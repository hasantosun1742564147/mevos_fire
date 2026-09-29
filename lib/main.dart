import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'l10n/app_localizations.dart';
import 'l10n/building_type_translations.dart';

final ValueNotifier<Locale?> _localeNotifier = ValueNotifier(null);
final Map<String, Map<String, String>> _buildingTypeNameCache = {};

String _binaGorunenAd(String value, AppLocalizations l10n) {
  final names = _buildingTypeNameCache.putIfAbsent(
    l10n.localeName,
    () => buildingTypeTranslations[l10n.localeName] ?? {},
  );
  return names[value] ?? value;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final savedLocale = prefs.getString('app_locale');
  _localeNotifier.value = Locale(
    savedLocale == 'en' || savedLocale == 'de' ? savedLocale! : 'tr',
  );
  runApp(const MevosFireApp());
}

Future<void> _setAppLocale(Locale locale) async {
  _localeNotifier.value = locale;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('app_locale', locale.languageCode);
}

class _DilSecici extends StatelessWidget {
  final Color? color;
  const _DilSecici({this.color});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PopupMenuButton<String>(
      tooltip: l10n.languageLabel,
      icon: Icon(Icons.language_rounded, color: color),
      onSelected: (value) => _setAppLocale(Locale(value)),
      itemBuilder: (context) => [
        PopupMenuItem(value: 'tr', child: Text('🇹🇷 ${l10n.turkish}')),
        PopupMenuItem(value: 'en', child: Text('🇬🇧 ${l10n.english}')),
        PopupMenuItem(value: 'de', child: Text('🇩🇪 ${l10n.german}')),
      ],
    );
  }
}

// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
// GEMINI API
// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦

// Google tarafında "high demand" (503 UNAVAILABLE) hataları sık ve genellikle
// geçicidir; bu yüzden birden fazla model + backoff ile yeniden deneniyor.
const _geminiModelZinciri = ['gemini-3.5-flash', 'gemini-3.5-flash-lite'];

Future<String> geminiChat({
  required String apiKey,
  required List<Map<String, String>> mesajlar,
  int maxTokens = 1024,
}) async {
  final sistemMesaj = mesajlar.where((m) => m['role'] == 'system').firstOrNull;
  final diger = mesajlar.where((m) => m['role'] != 'system').toList();
  final contents = diger.map((m) {
    final role = (m['role'] == 'assistant') ? 'model' : m['role']!;
    return {
      'role': role,
      'parts': [
        {'text': m['content']!},
      ],
    };
  }).toList();
  final body = <String, dynamic>{
    'contents': contents,
    'generationConfig': {'maxOutputTokens': maxTokens},
  };
  if (sistemMesaj != null) {
    body['system_instruction'] = {
      'parts': [
        {'text': sistemMesaj['content']!},
      ],
    };
  }

  Object? sonHata;
  for (final model in _geminiModelZinciri) {
    for (var deneme = 0; deneme < 3; deneme++) {
      late http.Response res;
      try {
        res = await http
            .post(
              Uri.parse(
                'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey',
              ),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(body),
            )
            .timeout(const Duration(seconds: 30));
      } on TimeoutException {
        throw Exception('Sunucuya bağlanılamadı. Bağlantınızı kontrol edin.');
      } catch (e) {
        throw Exception(
          'İnternet bağlantısı yok. Yapay zeka özelliği çevrimiçi bağlantı gerektirir.',
        );
      }

      if (res.statusCode == 200) {
        final d = jsonDecode(res.body) as Map<String, dynamic>;
        final candidates = d['candidates'] as List;
        final parts = candidates.first['content']['parts'] as List;
        return (parts.first['text'] as String).trim();
      } else if (res.statusCode == 401 || res.statusCode == 403) {
        throw Exception('Geçersiz API anahtarı. Lütfen güncelleyiniz.');
      } else if (res.statusCode == 503 || res.statusCode == 429) {
        // Geçici yoğunluk/kota hatası — kısa bekleyip yeniden dene,
        // olmazsa zincirdeki bir sonraki modele geç.
        sonHata = Exception(
          'Gemini hatası: ${res.statusCode} — model yoğun, yeniden deneniyor.',
        );
        await Future.delayed(Duration(milliseconds: 700 * (deneme + 1)));
        continue;
      } else {
        final d = jsonDecode(res.body) as Map<String, dynamic>;
        final msg = (d['error'] as Map?)?['message'] ?? res.statusCode.toString();
        throw Exception('Gemini hatası: $msg');
      }
    }
  }
  throw Exception(
    'Gemini şu anda yoğun, lütfen birkaç dakika sonra tekrar deneyin. (${sonHata ?? ''})',
  );
}

Future<String?> _geminiApiAl(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final mevcut = prefs.getString('gemini_api_key') ?? '';
  if (mevcut.isNotEmpty) return mevcut;
  if (!context.mounted) return null;
  return _geminiApiDiyaloguGoster(context, prefs);
}

Future<String?> _geminiApiDiyaloguGoster(
  BuildContext context,
  SharedPreferences prefs,
) async {
  if (!context.mounted) return null;
  final ctrl = TextEditingController();
  final result = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(AppLocalizations.of(context)!.apiKeyTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context).geminiApiKeyRequiredInfo,
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: const Icon(Icons.open_in_browser_rounded, size: 16),
            label: const Text(
              'aistudio.google.com/apikey',
              style: TextStyle(fontSize: 13),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF7C3AED),
              side: const BorderSide(color: Color(0xFF7C3AED)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () async {
              final uri = Uri.parse('https://aistudio.google.com/apikey');
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: ctrl,
            obscureText: true,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.apiKeyTitle,
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.key_rounded),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
          child: Text(AppLocalizations.of(context).save),
        ),
      ],
    ),
  );
  if (result != null && result.isNotEmpty) {
    await prefs.setString('gemini_api_key', result);
    return result;
  }
  return null;
}

// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
// APP ROOT
// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦

// API Base URL
const kApiBase = 'https://www.mevos.com.tr';
const kAppVersion = '2.0.0'; // güncelleme kontrolü için mevcut sürüm

void _cikisYap(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('jwt_token');
  if (context.mounted) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const GirisSayfasi()),
      (route) => false,
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// YANGINI MODÜLÜ AKTİF ABONELİK KONTROLÜ
// ────────────────────────────────────────────────────────────────────────────
bool hasActiveFirePerm(Map<String, dynamic> perms) {
  final v = perms['fire'];
  if (v == null || v == false || v == 'false') return false;
  if (v == 'omur') return true;
  if (v == 'yillik' || v == true || v == 'true') {
    final atStr = perms['fire_activatedAt']?.toString() ?? '';
    if (atStr.isEmpty) return false;
    final activated = DateTime.tryParse(atStr);
    if (activated == null) return false;
    return activated.add(const Duration(days: 365)).isAfter(DateTime.now());
  }
  return false;
}

// ────────────────────────────────────────────────────────────────────────────
// STARTUP EKRANI — Kaydedilmiş token kontrolü
// ────────────────────────────────────────────────────────────────────────────

class _StartupEkrani extends StatefulWidget {
  const _StartupEkrani();
  @override
  State<_StartupEkrani> createState() => _StartupEkraniState();
}

class _StartupEkraniState extends State<_StartupEkrani> {
  @override
  void initState() {
    super.initState();
    _tokenKontrol();
  }

  Future<void> _tokenKontrol() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null || token.isEmpty) {
      _girisEkranineGit();
      return;
    }
    try {
      final response = await http
          .get(
            Uri.parse('$kApiBase/api/auth/me.php'),
            headers: {'Authorization': 'Bearer $token'},
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final user = data['user'] as Map<String, dynamic>;
        final perms = (user['perms'] as Map<String, dynamic>?) ?? {};
        await prefs.setInt('is_premium', (user['is_premium'] as int?) ?? 0);
        await prefs.setString('user_name', (user['name'] as String?) ?? '');
        await prefs.setString('user_email', (user['email'] as String?) ?? '');
        await prefs.setString(
          'fire_perm',
          perms['fire']?.toString() ?? 'false',
        );
        await prefs.setString(
          'fire_perm_at',
          perms['fire_activatedAt']?.toString() ?? '',
        );
        if (hasActiveFirePerm(perms)) {
          _anaEkranaGit();
        } else {
          await prefs.remove('jwt_token');
          _girisEkranineGit();
        }
      } else if (response.statusCode == 401) {
        await prefs.remove('jwt_token');
        _girisEkranineGit();
      } else {
        _anaEkranaGit();
      }
    } on TimeoutException {
      // Çevrimdışı: önbellekteki fire iznini kullan
      final cachedPerm = prefs.getString('fire_perm') ?? 'false';
      final cachedAt = prefs.getString('fire_perm_at') ?? '';
      if (hasActiveFirePerm({
        'fire': cachedPerm,
        'fire_activatedAt': cachedAt,
      })) {
        _anaEkranaGit();
      } else {
        _girisEkranineGit();
      }
    } catch (_) {
      _girisEkranineGit();
    }
  }

  void _anaEkranaGit() {
    if (mounted) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const AnaSayfa()));
      _guncellemKontrol();
    }
  }

  Future<void> _guncellemKontrol() async {
    try {
      final res = await http
          .get(Uri.parse('$kApiBase/api/fire_version.php'))
          .timeout(const Duration(seconds: 8));
      if (res.statusCode != 200) return;
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final sunucuVersiyon = data['version'] as String? ?? '';
      final indirUrl = data['download_url'] as String? ?? '';
      if (sunucuVersiyon.isEmpty || !mounted) return;
      if (_versiyonKarsilastir(sunucuVersiyon, kAppVersion) > 0) {
        if (!mounted) return;
        final l10n = AppLocalizations.of(context);
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            title: Text(l10n.updateAvailableTitle),
            content: Text(l10n.updateAvailableMessage(sunucuVersiyon)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.updateLaterButton),
              ),
              FilledButton(
                onPressed: () async {
                  Navigator.pop(context);
                  if (indirUrl.isNotEmpty) {
                    await launchUrl(
                      Uri.parse(indirUrl),
                      mode: LaunchMode.externalApplication,
                    );
                  }
                },
                child: Text(l10n.updateNowButton),
              ),
            ],
          ),
        );
      }
    } catch (_) {}
  }

  /// Pozitif: a > b, negatif: a < b, 0: eşit
  int _versiyonKarsilastir(String a, String b) {
    final pa = a.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final pb = b.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    for (var i = 0; i < 3; i++) {
      final diff = (i < pa.length ? pa[i] : 0) - (i < pb.length ? pb[i] : 0);
      if (diff != 0) return diff;
    }
    return 0;
  }

  void _girisEkranineGit() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const GirisSayfasi()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF1C0000),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: Color(0xFFB91C1C),
              strokeWidth: 2.5,
            ),
            SizedBox(height: 24),
            Text(
              'MEVOS FIRE',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w800,
                letterSpacing: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MevosFireApp extends StatelessWidget {
  const MevosFireApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale?>(
      valueListenable: _localeNotifier,
      builder: (context, locale, _) => MaterialApp(
        title: 'MEVOS Fire',
        debugShowCheckedModeBanner: false,
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFB91C1C)),
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        home: const _StartupEkrani(),
      ),
    );
  }
}

// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
// GİRİŞ SAYFASI
// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦

class GirisSayfasi extends StatefulWidget {
  const GirisSayfasi({super.key});
  @override
  State<GirisSayfasi> createState() => _GirisSayfasiState();
}

class _GirisSayfasiState extends State<GirisSayfasi> {
  static const Color _kFire = Color(0xFFB91C1C);
  static const Color _kDark = Color(0xFF7F1D1D);

  final _emailCtrl = TextEditingController();
  final _sifreCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _yukleniyor = false;
  bool _sifreGizle = true;
  String? _hata;
  Timer? _rateLimitZamanlayici;
  int _rateLimitSaniye = 0;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _sifreCtrl.dispose();
    _rateLimitZamanlayici?.cancel();
    super.dispose();
  }

  String _sureFormatla(int saniye) {
    final dk = saniye ~/ 60;
    final sn = saniye % 60;
    return '${dk.toString().padLeft(2, '0')}:${sn.toString().padLeft(2, '0')}';
  }

  void _rateLimitBaslat(String mesaj) {
    final eslesme = RegExp(r'(\d+)\s*dakika').firstMatch(mesaj);
    if (eslesme == null) return;
    final dakika = int.tryParse(eslesme.group(1)!) ?? 0;
    if (dakika <= 0) return;
    _rateLimitZamanlayici?.cancel();
    setState(() => _rateLimitSaniye = dakika * 60);
    _rateLimitZamanlayici = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        if (_rateLimitSaniye <= 1) {
          _rateLimitSaniye = 0;
          _hata = null;
          t.cancel();
        } else {
          _rateLimitSaniye--;
        }
      });
    });
  }

  Future<void> _girisYap() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _yukleniyor = true;
      _hata = null;
    });

    try {
      final response = await http
          .post(
            Uri.parse('$kApiBase/api/auth/login.php'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': _emailCtrl.text.trim().toLowerCase(),
              'password': _sifreCtrl.text,
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final token = data['token'] as String;
        final user = data['user'] as Map<String, dynamic>;
        final perms = (user['perms'] as Map<String, dynamic>?) ?? {};
        debugPrint('LOGIN USER: ${jsonEncode(user)}');
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);
        await prefs.setString('user_name', (user['name'] as String?) ?? '');
        await prefs.setString('user_email', (user['email'] as String?) ?? '');
        await prefs.setInt('is_premium', (user['is_premium'] as int?) ?? 0);
        await prefs.setString(
          'fire_perm',
          perms['fire']?.toString() ?? 'false',
        );
        await prefs.setString(
          'fire_perm_at',
          perms['fire_activatedAt']?.toString() ?? '',
        );
        if (!hasActiveFirePerm(perms)) {
          setState(() {
            _hata = AppLocalizations.of(
              context,
            ).fireModuleSubscriptionMissing(jsonEncode(perms));
            _yukleniyor = false;
          });
          return;
        }
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const AnaSayfa()),
            (route) => false,
          );
        }
      } else {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final mesaj =
            (data['error'] as String?) ??
            AppLocalizations.of(context).loginFailed;
        setState(() {
          _hata = mesaj;
          _yukleniyor = false;
        });
        _rateLimitBaslat(mesaj);
      }
    } on TimeoutException {
      setState(() {
        _hata = AppLocalizations.of(context).loginServerUnreachable;
        _yukleniyor = false;
      });
    } catch (e, st) {
      debugPrint('LOGIN HATA: $e');
      debugPrint('STACK: $st');
      setState(() {
        _hata = AppLocalizations.of(context).genericErrorWithDetail('$e');
        _yukleniyor = false;
      });
    }
  }

  InputDecoration _inputDecor(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.white.withValues(alpha: 0.35),
        fontSize: 14,
      ),
      prefixIcon: Icon(icon, color: Colors.white54, size: 20),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFFCA5A5)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFFCA5A5), width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      errorStyle: const TextStyle(color: Color(0xFFFCA5A5), fontSize: 11),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_kFire, _kDark, Color(0xFF1C0000)],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: _DilSecici(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      // Logo
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/logo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Başlık
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          const Text(
                            'MEVOS ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Color(0xFFFF4500),
                                Color(0xFFFF8C00),
                                Color(0xFFFFD700),
                              ],
                            ).createShader(bounds),
                            child: const Text(
                              'Fire',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.loginSubtitle,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 28),
                      // E-posta
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecor(
                          l10n.emailAddress,
                          Icons.email_rounded,
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return l10n.emailRequired;
                          if (!v.contains('@')) return l10n.validEmailRequired;
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      // Şifre
                      TextFormField(
                        controller: _sifreCtrl,
                        obscureText: _sifreGizle,
                        style: const TextStyle(color: Colors.white),
                        decoration:
                            _inputDecor(
                              l10n.password,
                              Icons.lock_rounded,
                            ).copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _sifreGizle
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
                                  color: Colors.white54,
                                  size: 20,
                                ),
                                onPressed: () =>
                                    setState(() => _sifreGizle = !_sifreGizle),
                              ),
                            ),
                        validator: (v) => (v == null || v.isEmpty)
                            ? l10n.passwordRequired
                            : null,
                        onFieldSubmitted: (_) => _girisYap(),
                      ),
                      // Hata mesajı
                      if (_hata != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFFCA5A5,
                            ).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(
                                0xFFFCA5A5,
                              ).withValues(alpha: 0.4),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline_rounded,
                                color: Color(0xFFFCA5A5),
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _rateLimitSaniye > 0
                                      ? l10n.loginRateLimitMessage(
                                          _sureFormatla(_rateLimitSaniye),
                                        )
                                      : _hata!,
                                  style: const TextStyle(
                                    color: Color(0xFFFCA5A5),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      // Giriş butonu
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: (_yukleniyor || _rateLimitSaniye > 0)
                              ? null
                              : _girisYap,
                          icon: _yukleniyor
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: _kFire,
                                  ),
                                )
                              : const Icon(Icons.login_rounded, size: 20),
                          label: Text(
                            _yukleniyor
                                ? l10n.loggingIn
                                : _rateLimitSaniye > 0
                                ? _sureFormatla(_rateLimitSaniye)
                                : l10n.login,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: _kFire,
                            disabledBackgroundColor: Colors.white.withValues(
                              alpha: 0.5,
                            ),
                            disabledForegroundColor: _kFire.withValues(
                              alpha: 0.5,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Demo ile giriş
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const AnaSayfa(demoModu: true),
                                ),
                                (route) => false,
                              ),
                          icon: const Icon(
                            Icons.play_circle_outline_rounded,
                            size: 20,
                          ),
                          label: Text(
                            l10n.demoLogin,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: BorderSide(
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Kayıt linki
                      GestureDetector(
                        onTap: () => launchUrl(
                          Uri.parse(
                            'https://www.mevos.com.tr/pages/kayit.html',
                          ),
                          mode: LaunchMode.externalApplication,
                        ),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.55),
                            ),
                            children: [
                              TextSpan(text: l10n.accountPrompt),
                              TextSpan(
                                text: l10n.register,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white.withValues(
                                    alpha: 0.7,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.preliminaryToolDisclaimer,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.35),
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
// KAYITLI PROJELER
// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦

class _Proje {
  final String id, ad, modul, tarih, veri;
  const _Proje({
    required this.id,
    required this.ad,
    required this.modul,
    required this.tarih,
    this.veri = '',
  });
  Map<String, dynamic> toJson() => {
    'id': id,
    'ad': ad,
    'modul': modul,
    'tarih': tarih,
    'veri': veri,
  };
  factory _Proje.fromJson(Map<String, dynamic> j) => _Proje(
    id: j['id'] as String,
    ad: j['ad'] as String,
    modul: j['modul'] as String,
    tarih: j['tarih'] as String,
    veri: j['veri'] as String? ?? '',
  );
}

String _localizedProjectModule(AppLocalizations l10n, String module) =>
    switch (module) {
      'Yangın Yükü Hesabı' => l10n.fireLoadTitle,
      'Davlumbaz Söndürme' => l10n.kitchenSuppressionTitle,
      'Gazlı Söndürme Sistemi' => l10n.gasSuppressionTitle,
      'Lityum Pil Yangını' => l10n.lithiumFireTitle,
      'Sprinkler Sistemi' => l10n.sprinklerTitle,
      'Duman Algılama' => l10n.smokeDetectionTitle,
      'Duman Kontrolü' => l10n.smokeControlTitle,
      _ => module,
    };

class ProjeServisi {
  static const _key = 'kayitli_projeler_v1';
  static final hesapSinyali = ValueNotifier<bool>(false);
  static String hesapVeri = ''; // son hesap özeti — proje kaydında kullanılır
  static Map<String, String>? kayitliGirdiler; // yüklenen proje girdileri

  static Future<List<_Proje>> yukle() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw
        .map((s) => _Proje.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.tarih.compareTo(a.tarih));
  }

  static Future<void> kaydet(_Proje p) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    raw.add(jsonEncode(p.toJson()));
    await prefs.setStringList(_key, raw);
  }

  static Future<void> sil(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    raw.removeWhere((s) {
      final m = jsonDecode(s) as Map<String, dynamic>;
      return m['id'] == id;
    });
    await prefs.setStringList(_key, raw);
  }
}

class KayitliProjeler extends StatefulWidget {
  const KayitliProjeler({super.key});
  @override
  State<KayitliProjeler> createState() => _KayitliProjelerState();
}

class _KayitliProjelerState extends State<KayitliProjeler> {
  List<_Proje> _projeler = [];
  bool _yukleniyor = true;

  @override
  void initState() {
    super.initState();
    _yukle();
  }

  Future<void> _yukle() async {
    final list = await ProjeServisi.yukle();
    if (mounted)
      setState(() {
        _projeler = list;
        _yukleniyor = false;
      });
  }

  Future<void> _sil(_Proje p) async {
    final l10n = AppLocalizations.of(context);
    final onay = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteProjectTitle),
        content: Text(l10n.deleteProjectConfirm(p.ad)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (onay == true) {
      await ProjeServisi.sil(p.id);
      _yukle();
    }
  }

  void _ac(_Proje p) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => _ProjeDetaySayfasi(proje: p)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFFEF2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB91C1C),
        foregroundColor: Colors.white,
        title: Text(
          l10n.savedProjects,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: _yukleniyor
          ? const Center(child: CircularProgressIndicator())
          : _projeler.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.folder_open_rounded,
                    size: 64,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.noSavedProjects,
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _projeler.length,
              itemBuilder: (_, i) {
                final p = _projeler[i];
                final tarihStr = () {
                  try {
                    final dt = DateTime.parse(p.tarih);
                    return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}  ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
                  } catch (_) {
                    return p.tarih;
                  }
                }();
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.folder_rounded,
                      color: Color(0xFFB91C1C),
                    ),
                    title: Text(
                      p.ad,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      '${_localizedProjectModule(l10n, p.modul)}  ·  $tarihStr',
                      style: const TextStyle(fontSize: 11),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.red,
                      ),
                      onPressed: () => _sil(p),
                    ),
                    onTap: () => _ac(p),
                  ),
                );
              },
            ),
    );
  }
}

class _ProjeKaydetBant extends StatelessWidget {
  final String modulAdi;
  const _ProjeKaydetBant({required this.modulAdi});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.bookmark_border_rounded,
            size: 18,
            color: Color(0xFFB91C1C),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.saveProjectPrompt,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
          TextButton(
            onPressed: () => _kaydetDiyalog(context),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFB91C1C),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
            child: Text(
              l10n.save,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _kaydetDiyalog(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final ctrl = TextEditingController();
    final ad = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          l10n.saveProjectTitle,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: InputDecoration(
            labelText: l10n.projectName,
            hintText: l10n.projectNameExample,
            border: const OutlineInputBorder(),
            isDense: true,
          ),
          onSubmitted: (v) => Navigator.pop(ctx, v.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: Text(
              l10n.save,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
    if (ad == null || ad.isEmpty) return;
    final proje = _Proje(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      ad: ad,
      modul: modulAdi,
      tarih: DateTime.now().toIso8601String(),
      veri: ProjeServisi.hesapVeri,
    );
    await ProjeServisi.kaydet(proje);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.projectSaved(ad)),
          backgroundColor: const Color(0xFF15803D),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}

class _ProjeDetaySayfasi extends StatelessWidget {
  final _Proje proje;
  const _ProjeDetaySayfasi({required this.proje});

  static Widget? _modulSayfasi(String modul) => switch (modul) {
    'Yangın Yükü Hesabı' => const YanginYukuSayfasi(),
    'Davlumbaz Söndürme' => const DavlumbazSondurme(),
    'Gazlı Söndürme Sistemi' => const GazliSondurme(),
    'Lityum Pil Yangını' => const LityumPilYangini(),
    'Sprinkler Sistemi' => const SprinkleSistemi(),
    'Duman Algılama' => const DumanAlgilama(),
    'Duman Kontrolü' => const DumanKontrol(),
    _ => null,
  };

  String _formatTarih(String iso) {
    try {
      final d = DateTime.parse(iso);
      return '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
    } catch (_) {
      return iso;
    }
  }

  void _yenidenHesapla(BuildContext context) {
    final sayfa = _modulSayfasi(proje.modul);
    if (sayfa == null) return;
    // Kaydedilen girdileri aktarır
    if (proje.veri.startsWith('{')) {
      try {
        final j = jsonDecode(proje.veri) as Map<String, dynamic>;
        final inputs = j['i'];
        if (inputs is Map) {
          ProjeServisi.kayitliGirdiler = Map<String, String>.from(
            inputs.map((k, v) => MapEntry(k.toString(), v.toString())),
          );
        }
      } catch (_) {}
    }
    ProjeServisi.hesapSinyali.value = false;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFFB91C1C),
            foregroundColor: Colors.white,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  proje.ad,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  proje.modul,
                  style: const TextStyle(fontSize: 11, color: Colors.white70),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(child: sayfa),
              ValueListenableBuilder<bool>(
                valueListenable: ProjeServisi.hesapSinyali,
                builder: (_, val, __) => val
                    ? _ProjeKaydetBant(modulAdi: proje.modul)
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // JSON format ile geriye dönük uyum
    String resultsText = proje.veri;
    if (proje.veri.startsWith('{')) {
      try {
        final j = jsonDecode(proje.veri) as Map<String, dynamic>;
        resultsText = j['r'] as String? ?? proje.veri;
      } catch (_) {}
    }
    final satirlar = resultsText.isEmpty ? <String>[] : resultsText.split('\n');
    return Scaffold(
      backgroundColor: const Color(0xFFFEF2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB91C1C),
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              proje.ad,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              proje.modul,
              style: const TextStyle(fontSize: 11, color: Colors.white70),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tarih bilgisi
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_rounded,
                  size: 14,
                  color: Colors.black45,
                ),
                const SizedBox(width: 6),
                Text(
                  AppLocalizations.of(
                    context,
                  ).savedOnLabel(_formatTarih(proje.tarih)),
                  style: const TextStyle(fontSize: 12, color: Colors.black45),
                ),
              ],
            ),
            const SizedBox(height: 20),

            if (satirlar.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFFED7AA),
                    width: 1.5,
                  ),
                  boxShadow: const [
                    BoxShadow(color: Color(0x0F000000), blurRadius: 6),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.bookmark_rounded,
                          size: 18,
                          color: Color(0xFF92400E),
                        ),
                        SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.calculationResults,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF92400E),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 12),
                    ...satirlar.asMap().entries.map((entry) {
                      final satir = entry.value;
                      // Bölüm başlığı
                      if (satir.startsWith('## ')) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 4),
                          child: Text(
                            satir.substring(3),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0369A1),
                              letterSpacing: 0.3,
                            ),
                          ),
                        );
                      }
                      // Veri satırı
                      final parcalar = satir.split('  |  ');
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Wrap(
                          spacing: 20,
                          runSpacing: 4,
                          children: parcalar.map((p) {
                            final colonIdx = p.indexOf(': ');
                            if (colonIdx >= 0) {
                              final key = p.substring(0, colonIdx);
                              final value = p.substring(colonIdx + 2);
                              return RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '$key  ',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.black45,
                                      ),
                                    ),
                                    TextSpan(
                                      text: value,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF78350F),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return Text(
                              p,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  AppLocalizations.of(context)!.noSavedCalculationResult,
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
            ],

            if (_modulSayfasi(proje.modul) != null)
              ElevatedButton.icon(
                onPressed: () => _yenidenHesapla(context),
                icon: const Icon(Icons.calculate_rounded),
                label: Text(AppLocalizations.of(context)!.recalculate),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB91C1C),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(double.infinity, 0),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _KaydedilmisVeriPaneli extends StatefulWidget {
  final String veri;
  const _KaydedilmisVeriPaneli({required this.veri});
  @override
  State<_KaydedilmisVeriPaneli> createState() => _KaydedilmisVeriPaneliState();
}

class _KaydedilmisVeriPaneliState extends State<_KaydedilmisVeriPaneli> {
  bool _acik = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFF7ED),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _acik = !_acik),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.bookmark_rounded,
                    size: 16,
                    color: Color(0xFF92400E),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.savedValues,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF92400E),
                      ),
                    ),
                  ),
                  Icon(
                    _acik ? Icons.expand_less : Icons.expand_more,
                    size: 18,
                    color: const Color(0xFF92400E),
                  ),
                ],
              ),
            ),
          ),
          if (_acik)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Text(
                widget.veri,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF78350F),
                  height: 1.5,
                ),
              ),
            ),
          const Divider(height: 1),
        ],
      ),
    );
  }
}

// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
// ANA SAYFA
// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦

class AnaSayfa extends StatelessWidget {
  const AnaSayfa({super.key, this.demoModu = false});

  final bool demoModu;

  static const Color _kFire = Color(0xFFB91C1C);

  static Widget _appBarTitle(String? altBaslik) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipOval(
          child: Image.asset(
            'assets/logo.png',
            width: 26,
            height: 26,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            const Text(
              'MEVOS ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color(0xFFFF4500),
                  Color(0xFFFF8C00),
                  Color(0xFFFFD700),
                ],
                stops: [0.0, 0.5, 1.0],
              ).createShader(bounds),
              child: const Text(
                'Fire',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Color(0xFFFF4500),
                      blurRadius: 8,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (altBaslik != null) ...[
          const SizedBox(width: 8),
          Text('·', style: TextStyle(color: Colors.white54, fontSize: 16)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              altBaslik,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }

  void _git(BuildContext context, Widget sayfa, String baslik) {
    final l10n = AppLocalizations.of(context);
    ProjeServisi.hesapSinyali.value = false;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            backgroundColor: _kFire,
            foregroundColor: Colors.white,
            title: _appBarTitle(baslik),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout_rounded, color: Colors.white),
                tooltip: l10n.logout,
                onPressed: () => _cikisYap(context),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(child: sayfa),
              ValueListenableBuilder<bool>(
                valueListenable: ProjeServisi.hesapSinyali,
                builder: (_, val, __) => val
                    ? _ProjeKaydetBant(
                        modulAdi: _projeModulKimligi(sayfa, baslik),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _projeModulKimligi(Widget sayfa, String baslik) {
    if (sayfa is YanginYukuSayfasi) return 'Yangın Yükü Hesabı';
    if (sayfa is DavlumbazSondurme) return 'Davlumbaz Söndürme';
    if (sayfa is GazliSondurme) return 'Gazlı Söndürme Sistemi';
    if (sayfa is LityumPilYangini) return 'Lityum Pil Yangını';
    if (sayfa is SprinkleSistemi) return 'Sprinkler Sistemi';
    if (sayfa is DumanAlgilama) return 'Duman Algılama';
    if (sayfa is DumanKontrol) return 'Duman Kontrolü';
    return baslik;
  }

  // Demo modunda yalnızca Davlumbaz Söndürme serbest; diğerleri kayıt sayfasına yönlendirir.
  void _modulAc(
    BuildContext context, {
    required bool demoIzinli,
    required VoidCallback ac,
  }) {
    if (demoModu && !demoIzinli) {
      _surumYukseltUyarisiGoster(context);
    } else {
      ac();
    }
  }

  void _surumYukseltUyarisiGoster(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.upgradeRequiredTitle),
        content: Text(l10n.upgradeRequiredMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              launchUrl(
                Uri.parse('https://www.mevos.com.tr/pages/kayit.html'),
                mode: LaunchMode.externalApplication,
              );
            },
            child: Text(l10n.upgradeSignUpButton),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFFEF2F2),
      appBar: AppBar(
        backgroundColor: _kFire,
        foregroundColor: Colors.white,
        title: _appBarTitle(null),
        actions: [
          const _DilSecici(color: Colors.white),
          IconButton(
            icon: const Icon(Icons.settings_rounded, color: Colors.white),
            tooltip: l10n.settingsTitle,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ApiAyarlariSayfasi()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            tooltip: l10n.logout,
            onPressed: () => _cikisYap(context),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Text(
              'v2.0',
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Başlık bandı
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFB91C1C), Color(0xFF7F1D1D)],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.fireSafetyCalculator,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'EN 1991-1-2 · NFPA 17A · ISO 14520 · EN 12845',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ),
            if (demoModu) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFDBA74)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_rounded,
                      color: Color(0xFF9A3412),
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.demoMode,
                        style: TextStyle(
                          color: Color(0xFF9A3412),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),

            // Modül kartları
            _ModulKarti(
              baslik: l10n.fireLoadTitle,
              aciklama: l10n.fireLoadDescription,
              ikon: Icons.whatshot_rounded,
              renk: const Color(0xFF0F766E),
              onTap: () => _modulAc(
                context,
                demoIzinli: false,
                ac: () => _git(
                  context,
                  const YanginYukuSayfasi(),
                  l10n.fireLoadTitle,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _ModulKarti(
              baslik: l10n.kitchenSuppressionTitle,
              aciklama: l10n.kitchenSuppressionDescription,
              ikon: Icons.kitchen_rounded,
              renk: const Color(0xFF0369A1),
              onTap: () => _modulAc(
                context,
                demoIzinli: true,
                ac: () => _git(
                  context,
                  const DavlumbazSondurme(),
                  l10n.kitchenSuppressionTitle,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _ModulKarti(
              baslik: l10n.gasSuppressionTitle,
              aciklama: l10n.gasSuppressionDescription,
              ikon: Icons.cloud_rounded,
              renk: const Color(0xFF0891B2),
              onTap: () => _modulAc(
                context,
                demoIzinli: false,
                ac: () => _git(
                  context,
                  const GazliSondurme(),
                  l10n.gasSuppressionTitle,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _ModulKarti(
              baslik: l10n.lithiumFireTitle,
              aciklama: l10n.lithiumFireDescription,
              ikon: Icons.battery_charging_full_rounded,
              renk: const Color(0xFF7C3AED),
              onTap: () => _modulAc(
                context,
                demoIzinli: false,
                ac: () => _git(
                  context,
                  const LityumPilYangini(),
                  l10n.lithiumFireTitle,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _ModulKarti(
              baslik: l10n.sprinklerTitle,
              aciklama: l10n.sprinklerDescription,
              ikon: Icons.water_rounded,
              renk: const Color(0xFF0EA5E9),
              onTap: () => _modulAc(
                context,
                demoIzinli: false,
                ac: () =>
                    _git(context, const SprinkleSistemi(), l10n.sprinklerTitle),
              ),
            ),
            const SizedBox(height: 12),
            _ModulKarti(
              baslik: l10n.smokeDetectionTitle,
              aciklama: l10n.smokeDetectionDescription,
              ikon: Icons.sensors_rounded,
              renk: const Color(0xFF7C2D12),
              onTap: () => _modulAc(
                context,
                demoIzinli: false,
                ac: () => _git(
                  context,
                  const DumanAlgilama(),
                  l10n.smokeDetectionTitle,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _ModulKarti(
              baslik: l10n.smokeControlTitle,
              aciklama: l10n.smokeControlDescription,
              ikon: Icons.air_rounded,
              renk: const Color(0xFF374151),

              onTap: () => _modulAc(
                context,
                demoIzinli: false,
                ac: () =>
                    _git(context, const DumanKontrol(), l10n.smokeControlTitle),
              ),
            ),
            const SizedBox(height: 12),
            _ModulKarti(
              baslik: l10n.standardSearch,
              aciklama: l10n.standardSearchDescription,
              ikon: Icons.search_rounded,
              renk: const Color(0xFF065F46),
              onTap: () => _modulAc(
                context,
                demoIzinli: false,
                ac: () =>
                    _git(context, const StandartArama(), l10n.standardSearch),
              ),
            ),
            const SizedBox(height: 12),
            _ModulKarti(
              baslik: l10n.standardGuide,
              aciklama: l10n.standardGuideDescription,
              ikon: Icons.menu_book_rounded,
              renk: const Color(0xFF6D28D9),
              onTap: () => _modulAc(
                context,
                demoIzinli: false,
                ac: () {
                  final rehberKey = GlobalKey<_StandartRehberiState>();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Scaffold(
                        appBar: AppBar(
                          backgroundColor: _kFire,
                          foregroundColor: Colors.white,
                          title: _appBarTitle(l10n.standardGuide),
                          actions: [
                            TextButton.icon(
                              onPressed: () => rehberKey.currentState
                                  ?._ozelStandartEkleDiyalogu(),
                              icon: const Icon(
                                Icons.add_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                              label: Text(
                                l10n.addStandard,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.logout_rounded,
                                color: Colors.white,
                              ),
                              tooltip: l10n.logout,
                              onPressed: () => _cikisYap(context),
                            ),
                          ],
                        ),
                        body: StandartRehberi(key: rehberKey),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            _ModulKarti(
              baslik: l10n.savedProjects,
              aciklama: l10n.savedProjectsDescription,
              ikon: Icons.folder_rounded,
              renk: const Color(0xFF92400E),
              onTap: () => _modulAc(
                context,
                demoIzinli: false,
                ac: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const KayitliProjeler()),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.moduleDisclaimer,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: Colors.black38),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModulKarti extends StatelessWidget {
  final String baslik;
  final String aciklama;
  final IconData ikon;
  final Color renk;
  final VoidCallback onTap;

  const _ModulKarti({
    required this.baslik,
    required this.aciklama,
    required this.ikon,
    required this.renk,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      elevation: 2,
      shadowColor: renk.withOpacity(0.2),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: renk.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(ikon, color: renk, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      baslik,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: renk,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      aciklama,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: renk.withOpacity(0.5)),
            ],
          ),
        ),
      ),
    );
  }
}

// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
// YANGIN YÜKÜ & SÖNDÜRME
// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦

class YanginYukuSayfasi extends StatefulWidget {
  const YanginYukuSayfasi({super.key});

  @override
  State<YanginYukuSayfasi> createState() => _YanginYukuState();
}

class _YanginYukuState extends State<YanginYukuSayfasi> {
  static const Color _kC = Color(0xFF0F766E);

  // ¦¦ Mod
  _Mod _mod = _Mod.bina;

  // ¦¦ Bina modu
  final _alanCtrl = TextEditingController();
  final _basincCtrl = TextEditingController(text: '4');
  final _binaAraCtrl = TextEditingController();
  final List<_Malzeme> _malzemeler = [
    _Malzeme(ad: 'Ahşap / Kereste', kg: 0, ncv: 17.5),
  ];
  String? _secilenBina;

  // ¦¦ Yakıt / Kimyasal Depo modu
  final _depoAlanCtrl = TextEditingController();
  final List<_Depo> _depolar = [
    _Depo(tur: 'LPG (Sıvılaştırılmış)', miktar: 0, birim: 'ton'),
  ];

  static const Map<String, _YakitSpec> _yakitVerisi = {
    'LPG (Sıvılaştırılmış)': _YakitSpec(46.4, 0.55, sinifC: true),
    'Benzin': _YakitSpec(44.0, 0.74),
    'Motorin / Dizel': _YakitSpec(42.5, 0.84),
    'Fuel Oil (Akaryakıt)': _YakitSpec(40.0, 0.85),
    'Jet Yakıtı / Kerozen': _YakitSpec(43.0, 0.80),
    'Ham Petrol': _YakitSpec(44.0, 0.85),
    'Madeni Yağ': _YakitSpec(42.0, 0.87),
    'Metanol': _YakitSpec(19.9, 0.79),
    'Etanol': _YakitSpec(26.8, 0.79),
    'Tiner / Solvent': _YakitSpec(33.0, 0.87),
  };

  // Sık kullanılan tank kapasiteleri (birim: ton veya m³)
  static const Map<String, List<double>> _kapasiteOneri = {
    'LPG (Sıvılaştırılmış)': [0.5, 1, 2, 5, 10, 20, 30, 50, 100, 250],
    'Benzin': [5, 10, 20, 30, 50, 100, 200],
    'Motorin / Dizel': [5, 10, 15, 20, 30, 50, 100, 200],
    'Fuel Oil (Akaryakıt)': [5, 10, 20, 50, 100, 250],
    'Jet Yakıtı / Kerozen': [5, 10, 20, 50, 100],
    'Ham Petrol': [10, 50, 100, 500, 1000],
    'Madeni Yağ': [1, 2, 5, 10, 20, 50],
    'Metanol': [5, 10, 20, 50, 100],
    'Etanol': [5, 10, 20, 50, 100],
    'Tiner / Solvent': [1, 2, 5, 10, 20, 50],
  };

  // Varsayılan birim (LPG → ton, sıvılar → m³)
  static String _varsayilanBirim(String tur) =>
      tur.contains('LPG') ? 'ton' : 'm³';

  // ¦¦ Pano modu
  final _pWCtrl = TextEditingController();
  final _pHCtrl = TextEditingController();
  final _pDCtrl = TextEditingController();
  String _pKablo = 'PVC';
  double _pDolum = 0.35;

  // ¦¦ Sonuç (ateş yükü)
  double? _toplamMJ, _yogunluk;
  String? _riskSinifi, _hata;
  Color? _riskRenk;
  double? _tBuyume, _tSabit, _tToplam, _qPik;
  String? _sinirlayanFaktor;

  // ¦¦ Büyüme hızı (manuel seçim veya _e5'ten otomatik)
  String _buyumeHiz = 'Orta'; // varsayılan

  // ¦¦ Havalandırma sınırlı Q_max (opsiyonel)
  bool _havaGoster = false;
  final _avCtrl = TextEditingController();
  final _heqCtrl = TextEditingController();
  static const Map<String, _BuyumeVeri> _buyumeSpec = {
    'Çok Yavaş': _BuyumeVeri('Çok Yavaş', 600, 250),
    'Yavaş': _BuyumeVeri('Yavaş', 400, 250),
    'Orta': _BuyumeVeri('Orta', 300, 250),
    'Hızlı': _BuyumeVeri('Hızlı', 150, 500),
    'Çok Hızlı': _BuyumeVeri('Çok Hızlı', 75, 1000),
  };

  // ¦¦ TS EN 3-7 Taşınabilir Söndürücü Sonuçları
  static const double _kktKg = 6.0; // sabit 6 kg KKT
  String? _en37BeyanA, _en37BeyanB;
  int? _en37SayiA, _en37SayiB;
  int? _en37SayiAlanA, _en37SayiAlanB;
  int? _en37SayiEnerjiA, _en37SayiEnerjiB;
  double? _en37KapasiteA, _en37KapasiteB;
  String? _en37KktA, _en37KktB;
  String? _yanginSinifiAciklama;

  // Sınıf B: B-değeri × 6.1 MJ (heptan eşdeğeri, %30 verimlilik)
  static double _bKapasite(String beyan) {
    final n = double.tryParse(beyan.replaceAll('B', '')) ?? 21;
    return n * 6.1;
  }

  static _En37Sonuc _en37Hesapla(double yon, double alan, double toplamMJ) {
    // 6 kg KKT sabit → spec tablosundan al
    const spec = _KktSpec(
      beyanA: '34A',
      beyanB: '113B',
      kapA: 480.0,
      kapB: 689.0,
    );
    final String beyanA = spec.beyanA;
    final String beyanB = spec.beyanB;
    final double kapA = spec.kapA;
    final double kapB = spec.kapB;
    const String kktA = '6 kg';
    const String kktB = '6 kg';
    // Alan bazlı sayı: BYKHY
    final bool dusukTehlike = yon <= 200;
    final double alanBasina = dusukTehlike ? 500.0 : 250.0;
    final int kAlan = ((alan / alanBasina).ceil()).clamp(2, 9999);
    // Enerji bazlı sayı
    final int kEnerjiA = toplamMJ <= 0
        ? 0
        : (toplamMJ / kapA).ceil().clamp(1, 9999);
    final int kEnerjiB = toplamMJ <= 0
        ? 0
        : (toplamMJ / kapB).ceil().clamp(1, 9999);
    return _En37Sonuc(
      beyanA: beyanA,
      beyanB: beyanB,
      kktA: kktA,
      kktB: kktB,
      sayi: kAlan,
      sayiEnerjiA: kEnerjiA,
      sayiEnerjiB: kEnerjiB,
      kapasiteA: kapA,
      kapasiteB: kapB,
    );
  }

  // ¦¦ Söndürme
  static const List<_SondAjan> _ajanlar = [
    _SondAjan(
      ad: 'CO² (Karbondioksit)',
      standart: 'TS EN 15004-2 / NFPA 12',
      spesifik: 0.5685,
      konsan: 34.0,
      inert: false,
      aciklama:
          'Sınıf B/C: %34 (min). Sınıf A derin oturmuş yangınlar: %50 (min). İnsan bulunmayan hacimler.',
    ),
    _SondAjan(
      ad: 'HFC-227ea (FM-200)',
      standart: 'TS EN 15004-5:2020 / NFPA 2001',
      spesifik: 0.1374, // @20°C: S = 0.1269 + 0.000513×20 (Tablo 2)
      konsan: 7.9, // Yüzey A min. %7,9; Derin A min. %8,5 (Tablo 4)
      inert: false,
      aciklama: 'Katı, sıvı, gaz yangınları. Elektrik donanım odaları.',
    ),
    _SondAjan(
      ad: 'FK-5-1-12 (Novec 1230)',
      standart: 'TS EN 15004-6 / NFPA 2001',
      spesifik: 0.0664,
      konsan: 4.2,
      inert: false,
      aciklama: 'Düşük GWP. Hassas ekipman odaları.',
    ),
    _SondAjan(
      ad: 'IG-541 (Inergen)',
      standart: 'TS EN 15004-9 / NFPA 2001',
      spesifik: 0.6575,
      konsan: 38.5,
      inert: true,
      aciklama: 'N²/Ar/CO² karışımı. Şiseden Nm³ olarak verilir.',
    ),
    _SondAjan(
      ad: 'IG-55 (Argonite)',
      standart: 'TS EN 15004-10 / NFPA 2001',
      spesifik: 0.6888,
      konsan: 38.5,
      inert: true,
      aciklama: 'N²/Ar karışımı. Şiseden Nm³ olarak verilir.',
    ),
    _SondAjan(
      ad: 'ABC Kuru Kimyevi Toz',
      standart: 'NFPA 17 / TS EN 615',
      spesifik: null,
      konsan: 0,
      inert: false,
      aciklama: 'Toplam taşkın tahmini: 0.5 kg/m³.',
    ),
  ];

  final _sYuksCtrl = TextEditingController();
  final _sRakimCtrl = TextEditingController();
  final _sKonsanCtrl = TextEditingController(text: '7.9'); // default: FM-200
  bool _sRakimGoster = false;
  int _sAjanIdx = 1;
  String? _sHata;
  double? _sAjanMiktar, _sSilindirSayisi;

  // ¦¦ Referans yoğunluklar (EN 1991-1-2 E.4)
  static const Map<String, double> _refYog = {
    'Konut (ortalama)': 948,
    'Ofis (genel)': 511,
    'Okul / Sınıf': 347,
    'Otel Odası': 377,
    'Hastane Odası': 280,
    'Kütüphane (genel)': 1824,
    'Alışveriş Merkezi': 730,
    'Sinema / Tiyatro': 365,
    'Depo (hafif)': 1000,
    'Depo (orta)': 1500,
    'Depo (ağır)': 3000,
    'Sunucu Odası (orta)': 2000,
    'Sunucu Odası (yoğun)': 3500,
    'Elektrik Panosu Odası (PVC)': 1500,
    'Elektrik Panosu Odası (XLPE)': 1200,
    'MCC Odası': 1200,
    'Hücre Odası (OG Şalt)': 1000,
    'Trafo Odası (kuru tip)': 600,
    'Trafo Odası (yağlı)': 2000,
    'UPS Odası': 800,
    'Arşiv Odası (kâğıt)': 3000,
    'Kapalı Otopark': 730,
    // ── BYKHY Madde 9 · Konutlar ──
    'Tek/İki Ailelik Ev': 800,
    'Apartman Dairesi': 948,
    // ── BYKHY Madde 10 · Konaklama ──
    'Motel / Pansiyon': 377,
    'Öğrenci Yurdu / Yatakhane': 400,
    'Tatil Köyü / Kamping': 300,
    // ── BYKHY Madde 11 · Kurumsal ──
    'Kreş / Anaokulu': 280,
    'Yükseköğretim Kurumu': 400,
    'Huzurevi / Bakımevi': 280,
    'Cezaevi / Tutukevi': 280,
    // ── BYKHY Madde 12 · Büro ──
    'Banka / Borsa': 511,
    'Kamu Hizmet Binası': 511,
    'Muayenehane / Klinik': 350,
    // ── BYKHY Madde 13 · Ticaret ──
    'Dükkân / Mağaza (küçük)': 600,
    'Süpermarket / Market': 730,
    'Toptancı Sitesi / Toptancı Hal': 800,
    'Tamirhane / Yedek Parça': 500,
    // ── BYKHY Madde 14 · Endüstriyel ──
    'Fabrika / İmalathane (hafif-OT1)': 420,
    'Fabrika / İmalathane (orta-OT2)': 800,
    'Atölye / Montaj': 600,
    'Gıda İşleme Tesisi': 500,
    'Tekstil Fabrikası': 800,
    // ── BYKHY Madde 15 · Toplanma ──
    'Lokanta / Restoran': 250,
    'Kafe / Kahvehane': 250,
    'Bar / Gece Kulübü': 300,
    'Müze / Sergi Salonu': 500,
    'İbadethane (Cami, Kilise vb.)': 300,
    'Kapalı Spor Salonu': 200,
    'Terminal / Gar / İstasyon': 300,
    'Havalimanı (terminal binası)': 400,
    // ── BYKHY Madde 16 · Depolama ──
    'Silo / Tahıl Deposu': 2000,
    'Antrepo / Ambar': 1500,
    // ── BYKHY Madde 17 · Yüksek Tehlikeli ──
    'LPG Depolama Tesisi': 3000,
    'Akaryakıt Servis İstasyonu': 3500,
    'Patlayıcı Madde Deposu': 4000,
  };

  // BYKHY Ek-1 Tehlike Sınıfı (Md. 19)
  // 'D' = Düşük Tehlike (Ek-1/A)
  // 'O' = Orta Tehlike  (Ek-1/B, OT-1 … OT-4)
  // 'Y' = Yüksek Tehlike (Ek-1/C, YT-1 … YT-4)
  static const Map<String, String> _ek1TehlikeSinifi = {
    // ── Ek-1/A  Düşük Tehlike ─────────────────────────────────────────
    // Düşük yangın yüküne sahip, en az 30 dk yangına dayanıklı,
    // 126 m²'den büyük bölümü olmayan mekânlar
    'Okul / Sınıf': 'D', // eğitim tesisleri (belirli alanlar)
    'Kreş / Anaokulu': 'D',
    'Yükseköğretim Kurumu': 'D',
    'Ofis (genel)': 'D', // bürolar (belirli alanlar)
    'Banka / Borsa': 'D',
    'Kamu Hizmet Binası': 'D',
    'Cezaevi / Tutukevi': 'D', // hapishaneler
    // ── Ek-1/B  Orta Tehlike-1 ────────────────────────────────────────
    'Konut (ortalama)': 'O',
    'Tek/İki Ailelik Ev': 'O',
    'Apartman Dairesi': 'O',
    'Otel Odası': 'O',
    'Motel / Pansiyon': 'O',
    'Öğrenci Yurdu / Yatakhane': 'O',
    'Tatil Köyü / Kamping': 'O',
    'Hastane Odası': 'O',
    'Huzurevi / Bakımevi': 'O',
    'Muayenehane / Klinik': 'O',
    'Lokanta / Restoran': 'O',
    'Kafe / Kahvehane': 'O',
    'Kütüphane (genel)': 'O', // kitap depoları hariç
    'Fabrika / İmalathane (hafif-OT1)': 'O',

    // ── Ek-1/B  Orta Tehlike-2 ────────────────────────────────────────
    'Kapalı Otopark': 'O', // otoparklar, müzeler
    'Müze / Sergi Salonu': 'O',
    'Atölye / Montaj': 'O',
    'Tamirhane / Yedek Parça': 'O',
    'Fabrika / İmalathane (orta-OT2)': 'O',
    'Gıda İşleme Tesisi': 'O',
    'UPS Odası': 'O',
    'Sunucu Odası (orta)': 'O',
    'Sunucu Odası (yoğun)': 'O',
    'Elektrik Panosu Odası (PVC)': 'O',
    'Elektrik Panosu Odası (XLPE)': 'O',

    // ── Ek-1/B  Orta Tehlike-3 ────────────────────────────────────────
    'Terminal / Gar / İstasyon': 'O',
    'Havalimanı (terminal binası)': 'O',
    'Alışveriş Merkezi': 'O', // büyük mağazalar, AVM
    'Süpermarket / Market': 'O',
    'Dükkân / Mağaza (küçük)': 'O',
    'Toptancı Sitesi / Toptancı Hal': 'O',
    'Tekstil Fabrikası': 'O',
    // Depolama − BYKHY Md. 16 → min. Orta tehlike
    'Depo (hafif)': 'O',
    'Depo (orta)': 'O',
    'Depo (ağır)': 'O',
    'Silo / Tahıl Deposu': 'O',
    'Antrepo / Ambar': 'O',
    'Arşiv Odası (kâğıt)': 'O',

    // ── Ek-1/B  Orta Tehlike-4 ────────────────────────────────────────
    'Sinema / Tiyatro': 'O',
    'Bar / Gece Kulübü': 'O',
    'Kapalı Spor Salonu': 'O',
    'İbadethane (Cami, Kilise vb.)': 'O',

    // ── Ek-1/C  Yüksek Tehlike ────────────────────────────────────────
    // BYKHY Md. 17 – parlayıcı/patlayıcı/akaryakıt tesisleri
    'LPG Depolama Tesisi': 'Y', // YT-1
    'Akaryakıt Servis İstasyonu': 'Y', // YT-1
    'Patlayıcı Madde Deposu': 'Y', // YT-4
    'MCC Odası': 'O',
    'Hücre Odası (OG Şalt)': 'O',
    'Trafo Odası (kuru tip)': 'O',
    'Trafo Odası (yağlı)': 'Y',
  };

  // Referans değer kaynakları
  static const Map<String, String> _refKaynak = {
    'Konut (ortalama)': 'EN 1991-1-2 Ek E, Tablo E.4',
    'Ofis (genel)': 'EN 1991-1-2 Ek E, Tablo E.4',
    'Okul / Sınıf': 'EN 1991-1-2 Ek E, Tablo E.4',
    'Otel Odası': 'EN 1991-1-2 Ek E, Tablo E.4',
    'Hastane Odası': 'EN 1991-1-2 Ek E, Tablo E.4',
    'Kütüphane (genel)': 'EN 1991-1-2 Ek E, Tablo E.4',
    'Alışveriş Merkezi': 'EN 1991-1-2 Ek E, Tablo E.4',
    'Sinema / Tiyatro': 'EN 1991-1-2 Ek E, Tablo E.4',
    'Depo (hafif)': 'EN 1991-1-2 Ek E, Tablo E.4',
    'Depo (orta)': 'EN 1991-1-2 Ek E, Tablo E.4',
    'Depo (ağır)': 'EN 1991-1-2 Ek E, Tablo E.4',
    'Sunucu Odası (orta)': 'NFPA 75 / IEC 60950',
    'Sunucu Odası (yoğun)': 'NFPA 75 / IEC 60950',
    'Elektrik Panosu Odası (PVC)': 'IEC 60332 / EN 1991-1-2',
    'Elektrik Panosu Odası (XLPE)': 'IEC 60332 / EN 1991-1-2',
    'MCC Odası': 'IEC 60332 / EN 1991-1-2',
    'Hücre Odası (OG Şalt)': 'IEC 60332 / EN 1991-1-2',
    'Trafo Odası (kuru tip)': 'IEC 60076 / EN 1991-1-2',
    'Trafo Odası (yağlı)': 'IEC 60076 / NFPA 15',
    'UPS Odası': 'NFPA 75 / EN 1991-1-2',
    'Arşiv Odası (kâğıt)': 'EN 1991-1-2 Ek E, Tablo E.4',
    'Kapalı Otopark': 'EN 1991-1-2 Ek E, Tablo E.4',
    // BYKHY Madde 9
    'Tek/İki Ailelik Ev': 'BYKHY Md.9 / EN 1991-1-2 E.4',
    'Apartman Dairesi': 'BYKHY Md.9 / EN 1991-1-2 E.4',
    // BYKHY Madde 10
    'Motel / Pansiyon': 'BYKHY Md.10 / EN 1991-1-2 E.4',
    'Öğrenci Yurdu / Yatakhane': 'BYKHY Md.10 / EN 1991-1-2 E.4',
    'Tatil Köyü / Kamping': 'BYKHY Md.10',
    // BYKHY Madde 11
    'Kreş / Anaokulu': 'BYKHY Md.11 / EN 1991-1-2 E.4',
    'Yükseköğretim Kurumu': 'BYKHY Md.11 / EN 1991-1-2 E.4',
    'Huzurevi / Bakımevi': 'BYKHY Md.11 / EN 1991-1-2 E.4',
    'Cezaevi / Tutukevi': 'BYKHY Md.11',
    // BYKHY Madde 12
    'Banka / Borsa': 'BYKHY Md.12 / EN 1991-1-2 E.4',
    'Kamu Hizmet Binası': 'BYKHY Md.12 / EN 1991-1-2 E.4',
    'Muayenehane / Klinik': 'BYKHY Md.12',
    // BYKHY Madde 13
    'Dükkân / Mağaza (küçük)': 'BYKHY Md.13 / EN 1991-1-2 E.4',
    'Süpermarket / Market': 'BYKHY Md.13 / EN 1991-1-2 E.4',
    'Toptancı Sitesi / Toptancı Hal': 'BYKHY Md.13',
    'Tamirhane / Yedek Parça': 'BYKHY Md.13',
    // BYKHY Madde 14
    'Fabrika / İmalathane (hafif-OT1)': 'BYKHY Md.14 / Ek-1/B OT-1',
    'Fabrika / İmalathane (orta-OT2)': 'BYKHY Md.14 / Ek-1/B OT-2',
    'Atölye / Montaj': 'BYKHY Md.14 / Ek-1/B OT-2',
    'Gıda İşleme Tesisi': 'BYKHY Md.14 / Ek-1/B OT-2',
    'Tekstil Fabrikası': 'BYKHY Md.14 / Ek-1/B OT-3',
    // BYKHY Madde 15
    'Lokanta / Restoran': 'BYKHY Md.15 / EN 1991-1-2 E.4',
    'Kafe / Kahvehane': 'BYKHY Md.15',
    'Bar / Gece Kulübü': 'BYKHY Md.15',
    'Müze / Sergi Salonu': 'BYKHY Md.15 / EN 1991-1-2 E.4',
    'İbadethane (Cami, Kilise vb.)': 'BYKHY Md.15',
    'Kapalı Spor Salonu': 'BYKHY Md.15',
    'Terminal / Gar / İstasyon': 'BYKHY Md.15 / Ek-1/B OT-1',
    'Havalimanı (terminal binası)': 'BYKHY Md.15',
    // BYKHY Madde 16
    'Silo / Tahıl Deposu': 'BYKHY Md.16',
    'Antrepo / Ambar': 'BYKHY Md.16 / EN 1991-1-2 E.4',
    // BYKHY Madde 17
    'LPG Depolama Tesisi': 'BYKHY Md.17 / Ek-1/C YT-1',
    'Akaryakıt Servis İstasyonu': 'BYKHY Md.17 / Ek-1/C YT-2',
    'Patlayıcı Madde Deposu': 'BYKHY Md.17 / Ek-1/C YT-4',
  };

  // ¦¦ E.5 büyüme verileri
  static const Map<String, _BuyumeVeri> _e5 = {
    'Konut (ortalama)': _BuyumeVeri('Orta', 300, 250),
    'Ofis (genel)': _BuyumeVeri('Orta', 300, 250),
    'Okul / Sınıf': _BuyumeVeri('Orta', 300, 250),
    'Otel Odası': _BuyumeVeri('Orta', 300, 250),
    'Kütüphane (genel)': _BuyumeVeri('Hızlı', 150, 500),
    'Alışveriş Merkezi': _BuyumeVeri('Hızlı', 150, 250),
    'Sinema / Tiyatro': _BuyumeVeri('Hızlı', 150, 500),
    'Sunucu Odası (orta)': _BuyumeVeri('Hızlı', 150, 500),
    'Sunucu Odası (yoğun)': _BuyumeVeri('Hızlı', 150, 500),
    'Elektrik Panosu Odası (PVC)': _BuyumeVeri('Orta', 300, 250),
    'Elektrik Panosu Odası (XLPE)': _BuyumeVeri('Orta', 300, 250),
    'MCC Odası': _BuyumeVeri('Hızlı', 150, 500),
    'Hücre Odası (OG Şalt)': _BuyumeVeri('Orta', 300, 250),
    'Trafo Odası (kuru tip)': _BuyumeVeri('Orta', 300, 250),
    'Trafo Odası (yağlı)': _BuyumeVeri('Çok Hızlı', 75, 1000),
    'Arşiv Odası (kâğıt)': _BuyumeVeri('Hızlı', 150, 500),
    // BYKHY eklemeleri
    'Tek/İki Ailelik Ev': _BuyumeVeri('Orta', 300, 250),
    'Apartman Dairesi': _BuyumeVeri('Orta', 300, 250),
    'Motel / Pansiyon': _BuyumeVeri('Orta', 300, 250),
    'Öğrenci Yurdu / Yatakhane': _BuyumeVeri('Orta', 300, 250),
    'Kreş / Anaokulu': _BuyumeVeri('Orta', 300, 250),
    'Yükseköğretim Kurumu': _BuyumeVeri('Orta', 300, 250),
    'Huzurevi / Bakımevi': _BuyumeVeri('Orta', 300, 250),
    'Banka / Borsa': _BuyumeVeri('Orta', 300, 250),
    'Kamu Hizmet Binası': _BuyumeVeri('Orta', 300, 250),
    'Süpermarket / Market': _BuyumeVeri('Hızlı', 150, 250),
    'Fabrika / İmalathane (hafif-OT1)': _BuyumeVeri('Orta', 300, 250),
    'Fabrika / İmalathane (orta-OT2)': _BuyumeVeri('Hızlı', 150, 500),
    'Tekstil Fabrikası': _BuyumeVeri('Hızlı', 150, 500),
    'Lokanta / Restoran': _BuyumeVeri('Orta', 300, 250),
    'Müze / Sergi Salonu': _BuyumeVeri('Orta', 300, 250),
    'LPG Depolama Tesisi': _BuyumeVeri('Çok Hızlı', 75, 1000),
    'Akaryakıt Servis İstasyonu': _BuyumeVeri('Çok Hızlı', 75, 1000),
  };

  // ¦¦ NCV tablosu (EN 1991-1-2 E.3 / ISO 1716 — teorik; PMMA/PP/ABS: ISO 5660-1
  // koni kalorimetre @25 kW/m² etkin yanma ısısı, EN 15004-1 Ek C Tablo C.2;
  // diğer sıvı/karma malzemeler: SFPE Yangın Koruma Mühendisliği El Kitabı tipik değerleri)
  static const Map<String, double> _ncv = {
    'Ahşap / Kereste': 17.5,
    'Kontrplak / MDF': 17.0,
    'Kâğıt / Karton': 20.0,
    'Tekstil (pamuklu)': 20.0,
    'Tekstil (sentetik)': 30.0,
    'Yün': 20.0,
    'Giysi': 20.0,
    'Deri': 20.0,
    'Polietilen (PE)': 40.0,
    'Polipropilen (PP)': 39.6,
    'PVC (sert)': 20.0,
    'PVC (esnek/kablo)': 22.0,
    'Polistiren (PS)': 40.0,
    'EPS köpük': 38.0,
    'XPS köpük': 38.5,
    'ABS Plastik': 29.1,
    'PMMA (Pleksiglas)': 23.3,
    'Epoksi Reçine': 30.0,
    'Polyester Reçine (CTP/FRP)': 30.0,
    'Poliüretan köpük (sert)': 25.0,
    'Poliüretan köpük (esnek)': 23.0,
    'Kauçuk (doğal)': 44.5,
    'Lastik (araç)': 30.0,
    'Benzin': 45.0,
    'Dizel': 45.0,
    'LPG': 46.4,
    'Propan': 46.3,
    'Doğalgaz (CNG)': 50.0,
    'Metanol': 20.0,
    'Etanol': 26.8,
    'Aseton / Solvent (genel)': 29.0,
    'Boya / Vernik (solventli)': 30.0,
    'Asfalt / Bitüm': 40.0,
    'Kömür': 30.0,
    'Trafo Yağı (mineral)': 41.9,
    'Hidrolik Yağ': 42.0,
    'Elektrik Kablosu (PVC)': 22.0,
    'Elektrik Kablosu (XLPE)': 32.0,
    'Li-ion Batarya': 10.0,
    'Mobilya (karma)': 20.0,
    'Diğer (manuel)': 0.0,
  };

  // Fiziksel hal: 'K' = Katı, 'S' = Sıvı, 'G' = Gaz, 'D' = Diğer (manuel)
  static const Map<String, String> _malzemeKategori = {
    'Ahşap / Kereste': 'K',
    'Kontrplak / MDF': 'K',
    'Kâğıt / Karton': 'K',
    'Tekstil (pamuklu)': 'K',
    'Tekstil (sentetik)': 'K',
    'Yün': 'K',
    'Giysi': 'K',
    'Deri': 'K',
    'Polietilen (PE)': 'K',
    'Polipropilen (PP)': 'K',
    'PVC (sert)': 'K',
    'PVC (esnek/kablo)': 'K',
    'Polistiren (PS)': 'K',
    'EPS köpük': 'K',
    'XPS köpük': 'K',
    'ABS Plastik': 'K',
    'PMMA (Pleksiglas)': 'K',
    'Epoksi Reçine': 'K',
    'Polyester Reçine (CTP/FRP)': 'K',
    'Poliüretan köpük (sert)': 'K',
    'Poliüretan köpük (esnek)': 'K',
    'Kauçuk (doğal)': 'K',
    'Lastik (araç)': 'K',
    'Asfalt / Bitüm': 'K',
    'Kömür': 'K',
    'Elektrik Kablosu (PVC)': 'K',
    'Elektrik Kablosu (XLPE)': 'K',
    'Li-ion Batarya': 'K',
    'Mobilya (karma)': 'K',
    'Benzin': 'S',
    'Dizel': 'S',
    'Metanol': 'S',
    'Etanol': 'S',
    'Aseton / Solvent (genel)': 'S',
    'Boya / Vernik (solventli)': 'S',
    'Trafo Yağı (mineral)': 'S',
    'Hidrolik Yağ': 'S',
    'LPG': 'G',
    'Propan': 'G',
    'Doğalgaz (CNG)': 'G',
    'Diğer (manuel)': 'D',
  };

  bool get _isPano => _mod == _Mod.pano;
  bool get _isDepo => _mod == _Mod.depo;

  void _hesapla() {
    setState(() {
      _hata = null;
      _toplamMJ = null;
      _yogunluk = null;
    });

    double alan;
    if (_mod == _Mod.pano) {
      final w = double.tryParse(_pWCtrl.text.replaceAll(',', '.'));
      final h = double.tryParse(_pHCtrl.text.replaceAll(',', '.'));
      final d = double.tryParse(_pDCtrl.text.replaceAll(',', '.'));
      if (w == null || h == null || d == null || w <= 0 || h <= 0 || d <= 0) {
        setState(
          () =>
              _hata = AppLocalizations.of(context).enterPanelInnerDimensionsCm,
        );
        return;
      }
      final v = (w / 100) * (h / 100) * (d / 100);
      final cableVol = v * _pDolum;
      final cableMass = cableVol * 600.0;
      final combFrac = _pKablo == 'PVC' ? 0.30 : 0.25;
      final nclvC = _pKablo == 'PVC' ? 20.0 : 32.0;
      final combCable = cableMass * combFrac;
      final compMass = v * 0.12 * 800.0;
      final combComp = compMass * 0.70;
      final totalComb = combCable + combComp;
      final energy = combCable * nclvC + combComp * 25.0;
      final eff = energy / totalComb;
      alan = (w / 100) * (d / 100);
      _alanCtrl.text = alan.toStringAsFixed(4);
      setState(() {
        _malzemeler
          ..clear()
          ..add(
            _Malzeme(
              ad: 'Elektrik Panosu (${w.round()}×${h.round()}×${d.round()} cm, $_pKablo)',
              kg: double.parse(totalComb.toStringAsFixed(2)),
              ncv: double.parse(eff.toStringAsFixed(1)),
            ),
          );
      });
    } else if (_mod == _Mod.depo) {
      if (_depolar.isEmpty) {
        setState(
          () => _hata = AppLocalizations.of(context).addAtLeastOneFuelTank,
        );
        return;
      }
      for (final d in _depolar) {
        if (d.miktar <= 0) {
          setState(
            () => _hata = AppLocalizations.of(
              context,
            ).enterQuantityForFuel(d.tur),
          );
          return;
        }
      }
      // Alan opsiyonel — girilmezse yoğunluk hesaplanmaz
      final a = double.tryParse(_depoAlanCtrl.text.replaceAll(',', '.'));
      alan = (a != null && a > 0) ? a : 0.0;
    } else {
      final a = double.tryParse(_alanCtrl.text.replaceAll(',', '.'));
      if (a == null || a <= 0) {
        setState(
          () => _hata = AppLocalizations.of(context).enterValidFloorAreaM2,
        );
        return;
      }
      alan = a;
      for (final m in _malzemeler) {
        if (m.kg <= 0) {
          setState(
            () =>
                _hata = AppLocalizations.of(context).materialMassMissing(m.ad),
          );
          return;
        }
        if (m.ncv <= 0) {
          setState(
            () => _hata = AppLocalizations.of(context).materialNcvMissing(m.ad),
          );
          return;
        }
      }
    }

    final double toplam;
    if (_mod == _Mod.depo) {
      toplam = _depolar.fold(0.0, (s, d) {
        final spec = _yakitVerisi[d.tur]!;
        final massKg = d.birim == 'ton'
            ? d.miktar * 1000.0
            : d.miktar * spec.d * 1000.0;
        return s + massKg * spec.ncv * d.adet;
      });
    } else {
      toplam = _malzemeler.fold(0.0, (s, m) => s + m.kg * m.ncv);
    }

    // Depo modunda alan opsiyonel; girilmemişse yoğunluk hesaplanmaz
    final bool depoAlanYok = _mod == _Mod.depo && alan <= 0;
    if (depoAlanYok) alan = 1.0; // bölme sıfırını önle
    final yon = depoAlanYok ? 0.0 : toplam / alan;
    final String sinif;
    final Color renk;
    if (yon <= 200) {
      sinif = 'Düşük Risk  (≤ 200 MJ/m²)';
      renk = const Color(0xFF16A34A);
    } else if (yon <= 600) {
      sinif = 'Orta Risk  (200–600 MJ/m²)';
      renk = const Color(0xFFD97706);
    } else if (yon <= 1200) {
      sinif = 'Yüksek Risk  (600–1200 MJ/m²)';
      renk = const Color(0xFFEA580C);
    } else {
      sinif = 'Çok Yüksek Risk  (> 1200 MJ/m²)';
      renk = const Color(0xFFDC2626);
    }

    double? tBuy, tSab, tToplam;
    String? e5Key;
    if (_mod == _Mod.pano) {
      e5Key = _pKablo == 'PVC'
          ? 'Elektrik Panosu Odası (PVC)'
          : 'Elektrik Panosu Odası (XLPE)';
    } else if (_mod == _Mod.bina &&
        _secilenBina != null &&
        _e5.containsKey(_secilenBina)) {
      e5Key = _secilenBina;
    }
    // Depo modu için yangın büyüme eğrisi hesaplanmaz
    // Eğer bina _e5'te yoksa manuel _buyumeHiz kullan
    final _BuyumeVeri? buyumeVeri = (e5Key != null && _e5.containsKey(e5Key))
        ? _e5[e5Key]
        : (_mod != _Mod.depo ? _buyumeSpec[_buyumeHiz] : null);
    if (buyumeVeri != null) {
      final veri = buyumeVeri;
      final ta = veri.tAlfa.toDouble();
      // Q_max = min(yakıt yüzeyi sınırlı, enerji sınırlı, [opsiyonel] havalandırma sınırlı)
      double qEff = veri.rhrF * alan / 1000.0;
      String sinirlayan = 'Yakıt Yüzeyi (RHRf × A)';
      if (toplam > 0) {
        final double qEnerji = math
            .pow(3.0 * toplam / ta, 2.0 / 3.0)
            .toDouble();
        if (qEnerji < qEff) {
          qEff = qEnerji;
          sinirlayan = 'Toplam Enerji (düşük yangın yükü)';
        }
      }
      if (_havaGoster) {
        final av = double.tryParse(_avCtrl.text.replaceAll(',', '.'));
        final heq = double.tryParse(_heqCtrl.text.replaceAll(',', '.'));
        final totalKg = _malzemeler.fold(0.0, (s, m) => s + m.kg);
        if (av != null && av > 0 && heq != null && heq > 0 && totalKg > 0) {
          final huOrt = toplam / totalKg; // MJ/kg — ağırlıklı ort. ısıl değer
          final mDotV =
              0.09 * av * math.sqrt(heq); // kg/s — Kawagoe ventilasyon faktörü
          final qMaxV = mDotV * huOrt * 0.8; // MW (η≈0,8 yanma verimliliği)
          if (qMaxV < qEff) {
            qEff = qMaxV;
            sinirlayan = 'Havalandırma (açıklık — yaklaşık)';
          }
        }
      }
      tBuy = ta * math.sqrt(qEff);
      final eBuy = (tBuy! * tBuy! * tBuy!) / (3.0 * ta * ta); // MJ
      // Sabit faz hedefi: toplam yükün %70'i (Eurocode Ek E varsayımı), enerji korunumlu
      final hedefSabitSonu = math.min(0.70 * toplam, toplam);
      final eSab = (hedefSabitSonu - eBuy).clamp(0.0, double.infinity);
      tSab = tBuy! + (qEff > 0 ? eSab / qEff : 0.0);
      // Bozunma enerjisi = gerçek kalan enerji (sabit %30 varsayımı yerine — toplamı asla aşmaz)
      final eBozunma = (toplam - (eBuy + eSab)).clamp(0.0, double.infinity);
      tToplam = tSab! + (qEff > 0 ? eBozunma / (qEff / 2.0) : 0.0);
      _qPik = qEff;
      _sinirlayanFaktor = sinirlayan;
    } else {
      _qPik = null;
      _sinirlayanFaktor = null;
    }

    // TS EN 3-7 taşınabilir söndürücü hesabı (depo modunda yapılmaz)
    final _En37Sonuc? en37 = _mod == _Mod.depo
        ? null
        : _en37Hesapla(depoAlanYok ? 201 : yon, depoAlanYok ? 0 : alan, toplam);
    // Yangın sınıfı açıklaması
    String yangSinifi;
    if (_mod == _Mod.pano) {
      yangSinifi = 'Sınıf B/C (elektrik ekipmanı yağı / gaz) — Toz veya CO₂';
    } else if (_mod == _Mod.depo) {
      final tamamLPG = _depolar.every((d) => d.tur.contains('LPG'));
      final herhangiLPG = _depolar.any((d) => d.tur.contains('LPG'));
      if (tamamLPG) {
        yangSinifi =
            'Sınıf C (sıkıştırılmış yanıcı gaz) — KKP Toz, CO₂ veya Köpük';
      } else if (herhangiLPG) {
        yangSinifi =
            'Sınıf B + Sınıf C (sıvı/gaz yakıt) — KKP ABC Toz veya Köpük';
      } else {
        yangSinifi = 'Sınıf B (yanıcı sıvı) — ABC Kuru Kimyevi Toz veya Köpük';
      }
    } else if (_secilenBina != null && _secilenBina!.contains('Depo')) {
      yangSinifi =
          'Sınıf A + Sınıf B (katı/sıvı yanıcı) — ABC Kuru Kimyevi Toz';
    } else if (_secilenBina != null && _secilenBina!.contains('Otopark')) {
      yangSinifi = 'Sınıf B (sıvı yakıt) — ABC Toz veya Köpük';
    } else {
      yangSinifi = 'Sınıf A (katı yanıcı) — ABC Kuru Kimyevi Toz veya Su';
    }

    setState(() {
      _toplamMJ = toplam;
      _yogunluk = depoAlanYok ? null : yon;
      _riskSinifi = depoAlanYok ? null : sinif;
      _riskRenk = depoAlanYok ? null : renk;
      _tBuyume = tBuy;
      _tSabit = tSab;
      _tToplam = tToplam;
      _en37BeyanA = en37?.beyanA;
      _en37BeyanB = en37?.beyanB;
      _en37SayiA = en37 == null ? null : math.max(en37.sayi, en37.sayiEnerjiA);
      _en37SayiB = en37 == null ? null : math.max(en37.sayi, en37.sayiEnerjiB);
      _en37SayiAlanA = en37?.sayi;
      _en37SayiAlanB = en37?.sayi;
      _en37SayiEnerjiA = en37?.sayiEnerjiA;
      _en37SayiEnerjiB = en37?.sayiEnerjiB;
      _en37KapasiteA = en37?.kapasiteA;
      _en37KapasiteB = en37?.kapasiteB;
      _en37KktA = en37?.kktA;
      _en37KktB = en37?.kktB;
      _yanginSinifiAciklama = yangSinifi;
    });

    if (_isPano) {
      if (_sAjanIdx >= 5) setState(() => _sAjanIdx = 1);
      final h = double.tryParse(_pHCtrl.text.replaceAll(',', '.'));
      if (h != null && h > 0) {
        _sYuksCtrl.text = (h / 100).toStringAsFixed(2);
        _hesaplaAjan();
      }
    }
    ProjeServisi.hesapVeri = jsonEncode({
      'i': {
        'mod': _mod.name,
        'alan': _alanCtrl.text,
        'basinc': _basincCtrl.text,
        'binaAra': _binaAraCtrl.text,
        'secilenBina': _secilenBina ?? '',
        'malzemeler': jsonEncode(
          _malzemeler
              .map((m) => {'ad': m.ad, 'kg': m.kg, 'ncv': m.ncv})
              .toList(),
        ),
        'depoAlan': _depoAlanCtrl.text,
        'depolar': jsonEncode(
          _depolar
              .map(
                (d) => {
                  'tur': d.tur,
                  'miktar': d.miktar,
                  'birim': d.birim,
                  'adet': d.adet,
                },
              )
              .toList(),
        ),
        'pW': _pWCtrl.text,
        'pH': _pHCtrl.text,
        'pD': _pDCtrl.text,
        'pKablo': _pKablo,
        'pDolum': _pDolum.toString(),
        'sYuks': _sYuksCtrl.text,
        'sRakim': _sRakimCtrl.text,
        'sRakimGoster': _sRakimGoster.toString(),
        'sKonsan': _sKonsanCtrl.text,
        'sAjanIdx': _sAjanIdx.toString(),
      },
      'r':
          '## Yang\u0131n Y\u00fck\u00fc Hesab\u0131\n'
          'Toplam Yang\u0131n Y\u00fck\u00fc: ${_toplamMJ?.toStringAsFixed(1) ?? "-"} MJ  |  '
          'Yo\u011funluk: ${_yogunluk?.toStringAsFixed(1) ?? "-"} MJ/m\u00b2  |  '
          'Risk S\u0131n\u0131f\u0131: ${_riskSinifi ?? "-"}\n'
          '${_sAjanMiktar != null ? "## S\u00f6nd\u00fcrme Ajan Hesab\u0131\nAjan: ${_ajanlar[_sAjanIdx].ad}  |  Miktar: ${_sAjanMiktar!.toStringAsFixed(1)} ${_ajanlar[_sAjanIdx].ad.startsWith("ABC")
                    ? "kg"
                    : _ajanlar[_sAjanIdx].inert
                    ? "Nm\u00b3"
                    : "kg"}  |  Silindir: ${_sSilindirSayisi?.toStringAsFixed(0) ?? "-"} adet" : ""}',
    });
    ProjeServisi.hesapSinyali.value = true;
  }

  void _hesaplaAjan() {
    setState(() {
      _sHata = null;
      _sAjanMiktar = null;
      _sSilindirSayisi = null;
    });
    final qf = _yogunluk;
    final alan = double.tryParse(_alanCtrl.text.replaceAll(',', '.'));
    final yuks = double.tryParse(_sYuksCtrl.text.replaceAll(',', '.'));
    if (qf == null) {
      setState(
        () => _sHata = AppLocalizations.of(context).calculateFireLoadFirst,
      );
      return;
    }
    if (alan == null || alan <= 0) {
      setState(() => _sHata = AppLocalizations.of(context).enterValidArea);
      return;
    }
    if (yuks == null || yuks <= 0) {
      setState(() => _sHata = AppLocalizations.of(context).enterRoomHeightM);
      return;
    }
    final v = alan * yuks;
    final rakimM =
        double.tryParse(_sRakimCtrl.text.replaceAll(',', '.')) ?? 0.0;
    final kf = rakimM > 0
        ? (101.325 / (101.325 * math.exp(-rakimM / 8400)))
        : 1.0;
    final ajan = _ajanlar[_sAjanIdx];
    if (ajan.ad.startsWith('ABC')) {
      final kg = v * 0.5;
      setState(() {
        _sAjanMiktar = kg;
        _sSilindirSayisi = (kg / 50).ceilToDouble();
      });
    } else {
      final s = ajan.spesifik!;
      final c =
          double.tryParse(_sKonsanCtrl.text.replaceAll(',', '.')) ??
          ajan.konsan;
      if (ajan.inert) {
        final nm3 = v * math.log(100 / (100 - c));
        setState(() {
          _sAjanMiktar = nm3;
          _sSilindirSayisi = (nm3 / 16).ceilToDouble();
        });
      } else {
        final w = (v / s) * kf * math.log(100 / (100 - c));
        setState(() {
          _sAjanMiktar = w;
          _sSilindirSayisi = (w / (ajan.ad.startsWith('CO') ? 45.0 : 100.0))
              .ceilToDouble();
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    final g = ProjeServisi.kayitliGirdiler;
    if (g != null) {
      ProjeServisi.kayitliGirdiler = null;
      _mod = _Mod.values.firstWhere(
        (e) => e.name == (g['mod'] ?? 'bina'),
        orElse: () => _Mod.bina,
      );
      _alanCtrl.text = g['alan'] ?? '';
      _basincCtrl.text = g['basinc'] ?? '4';
      _binaAraCtrl.text = g['binaAra'] ?? '';
      _secilenBina = g['secilenBina']?.isEmpty == true
          ? null
          : g['secilenBina'];
      final malStr = g['malzemeler'] ?? '';
      if (malStr.isNotEmpty) {
        try {
          final list = jsonDecode(malStr) as List;
          _malzemeler
            ..clear()
            ..addAll(
              list.map(
                (e) => _Malzeme(
                  ad: e['ad'] as String,
                  kg: (e['kg'] as num).toDouble(),
                  ncv: (e['ncv'] as num).toDouble(),
                ),
              ),
            );
        } catch (_) {}
      }
      _depoAlanCtrl.text = g['depoAlan'] ?? '';
      final depStr = g['depolar'] ?? '';
      if (depStr.isNotEmpty) {
        try {
          final list = jsonDecode(depStr) as List;
          _depolar
            ..clear()
            ..addAll(
              list.map(
                (e) => _Depo(
                  tur: e['tur'] as String,
                  miktar: (e['miktar'] as num).toDouble(),
                  birim: e['birim'] as String,
                  adet: (e['adet'] as num).toInt(),
                ),
              ),
            );
        } catch (_) {}
      }
      _pWCtrl.text = g['pW'] ?? '';
      _pHCtrl.text = g['pH'] ?? '';
      _pDCtrl.text = g['pD'] ?? '';
      _pKablo = g['pKablo'] ?? 'PVC';
      _pDolum = double.tryParse(g['pDolum'] ?? '0.35') ?? 0.35;
      _sYuksCtrl.text = g['sYuks'] ?? '';
      _sRakimCtrl.text = g['sRakim'] ?? '';
      _sRakimGoster = g['sRakimGoster'] == 'true';
      _sKonsanCtrl.text = g['sKonsan'] ?? '7.9';
      _sAjanIdx = int.tryParse(g['sAjanIdx'] ?? '1') ?? 1;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {});
          _hesapla();
        }
      });
    }
  }

  @override
  void dispose() {
    _alanCtrl.dispose();
    _basincCtrl.dispose();
    _binaAraCtrl.dispose();
    _depoAlanCtrl.dispose();
    _pWCtrl.dispose();
    _pHCtrl.dispose();
    _pDCtrl.dispose();
    _sYuksCtrl.dispose();
    _sRakimCtrl.dispose();
    _sKonsanCtrl.dispose();
    _avCtrl.dispose();
    _heqCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Formül özeti
          _InfoBox(
            color: const Color(0xFFFEF3C7),
            border: const Color(0xFFFCD34D),
            child: Text(
              l10n.fireLoadFormulaInfo,
              style: const TextStyle(
                fontSize: 11,
                fontFamily: 'monospace',
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Mod seçimi
          SegmentedButton<_Mod>(
            segments: [
              ButtonSegment(
                value: _Mod.bina,
                label: Text(l10n.building, style: TextStyle(fontSize: 12)),
                icon: Icon(Icons.domain_rounded),
              ),
              ButtonSegment(
                value: _Mod.pano,
                label: Text(
                  l10n.electricalPanel,
                  style: TextStyle(fontSize: 12),
                ),
                icon: Icon(Icons.electrical_services_rounded),
              ),
              ButtonSegment(
                value: _Mod.depo,
                label: Text(l10n.fuelOrStorage, style: TextStyle(fontSize: 12)),
                icon: Icon(Icons.local_gas_station_rounded),
              ),
            ],
            selected: {_mod},
            onSelectionChanged: (s) => setState(() {
              _mod = s.first;
              if (_mod != _Mod.bina) _secilenBina = null;
            }),
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.resolveWith(
                (st) => st.contains(WidgetState.selected) ? Colors.white : _kC,
              ),
              backgroundColor: WidgetStateProperty.resolveWith(
                (st) => st.contains(WidgetState.selected) ? _kC : null,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // ¦¦ Bina modu
          if (_mod == _Mod.bina) ...[
            // Aramalı bina seçici
            GestureDetector(
              onTap: () async {
                _binaAraCtrl.clear();
                final sec = await showModalBottomSheet<String>(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  builder: (ctx) => _BinaSeciciSheet(
                    araCtrl: _binaAraCtrl,
                    secenekler: _refYog.keys.toList(),
                    secilenBina: _secilenBina,
                    tehlikeMap: _ek1TehlikeSinifi,
                  ),
                );
                if (sec != null) {
                  setState(() {
                    _secilenBina = sec;
                    if (_e5.containsKey(sec)) {
                      _buyumeHiz = _e5[sec]!.hiz;
                    }
                  });
                }
              },
              child: InputDecorator(
                decoration: _decor(l10n.buildingUseType, Icons.domain_rounded),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _secilenBina == null
                            ? l10n.chooseBuildingUseType
                            : _binaGorunenAd(_secilenBina!, l10n),
                        style: TextStyle(
                          fontSize: 13,
                          color: _secilenBina != null
                              ? Colors.black87
                              : Colors.black38,
                        ),
                      ),
                    ),
                    if (_secilenBina != null)
                      GestureDetector(
                        onTap: () => setState(() => _secilenBina = null),
                        child: const Icon(
                          Icons.clear,
                          size: 18,
                          color: Colors.black38,
                        ),
                      )
                    else
                      const Icon(
                        Icons.search_rounded,
                        size: 18,
                        color: Colors.black38,
                      ),
                  ],
                ),
              ),
            ),
            if (_secilenBina != null) ...[
              const SizedBox(height: 4),
              Text(
                '${l10n.referenceDensity}: ${_refYog[_secilenBina]!.toStringAsFixed(0)} MJ/m²',
                style: const TextStyle(
                  fontSize: 12,
                  color: _kC,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (_e5.containsKey(_secilenBina))
                Text(
                  'E.5 › ${_buyumeHizL10n(l10n, _e5[_secilenBina]!.hiz)}  '
                  't\u03b1=${_e5[_secilenBina]!.tAlfa}s  '
                  'RHRf=${_e5[_secilenBina]!.rhrF}kW/m²',
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                ),
            ],
            const SizedBox(height: 10),
            // Büyüme hızı seçici
            Row(
              children: [
                const Icon(Icons.trending_up_rounded, size: 16, color: _kC),
                const SizedBox(width: 6),
                Text(l10n.growthRate, style: TextStyle(fontSize: 13)),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                      ),
                      child: DropdownButton<String>(
                        value: _buyumeSpec.containsKey(_buyumeHiz)
                            ? _buyumeHiz
                            : 'Orta',
                        isDense: true,
                        isExpanded: true,
                        items: _buyumeSpec.entries.map((e) {
                          final ta = e.value.tAlfa;
                          return DropdownMenuItem(
                            value: e.key,
                            child: Text(
                              '${_buyumeHizL10n(l10n, e.key)}  (t\u03b1=${ta}s)',
                              style: const TextStyle(fontSize: 13),
                            ),
                          );
                        }).toList(),
                        onChanged: (v) {
                          if (v != null) setState(() => _buyumeHiz = v);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _alanCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: _decor(
                l10n.floorArea,
                lblFontSize: 12,
                Icons.square_foot_rounded,
                suffix: 'm²',
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _basincCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: (_) => setState(() {}),
              decoration: _decor(
                l10n.cabinetNozzlePressure,
                Icons.compress_rounded,
                suffix: 'bar',
              ),
            ),
            const SizedBox(height: 14),

            // Malzeme listesi başlığı
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.combustibleMaterials,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => setState(
                    () => _malzemeler.add(
                      _Malzeme(ad: l10n.woodTimber, kg: 0, ncv: 17.5),
                    ),
                  ),
                  icon: const Icon(Icons.add_circle_rounded, size: 20),
                  label: Text(l10n.addMaterial),
                  style: TextButton.styleFrom(foregroundColor: _kC),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ...List.generate(
              _malzemeler.length,
              (i) => _MalzemeSatir(
                malzeme: _malzemeler[i],
                ncvMap: _ncv,
                kategoriMap: _malzemeKategori,
                onSil: _malzemeler.length > 1
                    ? () => setState(() => _malzemeler.removeAt(i))
                    : null,
                onDegisti: () => setState(() {}),
              ),
            ),
          ],

          // ¦¦ Pano modu
          if (_mod == _Mod.pano) ...[
            Text(
              l10n.panelInnerDimensions,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _panocm(l10n.panelWidth, _pWCtrl)),
                const SizedBox(width: 8),
                Expanded(child: _panocm(l10n.panelHeight, _pHCtrl)),
                const SizedBox(width: 8),
                Expanded(child: _panocm(l10n.panelDepth, _pDCtrl)),
              ],
            ),
            const SizedBox(height: 10),
            SegmentedButton<String>(
              segments: [
                ButtonSegment(value: 'PVC', label: Text('PVC')),
                ButtonSegment(value: 'XLPE', label: Text('XLPE')),
              ],
              selected: {_pKablo},
              onSelectionChanged: (s) => setState(() => _pKablo = s.first),
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.resolveWith(
                  (st) =>
                      st.contains(WidgetState.selected) ? Colors.white : _kC,
                ),
                backgroundColor: WidgetStateProperty.resolveWith(
                  (st) => st.contains(WidgetState.selected) ? _kC : null,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.cableFillRatio((_pDolum * 100).round()),
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            Slider(
              value: _pDolum,
              min: 0.10,
              max: 0.60,
              divisions: 10,
              activeColor: _kC,
              label: '% ${(_pDolum * 100).round()}',
              onChanged: (v) => setState(() => _pDolum = v),
            ),
          ],

          // ¦¦ Yakıt / Kimyasal Depo modu
          if (_mod == _Mod.depo) ...[
            _InfoBox(
              color: const Color(0xFFFFF7ED),
              border: const Color(0xFFFED7AA),
              child: Text(
                l10n.fuelStorageInstructions,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.fuelChemicalTanks,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => setState(
                    () => _depolar.add(
                      _Depo(tur: 'Motorin / Dizel', miktar: 0, birim: 'm³'),
                    ),
                  ),
                  icon: const Icon(Icons.add_circle_rounded, size: 20),
                  label: Text(l10n.addMaterial),
                  style: TextButton.styleFrom(foregroundColor: _kC),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ...List.generate(
              _depolar.length,
              (i) => _DepoSatir(
                depo: _depolar[i],
                yakitlar: _yakitVerisi.keys.toList(),
                kapasiteOneri: _kapasiteOneri,
                onSil: _depolar.length > 1
                    ? () => setState(() => _depolar.removeAt(i))
                    : null,
                onDegisti: () => setState(() {}),
              ),
            ),
            const SizedBox(height: 10),
            // Mini özet
            if (_depolar.any((d) => d.miktar > 0 && d.adet > 0)) ...[
              Builder(
                builder: (ctx) {
                  double toplamTon = 0;
                  for (final d in _depolar) {
                    final spec = _yakitVerisi[d.tur]!;
                    final massTon = d.birim == 'ton'
                        ? d.miktar
                        : d.miktar * spec.d;
                    toplamTon += massTon * d.adet;
                  }
                  return Text(
                    l10n.totalApproxMass(toplamTon.toStringAsFixed(1)),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      fontStyle: FontStyle.italic,
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
            // Opsiyonel bund/havuz alanı
            TextFormField(
              controller: _depoAlanCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: _decor(
                l10n.bundPoolArea,
                Icons.water_rounded,
                suffix: 'm²',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.fireLoadDensityIfEntered,
              style: const TextStyle(fontSize: 11, color: Colors.black38),
            ),
          ],
          if (_mod != _Mod.depo) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Checkbox(
                  value: _havaGoster,
                  activeColor: _kC,
                  onChanged: (v) => setState(() => _havaGoster = v ?? false),
                ),
                Expanded(
                  child: Text(
                    l10n.ventilationLimitedQmaxInclude,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            if (!_havaGoster)
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 4),
                child: Text(
                  l10n.ventilationLimitedQmaxNote,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.black45,
                    height: 1.4,
                  ),
                ),
              ),
            if (_havaGoster) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _avCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: _decor(
                        l10n.openingArea,
                        Icons.window_rounded,
                        suffix: 'm²',
                        lblFontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _heqCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: _decor(
                        l10n.openingHeight,
                        Icons.height_rounded,
                        suffix: 'm',
                        lblFontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                l10n.openingAreaHeightExplanation,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.black45,
                  height: 1.4,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.ventilationQmaxFormulaNote,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.black45,
                  height: 1.4,
                ),
              ),
            ],
          ],
          ElevatedButton.icon(
            onPressed: _hesapla,
            icon: const Icon(Icons.calculate_rounded),
            label: Text(AppLocalizations.of(context)!.calculate),
            style: ElevatedButton.styleFrom(
              backgroundColor: _kC,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          if (_hata != null) ...[
            const SizedBox(height: 8),
            _InfoBox(
              color: const Color(0xFFFEE2E2),
              border: const Color(0xFFFCA5A5),
              child: Text(
                _hata!,
                style: const TextStyle(color: Color(0xFFDC2626), fontSize: 13),
              ),
            ),
          ],

          // ¦¦ Sonuçlar — Depo modu, alan girilmedi
          if (_toplamMJ != null && _mod == _Mod.depo && _yogunluk == null) ...[
            const SizedBox(height: 18),
            Builder(
              builder: (ctx) {
                final gj = _toplamMJ! / 1000.0;
                final mwh = _toplamMJ! / 3600.0;
                final gwh = _toplamMJ! / 3_600_000.0;
                final Color c = gj < 1000
                    ? const Color(0xFFD97706)
                    : const Color(0xFFDC2626);
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: c, width: 2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.totalFireEnergyLabel,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: c,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const Divider(height: 16),
                      _SonucSatir(
                        etiket: l10n.totalEnergy,
                        deger: '${_toplamMJ!.toStringAsFixed(0)} MJ',
                        renk: c,
                      ),
                      const SizedBox(height: 4),
                      _SonucSatir(
                        etiket: l10n.totalEnergyGJ,
                        deger: '${gj.toStringAsFixed(1)} GJ',
                        renk: c,
                      ),
                      const SizedBox(height: 4),
                      _SonucSatir(
                        etiket: l10n.totalEnergyMWh,
                        deger: '${mwh.toStringAsFixed(2)} MWh',
                        renk: c,
                      ),
                      const SizedBox(height: 4),
                      _SonucSatir(
                        etiket: l10n.totalEnergyGWh,
                        deger: '${gwh.toStringAsFixed(4)} GWh',
                        renk: c,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.bundAreaIfEnteredNote,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],

          // ¦¦ Sonuçlar — Yoğunluk bazlı
          if (_yogunluk != null) ...[
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _riskRenk!, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.calculationResultLabel,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: _riskRenk,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const Divider(height: 16),
                  _SonucSatir(
                    etiket: l10n.totalFireLoad,
                    deger:
                        '${_toplamMJ!.toStringAsFixed(0)} MJ'
                        '  /  ${(_toplamMJ! / 1000).toStringAsFixed(1)} GJ'
                        '  /  ${(_toplamMJ! / 3600).toStringAsFixed(2)} MWh',
                    renk: _riskRenk!,
                  ),
                  const SizedBox(height: 4),
                  _SonucSatir(
                    etiket: l10n.fireLoadDensityLabel,
                    deger: '${_yogunluk!.toStringAsFixed(1)} MJ/m²',
                    renk: _riskRenk!,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 14,
                    ),
                    decoration: BoxDecoration(
                      color: _riskRenk!.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _riskRenk!.withOpacity(0.4)),
                    ),
                    child: Text(
                      _riskClassDisplay(_riskSinifi!, l10n),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: _riskRenk,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // Referans karşılaştırması
                  if (_mod == _Mod.bina && _secilenBina != null) ...[
                    const SizedBox(height: 12),
                    Builder(
                      builder: (ctx) {
                        final ref = _refYog[_secilenBina]!;
                        final fark = _yogunluk! - ref;
                        final fc = fark > 0
                            ? const Color(0xFFDC2626)
                            : const Color(0xFF16A34A);
                        return _InfoBox(
                          color: fc.withOpacity(0.07),
                          border: fc.withOpacity(0.4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _secilenBina!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${ref.toStringAsFixed(0)} MJ/m²',
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                fark > 0
                                    ? l10n.exceedsReferenceLabel(
                                        fark.toStringAsFixed(0),
                                      )
                                    : l10n.belowReferenceLabel(
                                        fark.abs().toStringAsFixed(0),
                                      ),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: fc,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${l10n.sourceLabel}: ${_refKaynak[_secilenBina] ?? 'EN 1991-1-2 Ek E'}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],

                  // Q(t) yangın takvimi
                  if (_tBuyume != null) ...[
                    const SizedBox(height: 12),
                    _InfoBox(
                      color: const Color(0xFFF0FDFA),
                      border: const Color(0xFF5EEAD4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.fireGrowthTimeline,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF134E4A),
                            ),
                          ),
                          const SizedBox(height: 8),
                          _ZamanSatir(
                            faz: l10n.growthPhaseEnd,
                            sure: _tBuyume!,
                            renk: const Color(0xFFEA580C),
                          ),
                          _ZamanSatir(
                            faz: l10n.decayPhaseStart,
                            sure: _tSabit!,
                            renk: const Color(0xFFDC2626),
                          ),
                          _ZamanSatir(
                            faz: l10n.totalFireDuration,
                            sure: _tToplam!,
                            renk: const Color(0xFF7C3AED),
                          ),
                          if (_qPik != null && _sinirlayanFaktor != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              l10n.peakHeatReleaseLabel(
                                _limitingFactorDisplay(
                                  _sinirlayanFaktor!,
                                  l10n,
                                ),
                                _qPik!.toStringAsFixed(2),
                              ),
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF134E4A),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // ¦¦ Söndürme bölümü (yakıt deposunda gösterilmez)
            if (_mod != _Mod.depo) ...[
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF0369A1),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.fire_extinguisher_rounded,
                          color: Color(0xFF0369A1),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.extinguishingAgentCalcTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xFF0369A1),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'q = ${_yogunluk!.toStringAsFixed(1)} MJ/m²',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                      ),
                    ),
                    const Divider(height: 20),

                    // Yükseklik (pano: otomatik)
                    if (_isPano)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          l10n.panelVolumeHeight(
                            (double.tryParse(_pHCtrl.text) ?? 0) > 0
                                ? '${((double.tryParse(_pHCtrl.text) ?? 0) / 100).toStringAsFixed(2)} m'
                                : '—',
                          ),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF0369A1),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextField(
                          controller: _sYuksCtrl,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: _sBordDecor(
                            l10n.roomHeightLabel,
                            Icons.height_rounded,
                          ),
                        ),
                      ),

                    // Pano uyarısı
                    if (_isPano) ...[
                      _InfoBox(
                        color: const Color(0xFFEFF6FF),
                        border: const Color(0xFF3B82F6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.lightbulb_outline_rounded,
                              size: 14,
                              color: Color(0xFF1D4ED8),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                l10n.panelAgentRecommendation,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF1E40AF),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],

                    // Ajan seçimi
                    DropdownButtonFormField<int>(
                      value: _sAjanIdx,
                      isExpanded: true,
                      decoration: _sBordDecor(
                        l10n.extinguishingAgentLabel,
                        Icons.fire_extinguisher_rounded,
                      ),
                      items: List.generate(
                        _ajanlar.length,
                        (i) => DropdownMenuItem(
                          value: i,
                          child: Text(
                            _ajanlar[i].ad,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                      onChanged: (v) => setState(() {
                        _sAjanIdx = v ?? 1;
                        _sAjanMiktar = null;
                        _sSilindirSayisi = null;
                        _sHata = null;
                        final defKonsan = _ajanlar[_sAjanIdx].konsan;
                        if (defKonsan > 0) {
                          _sKonsanCtrl.text = defKonsan.toStringAsFixed(1);
                        } else {
                          _sKonsanCtrl.clear();
                        }
                      }),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _ajanlar[_sAjanIdx].aciklama,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (!_ajanlar[_sAjanIdx].ad.startsWith('ABC')) ...[
                      TextField(
                        controller: _sKonsanCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: _sBordDecor(
                          l10n.designConcentration,
                          Icons.percent_rounded,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],

                    Row(
                      children: [
                        Checkbox(
                          value: _sRakimGoster,
                          activeColor: const Color(0xFF0369A1),
                          onChanged: (v) =>
                              setState(() => _sRakimGoster = v ?? false),
                        ),
                        Text(
                          l10n.altitudeCorrectionLabel,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    if (_sRakimGoster) ...[
                      TextField(
                        controller: _sRakimCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: _sBordDecor(
                          l10n.altitudeLabel,
                          Icons.terrain_rounded,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    if (_sHata != null)
                      Text(
                        _sHata!,
                        style: const TextStyle(
                          color: Color(0xFFDC2626),
                          fontSize: 12,
                        ),
                      ),

                    const SizedBox(height: 6),
                    ElevatedButton.icon(
                      onPressed: _hesaplaAjan,
                      icon: const Icon(Icons.calculate_rounded),
                      label: Text(
                        AppLocalizations.of(
                          context,
                        )!.calculateExtinguishingAgent,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0369A1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    if (_sAjanMiktar != null) ...[
                      const Divider(height: 20),
                      Builder(
                        builder: (ctx) {
                          final aj = _ajanlar[_sAjanIdx];
                          final isInert = aj.inert;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...[
                                _SonucSatirMavi(
                                  etiket: isInert
                                      ? l10n.requiredAgent
                                      : l10n.requiredAgentMass,
                                  deger: isInert
                                      ? '${_sAjanMiktar!.toStringAsFixed(1)} Nm³'
                                      : '${_sAjanMiktar!.toStringAsFixed(1)} kg',
                                ),
                                if (_sSilindirSayisi != null) ...[
                                  const SizedBox(height: 4),
                                  _SonucSatirMavi(
                                    etiket: isInert
                                        ? l10n.cylinderCountApprox
                                        : l10n.cylinderContainerCount,
                                    deger: ' ${_sSilindirSayisi!.toInt()} adet',
                                  ),
                                ],
                              ],
                            ],
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ], // if (_mod != _Mod.depo) sonu
          ], // if (_yogunluk != null) sonu
          // ¦¦ TS EN 3-7 Taşınabilir Söndürücü Bölümü (yakıt deposunda gösterilmez)
          if (_en37BeyanA != null && _mod != _Mod.depo) ...[
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFEA580C), width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.fire_extinguisher,
                        color: Color(0xFFEA580C),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.portableExtinguisherTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFFEA580C),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _yanginSinifiAciklama == null
                        ? ''
                        : _fireClassDisplay(_yanginSinifiAciklama!, l10n),
                    style: const TextStyle(fontSize: 11, color: Colors.black54),
                  ),
                  const Divider(height: 16),
                  _En37Satir(
                    sinif: 'A',
                    beyan: _en37BeyanA!,
                    kkt: _en37KktA!,
                    sayiAlan: _en37SayiAlanA!,
                    sayiEnerji: _en37SayiEnerjiA!,
                    kapasite: _en37KapasiteA!,
                    renk: const Color(0xFFEA580C),
                  ),
                  const SizedBox(height: 6),
                  _En37Satir(
                    sinif: 'B',
                    beyan: _en37BeyanB!,
                    kkt: _en37KktB!,
                    sayiAlan: _en37SayiAlanB!,
                    sayiEnerji: _en37SayiEnerjiB!,
                    kapasite: _en37KapasiteB!,
                    renk: const Color(0xFF7C3AED),
                  ),

                  const SizedBox(height: 8),
                  Text(
                    l10n.portableExtinguisherSourceFooter,
                    style: const TextStyle(fontSize: 10, color: Colors.black38),
                  ),
                ],
              ),
            ),
          ],
          // ¦¦ Yangın Dolabı Hesabı (bina + pano modunda, alan girildiyse)
          if (_yogunluk != null && _mod != _Mod.depo) ...[
            const SizedBox(height: 18),
            Builder(
              builder: (ctx) {
                final alan =
                    double.tryParse(_alanCtrl.text.replaceAll(',', '.')) ?? 0.0;
                // BYKHY Md. 19 tehlike sınıfı:
                // Bina türü seçildiyse Ek-1 (Ek-1/A, Ek-1/B, Ek-1/C) tablosundan,
                // seçilmediyse (pano / depo modu) yangın yükü yoğunluğundan belirlenir.
                final String tehlikeSinifi;
                if (_secilenBina != null &&
                    _ek1TehlikeSinifi.containsKey(_secilenBina)) {
                  tehlikeSinifi = switch (_ek1TehlikeSinifi[_secilenBina]!) {
                    'D' => 'Düşük',
                    'Y' => 'Yüksek',
                    _ => 'Orta',
                  };
                } else {
                  // Yoğunluk tabanlı (BYKHY Md. 92 / Ek-8/C sınır değerleri)
                  tehlikeSinifi = _yogunluk! <= 200
                      ? 'Düşük'
                      : (_yogunluk! <= 1000 ? 'Orta' : 'Yüksek');
                }
                final dusuk = tehlikeSinifi == 'Düşük';
                final orta = tehlikeSinifi == 'Orta';
                final m2PerDolap = dusuk ? 1000.0 : (orta ? 800.0 : 500.0);
                final alanBazli = alan > 0
                    ? (alan / m2PerDolap).ceil().clamp(2, 9999)
                    : 2;

                // DN25 (1") yarı sert hortumlu makara (TS EN 671-1): K=50 L/min/bar^0.5
                // Q = K × √P → 4 bar'da: 100 L/min  (EN 671-1 min. akış şartı)
                const double kFaktor = 50.0; // nozzle K-factor
                const double pMin = 4.0; // bar minimum
                final double pGirilen =
                    (double.tryParse(_basincCtrl.text.replaceAll(',', '.')) ??
                            pMin)
                        .clamp(pMin, 16.0);
                final double flowLmin = kFaktor * math.sqrt(pGirilen);
                // BYKHY rezerv süresi: Düşük 30 dk · Orta 60 dk · Yüksek 90 dk
                final double calismaMin = dusuk ? 30.0 : (orta ? 60.0 : 90.0);

                // Pratik söndürme kapasitesi (laboratuvar ölçümlü, Net Karşılaştırma tablosu)
                // A sınıfı: 1–2 MW/dolap  →  orta: 1.5 MW
                // B sınıfı: 0.2–0.6 MW/dolap  →  orta: 0.4 MW
                // Sınıf belirleme: pano = B/C sabit; diğer modlarda malzeme cinsine bak
                const _sinifBMalzemeler = {
                  'Benzin',
                  'Dizel',
                  'LPG',
                  'Metanol',
                  'Etanol',
                  'Boya / Vernik (solventli)',
                  'Asfalt / Bitüm',
                };
                final bool isSinifB = _mod == _Mod.pano
                    ? true
                    : _malzemeler.any(
                        (m) => m.kg > 0 && _sinifBMalzemeler.contains(m.ad),
                      );
                // Pratik söndürme kapasitesi: A sınıfı 2 MW, B/C sınıfı 0.6 MW
                final double qPerDolap = isSinifB ? 0.6 : 2.0;
                final double qPerDolapUst = qPerDolap; // tek değer

                final toplamQ = alanBazli * qPerDolap;
                // Su rezerv süresi: toplam yangın süresi varsa onu kullan, yoksa BYKHY minimum
                final double rezervMin = _tToplam != null
                    ? (_tToplam! / 60.0).ceilToDouble().clamp(
                        calismaMin,
                        double.infinity,
                      )
                    : calismaMin;
                final rezervLitre = alanBazli * flowLmin * rezervMin;
                final rezervM3 = rezervLitre / 1000.0;

                const kC2 = Color(0xFF0369A1);

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kC2, width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.local_fire_department_rounded,
                            color: kC2,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              l10n.fireCabinetTitle,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xFF0369A1),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 16),
                      // Teknik özellikler satırı
                      _InfoBox(
                        color: const Color(0xFFF0F9FF),
                        border: const Color(0xFFBAE6FD),
                        child: Text(
                          l10n.fireCabinetTechSpecs(
                            isSinifB
                                ? l10n.classBCapacityPerCabinet
                                : l10n.classACapacityPerCabinet,
                            flowLmin.toStringAsFixed(1),
                            pGirilen.toStringAsFixed(1),
                          ),
                          style: const TextStyle(
                            fontSize: 11,
                            fontFamily: 'monospace',
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Hesap sonuçları
                      _SonucSatirMavi(
                        etiket: l10n.hazardClassLabel,
                        deger: _hazardClassDisplay(tehlikeSinifi, l10n),
                      ),
                      const SizedBox(height: 4),
                      if (alan > 0) ...[
                        const SizedBox(height: 4),
                        _SonucSatirMavi(
                          etiket: l10n.requiredCabinetCount,
                          deger: '$alanBazli adet',
                        ),
                      ],
                      const SizedBox(height: 4),
                      _SonucSatirMavi(
                        etiket: l10n.totalExtinguishingCapacityLabel,
                        deger:
                            '${toplamQ.toStringAsFixed(2)} MW  ($alanBazli × ${qPerDolap.toStringAsFixed(1)} MW)',
                      ),
                      const SizedBox(height: 4),
                      _SonucSatirMavi(
                        etiket: l10n.waterReserveVolumeLabel(rezervMin.toInt()),
                        deger:
                            '${rezervM3.toStringAsFixed(1)} m³  (${rezervLitre.toStringAsFixed(0)} L)',
                      ),
                      // Yeterli / Yetersiz karşılaştırması
                      if (_toplamMJ != null) ...[
                        const SizedBox(height: 8),
                        Builder(
                          builder: (ctx) {
                            // Toplam söndürme kapasitesi (MW) vs ortalama yangın gücü (MW)
                            // rezervMin: toplam yangın süresi (veya BYKHY min) — su rezerviyle aynı zaman tabanı
                            final yangYukuMW =
                                _toplamMJ! / (rezervMin * 60.0); // MW
                            final yeterli = toplamQ >= yangYukuMW;
                            final renk = yeterli
                                ? const Color(0xFF16A34A)
                                : const Color(0xFFDC2626);
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: renk.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: renk.withOpacity(0.4),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    yeterli
                                        ? Icons.check_circle_rounded
                                        : Icons.warning_rounded,
                                    color: renk,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      yeterli
                                          ? l10n.cabinetSufficientLabel(
                                              alanBazli,
                                              yangYukuMW.toStringAsFixed(2),
                                              toplamQ.toStringAsFixed(2),
                                            )
                                          : l10n.cabinetInsufficientLabel(
                                              alanBazli,
                                              yangYukuMW.toStringAsFixed(2),
                                              (yangYukuMW / qPerDolap).ceil(),
                                              toplamQ.toStringAsFixed(2),
                                            ),
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: renk,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                      const SizedBox(height: 6),
                      Text(
                        l10n.fireCabinetSourceFooter,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black38,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
          const SizedBox(height: 20),
          Text(
            l10n.fireLoadSourcesFooter,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: Colors.black38),
          ),
        ],
      ),
    );
  }

  // helpers
  String _limitingFactorDisplay(String v, AppLocalizations l10n) => switch (v) {
    'Yakıt Yüzeyi (RHRf × A)' => l10n.limitingFactorFuelSurface,
    'Toplam Enerji (düşük yangın yükü)' => l10n.limitingFactorTotalEnergy,
    'Havalandırma (açıklık — yaklaşık)' => l10n.limitingFactorVentilation,
    _ => v,
  };

  String _riskClassDisplay(String v, AppLocalizations l10n) => switch (v) {
    'Düşük Risk  (≤ 200 MJ/m²)' => l10n.riskClassLow,
    'Orta Risk  (200–600 MJ/m²)' => l10n.riskClassMedium,
    'Yüksek Risk  (600–1200 MJ/m²)' => l10n.riskClassHigh,
    'Çok Yüksek Risk  (> 1200 MJ/m²)' => l10n.riskClassVeryHigh,
    _ => v,
  };

  String _hazardClassDisplay(String v, AppLocalizations l10n) => switch (v) {
    'Düşük' => l10n.hazardClassLow,
    'Yüksek' => l10n.hazardClassHigh,
    _ => l10n.hazardClassMedium,
  };

  String _fireClassDisplay(String v, AppLocalizations l10n) => switch (v) {
    'Sınıf B/C (elektrik ekipmanı yağı / gaz) — Toz veya CO₂' =>
      l10n.fireClassPanel,
    'Sınıf C (sıkıştırılmış yanıcı gaz) — KKP Toz, CO₂ veya Köpük' =>
      l10n.fireClassGasStorage,
    'Sınıf B + Sınıf C (sıvı/gaz yakıt) — KKP ABC Toz veya Köpük' =>
      l10n.fireClassLiquidGasStorage,
    'Sınıf B (yanıcı sıvı) — ABC Kuru Kimyevi Toz veya Köpük' =>
      l10n.fireClassLiquidStorage,
    'Sınıf A + Sınıf B (katı/sıvı yanıcı) — ABC Kuru Kimyevi Toz' =>
      l10n.fireClassSolidLiquidStorage,
    'Sınıf B (sıvı yakıt) — ABC Toz veya Köpük' => l10n.fireClassParking,
    'Sınıf A (katı yanıcı) — ABC Kuru Kimyevi Toz veya Su' =>
      l10n.fireClassSolidDefault,
    _ => v,
  };

  Widget _panocm(String lbl, TextEditingController c) => TextField(
    controller: c,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    decoration: InputDecoration(
      labelText: lbl,
      suffixText: 'cm',
      border: const OutlineInputBorder(),
      isDense: true,
      labelStyle: const TextStyle(color: _kC),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: _kC, width: 2),
      ),
    ),
  );

  InputDecoration _decor(
    String lbl,
    IconData ico, {
    String? suffix,
    double? lblFontSize,
  }) => InputDecoration(
    labelText: lbl,
    prefixIcon: Icon(ico),
    border: const OutlineInputBorder(),
    suffixText: suffix,
    labelStyle: TextStyle(color: _kC, fontSize: lblFontSize),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: _kC, width: 2),
    ),
  );

  InputDecoration _sBordDecor(String lbl, IconData ico) => InputDecoration(
    labelText: lbl,
    prefixIcon: Icon(ico),
    border: const OutlineInputBorder(),
    isDense: true,
    labelStyle: const TextStyle(color: Color(0xFF0369A1)),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF0369A1), width: 2),
    ),
  );
}

// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
// SMALL HELPER WIDGETS
// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦

class _InfoBox extends StatelessWidget {
  final Color color, border;
  final Widget child;
  const _InfoBox({
    required this.color,
    required this.border,
    required this.child,
  });
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: border),
    ),
    child: child,
  );
}

class _SonucSatir extends StatelessWidget {
  final String etiket, deger;
  final Color renk;
  const _SonucSatir({
    required this.etiket,
    required this.deger,
    required this.renk,
  });
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(Icons.fiber_manual_record, size: 8, color: renk),
      const SizedBox(width: 6),
      Expanded(
        child: Text(etiket, style: TextStyle(fontSize: 13, color: renk)),
      ),
      Text(
        deger,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: renk,
        ),
      ),
    ],
  );
}

class _SonucSatirMavi extends StatelessWidget {
  final String etiket, deger;
  const _SonucSatirMavi({required this.etiket, required this.deger});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Icon(Icons.fiber_manual_record, size: 8, color: Color(0xFF0369A1)),
      const SizedBox(width: 6),
      Expanded(
        child: Text(
          etiket,
          style: const TextStyle(fontSize: 13, color: Color(0xFF0369A1)),
        ),
      ),
      Text(
        deger,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: Color(0xFF0369A1),
        ),
      ),
    ],
  );
}

class _ZamanSatir extends StatelessWidget {
  final String faz;
  final double sure;
  final Color renk;
  final double? hrr; // MW — opsiyonel
  const _ZamanSatir({
    required this.faz,
    required this.sure,
    required this.renk,
    this.hrr,
  });
  String _fmt(double s) {
    if (s < 60) return '${s.toStringAsFixed(0)} s';
    final m = (s / 60).floor();
    final r = s - m * 60;
    return r > 0 ? '${m}d ${r.toStringAsFixed(0)}s' : '${m}d';
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: renk, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Expanded(child: Text(faz, style: const TextStyle(fontSize: 12))),
        if (hrr != null)
          Text(
            '${hrr!.toStringAsFixed(2)} MW  · ',
            style: TextStyle(fontSize: 12, color: renk.withAlpha(180)),
          ),
        Text(
          _fmt(sure),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: renk,
          ),
        ),
      ],
    ),
  );
}

// KKT kg → beyan + kapasite eşleşmesi
class _KktSpec {
  final String beyanA, beyanB;
  final double kapA, kapB;
  const _KktSpec({
    required this.beyanA,
    required this.beyanB,
    required this.kapA,
    required this.kapB,
  });
}

// TS EN 3-7 hesap sonuç veri sınıfı
class _En37Sonuc {
  final String beyanA, beyanB, kktA, kktB;
  final int sayi; // alan bazlı
  final int sayiEnerjiA; // enerji bazlı (Sınıf A)
  final int sayiEnerjiB; // enerji bazlı (Sınıf B)
  final double kapasiteA; // MJ/adet (Sınıf A)
  final double kapasiteB; // MJ/adet (Sınıf B)
  const _En37Sonuc({
    required this.beyanA,
    required this.beyanB,
    required this.kktA,
    required this.kktB,
    required this.sayi,
    required this.sayiEnerjiA,
    required this.sayiEnerjiB,
    required this.kapasiteA,
    required this.kapasiteB,
  });
}

// TS EN 3-7 söndürücü özellik satırı
class _En37Satir extends StatelessWidget {
  final String sinif, beyan, kkt;
  final int sayiAlan; // alan bazlı
  final int sayiEnerji; // enerji bazlı
  final double kapasite; // MJ/adet
  final Color renk;
  const _En37Satir({
    required this.sinif,
    required this.beyan,
    required this.kkt,
    required this.sayiAlan,
    required this.sayiEnerji,
    required this.kapasite,
    required this.renk,
  });
  @override
  Widget build(BuildContext context) {
    final int toplam = math.max(sayiAlan, sayiEnerji);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: renk.withOpacity(0.07),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: renk.withOpacity(0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: renk,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              sinif,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Min. Beyan: $beyan  ·  KKT: $kkt',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: renk,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Alan bazlı: $sayiAlan adet  ·  Enerji bazlı: $sayiEnerji adet',
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                ),
                Text(
                  'Kapasite ≈ ${kapasite.toStringAsFixed(0)} MJ/söndürücü',
                  style: const TextStyle(fontSize: 10, color: Colors.black38),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '≥ $toplam adet',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: renk,
                ),
              ),
              Text(
                toplam == sayiEnerji && sayiEnerji > sayiAlan
                    ? 'enerji belirleyici'
                    : 'alan belirleyici',
                style: TextStyle(fontSize: 10, color: renk.withOpacity(0.7)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Aramalı bina seçici bottom sheet
class _BinaSeciciSheet extends StatefulWidget {
  final TextEditingController araCtrl;
  final List<String> secenekler;
  final String? secilenBina;
  final Map<String, String> tehlikeMap;
  const _BinaSeciciSheet({
    required this.araCtrl,
    required this.secenekler,
    this.secilenBina,
    required this.tehlikeMap,
  });
  @override
  State<_BinaSeciciSheet> createState() => _BinaSeciciSheetState();
}

class _BinaSeciciSheetState extends State<_BinaSeciciSheet> {
  List<String> _filtreli = [];

  static const _grupSirasi = ['D', 'O', 'Y', '?'];
  String _grupAdi(String group, AppLocalizations l10n) => switch (group) {
    'D' => l10n.lowHazardAppendix,
    'O' => l10n.ordinaryHazardAppendix,
    'Y' => l10n.highHazardAppendix,
    _ => l10n.unclassified,
  };
  static const _grupRenk = {
    'D': Color(0xFF16A34A),
    'O': Color(0xFFD97706),
    'Y': Color(0xFFDC2626),
    '?': Color(0xFF6B7280),
  };

  @override
  void initState() {
    super.initState();
    _filtreli = widget.secenekler;
    widget.araCtrl.addListener(_filtrele);
  }

  void _filtrele() {
    final q = widget.araCtrl.text.toLowerCase();
    setState(() {
      _filtreli = q.isEmpty
          ? widget.secenekler
          : widget.secenekler
                .where(
                  (s) =>
                      '${_binaGorunenAd(s, AppLocalizations.of(context)!)} ${_grupAdi(widget.tehlikeMap[s] ?? '?', AppLocalizations.of(context)!)}'
                          .toLowerCase()
                          .contains(q),
                )
                .toList();
    });
  }

  @override
  void dispose() {
    widget.araCtrl.removeListener(_filtrele);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.65,
      maxChildSize: 0.92,
      minChildSize: 0.4,
      builder: (ctx, scrollCtrl) => Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: widget.araCtrl,
              autofocus: true,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.searchBuildingTypes,
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: widget.araCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () => widget.araCtrl.clear(),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _filtreli.isEmpty
                ? Center(
                    child: Text(
                      AppLocalizations.of(context)!.noResults,
                      style: TextStyle(color: Colors.black45),
                    ),
                  )
                : Builder(
                    builder: (_) {
                      final gruplu = <String, List<String>>{
                        for (final g in _grupSirasi) g: [],
                      };
                      for (final item in _filtreli) {
                        final g = widget.tehlikeMap[item] ?? '?';
                        (gruplu[g] ?? gruplu['?']!).add(item);
                      }
                      final rows = <(String, bool)>[];
                      for (final g in _grupSirasi) {
                        final items = gruplu[g]!;
                        if (items.isEmpty) continue;
                        rows.add((g, true));
                        for (final it in items) {
                          rows.add((it, false));
                        }
                      }
                      return ListView.builder(
                        controller: scrollCtrl,
                        itemCount: rows.length,
                        itemBuilder: (_, i) {
                          final (text, isHeader) = rows[i];
                          if (isHeader) {
                            final ad = _grupAdi(
                              text,
                              AppLocalizations.of(context)!,
                            );
                            final renk = _grupRenk[text] ?? Colors.black54;
                            return Container(
                              width: double.infinity,
                              color: renk.withOpacity(0.08),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              child: Text(
                                ad,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: renk,
                                ),
                              ),
                            );
                          }
                          final item = text;
                          final secili = item == widget.secilenBina;
                          return ListTile(
                            dense: true,
                            selected: secili,
                            selectedTileColor: const Color(
                              0xFF0F766E,
                            ).withOpacity(0.08),
                            leading: Icon(
                              Icons.domain_rounded,
                              size: 18,
                              color: secili
                                  ? const Color(0xFF0F766E)
                                  : Colors.black38,
                            ),
                            title: Text(
                              _binaGorunenAd(
                                item,
                                AppLocalizations.of(context)!,
                              ),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: secili
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: secili
                                    ? const Color(0xFF0F766E)
                                    : Colors.black87,
                              ),
                            ),
                            trailing: secili
                                ? const Icon(
                                    Icons.check_circle_rounded,
                                    color: Color(0xFF0F766E),
                                    size: 18,
                                  )
                                : null,
                            onTap: () => Navigator.pop(context, item),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// TS EN 3-7 bilgi satırı
Widget _En37BilgiSatir(String baslik, String deger) => Padding(
  padding: const EdgeInsets.only(bottom: 3),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        '• ',
        style: TextStyle(color: Color(0xFF78350F), fontSize: 11),
      ),
      Expanded(
        child: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 11, color: Colors.black87),
            children: [
              TextSpan(
                text: '$baslik: ',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF78350F),
                ),
              ),
              TextSpan(text: deger),
            ],
          ),
        ),
      ),
    ],
  ),
);

class _MalzemeSatir extends StatefulWidget {
  final _Malzeme malzeme;
  final Map<String, double> ncvMap;
  final Map<String, String> kategoriMap;
  final VoidCallback? onSil;
  final VoidCallback onDegisti;
  const _MalzemeSatir({
    required this.malzeme,
    required this.ncvMap,
    required this.kategoriMap,
    required this.onSil,
    required this.onDegisti,
  });
  @override
  State<_MalzemeSatir> createState() => _MalzemeSatirState();
}

class _MalzemeSatirState extends State<_MalzemeSatir> {
  late TextEditingController _kgC, _ncvC;
  final _araCtrl = TextEditingController();
  @override
  void initState() {
    super.initState();
    _kgC = TextEditingController(
      text: widget.malzeme.kg > 0 ? widget.malzeme.kg.toString() : '',
    );
    _ncvC = TextEditingController(text: widget.malzeme.ncv.toString());
  }

  @override
  void dispose() {
    _kgC.dispose();
    _ncvC.dispose();
    _araCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const kC = Color(0xFF0F766E);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      _araCtrl.clear();
                      final sec = await showModalBottomSheet<String>(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        builder: (ctx) => _MalzemeSeciciSheet(
                          araCtrl: _araCtrl,
                          secenekler: widget.ncvMap.keys.toList(),
                          kategoriMap: widget.kategoriMap,
                          secilenMalzeme: widget.malzeme.ad,
                        ),
                      );
                      if (sec != null) {
                        setState(() {
                          widget.malzeme.ad = sec;
                          widget.malzeme.ncv = widget.ncvMap[sec] ?? 0.0;
                          _ncvC.text = widget.malzeme.ncv.toString();
                        });
                        widget.onDegisti();
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.material,
                        border: OutlineInputBorder(),
                        isDense: true,
                        labelStyle: TextStyle(color: kC),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _malzemeGorunenAd(
                                widget.malzeme.ad,
                                AppLocalizations.of(context)!,
                              ),
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_drop_down_rounded,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (widget.onSil != null) ...[
                  const SizedBox(width: 6),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.red,
                    ),
                    onPressed: widget.onSil,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _kgC,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.massKg,

                      border: OutlineInputBorder(),
                      isDense: true,
                      suffixText: 'kg',
                      labelStyle: TextStyle(fontSize: 12, color: kC),
                    ),
                    onChanged: (v) {
                      final d = double.tryParse(v.replaceAll(',', '.'));
                      if (d != null) {
                        widget.malzeme.kg = d;
                        widget.onDegisti();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _ncvC,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(
                        context,
                      )!.netCalorificValue,
                      border: OutlineInputBorder(),
                      isDense: true,
                      suffixText: 'MJ/kg',
                      labelStyle: TextStyle(fontSize: 12, color: kC),
                    ),
                    onChanged: (v) {
                      final d = double.tryParse(v.replaceAll(',', '.'));
                      if (d != null) {
                        widget.malzeme.ncv = d;
                        widget.onDegisti();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String _malzemeGorunenAd(String value, AppLocalizations l10n) =>
    switch (value) {
      'Ahşap / Kereste' => l10n.materialWoodTimber,
      'Kontrplak / MDF' => l10n.materialPlywoodMdf,
      'Kâğıt / Karton' => l10n.materialPaperCardboard,
      'Tekstil (pamuklu)' => l10n.materialCottonTextile,
      'Tekstil (sentetik)' => l10n.materialSyntheticTextile,
      'Yün' => l10n.materialWool,
      'Giysi' => l10n.materialClothing,
      'Deri' => l10n.materialLeather,
      'Polietilen (PE)' => l10n.materialPolyethylene,
      'Polipropilen (PP)' => l10n.materialPolypropylene,
      'PVC (sert)' => l10n.materialRigidPvc,
      'PVC (esnek/kablo)' => l10n.materialFlexiblePvc,
      'Polistiren (PS)' => l10n.materialPolystyrene,
      'EPS köpük' => l10n.materialEpsFoam,
      'XPS köpük' => l10n.materialXpsFoam,
      'ABS Plastik' => l10n.materialAbsPlastic,
      'PMMA (Pleksiglas)' => l10n.materialPmma,
      'Epoksi Reçine' => l10n.materialEpoxyResin,
      'Polyester Reçine (CTP/FRP)' => l10n.materialPolyesterResin,
      'Poliüretan köpük (sert)' => l10n.materialRigidPolyurethaneFoam,
      'Poliüretan köpük (esnek)' => l10n.materialFlexiblePolyurethaneFoam,
      'Kauçuk (doğal)' => l10n.materialNaturalRubber,
      'Lastik (araç)' => l10n.materialVehicleTire,
      'Benzin' => l10n.materialGasoline,
      'Dizel' => l10n.materialDiesel,
      'LPG' => l10n.materialLpg,
      'Propan' => l10n.materialPropane,
      'Doğalgaz (CNG)' => l10n.materialNaturalGasCng,
      'Metanol' => l10n.materialMethanol,
      'Etanol' => l10n.materialEthanol,
      'Aseton / Solvent (genel)' => l10n.materialAcetoneSolvent,
      'Boya / Vernik (solventli)' => l10n.materialSolventBasedPaint,
      'Asfalt / Bitüm' => l10n.materialAsphaltBitumen,
      'Kömür' => l10n.materialCoal,
      'Trafo Yağı (mineral)' => l10n.materialMineralTransformerOil,
      'Hidrolik Yağ' => l10n.materialHydraulicOil,
      'Elektrik Kablosu (PVC)' => l10n.materialPvcCable,
      'Elektrik Kablosu (XLPE)' => l10n.materialXlpeCable,
      'Li-ion Batarya' => l10n.materialLithiumIonBattery,
      'Mobilya (karma)' => l10n.materialMixedFurniture,
      'Diğer (manuel)' => l10n.materialOtherManual,
      _ => value,
    };

// Aramalı, katı/sıvı/gaz kategorilerine ayrılmış malzeme seçici bottom sheet
class _MalzemeSeciciSheet extends StatefulWidget {
  final TextEditingController araCtrl;
  final List<String> secenekler;
  final Map<String, String> kategoriMap;
  final String? secilenMalzeme;
  const _MalzemeSeciciSheet({
    required this.araCtrl,
    required this.secenekler,
    required this.kategoriMap,
    this.secilenMalzeme,
  });
  @override
  State<_MalzemeSeciciSheet> createState() => _MalzemeSeciciSheetState();
}

class _MalzemeSeciciSheetState extends State<_MalzemeSeciciSheet> {
  List<String> _filtreli = [];
  final Set<String> _acikGruplar = {};

  static const _grupSirasi = ['K', 'S', 'G', 'D'];
  String _grupAdi(String group, AppLocalizations l10n) => switch (group) {
    'K' => l10n.solid,
    'S' => l10n.liquid,
    'G' => l10n.gas,
    _ => l10n.other,
  };

  String _malzemeAdi(String value, AppLocalizations l10n) =>
      _malzemeGorunenAd(value, l10n);
  static const _grupIkon = {
    'K': Icons.widgets_rounded,
    'S': Icons.water_drop_rounded,
    'G': Icons.cloud_rounded,
    'D': Icons.help_outline_rounded,
  };
  static const _grupRenk = {
    'K': Color(0xFF0F766E),
    'S': Color(0xFF2563EB),
    'G': Color(0xFF7C3AED),
    'D': Color(0xFF6B7280),
  };

  @override
  void initState() {
    super.initState();
    _filtreli = widget.secenekler;
    widget.araCtrl.addListener(_filtrele);
    if (widget.secilenMalzeme != null) {
      _acikGruplar.add(widget.kategoriMap[widget.secilenMalzeme] ?? 'D');
    }
  }

  void _filtrele() {
    final q = widget.araCtrl.text.toLowerCase();
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _filtreli = q.isEmpty
          ? widget.secenekler
          : widget.secenekler
                .where((s) => _malzemeAdi(s, l10n).toLowerCase().contains(q))
                .toList();
    });
  }

  @override
  void dispose() {
    widget.araCtrl.removeListener(_filtrele);
    super.dispose();
  }

  Widget _grupBaslik(String g, int adet, bool acik) {
    final l10n = AppLocalizations.of(context)!;
    final ad = _grupAdi(g, l10n);
    final renk = _grupRenk[g] ?? Colors.black54;
    final ikon = _grupIkon[g] ?? Icons.circle;
    return InkWell(
      onTap: () => setState(() {
        if (_acikGruplar.contains(g)) {
          _acikGruplar.remove(g);
        } else {
          _acikGruplar.add(g);
        }
      }),
      child: Container(
        width: double.infinity,
        color: renk.withOpacity(0.08),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Icon(ikon, size: 16, color: renk),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.materialGroupCount(ad, adet),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: renk,
                ),
              ),
            ),
            AnimatedRotation(
              turns: acik ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 150),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 20,
                color: renk,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _malzemeSatiri(String item) {
    final secili = item == widget.secilenMalzeme;
    final l10n = AppLocalizations.of(context)!;
    return ListTile(
      dense: true,
      selected: secili,
      selectedTileColor: const Color(0xFF0F766E).withOpacity(0.08),
      title: Text(
        _malzemeAdi(item, l10n),
        style: TextStyle(
          fontSize: 13,
          fontWeight: secili ? FontWeight.bold : FontWeight.normal,
          color: secili ? const Color(0xFF0F766E) : Colors.black87,
        ),
      ),
      trailing: secili
          ? const Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF0F766E),
              size: 18,
            )
          : null,
      onTap: () => Navigator.pop(context, item),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.65,
      maxChildSize: 0.92,
      minChildSize: 0.4,
      builder: (ctx, scrollCtrl) => Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: widget.araCtrl,
              autofocus: true,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.searchMaterials,
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: widget.araCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () => widget.araCtrl.clear(),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _filtreli.isEmpty
                ? Center(
                    child: Text(
                      AppLocalizations.of(context)!.noResults,
                      style: TextStyle(color: Colors.black45),
                    ),
                  )
                : Builder(
                    builder: (_) {
                      final gruplu = <String, List<String>>{
                        for (final g in _grupSirasi) g: [],
                      };
                      for (final item in _filtreli) {
                        final g = widget.kategoriMap[item] ?? 'D';
                        (gruplu[g] ?? gruplu['D']!).add(item);
                      }
                      for (final g in _grupSirasi) {
                        gruplu[g]!.sort(
                          (a, b) => a.toLowerCase().compareTo(b.toLowerCase()),
                        );
                      }
                      final aramaVar = widget.araCtrl.text.isNotEmpty;
                      return ListView(
                        controller: scrollCtrl,
                        children: [
                          for (final g in _grupSirasi)
                            if (gruplu[g]!.isNotEmpty) ...[
                              _grupBaslik(
                                g,
                                gruplu[g]!.length,
                                aramaVar || _acikGruplar.contains(g),
                              ),
                              if (aramaVar || _acikGruplar.contains(g))
                                for (final item in gruplu[g]!)
                                  _malzemeSatiri(item),
                            ],
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
// YAKIT / KİMYASAL DEPO SATIRI
// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦

class _DepoSatir extends StatefulWidget {
  final _Depo depo;
  final List<String> yakitlar;
  final Map<String, List<double>> kapasiteOneri;
  final VoidCallback? onSil;
  final VoidCallback onDegisti;
  const _DepoSatir({
    required this.depo,
    required this.yakitlar,
    required this.kapasiteOneri,
    required this.onSil,
    required this.onDegisti,
  });
  @override
  State<_DepoSatir> createState() => _DepoSatirState();
}

class _DepoSatirState extends State<_DepoSatir> {
  static const Color kC = Color(0xFF0F766E);
  late final TextEditingController _miktarC;
  late final TextEditingController _adetC;

  @override
  void initState() {
    super.initState();
    _miktarC = TextEditingController(
      text: widget.depo.miktar > 0 ? widget.depo.miktar.toString() : '',
    );
    _adetC = TextEditingController(text: widget.depo.adet.toString());
  }

  @override
  void dispose() {
    _miktarC.dispose();
    _adetC.dispose();
    super.dispose();
  }

  void _setMiktar(double v) {
    widget.depo.miktar = v;
    _miktarC.text = v % 1 == 0 ? v.toInt().toString() : v.toString();
    widget.onDegisti();
  }

  @override
  Widget build(BuildContext context) {
    final oneri = widget.kapasiteOneri[widget.depo.tur] ?? [];
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Yakıt türü + sil
            Row(
              children: [
                const Icon(
                  Icons.propane_tank_rounded,
                  size: 18,
                  color: Colors.orange,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: widget.depo.tur,
                      isDense: true,
                      isExpanded: true,
                      items: widget.yakitlar
                          .map(
                            (y) => DropdownMenuItem(
                              value: y,
                              child: Text(
                                y,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) {
                          setState(() {
                            widget.depo.tur = v;
                            // Birim güncelle: LPG→ton, diğer→m³
                            widget.depo.birim = v.contains('LPG')
                                ? 'ton'
                                : widget.depo.birim;
                          });
                          widget.onDegisti();
                        }
                      },
                    ),
                  ),
                ),
                if (widget.onSil != null) ...[
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.red,
                      size: 20,
                    ),
                    onPressed: widget.onSil,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            // Hazır kapasite seçenekleri
            if (oneri.isNotEmpty) ...[
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: oneri.map((cap) {
                  final label = cap % 1 == 0
                      ? '${cap.toInt()} ${widget.depo.birim}'
                      : '$cap ${widget.depo.birim}';
                  final secili = widget.depo.miktar == cap;
                  return GestureDetector(
                    onTap: () => setState(() => _setMiktar(cap)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: secili ? kC : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: secili ? kC : const Color(0xFFCBD5E1),
                        ),
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          color: secili ? Colors.white : Colors.black87,
                          fontWeight: secili
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
            ],
            // Miktar + birim + adet
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _miktarC,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.capacityTank,
                      border: const OutlineInputBorder(),
                      isDense: true,
                      suffixText: widget.depo.birim,
                      labelStyle: const TextStyle(color: kC),
                    ),
                    onChanged: (v) {
                      final d = double.tryParse(v.replaceAll(',', '.'));
                      if (d != null) {
                        widget.depo.miktar = d;
                        widget.onDegisti();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  flex: 2,
                  child: DropdownButtonHideUnderline(
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.unit,
                        border: OutlineInputBorder(),
                        isDense: true,
                        labelStyle: TextStyle(color: kC),
                      ),
                      child: DropdownButton<String>(
                        value: widget.depo.birim,
                        isDense: true,
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(value: 'ton', child: Text('ton')),
                          DropdownMenuItem(value: 'm³', child: Text('m³')),
                        ],
                        onChanged: (v) {
                          if (v != null) {
                            setState(() => widget.depo.birim = v);
                            widget.onDegisti();
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _adetC,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.quantity,
                      border: OutlineInputBorder(),
                      isDense: true,
                      suffixText: 'adet',
                      labelStyle: TextStyle(color: kC),
                    ),
                    onChanged: (v) {
                      final n = int.tryParse(v);
                      if (n != null && n > 0) {
                        widget.depo.adet = n;
                        widget.onDegisti();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
// DAVLUMBAZ SÖNDÜRME — NFPA 17A / TS EN 15751
// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦

class _EkipmanTip {
  final String ad;
  final String altBilgi;
  final IconData ikon;
  final Color renk;
  final double hazardWeight;
  const _EkipmanTip({
    required this.ad,
    required this.altBilgi,
    required this.ikon,
    required this.renk,
    required this.hazardWeight,
  });
}

class _WetAjan {
  final String ad;
  final String standart;
  final String aciklama;
  final String oneri;
  final int etkinlik; // 1-5
  final int korozyon; // 1-5 (düşük=1, yüksek=5)
  final int maliyet; // 1-5
  final bool dusuk;
  final bool orta;
  final bool yuksek;
  const _WetAjan({
    required this.ad,
    required this.standart,
    required this.aciklama,
    required this.etkinlik,
    required this.dusuk,
    required this.orta,
    required this.yuksek,
    required this.korozyon,
    required this.maliyet,
    required this.oneri,
  });
}

class DavlumbazSondurme extends StatefulWidget {
  const DavlumbazSondurme({super.key});
  @override
  State<DavlumbazSondurme> createState() => _DavlumbazState();
}

class _DavlumbazState extends State<DavlumbazSondurme> {
  static const Color _kD = Color(0xFF0369A1);

  final _uzCtrl = TextEditingController();
  final _genCtrl = TextEditingController();
  final Map<int, int> _ekipmanSayilari = {};

  String? _hata;
  double? _sChem, _noSpr, _hazardPuan;
  String? _tehlikeSinifi, _notlar;
  String? _temizlikSikligi, _filterMesafeUyari, _fritUyari;
  int _ajanIdx = 0;
  bool _karsilastirmaAcik = false;

  static const List<_WetAjan> _wetAjanlar = [
    _WetAjan(
      ad: 'Potasyum Karbonat',
      standart: 'NFPA 17A / UL 300',
      aciklama: 'En yaygın. Yağ/yüzey yangınlarına karşı etkili.',
      etkinlik: 4,
      dusuk: true,
      orta: true,
      yuksek: true,
      korozyon: 2,
      maliyet: 2,
      oneri: 'Genel amaçlı. Her tehlike sınıfı için uygundur.',
    ),
    _WetAjan(
      ad: 'Potasyum Asetat',
      standart: 'NFPA 17A / UL 300',
      aciklama: 'Yüksek verimli. Ansul R-102, Amerex B500 sistemleri.',
      etkinlik: 5,
      dusuk: true,
      orta: true,
      yuksek: true,
      korozyon: 2,
      maliyet: 3,
      oneri: 'Yüksek tehlike için birinci tercih. En iyi söndürme verimi.',
    ),
    _WetAjan(
      ad: 'Potasyum Sitrat',
      standart: 'NFPA 17A',
      aciklama: 'Paslanmaz çelik ekipmanlara uyumlu. Korozyon riski düşük.',
      etkinlik: 4,
      dusuk: true,
      orta: true,
      yuksek: false,
      korozyon: 1,
      maliyet: 3,
      oneri: 'Paslanmaz çelik mutfak / gıda endüstrisi. Düşük–Orta tehlike.',
    ),
    _WetAjan(
      ad: 'Sodyum Bikarbonat',
      standart: 'NFPA 17A',
      aciklama: 'Eski nesil. Düşük maliyetli, sınırlı etkinlik.',
      etkinlik: 2,
      dusuk: true,
      orta: false,
      yuksek: false,
      korozyon: 3,
      maliyet: 1,
      oneri: 'Yalnızca düşük tehlike. Yüksek yağ yangınlarında yeterli değil.',
    ),
  ];

  static const Map<String, Map<String, double>> _wetChemData = {
    'Düşük': {'kimyasal': 3.0, 'nozulNo': 1.0},
    'Orta': {'kimyasal': 5.5, 'nozulNo': 2.0},
    'Yüksek': {'kimyasal': 9.0, 'nozulNo': 3.0},
  };

  static const List<_EkipmanTip> _ekipmanlar = [
    _EkipmanTip(
      ad: 'Tost / Sandviç\nMakinesi',
      altBilgi: 'Hafif',
      ikon: Icons.breakfast_dining_rounded,
      renk: Color(0xFF16A34A),
      hazardWeight: 0.3,
    ),
    _EkipmanTip(
      ad: 'Küçük Elektrikli\nFırın',
      altBilgi: 'Hafif',
      ikon: Icons.kitchen_rounded,
      renk: Color(0xFF16A34A),
      hazardWeight: 0.5,
    ),
    _EkipmanTip(
      ad: 'Konveksiyon\nFırın',
      altBilgi: 'Orta',
      ikon: Icons.kitchen_rounded,
      renk: Color(0xFFD97706),
      hazardWeight: 0.8,
    ),
    _EkipmanTip(
      ad: 'Ocak\n(1 gözlü)',
      altBilgi: 'Hafif',
      ikon: Icons.local_fire_department_rounded,
      renk: Color(0xFF16A34A),
      hazardWeight: 0.4,
    ),
    _EkipmanTip(
      ad: 'Ocak\n(2 gözlü)',
      altBilgi: 'Orta',
      ikon: Icons.local_fire_department_rounded,
      renk: Color(0xFFD97706),
      hazardWeight: 0.8,
    ),
    _EkipmanTip(
      ad: 'Ocak\n(4–6 gözlü)',
      altBilgi: 'Orta–Yüksek',
      ikon: Icons.local_fire_department_rounded,
      renk: Color(0xFFEA580C),
      hazardWeight: 1.2,
    ),
    _EkipmanTip(
      ad: 'Wok Ocağı',
      altBilgi: 'Yüksek',
      ikon: Icons.outdoor_grill_rounded,
      renk: Color(0xFFDC2626),
      hazardWeight: 1.5,
    ),
    _EkipmanTip(
      ad: 'Çift Wok\nOcağı',
      altBilgi: 'Çok Yüksek',
      ikon: Icons.outdoor_grill_rounded,
      renk: Color(0xFF991B1B),
      hazardWeight: 3.0,
    ),
    _EkipmanTip(
      ad: 'Salamander\nIzgara',
      altBilgi: 'Orta',
      ikon: Icons.set_meal_rounded,
      renk: Color(0xFFD97706),
      hazardWeight: 0.8,
    ),
    _EkipmanTip(
      ad: 'Charbroiler /\nMangal',
      altBilgi: 'Yüksek',
      ikon: Icons.outdoor_grill_rounded,
      renk: Color(0xFFDC2626),
      hazardWeight: 1.5,
    ),
    _EkipmanTip(
      ad: 'Fritöz\n(? 22 L)',
      altBilgi: 'Yüksek',
      ikon: Icons.fastfood_rounded,
      renk: Color(0xFFDC2626),
      hazardWeight: 1.5,
    ),
    _EkipmanTip(
      ad: 'Fritöz\n(> 22 L)',
      altBilgi: 'Çok Yüksek',
      ikon: Icons.fastfood_rounded,
      renk: Color(0xFF991B1B),
      hazardWeight: 3.0,
    ),
    _EkipmanTip(
      ad: 'Döner Tava\n(Devrilebilir)',
      altBilgi: 'Orta',
      ikon: Icons.dinner_dining_rounded,
      renk: Color(0xFFD97706),
      hazardWeight: 1.0,
    ),
  ];

  double _toplamHazard() => _ekipmanSayilari.entries.fold(
    0.0,
    (sum, e) => sum + e.value * _ekipmanlar[e.key].hazardWeight,
  );

  String _hesaplaTehlike() {
    final h = _toplamHazard();
    if (h < 2.0) return 'Düşük';
    if (h < 5.0) return 'Orta';
    return 'Yüksek';
  }

  static String _hoodAgentName(AppLocalizations l10n, int i) => switch (i) {
    0 => l10n.hoodAgentPotassiumCarbonateName,
    1 => l10n.hoodAgentPotassiumAcetateName,
    2 => l10n.hoodAgentPotassiumCitrateName,
    3 => l10n.hoodAgentSodiumBicarbonateName,
    _ => _wetAjanlar[i].ad,
  };

  static String _hoodAgentDesc(AppLocalizations l10n, int i) => switch (i) {
    0 => l10n.hoodAgentPotassiumCarbonateDesc,
    1 => l10n.hoodAgentPotassiumAcetateDesc,
    2 => l10n.hoodAgentPotassiumCitrateDesc,
    3 => l10n.hoodAgentSodiumBicarbonateDesc,
    _ => _wetAjanlar[i].aciklama,
  };

  static String _hoodAgentReco(AppLocalizations l10n, int i) => switch (i) {
    0 => l10n.hoodAgentPotassiumCarbonateReco,
    1 => l10n.hoodAgentPotassiumAcetateReco,
    2 => l10n.hoodAgentPotassiumCitrateReco,
    3 => l10n.hoodAgentSodiumBicarbonateReco,
    _ => _wetAjanlar[i].oneri,
  };

  void _hesapla() {
    setState(() {
      _hata = null;
      _sChem = null;
    });
    final uz = double.tryParse(_uzCtrl.text.replaceAll(',', '.'));
    final gen = double.tryParse(_genCtrl.text.replaceAll(',', '.'));
    if (uz == null || gen == null || uz <= 0 || gen <= 0) {
      setState(
        () => _hata = AppLocalizations.of(context).enterHoodLengthWidthCm,
      );
      return;
    }
    final alanM2 = (uz / 100) * (gen / 100);
    final puan = _toplamHazard();
    final tehlike = _hesaplaTehlike();
    final data = _wetChemData[tehlike]!;
    final kimyasal = data['kimyasal']! * alanM2;
    final noSpr = (data['nozulNo']! * alanM2).clamp(1.0, double.infinity);

    // NFPA 96 §11.6 Tablo 11.4 — Temizlik sıklığı
    // idx: 6=Wok, 7=ÇiftWok, 9=Charbroiler, 11=Fritöz>22L
    final bool yuksekHacim =
        (_ekipmanSayilari[6] ?? 0) > 0 ||
        (_ekipmanSayilari[7] ?? 0) > 0 ||
        (_ekipmanSayilari[9] ?? 0) > 0 ||
        (_ekipmanSayilari[11] ?? 0) > 0;
    final String temizlikSikligi = yuksekHacim
        ? '3 ayda bir (wok / charbroiler / büyük fritöz)'
        : tehlike == 'Düşük'
        ? 'Yıllık (düşük hacimli)'
        : '6 ayda bir (orta hacimli)';

    // NFPA 96 §6.2.1.2 — Charbroiler filtre mesafesi uyarısı
    final bool charbroilerVar = (_ekipmanSayilari[9] ?? 0) > 0;
    final String? filterUyari = charbroilerVar
        ? 'Charbroiler/mangal mevcut → Filtre alt kenarı ile pişirme yüzeyi arası en az 1220 mm (4 ft) (NFPA 96 §6.2.1.2)'
        : null;

    // NFPA 96 §12.1.2.4 — Fritöz açık alev mesafesi uyarısı
    final bool fritVar =
        (_ekipmanSayilari[10] ?? 0) > 0 || (_ekipmanSayilari[11] ?? 0) > 0;
    final String? fritUyari = fritVar
        ? 'Fritöz mevcut → Açık alev kaynaklarından yatayda min. 406 mm (16 in.) uzakta '
              'konumlandırılmalıdır (§12.1.2.4). Ara plaka (baffle) kullanılıyorsa '
              'min. 203 mm (8 in.) yükseklik yeterlidir (§12.1.2.5).'
        : null;

    setState(() {
      _sChem = kimyasal;
      _noSpr = noSpr;
      _hazardPuan = puan;
      _tehlikeSinifi = tehlike;
      _temizlikSikligi = temizlikSikligi;
      _filterMesafeUyari = filterUyari;
      _fritUyari = fritUyari;
      final l10nNotes = AppLocalizations.of(context)!;
      final hazardText = tehlike == 'Orta'
          ? l10nNotes.hazardMedium
          : tehlike == 'Yüksek'
          ? l10nNotes.hazardHigh
          : l10nNotes.hazardLight;
      _notlar = l10nNotes.hoodNotesText(
        _hoodAgentName(l10nNotes, _ajanIdx),
        hazardText,
        puan.toStringAsFixed(1),
        alanM2.toStringAsFixed(2),
      );
    });
    ProjeServisi.hesapVeri = jsonEncode({
      'i': {
        'uz': _uzCtrl.text,
        'gen': _genCtrl.text,
        'ajanIdx': _ajanIdx.toString(),
        'ekipman': _ekipmanSayilari.entries
            .where((e) => e.value > 0)
            .map((e) => '${e.key}:${e.value}')
            .join(','),
      },
      'r':
          '## Davlumbaz S\u00f6nd\u00fcrme Sistemi\n'
          'Uzunluk: ${_uzCtrl.text} cm  |  Geni\u015flik: ${_genCtrl.text} cm\n'
          'Ajan: ${_wetAjanlar[_ajanIdx].ad}\n'
          '## Hesap Sonu\u00e7lar\u0131\n'
          'Kimyasal: ${_sChem?.toStringAsFixed(2) ?? "-"} L  |  Nozul: ${_noSpr?.toStringAsFixed(0) ?? "-"} adet\n'
          'Tehlike S\u0131n\u0131f\u0131: ${_tehlikeSinifi ?? "-"}  |  Hazard Puan\u0131: ${_hazardPuan?.toStringAsFixed(1) ?? "-"}',
    });
    ProjeServisi.hesapSinyali.value = true;
  }

  @override
  void initState() {
    super.initState();
    final g = ProjeServisi.kayitliGirdiler;
    if (g != null) {
      ProjeServisi.kayitliGirdiler = null;
      _uzCtrl.text = g['uz'] ?? '';
      _genCtrl.text = g['gen'] ?? '';
      _ajanIdx = int.tryParse(g['ajanIdx'] ?? '0') ?? 0;
      final ekipStr = g['ekipman'] ?? '';
      if (ekipStr.isNotEmpty) {
        for (final p in ekipStr.split(',')) {
          final kv = p.split(':');
          if (kv.length == 2) {
            final k = int.tryParse(kv[0]);
            final v = int.tryParse(kv[1]);
            if (k != null && v != null && v > 0) _ekipmanSayilari[k] = v;
          }
        }
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _hesapla();
      });
    }
  }

  @override
  void dispose() {
    _uzCtrl.dispose();
    _genCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _InfoBox(
            color: const Color(0xFFEFF6FF),
            border: _kD,
            child: Text(
              l10n.hoodSystemDescription,
              style: TextStyle(
                fontSize: 11,
                height: 1.5,
                color: Color(0xFF1E40AF),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Ekipman seçimi
          Text(
            l10n.hoodEquipmentHeading,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.hoodEquipmentInstructions,
            style: TextStyle(fontSize: 11, color: Colors.black54, height: 1.4),
          ),
          const SizedBox(height: 10),
          ...List.generate(
            _ekipmanlar.length,
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: _EkipmanKarti(
                ekipman: _ekipmanlar[i],
                index: i,
                sayi: _ekipmanSayilari[i] ?? 0,
                onArtir: () => setState(
                  () => _ekipmanSayilari[i] = (_ekipmanSayilari[i] ?? 0) + 1,
                ),
                onAzalt: () {
                  if ((_ekipmanSayilari[i] ?? 0) > 0) {
                    setState(
                      () => _ekipmanSayilari[i] = _ekipmanSayilari[i]! - 1,
                    );
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Builder(
            builder: (ctx) {
              final puan = _toplamHazard();
              final sinif = _hesaplaTehlike();
              final toplam = _ekipmanSayilari.values.fold(0, (s, v) => s + v);
              final kategori = switch (sinif) {
                'Orta' => l10n.hazardMedium,
                'Yüksek' => l10n.hazardHigh,
                _ => l10n.hazardLight,
              };
              final Color sinifRenk = sinif == 'Düşük'
                  ? const Color(0xFF16A34A)
                  : sinif == 'Orta'
                  ? const Color(0xFFD97706)
                  : const Color(0xFFDC2626);
              return _InfoBox(
                color: sinifRenk.withOpacity(0.07),
                border: sinifRenk.withOpacity(0.4),
                child: Row(
                  children: [
                    Icon(Icons.bar_chart_rounded, size: 18, color: sinifRenk),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.hoodHazardClass(kategori),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: sinifRenk,
                            ),
                          ),
                          Text(
                            l10n.hoodEquipmentScore(
                              toplam,
                              puan.toStringAsFixed(1),
                            ),
                            style: TextStyle(
                              fontSize: 10,
                              color: sinifRenk.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 14),

          // Davlumbaz boyutları
          Text(
            l10n.hoodFilterArea,
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _uzCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.singleLength,
                    suffixText: 'cm',
                    border: const OutlineInputBorder(),
                    isDense: true,
                    labelStyle: const TextStyle(color: _kD),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: _kD, width: 2),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _genCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.singleWidth,
                    suffixText: 'cm',
                    border: const OutlineInputBorder(),
                    isDense: true,
                    labelStyle: const TextStyle(color: _kD),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: _kD, width: 2),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Söndürme maddesi seçimi
          DropdownButtonFormField<int>(
            value: _ajanIdx,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: l10n.extinguishingAgent,
              prefixIcon: const Icon(Icons.water_drop_rounded),
              border: const OutlineInputBorder(),
              isDense: true,
              labelStyle: const TextStyle(color: _kD),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: _kD, width: 2),
              ),
            ),
            items: List.generate(
              _wetAjanlar.length,
              (i) => DropdownMenuItem(
                value: i,
                child: Text(
                  _hoodAgentName(l10n, i),
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ),
            onChanged: (v) => setState(() => _ajanIdx = v ?? 0),
          ),
          const SizedBox(height: 4),
          Text(
            '${_wetAjanlar[_ajanIdx].standart}  ·  ${_hoodAgentDesc(l10n, _ajanIdx)}',
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
          const SizedBox(height: 6),
          // ¦¦ Karşılaştırma Paneli ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
          TextButton.icon(
            onPressed: () =>
                setState(() => _karsilastirmaAcik = !_karsilastirmaAcik),
            icon: Icon(
              _karsilastirmaAcik
                  ? Icons.expand_less_rounded
                  : Icons.expand_more_rounded,
              size: 18,
            ),
            label: Text(
              _karsilastirmaAcik
                  ? l10n.hoodHideComparison
                  : l10n.hoodCompareAgents,
              style: const TextStyle(fontSize: 12),
            ),
            style: TextButton.styleFrom(
              foregroundColor: _kD,
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          if (_karsilastirmaAcik) ...[
            const SizedBox(height: 6),
            _InfoBox(
              color: const Color(0xFFF0F9FF),
              border: const Color(0xFFBAE6FD),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Başlık satırı
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          l10n.hoodTableAgentCol,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0369A1),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          l10n.hoodTableEffectivenessCol,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0369A1),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 22,
                        child: Text(
                          l10n.hoodColLowAbbr,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0369A1),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 22,
                        child: Text(
                          l10n.hoodColMediumAbbr,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0369A1),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 22,
                        child: Text(
                          l10n.hoodColHighAbbr,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0369A1),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 8, thickness: 1),
                  // Her ajan için bir satır
                  ...List.generate(_wetAjanlar.length, (i) {
                    final a = _wetAjanlar[i];
                    final secili = i == _ajanIdx;
                    final sinif =
                        _tehlikeSinifi; // 'Düşük','Orta','Yüksek' veya null
                    Color uygunRenk(bool flag, String hedef) {
                      if (sinif == hedef) {
                        return flag
                            ? const Color(0xFF16A34A)
                            : const Color(0xFFDC2626);
                      }
                      return flag
                          ? const Color(0xFF22C55E)
                          : const Color(0xFF94A3B8);
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 6,
                      ),
                      decoration: BoxDecoration(
                        color: secili
                            ? const Color(0xFFE0F2FE)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        border: secili
                            ? Border.all(
                                color: const Color(0xFF0369A1),
                                width: 1.5,
                              )
                            : null,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  _hoodAgentName(l10n, i),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: secili
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: secili
                                        ? const Color(0xFF0C4A6E)
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Row(
                                  children: List.generate(
                                    5,
                                    (s) => Icon(
                                      s < a.etkinlik
                                          ? Icons.star_rounded
                                          : Icons.star_outline_rounded,
                                      size: 12,
                                      color: s < a.etkinlik
                                          ? const Color(0xFFF59E0B)
                                          : Colors.black26,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 22,
                                child: Icon(
                                  a.dusuk
                                      ? Icons.check_circle_rounded
                                      : Icons.cancel_rounded,
                                  size: 15,
                                  color: uygunRenk(a.dusuk, 'Düşük'),
                                ),
                              ),
                              SizedBox(
                                width: 22,
                                child: Icon(
                                  a.orta
                                      ? Icons.check_circle_rounded
                                      : Icons.cancel_rounded,
                                  size: 15,
                                  color: uygunRenk(a.orta, 'Orta'),
                                ),
                              ),
                              SizedBox(
                                width: 22,
                                child: Icon(
                                  a.yuksek
                                      ? Icons.check_circle_rounded
                                      : Icons.cancel_rounded,
                                  size: 15,
                                  color: uygunRenk(a.yuksek, 'Yüksek'),
                                ),
                              ),
                            ],
                          ),
                          if (secili) ...[
                            const SizedBox(height: 3),
                            Text(
                              _hoodAgentReco(l10n, i),
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF0369A1),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }),
                  const Divider(height: 8, thickness: 1),
                  Text(
                    l10n.hoodComparisonLegend,
                    style: const TextStyle(fontSize: 9, color: Colors.black45),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),

          if (_hata != null) ...[
            _InfoBox(
              color: const Color(0xFFFEE2E2),
              border: const Color(0xFFFCA5A5),
              child: Text(
                _hata!,
                style: const TextStyle(color: Color(0xFFDC2626), fontSize: 13),
              ),
            ),
            const SizedBox(height: 8),
          ],

          ElevatedButton.icon(
            onPressed: _hesapla,
            icon: const Icon(Icons.calculate_rounded),
            label: Text(AppLocalizations.of(context)!.calculate),
            style: ElevatedButton.styleFrom(
              backgroundColor: _kD,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          if (_sChem != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _kD, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.hoodResultTitleCaps,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF0369A1),
                      letterSpacing: 0.8,
                    ),
                  ),
                  const Divider(height: 16),
                  if (_tehlikeSinifi != null) ...[
                    _SonucSatirMavi(
                      etiket: l10n.hoodHazardClass(''),
                      deger:
                          '${_tehlikeSinifi == "Orta"
                              ? l10n.hazardMedium
                              : _tehlikeSinifi == "Yüksek"
                              ? l10n.hazardHigh
                              : l10n.hazardLight}  (score: ${_hazardPuan!.toStringAsFixed(1)})',
                    ),
                    const SizedBox(height: 4),
                  ],
                  _SonucSatirMavi(
                    etiket: l10n.extinguishingAgent,
                    deger: _hoodAgentName(l10n, _ajanIdx),
                  ),
                  const SizedBox(height: 4),
                  _SonucSatirMavi(
                    etiket: l10n.chemicalAgentAmount,
                    deger: '${_sChem!.toStringAsFixed(1)} L',
                  ),
                  const SizedBox(height: 4),
                  _SonucSatirMavi(
                    etiket: l10n.minimumNozzleCount,
                    deger: '${_noSpr!.ceil()} adet',
                  ),
                  const SizedBox(height: 4),
                  _SonucSatirMavi(
                    etiket: l10n.minimumDischargeTime,
                    deger: '30 s',
                  ),
                  const SizedBox(height: 10),
                  _InfoBox(
                    color: const Color(0xFFF0FDF4),
                    border: const Color(0xFF86EFAC),
                    child: Text(
                      _notlar!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF166534),
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // ── NFPA 96 Zorunlu Gereklilikler ──────────────────
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFFBD38D),
                        width: 1.2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.checklist_rounded,
                              size: 15,
                              color: Color(0xFF92400E),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              l10n.hoodNfpa96RequirementsTitle,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Color(0xFF92400E),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _Nfpa96Satir(
                          ikon: Icons.electrical_services_rounded,
                          metin: l10n.hoodReqFuelElectric,
                        ),
                        _Nfpa96Satir(
                          ikon: Icons.settings_backup_restore_rounded,
                          metin: l10n.hoodReqManualPull,
                        ),
                        _Nfpa96Satir(
                          ikon: Icons.campaign_rounded,
                          metin: l10n.hoodReqAlarm,
                        ),
                        _Nfpa96Satir(
                          ikon: Icons.air_rounded,
                          metin: l10n.hoodReqFanMakeupAir,
                        ),
                        _Nfpa96Satir(
                          ikon: Icons.fire_extinguisher_rounded,
                          metin: l10n.hoodReqClassKExtinguisher,
                        ),
                        _Nfpa96Satir(
                          ikon: Icons.filter_alt_rounded,
                          metin: l10n.hoodReqFilterDistance(
                            _filterMesafeUyari != null
                                ? '\n⚠ ${l10n.hoodFilterDistanceWarning}'
                                : '',
                          ),
                          vurgu: _filterMesafeUyari != null,
                        ),
                        _Nfpa96Satir(
                          ikon: Icons.build_rounded,
                          metin: l10n.hoodReqMaintenance,
                        ),
                        _Nfpa96Satir(
                          ikon: Icons.cleaning_services_rounded,
                          metin: l10n.hoodReqCleaningFrequency(
                            _temizlikSikligi == '3 ayda bir (wok / charbroiler / büyük fritöz)'
                                ? l10n.hoodCleaningFreqHighVolume
                                : _temizlikSikligi == 'Yıllık (düşük hacimli)'
                                ? l10n.hoodCleaningFreqLow
                                : l10n.hoodCleaningFreqMedium,
                          ),
                        ),
                        _Nfpa96Satir(
                          ikon: Icons.link_rounded,
                          metin: l10n.hoodReqSimultaneousOperation,
                        ),
                        _Nfpa96Satir(
                          ikon: Icons.fastfood_rounded,
                          metin: l10n.hoodReqFryerDistance(
                            _fritUyari != null
                                ? '\n⚠ ${l10n.hoodFryerDistanceWarning}'
                                : '',
                          ),
                          vurgu: _fritUyari != null,
                        ),
                        _Nfpa96Satir(
                          ikon: Icons.thermostat_rounded,
                          metin: l10n.hoodReqFryerHighTempLimiter,
                        ),
                        _Nfpa96Satir(
                          ikon: Icons.straighten_rounded,
                          metin: l10n.hoodReqHoodDuctClearance,
                        ),
                        _Nfpa96Satir(
                          ikon: Icons.architecture_rounded,
                          metin: l10n.hoodReqDuctSlope,
                        ),
                        _Nfpa96Satir(
                          ikon: Icons.domain_rounded,
                          metin: l10n.hoodReqDuctFireBarrier,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 20),
          const _DavlumbazStandartOzet(),
        ],
      ),
    );
  }
}

// ─── NFPA 96 zorunlu madde satırı ───────────────────────────────
class _Nfpa96Satir extends StatelessWidget {
  final IconData ikon;
  final String metin;
  final bool vurgu;
  const _Nfpa96Satir({
    required this.ikon,
    required this.metin,
    this.vurgu = false,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          ikon,
          size: 13,
          color: vurgu ? const Color(0xFFDC2626) : const Color(0xFFF97316),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            metin,
            style: TextStyle(
              fontSize: 10.5,
              height: 1.45,
              color: vurgu ? const Color(0xFFB91C1C) : const Color(0xFF78350F),
            ),
          ),
        ),
      ],
    ),
  );
}

class _DavlumbazStandartOzet extends StatelessWidget {
  const _DavlumbazStandartOzet();
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = [
      ('NFPA 96 (2014)', l10n.hoodStdNfpa96Desc),
      ('NFPA 17A', l10n.hoodStdNfpa17aDesc),
      ('TS EN 15751', l10n.hoodStdTsEn15751Desc),
      ('UL 300', l10n.hoodStdUl300Desc),
      ('TS EN 1825-1/2', l10n.hoodStdTsEn1825Desc),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.sourceStandards,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        ...items.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _InfoBox(
              color: const Color(0xFFF8FAFC),
              border: const Color(0xFFCBD5E1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.$1,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF0369A1),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    e.$2,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _EkipmanKarti extends StatelessWidget {
  final _EkipmanTip ekipman;
  final int index;
  final int sayi;
  final VoidCallback onArtir;
  final VoidCallback onAzalt;

  const _EkipmanKarti({
    required this.ekipman,
    required this.index,
    required this.sayi,
    required this.onArtir,
    required this.onAzalt,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final equipmentName = switch (index) {
      0 => l10n.hoodToastSandwichMachine,
      1 => l10n.hoodSmallElectricOven,
      2 => l10n.hoodConvectionOven,
      3 => l10n.hoodSingleBurnerRange,
      4 => l10n.hoodDoubleBurnerRange,
      5 => l10n.hoodFourToSixBurnerRange,
      6 => l10n.hoodWokRange,
      7 => l10n.hoodDoubleWokRange,
      8 => l10n.hoodSalamanderGrill,
      9 => l10n.hoodCharbroilerGrill,
      10 => l10n.hoodFryerUpTo22L,
      11 => l10n.hoodFryerOver22L,
      12 => l10n.hoodTiltingSkillet,
      _ => ekipman.ad.replaceAll('\n', ' '),
    };
    final hazardName = switch (index) {
      0 || 1 || 3 => l10n.hazardLight,
      2 || 4 || 8 || 12 => l10n.hazardMedium,
      5 => l10n.hazardMediumHigh,
      6 || 9 || 10 => l10n.hazardHigh,
      7 || 11 => l10n.hazardVeryHigh,
      _ => ekipman.altBilgi,
    };
    final secili = sayi > 0;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: secili ? ekipman.renk.withOpacity(0.08) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: secili ? ekipman.renk : const Color(0xFFE5E7EB),
          width: secili ? 2 : 1,
        ),
        boxShadow: secili
            ? [
                BoxShadow(
                  color: ekipman.renk.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: secili
                    ? ekipman.renk.withOpacity(0.15)
                    : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                ekipman.ikon,
                color: secili ? ekipman.renk : Colors.grey,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    equipmentName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: secili ? ekipman.renk : Colors.black87,
                    ),
                  ),
                  Text(
                    hazardName,
                    style: TextStyle(
                      fontSize: 10,
                      color: secili
                          ? ekipman.renk.withOpacity(0.7)
                          : Colors.black38,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _CountBtn(
                  icon: Icons.remove_rounded,
                  color: secili ? ekipman.renk : Colors.grey,
                  onTap: sayi > 0 ? onAzalt : null,
                ),
                const SizedBox(width: 6),
                SizedBox(
                  width: 24,
                  child: Text(
                    '$sayi',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: secili ? ekipman.renk : Colors.black38,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                _CountBtn(
                  icon: Icons.add_rounded,
                  color: ekipman.renk,
                  onTap: onArtir,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CountBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _CountBtn({required this.icon, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: onTap != null
            ? color.withOpacity(0.12)
            : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: onTap != null
              ? color.withOpacity(0.4)
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: Icon(
        icon,
        size: 14,
        color: onTap != null ? color : Colors.grey.shade300,
      ),
    ),
  );
}

// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
// GAZLI SÖNDÜRME SİSTEMİ — ISO 14520 / NFPA 2001
// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦

class _GazAjanData {
  final String ad, standart, aciklama, silindirBirim;
  final bool inert;
  final double konsanA, konsanADerin, konsanB, konsanC;
  final double? spesifik20; // m³/kg — halokarbon için k1 (S = k1 + k2×T)
  final double? spesifK2; // S sıcaklık katsayısı k2 — EN 15004 serisi
  final double
  noael; // % — NFPA 2001:2022 Tablo 5.6.2.1 — negatif = insan bulunmayan hacimler
  final double
  loael; // % — NFPA 2001:2022 Tablo 5.6.2.1 — tahliye zorunlu sınır
  final double silindirKapasite;
  final double?
  rhoLiquid; // kg/m³ — boru içi sıvı yoğunluk (halokarbon ajanlar için)

  const _GazAjanData({
    required this.ad,
    required this.standart,
    required this.aciklama,
    required this.silindirBirim,
    required this.inert,
    required this.konsanA,
    required this.konsanADerin,
    required this.konsanB,
    required this.konsanC,
    this.spesifik20,
    this.spesifK2,
    required this.noael,
    required this.loael,
    required this.silindirKapasite,
    this.rhoLiquid,
  });
}

class _GazSonucSatir extends StatelessWidget {
  final String etiket, deger;
  const _GazSonucSatir({required this.etiket, required this.deger});

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Icon(Icons.fiber_manual_record, size: 8, color: Color(0xFF0891B2)),
      const SizedBox(width: 6),
      Expanded(
        child: Text(
          etiket,
          style: const TextStyle(fontSize: 13, color: Color(0xFF0891B2)),
        ),
      ),
      Text(
        deger,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: Color(0xFF0891B2),
        ),
      ),
    ],
  );
}

// NFPA 2001:2022 gereklilik satırı
class _GazNfpaSatir extends StatelessWidget {
  final String metin;
  const _GazNfpaSatir(this.metin, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_circle_outline_rounded,
          size: 13,
          color: Color(0xFFF97316),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            metin,
            style: const TextStyle(
              fontSize: 10.5,
              height: 1.45,
              color: Color(0xFF78350F),
            ),
          ),
        ),
      ],
    ),
  );
}

/// Yangın sınıfı A / AD için madde listesi açıklama kutusu
class _GazSinifAciklama extends StatelessWidget {
  final String baslik;
  final List<String> maddeler;
  final String kaynak;
  const _GazSinifAciklama({
    required this.baslik,
    required this.maddeler,
    required this.kaynak,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(
      color: const Color(0xFFF0F9FF),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: const Color(0xFFBAE6FD)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          baslik,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0369A1),
          ),
        ),
        const SizedBox(height: 4),
        ...maddeler.map(
          (m) => Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '├ ',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF0369A1),
                    fontFamily: 'monospace',
                  ),
                ),
                Expanded(
                  child: Text(
                    m,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF0C4A6E),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          kaynak,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.black38,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    ),
  );
}

/// Nozul / boru bilgi kartı içindeki küçük bilgi kutusu
class _GazBilgiKutu extends StatelessWidget {
  final String etiket, deger, alt;
  final Color renk;
  const _GazBilgiKutu({
    required this.etiket,
    required this.deger,
    required this.alt,
    required this.renk,
  });
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: renk.withOpacity(0.08),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: renk.withOpacity(0.3)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          etiket,
          style: TextStyle(fontSize: 10, color: renk.withOpacity(0.7)),
        ),
        const SizedBox(height: 2),
        Text(
          deger,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: renk,
          ),
        ),
        if (alt.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            alt,
            style: TextStyle(
              fontSize: 9.5,
              color: renk.withOpacity(0.65),
              height: 1.3,
            ),
          ),
        ],
      ],
    ),
  );
}

class GazliSondurme extends StatefulWidget {
  const GazliSondurme({super.key});

  @override
  State<GazliSondurme> createState() => _GazliSondurmeState();
}

class _GazliSondurmeState extends State<GazliSondurme>
    with SingleTickerProviderStateMixin {
  static const Color _kGaz = Color(0xFF0891B2);

  late final TabController _tabCtrl = TabController(length: 3, vsync: this);

  bool _olcuModu = true;
  final _wCtrl = TextEditingController();
  final _lCtrl = TextEditingController();
  final _hCtrl = TextEditingController();
  final _vCtrl = TextEditingController();
  final _tCtrl = TextEditingController(text: '20');
  final _rakimCtrl = TextEditingController();
  bool _rakimGoster = false;
  bool _guvenlikPayi = true;
  String _yanginSinifi = 'A';
  int _ajanIdx = 0;
  final _desarjCtrl = TextEditingController(text: '60');
  late final _konsanCtrl = TextEditingController(
    text: _ajanlar[0].konsanA.toStringAsFixed(1),
  );

  void _konsanGuncelle() {
    final ajan = _ajanlar[_ajanIdx];
    final def = _yanginSinifi == 'A'
        ? ajan.konsanA
        : _yanginSinifi == 'AD'
        ? ajan.konsanADerin
        : _yanginSinifi == 'B'
        ? ajan.konsanB
        : ajan.konsanC;
    _konsanCtrl.text = def.toStringAsFixed(1);
  }

  // (nominal_mm, min_kg_s, max_kg_s) — üretici nozul akış tablosundan
  static const List<(int, double, double)> _nozulTablosu = [
    (10, 0.3, 1.0),
    (15, 0.6, 1.6),
    (20, 1.1, 2.7),
    (25, 1.9, 3.9),
    (32, 3.4, 6.0),
    (40, 4.7, 9.0),
    (50, 7.8, 16.0),
  ];

  static const List<(int, double)> _dnTablosu = [
    (15, 15.8),
    (20, 21.9),
    (25, 27.3),
    (32, 36.0),
    (40, 41.8),
    (50, 53.1),
    (65, 68.9),
    (80, 82.5),
    (100, 107.1),
    (125, 133.0),
    (150, 158.3),
  ];

  static const List<_GazAjanData> _ajanlar = [
    _GazAjanData(
      ad: 'HFC-227ea (FM-200)',
      standart: 'TS EN 15004-5:2020 / NFPA 2001',
      inert: false,
      konsanA: 7.9, // Tablo 4: Yüzey A — min. tasarım %7,9
      konsanADerin: 8.5, // Tablo 4: Higher Hazard Class A — min. tasarım %8,5
      konsanB: 9.0, // Tablo 4: Sınıf B (heptan) — min. tasarım %9,0
      konsanC: 7.9, // NFPA 2001 §4.3: Sınıf C = Sınıf A konsantrasyonu
      spesifik20: 0.1269, // k1 — S = k1 + k2×T (EN 15004-5 §6.3 Tablo 3)
      spesifK2: 0.000513, // k2 — S = 0.1269 + 0.000513×T → @20°C: 0.1374 m³/kg
      noael: 9.0, // Tablo 5: NOAEL = %9,0
      loael: 10.5, // Tablo 5: LOAEL = %10,5
      silindirKapasite: 100.0,
      silindirBirim: 'kg',
      rhoLiquid: 1410.0, // kg/m³ — 20°C sıvı yoğunluğu (ISO 14520-9 §6.3)
      aciklama:
          'Sıvılaşmış halokarbon. 25/42/50 bar N₂ şişeleme. '
          'Maks. dolum yoğunluğu 1150 kg/m³. '
          'Elektrik/elektronik odalar için idealdir. (EN 15004-5 Tablo 6-8)',
    ),
    _GazAjanData(
      ad: 'FK-5-1-12 (Novec 1230)',
      standart: 'TS EN 15004-6 / NFPA 2001',
      inert: false,
      konsanA: 4.2,
      konsanADerin: 4.2,
      konsanB: 5.9,
      konsanC: 4.2, // NFPA 2001 §4.3: Sınıf C = Sınıf A konsantrasyonu
      spesifik20: 0.0664,
      noael: 10.0,
      loael: 10.0,
      silindirKapasite: 80.0,
      silindirBirim: 'kg',
      rhoLiquid: 1616.0, // kg/m³ — 20°C sıvı yoğunluğu (3M/Kidde teknik veri)
      aciklama: 'Düşük GWP. Hassas ekipman odaları, arşivler, müzeler.',
    ),
    _GazAjanData(
      ad: 'CO² (Karbondioksit)',
      standart: 'TS EN 15004-2 / NFPA 12',
      inert: false,
      konsanA: 34.0, // NFPA 12 §5.3.2 / EN 15004-2: min. %34 Sınıf A yüzey
      konsanADerin: 50.0, // NFPA 12 §5.4.2: derin yerleşik yangın min. %50
      konsanB:
          37.0, // NFPA 12 Tablo A.5.3.2.1: toluen/benzen ref. %37; heptan %34, IPA/etanol %53
      konsanC: 34.0, // Sınıf A konsantrasyonu
      spesifik20: 0.5685,
      noael: -1.0,
      loael: -1.0,
      silindirKapasite: 45.0,
      silindirBirim: 'kg',
      rhoLiquid:
          775.0, // kg/m³ — 20°C doyma noktası sıvı CO₂ (~57 bar, NFPA 12)
      aciklama:
          'Toplam taşkın — YALNIZCA insan bulunmayan hacimler. '
          'Sınıf B konsantrasyonu yakıta özel: heptan %34, toluen/benzen %37, '
          'etil asetat %38, MEK %40, IPA/etanol/metanol %53 (NFPA 12 Tablo A.5.3.2.1).',
    ),
    _GazAjanData(
      ad: 'IG-541 (Inergen)',
      standart: 'TS EN 15004-9 / NFPA 2001',
      inert: true,
      konsanA: 38.5,
      konsanADerin: 38.5,
      konsanB: 40.0,
      konsanC: 38.5,
      noael: 43.0, // NFPA 2001:2022 Tablo 5.6.2.1 (~8% O₂ eşdeğeri)
      loael: 52.0, // NFPA 2001:2022 Tablo 5.6.2.1
      silindirKapasite: 14.9,
      silindirBirim: 'Nm³',
      aciklama:
          'N²/Ar/CO² (52/40/8) karışımı. Oksijen seyreltme. İnsan varlığında kullanılabilir.',
    ),
    _GazAjanData(
      ad: 'IG-55 (Argonite)',
      standart: 'TS EN 15004-10 / NFPA 2001',
      inert: true,
      konsanA: 38.5,
      konsanADerin: 38.5,
      konsanB: 43.0,
      konsanC: 38.5,
      noael: 43.0, // NFPA 2001:2022 Tablo 5.6.2.1
      loael: 52.0,
      silindirKapasite: 14.9,
      silindirBirim: 'Nm³',
      aciklama:
          'N²/Ar (50/50) karışımı. Çevre dostu. İnsan varlığında kullanılabilir.',
    ),
    _GazAjanData(
      ad: 'IG-100 (Azot)',
      standart: 'TS EN 15004-8 / NFPA 2001',
      inert: true,
      konsanA: 38.0,
      konsanADerin: 38.0,
      konsanB: 43.0,
      konsanC: 38.0,
      noael: 43.0, // NFPA 2001:2022 Tablo 5.6.2.1
      loael: 52.0,
      silindirKapasite: 14.9,
      silindirBirim: 'Nm³',
      aciklama: 'Saf azot. Oksijen seyreltme. Kolay temin edilebilir.',
    ),
    _GazAjanData(
      ad: 'IG-01 (Argon)',
      standart: 'TS EN 15004-7:2009 / NFPA 2001',
      inert: true,
      konsanA: 41.9, // Çizelge 4: Yüzey sınıfı A — asg. tasarım %41,9
      konsanADerin: 49.2, // Çizelge 4: Yüksek tehlike sınıfı A — asg. %49,2
      konsanB: 51.7, // Çizelge 4: Sınıf B (heptan) — asg. tasarım %51,7
      konsanC: 41.9,
      spesifik20: 0.56119, // k1 — S = k1 + k2×T (TS EN 15004-7 §6.3 Çizelge 3)
      spesifK2: 0.0020545, // k2 — S@20°C = 0,56119 + 0,0020545×20 ≈ 0,602 m³/kg
      noael: 43.0, // Çizelge 5: NOAEL = %43 (≈ O₂ min %12)
      loael: 52.0, // Çizelge 5: LOAEL = %52 (≈ O₂ min %10)
      silindirKapasite: 14.9,
      silindirBirim: 'Nm³',
      aciklama:
          'Saf argon. Oksijen seyreltme ile söndürme. '
          '160 / 200 / 300 bar şişeleme. '
          'Kimyasal kalıntı bırakmaz. İnsan varlığında kullanılabilir. '
          '(TS EN 15004-7 Çizelge 6-8)',
    ),
  ];

  static String gazAgentDesc(AppLocalizations l10n, int i) => switch (i) {
    0 => l10n.gasAgentHfc227Desc,
    1 => l10n.gasAgentFk512Desc,
    2 => l10n.gasAgentCo2Desc,
    3 => l10n.gasAgentIg541Desc,
    4 => l10n.gasAgentIg55Desc,
    5 => l10n.gasAgentIg100Desc,
    6 => l10n.gasAgentIg01Desc,
    _ => _ajanlar[i].aciklama,
  };

  String? _hata;
  double? _netHacim, _konsantrasyon, _ajanMiktar, _silindirSayisi;
  String? _noaelUyari;
  double? _boruCapMin, _boruAkisHizi, _akisDebiM3s, _akisKgs;
  int? _boruDN;
  // Nozul & dağıtım borusu
  int? _nozulSayisi;
  int?
  _nozulBoreIdx; // null = otomatik (alan/hacim), aksi = _nozulTablosu indeksi
  double? _nozulAkisKgs; // kg/s — nozul başına kütle debisi
  int? _dalBoruDN;
  double? _dalBoruHizi, _dalBoruCapMin;
  double? _tahminiBoruMetraj; // m — sadece ölçü modunda

  void _hesapla() {
    setState(() {
      _hata = null;
      _netHacim = null;
      _ajanMiktar = null;
    });

    double v;
    if (_olcuModu) {
      final w = double.tryParse(_wCtrl.text.replaceAll(',', '.'));
      final l = double.tryParse(_lCtrl.text.replaceAll(',', '.'));
      final h = double.tryParse(_hCtrl.text.replaceAll(',', '.'));
      if (w == null || l == null || h == null || w <= 0 || l <= 0 || h <= 0) {
        setState(
          () => _hata = AppLocalizations.of(context).enterRoomDimensionsFullyM,
        );
        return;
      }
      v = w * l * h;
    } else {
      final vv = double.tryParse(_vCtrl.text.replaceAll(',', '.'));
      if (vv == null || vv <= 0) {
        setState(
          () => _hata = AppLocalizations.of(context).enterNetProtectedVolumeM3,
        );
        return;
      }
      v = vv;
    }

    final tVal = double.tryParse(_tCtrl.text.replaceAll(',', '.')) ?? 20.0;
    final rakimM = _rakimGoster
        ? (double.tryParse(_rakimCtrl.text.replaceAll(',', '.')) ?? 0.0)
        : 0.0;
    final kf = rakimM > 0
        ? (101.325 / (101.325 * math.exp(-rakimM / 8400)))
        : 1.0;

    final ajan = _ajanlar[_ajanIdx];
    final cParsed = double.tryParse(_konsanCtrl.text.replaceAll(',', '.'));
    if (cParsed == null || cParsed <= 0 || cParsed >= 100) {
      setState(
        () =>
            _hata = AppLocalizations.of(context).enterValidConcentrationPercent,
      );
      return;
    }
    final c = cParsed;

    double miktar;
    if (ajan.inert) {
      // ISO 14520-1 Ek A: X[Nm³] = V × ln[100/(100-C)] × (273.15/(273.15+T))
      miktar = v * math.log(100 / (100 - c)) * (273.15 / (273.15 + tVal));
    } else {
      // ISO 14520-1 §A.1: W = (V/s(T)) × [C/(100-C)] × kf
      // s(T) = s° × (273.15+T) / 293.15
      // EN 15004-5 §6.3: S = k1 + k2×T (doğrusal formül, T °C cinsinden)
      // Diğer ajanlar için ideal gaz yaklaşımı: S(T) = S₂₀ × (273+T) / 293
      final sT = ajan.spesifK2 != null
          ? ajan.spesifik20! + ajan.spesifK2! * tVal
          : ajan.spesifik20! * (273.15 + tVal) / 293.15;
      miktar = (v / sT) * (c / (100 - c)) * kf;
    }
    if (_guvenlikPayi) miktar *= 1.10;

    final silindirSayisi = (miktar / ajan.silindirKapasite).ceil().toDouble();

    final l10nCalc = AppLocalizations.of(context);
    final String noaelUyari;
    if (ajan.noael < 0) {
      noaelUyari = l10nCalc.gasNoaelCo2Warning;
    } else if (c >= ajan.loael && ajan.loael > 0) {
      noaelUyari = l10nCalc.gasNoaelLoaelExceeded(
        c.toStringAsFixed(1),
        ajan.loael.toStringAsFixed(1),
      );
    } else if (c >= ajan.noael) {
      noaelUyari = l10nCalc.gasNoaelReached(
        c.toStringAsFixed(1),
        ajan.noael.toStringAsFixed(1),
      );
    } else {
      noaelUyari = l10nCalc.gasNoaelOk(
        c.toStringAsFixed(1),
        ajan.noael.toStringAsFixed(1),
        ajan.loael.toStringAsFixed(1),
      );
    }

    setState(() {
      _netHacim = v;
      _konsantrasyon = c;
      _ajanMiktar = miktar;
      _silindirSayisi = silindirSayisi;
      _noaelUyari = noaelUyari;
      _boruCapMin = null;
      _boruDN = null;
      _akisDebiM3s = null;
      _akisKgs = null;
      _nozulAkisKgs = null;
      _nozulSayisi = null;
      _dalBoruDN = null;
      _dalBoruHizi = null;
      _dalBoruCapMin = null;
      _tahminiBoruMetraj = null;
    });

    // Boru çapı hesabı
    final tSure = double.tryParse(_desarjCtrl.text.replaceAll(',', '.'));
    if (tSure != null && tSure > 0) {
      final tVal2 = double.tryParse(_tCtrl.text.replaceAll(',', '.')) ?? 20.0;
      // Kütle debisi (her iki ajan türü için ortak)
      final massFlowKgs = miktar / tSure; // kg/s

      // ── Boru içi volumetrik debi ve hız limiti belirleme ──────────────
      // Sıvılaşmış ajanlar (FM-200, Novec, CO₂):
      //   Boru içinde SIVI olarak akar → ρ_sıvı kullanılır, v_maks = 6 m/s
      //   (ISO 14520-1 Ek E, tipik üretici tasarım kriterleri)
      // Atıl gazlar (IG-541, IG-55, IG-100, IG-01):
      //   200 bar depodan ~40 bar tahliye basıncında GAZ olarak akar
      //   v_maks = 30 m/s (ISO 14520-1 Ek E)
      final double qM3s; // boru içi volumetrik debi (m³/s)
      final double vRef; // m/s — seçilen hız limiti

      if (ajan.inert) {
        // Atmosferik hacim → tahliye basıncına (≈40 bar) dönüştür
        final qAtm =
            (miktar / tSure) * (273.15 + tVal2) / 273.15; // Nm³/s → m³/s atm
        const pDischargeBar =
            40.0; // bar — 200 bar depo için tipik ortalama tahliye basıncı
        qM3s = qAtm / pDischargeBar; // m³/s boru içinde
        vRef = 30.0;
      } else {
        // Sıvı halokarbon: kütle debisi / sıvı yoğunluğu
        final rhoLiq = ajan.rhoLiquid ?? 1400.0; // kg/m³
        qM3s = massFlowKgs / rhoLiq; // m³/s sıvı
        vRef = 6.0; // m/s — sıvı faz için tipik üst sınır
      }

      final aMin = qM3s / vRef;
      final dMinMm = math.sqrt(4 * aMin / math.pi) * 1000;
      int? dn;
      double? dnIcCap;
      for (final e in _dnTablosu) {
        if (e.$2 >= dMinMm) {
          dn = e.$1;
          dnIcCap = e.$2;
          break;
        }
      }
      // Seçilen DN için gerçek hız
      final gercekHiz = dnIcCap != null
          ? qM3s / (math.pi * math.pow(dnIcCap / 1000, 2) / 4)
          : null;
      setState(() {
        _boruCapMin = dMinMm;
        _boruAkisHizi = gercekHiz;
        _boruDN = dn;
        _akisDebiM3s = qM3s;
        _akisKgs = massFlowKgs;
      });

      // ── Nozul sayısı ──────────────────────────────────────────────────────
      double? odaAlani; // m²
      double? odaYukseklik;
      if (_olcuModu) {
        final w2 = double.tryParse(_wCtrl.text.replaceAll(',', '.'));
        final l2 = double.tryParse(_lCtrl.text.replaceAll(',', '.'));
        final h2 = double.tryParse(_hCtrl.text.replaceAll(',', '.'));
        if (w2 != null && l2 != null && h2 != null) {
          odaAlani = w2 * l2;
          odaYukseklik = h2;
        }
      }
      final int nozulSayisi;
      double? nozulAkisKgs;
      if (_nozulBoreIdx != null) {
        // Kullanıcı nozul çapı seçmiş: max akış bazlı hesap
        final nozul = _nozulTablosu[_nozulBoreIdx!];
        nozulSayisi = math.max(1, (massFlowKgs / nozul.$3).ceil());
        nozulAkisKgs = massFlowKgs / nozulSayisi;
      } else if (odaAlani != null) {
        // Alan her zaman basşvuru — yükseklikten bağımsız 50 m²/nozul
        nozulSayisi = math.max(1, (odaAlani / 50.0).ceil());
      } else {
        // Yalnızca hacim biliniyorsa: 150 m³/nozul (tutucu tahmini — üretici listesi ile doğrula)
        nozulSayisi = math.max(1, (v / 150.0).ceil());
      }

      // ── Şube (dağıtım) boru çapı — nozul başına debi ──────────────────
      final qDalM3s = qM3s / nozulSayisi;
      final aDal = qDalM3s / vRef;
      final dDalMm = math.sqrt(4 * aDal / math.pi) * 1000;
      int? dalDN;
      double? dalIcCap;
      for (final e in _dnTablosu) {
        if (e.$2 >= dDalMm) {
          dalDN = e.$1;
          dalIcCap = e.$2;
          break;
        }
      }
      final double? dalHiz = dalIcCap != null
          ? qDalM3s / (math.pi * math.pow(dalIcCap / 1000, 2) / 4)
          : null;

      // ── Tahmini boru metrajı (sadece ölçü modunda) ─────────────────────
      // Ana hat: odanın bir kenarından orta noktaya ~= uzun kenar/2
      // Dağıtım: oda içi yatay dağıtım ~= (En + Boy) × 0.7
      // Nozul düşey boruları: tavan yüksekliğinin %20'si × nozul sayısı
      double? tahminiMetraj;
      if (odaAlani != null && odaYukseklik != null) {
        final w2 = double.tryParse(_wCtrl.text.replaceAll(',', '.'))!;
        final l2 = double.tryParse(_lCtrl.text.replaceAll(',', '.'))!;
        final anaHat = (math.max(w2, l2) / 2).roundToDouble();
        final dagitim = ((w2 + l2) * 0.7).roundToDouble();
        final duseyler = (odaYukseklik * 0.2 * nozulSayisi).roundToDouble();
        tahminiMetraj = anaHat + dagitim + duseyler;
      }

      setState(() {
        _nozulSayisi = nozulSayisi;
        _nozulAkisKgs = nozulAkisKgs;
        _dalBoruDN = dalDN;
        _dalBoruHizi = dalHiz;
        _dalBoruCapMin = dDalMm;
        _tahminiBoruMetraj = tahminiMetraj;
      });
    }
    ProjeServisi.hesapVeri = jsonEncode({
      'i': {
        'olcuModu': _olcuModu.toString(),
        'w': _wCtrl.text,
        'l': _lCtrl.text,
        'h': _hCtrl.text,
        'v': _vCtrl.text,
        't': _tCtrl.text,
        'rakim': _rakimCtrl.text,
        'rakimGoster': _rakimGoster.toString(),
        'guvenlikPayi': _guvenlikPayi.toString(),
        'yanginSinifi': _yanginSinifi,
        'ajanIdx': _ajanIdx.toString(),
        'desarj': _desarjCtrl.text,
        'konsan': _konsanCtrl.text,
      },
      'r':
          '## Gazlı Söndürme Sistemi\n'
          'Ajan: ${_ajanlar[_ajanIdx].ad}  |  Yangın Sınıfı: $_yanginSinifi  |  Konsantrasyon: ${_konsanCtrl.text}%\n'
          'Net Hacim: ${_netHacim?.toStringAsFixed(1) ?? "-"} m³  |  Ajan Miktarı: ${_ajanMiktar?.toStringAsFixed(1) ?? "-"} kg  |  Güvenlik Payı: ${_guvenlikPayi ? "%10" : "yok"}\n'
          '## Hesap Sonuçları\n'
          'Silindir Sayısı: ${_silindirSayisi?.toStringAsFixed(0) ?? "-"} adet  |  Desarş Süresi: ${_desarjCtrl.text} s\n'
          'Boru DN: ${_boruDN?.toString() ?? "-"}  |  Nozul Sayısı: ${_nozulSayisi?.toString() ?? "-"} adet',
    });
    ProjeServisi.hesapSinyali.value = true;
  }

  @override
  void initState() {
    super.initState();
    final g = ProjeServisi.kayitliGirdiler;
    if (g != null) {
      ProjeServisi.kayitliGirdiler = null;
      final sekme = g['sekme'] ?? 'toplam';
      if (sekme == 'baski') {
        // Baskı Makinesi sekmesine geçiş ve geri yükleme BaskiMakinesiSondurmeState tarafından yapılır
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _tabCtrl.animateTo(1);
        });
        return;
      }
      if (sekme == 'pano') {
        // Pano İçi sekmesine geçiş ve geri yükleme _PanoIciSondurmeState tarafından yapılır
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _tabCtrl.animateTo(2);
        });
        return;
      }
      _olcuModu = g['olcuModu'] == 'true';
      _wCtrl.text = g['w'] ?? '';
      _lCtrl.text = g['l'] ?? '';
      _hCtrl.text = g['h'] ?? '';
      _vCtrl.text = g['v'] ?? '';
      _tCtrl.text = g['t'] ?? '20';
      _rakimCtrl.text = g['rakim'] ?? '';
      _rakimGoster = g['rakimGoster'] == 'true';
      _guvenlikPayi = g['guvenlikPayi'] != 'false';
      _yanginSinifi = g['yanginSinifi'] ?? 'A';
      _ajanIdx = int.tryParse(g['ajanIdx'] ?? '0') ?? 0;
      _desarjCtrl.text = g['desarj'] ?? '60';
      _konsanCtrl.text = g['konsan'] ?? '';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _hesapla();
      });
    }
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _wCtrl.dispose();
    _lCtrl.dispose();
    _hCtrl.dispose();
    _vCtrl.dispose();
    _tCtrl.dispose();
    _rakimCtrl.dispose();
    _desarjCtrl.dispose();
    _konsanCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ajan = _ajanlar[_ajanIdx];
    return Column(
      children: [
        TabBar(
          controller: _tabCtrl,
          labelColor: _kGaz,
          indicatorColor: _kGaz,
          unselectedLabelColor: Colors.black54,
          tabs: [
            Tab(
              icon: Icon(Icons.cloud_rounded, size: 18),
              text: l10n.gasRoomTab,
            ),
            Tab(
              icon: Icon(Icons.print_rounded, size: 18),
              text: l10n.gasPrintingTab,
            ),
            Tab(
              icon: Icon(Icons.electrical_services_rounded, size: 18),
              text: l10n.gasPanelTab,
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabCtrl,
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Bilgi kutusu
                    _InfoBox(
                      color: const Color(0xFFECFEFF),
                      border: _kGaz,
                      child: Text(
                        l10n.gasInfoBoxText,
                        style: const TextStyle(
                          fontSize: 11,
                          height: 1.5,
                          color: Color(0xFF0E7490),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Hacim giriş modu
                    SegmentedButton<bool>(
                      segments: [
                        ButtonSegment(
                          value: true,
                          label: Text(
                            l10n.roomDimensions,
                            style: TextStyle(fontSize: 12),
                          ),
                          icon: Icon(Icons.straighten_rounded),
                        ),
                        ButtonSegment(
                          value: false,
                          label: Text(
                            l10n.directVolume,
                            style: TextStyle(fontSize: 12),
                          ),
                          icon: Icon(Icons.view_in_ar_rounded),
                        ),
                      ],
                      selected: {_olcuModu},
                      onSelectionChanged: (s) =>
                          setState(() => _olcuModu = s.first),
                      style: ButtonStyle(
                        foregroundColor: WidgetStateProperty.resolveWith(
                          (st) => st.contains(WidgetState.selected)
                              ? Colors.white
                              : _kGaz,
                        ),
                        backgroundColor: WidgetStateProperty.resolveWith(
                          (st) =>
                              st.contains(WidgetState.selected) ? _kGaz : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (_olcuModu) ...[
                      Row(
                        children: [
                          Expanded(
                            child: _gazField(
                              l10n.singleWidth,
                              _wCtrl,
                              'm',
                              labelStyle: TextStyle(fontSize: 12),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _gazField(
                              l10n.singleLength,
                              _lCtrl,
                              'm',
                              labelStyle: TextStyle(fontSize: 12),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _gazField(
                              l10n.panelHeight,
                              _hCtrl,
                              'm',
                              labelStyle: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.gasNetVolumeHint,
                        style: const TextStyle(fontSize: 10, color: Colors.black45),
                      ),
                    ] else ...[
                      _gazField(
                        l10n.netProtectionVolume,
                        _vCtrl,
                        'm³',
                        labelStyle: TextStyle(fontSize: 12),
                      ),
                    ],
                    const SizedBox(height: 12),

                    _gazField(
                      l10n.minimumDesignTemperature,
                      _tCtrl,
                      '°C',
                      labelStyle: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.gasMinDesignTempHint,
                      style: const TextStyle(fontSize: 10, color: Colors.black45),
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Checkbox(
                          value: _rakimGoster,
                          activeColor: _kGaz,
                          onChanged: (v) =>
                              setState(() => _rakimGoster = v ?? false),
                        ),
                        Expanded(
                          child: Text(
                            l10n.altitudeCorrection,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    if (_rakimGoster) ...[
                      _gazField(l10n.gasAltitudeFieldLabel, _rakimCtrl, 'm'),
                      const SizedBox(height: 8),
                    ],

                    Row(
                      children: [
                        Checkbox(
                          value: _guvenlikPayi,
                          activeColor: _kGaz,
                          onChanged: (v) =>
                              setState(() => _guvenlikPayi = v ?? true),
                        ),
                        Expanded(
                          child: Text(
                            l10n.safetyMargin,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Yangın sınıfı
                    Text(
                      l10n.fireClass,
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final (val, icon, lbl) in [
                          ('A', Icons.home_rounded, l10n.surfaceClassA),
                          ('AD', Icons.layers_rounded, l10n.deepClassA),
                          ('B', Icons.local_gas_station_rounded, l10n.classB),
                          ('C', Icons.electrical_services_rounded, l10n.classC),
                        ])
                          ChoiceChip(
                            avatar: Icon(
                              icon,
                              size: 14,
                              color: _yanginSinifi == val
                                  ? Colors.white
                                  : _kGaz,
                            ),
                            label: Text(
                              lbl,
                              style: TextStyle(
                                fontSize: 12,
                                color: _yanginSinifi == val
                                    ? Colors.white
                                    : _kGaz,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            selected: _yanginSinifi == val,
                            selectedColor: _kGaz,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: _kGaz),
                            ),
                            showCheckmark: false,
                            onSelected: (_) => setState(() {
                              _yanginSinifi = val;
                              _ajanMiktar = null;
                              _hata = null;
                              _konsanGuncelle();
                            }),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (_yanginSinifi == 'A') ...[
                      _GazSinifAciklama(
                        baslik: l10n.surfaceClassA,
                        maddeler: [
                          l10n.gasClassAMaterial1,
                          l10n.gasClassAMaterial2,
                          l10n.gasClassAMaterial3,
                          l10n.gasClassAMaterial4,
                          l10n.gasClassAMaterial5,
                          l10n.gasClassAMaterial6,
                          l10n.gasClassAMaterial7,
                          l10n.gasClassAMaterial8,
                        ],
                        kaynak: l10n.gasClassASource,
                      ),
                    ] else if (_yanginSinifi == 'AD') ...[
                      _GazSinifAciklama(
                        baslik: l10n.gasClassADTitle,
                        maddeler: [
                          l10n.gasClassADMaterial1,
                          l10n.gasClassADMaterial2,
                          l10n.gasClassADMaterial3,
                          l10n.gasClassADMaterial4,
                          l10n.gasClassADMaterial5,
                          l10n.gasClassADMaterial6,
                          l10n.gasClassADMaterial7,
                          l10n.gasClassADMaterial8,
                        ],
                        kaynak: l10n.gasClassADSource,
                      ),
                    ] else if (_yanginSinifi == 'B') ...[
                      _GazSinifAciklama(
                        baslik: l10n.gasClassBTitle,
                        maddeler: [
                          l10n.gasClassBMaterial1,
                          l10n.gasClassBMaterial2,
                          l10n.gasClassBMaterial3,
                          l10n.gasClassBMaterial4,
                          l10n.gasClassBMaterial5,
                        ],
                        kaynak: 'ISO 3941 / TS EN 15004-1:2019 / NFPA 2001',
                      ),
                    ] else ...[
                      _GazSinifAciklama(
                        baslik: l10n.classC,
                        maddeler: [
                          l10n.gasClassCMaterial1,
                          l10n.gasClassCMaterial2,
                          l10n.gasClassCMaterial3,
                          l10n.gasClassCMaterial4,
                        ],
                        kaynak: l10n.gasClassCSource,
                      ),
                    ],
                    const SizedBox(height: 12),

                    // Ajan seçimi
                    DropdownButtonFormField<int>(
                      value: _ajanIdx,
                      isExpanded: true,
                      decoration: _gazDecor(
                        l10n.gasAgent,
                        Icons.cloud_rounded,
                      ),
                      items: List.generate(
                        _ajanlar.length,
                        (i) => DropdownMenuItem(
                          value: i,
                          child: Text(
                            _ajanlar[i].ad,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                      onChanged: (v) => setState(() {
                        _ajanIdx = v ?? 0;
                        _konsanGuncelle();
                      }),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_ajanlar[_ajanIdx].standart}  ·  ${gazAgentDesc(l10n, _ajanIdx)}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _InfoBox(
                      color: const Color(0xFFECFEFF),
                      border: const Color(0xFF67E8F9),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            size: 14,
                            color: Color(0xFF0E7490),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              l10n.gasStandardDefaultInfo(
                                _yanginSinifi == 'AD'
                                    ? l10n.deepClassA
                                    : _yanginSinifi == 'A'
                                    ? l10n.surfaceClassA
                                    : _yanginSinifi == 'B'
                                    ? l10n.classB
                                    : l10n.classC,
                                (() {
                                  final a = _ajanlar[_ajanIdx];
                                  return _yanginSinifi == "A"
                                      ? a.konsanA
                                      : _yanginSinifi == "AD"
                                      ? a.konsanADerin
                                      : _yanginSinifi == "B"
                                      ? a.konsanB
                                      : a.konsanC;
                                })().toStringAsFixed(1),
                                _ajanlar[_ajanIdx].silindirKapasite
                                    .toString(),
                                _ajanlar[_ajanIdx].silindirBirim,
                              ),
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF0E7490),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Tasarım konsantrasyonu (düzenlenebilir)
                    _gazField(l10n.designConcentration, _konsanCtrl, '%'),
                    const SizedBox(height: 4),
                    Text(
                      l10n.gasConcentrationHint,
                      style: const TextStyle(fontSize: 10, color: Colors.black45),
                    ),
                    const SizedBox(height: 16),

                    // Deşarj süresi girişi
                    _gazField(l10n.dischargeDuration, _desarjCtrl, 's'),
                    const SizedBox(height: 4),
                    Text(
                      _yanginSinifi == 'B'
                          ? l10n.gasDischargeDurationHintClassB
                          : l10n.gasDischargeDurationHintOther,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.black45,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Nozul çapı seçimi
                    Row(
                      children: [
                        Text(
                          l10n.nozzleDiameter + ':',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: _kGaz,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<int?>(
                            value: _nozulBoreIdx,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                            ),
                            items: [
                              DropdownMenuItem<int?>(
                                value: null,
                                child: Text(
                                  l10n.automaticNozzle,
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                              ..._GazliSondurmeState._nozulTablosu
                                  .asMap()
                                  .entries
                                  .map(
                                    (e) => DropdownMenuItem<int?>(
                                      value: e.key,
                                      child: Text(
                                        l10n.gasNozzleFlowRange(
                                          e.value.$1.toString(),
                                          e.value.$2.toString(),
                                          e.value.$3.toString(),
                                        ),
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ),
                            ],
                            onChanged: (val) =>
                                setState(() => _nozulBoreIdx = val),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.gasNozzleHint,
                      style: const TextStyle(fontSize: 10, color: Colors.black45),
                    ),
                    const SizedBox(height: 16),

                    if (_hata != null) ...[
                      _InfoBox(
                        color: const Color(0xFFFEE2E2),
                        border: const Color(0xFFFCA5A5),
                        child: Text(
                          _hata!,
                          style: const TextStyle(
                            color: Color(0xFFDC2626),
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],

                    ElevatedButton.icon(
                      onPressed: _hesapla,
                      icon: const Icon(Icons.calculate_rounded),
                      label: Text(AppLocalizations.of(context)!.calculate),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _kGaz,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    // ¦¦ Sonuçlar
                    if (_ajanMiktar != null) ...[
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _kGaz, width: 2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.cloud_done_rounded,
                                  color: Color(0xFF0891B2),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.calculationResultCaps,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Color(0xFF0891B2),
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 16),
                            _GazSonucSatir(
                              etiket: l10n.netProtectionVolume,
                              deger: '${_netHacim!.toStringAsFixed(2)} m³',
                            ),
                            const SizedBox(height: 4),
                            _GazSonucSatir(
                              etiket: l10n.designConcentration,
                              deger: '${_konsantrasyon!.toStringAsFixed(1)} %',
                            ),
                            const SizedBox(height: 4),
                            _GazSonucSatir(
                              etiket: ajan.inert
                                  ? l10n.gasRequiredAgentVolume
                                  : l10n.requiredAgentMass,
                              deger: ajan.inert
                                  ? '${_ajanMiktar!.toStringAsFixed(1)} Nm³'
                                        '${_guvenlikPayi ? l10n.gasSafetyMarginSuffix : ''}'
                                  : '${_ajanMiktar!.toStringAsFixed(1)} kg'
                                        '${_guvenlikPayi ? l10n.gasSafetyMarginSuffix : ''}',
                            ),
                            if (_guvenlikPayi) ...[
                              const SizedBox(height: 4),
                              _GazSonucSatir(
                                etiket: l10n.gasExcludingMarginLabel,
                                deger: ajan.inert
                                    ? '${(_ajanMiktar! / 1.10).toStringAsFixed(1)} Nm³'
                                    : '${(_ajanMiktar! / 1.10).toStringAsFixed(1)} kg',
                              ),
                            ],
                            const SizedBox(height: 4),
                            _GazSonucSatir(
                              etiket: l10n.minimumNozzleCount,
                              deger:
                                  ' ${_silindirSayisi!.toInt()} adet'
                                  '  (${ajan.silindirKapasite} ${ajan.silindirBirim}/silindir)',
                            ),
                            const SizedBox(height: 12),

                            // Deşarj süresi
                            _InfoBox(
                              color: const Color(0xFFF0FDF4),
                              border: const Color(0xFF86EFAC),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.gasDischargeRequirementsTitle,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                      color: Color(0xFF166534),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    ajan.inert
                                        ? l10n.gasDischargeReqInert
                                        : ajan.ad.contains('CO²')
                                        ? l10n.gasDischargeReqCo2
                                        : ajan.ad.contains('FM-200') ||
                                              ajan.ad.contains('227')
                                        ? l10n.gasDischargeReqFm200(
                                            _yanginSinifi == "B"
                                                ? l10n.gasMaxDischargeClassB
                                                : l10n.gasMaxDischargeClassOther,
                                          )
                                        : l10n.gasDischargeReqDefault(
                                            _yanginSinifi == "B"
                                                ? l10n.gasMaxDischargeClassB
                                                : l10n.gasMaxDischargeClassOther,
                                          ),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF166534),
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),

                            // IG-01 silindir depolama özellikleri (TS EN 15004-7 §6.1)
                            if (ajan.ad.contains('IG-01')) ...[
                              _InfoBox(
                                color: const Color(0xFFF0FAFE),
                                border: const Color(0xFF7DD3FC),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.storage_rounded,
                                          size: 14,
                                          color: Color(0xFF0369A1),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          l10n.gasIg01SpecsTitle,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                            color: Color(0xFF0369A1),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Table(
                                      columnWidths: const {
                                        0: FlexColumnWidth(2.4),
                                        1: FlexColumnWidth(1.0),
                                        2: FlexColumnWidth(1.0),
                                        3: FlexColumnWidth(1.0),
                                      },
                                      children: [
                                        TableRow(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFBAE6FD),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 6,
                                                vertical: 3,
                                              ),
                                              child: Text(
                                                l10n.gasTablePropertyHeader,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF0C4A6E),
                                                ),
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 4,
                                                vertical: 3,
                                              ),
                                              child: Text(
                                                '160 bar',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF0C4A6E),
                                                ),
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 4,
                                                vertical: 3,
                                              ),
                                              child: Text(
                                                '200 bar',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF0C4A6E),
                                                ),
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 4,
                                                vertical: 3,
                                              ),
                                              child: Text(
                                                '300 bar',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF0C4A6E),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        _gazPropRow(
                                          l10n.gasFillPressureLabel,
                                          '160',
                                          '200',
                                          '300',
                                        ),
                                        _gazPropRow(
                                          l10n.gasMaxOperatingPressureLabel,
                                          '188',
                                          '235',
                                          '362',
                                        ),
                                        _gazPropRow(
                                          l10n.gasOverpressurizationLabel,
                                          l10n.gasNotApplicable,
                                          l10n.gasNotApplicable,
                                          l10n.gasNotApplicable,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      l10n.gasIg01Note,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFF0369A1),
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],

                            // FM-200 silindir depolama özellikleri (EN 15004-5 §6.1)
                            if (ajan.ad.contains('FM-200') ||
                                ajan.ad.contains('227')) ...[
                              _InfoBox(
                                color: const Color(0xFFEFF6FF),
                                border: const Color(0xFF93C5FD),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.propane_tank_rounded,
                                          size: 14,
                                          color: Color(0xFF1D4ED8),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          l10n.gasFm200SpecsTitle,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                            color: Color(0xFF1D4ED8),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Table(
                                      columnWidths: const {
                                        0: FlexColumnWidth(2.2),
                                        1: FlexColumnWidth(1.0),
                                        2: FlexColumnWidth(1.0),
                                        3: FlexColumnWidth(1.0),
                                      },
                                      children: [
                                        TableRow(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFDBEAFE),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 6,
                                                vertical: 3,
                                              ),
                                              child: Text(
                                                l10n.gasTablePropertyHeader,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF1E3A8A),
                                                ),
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 4,
                                                vertical: 3,
                                              ),
                                              child: Text(
                                                '25 bar',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF1E3A8A),
                                                ),
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 4,
                                                vertical: 3,
                                              ),
                                              child: Text(
                                                '42 bar',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF1E3A8A),
                                                ),
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 4,
                                                vertical: 3,
                                              ),
                                              child: Text(
                                                '50 bar',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF1E3A8A),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        _gazPropRow(
                                          l10n.gasMaxFillDensityLabel,
                                          '1 150',
                                          '1 150',
                                          '1 150',
                                        ),
                                        _gazPropRow(
                                          l10n.gasMaxOperatingPressureLabel,
                                          '34',
                                          '53',
                                          '—',
                                        ),
                                        _gazPropRow(
                                          l10n.gasN2FillingPressureLabel,
                                          '25',
                                          '42',
                                          '50',
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      l10n.gasFm200Note,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFF1D4ED8),
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],

                            // NOAEL/LOAEL uyarısı
                            _InfoBox(
                              color: _noaelUyari!.startsWith('⚠')
                                  ? const Color(0xFFFEF3C7)
                                  : const Color(0xFFEFF6FF),
                              border: _noaelUyari!.startsWith('⚠')
                                  ? const Color(0xFFFCD34D)
                                  : const Color(0xFF93C5FD),
                              child: Text(
                                _noaelUyari!,
                                style: TextStyle(
                                  fontSize: 11,
                                  height: 1.4,
                                  color: _noaelUyari!.startsWith('⚠')
                                      ? const Color(0xFF92400E)
                                      : const Color(0xFF1E40AF),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // ── NFPA 2001:2022 Zorunlu Gereklilikler ─────────────────
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF7ED),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFFFBD38D),
                                  width: 1.2,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.checklist_rounded,
                                        size: 15,
                                        color: Color(0xFF92400E),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        l10n.gasNfpa2001RequirementsTitle,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Color(0xFF92400E),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  _GazNfpaSatir(l10n.gasReqPreDischargeAlarm),
                                  _GazNfpaSatir(l10n.gasReqAbortSwitch),
                                  _GazNfpaSatir(l10n.gasReqVolumeIntegrity),
                                  _GazNfpaSatir(l10n.gasReqCylinderStorage),
                                  _GazNfpaSatir(
                                    l10n.gasReqPostDischargeVentilation,
                                  ),
                                  _GazNfpaSatir(l10n.gasReqInterlockedSystems),
                                  _GazNfpaSatir(
                                    l10n.gasReqSafetyMargin(
                                      _guvenlikPayi
                                          ? l10n.gasSafetyMarginApplied
                                          : l10n.gasSafetyMarginNotApplied,
                                    ),
                                  ),
                                  _GazNfpaSatir(
                                    l10n.gasReqPeriodicInspection,
                                  ),
                                ],
                              ),
                            ),

                            // Boru çapı sonucu
                            if (_boruCapMin != null) ...[
                              const SizedBox(height: 8),
                              _InfoBox(
                                color: const Color(0xFFFAF5FF),
                                border: const Color(0xFFD8B4FE),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.plumbing_rounded,
                                          size: 14,
                                          color: Color(0xFF6D28D9),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          l10n.gasMainPipeSizeTitle,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                            color: Color(0xFF6D28D9),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                l10n.gasMinInnerDiameterLabel,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.black45,
                                                ),
                                              ),
                                              Text(
                                                '${_boruCapMin!.toStringAsFixed(1)} mm',
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF6D28D9),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 1,
                                          height: 36,
                                          color: const Color(0xFFD8B4FE),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                l10n.gasStandardDnLabel,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.black45,
                                                ),
                                              ),
                                              Text(
                                                _boruDN != null
                                                    ? 'DN $_boruDN'
                                                    : l10n.gasDnOver150,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF6D28D9),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    if (_akisDebiM3s != null)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 4,
                                        ),
                                        child: Text(
                                          l10n.gasVolumetricFlowLabel(
                                            (_akisDebiM3s! * 1000)
                                                .toStringAsFixed(2),
                                            _akisDebiM3s!.toStringAsFixed(4),
                                          ),
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF6D28D9),
                                          ),
                                        ),
                                      ),
                                    if (_boruAkisHizi != null)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 4,
                                        ),
                                        child: Text(
                                          l10n.gasPipeActualSpeedLabel(
                                            _boruDN?.toString() ?? '>150',
                                            _boruAkisHizi!.toStringAsFixed(1),
                                            _boruAkisHizi! > 30
                                                ? l10n.gasSpeedOverLimitSuffix
                                                : l10n.gasSpeedOkSuffix,
                                          ),
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: _boruAkisHizi! > 30
                                                ? const Color(0xFFDC2626)
                                                : const Color(0xFF6D28D9),
                                            fontWeight: _boruAkisHizi! > 30
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    Text(
                                      l10n.gasMainPipeSizingNote,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.black45,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],

                            // ── Nozul & Dağıtım Borusu ──────────────────────────
                            if (_nozulSayisi != null) ...[
                              const SizedBox(height: 8),
                              _InfoBox(
                                color: const Color(0xFFF0FDF4),
                                border: const Color(0xFF6EE7B7),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.scatter_plot_rounded,
                                          size: 14,
                                          color: Color(0xFF065F46),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          l10n.gasNozzleDistributionTitle,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                            color: Color(0xFF065F46),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    // Nozul sayısı + şube boru yan yana
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _GazBilgiKutu(
                                            etiket: l10n.gasNozzleCountLabel,
                                            deger: '${_nozulSayisi!} adet',
                                            alt: _nozulBoreIdx != null
                                                ? l10n.gasNozzleAltMassBased(
                                                    _GazliSondurmeState
                                                        ._nozulTablosu[_nozulBoreIdx!]
                                                        .$1
                                                        .toString(),
                                                  )
                                                : _olcuModu
                                                ? l10n.gasNozzleAltAreaBased
                                                : l10n.gasNozzleAltVolumeBased,
                                            renk: const Color(0xFF065F46),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: _GazBilgiKutu(
                                            etiket: l10n.gasBranchPipeLabel,
                                            deger: _dalBoruDN != null
                                                ? 'DN $_dalBoruDN'
                                                : l10n.gasDnOver150,
                                            alt: _dalBoruCapMin != null
                                                ? l10n.gasBranchMinInnerDiameter(
                                                    _dalBoruCapMin!
                                                        .toStringAsFixed(1),
                                                  )
                                                : '',
                                            renk: const Color(0xFF047857),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Nozul başına akış oranı ve aralık kontrolü
                                    if (_nozulAkisKgs != null &&
                                        _nozulBoreIdx != null) ...[
                                      const SizedBox(height: 6),
                                      Builder(
                                        builder: (ctx) {
                                          final nozul = _GazliSondurmeState
                                              ._nozulTablosu[_nozulBoreIdx!];
                                          final ok =
                                              _nozulAkisKgs! >= nozul.$2 &&
                                              _nozulAkisKgs! <= nozul.$3;
                                          return Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 5,
                                            ),
                                            decoration: BoxDecoration(
                                              color: ok
                                                  ? const Color(0xFFD1FAE5)
                                                  : const Color(0xFFFEE2E2),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              l10n.gasFlowPerNozzleLabel(
                                                _nozulAkisKgs!
                                                    .toStringAsFixed(3),
                                                nozul.$2.toString(),
                                                nozul.$3.toString(),
                                                ok
                                                    ? l10n.gasFlowOk
                                                    : l10n.gasFlowOutOfRange,
                                              ),
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                                color: ok
                                                    ? const Color(0xFF065F46)
                                                    : const Color(0xFFDC2626),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                    if (_dalBoruHizi != null) ...[
                                      const SizedBox(height: 6),
                                      Text(
                                        l10n.gasBranchSpeedLabel(
                                          _dalBoruHizi!.toStringAsFixed(1),
                                          (_akisDebiM3s! /
                                                  _nozulSayisi! *
                                                  1000)
                                              .toStringAsFixed(2),
                                          _dalBoruHizi! > 30
                                              ? l10n.gasBranchSpeedWarning
                                              : l10n.gasBranchSpeedOk,
                                        ),
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: _dalBoruHizi! > 30
                                              ? const Color(0xFFDC2626)
                                              : const Color(0xFF065F46),
                                          fontWeight: _dalBoruHizi! > 30
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                    if (_tahminiBoruMetraj != null) ...[
                                      const SizedBox(height: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFD1FAE5),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.straighten_rounded,
                                              size: 13,
                                              color: Color(0xFF065F46),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              l10n.gasEstimatedPipeLengthLabel(
                                                _tahminiBoruMetraj!
                                                    .toStringAsFixed(0),
                                              ),
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: Color(0xFF065F46),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 6),
                                    Text(
                                      l10n.gasNozzlePlacementNote,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.black45,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),
                    Text(
                      l10n.gasSourceFooter,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 10, color: Colors.black38),
                    ),
                  ],
                ),
              ),
              const BaskiMakinesiSondurme(),
              const PanoIciSondurme(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _gazField(
    String lbl,
    TextEditingController ctrl,
    String suffix, {
    TextStyle? labelStyle,
  }) => TextField(
    controller: ctrl,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    decoration: InputDecoration(
      labelText: lbl,
      suffixText: suffix,
      border: const OutlineInputBorder(),
      isDense: true,
      labelStyle: (labelStyle ?? const TextStyle()).copyWith(color: _kGaz),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: _kGaz, width: 2),
      ),
    ),
  );

  InputDecoration _gazDecor(String lbl, IconData ico) => InputDecoration(
    labelText: lbl,
    prefixIcon: Icon(ico),
    border: const OutlineInputBorder(),
    isDense: true,
    labelStyle: const TextStyle(color: _kGaz),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: _kGaz, width: 2),
    ),
  );

  // EN 15004-5 silindir tablo satırı
  static TableRow _gazPropRow(
    String label,
    String v25,
    String v42,
    String v50,
  ) => TableRow(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        child: Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.black87),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
        child: Text(
          v25,
          style: const TextStyle(fontSize: 10, color: Colors.black87),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
        child: Text(
          v42,
          style: const TextStyle(fontSize: 10, color: Colors.black87),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
        child: Text(
          v50,
          style: const TextStyle(fontSize: 10, color: Colors.black87),
        ),
      ),
    ],
  );
}

// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
// BASKI MAKİNESİ SÖNDÜRME — NFPA 2001 / TS EN 15004 / NFPA 12A
// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦

class BaskiMakinesiSondurme extends StatefulWidget {
  const BaskiMakinesiSondurme({super.key});
  @override
  State<BaskiMakinesiSondurme> createState() => _BaskiMakinesiSondurmeState();
}

class _BaskiMakinesiSondurmeState extends State<BaskiMakinesiSondurme> {
  static const Color _kBaski = Color(0xFF0891B2);

  // Makine tipleri: (ad, açıklama, yangın sınıfı önerisi)
  static const List<(String, String, String)> _makineIipleri = [
    ('Ofset Baskı', 'Islak ofset — IPA/alkol bazlı çözücü', 'B'),
    ('Flexo Baskı', 'Solvent veya su bazlı mürekkep', 'B'),
    (
      'Gravür / Rotogravür',
      'Toluen/etil asetat bazlı — yüksek solvent riski',
      'B',
    ),
    ('UV Ofset / UV Flex', 'UV kürleme — fotoinitiator bazlı', 'A'),
    ('Dijital (Inkjet/Toner)', 'Sıvı mürekkep veya toner — düşük solvent', 'A'),
    ('Şilte / Tampon Baskı', 'Solvent bazlı mürekkep — kapalı kap', 'B'),
  ];

  // Koruyucu gazlar (GazliSondurme ile aynı ajanlar)
  static const List<_GazAjanData> _ajanlar = _GazliSondurmeState._ajanlar;

  // Mürekkep/çözücü tipleri: (ad, tutuşma noktası °C, açıklama)
  static const List<(String, double, String)> _cozucuTipleri = [
    (
      'IPA (İzopropil Alkol)',
      12.0,
      'Ofset baskı çeşme solüsyonu — patlama riski',
    ),
    ('Toluen', 4.0, 'Gravür baskı — yüksek risk, GWP 0'),
    ('Etil Asetat', -4.0, 'Flexo/gravür — düşük tutuşma noktası'),
    ('Metanol', 11.0, 'Ağaç işleme ve özel uygulamalar'),
    ('n-Propil Alkol', 23.0, 'UV ofset ek solvent'),
    (
      'Solvent Karışımı (genel)',
      10.0,
      'Üretici veri sayfasına göre belirleyin',
    ),
    ('Su Bazlı Mürekkep', 80.0, 'Yanıcı solvent yok — Sınıf A uygulaması'),
  ];

  static String _baskiMakineAdi(AppLocalizations l10n, int i) => switch (i) {
    0 => l10n.baskiOffsetName,
    1 => l10n.baskiFlexoName,
    2 => l10n.baskiGravureName,
    3 => l10n.baskiUvOffsetName,
    4 => l10n.baskiDigitalName,
    5 => l10n.baskiPadName,
    _ => _makineIipleri[i].$1,
  };

  static String _baskiMakineAciklama(AppLocalizations l10n, int i) =>
      switch (i) {
        0 => l10n.baskiOffsetDesc,
        1 => l10n.baskiFlexoDesc,
        2 => l10n.baskiGravureDesc,
        3 => l10n.baskiUvOffsetDesc,
        4 => l10n.baskiDigitalDesc,
        5 => l10n.baskiPadDesc,
        _ => _makineIipleri[i].$2,
      };

  static String _baskiCozucuAdi(AppLocalizations l10n, int i) => switch (i) {
    0 => l10n.baskiIpaName,
    1 => l10n.baskiTolueneName,
    2 => l10n.baskiEthylAcetateName,
    3 => l10n.baskiMethanolName,
    4 => l10n.baskiNPropylName,
    5 => l10n.baskiSolventMixName,
    6 => l10n.baskiWaterBasedInkName,
    _ => _cozucuTipleri[i].$1,
  };

  static String _baskiCozucuAciklama(AppLocalizations l10n, int i) =>
      switch (i) {
        0 => l10n.baskiIpaDesc,
        1 => l10n.baskiTolueneDesc,
        2 => l10n.baskiEthylAcetateDesc,
        3 => l10n.baskiMethanolDesc,
        4 => l10n.baskiNPropylDesc,
        5 => l10n.baskiSolventMixDesc,
        6 => l10n.baskiWaterBasedInkDesc,
        _ => _cozucuTipleri[i].$3,
      };

  int _makineTipiIdx = 0;
  int _ajanIdx = 0;
  int _cozucuIdx = 0;
  final _unitSayisiCtrl = TextEditingController(text: '1');
  bool _olcuModu = true; // true = ölçü, false = doğrudan hacim
  final _wCtrl = TextEditingController();
  final _lCtrl = TextEditingController();
  final _hCtrl = TextEditingController();
  final _vCtrl = TextEditingController();
  final _tCtrl = TextEditingController(text: '20');
  bool _guvenlikPayi = true;
  bool _lokalUygulama = false; // yerel/lokal uygulama (local application) mı?
  bool _esZamanli =
      true; // true = eşzamanlı tahliye (toplam), false = seçici vana (bağımsız, en büyük ünite esas)
  bool _yedekBesleme = false; // %100 yedek besleme grubu
  late final _konsanCtrl = TextEditingController(
    text: _ajanlar[0].konsanB.toStringAsFixed(1),
  );
  final _desarjCtrl = TextEditingController(text: '10');

  void _konsanGuncelle() {
    final sinif = _makineIipleri[_makineTipiIdx].$3;
    final ajan = _ajanlar[_ajanIdx];
    final def = sinif == 'B' ? ajan.konsanB : ajan.konsanA;
    _konsanCtrl.text = def.toStringAsFixed(1);
  }

  String? _hata;
  double? _unitHacim, _konsantrasyon, _ajanBirimMiktar, _ajanToplamMiktar;
  double? _anaBeslemeMiktar;
  int? _silindirSayisi, _silindirYedekSayisi;

  void _hesapla() {
    setState(() {
      _hata = null;
      _unitHacim = null;
      _ajanBirimMiktar = null;
    });

    final unitSayisi = int.tryParse(_unitSayisiCtrl.text.trim()) ?? 0;
    if (unitSayisi <= 0 || unitSayisi > 50) {
      setState(
        () => _hata = AppLocalizations.of(context).enterValidUnitCount1to50,
      );
      return;
    }

    double v;
    if (_olcuModu) {
      final w = double.tryParse(_wCtrl.text.replaceAll(',', '.'));
      final l = double.tryParse(_lCtrl.text.replaceAll(',', '.'));
      final h = double.tryParse(_hCtrl.text.replaceAll(',', '.'));
      if (w == null || l == null || h == null || w <= 0 || l <= 0 || h <= 0) {
        setState(
          () => _hata = AppLocalizations.of(
            context,
          ).enterMachineCabinDimensionsFullyM,
        );
        return;
      }
      v = w * l * h;
    } else {
      final vv = double.tryParse(_vCtrl.text.replaceAll(',', '.'));
      if (vv == null || vv <= 0) {
        setState(
          () => _hata = AppLocalizations.of(context).enterUnitCabinVolumeM3,
        );
        return;
      }
      v = vv;
    }

    final tVal = double.tryParse(_tCtrl.text.replaceAll(',', '.')) ?? 20.0;
    final cParsed = double.tryParse(_konsanCtrl.text.replaceAll(',', '.'));
    if (cParsed == null || cParsed <= 0 || cParsed >= 100) {
      setState(
        () =>
            _hata = AppLocalizations.of(context).enterValidConcentrationPercent,
      );
      return;
    }

    final ajan = _ajanlar[_ajanIdx];
    final c = cParsed;

    double ajanBirim;
    if (ajan.inert) {
      // İnert gaz: hacimsel hesap (Nm³)
      final vf = v * (c / (100.0 - c));
      ajanBirim = vf;
    } else {
      // Halokarbon: kütle hesabı (EN 15004-1 §6.5)
      final s = ajan.spesifK2 != null
          ? ajan.spesifik20! + ajan.spesifK2! * tVal
          : ajan.spesifik20! * (273.15 + tVal) / 293.15;
      ajanBirim = v * (c / (s * (100.0 - c)));
    }

    // Lokal uygulama için NFPA 2001 §6.4: %30 artış faktörü
    if (_lokalUygulama && !ajan.inert) ajanBirim *= 1.30;

    if (_guvenlikPayi) ajanBirim *= 1.10;

    final ajanToplam = ajanBirim * unitSayisi;
    final silindirKap = ajan.silindirKapasite;
    // Eşzamanlı tahliye: tüm üniteler aynı anda boşalır → ana besleme = toplam envanter.
    // Seçici vana: yangın tek ünitede algılanır, sadece o ünite tahliye olur (NFPA 2001 §7.5.2 / NFPA 12 §4.3.4.2)
    // → ana besleme en büyük (burada tek tip) ünitenin ihtiyacına göre boyutlandırılır.
    final anaBesleme = _esZamanli ? ajanToplam : ajanBirim;
    final silindirAna = (anaBesleme / silindirKap).ceil();
    final silindirYedek = _yedekBesleme ? silindirAna : 0;

    setState(() {
      _unitHacim = v;
      _konsantrasyon = c;
      _ajanBirimMiktar = ajanBirim;
      _ajanToplamMiktar = ajanToplam;
      _anaBeslemeMiktar = anaBesleme;
      _silindirSayisi = silindirAna;
      _silindirYedekSayisi = silindirYedek;
    });

    ProjeServisi.hesapVeri = jsonEncode({
      'i': {
        'sekme': 'baski',
        'makineTipiIdx': _makineTipiIdx.toString(),
        'cozucuIdx': _cozucuIdx.toString(),
        'ajanIdx': _ajanIdx.toString(),
        'unitSayisi': _unitSayisiCtrl.text,
        'olcuModu': _olcuModu.toString(),
        'w': _wCtrl.text,
        'l': _lCtrl.text,
        'h': _hCtrl.text,
        'v': _vCtrl.text,
        't': _tCtrl.text,
        'guvenlikPayi': _guvenlikPayi.toString(),
        'lokalUygulama': _lokalUygulama.toString(),
        'esZamanli': _esZamanli.toString(),
        'yedekBesleme': _yedekBesleme.toString(),
        'konsan': _konsanCtrl.text,
        'desarj': _desarjCtrl.text,
      },
      'r':
          '## Baskı Makinesi Söndürme\n'
          'Makine: ${_makineIipleri[_makineTipiIdx].$1}  |  Ajan: ${_ajanlar[_ajanIdx].ad}  |  '
          'Konsantrasyon: ${_konsanCtrl.text}%\n'
          'Ünite Hacmi: ${_unitHacim!.toStringAsFixed(3)} m³  |  Ünite Sayısı: ${_unitSayisiCtrl.text} adet  |  '
          'Tahliye Şekli: ${_esZamanli ? "Eşzamanlı (Toplam)" : "Seçici Vana (Bağımsız)"}\n'
          '## Hesap Sonuçları\n'
          'Ünite Başına: ${_ajanBirimMiktar!.toStringAsFixed(2)} ${_ajanlar[_ajanIdx].inert ? "Nm³" : "kg"}  |  '
          'Toplam: ${_ajanToplamMiktar!.toStringAsFixed(2)} ${_ajanlar[_ajanIdx].inert ? "Nm³" : "kg"}  |  '
          'Ana Besleme Silindir: $_silindirSayisi adet'
          '${_yedekBesleme ? "  |  Yedek: $_silindirYedekSayisi adet  |  Toplam: ${_silindirSayisi! + _silindirYedekSayisi!} adet" : ""}',
    });
    ProjeServisi.hesapSinyali.value = true;
  }

  @override
  void initState() {
    super.initState();
    _unitSayisiCtrl.addListener(() => setState(() {}));
    final g = ProjeServisi.kayitliGirdiler;
    if (g != null && g['sekme'] == 'baski') {
      ProjeServisi.kayitliGirdiler = null;
      _makineTipiIdx = int.tryParse(g['makineTipiIdx'] ?? '0') ?? 0;
      _cozucuIdx = int.tryParse(g['cozucuIdx'] ?? '0') ?? 0;
      _ajanIdx = int.tryParse(g['ajanIdx'] ?? '0') ?? 0;
      _unitSayisiCtrl.text = g['unitSayisi'] ?? '1';
      _olcuModu = g['olcuModu'] == 'true';
      _wCtrl.text = g['w'] ?? '';
      _lCtrl.text = g['l'] ?? '';
      _hCtrl.text = g['h'] ?? '';
      _vCtrl.text = g['v'] ?? '';
      _tCtrl.text = g['t'] ?? '20';
      _guvenlikPayi = g['guvenlikPayi'] != 'false';
      _lokalUygulama = g['lokalUygulama'] == 'true';
      _esZamanli = g['esZamanli'] != 'false';
      _yedekBesleme = g['yedekBesleme'] == 'true';
      _konsanCtrl.text = g['konsan'] ?? '';
      _desarjCtrl.text = g['desarj'] ?? '10';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _hesapla();
      });
    }
  }

  @override
  void dispose() {
    _unitSayisiCtrl.dispose();
    _wCtrl.dispose();
    _lCtrl.dispose();
    _hCtrl.dispose();
    _vCtrl.dispose();
    _tCtrl.dispose();
    _konsanCtrl.dispose();
    _desarjCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ajan = _ajanlar[_ajanIdx];
    final makine = _makineIipleri[_makineTipiIdx];
    final cozucu = _cozucuTipleri[_cozucuIdx];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _InfoBox(
            color: const Color(0xFFECFEFF),
            border: _kBaski,
            child: Text(
              l10n.baskiInfoBoxText,
              style: const TextStyle(
                fontSize: 11,
                height: 1.5,
                color: Color(0xFF0E7490),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Makine tipi
          DropdownButtonFormField<int>(
            value: _makineTipiIdx,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: l10n.machineType,
              prefixIcon: const Icon(Icons.print_rounded),
              border: const OutlineInputBorder(),
              isDense: true,
              labelStyle: const TextStyle(color: _kBaski),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: _kBaski, width: 2),
              ),
            ),
            items: List.generate(
              _makineIipleri.length,
              (i) => DropdownMenuItem(
                value: i,
                child: Text(
                  _baskiMakineAdi(l10n, i),
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ),
            onChanged: (v) => setState(() {
              _makineTipiIdx = v ?? 0;
              _konsanGuncelle();
            }),
          ),
          const SizedBox(height: 4),
          Text(
            _baskiMakineAciklama(l10n, _makineTipiIdx),
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
          const SizedBox(height: 10),

          // Mürekkep/Çözücü tipi
          DropdownButtonFormField<int>(
            value: _cozucuIdx,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: l10n.inkSolventType,
              prefixIcon: const Icon(Icons.water_drop_rounded),
              border: const OutlineInputBorder(),
              isDense: true,
              labelStyle: const TextStyle(color: _kBaski),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: _kBaski, width: 2),
              ),
            ),
            items: List.generate(
              _cozucuTipleri.length,
              (i) => DropdownMenuItem(
                value: i,
                child: Text(
                  _baskiCozucuAdi(l10n, i),
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ),
            onChanged: (v) => setState(() => _cozucuIdx = v ?? 0),
          ),
          const SizedBox(height: 4),
          _InfoBox(
            color: cozucu.$2 < 15.0
                ? const Color(0xFFFEE2E2)
                : const Color(0xFFFFF7ED),
            border: cozucu.$2 < 15.0
                ? const Color(0xFFFCA5A5)
                : const Color(0xFFFBBF24),
            child: Text(
              l10n.baskiIgnitionPointLabel(
                cozucu.$2.toStringAsFixed(0),
                _baskiCozucuAciklama(l10n, _cozucuIdx),
              ),
              style: TextStyle(
                fontSize: 11,
                color: cozucu.$2 < 15.0
                    ? const Color(0xFFDC2626)
                    : const Color(0xFF92400E),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Ünite sayısı
          _baskiField(
            l10n.printingUnitCount,
            _unitSayisiCtrl,
            'adet',
            tip: TextInputType.number,
          ),
          const SizedBox(height: 4),
          Text(
            l10n.baskiUnitCountHint,
            style: const TextStyle(fontSize: 10, color: Colors.black45),
          ),
          const SizedBox(height: 12),

          // Hacim giriş modu
          SegmentedButton<bool>(
            segments: [
              ButtonSegment(
                value: true,
                label: Text(
                  l10n.measureCabinet,
                  style: TextStyle(fontSize: 12),
                ),
                icon: Icon(Icons.straighten_rounded),
              ),
              ButtonSegment(
                value: false,
                label: Text(l10n.directVolume, style: TextStyle(fontSize: 12)),
                icon: Icon(Icons.view_in_ar_rounded),
              ),
            ],
            selected: {_olcuModu},
            onSelectionChanged: (s) => setState(() => _olcuModu = s.first),
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.resolveWith(
                (st) =>
                    st.contains(WidgetState.selected) ? Colors.white : _kBaski,
              ),
              backgroundColor: WidgetStateProperty.resolveWith(
                (st) => st.contains(WidgetState.selected) ? _kBaski : null,
              ),
            ),
          ),
          const SizedBox(height: 10),

          if (_olcuModu) ...[
            Row(
              children: [
                Expanded(
                  child: _baskiField(
                    l10n.singleWidth,
                    _wCtrl,
                    'm',
                    labelStyle: TextStyle(fontSize: 12),
                  ),
                ),

                const SizedBox(width: 8),
                Expanded(
                  child: _baskiField(
                    l10n.baskiLengthDepthLabel,
                    _lCtrl,
                    'm',
                    labelStyle: TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _baskiField(
                    l10n.panelHeight,
                    _hCtrl,
                    'm',
                    labelStyle: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              l10n.baskiCabinetDimensionsHint,
              style: const TextStyle(fontSize: 10, color: Colors.black45),
            ),
          ] else ...[
            _baskiField(
              l10n.baskiUnitNetVolumeLabel,
              _vCtrl,
              'm³',
              labelStyle: TextStyle(fontSize: 12),
            ),
          ],
          const SizedBox(height: 12),

          _baskiField(
            l10n.minimumDesignTemperature,
            _tCtrl,
            '°C',
            labelStyle: TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.baskiMinTempHint,
            style: const TextStyle(fontSize: 10, color: Colors.black45),
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Checkbox(
                value: _guvenlikPayi,
                activeColor: _kBaski,
                onChanged: (v) => setState(() => _guvenlikPayi = v ?? true),
              ),
              Expanded(
                child: Text(
                  l10n.safetyMargin,
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: _lokalUygulama,
                activeColor: _kBaski,
                onChanged: (v) => setState(() => _lokalUygulama = v ?? false),
              ),
              Expanded(
                child: Text(
                  l10n.baskiLocalApplicationLabel,
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Silindir tasarım yaklaşımı — birden fazla ünite varsa kritik karar
          if (int.tryParse(_unitSayisiCtrl.text.trim()) != null &&
              (int.tryParse(_unitSayisiCtrl.text.trim()) ?? 1) > 1) ...[
            Text(
              l10n.baskiDischargeModeTitle,
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 6),
            SegmentedButton<bool>(
              segments: [
                ButtonSegment(
                  value: true,
                  label: Text(
                    l10n.baskiSimultaneousLabel,
                    style: TextStyle(fontSize: 11),
                  ),
                  icon: Icon(Icons.dynamic_feed_rounded, size: 14),
                ),
                ButtonSegment(
                  value: false,
                  label: Text(
                    l10n.baskiSelectiveValveLabel,
                    style: TextStyle(fontSize: 11),
                  ),
                  icon: Icon(Icons.call_split_rounded, size: 14),
                ),
              ],
              selected: {_esZamanli},
              onSelectionChanged: (s) => setState(() => _esZamanli = s.first),
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.resolveWith(
                  (st) => st.contains(WidgetState.selected)
                      ? Colors.white
                      : _kBaski,
                ),
                backgroundColor: WidgetStateProperty.resolveWith(
                  (st) => st.contains(WidgetState.selected) ? _kBaski : null,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _esZamanli
                  ? l10n.baskiSimultaneousHint
                  : l10n.baskiSelectiveValveHint,
              style: const TextStyle(fontSize: 10, color: Colors.black45),
            ),
            const SizedBox(height: 10),
          ],

          Row(
            children: [
              Checkbox(
                value: _yedekBesleme,
                activeColor: _kBaski,
                onChanged: (v) => setState(() => _yedekBesleme = v ?? false),
              ),
              Expanded(
                child: Text(
                  l10n.baskiBackupSupplyLabel,
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Ajan seçimi
          DropdownButtonFormField<int>(
            value: _ajanIdx,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: l10n.gasAgent,
              prefixIcon: const Icon(Icons.cloud_rounded),
              border: const OutlineInputBorder(),
              isDense: true,
              labelStyle: const TextStyle(color: _kBaski),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: _kBaski, width: 2),
              ),
            ),
            items: List.generate(
              _ajanlar.length,
              (i) => DropdownMenuItem(
                value: i,
                child: Text(
                  _ajanlar[i].ad,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ),
            onChanged: (v) => setState(() {
              _ajanIdx = v ?? 0;
              _konsanGuncelle();
            }),
          ),
          const SizedBox(height: 4),
          Text(
            '${ajan.standart}  ·  ${_GazliSondurmeState.gazAgentDesc(l10n, _ajanIdx)}',
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
          const SizedBox(height: 10),

          _baskiField(l10n.designConcentration, _konsanCtrl, '%'),
          const SizedBox(height: 4),
          Text(
            l10n.baskiClassSummaryLabel(
              makine.$3 == "B" ? l10n.classB : l10n.baskiClassAPlain,
              makine.$3 == "B"
                  ? ajan.konsanB.toStringAsFixed(1)
                  : ajan.konsanA.toStringAsFixed(1),
              ajan.noael >= 0 ? "${ajan.noael.toStringAsFixed(1)} %" : "—",
            ),
            style: const TextStyle(fontSize: 10, color: Colors.black45),
          ),
          const SizedBox(height: 10),

          _baskiField(l10n.dischargeDuration, _desarjCtrl, 's'),
          const SizedBox(height: 4),
          Text(
            l10n.baskiDischargeHint,
            style: TextStyle(fontSize: 10, color: Colors.black45),
          ),
          const SizedBox(height: 16),

          if (_hata != null) ...[
            _InfoBox(
              color: const Color(0xFFFEE2E2),
              border: const Color(0xFFFCA5A5),
              child: Text(
                _hata!,
                style: const TextStyle(color: Color(0xFFDC2626), fontSize: 13),
              ),
            ),
            const SizedBox(height: 8),
          ],

          ElevatedButton.icon(
            onPressed: _hesapla,
            icon: const Icon(Icons.calculate_rounded),
            label: Text(AppLocalizations.of(context)!.calculate),
            style: ElevatedButton.styleFrom(
              backgroundColor: _kBaski,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          if (_ajanBirimMiktar != null) ...[
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _kBaski, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.print_rounded,
                        color: Color(0xFF0891B2),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.calculationResultCaps,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Color(0xFF0891B2),
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  _GazSonucSatir(
                    etiket: l10n.machineType,
                    deger: _baskiMakineAdi(l10n, _makineTipiIdx),
                  ),
                  const SizedBox(height: 4),
                  _GazSonucSatir(
                    etiket: l10n.unitCabinetVolume,
                    deger: '${_unitHacim!.toStringAsFixed(1)} m³',
                  ),
                  const SizedBox(height: 4),
                  _GazSonucSatir(
                    etiket: l10n.printingUnitCount,
                    deger: '${_unitSayisiCtrl.text} adet',
                  ),
                  const SizedBox(height: 4),
                  _GazSonucSatir(
                    etiket: l10n.designConcentration,
                    deger: '${_konsantrasyon!.toStringAsFixed(1)} %',
                  ),
                  const SizedBox(height: 4),
                  _GazSonucSatir(
                    etiket: l10n.agentPerUnit,
                    deger: ajan.inert
                        ? '${_ajanBirimMiktar!.toStringAsFixed(2)} Nm³${_guvenlikPayi ? "  (+%10)" : ""}'
                        : '${_ajanBirimMiktar!.toStringAsFixed(2)} kg${_guvenlikPayi ? "  (+%10)" : ""}',
                  ),
                  const SizedBox(height: 4),
                  _GazSonucSatir(
                    etiket: l10n.totalAgent,
                    deger: ajan.inert
                        ? '${_ajanToplamMiktar!.toStringAsFixed(2)} Nm³'
                        : '${_ajanToplamMiktar!.toStringAsFixed(2)} kg',
                  ),
                  const SizedBox(height: 4),
                  _GazSonucSatir(
                    etiket: _esZamanli
                        ? l10n.baskiMainSupplySimultaneous
                        : l10n.baskiMainSupplySelective,
                    deger: ajan.inert
                        ? '${_anaBeslemeMiktar!.toStringAsFixed(2)} Nm³'
                        : '${_anaBeslemeMiktar!.toStringAsFixed(2)} kg',
                  ),
                  const SizedBox(height: 4),
                  _GazSonucSatir(
                    etiket: l10n.baskiMainSupplyCylinderCount(
                      ajan.silindirKapasite.toString(),
                      ajan.silindirBirim,
                    ),
                    deger: '$_silindirSayisi adet',
                  ),
                  if (_yedekBesleme) ...[
                    const SizedBox(height: 4),
                    _GazSonucSatir(
                      etiket: l10n.backupCylinderCount,
                      deger: '$_silindirYedekSayisi adet',
                    ),
                    const SizedBox(height: 4),
                    _GazSonucSatir(
                      etiket: l10n.totalCylinders,
                      deger: '${_silindirSayisi! + _silindirYedekSayisi!} adet',
                    ),
                  ],
                  if (!_esZamanli) ...[
                    const SizedBox(height: 8),
                    _InfoBox(
                      color: const Color(0xFFECFEFF),
                      border: const Color(0xFF67E8F9),
                      child: Text(
                        l10n.baskiSelectiveValveInfo,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF0E7490),
                        ),
                      ),
                    ),
                  ],
                  if (_lokalUygulama) ...[
                    const SizedBox(height: 8),
                    _InfoBox(
                      color: const Color(0xFFFFF7ED),
                      border: const Color(0xFFFBBF24),
                      child: Text(
                        l10n.baskiLocalApplicationInfo,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF92400E),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 6),
                  Text(
                    l10n.baskiApplicationNotesTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Color(0xFF0891B2),
                    ),
                  ),
                  const SizedBox(height: 6),
                  _InfoBox(
                    color: const Color(0xFFECFEFF),
                    border: const Color(0xFF67E8F9),
                    child: Text(
                      l10n.baskiAppNotesBody(
                        cozucu.$2 < 23.0
                            ? l10n.baskiIgnitionNoteAtex
                            : l10n.baskiIgnitionNoteExplosionRisk,
                      ),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF0E7490),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 20),
          Text(
            l10n.baskiSourceFooter,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: Colors.black38),
          ),
        ],
      ),
    );
  }

  Widget _baskiField(
    String lbl,
    TextEditingController ctrl,
    String suffix, {
    TextInputType tip = const TextInputType.numberWithOptions(decimal: true),
    TextStyle? labelStyle,
  }) => TextField(
    controller: ctrl,
    keyboardType: tip,
    decoration: InputDecoration(
      labelText: lbl,
      suffixText: suffix,
      border: const OutlineInputBorder(),
      isDense: true,
      labelStyle: (labelStyle ?? const TextStyle()).copyWith(color: _kBaski),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: _kBaski, width: 2),
      ),
    ),
  );
}

// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
// PANO İÇİ SÖNDÜRME (DLP/ILP/DHP/IHP) — LPS 1666 / UL 2166 / FM 5600 / VdS 2093
// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦

// Pano içi (pre-engineered) pnömatik tubing sistemi tipi
class _PanoSistemTipi {
  final String kod, ad, standart, sertifika;
  final double maxHacimM3, maxTubingM;
  final String desarjNotu, aciklama;
  // TÜYAK Dergi 33 sistem seçim tablosu: ILP tam sızdırmazlık zorunlu, diğerlerinde gerekmez.
  final bool sizdirmazlikZorunlu;
  const _PanoSistemTipi({
    required this.kod,
    required this.ad,
    required this.standart,
    required this.sertifika,
    required this.maxHacimM3,
    required this.maxTubingM,
    required this.desarjNotu,
    required this.aciklama,
    this.sizdirmazlikZorunlu = false,
  });
}

class PanoIciSondurme extends StatefulWidget {
  const PanoIciSondurme({super.key});
  @override
  State<PanoIciSondurme> createState() => _PanoIciSondurmeState();
}

class _PanoIciSondurmeState extends State<PanoIciSondurme> {
  static const Color _kPano = Color(0xFF0891B2);

  // Ajan grubu: 0 = Temiz Gaz (FK-5-1-12/HFC-227ea) tubing sistemi, 1 = CO₂ tubing sistemi
  static const List<String> _ajanGruplari = [
    'Temiz Gaz (FK-5-1-12(Novec 1230)/HFC-227ea)',
    'CO₂ (Karbondioksit)',
  ];

  // Temiz gaz alt tipi: 0 = FK-5-1-12 (Novec 1230), 1 = HFC-227ea (FM-200)
  static const List<String> _temizAjanlar = [
    'FK-5-1-12 (Novec 1230)',
    'HFC-227ea',
  ];

  // NFPA 2001 tipi ajan miktarı formülü: W = V/s x C/(100-C), s = k1 + k2*T (20°C baz alınır).
  // Değerler üretici onaylı pre-engineered silindir tablosu ile teyit edilmeden kesin kabul edilmemelidir.
  static const double _fk512K1 = 0.0664, _fk512K2 = 0.0002741; // m3/kg
  static const double _hfc227K1 = 0.1269, _hfc227K2 = 0.0005; // m3/kg
  static const double _co2K1 = 0.507, _co2K2 = 0.0016; // m3/kg
  static const double _fk512TasarimYuzde = 5.9;
  static const double _hfc227TasarimYuzde = 7.2;
  static const double _co2TasarimYuzde = 50.0;

  double _ajanMiktariKg(double hacimM3) {
    late final double k1, k2, c;
    if (_ajanGrubuIdx == 1) {
      k1 = _co2K1;
      k2 = _co2K2;
      c = _co2TasarimYuzde;
    } else if (_temizAjanIdx == 0) {
      k1 = _fk512K1;
      k2 = _fk512K2;
      c = _fk512TasarimYuzde;
    } else {
      k1 = _hfc227K1;
      k2 = _hfc227K2;
      c = _hfc227TasarimYuzde;
    }
    final s = k1 + k2 * 20; // 20°C referans sıcaklık
    return hacimM3 / s * (c / (100 - c));
  }

  static const _dlp = _PanoSistemTipi(
    kod: 'DLP',
    ad: 'DLP — Doğrudan Düşük Basınç',
    standart: 'LPS 1666',
    sertifika: 'LPCB',
    maxHacimM3: 2.0,
    maxTubingM: 10.0,
    desarjNotu:
        'Tubing hattı hem algılama hem doğrudan boşaltma görevi görür — hesap gerektirmez.',
    aciklama:
        'En yaygın kullanılan pano içi söndürme tipidir. Kırmızı algılama tubingi doğrudan söndürme hattı '
        'olarak işlev görür; ek boru hattına ve nozula gerek yoktur. Tubing yangın noktasında patladığında ajan '
        'o noktadan boşalır. Hidrolik akış hesabı gerektirmeyen pre-engineered bir sistemdir.',
  );
  static const _ilp = _PanoSistemTipi(
    kod: 'ILP',
    ad: 'ILP — Dolaylı Düşük Basınç',
    standart: 'UL 2166 / FM 5600',
    sertifika: 'UL / FM',
    maxHacimM3: 10.0,
    maxTubingM: 35.0,
    desarjNotu:
        'Tubing algılama yapar; boşaltma ayrı nozul(lar) üzerinden gerçekleşir.',
    aciklama:
        'Algılama tubingi yalnızca tetikleyici işlev görür; söndürücü ajan paslanmaz çelik boru hattı ve '
        'nozullar aracılığıyla panoya boşaltılır. Çok bölmeli ve büyük hacimli panolarda nozullar stratejik '
        'noktalara yerleştirilerek homojen söndürme konsantrasyonu sağlanır. Manuel boşaltma butonu bulunur; '
        'panonun tam sızdırmaz olması zorunludur.',
    sizdirmazlikZorunlu: true,
  );
  static const _dhp = _PanoSistemTipi(
    kod: 'DHP',
    ad: 'DHP — Doğrudan Yüksek Basınç (CO₂)',
    standart: 'VdS 2093',
    sertifika: 'VdS / CNPP',
    maxHacimM3: 3.0,
    maxTubingM: 25.0,
    desarjNotu:
        'Sabit deşarj süresi ≈ 60 sn @ 60 bar — kullanıcı girdisi gerekmez.',
    aciklama:
        'CO₂ ajanı kullanan ve algılama tubinginin hem dedektör hem de boşaltma hattı olarak işlev gördüğü '
        'sistemdir. CO₂ yüksek basınçta depolandığından tubing uzunluğu ve maksimum hacim açısından DLP\'ye göre '
        'avantajlıdır. Nozul deliği açılması istenmeyen ve DLP\'ye göre daha büyük havalandırma açıklığına sahip '
        'panolarda tercih edilir.',
  );
  static const _ihp = _PanoSistemTipi(
    kod: 'IHP',
    ad: 'IHP — Dolaylı Yüksek Basınç (CO₂)',
    standart: 'VdS 2093',
    sertifika: 'VdS / CNPP',
    maxHacimM3: 40.0,
    maxTubingM: 100.0,
    desarjNotu:
        'Deşarj süresi standarda göre sabittir; üretici onaylı tabloya bakınız.',
    aciklama:
        'CO₂ kullanılan en kapsamlı pano içi söndürme çözümüdür. Büyük hacimli, birden fazla bölmesi olan ve '
        'bölmeler arası geçişlerin bulunduğu panolarda tercih edilir. Paslanmaz çelik boru hattı, esnek bağlantı '
        'hortumları ve nozullardan oluşan dağıtım sistemi ile geniş alanlarda homojen söndürme sağlanır.',
  );

  static String _panoAgentGroupName(AppLocalizations l10n, int i) =>
      i == 1 ? l10n.panoAgentGroupCo2 : l10n.panoAgentGroupClean;

  static String _panoSistemAciklama(
    AppLocalizations l10n,
    _PanoSistemTipi s,
  ) => switch (s.kod) {
    'DLP' => l10n.panoDlpAciklama,
    'ILP' => l10n.panoIlpAciklama,
    'DHP' => l10n.panoDhpAciklama,
    'IHP' => l10n.panoIhpAciklama,
    _ => s.aciklama,
  };

  static String _panoSistemDesarjNotu(
    AppLocalizations l10n,
    _PanoSistemTipi s,
  ) => switch (s.kod) {
    'DLP' => l10n.panoDlpDesarjNotu,
    'ILP' => l10n.panoIlpDesarjNotu,
    'DHP' => l10n.panoDhpDesarjNotu,
    'IHP' => l10n.panoIhpDesarjNotu,
    _ => s.desarjNotu,
  };

  int _ajanGrubuIdx = 0;
  int _temizAjanIdx =
      0; // 0 = FK-5-1-12, 1 = HFC-227ea (yalnızca temiz gaz grubunda kullanılır)
  bool _olcuModu = true;
  final _wCtrl = TextEditingController();
  final _lCtrl = TextEditingController();
  final _hCtrl = TextEditingController();
  final _vCtrl = TextEditingController();
  bool _sizdirmazMi = true; // kapatılamayan açıklık YOK
  final _tubingCtrl = TextEditingController();

  String? _hata;
  double? _hacim;
  _PanoSistemTipi? _sistem;
  bool _hacimAsimi = false;
  bool _tubingAsimi = false;
  bool _sizdirmazlikUyari = false;
  double? _ajanKg;

  void _hesapla() {
    setState(() {
      _hata = null;
      _sistem = null;
      _hacimAsimi = false;
      _tubingAsimi = false;
      _sizdirmazlikUyari = false;
      _ajanKg = null;
    });

    double v;
    if (_olcuModu) {
      final w = double.tryParse(_wCtrl.text.replaceAll(',', '.'));
      final l = double.tryParse(_lCtrl.text.replaceAll(',', '.'));
      final h = double.tryParse(_hCtrl.text.replaceAll(',', '.'));
      if (w == null || l == null || h == null || w <= 0 || l <= 0 || h <= 0) {
        setState(
          () => _hata = AppLocalizations.of(
            context,
          ).enterPanelCabinDimensionsFullyM,
        );
        return;
      }
      v = w * l * h;
    } else {
      final vv = double.tryParse(_vCtrl.text.replaceAll(',', '.'));
      if (vv == null || vv <= 0) {
        setState(
          () => _hata = AppLocalizations.of(context).enterPanelCabinVolumeM3,
        );
        return;
      }
      v = vv;
    }

    final temizGaz = _ajanGrubuIdx == 0;
    _PanoSistemTipi? sistem;
    bool hacimAsimi = false;
    if (temizGaz) {
      if (v <= _dlp.maxHacimM3) {
        sistem = _dlp;
      } else if (v <= _ilp.maxHacimM3) {
        sistem = _ilp;
      } else {
        hacimAsimi = true;
      }
    } else {
      if (v <= _dhp.maxHacimM3) {
        sistem = _dhp;
      } else if (v <= _ihp.maxHacimM3) {
        sistem = _ihp;
      } else {
        hacimAsimi = true;
      }
    }

    final tubing = double.tryParse(_tubingCtrl.text.replaceAll(',', '.'));
    final tubingAsimi =
        sistem != null && tubing != null && tubing > sistem.maxTubingM;
    // ILP tam sızdırmazlık ister (TÜYAK Dergi 33); açıklık varsa CO₂ grubuna geçilmeli.
    final sizdirmazlikUyari =
        sistem != null && sistem.sizdirmazlikZorunlu && !_sizdirmazMi;
    final ajanKg = sistem != null && !hacimAsimi ? _ajanMiktariKg(v) : null;

    setState(() {
      _hacim = v;
      _sistem = sistem;
      _hacimAsimi = hacimAsimi;
      _tubingAsimi = tubingAsimi;
      _sizdirmazlikUyari = sizdirmazlikUyari;
      _ajanKg = ajanKg;
    });

    final ajanAdi = _ajanGrubuIdx == 1 ? 'CO₂' : _temizAjanlar[_temizAjanIdx];
    ProjeServisi.hesapVeri = jsonEncode({
      'i': {
        'sekme': 'pano',
        'ajanGrubuIdx': _ajanGrubuIdx.toString(),
        'temizAjanIdx': _temizAjanIdx.toString(),
        'olcuModu': _olcuModu.toString(),
        'w': _wCtrl.text,
        'l': _lCtrl.text,
        'h': _hCtrl.text,
        'v': _vCtrl.text,
        'sizdirmazMi': _sizdirmazMi.toString(),
        'tubing': _tubingCtrl.text,
      },
      'r':
          '## Pano İçi Söndürme Sistemi\n'
          'Ajan Grubu: ${_ajanGruplari[_ajanGrubuIdx]}  |  Hacim: ${v.toStringAsFixed(2)} m³\n'
          '## Hesap Sonuçları\n'
          '${sistem != null ? "Önerilen Sistem: ${sistem.ad} (${sistem.standart}, ${sistem.sertifika})  |  Maks. Tubing: ${sistem.maxTubingM.toStringAsFixed(0)} m" : "Hacim, pre-engineered pano içi sistem sınırlarını aşıyor — mühendislik hesaplı sistem (Mahal sekmesi) gereklidir."}'
          '${ajanKg != null ? "\nTahmini Ajan Miktarı: ${ajanKg.toStringAsFixed(2)} kg $ajanAdi (üretici onaylı silindir tablosuyla teyit edilmelidir)" : ""}'
          '${sizdirmazlikUyari ? "\nUYARI: ILP tam sızdırmazlık gerektirir; pano kapatılamayan açıklık içeriyor — CO₂ grubuna (DHP/IHP) geçilmeli veya pano sızdırmaz hâle getirilmelidir." : ""}',
    });
    ProjeServisi.hesapSinyali.value = true;
  }

  @override
  void initState() {
    super.initState();
    final g = ProjeServisi.kayitliGirdiler;
    if (g != null && g['sekme'] == 'pano') {
      ProjeServisi.kayitliGirdiler = null;
      _ajanGrubuIdx = int.tryParse(g['ajanGrubuIdx'] ?? '0') ?? 0;
      _temizAjanIdx = int.tryParse(g['temizAjanIdx'] ?? '0') ?? 0;
      _olcuModu = g['olcuModu'] == 'true';
      _wCtrl.text = g['w'] ?? '';
      _lCtrl.text = g['l'] ?? '';
      _hCtrl.text = g['h'] ?? '';
      _vCtrl.text = g['v'] ?? '';
      _sizdirmazMi = g['sizdirmazMi'] != 'false';
      _tubingCtrl.text = g['tubing'] ?? '';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _hesapla();
      });
    }
  }

  @override
  void dispose() {
    _wCtrl.dispose();
    _lCtrl.dispose();
    _hCtrl.dispose();
    _vCtrl.dispose();
    _tubingCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _InfoBox(
            color: const Color(0xFFECFEFF),
            border: _kPano,
            child: Text(
              l10n.panoInfoBoxText,
              style: const TextStyle(
                fontSize: 11,
                height: 1.5,
                color: Color(0xFF0E7490),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Ajan grubu
          SegmentedButton<int>(
            segments: [
              ButtonSegment(
                value: 0,
                label: Text(l10n.cleanAgent, style: TextStyle(fontSize: 12)),
                icon: Icon(Icons.eco_rounded),
              ),
              ButtonSegment(
                value: 1,
                label: Text('CO₂', style: TextStyle(fontSize: 12)),
                icon: Icon(Icons.cloud_rounded),
              ),
            ],
            selected: {_ajanGrubuIdx},
            onSelectionChanged: (s) => setState(() => _ajanGrubuIdx = s.first),
          ),
          const SizedBox(height: 4),
          Text(
            _panoAgentGroupName(l10n, _ajanGrubuIdx),
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
          if (_ajanGrubuIdx == 0) ...[
            const SizedBox(height: 10),
            SegmentedButton<int>(
              segments: [
                ButtonSegment(
                  value: 0,
                  label: Text(
                    'FK-5-1-12 (NOVEC1230)',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                ButtonSegment(
                  value: 1,
                  label: Text('HFC-227ea', style: TextStyle(fontSize: 12)),
                ),
              ],
              selected: {_temizAjanIdx},
              onSelectionChanged: (s) =>
                  setState(() => _temizAjanIdx = s.first),
            ),
          ],
          const SizedBox(height: 12),

          // Hacim giriş modu
          SegmentedButton<bool>(
            segments: [
              ButtonSegment(
                value: true,
                label: Text(
                  l10n.panelDimensions,
                  style: TextStyle(fontSize: 12),
                ),
                icon: Icon(Icons.straighten_rounded),
              ),
              ButtonSegment(
                value: false,
                label: Text(l10n.directVolume, style: TextStyle(fontSize: 12)),
                icon: Icon(Icons.view_in_ar_rounded),
              ),
            ],
            selected: {_olcuModu},
            onSelectionChanged: (s) => setState(() => _olcuModu = s.first),
          ),
          const SizedBox(height: 10),

          if (_olcuModu) ...[
            Row(
              children: [
                Expanded(child: _panoField(l10n.singleWidth, _wCtrl, 'm')),
                const SizedBox(width: 8),
                Expanded(child: _panoField(l10n.singleLength, _lCtrl, 'm')),
                const SizedBox(width: 8),
                Expanded(child: _panoField(l10n.panelHeight, _hCtrl, 'm')),
              ],
            ),
          ] else
            _panoField(l10n.panelCabinetVolume, _vCtrl, 'm³'),
          const SizedBox(height: 12),

          CheckboxListTile(
            value: _sizdirmazMi,
            onChanged: (v) => setState(() => _sizdirmazMi = v ?? true),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            dense: true,
            activeColor: _kPano,
            title: Text(
              l10n.panoNoOpeningLabel,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          if (!_sizdirmazMi) ...[
            const SizedBox(height: 4),
            _InfoBox(
              color: const Color(0xFFFEE2E2),
              border: const Color(0xFFFCA5A5),
              child: Text(
                l10n.panoOpeningWarning,
                style: const TextStyle(fontSize: 11, color: Color(0xFFDC2626)),
              ),
            ),
          ],
          const SizedBox(height: 12),

          _panoField(
            l10n.panoTubingLengthLabel,
            _tubingCtrl,
            'm',
          ),
          const SizedBox(height: 16),

          if (_hata != null) ...[
            _InfoBox(
              color: const Color(0xFFFEE2E2),
              border: const Color(0xFFFCA5A5),
              child: Text(
                _hata!,
                style: const TextStyle(color: Color(0xFFDC2626), fontSize: 13),
              ),
            ),
            const SizedBox(height: 8),
          ],

          ElevatedButton.icon(
            onPressed: _hesapla,
            icon: const Icon(Icons.calculate_rounded),
            label: Text(AppLocalizations.of(context)!.calculate),
            style: ElevatedButton.styleFrom(
              backgroundColor: _kPano,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          if (_hacim != null) ...[
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _kPano, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.electrical_services_rounded,
                        color: Color(0xFF0891B2),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.panoRecommendedSystemCaps,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Color(0xFF0891B2),
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  _GazSonucSatir(
                    etiket: l10n.panelCabinetVolume,
                    deger: '${_hacim!.toStringAsFixed(2)} m³',
                  ),
                  if (_hacimAsimi) ...[
                    const SizedBox(height: 8),
                    _InfoBox(
                      color: const Color(0xFFFEE2E2),
                      border: const Color(0xFFFCA5A5),
                      child: Text(
                        l10n.panoVolumeExceededWarning(
                          _ajanGrubuIdx == 0
                              ? l10n.panoIlpMaxVolume(
                                  _ilp.maxHacimM3.toStringAsFixed(0),
                                )
                              : l10n.panoIhpMaxVolume(
                                  _ihp.maxHacimM3.toStringAsFixed(0),
                                ),
                          l10n.gasRoomTab,
                        ),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFFDC2626),
                        ),
                      ),
                    ),
                  ] else if (_sistem != null) ...[
                    const SizedBox(height: 4),
                    _GazSonucSatir(
                      etiket: l10n.systemType,
                      deger: _sistem!.kod,
                    ),
                    const SizedBox(height: 8),
                    _InfoBox(
                      color: const Color(0xFFF8FAFC),
                      border: const Color(0xFFCBD5E1),
                      child: Text(
                        _panoSistemAciklama(l10n, _sistem!),
                        style: const TextStyle(
                          fontSize: 11,
                          height: 1.5,
                          color: Color(0xFF334155),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _GazSonucSatir(
                      etiket: l10n.standard,
                      deger: _sistem!.standart,
                    ),
                    const SizedBox(height: 4),
                    _GazSonucSatir(
                      etiket: l10n.certification,
                      deger: _sistem!.sertifika,
                    ),
                    const SizedBox(height: 4),
                    _GazSonucSatir(
                      etiket: l10n.maximumTubingLength,
                      deger: '${_sistem!.maxTubingM.toStringAsFixed(0)} m',
                    ),
                    if (_ajanKg != null) ...[
                      const SizedBox(height: 4),
                      _GazSonucSatir(
                        etiket: l10n.estimatedAgentAmount,
                        deger:
                            '${_ajanKg!.toStringAsFixed(2)} kg '
                            '${_ajanGrubuIdx == 1 ? 'CO₂' : _temizAjanlar[_temizAjanIdx]}',
                      ),
                      const SizedBox(height: 8),
                      _InfoBox(
                        color: const Color(0xFFECFEFF),
                        border: const Color(0xFF67E8F9),
                        child: Text(
                          l10n.panoAgentAmountNote(
                            _ajanGrubuIdx == 1
                                ? _co2TasarimYuzde.toStringAsFixed(0)
                                : (_temizAjanIdx == 0
                                          ? _fk512TasarimYuzde
                                          : _hfc227TasarimYuzde)
                                      .toStringAsFixed(1),
                          ),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF0E7490),
                          ),
                        ),
                      ),
                    ],
                    if (_tubingAsimi) ...[
                      const SizedBox(height: 8),
                      _InfoBox(
                        color: const Color(0xFFFEE2E2),
                        border: const Color(0xFFFCA5A5),
                        child: Text(
                          l10n.panoTubingExceededWarning(
                            _tubingCtrl.text,
                            _sistem!.kod,
                            _sistem!.maxTubingM.toStringAsFixed(0),
                          ),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFFDC2626),
                          ),
                        ),
                      ),
                    ],
                    if (_sizdirmazlikUyari) ...[
                      const SizedBox(height: 8),
                      _InfoBox(
                        color: const Color(0xFFFEE2E2),
                        border: const Color(0xFFFCA5A5),
                        child: Text(
                          l10n.panoSealingWarning,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFFDC2626),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    _InfoBox(
                      color: const Color(0xFFECFEFF),
                      border: const Color(0xFF67E8F9),
                      child: Text(
                        _panoSistemDesarjNotu(l10n, _sistem!),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF0E7490),
                        ),
                      ),
                    ),
                    if (_ajanGrubuIdx == 1) ...[
                      const SizedBox(height: 8),
                      _InfoBox(
                        color: const Color(0xFFFFF7ED),
                        border: const Color(0xFFFBBF24),
                        child: Text(
                          l10n.panoCo2ToxicityWarning,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF92400E),
                          ),
                        ),
                      ),
                      if (!_sizdirmazMi) ...[
                        const SizedBox(height: 8),
                        _InfoBox(
                          color: const Color(0xFFFFF7ED),
                          border: const Color(0xFFFBBF24),
                          child: Text(
                            l10n.panoNoSealingRequiredNote,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF92400E),
                            ),
                          ),
                        ),
                      ],
                    ],
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 6),
                    Text(
                      l10n.panoDesignRequirementsTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Color(0xFF0891B2),
                      ),
                    ),
                    const SizedBox(height: 6),
                    _InfoBox(
                      color: const Color(0xFFECFEFF),
                      border: const Color(0xFF67E8F9),
                      child: Text(
                        '${_sistem!.kod == 'ILP' || _sistem!.kod == 'IHP' ? l10n.panoManualReleaseNote(_sistem!.kod) : ''}'
                        '${l10n.panoDesignRequirementsBody}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF0E7490),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 6),
                  Text(
                    l10n.panoMaintenanceScheduleTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Color(0xFF0891B2),
                    ),
                  ),
                  const SizedBox(height: 6),
                  _InfoBox(
                    color: const Color(0xFFECFEFF),
                    border: const Color(0xFF67E8F9),
                    child: Text(
                      l10n.panoMaintenanceScheduleBody,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF0E7490),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 20),
          Text(
            l10n.panoSourceFooter,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: Colors.black38),
          ),
        ],
      ),
    );
  }

  Widget _panoField(String lbl, TextEditingController ctrl, String suffix) =>
      TextField(
        controller: ctrl,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: lbl,
          suffixText: suffix,
          border: const OutlineInputBorder(),
          isDense: true,
          labelStyle: const TextStyle(color: _kPano),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: _kPano, width: 2),
          ),
        ),
      );
}

// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
// DUMAN ALGILAMA — TS EN 54-7 / EN 54-14
// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦

class _OdaModel {
  final String uid;
  String ad;
  int odaTipiIdx;
  double w, l, h;
  int? detSayisi;
  double? aralikX, aralikY, duvarX, duvarY, snKullan;
  bool yuksekTavan = false;
  bool isinOneri = false;

  _OdaModel({
    required this.uid,
    required this.ad,
    required this.odaTipiIdx,
    required this.w,
    required this.l,
    required this.h,
  });

  _OdaModel kopyala(String yeniUid) {
    final k = _OdaModel(
      uid: yeniUid,
      ad: '$ad (kopya)',
      odaTipiIdx: odaTipiIdx,
      w: w,
      l: l,
      h: h,
    );
    k.detSayisi = detSayisi;
    k.aralikX = aralikX;
    k.aralikY = aralikY;
    k.duvarX = duvarX;
    k.duvarY = duvarY;
    k.snKullan = snKullan;
    k.yuksekTavan = yuksekTavan;
    k.isinOneri = isinOneri;
    return k;
  }
}

class _KatModel {
  final String uid;
  String ad;
  final List<_OdaModel> odalar = [];
  bool genisletildi = true;

  _KatModel({required this.uid, required this.ad});

  int get toplamDet => odalar.fold(0, (s, o) => s + (o.detSayisi ?? 0));
}

class DumanAlgilama extends StatefulWidget {
  const DumanAlgilama({super.key});
  @override
  State<DumanAlgilama> createState() => _DumanAlgilamaState();
}

class _DumanAlgilamaState extends State<DumanAlgilama> {
  static const Color _kA = Color(0xFF7C2D12);

  static const List<(String, double)> _yapiTipleri = [
    ('Ofis / İdari', 2.8),
    ('Konut / Otel', 2.6),
    ('Hastane', 3.0),
    ('Ticari / AVM', 4.5),
    ('Depo (normal ≤ 6 m)', 6.0),
    ('Depo (yüksek > 6 m)', 9.0),
    ('Endüstriyel', 7.0),
  ];

  static const List<(String, String, bool)> _odaTipleri = [
    ('Standart Oda', 'Düz tavan, engelsiz', false),
    ('Açık Ofis', 'Geniş, düz tavan', false),
    ('Teknik / Tesisat', 'Ekipman yoğun — S_n × 0.75', false),
    ('Mutfak / Pişirme', 'Hassas — S_n × 0.50', false),
    ('Koridor (G ≤ 3 m)', 'Tek sıra yerleşim', true),
    ('Üretim / Montaj', 'Engel olabilir — S_n × 0.75', false),
    ('Depo Rafı', 'Raf arası — S_n × 0.75', false),
  ];

  List<String> _odaTipEtiketleri(AppLocalizations l10n) => [
    l10n.roomStandard,
    l10n.roomOpenOffice,
    l10n.roomTechnical,
    l10n.roomKitchen,
    l10n.roomCorridor,
    l10n.roomProduction,
    l10n.roomWarehouseRack,
  ];

  int _yapiIdx = 0;
  final List<_KatModel> _katlar = [];
  int _uidSayac = 0;

  String _uid() => '${++_uidSayac}';

  double get _varsayilanH => _yapiTipleri[_yapiIdx].$2;

  void _hesaplaOda(_OdaModel o) {
    final h = o.h;
    o.yuksekTavan = h > 12.0;
    o.isinOneri = h > 8.0 && h <= 12.0;

    if (h > 12.0) {
      o.detSayisi = null;
      return;
    }

    final double sn = h <= 6.0
        ? 80.0
        : h <= 8.0
        ? 60.0
        : 40.0;
    final double snOda = switch (o.odaTipiIdx) {
      2 || 5 || 6 => sn * 0.75,
      3 => sn * 0.50,
      _ => sn,
    };

    final bool koridor = _odaTipleri[o.odaTipiIdx].$3 || o.w <= 3.0;
    if (koridor) {
      final d = h <= 6.0 ? 11.0 : 8.0;
      final n = (o.l / d).ceil();
      o.detSayisi = n;
      o.aralikX = o.l / n;
      o.aralikY = null;
      o.duvarX = (o.l / n) / 2;
      o.duvarY = o.w / 2;
    } else {
      final d = math.sqrt(snOda);
      final nX = (o.w / d).ceil();
      final nY = (o.l / d).ceil();
      o.detSayisi = nX * nY;
      o.aralikX = o.w / nX;
      o.aralikY = o.l / nY;
      o.duvarX = (o.w / nX) / 2;
      o.duvarY = (o.l / nY) / 2;
    }
    o.snKullan = snOda;
    ProjeServisi.hesapVeri =
        'Yap\u0131: ${_yapiTipleri[_yapiIdx].$1}\n'
        'Oda: ${o.ad}  |  ${o.w}\u00d7${o.l} m  |  H=${o.h} m  |  Detekt\u00f6r: ${o.detSayisi ?? "-"} adet';
    ProjeServisi.hesapSinyali.value = true;
  }

  Future<void> _odaDialog({required String katUid, _OdaModel? duzelt}) async {
    final l10n = AppLocalizations.of(context);
    final odaEtiketleri = _odaTipEtiketleri(l10n);
    final kat = _katlar.firstWhere((k) => k.uid == katUid);
    int odaTipiIdx = duzelt?.odaTipiIdx ?? 0;
    final adCtrl = TextEditingController(text: duzelt?.ad ?? odaEtiketleri[0]);
    final wCtrl = TextEditingController(
      text: duzelt != null ? duzelt.w.toString() : '',
    );
    final lCtrl = TextEditingController(
      text: duzelt != null ? duzelt.l.toString() : '',
    );
    final hCtrl = TextEditingController(
      text: (duzelt?.h ?? _varsayilanH).toString(),
    );
    String? hata;

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          title: Text(
            duzelt == null ? l10n.addRoomArea : l10n.editRoomArea,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7C2D12),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: adCtrl,
                  decoration: InputDecoration(
                    labelText: l10n.roomAreaName,
                    hintText: l10n.roomAreaExample,
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.areaType,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: List.generate(_odaTipleri.length, (i) {
                    final sel = odaTipiIdx == i;
                    return GestureDetector(
                      onTap: () => setS(() {
                        final prevAd = odaEtiketleri[odaTipiIdx];
                        odaTipiIdx = i;
                        if (adCtrl.text.isEmpty || adCtrl.text == prevAd) {
                          adCtrl.text = odaEtiketleri[i];
                        }
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: sel ? const Color(0xFF7C2D12) : Colors.white,
                          border: Border.all(color: const Color(0xFF7C2D12)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          odaEtiketleri[i],
                          style: TextStyle(
                            fontSize: 11,
                            color: sel ? Colors.white : const Color(0xFF7C2D12),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: wCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.unitWidth,
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: TextField(
                        controller: lCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.unitLength,
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: TextField(
                        controller: hCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.unitHeight,
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
                if (hata != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    hata!,
                    style: const TextStyle(
                      color: Color(0xFFDC2626),
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C2D12),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final w = double.tryParse(wCtrl.text.replaceAll(',', '.'));
                final l = double.tryParse(lCtrl.text.replaceAll(',', '.'));
                final h = double.tryParse(hCtrl.text.replaceAll(',', '.'));
                if (w == null ||
                    l == null ||
                    h == null ||
                    w <= 0 ||
                    l <= 0 ||
                    h <= 0) {
                  setS(() => hata = l10n.validDimensions);
                  return;
                }
                if (adCtrl.text.trim().isEmpty) {
                  setS(() => hata = l10n.roomNameRequired);
                  return;
                }
                setState(() {
                  if (duzelt != null) {
                    duzelt.ad = adCtrl.text.trim();
                    duzelt.odaTipiIdx = odaTipiIdx;
                    duzelt.w = w;
                    duzelt.l = l;
                    duzelt.h = h;
                    _hesaplaOda(duzelt);
                  } else {
                    final oda = _OdaModel(
                      uid: _uid(),
                      ad: adCtrl.text.trim(),
                      odaTipiIdx: odaTipiIdx,
                      w: w,
                      l: l,
                      h: h,
                    );
                    _hesaplaOda(oda);
                    kat.odalar.add(oda);
                  }
                });
                Navigator.pop(ctx);
              },
              child: Text(duzelt == null ? l10n.add : l10n.save),
            ),
          ],
        ),
      ),
    );
    adCtrl.dispose();
    wCtrl.dispose();
    lCtrl.dispose();
    hCtrl.dispose();
  }

  Future<void> _katAdDialog(_KatModel kat) async {
    final l10n = AppLocalizations.of(context);
    final ctrl = TextEditingController(text: kat.ad);
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.floorZone),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C2D12),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                setState(() => kat.ad = ctrl.text.trim());
              }
              Navigator.pop(ctx);
            },
            child: Text(l10n.done),
          ),
        ],
      ),
    );
    ctrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final toplamDet = _katlar.fold(0, (s, k) => s + k.toplamDet);
    final yapiEtiketleri = [
      l10n.buildingOffice,
      l10n.buildingHome,
      l10n.buildingHospital,
      l10n.buildingCommercial,
      l10n.buildingWarehouseNormal,
      l10n.buildingWarehouseHigh,
      l10n.buildingIndustrial,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.smokeDetectionTitle,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: _kA,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Standart referansı
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFED7AA)),
              ),
              child: Text(
                l10n.smokeReference,
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF92400E),
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Yapı tipi
            Text(
              l10n.buildingType,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: List.generate(_yapiTipleri.length, (i) {
                final sec = _yapiIdx == i;
                return ChoiceChip(
                  label: Text(
                    yapiEtiketleri[i],
                    style: TextStyle(
                      fontSize: 12,
                      color: sec ? Colors.white : _kA,
                    ),
                  ),
                  selected: sec,
                  selectedColor: _kA,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: _kA),
                  ),
                  showCheckmark: false,
                  onSelected: (_) => setState(() => _yapiIdx = i),
                );
              }),
            ),
            const SizedBox(height: 4),
            Text(
              '${l10n.defaultCeilingHeight(_varsayilanH.toStringAsFixed(1))} (${l10n.editablePerRoom})',
              style: const TextStyle(fontSize: 10, color: Colors.black45),
            ),
            const SizedBox(height: 16),

            // Kat / Bölge listesi
            ..._katlar.map(
              (kat) => _KatKarti(
                kat: kat,
                kA: _kA,
                odaTipleri: _odaTipleri,
                onOdaEkle: () => _odaDialog(katUid: kat.uid),
                onOdaDuzenle: (o) => _odaDialog(katUid: kat.uid, duzelt: o),
                onOdaSil: (o) => setState(() => kat.odalar.remove(o)),
                onOdaKopyala: (o) => setState(() {
                  final idx = kat.odalar.indexOf(o);
                  kat.odalar.insert(
                    idx + 1,
                    o.kopyala(DateTime.now().microsecondsSinceEpoch.toString()),
                  );
                }),
                onKatAdDuzenle: () => _katAdDialog(kat),
                onKatSil: () => setState(() => _katlar.remove(kat)),
                onGenislet: () =>
                    setState(() => kat.genisletildi = !kat.genisletildi),
              ),
            ),

            // + Kat / Bölge Ekle
            OutlinedButton.icon(
              onPressed: () {
                final idx = _katlar.length + 1;
                setState(
                  () => _katlar.add(
                    _KatModel(uid: _uid(), ad: '${l10n.floorZone} $idx'),
                  ),
                );
              },
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.addFloorZone),
              style: OutlinedButton.styleFrom(
                foregroundColor: _kA,
                side: BorderSide(color: _kA),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            // Genel Toplam
            if (_katlar.isNotEmpty && toplamDet > 0) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: _kA,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.sensors_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l10n.totalDetectors,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      l10n.detectorCount(toplamDet),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),
            Text(
              '${l10n.sourceLabel}: TS EN 54-7:2006 · EN 54-14:2004',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, color: Colors.black38),
            ),
          ],
        ),
      ),
    );
  }
}

class _KatKarti extends StatelessWidget {
  final _KatModel kat;
  final Color kA;
  final List<(String, String, bool)> odaTipleri;
  final VoidCallback onOdaEkle, onKatAdDuzenle, onKatSil, onGenislet;
  final void Function(_OdaModel) onOdaDuzenle, onOdaSil, onOdaKopyala;

  const _KatKarti({
    required this.kat,
    required this.kA,
    required this.odaTipleri,
    required this.onOdaEkle,
    required this.onOdaDuzenle,
    required this.onOdaSil,
    required this.onOdaKopyala,
    required this.onKatAdDuzenle,
    required this.onKatSil,
    required this.onGenislet,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFFED7AA), width: 1.5),
          boxShadow: const [BoxShadow(color: Color(0x0F000000), blurRadius: 4)],
        ),
        child: Column(
          children: [
            // Kat başlığı
            InkWell(
              onTap: onGenislet,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      kat.genisletildi
                          ? Icons.expand_less_rounded
                          : Icons.expand_more_rounded,
                      color: kA,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        kat.ad,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: kA,
                        ),
                      ),
                    ),
                    Text(
                      l10n.floorZoneSummary(kat.odalar.length, kat.toplamDet),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black45,
                      ),
                    ),
                    const SizedBox(width: 6),
                    IconButton(
                      icon: const Icon(Icons.edit_rounded, size: 16),
                      color: kA,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: onKatAdDuzenle,
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(Icons.delete_rounded, size: 16),
                      color: Colors.red,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: onKatSil,
                    ),
                  ],
                ),
              ),
            ),

            if (kat.genisletildi) ...[
              // Oda listesi
              ...kat.odalar.map(
                (o) => _OdaSatiri(
                  oda: o,
                  kA: kA,
                  odaTipleri: odaTipleri,
                  onDuzenle: () => onOdaDuzenle(o),
                  onSil: () => onOdaSil(o),
                  onKopyala: () => onOdaKopyala(o),
                ),
              ),

              // + Oda Ekle butonu
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                child: OutlinedButton.icon(
                  onPressed: onOdaEkle,
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: Text(l10n.addRoomArea, style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kA,
                    side: BorderSide(color: kA),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _OdaSatiri extends StatefulWidget {
  final _OdaModel oda;
  final Color kA;
  final List<(String, String, bool)> odaTipleri;
  final VoidCallback onDuzenle, onSil, onKopyala;

  const _OdaSatiri({
    required this.oda,
    required this.kA,
    required this.odaTipleri,
    required this.onDuzenle,
    required this.onSil,
    required this.onKopyala,
  });

  @override
  State<_OdaSatiri> createState() => _OdaSatiriState();
}

class _OdaSatiriState extends State<_OdaSatiri> {
  bool _acik = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final o = widget.oda;
    final tip = [
      l10n.roomStandard,
      l10n.roomOpenOffice,
      l10n.roomTechnical,
      l10n.roomKitchen,
      l10n.roomCorridor,
      l10n.roomProduction,
      l10n.roomWarehouseRack,
    ][o.odaTipiIdx];
    return Column(
      children: [
        const Divider(height: 1, indent: 12, endIndent: 12),
        InkWell(
          onTap: () => setState(() => _acik = !_acik),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.meeting_room_rounded, size: 15, color: widget.kA),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        o.ad,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '$tip  ·  ${o.w}×${o.l} m  ·  H=${o.h} m',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                if (o.yuksekTavan)
                  const Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: Text('⚠', style: TextStyle(fontSize: 14)),
                  )
                else if (o.detSayisi != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7C2D12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      l10n.detectorBadge(o.detSayisi!),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const SizedBox(width: 6),
                IconButton(
                  icon: const Icon(Icons.copy_rounded, size: 15),
                  color: Colors.grey,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: l10n.copy,
                  onPressed: widget.onKopyala,
                ),
                const SizedBox(width: 2),
                IconButton(
                  icon: const Icon(Icons.edit_rounded, size: 15),
                  color: widget.kA,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: widget.onDuzenle,
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.delete_rounded, size: 15),
                  color: Colors.red,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: widget.onSil,
                ),
              ],
            ),
          ),
        ),
        if (_acik)
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 0, 12, 8),
            child: o.yuksekTavan
                ? Text(
                    l10n.highCeilingNotice,
                    style: TextStyle(fontSize: 11, color: Color(0xFFDC2626)),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (o.isinOneri)
                        Text(
                          l10n.beamRecommendation,
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF92400E),
                          ),
                        ),
                      if (o.aralikY != null) ...[
                        Text(
                          '${l10n.widthSpacing(o.aralikX!.toStringAsFixed(2))} | ${l10n.lengthSpacing(o.aralikY!.toStringAsFixed(2))}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          '${l10n.wallDistanceWidth(o.duvarX!.toStringAsFixed(2))} | ${l10n.wallDistanceLength(o.duvarY!.toStringAsFixed(2))}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black54,
                          ),
                        ),
                      ] else if (o.aralikX != null) ...[
                        Text(
                          '${l10n.corridorSpacing(o.aralikX!.toStringAsFixed(2))} | ${l10n.wallDistance(o.duvarY!.toStringAsFixed(2))}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                      if (o.snKullan != null)
                        Text(
                          l10n.snAreaPerDetector(
                            o.snKullan!.toStringAsFixed(0),
                          ),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.black38,
                          ),
                        ),
                    ],
                  ),
          ),
      ],
    );
  }
}

// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
// DUMAN KONTROLÜ — EN 12101-2 / EN 12101-3 / EN 12101-6
// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦

class DumanKontrol extends StatefulWidget {
  const DumanKontrol({super.key});
  @override
  State<DumanKontrol> createState() => _DumanKontrolState();
}

class _DumanKontrolState extends State<DumanKontrol> {
  static const Color _kD = Color(0xFF374151);

  int _mod = 0; // 0=Doğal, 1=Mekanik, 2=Basınçlandırma

  final _alanCtrl = TextEditingController();
  final _yukseklikCtrl = TextEditingController();
  final _qCtrl = TextEditingController();
  final _zCtrl = TextEditingController();
  final _tambiCtrl = TextEditingController(text: '20');
  final _havaDeCtrl = TextEditingController(
    text: '10',
  ); // sabit EN 12101-3 min.
  final _katCtrl = TextEditingController(text: '5');
  final _kapiGenCtrl = TextEditingController(text: '0.9');
  final _kapiYukCtrl = TextEditingController(text: '2.0');
  final _mGenCtrl = TextEditingController(text: '2.0');
  final _mDepCtrl = TextEditingController(text: '2.0');
  final _katYukCtrl = TextEditingController(text: '3.0');

  // EN 12101-6 Ek F Tablo F.1: duvar malzemesi → sızıntı katsayısı (m²/m²)
  static const _duvarMalzemeler = [
    ('Beton / Kagir', 1.3e-4),
    ('Hafif Beton Blok', 2.0e-4),
    ('Alçıpan (Çift)', 3.0e-4),
  ];
  int _duvarMalzemeIdx = 0;

  List<String> _duvarMalzemeEtiketleri(AppLocalizations l10n) => [
    l10n.wallMaterialConcrete,
    l10n.wallMaterialLightBlock,
    l10n.wallMaterialGypsum,
  ];

  String? _hata;
  double? _mp, _Ts, _dT, _AvEff, _Ai;
  double? _vDot, _havaD, _fanM3h;
  bool _minHDYonetir = false; // true = min. hava değişimi kriterini yönetir
  double? _qKapi, _qSizinti, _qDuvar, _qToplam;

  @override
  void initState() {
    super.initState();
    _yukseklikCtrl.addListener(() {
      final H = double.tryParse(_yukseklikCtrl.text.replaceAll(',', '.'));
      if (H != null && H > 0) {
        final zOto = double.parse((math.max(2.5, H * 0.7)).toStringAsFixed(1));
        _zCtrl.text = zOto.toString();
        _zCtrl.selection = TextSelection.collapsed(offset: _zCtrl.text.length);
      }
      setState(() {});
    });
    _zCtrl.addListener(() => setState(() {}));
    final g = ProjeServisi.kayitliGirdiler;
    if (g != null) {
      ProjeServisi.kayitliGirdiler = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          _mod = int.tryParse(g['mod'] ?? '0') ?? 0;
          _duvarMalzemeIdx = int.tryParse(g['duvarIdx'] ?? '0') ?? 0;
        });
        _alanCtrl.text = g['alan'] ?? '';
        _yukseklikCtrl.text = g['yuks'] ?? '';
        _zCtrl.text = g['z'] ?? '';
        _qCtrl.text = g['q'] ?? '';
        _tambiCtrl.text = g['tambi'] ?? '20';
        _havaDeCtrl.text = g['havaDe'] ?? '10';
        _katCtrl.text = g['kat'] ?? '5';
        _kapiGenCtrl.text = g['kapiGen'] ?? '0.9';
        _kapiYukCtrl.text = g['kapiYuk'] ?? '2.0';
        _mGenCtrl.text = g['mGen'] ?? '2.0';
        _mDepCtrl.text = g['mDep'] ?? '2.0';
        _katYukCtrl.text = g['katYuk'] ?? '3.0';
        _hesapla();
      });
    }
  }

  @override
  void dispose() {
    for (final c in [
      _alanCtrl,
      _yukseklikCtrl,
      _qCtrl,
      _zCtrl,
      _tambiCtrl,
      _havaDeCtrl,
      _katCtrl,
      _kapiGenCtrl,
      _kapiYukCtrl,
      _mGenCtrl,
      _mDepCtrl,
      _katYukCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _hesapla() {
    final alan = double.tryParse(_alanCtrl.text.replaceAll(',', '.'));
    final H = double.tryParse(_yukseklikCtrl.text.replaceAll(',', '.'));
    final Q = double.tryParse(_qCtrl.text.replaceAll(',', '.'));
    final T0 =
        (double.tryParse(_tambiCtrl.text.replaceAll(',', '.')) ?? 20) + 273.15;

    if (_mod < 2) {
      if (alan == null || alan <= 0) {
        setState(() => _hata = AppLocalizations.of(context).enterRoomAreaM2);
        return;
      }
      if (H == null || H <= 0) {
        setState(
          () => _hata = AppLocalizations.of(context).enterCeilingHeightSimpleM,
        );
        return;
      }
      if (Q == null || Q <= 0) {
        setState(() => _hata = AppLocalizations.of(context).enterDesignHrrKw);
        return;
      }
      final z = double.tryParse(_zCtrl.text.replaceAll(',', '.'));
      if (z == null || z <= 0 || z >= H) {
        setState(
          () => _hata = AppLocalizations.of(context).smokeLayerHeightRangeError,
        );
        return;
      }

      const Cp = 1.0;
      const rho0 = 1.2;
      const g = 9.81;
      final Qc = 0.7 * Q;
      // Thomas plume (EN 12101-2 Ek B)
      final mp =
          0.071 * math.pow(Qc, 1 / 3.0) * math.pow(z, 5 / 3.0) + 0.0018 * Qc;
      final Ts = T0 + Qc / (mp * Cp);
      final dT = Ts - T0;

      setState(() {
        _hata = null;
        _mp = mp;
        _Ts = Ts;
        _dT = dT;
        _qKapi = null;
        _qSizinti = null;
        _qToplam = null;
      });

      if (_mod == 0) {
        // Doğal tahliye — EN 12101-2
        const Cd = 0.5;
        final d = H - z;
        final AvEff = mp / (Cd * math.sqrt(2 * rho0 * g * d * dT / Ts));
        setState(() {
          _AvEff = AvEff;
          _Ai = 1.1 * AvEff;
          _vDot = null;
          _havaD = null;
          _fanM3h = null;
        });
      } else {
        // Mekanik tahliye — EN 12101-3
        final minHD =
            double.tryParse(_havaDeCtrl.text.replaceAll(',', '.')) ?? 10;
        final rhoS = rho0 * T0 / Ts;
        final vDot = mp / rhoS;
        final V = alan * H;
        final havaD = vDot * 3600 / V;
        final fanM3h = math.max(vDot, minHD / 3600 * V) * 3600;
        final minHDYonetir = (minHD / 3600 * V) > vDot;
        setState(() {
          _vDot = vDot;
          _havaD = havaD;
          _fanM3h = fanM3h;
          _minHDYonetir = minHDYonetir;
          _AvEff = null;
          _Ai = null;
        });
      }
    } else {
      // Basınçlandırma — EN 12101-6
      final katSayi = int.tryParse(_katCtrl.text) ?? 5;
      final kG = double.tryParse(_kapiGenCtrl.text.replaceAll(',', '.')) ?? 0.9;
      final kY = double.tryParse(_kapiYukCtrl.text.replaceAll(',', '.')) ?? 2.0;
      final mGen = double.tryParse(_mGenCtrl.text.replaceAll(',', '.')) ?? 2.0;
      final mDep = double.tryParse(_mDepCtrl.text.replaceAll(',', '.')) ?? 2.0;
      final katYuk =
          double.tryParse(_katYukCtrl.text.replaceAll(',', '.')) ?? 3.0;
      const dP = 50.0;
      const rho0 = 1.2;
      const Cd = 0.83;
      final aSizinti = 2 * (kG + kY) * 0.01; // 10 mm kapı aralığı
      final qKapi = kG * kY * math.sqrt(2 * dP / rho0) * 3600;
      final qSizinti = Cd * aSizinti * math.sqrt(2 * dP / rho0) * 3600;
      // Duvar sızıntısı — EN 12101-6 Ek F Tablo F.1
      final sizKat = _duvarMalzemeler[_duvarMalzemeIdx].$2;
      final duvarAlani = 2 * (mGen + mDep) * katYuk * katSayi;
      final aDuvar = duvarAlani * sizKat;
      final qDuvar = aDuvar * math.sqrt(2 * dP / rho0) * 3600;
      final qToplam = qKapi + qSizinti * katSayi + qDuvar;
      setState(() {
        _hata = null;
        _qKapi = qKapi;
        _qSizinti = qSizinti;
        _qDuvar = qDuvar;
        _qToplam = qToplam;
        _mp = null;
        _Ts = null;
        _dT = null;
        _AvEff = null;
        _Ai = null;
        _vDot = null;
        _havaD = null;
        _fanM3h = null;
      });
    }
    final _modAdi = [
      'Do\u011fal Tahliye',
      'Mekanik Tahliye',
      'Bas\u0131n\u00e7land\u0131rma',
    ][_mod];
    ProjeServisi.hesapVeri = jsonEncode({
      'i': {
        'mod': _mod.toString(),
        'alan': _alanCtrl.text,
        'yuks': _yukseklikCtrl.text,
        'q': _qCtrl.text,
        'z': _zCtrl.text,
        'tambi': _tambiCtrl.text,
        'havaDe': _havaDeCtrl.text,
        'kat': _katCtrl.text,
        'kapiGen': _kapiGenCtrl.text,
        'kapiYuk': _kapiYukCtrl.text,
        'mGen': _mGenCtrl.text,
        'mDep': _mDepCtrl.text,
        'katYuk': _katYukCtrl.text,
        'duvarIdx': _duvarMalzemeIdx.toString(),
      },
      'r': _mod == 0
          ? '## Duman Kontrol - Do\u011fal Tahliye\n'
                'Sistem: $_modAdi\n'
                'Alan: ${_alanCtrl.text} m\u00b2  |  H: ${_yukseklikCtrl.text} m  |  Q: ${_qCtrl.text} kW  |  z: ${_zCtrl.text} m\n'
                '## Hesap Sonu\u00e7lar\u0131\n'
                'Duman Ak\u0131\u015f\u0131: ${_mp?.toStringAsFixed(3) ?? "-"} kg/s  |  Duman S\u0131c.: ${_Ts != null ? (_Ts! - 273.15).toStringAsFixed(0) : "-"} \u00b0C  |  dT: ${_dT?.toStringAsFixed(0) ?? "-"} K\n'
                'Av_eff: ${_AvEff?.toStringAsFixed(4) ?? "-"} m\u00b2  |  Giri\u015f Alan\u0131: ${_Ai?.toStringAsFixed(4) ?? "-"} m\u00b2'
          : _mod == 1
          ? '## Duman Kontrol - Mekanik Tahliye\n'
                'Sistem: $_modAdi\n'
                'Alan: ${_alanCtrl.text} m\u00b2  |  H: ${_yukseklikCtrl.text} m  |  Q: ${_qCtrl.text} kW\n'
                '## Hesap Sonu\u00e7lar\u0131\n'
                'Fan Debisi: ${_fanM3h?.toStringAsFixed(0) ?? "-"} m\u00b3/h  |  Hava De\u011fi\u015fimi: ${_havaD?.toStringAsFixed(2) ?? "-"} /h'
          : '## Duman Kontrol - Bas\u0131n\u00e7land\u0131rma\n'
                'Sistem: $_modAdi\n'
                'Kat Say\u0131s\u0131: ${_katCtrl.text}  |  Kap\u0131 Gen: ${_kapiGenCtrl.text} m  |  Kap\u0131 Y\u00fck: ${_kapiYukCtrl.text} m\n'
                '## Hesap Sonu\u00e7lar\u0131\n'
                'Q Toplam: ${_qToplam?.toStringAsFixed(0) ?? "-"} m\u00b3/h  |  Q Kap\u0131: ${_qKapi?.toStringAsFixed(0) ?? "-"} m\u00b3/h  |  Q S\u0131z\u0131nt\u0131: ${_qSizinti?.toStringAsFixed(0) ?? "-"} m\u00b3/h',
    });
    ProjeServisi.hesapSinyali.value = true;
  }

  InputDecoration _dec(String lbl, String sfx) => InputDecoration(
    labelText: lbl,
    suffixText: sfx,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    isDense: true,
  );

  Widget _field(String lbl, TextEditingController c, String sfx) => TextField(
    controller: c,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    decoration: _dec(lbl, sfx),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _kD.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _kD.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.air_rounded, color: _kD, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      l10n.smokeControlTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: _kD,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.smokeControlStandards,
                  style: TextStyle(fontSize: 11, color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          Text(
            l10n.systemType,
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 6),
          SegmentedButton<int>(
            segments: [
              ButtonSegment(
                value: 0,
                label: Text(
                  l10n.naturalExhaust,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11),
                ),
                icon: Icon(Icons.open_in_new_rounded, size: 16),
              ),
              ButtonSegment(
                value: 1,
                label: Text(
                  l10n.mechanicalExhaust,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11),
                ),
                icon: Icon(Icons.cyclone_rounded, size: 16),
              ),
              ButtonSegment(
                value: 2,
                label: Text(
                  l10n.pressurization,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11),
                ),
                icon: Icon(Icons.compress_rounded, size: 16),
              ),
            ],
            selected: {_mod},
            onSelectionChanged: (s) => setState(() {
              _mod = s.first;
              _hata = null;
            }),
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.resolveWith(
                (st) => st.contains(WidgetState.selected) ? Colors.white : _kD,
              ),
              backgroundColor: WidgetStateProperty.resolveWith(
                (st) => st.contains(WidgetState.selected) ? _kD : null,
              ),
            ),
          ),
          const SizedBox(height: 14),

          if (_mod < 2) ...[
            Row(
              children: [
                Expanded(child: _field(l10n.roomArea, _alanCtrl, 'm²')),
                const SizedBox(width: 8),
                Expanded(
                  child: _field(l10n.ceilingHeight, _yukseklikCtrl, 'm'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _field(l10n.designFirePower, _qCtrl, 'kW'),
            const SizedBox(height: 4),
            Text(
              l10n.designFirePowerHint,
              style: TextStyle(fontSize: 10, color: Colors.black45),
            ),
            const SizedBox(height: 6),
            OutlinedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Scaffold(
                    appBar: AppBar(
                      backgroundColor: const Color(0xFFB91C1C),
                      foregroundColor: Colors.white,
                      title: Text(
                        l10n.fireAndSuppression,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    body: const YanginYukuSayfasi(),
                  ),
                ),
              ),
              icon: const Icon(Icons.calculate_outlined, size: 16),
              label: Text(
                l10n.unknownFirePowerButton,
                style: const TextStyle(fontSize: 12),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: _kD,
                side: BorderSide(color: _kD.withOpacity(0.4)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 8),
            _field(l10n.smokeLayerHeight, _zCtrl, 'm'),
            const SizedBox(height: 4),
            Text(
              l10n.smokeLayerHeightHint,
              style: TextStyle(fontSize: 10, color: Colors.black45),
            ),
            Builder(
              builder: (_) {
                final H = double.tryParse(
                  _yukseklikCtrl.text.replaceAll(',', '.'),
                );
                final z = double.tryParse(_zCtrl.text.replaceAll(',', '.'));
                if (H == null || z == null || H <= 0)
                  return const SizedBox.shrink();
                final d = H - z;
                final warn = d > 0 && z < 2.5 && z < H;
                Color bg;
                Color fg;
                String msg;
                if (d <= 0 || z >= H) {
                  bg = const Color(0xFFFEE2E2);
                  fg = const Color(0xFFDC2626);
                  msg = l10n.smokeLayerHeightError(H.toStringAsFixed(1));
                } else if (warn) {
                  bg = const Color(0xFFFFFBEB);
                  fg = const Color(0xFFB45309);
                  msg = l10n.smokeLayerLowWarning(
                    z.toStringAsFixed(1),
                    d.toStringAsFixed(1),
                  );
                } else {
                  bg = const Color(0xFFF0FDF4);
                  fg = const Color(0xFF166534);
                  msg = l10n.smokeLayerDepthInfo(
                    z.toStringAsFixed(1),
                    d.toStringAsFixed(1),
                    H.toStringAsFixed(1),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(msg, style: TextStyle(fontSize: 11, color: fg)),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _field(l10n.ambientTemperature, _tambiCtrl, '°C'),
                ),
              ],
            ),
          ],

          if (_mod == 2) ...[
            Row(
              children: [
                Expanded(child: _field(l10n.doorWidth, _kapiGenCtrl, 'm')),
                const SizedBox(width: 8),
                Expanded(child: _field(l10n.doorHeight, _kapiYukCtrl, 'm')),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _field(l10n.stairShaftWidth, _mGenCtrl, 'm')),
                const SizedBox(width: 8),
                Expanded(child: _field(l10n.stairShaftDepth, _mDepCtrl, 'm')),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _field(l10n.floorHeight, _katYukCtrl, 'm')),
                const SizedBox(width: 8),
                Expanded(child: _field(l10n.floorCount, _katCtrl, 'kat')),
              ],
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: _duvarMalzemeIdx,
              decoration: InputDecoration(
                labelText: l10n.shaftWallMaterial,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                isDense: true,
              ),
              items: List.generate(
                _duvarMalzemeler.length,
                (i) => DropdownMenuItem(
                  value: i,
                  child: Text(
                    '${_duvarMalzemeEtiketleri(l10n)[i]}  —  ${(_duvarMalzemeler[i].$2 * 1e4).toStringAsFixed(1)}×10⁻⁴ m²/m²',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ),
              onChanged: (v) => setState(() => _duvarMalzemeIdx = v ?? 0),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.pressurizationConditions,
              style: TextStyle(fontSize: 10, color: Colors.black45),
            ),
          ],
          const SizedBox(height: 14),

          if (_hata != null) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFCA5A5)),
              ),
              child: Text(
                _hata!,
                style: const TextStyle(color: Color(0xFFDC2626), fontSize: 13),
              ),
            ),
            const SizedBox(height: 8),
          ],

          ElevatedButton.icon(
            onPressed: _hesapla,
            icon: const Icon(Icons.calculate_rounded),
            label: Text(l10n.calculate),
            style: ElevatedButton.styleFrom(
              backgroundColor: _kD,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: const Size(double.infinity, 0),
            ),
          ),

          // Doğal tahliye sonuçları
          if (_AvEff != null) ...[
            const SizedBox(height: 16),
            _DumanSonucKutu(
              renk: _kD,
              baslik: l10n.naturalExhaustResult,
              satirlar: [
                (l10n.smokeMassFlow, '${_mp!.toStringAsFixed(3)} kg/s'),
                (
                  l10n.smokeTemperature,
                  '${(_Ts! - 273.15).toStringAsFixed(1)} °C',
                ),
                (l10n.temperatureRise, '${_dT!.toStringAsFixed(1)} °C'),
                (l10n.effectiveOpening, '${_AvEff!.toStringAsFixed(2)} m²'),
                (l10n.minimumFreshAir, '${_Ai!.toStringAsFixed(2)} m²'),
              ],
            ),
            const SizedBox(height: 8),
            _dumanNot([
              l10n.smokeNoteNaturalPlume,
              l10n.smokeNoteNaturalCd,
              l10n.smokeNoteNaturalFreshAir,
              l10n.smokeNoteMinimumAreaCaveat,
              l10n.smokeNoteResponsibilityNatural,
            ]),
          ],

          // Mekanik tahliye sonuçları
          if (_fanM3h != null) ...[
            const SizedBox(height: 16),
            _DumanSonucKutu(
              renk: _kD,
              baslik: l10n.mechanicalExhaustResult,
              satirlar: [
                (l10n.smokeMassFlow, '${_mp!.toStringAsFixed(3)} kg/s'),
                (
                  l10n.smokeTemperature,
                  '${(_Ts! - 273.15).toStringAsFixed(1)} °C',
                ),
                (l10n.temperatureRise, '${_dT!.toStringAsFixed(1)} °C'),
                (
                  l10n.smokeVolumeFlow,
                  '${_vDot!.toStringAsFixed(3)} m³/s  (${(_vDot! * 3600).toStringAsFixed(0)} m³/h)',
                ),
                (
                  l10n.calculatedAirChanges,
                  '${_havaD!.toStringAsFixed(1)} 1/h',
                ),
                (
                  l10n.fanDesignFlow,
                  '${_fanM3h!.toStringAsFixed(0)} m³/h  →  ${_minHDYonetir ? l10n.fanCriterionMinAirChange : l10n.fanCriterionPlumeFlow}',
                ),
              ],
            ),
            const SizedBox(height: 8),
            _dumanNot([
              l10n.smokeNoteMechanicalPlume,
              l10n.smokeNoteMinAirChange,
              l10n.smokeNoteFanTempRating,
              l10n.smokeNoteFreshAirPercent,
              l10n.smokeNoteResponsibility,
            ]),
          ],

          // Basınçlandırma sonuçları
          if (_qToplam != null) ...[
            const SizedBox(height: 16),
            _DumanSonucKutu(
              renk: _kD,
              baslik: l10n.pressurizationResult,
              satirlar: [
                (l10n.targetPressureDifference, '50 Pa'),
                (l10n.openDoorFlow, '${_qKapi!.toStringAsFixed(0)} m³/h'),
                (
                  l10n.closedDoorLeakage,
                  '${_qSizinti!.toStringAsFixed(0)} m³/h',
                ),
                (l10n.wallLeakage, '${_qDuvar!.toStringAsFixed(0)} m³/h'),
                (l10n.totalFanFlow, '${_qToplam!.toStringAsFixed(0)} m³/h'),
              ],
            ),
            const SizedBox(height: 8),
            _dumanNot([
              l10n.smokeNoteDoorFlowExplain,
              l10n.smokeNoteDoorFlowFormula,
              l10n.smokeNoteWallLeakageConcrete,
              l10n.smokeNoteDoorGapCd,
              l10n.smokeNoteDoorForceCheck,
              l10n.smokeNotePressureLimit,
              l10n.smokeNoteResponsibility,
            ]),
          ],
        ],
      ),
    );
  }

  Widget _dumanNot(List<String> maddeler) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: const Color(0xFFF0FDF4),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: const Color(0xFF86EFAC)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: maddeler
          .map(
            (m) => Text(
              '• $m',
              style: const TextStyle(fontSize: 11, color: Color(0xFF166534)),
            ),
          )
          .toList(),
    ),
  );
}

class _DumanSonucKutu extends StatelessWidget {
  final Color renk;
  final String baslik;
  final List<(String, String)> satirlar;
  const _DumanSonucKutu({
    required this.renk,
    required this.baslik,
    required this.satirlar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: renk, width: 2),
        borderRadius: BorderRadius.circular(10),
        color: renk.withOpacity(0.04),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            baslik,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: renk,
            ),
          ),
          const Divider(height: 12),
          for (final (lbl, val) in satirlar)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Expanded(
                    child: Text(lbl, style: const TextStyle(fontSize: 13)),
                  ),
                  Text(
                    val,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
// LİTYUM PİL YANGINI — ISO 3941:2026 / NFPA 855:2023 / FM Global DS 5-33
// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦

class LityumPilYangini extends StatefulWidget {
  const LityumPilYangini({super.key});
  @override
  State<LityumPilYangini> createState() => _LityumPilYanginiState();
}

class _LityumPilYanginiState extends State<LityumPilYangini> {
  static const Color _kLi = Color(0xFF7C3AED);

  final _kapasiteCtrl = TextEditingController();
  final _alanCtrl = TextEditingController();
  final _sureCtrl = TextEditingController(text: '30');
  String _kimya = 'NMC';
  String _mod = 'ess'; // 'ess' | 'ev'

  // ESS sonuçları
  String? _hata;
  double? _isi, _debi, _hacim, _f500;
  double? _essHrrTepe, _essTbuyume;
  String? _kategori;

  // EV girişleri
  String _aracTipi = 'binek';
  final _aracSayisiCtrl = TextEditingController(text: '1');
  final _evSureCtrl = TextEditingController(text: '60');
  // EV sonuçları
  String? _evHata;
  double? _evIsi, _evDebiArac, _evDebiToplam, _evHacim, _evDaldirma;
  double? _evHrrTepe, _evTbuyume, _evAlfa;

  @override
  void initState() {
    super.initState();
    final g = ProjeServisi.kayitliGirdiler;
    if (g != null) {
      ProjeServisi.kayitliGirdiler = null;
      _kapasiteCtrl.text = g['kapasite'] ?? '';
      _alanCtrl.text = g['alan'] ?? '';
      _sureCtrl.text = g['sure'] ?? '30';
      _kimya = g['kimya'] ?? 'NMC';
      _mod = g['mod'] ?? 'ess';
      _aracTipi = g['aracTipi'] ?? 'binek';
      _aracSayisiCtrl.text = g['aracSayisi'] ?? '1';
      _evSureCtrl.text = g['evSure'] ?? '60';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {});
          if (_mod == 'ess')
            _hesapla();
          else
            _hesaplaEv();
        }
      });
    }
  }

  @override
  void dispose() {
    _kapasiteCtrl.dispose();
    _alanCtrl.dispose();
    _sureCtrl.dispose();
    _aracSayisiCtrl.dispose();
    _evSureCtrl.dispose();
    super.dispose();
  }

  void _hesapla() {
    setState(() {
      _hata = null;
      _isi = null;
      _debi = null;
      _hacim = null;
      _f500 = null;
      _essHrrTepe = null;
      _essTbuyume = null;
      _kategori = null;
    });
    final e = double.tryParse(_kapasiteCtrl.text.replaceAll(',', '.'));
    final a = double.tryParse(_alanCtrl.text.replaceAll(',', '.'));
    final t = double.tryParse(_sureCtrl.text.replaceAll(',', '.'));
    if (e == null || e <= 0) {
      setState(
        () => _hata = AppLocalizations.of(context).enterInstalledCapacityKwh,
      );
      return;
    }
    if (a == null || a <= 0) {
      setState(
        () => _hata = AppLocalizations.of(context).enterProtectionAreaM2,
      );
      return;
    }
    if (t == null || t <= 0) {
      setState(
        () => _hata = AppLocalizations.of(context).enterApplicationDurationMin,
      );
      return;
    }
    // NFPA 855:2023 §4.4.2 — tehlike kategorisi
    final String kat;
    final double yogunluk; // L/(min·m²) — FM Global DS 5-33
    if (e < 20) {
      kat = 'Düşük Tehlike (< 20 kWh)';
      yogunluk = 8.2;
    } else if (e <= 600) {
      kat = 'Orta Tehlike (20–600 kWh)';
      yogunluk = 12.2;
    } else {
      kat = 'Yüksek Tehlike (> 600 kWh)';
      yogunluk = 16.3;
    }
    // Isı tahmini — IEC 62619:2022 termik kaçış verisi
    const isiMap = {'NMC': 30.0, 'LFP': 12.0, 'NCA': 35.0, 'LCO': 35.0};
    final isi = e * (isiMap[_kimya] ?? 30.0);
    final debi = yogunluk * a;
    final hacim = debi * t;
    final f500 = hacim * 0.015; // %1,5 F-500 konsantrasyonu

    // t² yangın büyüme modeli — ESS (IEC 62933-5-2 / NFPA 855 / SP Technical 2022)
    // ESS birim hücre tüketiminin yayılmasıyla oluşan tepe HRR ? kapasite × tür katsayısı (kW/kWh)
    const hrrKatMap = {
      'NMC': 3.0,
      'LFP': 1.5,
      'NCA': 3.5,
      'LCO': 3.5,
    }; // kW/kWh — SP 2022:08
    final hrrTepe = e * (hrrKatMap[_kimya] ?? 3.0) / 1000.0; // MW
    // ?: ESS yangınları genellikle "hızlı" büyüme sınıfı
    const alfaEss = 0.0469; // kW/s² — "hızlı" t² (ISO 16734 / NFPA 72)
    final tBuyume = math.sqrt((hrrTepe * 1000.0) / alfaEss); // saniye

    setState(() {
      _isi = isi;
      _debi = debi;
      _hacim = hacim;
      _f500 = f500;
      _essHrrTepe = hrrTepe;
      _essTbuyume = tBuyume;
      _kategori = kat;
    });
    ProjeServisi.hesapVeri =
        'Kimya: $_kimya  |  Kapasite: ${_kapasiteCtrl.text} kWh  |  Alan: ${_alanCtrl.text} m\u00b2\n'
        'Tehlike Kategorisi: ${_kategori ?? "-"}  |  S\u00fcre: ${_sureCtrl.text} dak\n'
        'Is\u0131 Enerjisi: ${_isi?.toStringAsFixed(0) ?? "-"} MJ  |  Debi: ${_debi?.toStringAsFixed(0) ?? "-"} L/min  |  Toplam Hacim: ${_hacim?.toStringAsFixed(0) ?? "-"} L';
    ProjeServisi.hesapSinyali.value = true;
  }

  void _hesaplaEv() {
    setState(() {
      _evHata = null;
      _evIsi = null;
      _evDebiArac = null;
      _evDebiToplam = null;
      _evHacim = null;
      _evDaldirma = null;
      _evHrrTepe = null;
      _evTbuyume = null;
      _evAlfa = null;
    });
    final e = double.tryParse(_kapasiteCtrl.text.replaceAll(',', '.'));
    final n = int.tryParse(_aracSayisiCtrl.text);
    final t = double.tryParse(_evSureCtrl.text.replaceAll(',', '.'));
    if (e == null || e <= 0) {
      setState(
        () => _evHata = AppLocalizations.of(
          context,
        ).enterVehicleBatteryCapacityKwh,
      );
      return;
    }
    if (n == null || n <= 0) {
      setState(() => _evHata = AppLocalizations.of(context).enterVehicleCount);
      return;
    }
    if (t == null || t <= 0) {
      setState(
        () =>
            _evHata = AppLocalizations.of(context).enterApplicationDurationMin,
      );
      return;
    }
    // Araç başına minimum debi — VdS 3471:2023
    final double debiArac;
    if (_aracTipi == 'ag_ticari') {
      debiArac = 1000.0;
    } else if (_aracTipi == 'hafif_ticari') {
      debiArac = 600.0;
    } else {
      debiArac = e < 60 ? 400.0 : 600.0;
    }
    // VdS 3471: maks. 2 araç eş zamanlı yanma
    final esZamanli = n > 1 ? 2 : 1;
    final debiToplam = debiArac * esZamanli;
    final hacim = debiToplam * t;
    // IEC 62619 termik kaçış ısı katsayısı
    const isiMap = {'NMC': 30.0, 'LFP': 12.0, 'NCA': 35.0, 'LCO': 35.0};
    final isi = e * (isiMap[_kimya] ?? 30.0);
    // Container daldırma: 3 000 L/araç (BRE Global / SFPE rehberi)
    final daldirma = 3000.0 * n;

    // t² yangın büyüme modeli (ISO 16734 / SFPE Handbook)
    // Tepe HRR: binek ?60kWh›3MW, binek >60kWh›6MW, hafif ticari›8MW, ağır ticari›15MW
    final double hrrTepe;
    if (_aracTipi == 'ag_ticari') {
      hrrTepe = 15.0; // MW — elektrikli otobüs (SP Report 2021:11)
    } else if (_aracTipi == 'hafif_ticari') {
      hrrTepe = 8.0; // MW — elektrikli van/minibüs
    } else {
      hrrTepe = e < 60 ? 3.0 : 6.0; // MW — binek araç
    }
    // ? katsayısı — EV için "çok hızlı" (ultra-fast) t² modeli: ?=0.1876 kW/s²
    // ISO 16734 / NFPA 72 Tablo B.2.3
    const alfa = 0.1876; // kW/s²
    // t_peak = sqrt(HRR_kW / ?)
    final tBuyume = math.sqrt((hrrTepe * 1000.0) / alfa); // saniye

    setState(() {
      _evIsi = isi;
      _evDebiArac = debiArac;
      _evDebiToplam = debiToplam;
      _evHacim = hacim;
      _evDaldirma = daldirma;
      _evHrrTepe = hrrTepe;
      _evTbuyume = tBuyume;
      _evAlfa = alfa;
    });
    ProjeServisi.hesapVeri = jsonEncode({
      'i': {
        'kapasite': _kapasiteCtrl.text,
        'aracSayisi': _aracSayisiCtrl.text,
        'evSure': _evSureCtrl.text,
        'kimya': _kimya,
        'mod': _mod,
        'aracTipi': _aracTipi,
      },
      'r':
          '## Lityum Pil Yang\u0131n\u0131 - Elektrikli Ara\u00e7\n'
          'Ara\u00e7 Tipi: $_aracTipi  |  Kimya: $_kimya  |  Kapasite: ${_kapasiteCtrl.text} kWh  |  Ara\u00e7 Say\u0131s\u0131: ${_aracSayisiCtrl.text}\n'
          '## Hesap Sonu\u00e7lar\u0131\n'
          'E\u015f Zamanl\u0131 Yang\u0131n: ${_aracSayisiCtrl.text.isNotEmpty && (int.tryParse(_aracSayisiCtrl.text) ?? 1) > 1 ? 2 : 1} ara\u00e7  |  Debi/Ara\u00e7: ${_evDebiArac?.toStringAsFixed(0) ?? "-"} L/min\n'
          'Toplam Debi: ${_evDebiToplam?.toStringAsFixed(0) ?? "-"} L/min  |  Su Hacmi: ${_evHacim?.toStringAsFixed(0) ?? "-"} L  |  Is\u0131 Enerjisi: ${_evIsi?.toStringAsFixed(0) ?? "-"} MJ',
    });
    ProjeServisi.hesapSinyali.value = true;
  }

  Widget _field(String lbl, TextEditingController ctrl, String suffix) =>
      TextField(
        controller: ctrl,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: lbl,
          suffixText: suffix,
          border: const OutlineInputBorder(),
          isDense: true,
          labelStyle: const TextStyle(color: _kLi),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: _kLi, width: 2),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Mod seçici
          ToggleButtons(
            isSelected: [_mod == 'ess', _mod == 'ev'],
            onPressed: (i) => setState(() {
              _mod = i == 0 ? 'ess' : 'ev';
              _hata = null;
              _evHata = null;
            }),
            borderRadius: BorderRadius.circular(10),
            selectedColor: Colors.white,
            fillColor: _kLi,
            color: _kLi,
            constraints: const BoxConstraints(minHeight: 42, minWidth: 0),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  l10n.essStationary,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  l10n.electricVehicleMode,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (_mod == 'ess') ...[
            // Üst bilgi kutusu
            _InfoBox(
              color: const Color(0xFFEDE9FE),
              border: _kLi,
              child: Text(
                l10n.essLithiumFireInfo,
                style: const TextStyle(
                  fontSize: 11,
                  height: 1.5,
                  color: Color(0xFF4C1D95),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Pil kimyası
            Text(
              l10n.batteryTechnology,
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final entry in [
                  ('NMC', 'NMC/NCM', l10n.nmcDescription),
                  ('LFP', 'LFP', l10n.lfpDescription),
                  ('NCA', 'NCA', l10n.ncaDescription),
                  ('LCO', 'LCO', l10n.lcoDescription),
                ])
                  Tooltip(
                    message: entry.$3,
                    child: ChoiceChip(
                      label: Text(
                        entry.$2,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _kimya == entry.$1 ? Colors.white : _kLi,
                        ),
                      ),
                      selected: _kimya == entry.$1,
                      selectedColor: _kLi,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: Color(0xFF8B5CF6)),
                      ),
                      showCheckmark: false,
                      onSelected: (_) => setState(() {
                        _kimya = entry.$1;
                        _isi = null;
                        _debi = null;
                        _hacim = null;
                        _f500 = null;
                        _essHrrTepe = null;
                        _essTbuyume = null;
                        _kategori = null;
                        _hata = null;
                      }),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              _kimya == 'NMC'
                  ? l10n.nmcThermalRunawayNote
                  : _kimya == 'LFP'
                  ? l10n.lfpThermalRunawayNote
                  : _kimya == 'NCA'
                  ? l10n.ncaThermalRunawayNote
                  : l10n.lcoThermalRunawayNote,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black54,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 14),

            // Giriş alanları
            _field(l10n.installedCapacity, _kapasiteCtrl, 'kWh'),
            const SizedBox(height: 4),
            Text(
              l10n.hazardClassificationBasisNote,
              style: const TextStyle(fontSize: 10, color: Colors.black45),
            ),
            const SizedBox(height: 10),
            _field(l10n.protectedArea, _alanCtrl, 'm²'),
            const SizedBox(height: 10),
            _field(l10n.applicationDuration, _sureCtrl, 'dk'),
            const SizedBox(height: 4),
            Text(
              l10n.fmGlobalMinDurationNote,
              style: const TextStyle(fontSize: 10, color: Colors.black45),
            ),
            const SizedBox(height: 14),

            // Tehlike kategorisi referans
            _InfoBox(
              color: const Color(0xFFF5F3FF),
              border: const Color(0xFFDDD6FE),
              child: Text(
                l10n.essHazardCategoryInfo,
                style: const TextStyle(
                  fontSize: 11,
                  height: 1.6,
                  color: Color(0xFF4C1D95),
                ),
              ),
            ),
            const SizedBox(height: 14),

            if (_hata != null) ...[
              _InfoBox(
                color: const Color(0xFFFEE2E2),
                border: const Color(0xFFFCA5A5),
                child: Text(
                  _hata!,
                  style: const TextStyle(
                    color: Color(0xFFDC2626),
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],

            ElevatedButton.icon(
              onPressed: _hesapla,
              icon: const Icon(Icons.calculate_rounded),
              label: Text(AppLocalizations.of(context)!.calculateCooling),
              style: ElevatedButton.styleFrom(
                backgroundColor: _kLi,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            if (_isi != null) ...[
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _kLi, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.water_drop_rounded,
                          color: Color(0xFF7C3AED),
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          l10n.coolingCalculationResult,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFF7C3AED),
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    _LiSonucSatir(
                      etiket: l10n.fireRiskCategory,
                      deger: _kategori!.startsWith('D')
                          ? l10n.hazardLight
                          : _kategori!.startsWith('O')
                          ? l10n.hazardMedium
                          : l10n.hazardHigh,
                    ),
                    const SizedBox(height: 4),
                    _LiSonucSatir(
                      etiket: l10n.thermalRunawayHeat,
                      deger: '${_isi!.toStringAsFixed(0)} MJ',
                    ),
                    const SizedBox(height: 4),
                    _LiSonucSatir(
                      etiket: l10n.estimatedPeakHrr,
                      deger: '${_essHrrTepe!.toStringAsFixed(2)} MW',
                    ),
                    const SizedBox(height: 4),
                    _LiSonucSatir(
                      etiket: l10n.timeToPeak,
                      deger:
                          '${_essTbuyume!.toStringAsFixed(0)} s  (${(_essTbuyume! / 60).toStringAsFixed(1)} dk)',
                    ),
                    const SizedBox(height: 4),
                    _LiSonucSatir(
                      etiket: l10n.minimumFlowRate,
                      deger: '${_debi!.toStringAsFixed(1)} L/min',
                    ),
                    const SizedBox(height: 4),
                    _LiSonucSatir(
                      etiket: l10n.totalWaterVolume,
                      deger: '${_hacim!.toStringAsFixed(0)} L',
                    ),
                    const SizedBox(height: 4),
                    _LiSonucSatir(
                      etiket: l10n.f500Amount,
                      deger: '${_f500!.toStringAsFixed(1)} L',
                    ),
                    const SizedBox(height: 10),
                    _InfoBox(
                      color: const Color(0xFFF5F3FF),
                      border: const Color(0xFFDDD6FE),
                      child: Text(
                        l10n.essResultsFooterNote,
                        style: const TextStyle(
                          fontSize: 10,
                          height: 1.5,
                          color: Color(0xFF4C1D95),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ] else
            ..._evForm(l10n),
        ],
      ),
    );
  }

  List<Widget> _evForm(AppLocalizations l10n) {
    final aracTipiLabel = _aracTipi == 'binek'
        ? l10n.passengerCar
        : _aracTipi == 'hafif_ticari'
        ? l10n.lightCommercial
        : l10n.heavyCommercialBus;
    return [
      _InfoBox(
        color: const Color(0xFFEDE9FE),
        border: _kLi,
        child: Text(
          l10n.evLithiumFireInfo,
          style: const TextStyle(
            fontSize: 11,
            height: 1.5,
            color: Color(0xFF4C1D95),
          ),
        ),
      ),
      const SizedBox(height: 14),
      Text(
        l10n.vehicleType,
        style: TextStyle(fontSize: 12, color: Colors.black54),
      ),
      const SizedBox(height: 6),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final entry in [
            ('binek', l10n.passengerCar, l10n.passengerCarSpecNote),
            ('hafif_ticari', l10n.lightCommercial, l10n.lightCommercialSpecNote),
            ('ag_ticari', l10n.heavyCommercialBus, l10n.heavyCommercialSpecNote),
          ])
            Tooltip(
              message: entry.$3,
              child: ChoiceChip(
                label: Text(
                  entry.$2,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _aracTipi == entry.$1 ? Colors.white : _kLi,
                  ),
                ),
                selected: _aracTipi == entry.$1,
                selectedColor: _kLi,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Color(0xFF8B5CF6)),
                ),
                showCheckmark: false,
                onSelected: (_) => setState(() {
                  _aracTipi = entry.$1;
                  _evIsi = null;
                  _evDebiArac = null;
                  _evDebiToplam = null;
                  _evHacim = null;
                  _evDaldirma = null;
                  _evHrrTepe = null;
                  _evTbuyume = null;
                  _evAlfa = null;
                  _evHata = null;
                }),
              ),
            ),
        ],
      ),
      const SizedBox(height: 14),
      Text(
        l10n.batteryTechnology,
        style: TextStyle(fontSize: 12, color: Colors.black54),
      ),
      const SizedBox(height: 6),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final entry in [
            ('NMC', 'NMC/NCM', l10n.nmcHeatValue),
            ('LFP', 'LFP', l10n.lfpHeatValue),
            ('NCA', 'NCA', l10n.ncaHeatValue),
            ('LCO', 'LCO', l10n.lcoHeatValue),
          ])
            Tooltip(
              message: entry.$3,
              child: ChoiceChip(
                label: Text(
                  entry.$2,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _kimya == entry.$1 ? Colors.white : _kLi,
                  ),
                ),
                selected: _kimya == entry.$1,
                selectedColor: _kLi,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Color(0xFF8B5CF6)),
                ),
                showCheckmark: false,
                onSelected: (_) => setState(() {
                  _kimya = entry.$1;
                  _evIsi = null;
                  _evDebiArac = null;
                  _evDebiToplam = null;
                  _evHacim = null;
                  _evDaldirma = null;
                  _evHrrTepe = null;
                  _evTbuyume = null;
                  _evAlfa = null;
                  _evHata = null;
                }),
              ),
            ),
        ],
      ),
      const SizedBox(height: 14),
      _field(l10n.batteryCapacity, _kapasiteCtrl, 'kWh'),
      const SizedBox(height: 4),
      Text(
        l10n.vehicleBatteryCapacityNote,
        style: const TextStyle(fontSize: 10, color: Colors.black45),
      ),
      const SizedBox(height: 10),
      _field(l10n.vehicleCount, _aracSayisiCtrl, 'adet'),
      const SizedBox(height: 4),
      Text(
        l10n.maxSimultaneousVehiclesNote,
        style: const TextStyle(fontSize: 10, color: Colors.black45),
      ),
      const SizedBox(height: 10),
      _field(l10n.applicationDuration, _evSureCtrl, 'dk'),
      const SizedBox(height: 4),
      Text(
        l10n.vehicleApplicationDurationNote,
        style: const TextStyle(fontSize: 10, color: Colors.black45),
      ),
      const SizedBox(height: 14),
      _InfoBox(
        color: const Color(0xFFF5F3FF),
        border: const Color(0xFFDDD6FE),
        child: Text(
          l10n.vdsMinimumFlowInfo,
          style: const TextStyle(fontSize: 11, height: 1.6, color: Color(0xFF4C1D95)),
        ),
      ),
      const SizedBox(height: 14),
      if (_evHata != null) ...[
        _InfoBox(
          color: const Color(0xFFFEE2E2),
          border: const Color(0xFFFCA5A5),
          child: Text(
            _evHata!,
            style: const TextStyle(color: Color(0xFFDC2626), fontSize: 13),
          ),
        ),
        const SizedBox(height: 8),
      ],
      ElevatedButton.icon(
        onPressed: _hesaplaEv,
        icon: const Icon(Icons.calculate_rounded),
        label: Text(AppLocalizations.of(context)!.calculateCooling),
        style: ElevatedButton.styleFrom(
          backgroundColor: _kLi,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      if (_evIsi != null) ...[
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _kLi, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.directions_car_rounded,
                    color: Color(0xFF7C3AED),
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    l10n.electricVehicleFireResult,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF7C3AED),
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              const Divider(height: 16),
              _LiSonucSatir(etiket: l10n.vehicleType, deger: aracTipiLabel),
              const SizedBox(height: 4),
              _LiSonucSatir(
                etiket: l10n.thermalRunawayHeat,
                deger: l10n.heatPerVehicleMj(_evIsi!.toStringAsFixed(0)),
              ),
              const SizedBox(height: 4),
              _LiSonucSatir(
                etiket: l10n.averageHeatReleaseRate,
                deger: l10n.avgHrrPerVehicleMw(
                  (_evIsi! /
                          (double.tryParse(
                                _evSureCtrl.text.replaceAll(',', '.'),
                              )! *
                              60))
                      .toStringAsFixed(2),
                ),
              ),
              const SizedBox(height: 4),
              _LiSonucSatir(
                etiket: l10n.estimatedPeakHrr,
                deger: '${_evHrrTepe!.toStringAsFixed(0)} MW',
              ),
              const SizedBox(height: 4),
              _LiSonucSatir(
                etiket: l10n.timeToPeak,
                deger:
                    '${_evTbuyume!.toStringAsFixed(0)} s  (${(_evTbuyume! / 60).toStringAsFixed(1)} dk)',
              ),
              const SizedBox(height: 4),
              _LiSonucSatir(
                etiket: l10n.vehicleMinimumFlow,
                deger: '${_evDebiArac!.toStringAsFixed(0)} L/min',
              ),
              const SizedBox(height: 4),
              _LiSonucSatir(
                etiket: l10n.simultaneousVehicleFlow,
                deger: '${_evDebiToplam!.toStringAsFixed(0)} L/min',
              ),
              const SizedBox(height: 4),
              _LiSonucSatir(
                etiket: l10n.totalWaterVolume,
                deger: '${_evHacim!.toStringAsFixed(0)} L',
              ),
              const SizedBox(height: 4),
              _LiSonucSatir(
                etiket: l10n.containerImmersion,
                deger: '${_evDaldirma!.toStringAsFixed(0)} L',
              ),
              const SizedBox(height: 10),
              _InfoBox(
                color: const Color(0xFFF5F3FF),
                border: const Color(0xFFDDD6FE),
                child: Text(
                  l10n.evResultsFooterNote,
                  style: const TextStyle(
                    fontSize: 10,
                    height: 1.5,
                    color: Color(0xFF4C1D95),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ];
  }
}

class _LiSonucSatir extends StatelessWidget {
  final String etiket, deger;
  const _LiSonucSatir({required this.etiket, required this.deger});

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Icon(Icons.fiber_manual_record, size: 8, color: Color(0xFF7C3AED)),
      const SizedBox(width: 6),
      Expanded(
        child: Text(
          etiket,
          style: const TextStyle(fontSize: 13, color: Color(0xFF7C3AED)),
        ),
      ),
      Text(
        deger,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: Color(0xFF7C3AED),
        ),
      ),
    ],
  );
}

// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
// STANDART ARAMA
// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦

class StandartArama extends StatefulWidget {
  const StandartArama({super.key});
  @override
  State<StandartArama> createState() => _StandartAramaState();
}

class _StandartAramaState extends State<StandartArama> {
  static const Color _kG = Color(0xFF065F46);
  List<_Standart> _tumListe = [];
  List<_Standart> _sonuclar = [];
  bool _yukleniyor = true;
  final _aramaCtrl = TextEditingController();
  String? _secilenKategori;
  String? _yuklenenDil;

  // JSON kategori adı → uygulama modül adı (yangın dışı kategoriler dahil değil)
  static const Map<String, String> _kategoriDonusum = {
    'Yangın': 'Yangın Yükü & Söndürme',
    'Yangın Yükü': 'Yangın Yükü & Söndürme',
    'Yapısal Yangına Direniç': 'Yangın Yükü & Söndürme',
    'Mutfak Söndürme': 'Davlumbaz Söndürme',
    'Gazlı Söndürme': 'Gazlı Söndürme Sistemi',
    'Baskı Makinesi Söndürme': 'Baskı Makinesi Söndürme',
    'Su Bazlı Söndürme': 'Sprinkler Sistemi',
    'Köpüklü Söndürme': 'Sprinkler Sistemi',
    'Yangın Alarm': 'Yangın Alarm & Algılama',
    'Yangın Söndürücüler': 'Yangın Söndürücüler',
    'Duman Kontrolü': 'Duman Kontrolü & Tahliye',
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageCode = Localizations.localeOf(context).languageCode;
    if (_yuklenenDil != languageCode) {
      _yuklenenDil = languageCode;
      _yukle(languageCode);
    }
  }

  Future<void> _yukle(String languageCode) async {
    final l10n = AppLocalizations.of(context);
    final jsonStr = await rootBundle.loadString('assets/standartlar_db.json');
    final liste = json.decode(jsonStr) as List<dynamic>;
    final Map<String, dynamic> translations =
        languageCode == 'en' || languageCode == 'de'
        ? json.decode(
                await rootBundle.loadString(
                  'assets/standartlar_$languageCode.json',
                ),
              )
              as Map<String, dynamic>
        : {};
    final englishCategories = <String, String>{
      'Yangın': l10n.fireAndSuppression,
      'Yangın Yükü': l10n.fireAndSuppression,
      'Yapısal Yangına Direniç': l10n.fireAndSuppression,
      'Mutfak Söndürme': l10n.kitchenSuppression,
      'Gazlı Söndürme': l10n.gasSuppression,
      'Baskı Makinesi Söndürme': l10n.printingSuppression,
      'Su Bazlı Söndürme': l10n.sprinklerSystems,
      'Köpüklü Söndürme': l10n.sprinklerSystems,
      'Yangın Alarm': l10n.fireAlarm,
      'Yangın Söndürücüler': l10n.fireExtinguishers,
      'Duman Kontrolü': l10n.smokeControl,
    };
    if (!mounted) return;
    setState(() {
      _tumListe = liste
          .map((e) => _Standart.fromJson(e as Map<String, dynamic>))
          .where((s) => _kategoriDonusum.containsKey(s.kategori))
          .map((s) {
            final translation = translations[s.numara] as Map<String, dynamic>?;
            return _Standart(
              numara: s.numara,
              ad: (translation?['ad'] ?? s.ad).toString(),
              kategori: languageCode == 'en'
                  ? (translation?['kategori']?.toString() ??
                        englishCategories[s.kategori]!)
                  : _kategoriDonusum[s.kategori]!,
              aciklama: (translation?['aciklama'] ?? s.aciklama).toString(),
            );
          })
          .toList();
      _sonuclar = List.from(_tumListe);
      _yukleniyor = false;
    });
  }

  void _ara(String q) {
    setState(() {
      _sonuclar = _tumListe.where((s) {
        final kat = _secilenKategori == null || s.kategori == _secilenKategori;
        if (!kat) return false;
        if (q.isEmpty) return true;
        final k = q.toLowerCase();
        return s.numara.toLowerCase().contains(k) ||
            s.ad.toLowerCase().contains(k) ||
            s.kategori.toLowerCase().contains(k);
      }).toList();
    });
  }

  @override
  void dispose() {
    _aramaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (_yukleniyor) {
      return const Center(child: CircularProgressIndicator());
    }
    final kategoriler = _tumListe.map((s) => s.kategori).toSet().toList()
      ..sort();
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          color: _kG.withOpacity(0.05),
          child: Column(
            children: [
              TextField(
                controller: _aramaCtrl,
                onChanged: _ara,
                decoration: InputDecoration(
                  hintText: l10n.standardSearchHint,
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Color(0xFF065F46),
                  ),
                  suffixIcon: _aramaCtrl.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: () {
                            _aramaCtrl.clear();
                            _ara('');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFF065F46),
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _secilenKategori,
                hint: Text(l10n.allCategories),
                isExpanded: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text(l10n.allCategories),
                  ),
                  ...kategoriler.map(
                    (k) => DropdownMenuItem(
                      value: k,
                      child: Text(k, style: const TextStyle(fontSize: 13)),
                    ),
                  ),
                ],
                onChanged: (v) {
                  setState(() => _secilenKategori = v);
                  _ara(_aramaCtrl.text);
                },
              ),
              const SizedBox(height: 6),
              Text(
                l10n.standardsFound(_sonuclar.length),
                style: const TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _sonuclar.length,
            itemExtent: 88,
            itemBuilder: (ctx, i) {
              final s = _sonuclar[i];
              return ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _kG.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.article_rounded,
                    color: Color(0xFF065F46),
                    size: 20,
                  ),
                ),
                title: Text(
                  s.numara,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF065F46),
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.ad,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      s.kategori,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.black38,
                      ),
                    ),
                  ],
                ),
                dense: true,
                onTap: () => showDialog(
                  context: ctx,
                  builder: (dlgCtx) => AlertDialog(
                    title: Text(
                      s.numara,
                      style: const TextStyle(
                        color: Color(0xFF065F46),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            s.ad,
                            style: const TextStyle(fontSize: 13, height: 1.4),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.category(s.kategori),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          if (s.aciklama.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              s.aciklama,
                              style: const TextStyle(fontSize: 12, height: 1.4),
                            ),
                          ],
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dlgCtx),
                        child: Text(l10n.close),
                      ),
                      TextButton.icon(
                        icon: const Icon(
                          Icons.search_rounded,
                          size: 16,
                          color: Color(0xFF0369A1),
                        ),
                        label: Text(
                          l10n.searchWeb,
                          style: TextStyle(color: Color(0xFF0369A1)),
                        ),
                        onPressed: () async {
                          final uri = Uri.parse(
                            'https://www.google.com/search?q=${Uri.encodeComponent('${s.numara} ${s.ad} yangın standardı')}',
                          );
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        },
                      ),
                      TextButton.icon(
                        icon: const Icon(
                          Icons.auto_awesome_rounded,
                          size: 16,
                          color: Color(0xFF7C3AED),
                        ),
                        label: Text(
                          l10n.askAi,
                          style: TextStyle(color: Color(0xFF7C3AED)),
                        ),
                        onPressed: () async {
                          Navigator.pop(dlgCtx);
                          final apiKey = await _geminiApiAl(ctx);
                          if (apiKey == null || !ctx.mounted) return;
                          Navigator.push(
                            ctx,
                            MaterialPageRoute(
                              builder: (_) => AiSohbetSayfasi(
                                standartAdi: s.numara,
                                standartAciklama:
                                    '${s.ad}. Kategori: ${s.kategori}. ${s.aciklama}',
                                apiKey: apiKey,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
// STANDART REHBERİ
// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦

class StandartRehberi extends StatefulWidget {
  const StandartRehberi({super.key});

  @override
  State<StandartRehberi> createState() => _StandartRehberiState();
}

class _StandartRehberiState extends State<StandartRehberi> {
  List<({String numara, String aciklama, String kategori})> _ozelStandartlar =
      [];

  @override
  void initState() {
    super.initState();
    _ozelStandartlariYukle();
  }

  Future<void> _ozelStandartlariYukle() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('ozel_standartlar_fire') ?? '[]';
    try {
      final liste = json.decode(jsonStr) as List<dynamic>;
      if (mounted) {
        setState(() {
          _ozelStandartlar = liste
              .map(
                (e) => (
                  numara: (e['numara'] ?? '').toString(),
                  aciklama: (e['aciklama'] ?? '').toString(),
                  kategori: (e['kategori'] ?? '').toString(),
                ),
              )
              .toList();
        });
      }
    } catch (_) {}
  }

  Future<void> _ozelStandartKaydet() async {
    final prefs = await SharedPreferences.getInstance();
    final liste = _ozelStandartlar
        .map(
          (s) => {
            'numara': s.numara,
            'aciklama': s.aciklama,
            'kategori': s.kategori,
          },
        )
        .toList();
    await prefs.setString('ozel_standartlar_fire', json.encode(liste));
  }

  Future<void> _ozelStandartEkle(
    ({String numara, String aciklama, String kategori}) s,
  ) async {
    if (_ozelStandartlar.any((x) => x.numara == s.numara)) return;
    setState(() => _ozelStandartlar.add(s));
    await _ozelStandartKaydet();
  }

  Future<void> _ozelStandartSil(String numara) async {
    setState(() => _ozelStandartlar.removeWhere((s) => s.numara == numara));
    await _ozelStandartKaydet();
  }

  Future<void> _ozelStandartEkleDiyalogu() async {
    if (!mounted) return;

    final numaraCtrl = TextEditingController();
    final aciklamaCtrl = TextEditingController();
    bool numaraAraniyor = false;
    String numaraHatasi = '';

    final konuCtrl = TextEditingController();
    bool konuAraniyor = false;
    String konuHatasi = '';
    List<Map<String, String>> konuSonuclari = [];
    Set<int> secilenIndexler = {};

    int tabIndex = 0;

    final List<({String numara, String aciklama, String kategori})>?
    sonuc = await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) {
          // ¦¦¦¦ Numara ile arama ¦¦¦¦
          Future<void> numaraIleAra() async {
            final numara = numaraCtrl.text.trim();
            if (numara.isEmpty) {
              setLocal(
                () => numaraHatasi = AppLocalizations.of(
                  context,
                ).enterStandardNumberFirst,
              );
              return;
            }
            setLocal(() {
              numaraAraniyor = true;
              numaraHatasi = '';
            });
            try {
              final prefs = await SharedPreferences.getInstance();
              String? apiKey = prefs.getString('gemini_api_key') ?? '';
              if (apiKey.isEmpty) {
                if (!ctx.mounted) return;
                apiKey = await _geminiApiDiyaloguGoster(ctx, prefs);
              }
              if (apiKey == null || apiKey.isEmpty) {
                setLocal(() {
                  numaraAraniyor = false;
                  numaraHatasi = AppLocalizations.of(
                    context,
                  ).apiKeyRequiredError;
                });
                return;
              }
              final cevap = await geminiChat(
                apiKey: apiKey,
                mesajlar: [
                  {
                    'role': 'system',
                    'content':
                        'Sen bir yangın güvenliği standartları uzmanısın. '
                        'Kullanıcı standart numarası verecek. '
                        'Yanıtını YALNIZCA şu JSON formatında ver:\n'
                        '{"aciklama": "standardın kısa Türkçe açıklaması", "kategori": "en uygun kategori"}',
                  },
                  {
                    'role': 'user',
                    'content':
                        '$numara standardının kısa açıklamasını ve kategorisini ver.'
                        '\nKategori seçenekleri: Yangın Yükü, Gazlı Söndürme, Su Bazlı Söndürme, '
                        'Köpüklü Söndürme, Mutfak Söndürme, Yangın Alarm, Duman Kontrolü, '
                        'Yangın Söndürücüler, Yapısal Yangına Direnç, Risk Değerlendirme, '
                        'Endüstriyel Risk, Kategorisiz',
                  },
                ],
                maxTokens: 256,
              );
              String aciklama = '';
              String kategori = '';
              try {
                final temiz = cevap
                    .replaceAll(RegExp(r'```json|```'), '')
                    .trim();
                final idx1 = temiz.indexOf('{');
                final idx2 = temiz.lastIndexOf('}');
                if (idx1 != -1 && idx2 != -1) {
                  final parsed =
                      json.decode(temiz.substring(idx1, idx2 + 1))
                          as Map<String, dynamic>;
                  aciklama = (parsed['aciklama'] ?? '').toString();
                  kategori = (parsed['kategori'] ?? '').toString();
                }
              } catch (_) {
                aciklama = cevap.trim();
              }
              if (aciklama.isNotEmpty) aciklamaCtrl.text = aciklama;
              setLocal(() {
                numaraAraniyor = false;
                numaraHatasi = aciklama.isEmpty
                    ? AppLocalizations.of(context).standardNotFoundError
                    : '';
              });
            } on Exception catch (e) {
              setLocal(() {
                numaraAraniyor = false;
                numaraHatasi = e.toString().replaceFirst('Exception: ', '');
              });
            }
          }

          // ¦¦¦¦ Konuya göre arama ¦¦¦¦
          Future<void> konuyaGoreAra() async {
            final konu = konuCtrl.text.trim();
            if (konu.isEmpty) {
              setLocal(
                () => konuHatasi = AppLocalizations.of(
                  context,
                ).enterTopicOrKeywordFirst,
              );
              return;
            }
            setLocal(() {
              konuAraniyor = true;
              konuHatasi = '';
              konuSonuclari = [];
              secilenIndexler = {};
            });
            try {
              final prefs = await SharedPreferences.getInstance();
              String? apiKey = prefs.getString('gemini_api_key') ?? '';
              if (apiKey.isEmpty) {
                if (!ctx.mounted) return;
                apiKey = await _geminiApiDiyaloguGoster(ctx, prefs);
              }
              if (apiKey == null || apiKey.isEmpty) {
                setLocal(() {
                  konuAraniyor = false;
                  konuHatasi = AppLocalizations.of(context).apiKeyRequiredError;
                });
                return;
              }
              final cevap = await geminiChat(
                apiKey: apiKey,
                mesajlar: [
                  {
                    'role': 'system',
                    'content':
                        'Sen bir yangın güvenliği standartları uzmanısın. '
                        'Kullanıcı bir konu verecek. '
                        'O konuyla ilgili EN FAZLA 8 adet GERÇEK standart döndür. '
                        'Yanıtını YALNIZCA şu JSON formatında ver:\n'
                        '[{"numara":"EN 12345","aciklama":"Kısa açıklama","kategori":"Kategori"}]',
                  },
                  {
                    'role': 'user',
                    'content':
                        '"$konu" konusuyla ilgili yangın güvenliği standartlarını listele.'
                        '\nKategori seçenekleri: Yangın Yükü, Gazlı Söndürme, Su Bazlı Söndürme, '
                        'Köpüklü Söndürme, Mutfak Söndürme, Yangın Alarm, Duman Kontrolü, '
                        'Yangın Söndürücüler, Yapısal Yangına Direnç, Risk Değerlendirme, '
                        'Endüstriyel Risk, Kategorisiz',
                  },
                ],
                maxTokens: 1024,
              );
              List<Map<String, String>> sonuclar = [];
              try {
                final temiz = cevap
                    .replaceAll(RegExp(r'```json|```'), '')
                    .trim();
                final idx1 = temiz.indexOf('[');
                final idx2 = temiz.lastIndexOf(']');
                if (idx1 != -1 && idx2 != -1) {
                  final liste =
                      json.decode(temiz.substring(idx1, idx2 + 1)) as List;
                  for (final item in liste) {
                    final m = item as Map<String, dynamic>;
                    final num = (m['numara'] ?? '').toString();
                    final ac = (m['aciklama'] ?? '').toString();
                    if (num.isNotEmpty && ac.isNotEmpty) {
                      sonuclar.add({
                        'numara': num,
                        'aciklama': ac,
                        'kategori': (m['kategori'] ?? '').toString(),
                      });
                    }
                  }
                }
              } catch (_) {}
              setLocal(() {
                konuAraniyor = false;
                konuSonuclari = sonuclar;
                secilenIndexler = {};
                konuHatasi = sonuclar.isEmpty
                    ? AppLocalizations.of(context).relatedStandardNotFound
                    : '';
              });
            } on Exception catch (e) {
              setLocal(() {
                konuAraniyor = false;
                konuHatasi = e.toString().replaceFirst('Exception: ', '');
              });
            }
          }

          // ¦¦¦¦ UI ¦¦¦¦
          return Dialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 24,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).addCustomStandardTitle,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Tab seçici
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F1F6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setLocal(() => tabIndex = 0),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: tabIndex == 0
                                    ? Colors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: tabIndex == 0
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.08),
                                          blurRadius: 4,
                                          offset: const Offset(0, 1),
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.tag_rounded,
                                    size: 14,
                                    color: tabIndex == 0
                                        ? const Color(0xFFB91C1C)
                                        : Colors.black45,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    AppLocalizations.of(context).byNumberTab,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: tabIndex == 0
                                          ? FontWeight.w700
                                          : FontWeight.normal,
                                      color: tabIndex == 0
                                          ? const Color(0xFFB91C1C)
                                          : Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setLocal(() => tabIndex = 1),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: tabIndex == 1
                                    ? Colors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: tabIndex == 1
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.08),
                                          blurRadius: 4,
                                          offset: const Offset(0, 1),
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.topic_rounded,
                                    size: 14,
                                    color: tabIndex == 1
                                        ? const Color(0xFF7C3AED)
                                        : Colors.black45,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    AppLocalizations.of(context).byTopicTab,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: tabIndex == 1
                                          ? FontWeight.w700
                                          : FontWeight.normal,
                                      color: tabIndex == 1
                                          ? const Color(0xFF7C3AED)
                                          : Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Tab 0: Numara ile
                  if (tabIndex == 0) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: numaraCtrl,
                            textCapitalization: TextCapitalization.characters,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(
                                context,
                              )!.standardNumber,
                              hintText: AppLocalizations.of(
                                context,
                              )!.standardNumberExample,
                              prefixIcon: Icon(Icons.tag_rounded),
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            onSubmitted: (_) => numaraIleAra(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          height: 50,
                          child: numaraAraniyor
                              ? const Padding(
                                  padding: EdgeInsets.all(14),
                                  child: SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Color(0xFF7C3AED),
                                    ),
                                  ),
                                )
                              : Tooltip(
                                  message: AppLocalizations.of(
                                    context,
                                  ).findDescriptionWithAiTooltip,
                                  child: FilledButton(
                                    onPressed: numaraIleAra,
                                    style: FilledButton.styleFrom(
                                      backgroundColor: const Color(0xFF7C3AED),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      minimumSize: Size.zero,
                                    ),
                                    child: const Icon(
                                      Icons.auto_awesome_rounded,
                                      size: 20,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                    if (numaraHatasi.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          numaraHatasi,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: aciklamaCtrl,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.description,
                        hintText: AppLocalizations.of(
                          context,
                        )!.shortDescriptionHint,
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ],

                  // Tab 1: Konuya göre
                  if (tabIndex == 1) ...[
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: konuCtrl,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(
                                context,
                              )!.topicKeyword,
                              hintText: AppLocalizations.of(
                                context,
                              )!.topicKeywordExample,
                              prefixIcon: Icon(Icons.topic_rounded),
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            onSubmitted: (_) => konuyaGoreAra(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          height: 50,
                          child: konuAraniyor
                              ? const Padding(
                                  padding: EdgeInsets.all(14),
                                  child: SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Color(0xFF7C3AED),
                                    ),
                                  ),
                                )
                              : Tooltip(
                                  message: AppLocalizations.of(
                                    context,
                                  ).searchStandardsWithAiTooltip,
                                  child: FilledButton(
                                    onPressed: konuyaGoreAra,
                                    style: FilledButton.styleFrom(
                                      backgroundColor: const Color(0xFF7C3AED),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      minimumSize: Size.zero,
                                    ),
                                    child: const Icon(
                                      Icons.auto_awesome_rounded,
                                      size: 20,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                    if (konuHatasi.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          konuHatasi,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    if (konuSonuclari.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(
                              context,
                            ).standardsFound(konuSonuclari.length),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          TextButton(
                            onPressed: () => setLocal(() {
                              if (secilenIndexler.isEmpty) {
                                secilenIndexler = Set.from(
                                  List.generate(konuSonuclari.length, (i) => i),
                                );
                              } else {
                                secilenIndexler = {};
                              }
                            }),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              secilenIndexler.isEmpty
                                  ? AppLocalizations.of(context).selectAllButton
                                  : AppLocalizations.of(
                                      context,
                                    ).deselectAllButton,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 260),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: konuSonuclari.length,
                          itemBuilder: (_, i) {
                            final item = konuSonuclari[i];
                            final secili = secilenIndexler.contains(i);
                            return InkWell(
                              onTap: () => setLocal(() {
                                if (secili) {
                                  secilenIndexler.remove(i);
                                } else {
                                  secilenIndexler.add(i);
                                }
                              }),
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 3,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Checkbox(
                                      value: secili,
                                      onChanged: (v) => setLocal(() {
                                        if (v == true) {
                                          secilenIndexler.add(i);
                                        } else {
                                          secilenIndexler.remove(i);
                                        }
                                      }),
                                      visualDensity: VisualDensity.compact,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['numara'] ?? '',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFFB91C1C),
                                            ),
                                          ),
                                          Text(
                                            item['aciklama'] ?? '',
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                          if ((item['kategori'] ?? '')
                                              .isNotEmpty)
                                            Text(
                                              item['kategori']!,
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.black45,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ],

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(AppLocalizations.of(context)!.cancel),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFB91C1C),
                        ),
                        onPressed: () {
                          if (tabIndex == 0) {
                            final num = numaraCtrl.text.trim();
                            final ac = aciklamaCtrl.text.trim();
                            if (num.isEmpty || ac.isEmpty) return;
                            Navigator.pop(ctx, [
                              (numara: num, aciklama: ac, kategori: 'Özel'),
                            ]);
                          } else {
                            if (secilenIndexler.isEmpty) return;
                            final liste = secilenIndexler.map((i) {
                              final item = konuSonuclari[i];
                              return (
                                numara: item['numara'] ?? '',
                                aciklama: item['aciklama'] ?? '',
                                kategori: item['kategori'] ?? 'Özel',
                              );
                            }).toList();
                            Navigator.pop(ctx, liste);
                          }
                        },
                        child: Text(
                          tabIndex == 1 && konuSonuclari.isNotEmpty
                              ? AppLocalizations.of(
                                  context,
                                ).addSelectedButton(secilenIndexler.length)
                              : AppLocalizations.of(context).add,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    if (sonuc != null) {
      for (final s in sonuc) {
        await _ozelStandartEkle(s);
      }
    }
  }

  static const _kategoriler = [
    _RehberKategori(
      baslik: 'Yangın Yükü & Yangın Senaryosu',
      ikon: Icons.whatshot_rounded,
      renk: Color(0xFFB45309),
      standartlar: [
        (
          'EN 1991-1-2:2002',
          'Eurocode 1 Bölüm 1-2: Yapılara etkiyen yükler — Yangın etkileri. Yangın yükü yoğunluğu, büyüme hızı ve yangın senaryosu hesabı.',
        ),
        (
          'ISO 1716:2021',
          'Yapı malzemeleri ve ürünlerinin yanma ısısının tayini — Net ısıl değer (NCV) belirleme yöntemi.',
        ),
        (
          'ISO 5660-1:2015',
          'Yangın tepkisi deneyleri — Isı salım hızı, duman üretim hızı ve kütle kaybı hızı. Koni kalorimetre yöntemi.',
        ),
        (
          'NFPA 557:2022',
          'Yangın yükü yoğunluğu hesabı standardı — Bina kullanım tipine göre referans yoğunluk tabloları.',
        ),
        (
          'ISO 24679-1:2019',
          'Yangın güvenliği mühendisliği — Yapıda yangın davranışının değerlendirilmesi.',
        ),
        (
          'ISO 16733-1:2015',
          'Yangın güvenliği mühendisliği — Yangın senaryosu ve yangın modellemesi seçimi.',
        ),
        (
          'SFPE Handbook (7th Ed.)',
          'Yangın koruma mühendisliği başvuru kitabı — Hesap yöntemleri, yangın dinamiği, duman hareketi.',
        ),
        (
          'PD 7974-1:2019',
          'BSI — Yapılarda yangın güvenliği mühendisliği uygulaması: Yangın başlangıcı ve gelişimi.',
        ),
      ],
    ),
    _RehberKategori(
      baslik: 'Gazlı Söndürme Sistemleri',
      ikon: Icons.cloud_rounded,
      renk: Color(0xFF0369A1),
      standartlar: [
        (
          'ISO 14520-1:2015',
          'Gazlı söndürme sistemleri — Genel kurallar: tasarım, kurulum, devreye alma, bakım ve güvenlik.',
        ),
        (
          'ISO 14520-2:2019',
          'CO² söndürme sistemleri — Toplam taşkın ve yerel uygulama yöntemleri.',
        ),
        (
          'ISO 14520-5:2019',
          'HFC-227ea (FM-200) gazlı söndürme sistemleri — Konsantrasyon ve hacim hesabı.',
        ),
        ('ISO 14520-8:2019', 'HCFC Blend A (Halotron I) söndürme sistemleri.'),
        ('ISO 14520-9:2019', 'HFC 23 (Triflorometan) söndürme sistemleri.'),
        (
          'ISO 14520-10:2019',
          'IG-55 (Argonite) sistemleri — N²/Ar karışımı, inert gaz.',
        ),
        (
          'ISO 14520-11:2019',
          'IG-541 (Inergen) — N²/Ar/CO² karışımı, inert gazlı söndürme.',
        ),
        (
          'ISO 14520-12:2005 / TS EN 15004-7',
          'IG-01 (Argon) söndürme sistemleri.',
        ),
        (
          'ISO 14520-13:2006 / TS EN 15004-8',
          'IG-100 (Azot) söndürme sistemleri.',
        ),
        (
          'ISO 14520-15:2019',
          'FK-5-1-12 (Novec 1230) — Düşük GWP değeri, hassas ekipman odaları.',
        ),
        (
          'NFPA 2001:2022',
          'ABD — Temiz ajan (clean agent) söndürme sistemleri standardı.',
        ),
        (
          'NFPA 12:2022',
          'CO² söndürme sistemleri — ABD standardı, toplam taşkın ve yerel uygulama.',
        ),
        (
          'NFPA 12A:2018',
          'Halon 1301 söndürme sistemleri — ABD, mevcut sistemler.',
        ),
        (
          'TS EN 15004-1:2019',
          'Sabit yangın söndürme sistemleri — Gazlı söndürme sistemleri, genel gereksinimler.',
        ),
        (
          'VdS 2380:2017',
          'Almanya — Gazlı söndürme sistemleri tasarım ve kurulum yönergeleri.',
        ),
      ],
    ),
    _RehberKategori(
      baslik: 'Baskı Makinesi Söndürme',
      ikon: Icons.print_rounded,
      renk: Color(0xFF0369A1),
      standartlar: [
        (
          'NFPA 34:2024',
          'Yanıcı/tutuşabilir sıvı kullanan daldırma, kaplama ve baskı prosesleri — temel güvenlik standardı.',
        ),
        (
          'NFPA 34:2024 §10',
          'Printing Operations: baskı alanı yapısı, havalandırma, elektrik sınıflandırması ve yangın koruma.',
        ),
        (
          'NFPA 34:2024 §10.6',
          'Otomatik yangın söndürme zorunluluğu — Sınıf I sıvı için sprinkler; kurutucu bölmeler için yerel CO₂/temiz ajan.',
        ),
        (
          'NFPA 12:2022',
          'CO₂ söndürme — baskı makinesi ve kurutucu bölme yerel uygulama sistemleri.',
        ),
        (
          'NFPA 2001:2022',
          'Temiz ajan söndürme — baskı makinesi kabin koruma, insan varlığında tercih edilir.',
        ),
        (
          'NFPA 30:2024',
          'Yanıcı ve tutuşabilir sıvılar kodu — baskı tesisinde solvent depolama ve kullanım.',
        ),
        (
          'NFPA 70 (NEC) Madde 516',
          'Baskı alanı ATEX/NEC patlayıcı atmosfer sınıflandırması ve elektrik ekipmanı.',
        ),
        (
          'EN 1010-1:2004+A1:2010',
          'Baskı makinelerinin güvenliği — Genel gereksinimler.',
        ),
        (
          'EN 1010-2:2006+A1:2010',
          'Baskı makinelerinin güvenliği — Baskı ve baskı lakı uygulama makineleri (ofset, flexo, gravür).',
        ),
        (
          'EN 13463-1:2009',
          'ATEX ekipmanlar — Potansiyel patlayıcı ortamda kullanılacak ekipmanlar için güvenlik kriterleri.',
        ),
        (
          'TS EN 15004-1:2019',
          'Gazlı söndürme sistemleri — Genel şartlar (baskı kabini için temiz ajan hesabı).',
        ),
      ],
    ),
    _RehberKategori(
      baslik: 'Su Bazlı Söndürme Sistemleri',
      ikon: Icons.water_drop_rounded,
      renk: Color(0xFF0284C7),
      standartlar: [
        (
          'TS EN 12845+A1:2020',
          'Sabit sprinkler sistemleri — Tasarım, tesis ve bakım. Tehlike sınıfı, yoğunluk, debi ve depo hacmi.',
        ),
        (
          'NFPA 13:2022',
          'Sprinkler sistemi kurulumu standardı — ABD, tüm bina tipleri.',
        ),
        (
          'NFPA 13R:2022',
          'Konut binalarında sprinkler sistemleri — 4 kata kadar yapılar.',
        ),
        (
          'NFPA 13D:2022',
          'Tek ve iki ailelik konutlarda sprinkler sistemleri.',
        ),
        (
          'NFPA 15:2022',
          'Sabit su spreyi söndürme sistemleri — Ekipman ve risk koruma.',
        ),
        ('NFPA 16:2019', 'Köpük-su sprey ve köpük-su sprinkler sistemleri.'),
        (
          'EN 14339:2005',
          'Yeraltı yangın hidranti sistemleri — Tasarım ve kurulum.',
        ),
        ('EN 14384:2005', 'Yerüstü yangın hidranti sistemleri.'),
        (
          'EN 671-1:2012',
          'Sabit yangın söndürme donanımı — Yarı sert hortumlu makara sistemleri.',
        ),
        (
          'EN 671-2:2012',
          'Sabit yangın söndürme donanımı — Düz hortumlu hidrant sistemleri.',
        ),
        ('EN 671-3:2009', 'Sabit yangın söndürme donanımı — Bakım, Bölüm 3.'),
        (
          'EN 12259-1:2019',
          'Sabit yangın söndürme sistemleri — Sprinkler ve su spreyi bileşenleri.',
        ),
        (
          'TS EN 14972-1:2021',
          'Sabit söndürme sistemleri — Su sisi sistemleri, Bölüm 1: Tasarım ve kurulum.',
        ),
        (
          'NFPA 750:2023',
          'Su sisi (water mist) söndürme sistemleri standardı — ABD.',
        ),
      ],
    ),
    _RehberKategori(
      baslik: 'Köpüklü Söndürme Sistemleri',
      ikon: Icons.waves_rounded,
      renk: Color(0xFF0891B2),
      standartlar: [
        (
          'NFPA 11:2021',
          'Düşük, orta ve yüksek genleşmeli köpük söndürme sistemleri — ABD standardı.',
        ),
        (
          'EN 13565-1:2012',
          'Sabit köpük söndürme sistemleri — Bölüm 1: Gereksinimler ve test yöntemleri.',
        ),
        (
          'EN 13565-2:2009',
          'Sabit köpük söndürme sistemleri — Bölüm 2: Tasarım, kurulum ve bakım.',
        ),
        (
          'ISO 7203-1:2019',
          'Yangın söndürücü maddeler — Sıvı akaryakıt yangınları için köpük konsantreleri.',
        ),
        (
          'NFPA 30:2021',
          'Yanıcı ve tutuşabilir sıvılar kodu — Depolama ve taşıma.',
        ),
        (
          'API 2021:2021',
          'Petrol endüstrisi — Depo tankları yangın önleme ve söndürme.',
        ),
      ],
    ),
    _RehberKategori(
      baslik: 'Davlumbaz & Mutfak Söndürme',
      ikon: Icons.kitchen_rounded,
      renk: Color(0xFF9D174D),
      standartlar: [
        (
          'NFPA 17A:2021',
          'Islak kimyasal (wet chemical) söndürme sistemleri — Ticari mutfak uygulamaları.',
        ),
        (
          'NFPA 17:2021',
          'Kuru kimyasal söndürme sistemleri — Genel sanayi uygulamaları.',
        ),
        (
          'TS EN 15751:2016',
          'Avrupa — Ticari mutfak ekipmanı için sabit yangın söndürme sistemleri.',
        ),
        (
          'UL 300:2017',
          'ABD ürün onay standardı — Yemek pişirme alanları söndürme sistemleri (Ansul, Amerex vb.).',
        ),
        (
          'UL 300A:2014',
          'Otomatik söndürme sistemleri — Pişirme aleti üstü yangın tehlikesi.',
        ),
        ('TS EN 1825-1:2004', 'Mutfak davlumbazı gres tutucular ve filtreler.'),
        (
          'TS EN 1825-2:2004',
          'Mutfak davlumbazı gres tutucular — Seçim, kurulum ve bakım.',
        ),
        (
          'NFPA 96:2021',
          'Ticari mutfak havalandırma sistemi standardı — Kanal, davlumbaz ve yangın önleme.',
        ),
      ],
    ),
    _RehberKategori(
      baslik: 'Yangın Alarm & Algılama',
      ikon: Icons.notifications_active_rounded,
      renk: Color(0xFFB91C1C),
      standartlar: [
        (
          'EN 54-1:2011',
          'Yangın algılama ve alarm sistemleri — Bölüm 1: Sisteme genel bakış.',
        ),
        ('EN 54-2:1997+A1:2006', 'Yangın alarm kontrol ve gösterge paneli.'),
        ('EN 54-3:2001+A2:2006', 'Yangın alarm sesli uyarı cihazları.'),
        ('EN 54-4:1997+A2:2006', 'Güç besleme donanımı.'),
        ('EN 54-5:2017', 'Isı detektörleri — Noktasal.'),
        (
          'EN 54-7:2000+A2:2006',
          'Duman detektörleri — Dağılım tipi optik detektörler.',
        ),
        ('EN 54-10:2002+A1:2005', 'Alev detektörleri — Noktasal.'),
        (
          'EN 54-11:2001+A1:2005',
          'Manuel yangın alarm butonu (kırılır camlı).',
        ),
        ('EN 54-12:2015', 'Duman detektörleri — Doğrusal ışın tipi.'),
        (
          'EN 54-13:2017',
          'Sistem bileşenlerinin uyumluluğu ve bağlanabilirliği değerlendirmesi.',
        ),
        (
          'EN 54-14:2015',
          'Yangın algılama ve alarm sistemleri — Planlama, tasarım, kurulum, devreye alma, kullanım ve bakım kılavuzu.',
        ),
        ('EN 54-16:2008', 'Sesli alarm kontrol ve gösterge donanımı.'),
        ('EN 54-17:2005', 'Kısa devre izolatörleri.'),
        ('EN 54-18:2005', 'Giriş/çıkış cihazları.'),
        ('EN 54-20:2006', 'Duman detektörleri — Aspirasyonlu tip.'),
        ('EN 54-21:2006', 'Alarm iletim ve arıza uyarı yönlendirme donanımı.'),
        ('EN 54-23:2010', 'Yangın alarm görsel uyarı cihazları.'),
        ('EN 54-25:2008', 'Radyo bağlantılı (kablosuz) sistem bileşenleri.'),
        (
          'NFPA 72:2022',
          'ABD — Ulusal yangın alarm ve sinyalizasyon kodu. Adresleme, bildirim, altyapı.',
        ),
        (
          'VdS 2095:2022',
          'Almanya — Yangın alarm sistemleri planlama ve kurulum yönergeleri.',
        ),
      ],
    ),
    _RehberKategori(
      baslik: 'Duman Kontrolü & Tahliye',
      ikon: Icons.air_rounded,
      renk: Color(0xFF374151),
      standartlar: [
        (
          'EN 12101-1:2005',
          'Duman ve ısı tahliye sistemleri — Bölüm 1: Duman ve ısı kontrol perdelerinin özellikleri.',
        ),
        (
          'EN 12101-2:2003',
          'Doğal duman ve ısı tahliye ventilatörleri — Performans gereksinimleri.',
        ),
        (
          'EN 12101-3:2002',
          'Mekanik duman tahliye sistemleri — Motorlu duman egzoz fanları.',
        ),
        (
          'EN 12101-4:2015',
          'Kurulum, kabul testi, rutin bakım ve onarım kılavuzu.',
        ),
        (
          'EN 12101-6:2005',
          'Basınçlı duman kontrol sistemleri — Kit özellikleri.',
        ),
        (
          'EN 12101-7:2011',
          'Duman ve ısı tahliye ventilatörleri — Kanalsız doğal duman tahliyesi.',
        ),
        (
          'EN 12101-8:2011',
          'Tünel için doğal duman tahliye sistemi kontrol panelleri.',
        ),
        ('EN 12101-9:2020', 'Yangın kontrol damperlerinin kontrolü.'),
        ('EN 12101-10:2005', 'Güç besleme kitleri.'),
        (
          'NFPA 92:2021',
          'ABD — Duman kontrol sistemleri standardı. Basınçlı merdivenler, atrium duman yönetimi.',
        ),
        (
          'NFPA 101:2021',
          'ABD — Can güvenliği kodu, tahliye yolları, çıkış gereksinimleri.',
        ),
        (
          'EN 1634-1:2022',
          'Yangın ve duman kontrol kapı ve pencere takımları — Yangına direnç deneyi.',
        ),
        (
          'EN 1634-3:2004',
          'Yangın kapıları — Yangın ve duman geçirgenliği deneyi.',
        ),
        ('EN 15650:2010', 'Havalandırma sistemleri için yangın damperleri.'),
        (
          'EN 15882-1:2011',
          'Yangın kontrol damperlerinin genişletilmiş uygulama.',
        ),
      ],
    ),
    _RehberKategori(
      baslik: 'Yangın Söndürücüler & Taşınabilir Donanım',
      ikon: Icons.fire_extinguisher_rounded,
      renk: Color(0xFFDC2626),
      standartlar: [
        (
          'EN 3-7:2004+A1:2007',
          'Taşınabilir yangın söndürücüler — Performans, test yöntemleri ve yapı.',
        ),
        (
          'EN 3-8:2006+A1:2007',
          'Taşınabilir yangın söndürücüler — Ek gereksinimler ve testler.',
        ),
        (
          'EN 3-9:2006+A1:2007',
          'Taşınabilir yangın söndürücüler — CO² söndürücüler.',
        ),
        (
          'EN 3-10:2009',
          'Taşınabilir yangın söndürücüler — Özel gereksinimler.',
        ),
        ('NFPA 10:2022', 'ABD — Taşınabilir yangın söndürücüler standardı.'),
        ('EN 1866-1:2007', 'Taşınabilir CO² söndürücüler.'),
        (
          'TS EN 615:2009',
          'Yangın söndürücü maddeler — Kuru kimyasal toz özellikleri.',
        ),
        (
          'TS EN 1568-3:2008',
          'Yangın söndürücü maddeler — Köpük konsantreleri.',
        ),
      ],
    ),
    _RehberKategori(
      baslik: 'Yapısal Yangına Direnç',
      ikon: Icons.foundation_rounded,
      renk: Color(0xFF7C3AED),
      standartlar: [
        (
          'EN 1992-1-2:2004',
          'Betonarme yapılar — Yangın etkisi altında yapısal tasarım (Eurocode 2).',
        ),
        (
          'EN 1993-1-2:2005',
          'Çelik yapılar — Yangın etkisi altında yapısal tasarım (Eurocode 3).',
        ),
        (
          'EN 1994-1-2:2005',
          'Kompozit çelik-beton yapılar — Yangın etkisi altında tasarım (Eurocode 4).',
        ),
        (
          'EN 1995-1-2:2004',
          'Ahşap yapılar — Yangın etkisi altında yapısal tasarım (Eurocode 5).',
        ),
        (
          'EN 1996-1-2:2005',
          'Yığma yapılar — Yangın etkisi altında yapısal tasarım (Eurocode 6).',
        ),
        (
          'ISO 834-1:1999',
          'Standart yangın eğrisi — Yapı elemanlarının yangına direnç deneyi.',
        ),
        ('ISO 834-2:2019', 'Alternatif ve parametrik yangın eğrileri.'),
        (
          'EN 13501-1:2018',
          'Yapı malzemeleri ve ürünlerinin yangın performansı sınıflandırması.',
        ),
        (
          'EN 13501-2:2016',
          'Yapı elemanlarının yangına direnç sınıflandırması.',
        ),
        (
          'EN 13501-3:2005',
          'Yangın durumundaki havalandırma servis ürünleri sınıflandırması.',
        ),
        (
          'EN 13501-4:2016',
          'Duman kontrol kapılar ve yapı elemanları sınıflandırması.',
        ),
        (
          'EN 13501-5:2016',
          'Çatılar — Dışarıdan gelen yangına maruz kalma sınıflandırması.',
        ),
        ('NFPA 220:2021', 'ABD — Yapı inşaat tipleri standardı.'),
        ('UL 263:2011', 'ABD — Yapı elemanlarının yangına direnç deneyleri.'),
        (
          'ASTM E119:2022',
          'ABD — Yapı malzemeleri ve sistemlerinin yangın dayanımı deneyleri.',
        ),
      ],
    ),
    _RehberKategori(
      baslik: 'Risk Değerlendirme & Güvenlik Yönetimi',
      ikon: Icons.security_rounded,
      renk: Color(0xFF065F46),
      standartlar: [
        ('ISO 31000:2018', 'Risk yönetimi — Kılavuz ilkeler ve genel çerçeve.'),
        (
          'ISO 45001:2018',
          'İSG yönetim sistemleri — Gereksinimler ve kullanım kılavuzu.',
        ),
        (
          'ISO 16069:2017',
          'Güvenlik işaret sistemleri — Acil kaçış aydınlatması ve yönlendirmesi.',
        ),
        (
          'EN 50172:2004',
          'Acil kaçış aydınlatma sistemleri — Kurulum ve işletme.',
        ),
        (
          'NFPA 1:2021',
          'ABD — Yangın kodu. Bina kullanımı, çıkış, tahliye ve risk.',
        ),
        (
          'NFPA 25:2023',
          'Su bazlı söndürme sistemleri — Denetim, test ve bakım.',
        ),
        (
          'EN ISO 7010:2020',
          'Güvenlik işaretleri — Acil çıkış, yangın teçhizatı ve tehlike işaretleri.',
        ),
        ('TS 9811:2012', 'Türkiye — Yangın İçin Güvenlik İşaretleri.'),
        (
          'TBDY 2018',
          'Türkiye Bina Deprem Yönetmeliği — Bölüm 3: Yapısal çelik, yangın etkisi.',
        ),
        (
          'Binaların Yangından Korunması Hakkında Yönetmelik (2015)',
          'Türkiye — Yapılarda yangından korunma, tahliye, söndürme ve alarm sistemleri gereksinimleri.',
        ),
      ],
    ),
    _RehberKategori(
      baslik: 'Endüstriyel & Özel Risk Sistemleri',
      ikon: Icons.factory_rounded,
      renk: Color(0xFF92400E),
      standartlar: [
        (
          'NFPA 850:2020',
          'Elektrik santrallerinde yangın koruması — Türbin sahaları, trafo ve kablo güzergâhları.',
        ),
        ('NFPA 804:2020', 'Nükleer santraller için yangın koruma standardı.'),
        ('NFPA 409:2022', 'Uçak hangarları yangın koruma standardı.'),
        ('NFPA 415:2021', 'Uçak yakıt ikmal sistemleri ve çalışma alanları.'),
        (
          'EN 1127-1:2019',
          'Patlayıcı ortamlar — Patlamadan korunma, temel kavramlar.',
        ),
        (
          'EN 60079-10-1:2021',
          'Patlayıcı ortamlar — Tehlikeli bölgelerin sınıflandırılması (gaz).',
        ),
        (
          'IEC 61511:2016',
          'İşlevsel güvenlik — Proses endüstrisi güvenlik enstrüman sistemleri.',
        ),
        (
          'API 610:2021',
          'Petrokimya tesislerinde pompalar — Yangın güvenliği gereksinimleri.',
        ),
        ('NFPA 654:2017', 'Yanıcı toz yangını ve patlamasına karşı koruma.'),
        ('NFPA 68:2018', 'Patlama basıncı tahliyesi standardı.'),
        ('NFPA 69:2019', 'Patlama önleme sistemleri standardı.'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      itemCount: _kategoriler.length + (_ozelStandartlar.isNotEmpty ? 1 : 0),
      itemBuilder: (ctx, i) {
        if (i < _kategoriler.length) {
          return _KategoriKart(kategori: _kategoriler[i]);
        }
        // Özel standartlar kartı
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          elevation: 2,
          shadowColor: const Color(0xFFD97706).withOpacity(0.15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD97706).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.bookmark_added_rounded,
                        color: Color(0xFFD97706),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(
                          context,
                        ).customAddedStandardsHeader,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFFD97706),
                        ),
                      ),
                    ),
                    Text(
                      '${_ozelStandartlar.length}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFD97706),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(height: 1),
                const SizedBox(height: 8),
                ..._ozelStandartlar.map(
                  (s) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 3),
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFFD97706),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.numara,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Color(0xFFD97706),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                s.aciklama,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.black54,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  _AraButon(
                                    etiket: AppLocalizations.of(
                                      context,
                                    ).searchWeb,
                                    ikon: Icons.search_rounded,
                                    renk: const Color(0xFF0369A1),
                                    url:
                                        'https://www.google.com/search?q=${Uri.encodeComponent('${s.numara} yangın standardı')}',
                                  ),
                                  const SizedBox(width: 6),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () => showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text(
                                          AppLocalizations.of(
                                            context,
                                          ).deleteStandardTitle,
                                        ),
                                        content: Text(
                                          AppLocalizations.of(
                                            context,
                                          ).deleteStandardConfirm(s.numara),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(ctx),
                                            child: Text(
                                              AppLocalizations.of(
                                                context,
                                              )!.cancel,
                                            ),
                                          ),
                                          FilledButton(
                                            onPressed: () {
                                              Navigator.pop(ctx);
                                              _ozelStandartSil(s.numara);
                                            },
                                            style: FilledButton.styleFrom(
                                              backgroundColor: Colors.red,
                                            ),
                                            child: Text(
                                              AppLocalizations.of(
                                                context,
                                              ).delete,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.red.withOpacity(0.3),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.delete_outline_rounded,
                                            size: 13,
                                            color: Colors.red,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            AppLocalizations.of(
                                              context,
                                            ).delete,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.red,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _KategoriKart extends StatefulWidget {
  final _RehberKategori kategori;
  const _KategoriKart({required this.kategori});
  @override
  State<_KategoriKart> createState() => _KategoriKartState();
}

class _KategoriKartState extends State<_KategoriKart> {
  bool _acik = false;
  @override
  Widget build(BuildContext context) {
    final k = widget.kategori;
    final l10n = AppLocalizations.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
      shadowColor: k.renk.withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => setState(() => _acik = !_acik),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: k.renk.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(k.ikon, color: k.renk, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _rehberBaslikCevir(l10n, k.baslik),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: k.renk,
                      ),
                    ),
                  ),
                  Text(
                    '${k.standartlar.length}',
                    style: TextStyle(
                      fontSize: 12,
                      color: k.renk,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _acik
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: k.renk,
                  ),
                ],
              ),
            ),
          ),
          if (_acik) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
              child: Column(
                children: k.standartlar
                    .map(
                      (s) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 3),
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: k.renk,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        s.$1,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: k.renk,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _standartAciklamaL10n(l10n, s.$2),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.black54,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Padding(
                              padding: const EdgeInsets.only(left: 14),
                              child: Row(
                                children: [
                                  _AraButon(
                                    etiket: AppLocalizations.of(
                                      context,
                                    ).searchWeb,
                                    ikon: Icons.search_rounded,
                                    renk: const Color(0xFF0369A1),
                                    url:
                                        'https://www.google.com/search?q=${Uri.encodeComponent(s.$1 + ' yangın standardı')}',
                                  ),
                                  const SizedBox(width: 6),
                                  _GrokButon(
                                    standartAdi: s.$1,
                                    standartAciklama: _standartAciklamaL10n(
                                      l10n,
                                      s.$2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AraButon extends StatelessWidget {
  final String etiket;
  final IconData ikon;
  final Color renk;
  final String url;
  const _AraButon({
    required this.etiket,
    required this.ikon,
    required this.renk,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: renk.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: renk.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(ikon, size: 13, color: renk),
            const SizedBox(width: 4),
            Text(
              etiket,
              style: TextStyle(
                fontSize: 11,
                color: renk,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GrokButon extends StatefulWidget {
  final String standartAdi;
  final String standartAciklama;
  const _GrokButon({required this.standartAdi, required this.standartAciklama});

  @override
  State<_GrokButon> createState() => _GrokButonState();
}

class _GrokButonState extends State<_GrokButon> {
  Future<void> _geminiSor() async {
    final apiKey = await _geminiApiAl(context);
    if (apiKey == null) return;
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AiSohbetSayfasi(
          standartAdi: widget.standartAdi,
          standartAciklama: widget.standartAciklama,
          apiKey: apiKey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const renk = Color(0xFF7C3AED);
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: _geminiSor,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: renk.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: renk.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_awesome_rounded, size: 13, color: renk),
            const SizedBox(width: 4),
            Text(
              AppLocalizations.of(context).askAi,
              style: const TextStyle(
                fontSize: 11,
                color: renk,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
// API AYARLARI SAYFASI
// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦

class ApiAyarlariSayfasi extends StatefulWidget {
  const ApiAyarlariSayfasi({super.key});

  @override
  State<ApiAyarlariSayfasi> createState() => _ApiAyarlariSayfasiState();
}

class _ApiAyarlariSayfasiState extends State<ApiAyarlariSayfasi> {
  final _ctrl = TextEditingController();
  bool _gizle = true;
  bool _kaydedildi = false;
  bool _siliniyor = false;
  String _kullaniciEposta = '';

  Future<void> _hesabiSil() async {
    final l10n = AppLocalizations.of(context);
    final onay = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.accountDeleteTitle),
        content: Text(l10n.accountDeleteWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (onay != true || !mounted) return;

    setState(() => _siliniyor = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token') ?? '';
      if (token.isEmpty) {
        throw Exception(l10n.sessionNotFoundRelogin);
      }
      final response = await http
          .post(
            Uri.parse('$kApiBase/api/auth/delete-account.php'),
            headers: {'Authorization': 'Bearer $token'},
          )
          .timeout(const Duration(seconds: 20));
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 200) {
        throw Exception(data['error']?.toString() ?? l10n.accountDeleteFailed);
      }

      for (final key in [
        'jwt_token',
        'user_name',
        'user_email',
        'is_premium',
        'fire_perm',
        'fire_perm_at',
        'ozel_standartlar_fire',
        'kayitli_projeler_v1',
        'gemini_api_key',
      ]) {
        await prefs.remove(key);
      }
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const GirisSayfasi()),
        (route) => false,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
        );
      }
    } finally {
      if (mounted) setState(() => _siliniyor = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _yukle();
  }

  Future<void> _yukle() async {
    final prefs = await SharedPreferences.getInstance();
    final val = prefs.getString('gemini_api_key') ?? '';
    final eposta = prefs.getString('user_email') ?? '';
    if (!mounted) return;
    setState(() {
      _ctrl.text = val;
      _kullaniciEposta = eposta;
    });
  }

  Future<void> _kaydet() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('gemini_api_key', _ctrl.text.trim());
    setState(() => _kaydedildi = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _kaydedildi = false);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB91C1C),
        foregroundColor: Colors.white,
        title: Text(l10n.settingsTitle, style: const TextStyle(fontSize: 16)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            tooltip: l10n.logout,
            onPressed: () => _cikisYap(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.language_rounded),
              title: Text(l10n.languageLabel),
              trailing: const _DilSecici(),
            ),
            const Divider(height: 24),
            Text(
              l10n.apiKeyTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.apiKeyInstructions,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _ctrl,
              obscureText: _gizle,
              decoration: InputDecoration(
                hintText: 'AIza...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.key_rounded),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                suffixIcon: IconButton(
                  icon: Icon(_gizle ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _gizle = !_gizle),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _kaydet,
                icon: Icon(
                  _kaydedildi ? Icons.check_rounded : Icons.save_rounded,
                ),
                label: Text(_kaydedildi ? l10n.saved : l10n.save),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () async {
                final uri = Uri.parse('https://aistudio.google.com/apikey');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              child: Text(
                'aistudio.google.com/apikey › ${l10n.getApiKey}',
                style: const TextStyle(
                  color: Color(0xFF0369A1),
                  decoration: TextDecoration.underline,
                  fontSize: 13,
                ),
              ),
            ),
            const Divider(height: 36),
            Text(
              l10n.accountManagement,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.accountDeleteInfo,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            if (_kullaniciEposta.isNotEmpty) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.email_outlined,
                    size: 18,
                    color: Colors.black54,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _kullaniciEposta,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _siliniyor ? null : _hesabiSil,
                icon: _siliniyor
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.delete_forever_rounded),
                label: Text(
                  _siliniyor ? l10n.deletingAccount : l10n.deleteAccount,
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const Divider(height: 36),
            Text(
              l10n.feedbackTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.feedbackSubtitle,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => const Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    insetPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    child: _GeriBildirimSheet(),
                  ),
                ),
                icon: const Icon(Icons.feedback_outlined),
                label: Text(l10n.feedbackTitle),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFB91C1C),
                  side: const BorderSide(color: Color(0xFFB91C1C)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
// GERİ BİLDİRİM (FEEDBACK) BOTTOM SHEET
// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦

class _GeriBildirimSheet extends StatefulWidget {
  const _GeriBildirimSheet();

  @override
  State<_GeriBildirimSheet> createState() => _GeriBildirimSheetState();
}

class _GeriBildirimSheetState extends State<_GeriBildirimSheet> {
  final _mesajCtrl = TextEditingController();
  String? _seciliSayfa;
  bool _gonderiliyor = false;

  List<String> _sayfaListesi(AppLocalizations l10n) => [
    l10n.feedbackPageHome,
    l10n.fireLoadTitle,
    l10n.kitchenSuppressionTitle,
    l10n.gasSuppressionTitle,
    l10n.lithiumFireTitle,
    l10n.sprinklerTitle,
    l10n.smokeDetectionTitle,
    l10n.smokeControlTitle,
    l10n.standardSearch,
    l10n.standardGuide,
    l10n.savedProjects,
    l10n.feedbackPageOther,
  ];

  @override
  void dispose() {
    _mesajCtrl.dispose();
    super.dispose();
  }

  Future<void> _gonder(AppLocalizations l10n) async {
    if (_seciliSayfa == null || _mesajCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.feedbackMessageRequired)),
      );
      return;
    }
    setState(() => _gonderiliyor = true);
    final localeCode = Localizations.localeOf(context).languageCode;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token') ?? '';
      final email = prefs.getString('user_email') ?? '';
      final response = await http
          .post(
            Uri.parse('$kApiBase/api/feedback.php'),
            headers: {
              'Content-Type': 'application/json',
              if (token.isNotEmpty) 'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              'page': _seciliSayfa,
              'message': _mesajCtrl.text.trim(),
              'app_version': kAppVersion,
              'locale': localeCode,
              'email': email,
            }),
          )
          .timeout(const Duration(seconds: 15));
      if (!mounted) return;
      if (response.statusCode == 200) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.feedbackSentSuccess)),
        );
      } else {
        throw Exception(l10n.feedbackSendFailed);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.feedbackSendFailed)),
        );
      }
    } finally {
      if (mounted) setState(() => _gonderiliyor = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.feedbackTitle,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.feedbackSelectPage,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _seciliSayfa,
            isExpanded: true,
            hint: Text(l10n.feedbackSelectPageHint),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
            ),
            items: _sayfaListesi(l10n)
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
            onChanged: (v) => setState(() => _seciliSayfa = v),
          ),
          if (_seciliSayfa != null) ...[
            const SizedBox(height: 16),
            Text(
              l10n.feedbackMessageLabel,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _mesajCtrl,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: l10n.feedbackMessageHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _gonderiliyor ? null : () => _gonder(l10n),
                icon: _gonderiliyor
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send_rounded),
                label: Text(
                  _gonderiliyor ? l10n.feedbackSending : l10n.feedbackSend,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB91C1C),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ],
        ),
      ),
    );
  }
}

// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
// AI SOHBET SAYFASI
// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦

class AiSohbetSayfasi extends StatefulWidget {
  final String standartAdi;
  final String standartAciklama;
  final String apiKey;

  const AiSohbetSayfasi({
    super.key,
    required this.standartAdi,
    required this.standartAciklama,
    required this.apiKey,
  });

  @override
  State<AiSohbetSayfasi> createState() => _AiSohbetSayfasiState();
}

class _AiSohbetSayfasiState extends State<AiSohbetSayfasi> {
  final _ctrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  final List<Map<String, String>> _mesajlar = [];
  bool _yukleniyor = false;
  bool _selamlamaEklendi = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_selamlamaEklendi) {
      _selamlamaEklendi = true;
      _mesajlar.add({
        'role': 'model',
        'text': AppLocalizations.of(context).aiChatGreeting(
          widget.standartAdi,
        ),
      });
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _gonder(String metin) async {
    metin = metin.trim();
    if (metin.isEmpty || _yukleniyor) return;
    _ctrl.clear();
    setState(() {
      _mesajlar.add({'role': 'user', 'text': metin});
      _yukleniyor = true;
    });
    _asagiKaydir();
    try {
      final yanitDili = Localizations.localeOf(context).languageCode == 'en'
          ? 'English'
          : 'Turkish';
      final sistem =
          'Sen yangın güvenliği ve standartlar konusunda uzman bir mühendissin. '
          'Yalnızca aşağıdaki standart hakkında kısa, net yanıtlar ver. '
          'Yanıt dilin $yanitDili olsun. '
          'Emin olmadığın şeyleri uydurma.\n\n'
          'Standart: ${widget.standartAdi}\n'
          'Açıklama: ${widget.standartAciklama}';
      final gecmis = _mesajlar
          .skip(1)
          .map(
            (m) => {
              'role': m['role'] == 'model' ? 'assistant' : 'user',
              'content': m['text']!,
            },
          )
          .toList();
      final yanit = await geminiChat(
        apiKey: widget.apiKey,
        mesajlar: [
          {'role': 'system', 'content': sistem},
          ...gecmis,
        ],
      );
      if (!mounted) return;
      setState(() {
        _mesajlar.add({'role': 'model', 'text': yanit});
        _yukleniyor = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _mesajlar.add({
          'role': 'model',
          'text': AppLocalizations.of(
            context,
          ).genericErrorWithDetail(e.toString().replaceAll('Exception: ', '')),
        });
        _yukleniyor = false;
      });
    }
    _asagiKaydir();
  }

  void _asagiKaydir() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _apiGuncelle() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    final yeni = await _geminiApiDiyaloguGoster(context, prefs);
    if (yeni != null && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => AiSohbetSayfasi(
            standartAdi: widget.standartAdi,
            standartAciklama: widget.standartAciklama,
            apiKey: yeni,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const kAi = Color(0xFF7C3AED);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAi,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.aiAssistantTitle, style: const TextStyle(fontSize: 15)),
            Text(
              widget.standartAdi,
              style: const TextStyle(fontSize: 11, color: Colors.white70),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.key_rounded),
            tooltip: l10n.updateApiKey,
            onPressed: _apiGuncelle,
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            tooltip: l10n.logout,
            onPressed: () => _cikisYap(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            color: kAi.withAlpha(15),
            child: Text(
              '${widget.standartAdi} — ${widget.standartAciklama}',
              style: const TextStyle(
                fontSize: 12,
                color: kAi,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
              itemCount: _mesajlar.length + (_yukleniyor ? 1 : 0),
              itemBuilder: (ctx, i) {
                if (i == _mesajlar.length) return const _YaziyorBubble();
                final m = _mesajlar[i];
                return _MesajBubble(
                  metin: m['text']!,
                  kullanici: m['role'] == 'user',
                );
              },
            ),
          ),
          _MesajGiris(
            controller: _ctrl,
            yukleniyor: _yukleniyor,
            onGonder: _gonder,
          ),
        ],
      ),
    );
  }
}

class _MesajBubble extends StatelessWidget {
  const _MesajBubble({required this.metin, required this.kullanici});
  final String metin;
  final bool kullanici;

  @override
  Widget build(BuildContext context) {
    const kAi = Color(0xFF7C3AED);
    return Align(
      alignment: kullanici ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: kullanici ? kAi : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(kullanici ? 16 : 4),
            bottomRight: Radius.circular(kullanici ? 4 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(12),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: SelectableText(
          metin,
          style: TextStyle(
            fontSize: 14,
            color: kullanici ? Colors.white : Colors.black87,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}

class _YaziyorBubble extends StatelessWidget {
  const _YaziyorBubble();
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(12),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const SizedBox(
          width: 40,
          height: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _Nokta(delay: 0),
              _Nokta(delay: 200),
              _Nokta(delay: 400),
            ],
          ),
        ),
      ),
    );
  }
}

class _Nokta extends StatefulWidget {
  const _Nokta({required this.delay});
  final int delay;
  @override
  State<_Nokta> createState() => _NoktaState();
}

class _NoktaState extends State<_Nokta> with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _anim, curve: Curves.easeInOut));
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _anim.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: const CircleAvatar(radius: 4, backgroundColor: Color(0xFF7C3AED)),
    );
  }
}

class _MesajGiris extends StatelessWidget {
  const _MesajGiris({
    required this.controller,
    required this.yukleniyor,
    required this.onGonder,
  });
  final TextEditingController controller;
  final bool yukleniyor;
  final ValueChanged<String> onGonder;

  @override
  Widget build(BuildContext context) {
    const kAi = Color(0xFF7C3AED);
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(12, 8, 12, 8 + bottomPad),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.send,
              maxLines: 4,
              minLines: 1,
              enabled: !yukleniyor,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.questionHint,
                filled: true,
                fillColor: const Color(0xFFF8F9FF),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: const BorderSide(color: kAi, width: 1.5),
                ),
              ),
              onSubmitted: yukleniyor ? null : onGonder,
            ),
          ),
          const SizedBox(width: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: yukleniyor ? Colors.grey : kAi,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send_rounded, color: Colors.white),
              onPressed: yukleniyor ? null : () => onGonder(controller.text),
            ),
          ),
        ],
      ),
    );
  }
}

// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
// DATA MODELS
// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦

class _Malzeme {
  String ad;
  double kg;
  double ncv;
  _Malzeme({required this.ad, required this.kg, required this.ncv});
}

class _Depo {
  String tur;
  double miktar; // ton veya m³ (tek tank)
  String birim; // 'ton' | 'm³'
  int adet; // tank adedi
  _Depo({
    required this.tur,
    required this.miktar,
    required this.birim,
    this.adet = 1,
  });
}

class _YakitSpec {
  final double ncv; // MJ/kg
  final double d; // kg/L (yoğunluk)
  final bool sinifC; // true = Sınıf C (gaz), false = Sınıf B (sıvı)
  const _YakitSpec(this.ncv, this.d, {this.sinifC = false});
}

enum _Mod { bina, pano, depo }

class _SondAjan {
  final String ad, standart, aciklama;
  final double? spesifik;
  final double konsan;
  final bool inert;
  const _SondAjan({
    required this.ad,
    required this.standart,
    required this.spesifik,
    required this.konsan,
    required this.inert,
    required this.aciklama,
  });
}

class _BuyumeVeri {
  final String hiz;
  final int tAlfa;
  final double rhrF;
  const _BuyumeVeri(this.hiz, this.tAlfa, this.rhrF);
}

String _buyumeHizL10n(AppLocalizations l10n, String hizTr) => switch (hizTr) {
  'Çok Yavaş' => l10n.growthRateVerySlow,
  'Yavaş' => l10n.growthRateSlow,
  'Orta' => l10n.growthRateMedium,
  'Hızlı' => l10n.growthRateFast,
  'Çok Hızlı' => l10n.growthRateVeryFast,
  _ => hizTr,
};

class _Standart {
  final String numara, ad, kategori, aciklama;
  const _Standart({
    required this.numara,
    required this.ad,
    required this.kategori,
    required this.aciklama,
  });
  factory _Standart.fromJson(Map<String, dynamic> j) => _Standart(
    numara: (j['numara'] ?? '').toString(),
    ad: (j['ad'] ?? '').toString(),
    kategori: (j['kategori'] ?? '').toString(),
    aciklama: (j['aciklama'] ?? '').toString(),
  );
}

class _RehberKategori {
  final String baslik;
  final IconData ikon;
  final Color renk;
  final List<(String, String)> standartlar;
  const _RehberKategori({
    required this.baslik,
    required this.ikon,
    required this.renk,
    required this.standartlar,
  });
}

String _rehberBaslikCevir(AppLocalizations l10n, String baslik) =>
    switch (baslik) {
      'Yangın Yükü & Yangın Senaryosu' => l10n.rehberFireLoadScenario,
      'Gazlı Söndürme Sistemleri' => l10n.rehberGasSuppressionSystems,
      'Baskı Makinesi Söndürme' => l10n.printingSuppression,
      'Su Bazlı Söndürme Sistemleri' => l10n.rehberWaterBasedSuppression,
      'Köpüklü Söndürme Sistemleri' => l10n.rehberFoamSuppressionSystems,
      'Davlumbaz & Mutfak Söndürme' => l10n.rehberKitchenHoodSuppression,
      'Yangın Alarm & Algılama' => l10n.fireAlarm,
      'Duman Kontrolü & Tahliye' => l10n.smokeControl,
      'Yangın Söndürücüler & Taşınabilir Donanım' =>
        l10n.rehberFireExtinguishersPortable,
      'Yapısal Yangına Direnç' => l10n.rehberStructuralFireResistance,
      'Risk Değerlendirme & Güvenlik Yönetimi' =>
        l10n.rehberRiskAssessmentSafety,
      'Endüstriyel & Özel Risk Sistemleri' => l10n.rehberIndustrialSpecialRisk,
      _ => baslik,
    };

String _standartAciklamaL10n(AppLocalizations l10n, String aciklama) =>
    switch (aciklama) {
  'Eurocode 1 Bölüm 1-2: Yapılara etkiyen yükler — Yangın etkileri. Yangın yükü yoğunluğu, büyüme hızı ve yangın senaryosu hesabı.' => l10n.stdDescEn1991FireLoad,
  'Yapı malzemeleri ve ürünlerinin yanma ısısının tayini — Net ısıl değer (NCV) belirleme yöntemi.' => l10n.stdDescIso1716Ncv,
  'Yangın tepkisi deneyleri — Isı salım hızı, duman üretim hızı ve kütle kaybı hızı. Koni kalorimetre yöntemi.' => l10n.stdDescIso5660ConeCalorimeter,
  'Yangın yükü yoğunluğu hesabı standardı — Bina kullanım tipine göre referans yoğunluk tabloları.' => l10n.stdDescNfpa557FireLoadDensity,
  'Yangın güvenliği mühendisliği — Yapıda yangın davranışının değerlendirilmesi.' => l10n.stdDescIso24679FireBehaviour,
  'Yangın güvenliği mühendisliği — Yangın senaryosu ve yangın modellemesi seçimi.' => l10n.stdDescIso16733FireScenario,
  'Yangın koruma mühendisliği başvuru kitabı — Hesap yöntemleri, yangın dinamiği, duman hareketi.' => l10n.stdDescSfpeHandbook,
  'BSI — Yapılarda yangın güvenliği mühendisliği uygulaması: Yangın başlangıcı ve gelişimi.' => l10n.stdDescPd7974FireInitiation,
  'Gazlı söndürme sistemleri — Genel kurallar: tasarım, kurulum, devreye alma, bakım ve güvenlik.' => l10n.stdDescIso145201GeneralRules,
  'CO² söndürme sistemleri — Toplam taşkın ve yerel uygulama yöntemleri.' => l10n.stdDescIso145202Co2,
  'HFC-227ea (FM-200) gazlı söndürme sistemleri — Konsantrasyon ve hacim hesabı.' => l10n.stdDescIso145205Hfc227,
  'HCFC Blend A (Halotron I) söndürme sistemleri.' => l10n.stdDescIso145208Hcfc,
  'HFC 23 (Triflorometan) söndürme sistemleri.' => l10n.stdDescIso145209Hfc23,
  'IG-55 (Argonite) sistemleri — N²/Ar karışımı, inert gaz.' => l10n.stdDescIso1452010Ig55,
  'IG-541 (Inergen) — N²/Ar/CO² karışımı, inert gazlı söndürme.' => l10n.stdDescIso1452011Ig541,
  'IG-01 (Argon) söndürme sistemleri.' => l10n.stdDescIso1452012Ig01,
  'IG-100 (Azot) söndürme sistemleri.' => l10n.stdDescIso1452013Ig100,
  'FK-5-1-12 (Novec 1230) — Düşük GWP değeri, hassas ekipman odaları.' => l10n.stdDescIso1452015Novec,
  'ABD — Temiz ajan (clean agent) söndürme sistemleri standardı.' => l10n.stdDescNfpa2001CleanAgent,
  'CO² söndürme sistemleri — ABD standardı, toplam taşkın ve yerel uygulama.' => l10n.stdDescNfpa12Co2Us,
  'Halon 1301 söndürme sistemleri — ABD, mevcut sistemler.' => l10n.stdDescNfpa12aHalon,
  'Sabit yangın söndürme sistemleri — Gazlı söndürme sistemleri, genel gereksinimler.' => l10n.stdDescTsEn150041GeneralReq,
  'Almanya — Gazlı söndürme sistemleri tasarım ve kurulum yönergeleri.' => l10n.stdDescVds2380Design,
  'Yanıcı/tutuşabilir sıvı kullanan daldırma, kaplama ve baskı prosesleri — temel güvenlik standardı.' => l10n.stdDescNfpa34DippingCoating,
  'Printing Operations: baskı alanı yapısı, havalandırma, elektrik sınıflandırması ve yangın koruma.' => l10n.stdDescNfpa34Sec10PrintingOps,
  'Otomatik yangın söndürme zorunluluğu — Sınıf I sıvı için sprinkler; kurutucu bölmeler için yerel CO₂/temiz ajan.' => l10n.stdDescNfpa34Sec106AutoSuppression,
  'CO₂ söndürme — baskı makinesi ve kurutucu bölme yerel uygulama sistemleri.' => l10n.stdDescNfpa12PrintingPressLocal,
  'Temiz ajan söndürme — baskı makinesi kabin koruma, insan varlığında tercih edilir.' => l10n.stdDescNfpa2001PrintingCabin,
  'Yanıcı ve tutuşabilir sıvılar kodu — baskı tesisinde solvent depolama ve kullanım.' => l10n.stdDescNfpa30PrintingSolvent,
  'Baskı alanı ATEX/NEC patlayıcı atmosfer sınıflandırması ve elektrik ekipmanı.' => l10n.stdDescNfpa70Article516,
  'Baskı makinelerinin güvenliği — Genel gereksinimler.' => l10n.stdDescEn10101PrintingSafetyGeneral,
  'Baskı makinelerinin güvenliği — Baskı ve baskı lakı uygulama makineleri (ofset, flexo, gravür).' => l10n.stdDescEn10102PrintingSafetyMachines,
  'ATEX ekipmanlar — Potansiyel patlayıcı ortamda kullanılacak ekipmanlar için güvenlik kriterleri.' => l10n.stdDescEn13463AtexEquipment,
  'Gazlı söndürme sistemleri — Genel şartlar (baskı kabini için temiz ajan hesabı).' => l10n.stdDescTsEn150041PrintingCabinet,
  'Sabit sprinkler sistemleri — Tasarım, tesis ve bakım. Tehlike sınıfı, yoğunluk, debi ve depo hacmi.' => l10n.stdDescTsEn12845Sprinkler,
  'Sprinkler sistemi kurulumu standardı — ABD, tüm bina tipleri.' => l10n.stdDescNfpa13SprinklerInstallation,
  'Konut binalarında sprinkler sistemleri — 4 kata kadar yapılar.' => l10n.stdDescNfpa13rResidential,
  'Tek ve iki ailelik konutlarda sprinkler sistemleri.' => l10n.stdDescNfpa13dOneTwoFamily,
  'Sabit su spreyi söndürme sistemleri — Ekipman ve risk koruma.' => l10n.stdDescNfpa15WaterSpray,
  'Köpük-su sprey ve köpük-su sprinkler sistemleri.' => l10n.stdDescNfpa16FoamWaterSpray,
  'Yeraltı yangın hidranti sistemleri — Tasarım ve kurulum.' => l10n.stdDescEn14339UndergroundHydrant,
  'Yerüstü yangın hidranti sistemleri.' => l10n.stdDescEn14384AboveGroundHydrant,
  'Sabit yangın söndürme donanımı — Yarı sert hortumlu makara sistemleri.' => l10n.stdDescEn6711SemiRigidHose,
  'Sabit yangın söndürme donanımı — Düz hortumlu hidrant sistemleri.' => l10n.stdDescEn6712FlatHoseHydrant,
  'Sabit yangın söndürme donanımı — Bakım, Bölüm 3.' => l10n.stdDescEn6713Maintenance,
  'Sabit yangın söndürme sistemleri — Sprinkler ve su spreyi bileşenleri.' => l10n.stdDescEn122591Components,
  'Sabit söndürme sistemleri — Su sisi sistemleri, Bölüm 1: Tasarım ve kurulum.' => l10n.stdDescTsEn149721WaterMistDesign,
  'Su sisi (water mist) söndürme sistemleri standardı — ABD.' => l10n.stdDescNfpa750WaterMist,
  'Düşük, orta ve yüksek genleşmeli köpük söndürme sistemleri — ABD standardı.' => l10n.stdDescNfpa11ExpansionFoam,
  'Sabit köpük söndürme sistemleri — Bölüm 1: Gereksinimler ve test yöntemleri.' => l10n.stdDescEn135651FoamRequirements,
  'Sabit köpük söndürme sistemleri — Bölüm 2: Tasarım, kurulum ve bakım.' => l10n.stdDescEn135652FoamDesignInstall,
  'Yangın söndürücü maddeler — Sıvı akaryakıt yangınları için köpük konsantreleri.' => l10n.stdDescIso72031FoamConcentrates,
  'Yanıcı ve tutuşabilir sıvılar kodu — Depolama ve taşıma.' => l10n.stdDescNfpa30StorageTransfer,
  'Petrol endüstrisi — Depo tankları yangın önleme ve söndürme.' => l10n.stdDescApi2021TankFirePrevention,
  'Islak kimyasal (wet chemical) söndürme sistemleri — Ticari mutfak uygulamaları.' => l10n.stdDescNfpa17aWetChemical,
  'Kuru kimyasal söndürme sistemleri — Genel sanayi uygulamaları.' => l10n.stdDescNfpa17DryChemical,
  'Avrupa — Ticari mutfak ekipmanı için sabit yangın söndürme sistemleri.' => l10n.stdDescTsEn15751CommercialKitchen,
  'ABD ürün onay standardı — Yemek pişirme alanları söndürme sistemleri (Ansul, Amerex vb.).' => l10n.stdDescUl300CookingSuppression,
  'Otomatik söndürme sistemleri — Pişirme aleti üstü yangın tehlikesi.' => l10n.stdDescUl300aAutoSuppressionCooking,
  'Mutfak davlumbazı gres tutucular ve filtreler.' => l10n.stdDescTsEn18251GreaseSeparators,
  'Mutfak davlumbazı gres tutucular — Seçim, kurulum ve bakım.' => l10n.stdDescTsEn18252GreaseSelection,
  'Ticari mutfak havalandırma sistemi standardı — Kanal, davlumbaz ve yangın önleme.' => l10n.stdDescNfpa96VentilationCooking,
  'Yangın algılama ve alarm sistemleri — Bölüm 1: Sisteme genel bakış.' => l10n.stdDescEn541Introduction,
  'Yangın alarm kontrol ve gösterge paneli.' => l10n.stdDescEn542ControlIndicating,
  'Yangın alarm sesli uyarı cihazları.' => l10n.stdDescEn543SoundersDevices,
  'Güç besleme donanımı.' => l10n.stdDescEn544PowerSupply,
  'Isı detektörleri — Noktasal.' => l10n.stdDescEn545HeatDetectors,
  'Duman detektörleri — Dağılım tipi optik detektörler.' => l10n.stdDescEn547SmokeDetectorsOptical,
  'Alev detektörleri — Noktasal.' => l10n.stdDescEn5410FlameDetectors,
  'Manuel yangın alarm butonu (kırılır camlı).' => l10n.stdDescEn5411ManualCallPoint,
  'Duman detektörleri — Doğrusal ışın tipi.' => l10n.stdDescEn5412SmokeDetectorsLinear,
  'Sistem bileşenlerinin uyumluluğu ve bağlanabilirliği değerlendirmesi.' => l10n.stdDescEn5413SystemCompatibility,
  'Yangın algılama ve alarm sistemleri — Planlama, tasarım, kurulum, devreye alma, kullanım ve bakım kılavuzu.' => l10n.stdDescEn5414PlanningGuide,
  'Sesli alarm kontrol ve gösterge donanımı.' => l10n.stdDescEn5416VoiceAlarm,
  'Kısa devre izolatörleri.' => l10n.stdDescEn5417ShortCircuitIsolators,
  'Giriş/çıkış cihazları.' => l10n.stdDescEn5418InputOutputDevices,
  'Duman detektörleri — Aspirasyonlu tip.' => l10n.stdDescEn5420AspiratingSmoke,
  'Alarm iletim ve arıza uyarı yönlendirme donanımı.' => l10n.stdDescEn5421AlarmTransmission,
  'Yangın alarm görsel uyarı cihazları.' => l10n.stdDescEn5423VisualAlarm,
  'Radyo bağlantılı (kablosuz) sistem bileşenleri.' => l10n.stdDescEn5425RadioComponents,
  'ABD — Ulusal yangın alarm ve sinyalizasyon kodu. Adresleme, bildirim, altyapı.' => l10n.stdDescNfpa72NationalCode,
  'Almanya — Yangın alarm sistemleri planlama ve kurulum yönergeleri.' => l10n.stdDescVds2095PlanningInstall,
  'Duman ve ısı tahliye sistemleri — Bölüm 1: Duman ve ısı kontrol perdelerinin özellikleri.' => l10n.stdDescEn121011SmokeCurtains,
  'Doğal duman ve ısı tahliye ventilatörleri — Performans gereksinimleri.' => l10n.stdDescEn121012NaturalVentilators,
  'Mekanik duman tahliye sistemleri — Motorlu duman egzoz fanları.' => l10n.stdDescEn121013PoweredExhaust,
  'Kurulum, kabul testi, rutin bakım ve onarım kılavuzu.' => l10n.stdDescEn121014InstallCommission,
  'Basınçlı duman kontrol sistemleri — Kit özellikleri.' => l10n.stdDescEn121016PressureDifferential,
  'Duman ve ısı tahliye ventilatörleri — Kanalsız doğal duman tahliyesi.' => l10n.stdDescEn121017DuctlessNaturalVent,
  'Tünel için doğal duman tahliye sistemi kontrol panelleri.' => l10n.stdDescEn121018TunnelControlPanels,
  'Yangın kontrol damperlerinin kontrolü.' => l10n.stdDescEn121019FireDamperControl,
  'Güç besleme kitleri.' => l10n.stdDescEn1210110PowerSupplyKits,
  'ABD — Duman kontrol sistemleri standardı. Basınçlı merdivenler, atrium duman yönetimi.' => l10n.stdDescNfpa92SmokeControlUs,
  'ABD — Can güvenliği kodu, tahliye yolları, çıkış gereksinimleri.' => l10n.stdDescNfpa101LifeSafety,
  'Yangın ve duman kontrol kapı ve pencere takımları — Yangına direnç deneyi.' => l10n.stdDescEn16341DoorFireResistance,
  'Yangın kapıları — Yangın ve duman geçirgenliği deneyi.' => l10n.stdDescEn16343SmokeControl,
  'Havalandırma sistemleri için yangın damperleri.' => l10n.stdDescEn15650FireDampers,
  'Yangın kontrol damperlerinin genişletilmiş uygulama.' => l10n.stdDescEn158821ExtendedApplication,
  'Taşınabilir yangın söndürücüler — Performans, test yöntemleri ve yapı.' => l10n.stdDescEn37PortableExtPerformance,
  'Taşınabilir yangın söndürücüler — Ek gereksinimler ve testler.' => l10n.stdDescEn38PortableExtAdditional,
  'Taşınabilir yangın söndürücüler — CO² söndürücüler.' => l10n.stdDescEn39PortableExtCo2,
  'Taşınabilir yangın söndürücüler — Özel gereksinimler.' => l10n.stdDescEn310PortableExtSpecial,
  'ABD — Taşınabilir yangın söndürücüler standardı.' => l10n.stdDescNfpa10PortableUs,
  'Taşınabilir CO² söndürücüler.' => l10n.stdDescEn18661MobileCo2,
  'Yangın söndürücü maddeler — Kuru kimyasal toz özellikleri.' => l10n.stdDescTsEn615DryChemicalPowder,
  'Yangın söndürücü maddeler — Köpük konsantreleri.' => l10n.stdDescTsEn15683FoamConcentrates,
  'Betonarme yapılar — Yangın etkisi altında yapısal tasarım (Eurocode 2).' => l10n.stdDescEn1992Eurocode2,
  'Çelik yapılar — Yangın etkisi altında yapısal tasarım (Eurocode 3).' => l10n.stdDescEn1993Eurocode3,
  'Kompozit çelik-beton yapılar — Yangın etkisi altında tasarım (Eurocode 4).' => l10n.stdDescEn1994Eurocode4,
  'Ahşap yapılar — Yangın etkisi altında yapısal tasarım (Eurocode 5).' => l10n.stdDescEn1995Eurocode5,
  'Yığma yapılar — Yangın etkisi altında yapısal tasarım (Eurocode 6).' => l10n.stdDescEn1996Eurocode6,
  'Standart yangın eğrisi — Yapı elemanlarının yangına direnç deneyi.' => l10n.stdDescIso8341StandardFireCurve,
  'Alternatif ve parametrik yangın eğrileri.' => l10n.stdDescIso8342AlternativeCurves,
  'Yapı malzemeleri ve ürünlerinin yangın performansı sınıflandırması.' => l10n.stdDescEn135011ReactionToFire,
  'Yapı elemanlarının yangına direnç sınıflandırması.' => l10n.stdDescEn135012FireResistanceClass,
  'Yangın durumundaki havalandırma servis ürünleri sınıflandırması.' => l10n.stdDescEn135013VentilationServices,
  'Duman kontrol kapılar ve yapı elemanları sınıflandırması.' => l10n.stdDescEn135014SmokeControlDoors,
  'Çatılar — Dışarıdan gelen yangına maruz kalma sınıflandırması.' => l10n.stdDescEn135015Roofs,
  'ABD — Yapı inşaat tipleri standardı.' => l10n.stdDescNfpa220ConstructionTypes,
  'ABD — Yapı elemanlarının yangına direnç deneyleri.' => l10n.stdDescUl263FireResistanceTests,
  'ABD — Yapı malzemeleri ve sistemlerinin yangın dayanımı deneyleri.' => l10n.stdDescAstmE119FireEndurance,
  'Risk yönetimi — Kılavuz ilkeler ve genel çerçeve.' => l10n.stdDescIso31000RiskManagement,
  'İSG yönetim sistemleri — Gereksinimler ve kullanım kılavuzu.' => l10n.stdDescIso45001Ohs,
  'Güvenlik işaret sistemleri — Acil kaçış aydınlatması ve yönlendirmesi.' => l10n.stdDescIso16069SafetyWayGuidance,
  'Acil kaçış aydınlatma sistemleri — Kurulum ve işletme.' => l10n.stdDescEn50172EmergencyLighting,
  'ABD — Yangın kodu. Bina kullanımı, çıkış, tahliye ve risk.' => l10n.stdDescNfpa1FireCode,
  'Su bazlı söndürme sistemleri — Denetim, test ve bakım.' => l10n.stdDescNfpa25InspectionTesting,
  'Güvenlik işaretleri — Acil çıkış, yangın teçhizatı ve tehlike işaretleri.' => l10n.stdDescEnIso7010SafetySigns,
  'Türkiye — Yangın İçin Güvenlik İşaretleri.' => l10n.stdDescTs9811FireSafetySigns,
  'Türkiye Bina Deprem Yönetmeliği — Bölüm 3: Yapısal çelik, yangın etkisi.' => l10n.stdDescTbdy2018SeismicSteelFire,
  'Türkiye — Yapılarda yangından korunma, tahliye, söndürme ve alarm sistemleri gereksinimleri.' => l10n.stdDescTrFireRegulation2015,
  'Elektrik santrallerinde yangın koruması — Türbin sahaları, trafo ve kablo güzergâhları.' => l10n.stdDescNfpa850PowerGeneration,
  'Nükleer santraller için yangın koruma standardı.' => l10n.stdDescNfpa804NuclearPlants,
  'Uçak hangarları yangın koruma standardı.' => l10n.stdDescNfpa409AircraftHangars,
  'Uçak yakıt ikmal sistemleri ve çalışma alanları.' => l10n.stdDescNfpa415AircraftFueling,
  'Patlayıcı ortamlar — Patlamadan korunma, temel kavramlar.' => l10n.stdDescEn11271ExplosivePrevention,
  'Patlayıcı ortamlar — Tehlikeli bölgelerin sınıflandırılması (gaz).' => l10n.stdDescEn6007910ZoneClassification,
  'İşlevsel güvenlik — Proses endüstrisi güvenlik enstrüman sistemleri.' => l10n.stdDescIec61511FunctionalSafety,
  'Petrokimya tesislerinde pompalar — Yangın güvenliği gereksinimleri.' => l10n.stdDescApi610PetrochemPumps,
  'Yanıcı toz yangını ve patlamasına karşı koruma.' => l10n.stdDescNfpa654CombustibleDust,
  'Patlama basıncı tahliyesi standardı.' => l10n.stdDescNfpa68ExplosionVenting,
  'Patlama önleme sistemleri standardı.' => l10n.stdDescNfpa69ExplosionPrevention,
      _ => aciklama,
    };

// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
// SPRİNKLER SİSTEMİ  ·  EN 12845 / TS EN 12845
// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦

/// EN 12845 Tehlike Sınıfı tanım verisi
class _SpSinif {
  final String kod;
  final String ad;
  final double yogunluk; // L/(min·m²) = mm/min
  final double tasarimAlani; // m²
  final double maxKapsama; // m²/sprinkler
  final double minBasinc; // bar — EN 12845 Tablo 1 minimum işletme basıncı
  final List<String> faaliyetler;

  final double kFactor; // K-faktör: LH/OH=80, HH=115 (EN 12845)
  final int
  sureDk; // Min. su besleme süresi: LH=30, OH=60, HH=90 (EN 12845 Tablo 2)
  // ─── Çizelge 19 — Yan duvar dışındaki püskürtme grupları ───────────────────
  final double maxMesafe; // S ve D: maks. S ve D mesafesi (m)
  // ─── Çizelge 20 — Yan duvar püskürtme grupları (null = bu sınıf için yok) ──
  final double? yanKapsama; // yan duvar maks. kapsama (m²)
  final double? yanAralik; // gruplar arası maks. mesafe (m)
  final double? yanSonMesafe; // duvar sonuna kadar maks. mesafe (m)

  const _SpSinif({
    required this.kod,
    required this.ad,
    required this.yogunluk,
    required this.tasarimAlani,
    required this.maxKapsama,
    this.minBasinc = 0.50, // HHP varsayılanı (EN 12845 Tablo 1)
    this.kFactor = 80.0, // LH/OH varsayılanı
    this.sureDk = 60, // OH varsayılanı
    this.maxMesafe = 3.7, // HHP/HHS varsayılanı — en kısıtlayıcı (Çizelge 19)
    this.yanKapsama,
    this.yanAralik,
    this.yanSonMesafe,
    required this.faaliyetler,
  });

  double get gridAralik => math.sqrt(maxKapsama);
}

/// EN 12845:2015 Tablo 1 – Tasarım parametreleri
/// EN 12845:2015 Ek A (Bilgilendirici) — Kullanım sınıflandırması
const List<_SpSinif> _spSiniflar = [
  _SpSinif(
    kod: 'LH',
    ad: 'Düşük Tehlike (LH)',
    yogunluk: 2.25,
    tasarimAlani: 84,
    maxKapsama: 21,
    minBasinc: 0.70, // EN 12845 Tablo 1 — LH minimum 0,70 bar
    sureDk: 30, // EN 12845 Tablo 2 — LH su besleme süresi 30 dk
    faaliyetler: [
      // EN 12845:2015 Ek A — LH
      'Ofisler ve yönetim binaları',
      'Oteller, misafirhaneler, pansiyonlar',
      'Hastaneler, klinikler, sağlık merkezleri',
      'Okullar, üniversiteler ve eğitim binaları',
      'Konutlar ve apartmanlar',
      'Cezaevleri ve ıslahevleri',
      'Kiliseler, camiler ve ibadethaneler',
      'Tiyatrolar / sinema (yalnızca seyirci oturma alanları)',
      'Müzeler ve sanat galerileri',
    ],
  ),
  _SpSinif(
    kod: 'OH1',
    ad: 'Orta Tehlike Grup 1 (OH1)',
    yogunluk: 5.0,
    tasarimAlani: 72,
    maxKapsama: 12,
    minBasinc: 0.35, // EN 12845 Tablo 1 — OH minimum 0,35 bar
    maxMesafe: 4.0, // Çizelge 19 — OH maks. S ve D = 4,0 m
    yanKapsama: 9.0,
    yanAralik: 3.4,
    yanSonMesafe: 1.8, // Çizelge 20 — OH yan duvar
    faaliyetler: [
      // EN 12845:2015 Ek A — OH Grup 1
      'Bira fabrikaları (damıtma tesisleri hariç)',
      'Çok katlı ve bodrum katlı kapalı otoparklar',
      'Seramik ürünleri üretimi',
      'Cam ve cam eşya üretimi (cam elyafı hariç)',
      'Kimya araştırma laboratuvarları',
      'Süt ve süt ürünleri işleme tesisleri (mandıralar)',
      'Elektronik ekipman montaj atölyeleri',
      'Gıda işleme ve paketleme tesisleri',
      'Oteller — mutfak, çamaşırhane ve servis alanları',
      'Kurumsal ve ticari çamaşırhaneler',
      'Deri ve deri ürünleri üretimi',
      'Hafif metal işleme atölyeleri',
      'Farmasötik (ilaç) üretim tesisleri',
      'Araştırma laboratuvarları (yanmaz sıvı kullanımı)',
      'Tekstil dokuma — pamuk/yün/doğal elyaf (terbiye işlemsiz)',
      'Tütün işleme ve paketleme',
    ],
  ),
  _SpSinif(
    kod: 'OH2',
    ad: 'Orta Tehlike Grup 2 (OH2)',
    yogunluk: 5.0,
    tasarimAlani: 144,
    maxKapsama: 12,
    minBasinc: 0.35,
    maxMesafe: 4.0,
    yanKapsama: 9.0,
    yanAralik: 3.4,
    yanSonMesafe: 1.8,
    faaliyetler: [
      // EN 12845:2015 Ek A — OH Grup 2
      'Tarım ve iş makinesi montaj tesisleri',
      'Tahıl, un değirmeni ve benzeri gıda işleme',
      'Kimyasal üretim (yalnızca yanmaz sıvılı ürünler)',
      'Büyük mağazalar ve alışveriş merkezleri (tek katlı)',
      'Elektrikli ekipman üretim fabrikaları',
      'Bilgisayar ve elektronik veri işleme odaları',
      'Genel mühendislik atölyeleri ve fabrikalar',
      'Meyve, sebze ve konserve işleme tesisleri',
      'Araç bakım-onarım garajları',
      'Cam elyafı (fiberglas) üretimi ve montajı',
      'Hırdavat ve demir-çelik ürünleri mağazaları',
      'Hastaneler — tedavi ve ameliyat alanları',
      'Örme (triko/hosiery) fabrikaları',
      'Kütüphaneler — genel açık raf alanları',
      'Genel metal işleme fabrikaları',
      'Kâğıt ve karton üretim tesisleri',
      'Plastik ürün imalatı (yalnızca yanmaz plastikler)',
      'Genel baskı / matbaa (su bazlı mürekkep)',
      'Süpermarketler ve hipermarketler',
      'Terzilik, konfeksiyon ve giyim üretimi',
      'Tekstil eğirme ve dokuma (sentetik elyaf)',
      'Yükleme-boşaltma, sevkiyat/nakliye rampaları',
      'Genel depolama (istiflenmiş yükseklik ≤ 4 m)',
    ],
  ),
  _SpSinif(
    kod: 'OH3',
    ad: 'Orta Tehlike Grup 3 (OH3)',
    yogunluk: 5.0,
    tasarimAlani: 216,
    maxKapsama: 12,
    minBasinc: 0.35,
    maxMesafe: 4.0,
    yanKapsama: 9.0,
    yanAralik: 3.4,
    yanSonMesafe: 1.8,
    faaliyetler: [
      // EN 12845:2015 Ek A — OH Grup 3
      'Uçak hangarları — bakım ve onarım alanları',
      'Muşamba, branda, çadır bezi ve branda üretimi',
      'Kimyasal üretim (parlama noktası > 55 °C ürünler)',
      'Soğuk hava depoları',
      'Film ve televizyon stüdyoları (üretim alanı)',
      'Mobilya ve döşeme üretimi (sünger, kumaş)',
      'Marangoz / doğrama — ahşap işleme atölyeleri',
      'Kibrit üretim tesisleri',
      'Büyük kâğıt arşiv alanları olan ofisler',
      'Su bazlı boya ve vernik üretimi',
      'Kâğıt, karton ve oluklu mukavva kutu işleme/üretimi',
      'Termoplastik plastik imalat ve şekillendirme',
      'Yüksek hızlı ofset baskı (petrol bazlı mürekkep)',
      'Kauçuk ürünleri üretim tesisleri',
      'Tekstil boyama ve terbiye işleme tesisleri',
      'Genel depolama (istiflenmiş yükseklik > 4 m – 8 m)',
    ],
  ),
  _SpSinif(
    kod: 'OH4',
    ad: 'Orta Tehlike Grup 4 (OH4)',
    yogunluk: 5.0,
    tasarimAlani: 360,
    maxKapsama: 12,
    minBasinc: 0.35,
    maxMesafe: 4.0,
    yanKapsama: 9.0,
    yanAralik: 3.4,
    yanSonMesafe: 1.8,
    faaliyetler: [
      // EN 12845:2015 Ek A — OH Grup 4 (yanıcı sıvı İÇERMEYEN kimyasal/sanayi prosesleri)
      'Kimyasal üretim (kapalı proses, parlama noktası > 55 °C)',
      'Plastik ve kauçuk parça üretimi (kapalı ekstrüzyon/kalıplama)',
      'Tekstil boyama ve terbiye tesisleri (su bazlı)',
      'Eczane, kozmetik ve deterjan üretim tesisleri',
      'Gıda ve içecek üretim tesisleri (yüksek hacimli)',
      'Kağıt üretim ve işleme tesisleri (kuru kesi/tasnif)',
      'Su bazlı boya, vernik veya UV-kürleme boyasi kullanan boyahaneler',
      'Metal işleme ve makine üretim tesisleri (yoğun talaş, yağ buharı)',
    ],
  ),
  _SpSinif(
    kod: 'HHP1',
    ad: 'Yüksek Tehlike Püskürtme Grup 1 (HHP1)',
    yogunluk: 7.5, // EN 12845 Çizelge 3 — HHP1 · 7,5 mm/min
    tasarimAlani: 260, // sulu/ön etki 260 m²
    maxKapsama: 9,
    minBasinc: 0.50,
    kFactor: 115, // EN 12845 — HHP sınıfları K=115 minimum
    sureDk: 90, // EN 12845 Tablo 2 — HHP su besleme süresi 90 dk
    faaliyetler: [
      // EN 12845:2015 Çizelge 3 — HHP1 · 7,5 mm/min · 260 m²
      'Parlama noktası ≥ 55 °C yanıcı sıvı işleme/depolama prosesleri',
      'Köpük kauçuk ve köpük plastik (PU, EPS/XPS) üretim tesisleri',
      'Metal ve plastik parçalar için akış kaplama (flow coating)',
      'Yanıcı mürekkep / solvent kullanan endüstriyel baskı tesisleri',
      'Aerosol ve sprey ürünleri paketleme/dolum tesisleri',
    ],
  ),
  _SpSinif(
    kod: 'HHP2',
    ad: 'Yüksek Tehlike Püskürtme Grup 2 (HHP2)',
    yogunluk: 10.0, // EN 12845 Çizelge 3 — HHP2 · 10,0 mm/min · 260 m²
    tasarimAlani: 260,
    maxKapsama: 9,
    minBasinc: 0.50,
    kFactor: 115,
    sureDk: 90,
    faaliyetler: [
      // EN 12845:2015 Çizelge 3 — HHP2 · 10,0 mm/min · 260 m²
      'Parlama noktası < 55 °C yanıcı sıvı işleme prosesleri (açık kap)',
      'Kimyasal üretim (parlama noktası ≥ 55 °C yanıcı sıvı içeren ürünler)',
      'Solvent bazlı boya ve vernik üretim tesisleri',
      'Sprey boyahane — yanıcı solvent bazlı boya uygulaması',
      'Kuru temizleme tesisleri (perkloretilen / solvent bazlı)',
      'Solvent ekstraksiyon tesisleri',
      'Yanıcı mürekkep kullanan baskı / gravür tesisleri',
      'Yanıcı sıvı ile sprey kaplama / boyama kabinleri',
      'Kauçuk mastik ve yanıcı hammadde işleme tesisleri',
      'Boya, mürekkep veya vernik ambalajlama ve dolum tesisleri',
    ],
  ),
  _SpSinif(
    kod: 'HHP3',
    ad: 'Yüksek Tehlike Püskürtme Grup 3 (HHP3)',
    yogunluk: 12.5, // EN 12845 Çizelge 3 — HHP3 · 12,5 mm/min · 260 m²
    tasarimAlani: 260, // Çizelge 3: sulu/ön etki 260 m² (önceki 300 hatalıydı)
    maxKapsama: 9,
    minBasinc: 0.50,
    kFactor: 115,
    sureDk: 90,
    faaliyetler: [
      // EN 12845:2015 Çizelge 3 — HHP3 · 12,5 mm/min · 260 m²
      'Yüksek raflı palet depolama — katı malzeme, istif yüksekliği > 4 m',
      'Araç lastikleri ve kauçuk ürün depolaması',
      'Rulo kâğıt ve kâğıt topu depolaması',
      'Katı plastik hammadde ve ürün depolaması (paletli/raflı)',
      'Balya pamuk, tekstil hammaddesi ve sentetik elyaf depolaması',
    ],
  ),
  _SpSinif(
    // NOT: HHP4 — Yoğun su sistemi. Bu standart kapsamı dışındadır.
    // EN 12845 Çizelge 3 Not: Özel değerlendirme gerekir.
    // Aşağıdaki değerler yalnızca ön fikir amaçlıdır; tasarım onayı zorunludur.
    kod: 'HHP4',
    ad: 'Yüksek Tehlike Püskürtme Grup 4 (HHP4) — ⚠ Yoğun Su / Özel Sistem',
    yogunluk: 15.0, // Çizelge 3: "Yoğun su (Nota bakınız)" — standart dışı
    tasarimAlani:
        260, // referans değer; gerçek tasarım tam hidrolik hesap gerektirir
    maxKapsama: 9,
    minBasinc: 0.50,
    kFactor: 115,
    sureDk: 90,
    faaliyetler: [
      // EN 12845 Çizelge 3 Not — HHP4: Yoğun su sistemleri bu standardın kapsamı dışındadır.
      // Özel değerlendirme ve yetkili mühendis onayı zorunludur.
      'Yüksek raflı palet depolama — yanıcı sıvı içeren ürünler, > 4 m  ⚠ Yoğun su sistemi',
      'Aerosol ürün depoları (yanıcı itici gazlı, yüksek raf)  ⚠ Özel sistem gerektirir',
      'Yanıcı sıvı ambalajlı ürün depolaması (boya, solvent, vernik)  ⚠ Özel sistem',
      'Islanmaya dayanıksız veya yüksek ısıl değerli ürünlerin yoğun depolanması',
    ],
  ),

  // ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
  // DEPOLAMA KATEGORİLERİ  ·  EN 12845:2015 Ek A — Serbest Döşeme Depolama
  // ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
  _SpSinif(
    kod: 'SF1',
    ad: 'Depolama Kat. I — Serbest Döşeme (≤ 3 m)',
    yogunluk: 3.75,
    tasarimAlani: 72,
    maxKapsama: 12,
    minBasinc: 0.35,
    kFactor: 80,
    sureDk: 60,
    maxMesafe: 4.0, // OH kuralları (Çizelge 19)
    yanKapsama: 9.0,
    yanAralik: 3.4,
    yanSonMesafe: 1.8, // Çizelge 20
    faaliyetler: [
      // EN 12845:2015 Ek A — Depolama Kategorisi I, serbest döşeme, istif ≤ 3 m
      'Yanmaz ürün depolama — metal, cam, seramik, beton ürünler',
      'Dondurulmuş gıda ve soğuk zincir ürün depolama',
      'Kapalı metal kutu / bidon içindeki yanmaz ürünler',
      'Islak gıda (taze meyve-sebze, konserve) depoları',
      'Porselen ve sıhhi tesisat ürünleri depolama',
      'Boş cam şişe / boş metal kutu depolama',
    ],
  ),
  _SpSinif(
    kod: 'SF2',
    ad: 'Depolama Kat. II — Serbest Döşeme (≤ 3,5 m)',
    yogunluk: 5.0,
    tasarimAlani: 144,
    maxKapsama: 12,
    minBasinc: 0.35,
    kFactor: 80,
    sureDk: 60,
    maxMesafe: 4.0,
    yanKapsama: 9.0,
    yanAralik: 3.4,
    yanSonMesafe: 1.8,
    faaliyetler: [
      // EN 12845:2015 Ek A — Depolama Kategorisi II, serbest döşeme, istif ≤ 3,5 m
      'Karton ambalajlı yanmaz ürün depolama',
      'Tahta kutu / kasalarda yanmaz mal depolama',
      'Cam şişe / plastik kaplar içinde yanmaz sıvı depolama',
      'Küçük oranda yanabilir içerikli karışık ürün depolama',
      'Boya bezlerinde cam ve seramik ürün depolama',
    ],
  ),
  _SpSinif(
    kod: 'SF3',
    ad: 'Depolama Kat. III — Serbest Döşeme (≤ 3,5 m)',
    yogunluk: 5.0,
    tasarimAlani: 216,
    maxKapsama: 12,
    minBasinc: 0.35,
    kFactor: 80,
    sureDk: 60,
    maxMesafe: 4.0,
    yanKapsama: 9.0,
    yanAralik: 3.4,
    yanSonMesafe: 1.8,
    faaliyetler: [
      // EN 12845:2015 Ek A — Depolama Kategorisi III, serbest döşeme, istif ≤ 3,5 m
      'Kâğıt, karton ve oluklu mukavva ürün depolama',
      'Tekstil, iplik, kumaş ve hazır giyim depolama',
      'Ahşap ve ahşap esaslı ürün depolama',
      'Mobilya ve döşeme malzemeleri depolama',
      'Karışık ambalajlı mallar (kağıt + plastik kombine)',
      'Kuru gıda ve tarım ürünleri (dökme olmayan) depolama',
      'Deri ve deri ürünleri depolama',
      'Küçük elektrikli ev aletleri (ambalajlı) depolama',
    ],
  ),
  _SpSinif(
    kod: 'SF4',
    ad: 'Depolama Kat. IV — Serbest Döşeme (≤ 3,5 m)',
    yogunluk: 7.5,
    tasarimAlani: 260,
    maxKapsama: 9,
    minBasinc: 0.50,
    kFactor: 80,
    sureDk: 90,
    faaliyetler: [
      // EN 12845:2015 Ek A — Depolama Kategorisi IV, serbest döşeme, istif ≤ 3,5 m
      'Ekspande plastik (EPS, PU, XPS) ürün depolama (döşeme)',
      'Kauçuk ve lastik ürün depolama (döşeme)',
      'Yanıcı sıvı içeren plastik kaplar depolama (döşeme)',
      'Aerosol ürün depolama — döşeme, ≤ 3,5 m',
      'Polistiren köpük ambalajlı ürün depolama',
      'Yüksek kalorili yanabilir mal depolama (döşeme)',
    ],
  ),

  // ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
  // DEPOLAMA KATEGORİLERİ  ·  EN 12845:2015 Ek A — Raf / Palet Depolama
  // ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
  _SpSinif(
    kod: 'RS1',
    ad: 'Depolama Kat. I — Raf / Palet Depolama',
    yogunluk: 7.5,
    tasarimAlani: 260,
    maxKapsama: 9,
    minBasinc: 0.50,
    kFactor: 115,
    sureDk: 90,
    faaliyetler: [
      // EN 12845:2015 Ek A — Depolama Kategorisi I, raf / palet, yükseklik > 3 m
      'Raf / palet sistemi — Kategori I mallar (metal, cam, seramik)',
      'Yüksek raflı depo — yanmaz ürünler, istif > 3 m',
      'Palet üzeri kapalı metal / cam ürün depolama',
      'Soğuk hava deposu yüksek raf sistemi',
    ],
  ),
  _SpSinif(
    kod: 'RS2',
    ad: 'Depolama Kat. II — Raf / Palet Depolama',
    yogunluk: 10.0,
    tasarimAlani: 260,
    maxKapsama: 9,
    minBasinc: 0.50,
    kFactor: 115,
    sureDk: 90,
    faaliyetler: [
      // EN 12845:2015 Ek A — Depolama Kategorisi II, raf / palet, yükseklik > 3 m
      'Raf / palet sistemi — Kategori II mallar (karton ambalajlı)',
      'Yüksek raflı depo — karton kutu içinde yanmaz ürünler',
      'Palet üzeri karton ambalajlı ürün depolama, > 3 m',
      'Tahta kasalarda depolama, yüksek raf sistemi',
    ],
  ),
  _SpSinif(
    kod: 'RS3',
    ad: 'Depolama Kat. III — Raf / Palet Depolama',
    yogunluk: 12.5,
    tasarimAlani: 300,
    maxKapsama: 9,
    minBasinc: 0.50,
    kFactor: 115,
    sureDk: 90,
    faaliyetler: [
      // EN 12845:2015 Ek A — Depolama Kategorisi III, raf / palet, yükseklik > 3 m
      'Raf / palet sistemi — Kategori III mallar (kâğıt, tekstil, ahşap)',
      'Yüksek raflı depo — mobilya, ahşap ürünler',
      'Balya (pamuk, tekstil) raf depolama, > 3 m',
      'Rulo kâğıt ve kâğıt topu raf depolama, > 3 m',
      'Karışık ambalajlı (kağıt + plastik) yüksek raf depolama',
    ],
  ),
  _SpSinif(
    kod: 'RS4',
    ad: 'Depolama Kat. IV — Raf / Palet Depolama',
    yogunluk: 15.0,
    tasarimAlani: 300,
    maxKapsama: 9,
    minBasinc: 0.50,
    kFactor: 115,
    sureDk: 90,
    faaliyetler: [
      // EN 12845:2015 Ek A — Depolama Kategorisi IV, raf / palet, yükseklik > 3 m
      'Raf / palet sistemi — Kategori IV mallar (plastik, kauçuk, köpük)',
      'Ekspande plastik ve köpük ürün yüksek raf depolama',
      'Aerosol ürün raf depolama — yanıcı itici gazlı, > 3 m',
      'Katı plastik hammadde ve ürün yüksek raf depolama',
      'Yanıcı ambalajlı ürün yüksek raf depolama (boya, vernik, solvent)',
      'Kauçuk ve lastik ürün yüksek raf depolama, > 3 m',
    ],
  ),
];

// ¦¦ Standart boru iç çap tablosu (DN › ID mm, karbon çeliği Sch.40)
const List<(int, double)> _spBorular = [
  (25, 26.6),
  (32, 35.1),
  (40, 40.9),
  (50, 52.5),
  (65, 62.7),
  (80, 77.9),
  (90, 90.1),
  (100, 102.3),
  (125, 128.2),
  (150, 154.1),
  (200, 202.7),
];

/// EN 12845:2015 Tablo 14 — Ağaç sistemi boru çapı secimi (schedule/tarifeli boyutlandırma)
/// LH ve OH sınıfları için maksimum sprinkler sayısına göre DN seçilir.
/// HH sınıflarında standart tam hidrolik hesap gerektirir;
/// bu fonksiyon HH için hız ? 5 m/s olarak ön hesap yapar.
///
/// Tablo 14 — Çelik boru, ağaç sistemler (DN ? NPS inç karşılığı):
/// DN (NPS)   | LH (max)              | OH (max)
///  25 (1")   |     2                 |    2
///  32 (1¼")  |     3                 |    3
///  40 (1½")  |     5                 |    5
///  50 (2")   |    10                 |   10
///  65 (2½")  |    30                 |   20
///  80 (3")   |    60                 |   40
///  90 (3½")  |   100                 |   65
/// 100 (4")   |  alan sınırlaması     |  100
/// 125 (5")   |  gereksiz (LH için)   |  160
/// 150 (6")   |  gereksiz (LH için)   |  275
/// 200 (8")   |  gereksiz (LH için)   |  alan sınırlaması
const _spTablo14LH = [
  (25, 2),
  (32, 3),
  (40, 5),
  (50, 10),
  (65, 30),
  (80, 60),
  (90, 100),
];
const _spTablo14OH = [
  (25, 2),
  (32, 3),
  (40, 5),
  (50, 10),
  (65, 20),
  (80, 40),
  (90, 65),
  (100, 100),
  (125, 160),
  (150, 275),
];

int _spSecBoruEN12845(int nSprinkler, String sinifKod) {
  final isLH = sinifKod == 'LH';
  final isOH = sinifKod.startsWith('OH');
  if (isLH || isOH) {
    final tablo = isLH ? _spTablo14LH : _spTablo14OH;
    for (final (dn, maxN) in tablo) {
      if (nSprinkler <= maxN) return dn;
    }
    // Tablo sınırının ötesinde: sabit sayı değil, koruma alanı sınırlaması geçerlidir
    return isLH ? 100 : 200;
  }
  // HH: hız ? 5 m/s ön hesap yöntemi
  for (final (dn, id) in _spBorular) {
    final r = id / 1000.0 / 2.0;
    final q = nSprinkler * 80.0 * 1.0; // yaklaşık miktar L/min
    final v = (q / 60.0 / 1000.0) / (math.pi * r * r);
    if (v <= 5.0) return dn;
  }
  return 200;
}

/// Hız bazlı yardımcı (HH ve ?P hesabı için iç kullanım)
int _spSecBoruHiz(double qLpm, {double vMax = 5.0}) {
  for (final (dn, id) in _spBorular) {
    final r = id / 1000.0 / 2.0;
    final v = (qLpm / 60.0 / 1000.0) / (math.pi * r * r);
    if (v <= vMax) return dn;
  }
  return 200;
}

/// Hazen–Williams sürtünme kaybı (bar)
/// ?P/m (bar/m) = 6.05×105 × Q^1.85 / (C^1.85 × d^4.87)
/// Q: L/min  d: mm  C: boru malzemesine göre (varsayılan 120 — galvanizli çelik)
double _spHW(double qLpm, int dn, double uzunlukM, {double c = 120.0}) {
  if (qLpm <= 0 || uzunlukM <= 0) return 0;
  final id = _spBorular.firstWhere((b) => b.$1 == dn).$2;
  final dpPerM =
      (6.05e5 * math.pow(qLpm, 1.85)) /
      (math.pow(c, 1.85) * math.pow(id, 4.87));
  return (dpPerM * uzunlukM).toDouble();
}

/// TS EN 12845:2015+A1 Tablo 19 — Sprinkler başına maksimum kapsama alanı (m²)
/// Tablo 19, tavan yüksekliğine göre düzeltme içermez; sabit üst sınır geçerlidir.
/// Yüksek tavanlarda (> 6 m LH/OH, > 6 m HH) uyarı gösterilir ancak alan değişmez.
/// Not: HHS depolarda aşırı boşluk (> 4 m) için §7.2.2.3 yoğunluk artırımı uygulanır.
double _spMaxKapsamaYuks(double yuks, String sinifKod) {
  if (sinifKod == 'LH') return 21.0;
  if (sinifKod.startsWith('OH')) return 12.0;
  return 9.0; // HHP / HHS
}

/// Tavan yüksekliğine göre bilgi / uyarı metni (yoksa null)
/// TS EN 12845:2015+A1 Tablo 19 alan değerlerini değiştirmez;
/// ancak yüksek tavanlarda standart sprinkler performansı yetesiz olabilir.
String? _spYuksUyari(AppLocalizations l10n, double yuks, String sinifKod) {
  if (sinifKod == 'LH' && yuks > 6.0) {
    return l10n.spCeilingWarningLH;
  }
  if (sinifKod.startsWith('OH') && yuks > 6.0) {
    return l10n.spCeilingWarningOH;
  }
  if (sinifKod.startsWith('HH') && yuks > 6.0) {
    return l10n.spCeilingWarningHH;
  }
  return null;
}

/// TS EN 12845+A1 Tablo 6 — Islak ön-hesaplı LH/OH sistemleri minimum debi (L/min)
/// §7.3.1 + §10.7.1: Pompa ve su deposu boyutlandırması için bağlayıcı alt sınır.
/// HH sınıfları tam hidrolik hesap gerektirir; bu fonksiyon 0.0 döndürür.
double _spT6MinDebi(String kod) => switch (kod) {
  'LH' => 225.0,
  'OH1' => 375.0,
  'OH2' => 725.0,
  'OH3' => 1100.0,
  'OH4' => 1800.0,
  _ => 0.0,
};

/// TS EN 12845+A1 Tablo 6 — Islak ön-hesaplı LH/OH sistemleri kontrol vanası
/// girişinde minimum basınç (bar) · ps statik yük hariçtir.
/// §8.2: Sistemde herhangi bir noktadaki maksimum işletme basıncı 12 bar'ı geçemez.
double _spT6MinBasinc(String kod) => switch (kod) {
  'LH' => 2.2,
  'OH1' => 1.0,
  'OH2' => 1.4,
  'OH3' => 1.7,
  'OH4' => 2.0,
  _ => 0.0,
};

// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
// BORU MALZEMESİ  ·  Hazen-Williams C katsayısı (üretici/malzeme tablosu)
// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦

/// (ad, Hazen-Williams C katsayısı) — EN 12845 §13.3 varsayılanı C=120 (galvanizli çelik)
const List<(String, double)> _spBoruMalzemeleri = [
  ('Galvanizli Çelik (Sch.40)', 120.0),
  ('Siyah Karbon Çelik — kaynaklı', 100.0),
  ('Bakır Boru', 140.0),
  ('Paslanmaz Çelik', 140.0),
  ('CPVC Plastik Boru', 150.0),
];

String _spBoruAdiL10n(AppLocalizations l10n, String adTr) => switch (adTr) {
  'Galvanizli Çelik (Sch.40)' => l10n.spPipeGalvanizedSteel,
  'Siyah Karbon Çelik — kaynaklı' => l10n.spPipeBlackCarbonSteelWelded,
  'Bakır Boru' => l10n.spPipeCopper,
  'Paslanmaz Çelik' => l10n.spPipeStainlessSteel,
  'CPVC Plastik Boru' => l10n.spPipeCpvcPlastic,
  _ => adTr,
};

// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
// SPRİNKLER TİPİ  ·  K-Faktör seçenekleri (EN 12845 + üretici onaylı özel tipler)
// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦

class _SpSprinklerTipi {
  final String ad;
  final double? kFactor; // null → sınıfa göre otomatik (LH/OH=80, HH=115)
  final String aciklama;
  const _SpSprinklerTipi({
    required this.ad,
    this.kFactor,
    required this.aciklama,
  });
}

const List<_SpSprinklerTipi> _spSprinklerTipleri = [
  _SpSprinklerTipi(
    ad: 'Sınıfa Göre Otomatik',
    aciklama: 'Standart K80 (LH/OH) veya K115 (HH) — varsayılan',
  ),
  _SpSprinklerTipi(
    ad: 'Standart K57',
    kFactor: 57.0,
    aciklama: 'Yalnızca özel onaylı düşük debili uygulamalarda',
  ),
  _SpSprinklerTipi(
    ad: 'Standart K80',
    kFactor: 80.0,
    aciklama: 'LH/OH sınıfları için standart',
  ),
  _SpSprinklerTipi(
    ad: 'Yüksek Debili K115',
    kFactor: 115.0,
    aciklama: 'HH sınıfları için standart',
  ),
  _SpSprinklerTipi(
    ad: 'Büyük Damla K161',
    kFactor: 161.0,
    aciklama: 'Yüksek depolama / raf sistemleri — üretici onayı gerekir',
  ),
  _SpSprinklerTipi(
    ad: 'Ekstra Büyük Damla K200',
    kFactor: 200.0,
    aciklama: 'Özel yüksek debili uygulamalar — üretici onayı gerekir',
  ),
  _SpSprinklerTipi(
    ad: 'ESFR K242 (bilgi amaçlı)',
    kFactor: 242.0,
    aciklama:
        'Erken bastırma hızlı tepki — EN 12845 kapsamı dışıdır; NFPA 13 / listeleme verisi esas alınmalıdır',
  ),
];

// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
// KURULUM SINIFI  ·  Su kaynağı / pompa yedekliliği (EN 12845 Böl. 6 ilkeleri)
// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦

class _SpKurulumSinifi {
  final String ad;
  final String aciklama;
  final int pompaSayisi; // jokey pompa hariç
  final bool dizelGerekli;
  final bool ciftKaynak;
  const _SpKurulumSinifi({
    required this.ad,
    required this.aciklama,
    required this.pompaSayisi,
    required this.dizelGerekli,
    required this.ciftKaynak,
  });
}

const List<_SpKurulumSinifi> _spKurulumSiniflari = [
  _SpKurulumSinifi(
    ad: 'Tekli Kaynak + Tek Pompa',
    aciklama:
        'Yedekliliği yoktur — yalnızca LH ve düşük riskli, tek kaynaklı '
        'tesislerde kabul edilebilir.',
    pompaSayisi: 1,
    dizelGerekli: false,
    ciftKaynak: false,
  ),
  _SpKurulumSinifi(
    ad: 'Çiftli Pompa (Elektrik + Dizel)',
    aciklama:
        'OH ve çoğu HH tesisinde yaygın çözüm — elektrik kesintisinde '
        'dizel pompa otomatik devreye girer.',
    pompaSayisi: 2,
    dizelGerekli: true,
    ciftKaynak: false,
  ),
  _SpKurulumSinifi(
    ad: 'Çiftli Kaynak + Çiftli Pompa (Superior)',
    aciklama:
        'En yüksek güvenilirlik — kritik tesisler, HH sınıfları ve yüksek '
        'riskli depolarda önerilir; iki bağımsız su kaynağı ve pompa seti.',
    pompaSayisi: 2,
    dizelGerekli: true,
    ciftKaynak: true,
  ),
];

/// Boru şebekesi iç hacmi (L) — dry-pipe hava hacmi / priming suyu tahmini için.
double _spBoruHacmiL(int dn, double uzunlukM) {
  final id = _spBorular.firstWhere((b) => b.$1 == dn).$2; // mm
  final rM = id / 1000.0 / 2.0;
  return math.pi * rM * rM * uzunlukM * 1000.0; // L
}

// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
// KÖPÜK SİSTEMİ  ·  EN 13565-2 / TS EN 13565-2
// ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦

/// EN 13565-2 Tablo 1 — Köpük konsantresi tipi ve uygulama hızları
class _KopukTip {
  final String kod, ad;
  final double konsOrani; // % konsantrasyon (3 veya 6)
  final double hizHC; // L/(min·m²) — hidrokarbon (B1)
  final double? hizPS; // L/(min·m²) — polar solvent (B2) (null = uygulanamaz)
  const _KopukTip({
    required this.kod,
    required this.ad,
    required this.konsOrani,
    required this.hizHC,
    this.hizPS,
  });
}

const List<_KopukTip> _kopukTipleri = [
  _KopukTip(kod: 'AFFF3', ad: 'AFFF  %3', konsOrani: 3, hizHC: 4.1),
  _KopukTip(
    kod: 'ARAFFF3',
    ad: 'AR-AFFF  %3',
    konsOrani: 3,
    hizHC: 4.1,
    hizPS: 6.5,
  ),
  _KopukTip(kod: 'PR6', ad: 'Protein  %6', konsOrani: 6, hizHC: 5.0),
  _KopukTip(kod: 'FFFP3', ad: 'FFFP  %3', konsOrani: 3, hizHC: 4.1, hizPS: 6.5),
  _KopukTip(
    kod: 'MFFF6',
    ad: 'MF-FFF  %6',
    konsOrani: 6,
    hizHC: 5.0,
    hizPS: 7.5,
  ),
];

/// Köpük hesabı sonuç sınıfı
class _KopukSonuc {
  final _KopukTip tip;
  final String siviKat; // 'HC' = hidrokarbon | 'PS' = polar solvent
  final double alan; // m²
  final double sure; // dk
  final double uygulamaHizi; // L/(min·m²)
  final double cozeltDebi; // L/min (toplam çözelti = su + konsantre)
  final double konsDebi; // L/min (konsantre debi)
  final double suDebi; // L/min (su debi)
  final double konsTankHacmi; // L (minimum konsantre tankı)
  final double suTankHacmi; // L (minimum su rezervi)

  const _KopukSonuc({
    required this.tip,
    required this.siviKat,
    required this.alan,
    required this.sure,
    required this.uygulamaHizi,
    required this.cozeltDebi,
    required this.konsDebi,
    required this.suDebi,
    required this.konsTankHacmi,
    required this.suTankHacmi,
  });
}

// ¦¦ Sonuç veri sınıfı
/// Dal boru üzerinde tek bir sprinklerin hidrolik düğüm verisi.
/// En uzak sprinklerden (no=1) bağlantı noktasına doğru iteratif hesap.
class _SpHidrolikNode {
  final int no; // Sıra no (1 = en uzak)
  final String tip; // 'dal' | 'tali' | 'ana'
  final double mesafe; // Mesafe (m)
  final double p; // Basınç (bar)
  final double q; // Bu noktadan eklenen debi (L/min)
  final double cumQ; // Kümülatif debi (L/min)
  final double dpSonraki; // Sonraki düğüme boru kaybı (bar)
  final String? note; // Balanslama notu
  const _SpHidrolikNode({
    required this.no,
    required this.tip,
    required this.mesafe,
    required this.p,
    required this.q,
    required this.cumQ,
    required this.dpSonraki,
    this.note,
  });
}

class _SpSonuc {
  final double binaAlani, en, boy, yuks;
  final double
  maxKapsamaEfektif; // Tablo 19 maks. kapsama (yüksekliğe göre değişmez)
  final String? yuksUyari; // > standart limit uyarısı
  // ¦¦ Asma tavan
  final bool asmaTavan;
  final double asmaBosluk;
  final bool asmaSprinklerGerek; // boşluk > 0.8 m › ilave sprinkler
  final int nAsmaSpr; // gizli boşluk sprinkler sayısı
  final _SpSinif sinif;
  final double aralik;
  final int nX, nY, nToplam, nTasarim;
  final double gercekKapsama;
  final double qHead, pHead, qTasarim;
  final int dnBranch, dnCross, dnMain;
  final int nBranch, nCross, nMain; // boru başına düşen sprinkler sayısı
  final int nBranchPipes; // tasarım alanındaki dal boru sayısı
  final bool boruTabloHH; // true → HHP sınıfı, hız yöntemi kullanıldı
  final double qBranch, qCross, qMain;
  final double lBranch, lCross, lMain;
  // ¦¦ Boru metrajı
  final double mBranch, mCross, mMain, mMainEk, mToplam;
  final int nAlarmVana;
  final int maxVanaBasina; // max sprinkler/vana
  final double maxAlanPerVana; // max m²/vana
  final double dpBranch, dpCross, dpMain, dpToplam;
  final double pStatik, pompaDeb, pompaBasinc;
  // ¦¦ Su deposu
  final double
  suDepoHacmi; // L — TS EN 12845+A1 Tablo 2 besleme süresi × Q_efektif
  // ¦¦ TS EN 12845+A1 Tablo 6 kontrol bilgileri
  final bool
  tablo6ZorunluDebi; // true → Tablo 6 min. debi (qEfektif > qTasarim) uygulandı
  final bool
  tablo6ZorunluBasinc; // true → Tablo 6 min. basınç (kontrol vanası) uygulandı
  final bool maxBasincUyari; // true → pompaBasinc > 12 bar → §8.2 sınırı aşıldı
  // ¦¦ Dal boru sprinkler bazlı iteratif hidrolik (görsel tablo)
  final List<_SpHidrolikNode> kritikDevre;
  // ¦¦ Köpük sistemi (isteğe bağlı)
  final _KopukSonuc? kopuk;
  // ¦¦ Boru malzemesi
  final String boruMalzeme;
  final double boruC;
  // ¦¦ Sprinkler tipi / K-Faktör override
  final _SpSprinklerTipi sprinklerTipi;
  final double kFactorEfektif;
  final String? kFactorUyari;
  // ¦¦ Kurulum sınıfı / pompa yedekliliği
  final _SpKurulumSinifi kurulum;
  final double jokeyDebi; // L/min
  final double jokeyBasinc; // bar
  // ¦¦ Kuru borulu sistem
  final bool kuruBoru;
  final double? kuruBoruHacmi; // L — boru şebekesi iç hacmi
  // ¦¦ Basınç düşürücü vana / zon ayrımı
  final int zonSayisi;
  // ¦¦ Raf depolama (in-rack sprinkler) — ön tasarım
  final bool rafDepolama;
  final int? rafKatSayisi;
  final int? rafEkSprinkler;
  final double? rafEkDebi; // L/min

  const _SpSonuc({
    required this.binaAlani,
    required this.en,
    required this.boy,
    required this.yuks,
    required this.maxKapsamaEfektif,
    required this.yuksUyari,
    required this.asmaTavan,
    required this.asmaBosluk,
    required this.asmaSprinklerGerek,
    required this.nAsmaSpr,
    required this.sinif,
    required this.aralik,
    required this.nX,
    required this.nY,
    required this.nToplam,
    required this.gercekKapsama,
    required this.nTasarim,
    required this.qHead,
    required this.pHead,
    required this.qTasarim,
    required this.dnBranch,
    required this.dnCross,
    required this.dnMain,
    required this.nBranch,
    required this.nCross,
    required this.nMain,
    required this.nBranchPipes,
    required this.boruTabloHH,
    required this.qBranch,
    required this.qCross,
    required this.qMain,
    required this.lBranch,
    required this.lCross,
    required this.lMain,
    required this.mBranch,
    required this.mCross,
    required this.mMain,
    required this.mMainEk,
    required this.mToplam,
    required this.nAlarmVana,
    required this.maxVanaBasina,
    required this.maxAlanPerVana,
    required this.dpBranch,
    required this.dpCross,
    required this.dpMain,
    required this.dpToplam,
    required this.pStatik,
    required this.pompaDeb,
    required this.pompaBasinc,
    required this.suDepoHacmi,
    required this.tablo6ZorunluDebi,
    required this.tablo6ZorunluBasinc,
    required this.maxBasincUyari,
    required this.kritikDevre,
    this.kopuk,
    required this.boruMalzeme,
    required this.boruC,
    required this.sprinklerTipi,
    required this.kFactorEfektif,
    this.kFactorUyari,
    required this.kurulum,
    required this.jokeyDebi,
    required this.jokeyBasinc,
    required this.kuruBoru,
    this.kuruBoruHacmi,
    required this.zonSayisi,
    required this.rafDepolama,
    this.rafKatSayisi,
    this.rafEkSprinkler,
    this.rafEkDebi,
  });
}

/// Görüntüleme amaçlı yerelleştirilmiş tehlike sınıfı adı (iç anahtar: kod)
String _spSinifAdL10n(AppLocalizations l10n, String kod) => switch (kod) {
  'LH' => l10n.spSinifAdLH,
  'OH1' => l10n.spSinifAdOH1,
  'OH2' => l10n.spSinifAdOH2,
  'OH3' => l10n.spSinifAdOH3,
  'OH4' => l10n.spSinifAdOH4,
  'HHP1' => l10n.spSinifAdHHP1,
  'HHP2' => l10n.spSinifAdHHP2,
  'HHP3' => l10n.spSinifAdHHP3,
  'HHP4' => l10n.spSinifAdHHP4,
  'SF1' => l10n.spSinifAdSF1,
  'SF2' => l10n.spSinifAdSF2,
  'SF3' => l10n.spSinifAdSF3,
  'SF4' => l10n.spSinifAdSF4,
  'RS1' => l10n.spSinifAdRS1,
  'RS2' => l10n.spSinifAdRS2,
  'RS3' => l10n.spSinifAdRS3,
  'RS4' => l10n.spSinifAdRS4,
  _ => kod,
};

/// Görüntüleme amaçlı yerelleştirilmiş sprinkler tipi adı/açıklaması (iç anahtar: orijinal Türkçe ad)
String _spTipiAdL10n(AppLocalizations l10n, String adTr) => switch (adTr) {
  'Sınıfa Göre Otomatik' => l10n.spTipAdAuto,
  'Standart K57' => l10n.spTipAdK57,
  'Standart K80' => l10n.spTipAdK80,
  'Yüksek Debili K115' => l10n.spTipAdK115,
  'Büyük Damla K161' => l10n.spTipAdK161,
  'Ekstra Büyük Damla K200' => l10n.spTipAdK200,
  'ESFR K242 (bilgi amaçlı)' => l10n.spTipAdEsfr,
  _ => adTr,
};

String _spTipiAciklamaL10n(AppLocalizations l10n, String adTr) => switch (adTr) {
  'Sınıfa Göre Otomatik' => l10n.spTipDescAuto,
  'Standart K57' => l10n.spTipDescK57,
  'Standart K80' => l10n.spTipDescK80,
  'Yüksek Debili K115' => l10n.spTipDescK115,
  'Büyük Damla K161' => l10n.spTipDescK161,
  'Ekstra Büyük Damla K200' => l10n.spTipDescK200,
  'ESFR K242 (bilgi amaçlı)' => l10n.spTipDescEsfr,
  _ => adTr,
};

/// Görüntüleme amaçlı yerelleştirilmiş kurulum sınıfı adı/açıklaması (iç anahtar: orijinal Türkçe ad)
String _spKurulumAdL10n(AppLocalizations l10n, String adTr) => switch (adTr) {
  'Tekli Kaynak + Tek Pompa' => l10n.spKurulumAdSingle,
  'Çiftli Pompa (Elektrik + Dizel)' => l10n.spKurulumAdDual,
  'Çiftli Kaynak + Çiftli Pompa (Superior)' => l10n.spKurulumAdSuperior,
  _ => adTr,
};

String _spKurulumAciklamaL10n(AppLocalizations l10n, String adTr) => switch (adTr) {
  'Tekli Kaynak + Tek Pompa' => l10n.spKurulumDescSingle,
  'Çiftli Pompa (Elektrik + Dizel)' => l10n.spKurulumDescDual,
  'Çiftli Kaynak + Çiftli Pompa (Superior)' => l10n.spKurulumDescSuperior,
  _ => adTr,
};

/// Görüntüleme amaçlı yerelleştirilmiş sprinkler faaliyet açıklaması (iç anahtar: orijinal Türkçe faaliyet metni)
String _spFaaliyetL10n(AppLocalizations l10n, String faaliyet) => switch (faaliyet) {
  'Ofisler ve yönetim binaları' => l10n.spActOfficesAdmin,
  'Oteller, misafirhaneler, pansiyonlar' => l10n.spActHotelsHostelsGuesthouses,
  'Hastaneler, klinikler, sağlık merkezleri' => l10n.spActHospitalsClinics,
  'Okullar, üniversiteler ve eğitim binaları' => l10n.spActSchoolsUniversities,
  'Konutlar ve apartmanlar' => l10n.spActResidentialApartments,
  'Cezaevleri ve ıslahevleri' => l10n.spActPrisonsReformatories,
  'Kiliseler, camiler ve ibadethaneler' => l10n.spActChurchesMosquesWorship,
  'Tiyatrolar / sinema (yalnızca seyirci oturma alanları)' => l10n.spActTheatresCinemaSeating,
  'Müzeler ve sanat galerileri' => l10n.spActMuseumsGalleries,
  'Bira fabrikaları (damıtma tesisleri hariç)' => l10n.spActBreweriesExclDistilleries,
  'Çok katlı ve bodrum katlı kapalı otoparklar' => l10n.spActMultiStoreyBasementCarParks,
  'Seramik ürünleri üretimi' => l10n.spActCeramicsProduction,
  'Cam ve cam eşya üretimi (cam elyafı hariç)' => l10n.spActGlassGlasswareExclFibre,
  'Kimya araştırma laboratuvarları' => l10n.spActChemResearchLabs,
  'Süt ve süt ürünleri işleme tesisleri (mandıralar)' => l10n.spActDairyProcessing,
  'Elektronik ekipman montaj atölyeleri' => l10n.spActElectronicsAssembly,
  'Gıda işleme ve paketleme tesisleri' => l10n.spActFoodProcessingPackaging,
  'Oteller — mutfak, çamaşırhane ve servis alanları' => l10n.spActHotelsKitchenLaundryService,
  'Kurumsal ve ticari çamaşırhaneler' => l10n.spActInstitutionalCommercialLaundries,
  'Deri ve deri ürünleri üretimi' => l10n.spActLeatherProductsProduction,
  'Hafif metal işleme atölyeleri' => l10n.spActLightMetalworkingWorkshops,
  'Farmasötik (ilaç) üretim tesisleri' => l10n.spActPharmaceuticalProduction,
  'Araştırma laboratuvarları (yanmaz sıvı kullanımı)' => l10n.spActResearchLabsNonflamLiquids,
  'Tekstil dokuma — pamuk/yün/doğal elyaf (terbiye işlemsiz)' => l10n.spActTextileWeavingNaturalFibresUntreated,
  'Tütün işleme ve paketleme' => l10n.spActTobaccoProcessingPackaging,
  'Tarım ve iş makinesi montaj tesisleri' => l10n.spActAgriIndustrialMachineryAssembly,
  'Tahıl, un değirmeni ve benzeri gıda işleme' => l10n.spActGrainFlourMillFoodProcessing,
  'Kimyasal üretim (yalnızca yanmaz sıvılı ürünler)' => l10n.spActChemProductionNonflamLiquidsOnly,
  'Büyük mağazalar ve alışveriş merkezleri (tek katlı)' => l10n.spActDeptStoresShoppingCentresSingleStorey,
  'Elektrikli ekipman üretim fabrikaları' => l10n.spActElectricalEquipmentFactories,
  'Bilgisayar ve elektronik veri işleme odaları' => l10n.spActComputerDataProcessingRooms,
  'Genel mühendislik atölyeleri ve fabrikalar' => l10n.spActGeneralEngineeringWorkshopsFactories,
  'Meyve, sebze ve konserve işleme tesisleri' => l10n.spActFruitVegCanningFacilities,
  'Araç bakım-onarım garajları' => l10n.spActVehicleMaintenanceRepairGarages,
  'Cam elyafı (fiberglas) üretimi ve montajı' => l10n.spActFibreglassProductionAssembly,
  'Hırdavat ve demir-çelik ürünleri mağazaları' => l10n.spActHardwareIronmongeryStores,
  'Hastaneler — tedavi ve ameliyat alanları' => l10n.spActHospitalsTreatmentSurgeryAreas,
  'Örme (triko/hosiery) fabrikaları' => l10n.spActKnittingHosieryFactories,
  'Kütüphaneler — genel açık raf alanları' => l10n.spActLibrariesOpenShelfAreas,
  'Genel metal işleme fabrikaları' => l10n.spActGeneralMetalworkingFactories,
  'Kâğıt ve karton üretim tesisleri' => l10n.spActPaperBoardProductionFacilities,
  'Plastik ürün imalatı (yalnızca yanmaz plastikler)' => l10n.spActPlasticsManufNonflamOnly,
  'Genel baskı / matbaa (su bazlı mürekkep)' => l10n.spActGeneralPrintingWaterBasedInk,
  'Süpermarketler ve hipermarketler' => l10n.spActSupermarketsHypermarkets,
  'Terzilik, konfeksiyon ve giyim üretimi' => l10n.spActTailoringGarmentManufacture,
  'Tekstil eğirme ve dokuma (sentetik elyaf)' => l10n.spActTextileSpinningWeavingSynthetic,
  'Yükleme-boşaltma, sevkiyat/nakliye rampaları' => l10n.spActLoadingShippingDocks,
  'Genel depolama (istiflenmiş yükseklik ≤ 4 m)' => l10n.spActGeneralStorageUpTo4m,
  'Uçak hangarları — bakım ve onarım alanları' => l10n.spActAircraftHangarsMaintenance,
  'Muşamba, branda, çadır bezi ve branda üretimi' => l10n.spActOilclothTarpaulinCanvasProduction,
  'Kimyasal üretim (parlama noktası > 55 °C ürünler)' => l10n.spActChemProductionFpAbove55,
  'Soğuk hava depoları' => l10n.spActColdStores,
  'Film ve televizyon stüdyoları (üretim alanı)' => l10n.spActFilmTvStudiosProduction,
  'Mobilya ve döşeme üretimi (sünger, kumaş)' => l10n.spActFurnitureUpholsteryProduction,
  'Marangoz / doğrama — ahşap işleme atölyeleri' => l10n.spActJoineryWoodworkingWorkshops,
  'Kibrit üretim tesisleri' => l10n.spActMatchProductionFacilities,
  'Büyük kâğıt arşiv alanları olan ofisler' => l10n.spActOfficesLargePaperArchives,
  'Su bazlı boya ve vernik üretimi' => l10n.spActWaterBasedPaintVarnishProduction,
  'Kâğıt, karton ve oluklu mukavva kutu işleme/üretimi' => l10n.spActPaperCorrugatedBoxProduction,
  'Termoplastik plastik imalat ve şekillendirme' => l10n.spActThermoplasticsManufShaping,
  'Yüksek hızlı ofset baskı (petrol bazlı mürekkep)' => l10n.spActHighSpeedOffsetPrintingOilInk,
  'Kauçuk ürünleri üretim tesisleri' => l10n.spActRubberProductsProduction,
  'Tekstil boyama ve terbiye işleme tesisleri' => l10n.spActTextileDyeingFinishingFacilities,
  'Genel depolama (istiflenmiş yükseklik > 4 m – 8 m)' => l10n.spActGeneralStorage4to8m,
  'Kimyasal üretim (kapalı proses, parlama noktası > 55 °C)' => l10n.spActChemProductionClosedProcessFp55,
  'Plastik ve kauçuk parça üretimi (kapalı ekstrüzyon/kalıplama)' => l10n.spActPlasticRubberPartsClosedMoulding,
  'Tekstil boyama ve terbiye tesisleri (su bazlı)' => l10n.spActTextileDyeingFinishingWaterBased,
  'Eczane, kozmetik ve deterjan üretim tesisleri' => l10n.spActPharmacyCosmeticsDetergentProduction,
  'Gıda ve içecek üretim tesisleri (yüksek hacimli)' => l10n.spActFoodBeverageProductionHighVolume,
  'Kağıt üretim ve işleme tesisleri (kuru kesi/tasnif)' => l10n.spActPaperProductionDryCuttingSorting,
  'Su bazlı boya, vernik veya UV-kürleme boyasi kullanan boyahaneler' => l10n.spActPaintShopsWaterUvCuring,
  'Metal işleme ve makine üretim tesisleri (yoğun talaş, yağ buharı)' => l10n.spActMetalworkingMachineryHeavySwarfOilMist,
  'Parlama noktası ≥ 55 °C yanıcı sıvı işleme/depolama prosesleri' => l10n.spActFlammableLiquidProcessFp55Plus,
  'Köpük kauçuk ve köpük plastik (PU, EPS/XPS) üretim tesisleri' => l10n.spActFoamRubberFoamPlasticProduction,
  'Metal ve plastik parçalar için akış kaplama (flow coating)' => l10n.spActFlowCoatingMetalPlasticParts,
  'Yanıcı mürekkep / solvent kullanan endüstriyel baskı tesisleri' => l10n.spActIndustrialPrintingFlammableInkSolvent,
  'Aerosol ve sprey ürünleri paketleme/dolum tesisleri' => l10n.spActAerosolSprayPackagingFilling,
  'Parlama noktası < 55 °C yanıcı sıvı işleme prosesleri (açık kap)' => l10n.spActFlammableLiquidProcessFpBelow55Open,
  'Kimyasal üretim (parlama noktası ≥ 55 °C yanıcı sıvı içeren ürünler)' => l10n.spActChemProductionContainingFp55Liquids,
  'Solvent bazlı boya ve vernik üretim tesisleri' => l10n.spActSolventBasedPaintVarnishProduction,
  'Sprey boyahane — yanıcı solvent bazlı boya uygulaması' => l10n.spActSpraySolventPaintApplication,
  'Kuru temizleme tesisleri (perkloretilen / solvent bazlı)' => l10n.spActDryCleaningPerchloroethyleneSolvent,
  'Solvent ekstraksiyon tesisleri' => l10n.spActSolventExtractionFacilities,
  'Yanıcı mürekkep kullanan baskı / gravür tesisleri' => l10n.spActPrintingGravureFlammableInk,
  'Yanıcı sıvı ile sprey kaplama / boyama kabinleri' => l10n.spActSprayCoatingBoothsFlammableLiquid,
  'Kauçuk mastik ve yanıcı hammadde işleme tesisleri' => l10n.spActRubberMasticFlammableRawMaterialProcessing,
  'Boya, mürekkep veya vernik ambalajlama ve dolum tesisleri' => l10n.spActPaintInkVarnishPackagingFilling,
  'Yüksek raflı palet depolama — katı malzeme, istif yüksekliği > 4 m' => l10n.spActHighRackPalletStorageSolidAbove4m,
  'Araç lastikleri ve kauçuk ürün depolaması' => l10n.spActTyresRubberProductsStorage,
  'Rulo kâğıt ve kâğıt topu depolaması' => l10n.spActPaperRollsReelsStorage,
  'Katı plastik hammadde ve ürün depolaması (paletli/raflı)' => l10n.spActSolidPlasticRawProductStoragePalletRack,
  'Balya pamuk, tekstil hammaddesi ve sentetik elyaf depolaması' => l10n.spActBaledCottonTextileSyntheticFibreStorage,
  'Yüksek raflı palet depolama — yanıcı sıvı içeren ürünler, > 4 m  ⚠ Yoğun su sistemi' => l10n.spActHighRackPalletStorageFlammableLiquidAbove4m,
  'Aerosol ürün depoları (yanıcı itici gazlı, yüksek raf)  ⚠ Özel sistem gerektirir' => l10n.spActAerosolStoreFlammablePropellantHighRack,
  'Yanıcı sıvı ambalajlı ürün depolaması (boya, solvent, vernik)  ⚠ Özel sistem' => l10n.spActFlammableLiquidPackagedProductStorage,
  'Islanmaya dayanıksız veya yüksek ısıl değerli ürünlerin yoğun depolanması' => l10n.spActHighDensityStorageWaterSensitiveHighCalorific,
  'Yanmaz ürün depolama — metal, cam, seramik, beton ürünler' => l10n.spActNoncombustibleStorageMetalGlassCeramicConcrete,
  'Dondurulmuş gıda ve soğuk zincir ürün depolama' => l10n.spActFrozenFoodColdChainStorage,
  'Kapalı metal kutu / bidon içindeki yanmaz ürünler' => l10n.spActNoncombustibleInSealedMetalCansDrums,
  'Islak gıda (taze meyve-sebze, konserve) depoları' => l10n.spActWetFoodFreshProduceCannedStorage,
  'Porselen ve sıhhi tesisat ürünleri depolama' => l10n.spActPorcelainSanitarywareStorage,
  'Boş cam şişe / boş metal kutu depolama' => l10n.spActEmptyGlassBottlesMetalCansStorage,
  'Karton ambalajlı yanmaz ürün depolama' => l10n.spActNoncombustibleCartonPackagedStorage,
  'Tahta kutu / kasalarda yanmaz mal depolama' => l10n.spActNoncombustibleGoodsWoodenCratesStorage,
  'Cam şişe / plastik kaplar içinde yanmaz sıvı depolama' => l10n.spActNoncombustibleLiquidGlassPlasticContainersStorage,
  'Küçük oranda yanabilir içerikli karışık ürün depolama' => l10n.spActMixedProductsLowCombustibleContentStorage,
  'Boya bezlerinde cam ve seramik ürün depolama' => l10n.spActGlassCeramicWrappedStorage,
  'Kâğıt, karton ve oluklu mukavva ürün depolama' => l10n.spActPaperBoardCorrugatedProductStorage,
  'Tekstil, iplik, kumaş ve hazır giyim depolama' => l10n.spActTextileYarnFabricGarmentStorage,
  'Ahşap ve ahşap esaslı ürün depolama' => l10n.spActWoodWoodBasedProductStorage,
  'Mobilya ve döşeme malzemeleri depolama' => l10n.spActFurnitureUpholsteryMaterialsStorage,
  'Karışık ambalajlı mallar (kağıt + plastik kombine)' => l10n.spActMixedPackagedGoodsPaperPlastic,
  'Kuru gıda ve tarım ürünleri (dökme olmayan) depolama' => l10n.spActDryFoodAgriculturalProductsStorage,
  'Deri ve deri ürünleri depolama' => l10n.spActLeatherProductsStorage,
  'Küçük elektrikli ev aletleri (ambalajlı) depolama' => l10n.spActSmallElectricalApplianceStoragePackaged,
  'Ekspande plastik (EPS, PU, XPS) ürün depolama (döşeme)' => l10n.spActExpandedPlasticProductStorageFloor,
  'Kauçuk ve lastik ürün depolama (döşeme)' => l10n.spActRubberTyreProductStorageFloor,
  'Yanıcı sıvı içeren plastik kaplar depolama (döşeme)' => l10n.spActFlammableLiquidPlasticContainersStorageFloor,
  'Aerosol ürün depolama — döşeme, ≤ 3,5 m' => l10n.spActAerosolProductStorageFloor35m,
  'Polistiren köpük ambalajlı ürün depolama' => l10n.spActPolystyreneFoamPackagedProductStorage,
  'Yüksek kalorili yanabilir mal depolama (döşeme)' => l10n.spActHighCalorificCombustibleGoodsStorageFloor,
  'Raf / palet sistemi — Kategori I mallar (metal, cam, seramik)' => l10n.spActRackPalletCategoryIGoods,
  'Yüksek raflı depo — yanmaz ürünler, istif > 3 m' => l10n.spActHighRackNoncombustibleStorageAbove3m,
  'Palet üzeri kapalı metal / cam ürün depolama' => l10n.spActPalletSealedMetalGlassStorage,
  'Soğuk hava deposu yüksek raf sistemi' => l10n.spActColdStoreHighRackSystem,
  'Raf / palet sistemi — Kategori II mallar (karton ambalajlı)' => l10n.spActRackPalletCategoryIIGoods,
  'Yüksek raflı depo — karton kutu içinde yanmaz ürünler' => l10n.spActHighRackCartonBoxedNoncombustibleStorage,
  'Palet üzeri karton ambalajlı ürün depolama, > 3 m' => l10n.spActPalletCartonPackagedStorageAbove3m,
  'Tahta kasalarda depolama, yüksek raf sistemi' => l10n.spActWoodenCrateStorageHighRack,
  'Raf / palet sistemi — Kategori III mallar (kâğıt, tekstil, ahşap)' => l10n.spActRackPalletCategoryIIIGoods,
  'Yüksek raflı depo — mobilya, ahşap ürünler' => l10n.spActHighRackFurnitureWoodProductsStorage,
  'Balya (pamuk, tekstil) raf depolama, > 3 m' => l10n.spActBaledCottonTextileRackStorageAbove3m,
  'Rulo kâğıt ve kâğıt topu raf depolama, > 3 m' => l10n.spActPaperRollsRackStorageAbove3m,
  'Karışık ambalajlı (kağıt + plastik) yüksek raf depolama' => l10n.spActMixedPackagedHighRackStorage,
  'Raf / palet sistemi — Kategori IV mallar (plastik, kauçuk, köpük)' => l10n.spActRackPalletCategoryIVGoods,
  'Ekspande plastik ve köpük ürün yüksek raf depolama' => l10n.spActExpandedPlasticFoamHighRackStorage,
  'Aerosol ürün raf depolama — yanıcı itici gazlı, > 3 m' => l10n.spActAerosolRackStorageFlammablePropellantAbove3m,
  'Katı plastik hammadde ve ürün yüksek raf depolama' => l10n.spActSolidPlasticRawProductHighRackStorage,
  'Yanıcı ambalajlı ürün yüksek raf depolama (boya, vernik, solvent)' => l10n.spActFlammablePackagedProductHighRackStorage,
  'Kauçuk ve lastik ürün yüksek raf depolama, > 3 m' => l10n.spActRubberTyreProductHighRackStorageAbove3m,
  _ => faaliyet,
};

// ¦¦ Widget
class SprinkleSistemi extends StatefulWidget {
  const SprinkleSistemi({super.key});

  @override
  State<SprinkleSistemi> createState() => _SprinkleState();
}

class _SprinkleState extends State<SprinkleSistemi> {
  static const Color _kC = Color(0xFF0EA5E9);

  final _enCtrl = TextEditingController();
  final _boyCtrl = TextEditingController();
  final _yuksCtrl = TextEditingController();
  final _asmaBoslukCtrl = TextEditingController();
  bool _asmaTavan = false;
  // ¦¦ Köpük
  bool _kopukAktif = false;
  String _kopukSiviKat = 'HC'; // HC = hidrokarbon, PS = polar solvent
  String _kopukTipKod = 'AFFF3';
  int _kopukSure = 10; // dakika
  String? _secilenFaaliyet;
  // ¦¦ Gelişmiş tasarım seçenekleri
  int _boruMalzemeIdx = 0;
  int _sprinklerTipiIdx = 0;
  int _kurulumSinifIdx = 1;
  bool _kuruBoru = false;
  bool _rafDepolama = false;
  final _rafKatSayisiCtrl = TextEditingController(text: '2');

  /// Seçili faaliyete göre tehlike sınıfı indeksini otomatik belirler
  int? get _sinifIdx {
    if (_secilenFaaliyet == null) return null;
    final idx = _spSiniflar.indexWhere(
      (s) => s.faaliyetler.contains(_secilenFaaliyet),
    );
    return idx >= 0 ? idx : null;
  }

  String? _hata;
  _SpSonuc? _sonuc;

  @override
  void initState() {
    super.initState();
    final g = ProjeServisi.kayitliGirdiler;
    if (g != null) {
      ProjeServisi.kayitliGirdiler = null;
      _enCtrl.text = g['en'] ?? '';
      _boyCtrl.text = g['boy'] ?? '';
      _yuksCtrl.text = g['yuks'] ?? '';
      _asmaBoslukCtrl.text = g['asmaBosluk'] ?? '';
      _asmaTavan = g['asmaTavan'] == 'true';
      final faaliyet = g['faaliyet'] ?? '';
      _secilenFaaliyet = faaliyet.isNotEmpty ? faaliyet : null;
      _boruMalzemeIdx = int.tryParse(g['boruMalzemeIdx'] ?? '0') ?? 0;
      _sprinklerTipiIdx = int.tryParse(g['sprinklerTipiIdx'] ?? '0') ?? 0;
      _kurulumSinifIdx = int.tryParse(g['kurulumSinifIdx'] ?? '1') ?? 1;
      _kuruBoru = g['kuruBoru'] == 'true';
      _rafDepolama = g['rafDepolama'] == 'true';
      _rafKatSayisiCtrl.text = g['rafKatSayisi'] ?? '2';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _hesapla();
      });
    }
  }

  @override
  void dispose() {
    _enCtrl.dispose();
    _boyCtrl.dispose();
    _yuksCtrl.dispose();
    _asmaBoslukCtrl.dispose();
    _rafKatSayisiCtrl.dispose();
    super.dispose();
  }

  void _hesapla() {
    setState(() {
      _hata = null;
      _sonuc = null;
    });

    final l10n = AppLocalizations.of(context);
    final en = double.tryParse(_enCtrl.text.replaceAll(',', '.'));
    final boy = double.tryParse(_boyCtrl.text.replaceAll(',', '.'));
    final yuks = double.tryParse(_yuksCtrl.text.replaceAll(',', '.'));

    if (en == null || en <= 0) {
      setState(
        () => _hata = AppLocalizations.of(context).enterValidBuildingWidthM,
      );
      return;
    }
    if (boy == null || boy <= 0) {
      setState(
        () => _hata = AppLocalizations.of(context).enterValidBuildingLengthM,
      );
      return;
    }
    if (yuks == null || yuks <= 0) {
      setState(() => _hata = AppLocalizations.of(context).enterCeilingHeightM);
      return;
    }
    if (_sinifIdx == null) {
      setState(
        () => _hata = AppLocalizations.of(context).selectBuildingActivity,
      );
      return;
    }

    final sinif = _spSiniflar[_sinifIdx!];
    final alan = en * boy;

    // ¦¦ Boru malzemesi — Hazen-Williams C katsayısı
    final boruMalzeme = _spBoruMalzemeleri[_boruMalzemeIdx];
    final boruC = boruMalzeme.$2;

    // ¦¦ Sprinkler tipi / K-Faktör override (varsayılan: sınıfa göre otomatik)
    final sprinklerTipi = _spSprinklerTipleri[_sprinklerTipiIdx];
    final kFactorEfektif = sprinklerTipi.kFactor ?? sinif.kFactor;
    final kFactorUyari = kFactorEfektif < sinif.kFactor
        ? l10n.spKFactorWarning(
            '${kFactorEfektif.toInt()}',
            sinif.kod,
            '${sinif.kFactor.toInt()}',
          )
        : null;

    // ¦¦ Asma tavan hesabı (EN 12845 Md. 5.4)
    final asmaBoslukStr = _asmaBoslukCtrl.text.replaceAll(',', '.');
    // Kullanıcı cm girer, hesapta m'ye çevrilir
    final asmaBosluk = _asmaTavan
        ? ((double.tryParse(asmaBoslukStr) ?? 0.0) / 100.0)
        : 0.0;
    final asmaSprinklerGerek = _asmaTavan && asmaBosluk > 0.8;
    // Gizli boşluk sprinkler sayısı: aynı ızgara üst katsayısı ile
    // (bos boşluk tavanı için standart aralık kullanılır)
    int nAsmaSpr = 0;

    // ¦¦ Tavan yüksekliği düzeltmesi (EN 12845 Md. 5.2.3)
    final maxKapsamaEfektif = _spMaxKapsamaYuks(yuks, sinif.kod);
    final yuksUyari = _spYuksUyari(l10n, yuks, sinif.kod);
    // Düzeltilmiş kapsama alanı → alan bazlı aralık
    final aralikAlan = math.sqrt(maxKapsamaEfektif);
    // Çizelge 19: S ve D mesafe limiti uygulanır (hangi kısıt bağlayıcıysa)
    final aralik = math.min(aralikAlan, sinif.maxMesafe);

    // ¦¦ Sprinkler ızgarası (ana kat)
    final nX = (en / aralik).ceil();
    final nY = (boy / aralik).ceil();
    final nToplam = nX * nY;
    final gercekAralikX = en / nX;
    final gercekAralikY = boy / nY;
    final gercekKapsama = gercekAralikX * gercekAralikY;
    // Gizli boşluk sprinklerleri (aynı ızgara üst kata uygulanır)
    if (asmaSprinklerGerek) {
      nAsmaSpr = nToplam;
    }

    // ¦¦ Tasarım alanına düşen sprinkler sayısı
    final nTasarim = (sinif.tasarimAlani / maxKapsamaEfektif).ceil();

    // ¦¦ Sprinkler debisi ve basıncı
    // K-faktör: LH/OH=80, HH=115 (EN 12845)
    // Min. işletme basıncı: LH=0,35 bar | OH/HH=0,50 bar (EN 12845 Tablo 1)
    final qHeadHesap = sinif.yogunluk * maxKapsamaEfektif; // L/min
    double pHead = math.pow(qHeadHesap / kFactorEfektif, 2).toDouble();
    if (pHead < sinif.minBasinc) pHead = sinif.minBasinc;
    final qHead = kFactorEfektif * math.sqrt(pHead); // gerçek debi

    // ¦¦ Minimum yoğunluk kontrolü için referans debi (iteratif hesapla güncellenir)
    final qTasarimMin = sinif.yogunluk * sinif.tasarimAlani; // L/min

    // ¦¦ Boru debileri (çap seçimi sprinkler sayısına dayalı — LH/OH için akıştan bağımsız)
    final tasarimKenar = math.sqrt(sinif.tasarimAlani);
    final headPerBranch = (tasarimKenar / aralik)
        .ceil(); // bir dal boru üzerindeki spr. (tasarım alanı)
    final nCrossCalc =
        nTasarim; // cross main tasarım alanındaki tüm sprinkleri besler
    final nMainCalc = nTasarim; // ana boru: tasarım debisi (aynı)
    final qBranch = headPerBranch * qHead;

    // EN 12845 Tablo 14 bazlı çap seçimi (LH/OH); HH için hız yöntemi
    final boruTabloHH = sinif.kod.startsWith('HH');
    final dnBranch = boruTabloHH
        ? _spSecBoruHiz(qBranch, vMax: 5.0)
        : _spSecBoruEN12845(headPerBranch, sinif.kod);
    // LH/OH: sayı bazlı (akıştan bağımsız) · HH: qTasarimMin ön tahmini
    final dnCross = boruTabloHH
        ? _spSecBoruHiz(qTasarimMin, vMax: 4.0)
        : _spSecBoruEN12845(nCrossCalc, sinif.kod);
    final dnMain = boruTabloHH
        ? _spSecBoruHiz(qTasarimMin, vMax: 3.5)
        : _spSecBoruEN12845(nMainCalc, sinif.kod);

    // ¦¦ EN 12845 §13.3.2: Kritik Devre — 3 Faz Hidrolik Hesabı
    // Faz 1: Dal boru (range pipe) — en uzak kol, headPerBranch sprinkler
    // Faz 2: Tali boru (distribution) — nBranchPipes kavşak, K-orantılama balanslama
    // Faz 3: Ana boru (main pipe) — esas boru kaybı [qEfektif+lMain sonrasına eklenir]
    final nBranchPipes = (nTasarim / headPerBranch).ceil();
    final kritikDevre = <_SpHidrolikNode>[];

    // Faz 1: Dal boru
    double pIter = pHead;
    double cumQDal = 0.0;
    for (int i = 1; i <= headPerBranch; i++) {
      final qi = kFactorEfektif * math.sqrt(pIter);
      cumQDal += qi;
      final dpNext = _spHW(cumQDal, dnBranch, aralik * 1.2, c: boruC);
      kritikDevre.add(
        _SpHidrolikNode(
          no: i,
          tip: 'dal',
          mesafe: (i - 1) * aralik,
          p: pIter,
          q: qi,
          cumQ: cumQDal,
          dpSonraki: dpNext,
        ),
      );
      pIter += dpNext;
    }
    // pIter = tasarım noktası basıncı (design point) — dal boru → tali boru kavşağı
    final pDesignPoint = pIter;
    final qDalBoru = cumQDal;

    // Faz 2: Tali boru (distribution pipe) — K-orantılama balanslama
    // Q_j = qDalBoru × √(P_j / pDesignPoint)  (dallar aynı boru konfigürasyonuna sahip)
    double pTaliIter = pDesignPoint;
    double cumQTali = 0.0;
    for (int j = 1; j <= nBranchPipes; j++) {
      final qBranchJ = qDalBoru * math.sqrt(pTaliIter / pDesignPoint);
      cumQTali += qBranchJ;
      final dpNextTali = _spHW(cumQTali, dnCross, aralik * 1.2, c: boruC);
      final String? noteJ = j == 1
          ? null
          : 'Kol $j: Q = ${qDalBoru.toStringAsFixed(1)}×√(${pTaliIter.toStringAsFixed(3)}/${pDesignPoint.toStringAsFixed(3)}) = ${qBranchJ.toStringAsFixed(1)} L/min';
      kritikDevre.add(
        _SpHidrolikNode(
          no: j,
          tip: 'tali',
          mesafe: (j - 1) * aralik,
          p: pTaliIter,
          q: qBranchJ,
          cumQ: cumQTali,
          dpSonraki: dpNextTali,
          note: noteJ,
        ),
      );
      pTaliIter += dpNextTali;
    }
    // pTaliIter = ana boru başlangıç basıncı (tali boru → ana boru kavşağı)

    final qTasarim = math.max(cumQTali, qTasarimMin);

    // TS EN 12845+A1 Tablo 6 — ön-hesaplı LH/OH sistemleri için bağlayıcı alt sınır
    final _t6MinDebi = _spT6MinDebi(sinif.kod);
    final qEfektif = math.max(qTasarim, _t6MinDebi); // hangisi büyükse
    final tablo6ZorunluDebi = qEfektif > qTasarim; // Tablo 6 bağlayıcı oldu mu?

    // Gerçek boru debileri (iteratif hesap sonucuna dayalı)
    final qCross = qEfektif;
    final qMain = qEfektif;

    // ¦¦ Kritik devre uzunlukları (+%20 bağlantı eklentisi)
    // lBranch: kritik dal borusu uzunluğu (headPerBranch × aralik)
    final lBranch = headPerBranch * aralik * 1.2;
    final lCross = tasarimKenar * 1.0;
    final lMain = (math.max(en, boy) / 2.0) * 1.2;

    // ¦¦ Toplam boru metrajı (toplam sprinkler sayısı baz alınarak)
    // Dal borular: tüm satırlar (nY) × gerçek dal boru uzunluğu (headPerBranch × aralik)
    final mBranch = nY * headPerBranch * aralik * 1.2;
    // Dağıtım borusu: nBranchPipes dal kol bağlantısı × aralik aralığı
    final mCross = nBranchPipes * aralik * 1.2;
    // Esas boru: pompa dairesinden + tasarım alanı dışında kalan bina boyu
    final mMainPompa = (math.max(en, boy) / 2.0) * 1.2;
    final mMainEk = math.max(0.0, boy - tasarimKenar) * 1.2;
    final mMain = mMainPompa + mMainEk;
    final mToplam = mBranch + mCross + mMain;

    // ¦¦ Islak alarm vanası sayısı — EN 12845:2015 Madde 11.2.1
    // Sprinkler limiti: LH/OH 1000, HH 500 adet/vana
    // Alan limiti:      LH/OH 4800 m², HH 2300 m²/vana
    final isHH = sinif.kod.startsWith('HH');
    final maxVanaBasina = isHH ? 500 : 1000;
    final maxAlanPerVana = isHH ? 2300.0 : 4800.0;
    final nByCount = (nToplam / maxVanaBasina).ceil();
    final nByArea = (alan / maxAlanPerVana).ceil();
    final nAlarmVana = nByCount > nByArea ? nByCount : nByArea;

    // Faz 3: Ana boru (main pipe) — 1 düğüm (qEfektif ve lMain mevcut)
    {
      final dpAna = _spHW(qEfektif, dnMain, lMain, c: boruC);
      kritikDevre.add(
        _SpHidrolikNode(
          no: 1,
          tip: 'ana',
          mesafe: lMain,
          p: pTaliIter,
          q: qEfektif,
          cumQ: qEfektif,
          dpSonraki: dpAna,
          note:
              'Esas boru: L = ${lMain.toStringAsFixed(1)} m (fitting %20 dahil)',
        ),
      );
    }

    // ¦¦ Sürtünme kayıpları — kritikDevre düğümlerinden türetilir
    final dpBranch = kritikDevre
        .where((n) => n.tip == 'dal')
        .fold(0.0, (s, n) => s + n.dpSonraki);
    final dpCross = kritikDevre
        .where((n) => n.tip == 'tali')
        .fold(0.0, (s, n) => s + n.dpSonraki);
    final dpMain = kritikDevre
        .where((n) => n.tip == 'ana')
        .fold(0.0, (s, n) => s + n.dpSonraki);
    final dpToplam = dpBranch + dpCross + dpMain;

    // ¦¦ Statik yük (1 bar ? 10.2 m su sütunu)
    final pStatik = yuks * 0.098;

    // ¦¦ Pompa
    // TS EN 12845+A1 Tablo 6: kontrol vanası girişinde minimum basınç
    final pompaBasincHesap = pHead + dpToplam + pStatik + 0.50;
    final _t6MinBasinc = _spT6MinBasinc(sinif.kod);
    // Tablo 6 basıncı statik yük (pStatik) ile birlikte pompa basıncına uygulanır
    final pompaBasincMin = _t6MinBasinc > 0 ? _t6MinBasinc + pStatik : 0.0;
    final pompaBasinc = math.max(pompaBasincHesap, pompaBasincMin);
    final tablo6ZorunluBasinc = pompaBasinc > pompaBasincHesap;
    // TS EN 12845+A1 §8.2: Herhangi bir sprinkler konumundaki maks. basınç 12 bar'ı geçmemeli
    final maxBasincUyari = pompaBasinc > 12.0;
    // Pompa debisi: Tablo 6 efektif debisine %15 emniyet payı
    final pompaDeb = qEfektif * 1.15;

    // ¦¦ Su deposu hacmi (EN 12845 Tablo 2)
    // LH=30 dk, OH=60 dk, HH=90 dk  ×  Q_efektif (Tablo 6 bağlayıcı ise)
    final suDepoHacmi = qEfektif * sinif.sureDk.toDouble(); // L

    // ¦¦ Kurulum sınıfı / pompa yedekliliği (EN 12845 Böl. 6 ilkeleri)
    final kurulum = _spKurulumSiniflari[_kurulumSinifIdx];
    // Jokey (basınç bekletme) pompası: tipik pratik değer — ana debinin ~%1'i,
    // basıncı ana pompa kapalı-vana (churn) basıncından bir miktar yüksek tutulur.
    final jokeyDebi = pompaDeb * 0.01;
    final jokeyBasinc = pompaBasinc * 1.10;

    // ¦¦ Kuru borulu sistem — boru şebekesi iç hacmi (hava/priming suyu tahmini)
    final kuruBoruHacmi = _kuruBoru
        ? (_spBoruHacmiL(dnBranch, mBranch) +
              _spBoruHacmiL(dnCross, mCross) +
              _spBoruHacmiL(dnMain, mMain))
        : null;

    // ¦¦ Basınç düşürücü vana / zon ayrımı — §8.2 sınırı (12 bar) aşıldığında
    final zonSayisi = maxBasincUyari ? (pompaBasinc / 12.0).ceil() : 1;

    // ¦¦ Raf depolama (in-rack sprinkler) — basitleştirilmiş ön tasarım
    // Not: Kesin in-rack yerleşimi (flue space, kat aralığı) EN 12845 Ek H
    // kapsamında tam tasarımla belirlenmelidir; burada yalnızca ön fikir verilir.
    int? rafKatSayisi;
    int? rafEkSprinkler;
    double? rafEkDebi;
    if (_rafDepolama) {
      rafKatSayisi = int.tryParse(_rafKatSayisiCtrl.text.trim()) ?? 0;
      if (rafKatSayisi > 0) {
        const rafYatayAralik = 3.0; // m — tipik in-rack ön tasarım varsayımı
        final rafSiraBasi = math.max(1, (en / rafYatayAralik).ceil());
        rafEkSprinkler = rafKatSayisi * rafSiraBasi;
        const kFactorRaf = 80.0; // tipik in-rack K80
        const pRafMin = 1.0; // bar — in-rack ön tasarım min. basınç varsayımı
        rafEkDebi = rafEkSprinkler * kFactorRaf * math.sqrt(pRafMin);
      }
    }

    // ¦¦ Köpük sistemi hesabı (EN 13565-2)
    _KopukSonuc? kopukSonuc;
    if (_kopukAktif) {
      final kTip = _kopukTipleri.firstWhere(
        (t) => t.kod == _kopukTipKod,
        orElse: () => _kopukTipleri.first,
      );
      final hiz = _kopukSiviKat == 'PS'
          ? (kTip.hizPS ?? kTip.hizHC)
          : kTip.hizHC;
      final cozDebi = hiz * alan; // L/min
      final kDebi = cozDebi * kTip.konsOrani / 100.0; // L/min
      final sDebi = cozDebi - kDebi; // L/min
      final kTank = kDebi * _kopukSure.toDouble(); // L
      final sTank = sDebi * _kopukSure.toDouble(); // L
      kopukSonuc = _KopukSonuc(
        tip: kTip,
        siviKat: _kopukSiviKat,
        alan: alan,
        sure: _kopukSure.toDouble(),
        uygulamaHizi: hiz,
        cozeltDebi: cozDebi,
        konsDebi: kDebi,
        suDebi: sDebi,
        konsTankHacmi: kTank,
        suTankHacmi: sTank,
      );
    }

    setState(() {
      _sonuc = _SpSonuc(
        binaAlani: alan,
        en: en,
        boy: boy,
        yuks: yuks,
        maxKapsamaEfektif: maxKapsamaEfektif,
        yuksUyari: yuksUyari,
        asmaTavan: _asmaTavan,
        asmaBosluk: asmaBosluk,
        asmaSprinklerGerek: asmaSprinklerGerek,
        nAsmaSpr: nAsmaSpr,
        sinif: sinif,
        aralik: aralik,
        nX: nX,
        nY: nY,
        nToplam: nToplam,
        gercekKapsama: gercekKapsama,
        nTasarim: nTasarim,
        qHead: qHead,
        pHead: pHead,
        qTasarim: qTasarim,
        dnBranch: dnBranch,
        dnCross: dnCross,
        dnMain: dnMain,
        nBranch: headPerBranch,
        nCross: nCrossCalc,
        nMain: nMainCalc,
        nBranchPipes: nBranchPipes,
        boruTabloHH: boruTabloHH,
        qBranch: qBranch,
        qCross: qCross,
        qMain: qMain,
        lBranch: lBranch,
        lCross: lCross,
        lMain: lMain,
        mBranch: mBranch,
        mCross: mCross,
        mMain: mMain,
        mMainEk: mMainEk,
        mToplam: mToplam,
        nAlarmVana: nAlarmVana,
        maxVanaBasina: maxVanaBasina,
        maxAlanPerVana: maxAlanPerVana,
        dpBranch: dpBranch,
        dpCross: dpCross,
        dpMain: dpMain,
        dpToplam: dpToplam,
        pStatik: pStatik,
        pompaDeb: pompaDeb,
        pompaBasinc: pompaBasinc,
        suDepoHacmi: suDepoHacmi,
        tablo6ZorunluDebi: tablo6ZorunluDebi,
        tablo6ZorunluBasinc: tablo6ZorunluBasinc,
        maxBasincUyari: maxBasincUyari,
        kritikDevre: kritikDevre,
        kopuk: kopukSonuc,
        boruMalzeme: boruMalzeme.$1,
        boruC: boruC,
        sprinklerTipi: sprinklerTipi,
        kFactorEfektif: kFactorEfektif,
        kFactorUyari: kFactorUyari,
        kurulum: kurulum,
        jokeyDebi: jokeyDebi,
        jokeyBasinc: jokeyBasinc,
        kuruBoru: _kuruBoru,
        kuruBoruHacmi: kuruBoruHacmi,
        zonSayisi: zonSayisi,
        rafDepolama: _rafDepolama,
        rafKatSayisi: rafKatSayisi,
        rafEkSprinkler: rafEkSprinkler,
        rafEkDebi: rafEkDebi,
      );
    });
    if (_sonuc != null) {
      final s = _sonuc!;
      final wSpacing = s.en / s.nX;
      final lSpacing = s.boy / s.nY;
      final emniyet = s.pompaBasinc - s.pHead - s.dpToplam - s.pStatik;
      final resultsText = [
        '## Bina & Tasarım Parametreleri',
        'Bina: ${s.en.toStringAsFixed(1)}×${s.boy.toStringAsFixed(1)} m  |  Bina Alanı: ${s.binaAlani.toStringAsFixed(1)} m²  |  Tavan Yüksekliği: ${s.yuks.toStringAsFixed(1)} m',
        'Tehlike Sınıfı: ${s.sinif.kod}  |  Açıklama: ${s.sinif.ad}',
        'Tasarım Yoğunluğu: ${s.sinif.yogunluk.toStringAsFixed(2)} mm/min  |  Tasarım Alanı: ${s.sinif.tasarimAlani.toStringAsFixed(0)} m²  |  Maks. Kapsama/Sprinkler: ${s.maxKapsamaEfektif.toStringAsFixed(0)} m²',
        '## Sprinkler Yerleşim Hesabı',
        'Izgara Aralığı: ${s.aralik.toStringAsFixed(2)} m  |  Gerçek Kapsama: ${s.gercekKapsama.toStringAsFixed(2)} m²',
        'Yatay Sıra: ${s.nX} adet × ${wSpacing.toStringAsFixed(2)} m  |  Dikey Sıra: ${s.nY} adet × ${lSpacing.toStringAsFixed(2)} m',
        'Toplam Sprinkler: ${s.nToplam} adet  |  Tasarım Grubu: ${s.nTasarim} adet',
        '## Kritik Devre Hidrolik Hesabı',
        'En Uzak Sprinkler Debisi: ${s.qHead.toStringAsFixed(1)} L/min  |  En Uzak Basınç: ${s.pHead.toStringAsFixed(3)} bar  |  K-Faktör: ${s.kFactorEfektif.toStringAsFixed(0)} (${s.sprinklerTipi.ad})',
        'Boru Malzemesi: ${s.boruMalzeme} (C=${s.boruC.toStringAsFixed(0)})',
        'Q Tasarım: ${s.qTasarim.toStringAsFixed(1)} L/min  |  Pompa Debi: ${s.pompaDeb.toStringAsFixed(0)} L/min',
        'Dal Boru: DN${s.dnBranch}  |  Dağıtım Boru: DN${s.dnCross}  |  Ana Boru: DN${s.dnMain}',
        'ΔP Sürtünme: ${s.dpToplam.toStringAsFixed(3)} bar  |  Statik Yük: ${s.pStatik.toStringAsFixed(3)} bar  |  Emniyet: ${emniyet.clamp(0, 10).toStringAsFixed(3)} bar',
        '## Pompa Gereksinimleri',
        'Pompa Debi: ${s.pompaDeb.toStringAsFixed(0)} L/min  |  Pompa Basınç: ${s.pompaBasinc.toStringAsFixed(2)} bar',
        'Kurulum Sınıfı: ${s.kurulum.ad}  |  Jokey Pompa: ${s.jokeyDebi.toStringAsFixed(1)} L/min @ ${s.jokeyBasinc.toStringAsFixed(2)} bar',
        if (s.zonSayisi > 1)
          'Basınç Zonu: ${s.zonSayisi} adet (12 bar sınırı — PRV gerekli)',
        '## Su Deposu — EN 12845 Tablo 2',
        'Besleme Süresi: ${s.sinif.sureDk} dak.  |  Su Deposu Hacmi: ${(s.suDepoHacmi / 1000).toStringAsFixed(2)} m³',
        if (s.kuruBoru)
          'Kuru Borulu Sistem: Boru şebekesi hacmi ≈ ${(s.kuruBoruHacmi! / 1000).toStringAsFixed(2)} m³ (hava/priming suyu tahmini)',
        if (s.rafDepolama && s.rafEkSprinkler != null)
          'Raf Depolama (In-Rack, ön tasarım): ${s.rafKatSayisi} kat × ek ${s.rafEkSprinkler} sprinkler  |  Ek Debi: ${s.rafEkDebi!.toStringAsFixed(0)} L/min',
      ].join('\n');
      ProjeServisi.hesapVeri = jsonEncode({
        'i': {
          'en': _enCtrl.text,
          'boy': _boyCtrl.text,
          'yuks': _yuksCtrl.text,
          'asmaTavan': _asmaTavan.toString(),
          'asmaBosluk': _asmaBoslukCtrl.text,
          'faaliyet': _secilenFaaliyet ?? '',
          'boruMalzemeIdx': _boruMalzemeIdx.toString(),
          'sprinklerTipiIdx': _sprinklerTipiIdx.toString(),
          'kurulumSinifIdx': _kurulumSinifIdx.toString(),
          'kuruBoru': _kuruBoru.toString(),
          'rafDepolama': _rafDepolama.toString(),
          'rafKatSayisi': _rafKatSayisiCtrl.text,
        },
        'r': resultsText,
      });
    } else {
      ProjeServisi.hesapVeri = '';
    }
    ProjeServisi.hesapSinyali.value = true;
  }

  /// Arama destekli faaliyet seçim diyaloğu
  Future<void> _faaliyetSec(BuildContext context) async {
    final araCtrl = TextEditingController();
    String filtre = '';
    final l10n = AppLocalizations.of(context)!;

    final secilen = await showDialog<String>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlg) {
          final tumFaaliyetler = [
            for (final s in _spSiniflar)
              for (final f in s.faaliyetler) MapEntry(s.kod, f),
          ];
          final filtrelenmis = filtre.isEmpty
              ? tumFaaliyetler
              : tumFaaliyetler
                    .where(
                      (e) =>
                          e.value.toLowerCase().contains(
                            filtre.toLowerCase(),
                          ) ||
                          _spFaaliyetL10n(l10n, e.value).toLowerCase().contains(
                            filtre.toLowerCase(),
                          ) ||
                          e.key.toLowerCase().contains(filtre.toLowerCase()),
                    )
                    .toList();

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.spActivityDialogTitle,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: araCtrl,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: l10n.searchActivity,
                      prefixIcon: const Icon(Icons.search, size: 20),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (v) => setDlg(() => filtre = v),
                  ),
                  const SizedBox(height: 8),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(ctx).size.height * 0.5,
                    ),
                    child: filtrelenmis.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              l10n.spNoResultsFound,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            itemCount: filtrelenmis.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (_, i) {
                              final e = filtrelenmis[i];
                              final isSelected = e.value == _secilenFaaliyet;
                              return ListTile(
                                dense: true,
                                selected: isSelected,
                                selectedTileColor: const Color(
                                  0xFF0EA5E9,
                                ).withOpacity(0.1),
                                leading: Text(
                                  '[${e.key}]',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? const Color(0xFF0369A1)
                                        : Colors.grey,
                                  ),
                                ),
                                title: Text(
                                  _spFaaliyetL10n(l10n, e.value),
                                  style: const TextStyle(fontSize: 13),
                                ),
                                onTap: () => Navigator.pop(ctx, e.value),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(AppLocalizations.of(context)!.cancel),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    if (secilen != null) {
      setState(() {
        _secilenFaaliyet = secilen;
        _sonuc = null;
      });
    }
  }

  InputDecoration _spDecor(String label, IconData icon, {String? suffix}) =>
      InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: _kC),
        suffixText: suffix,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF0EA5E9), width: 2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomPad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Formül bilgi kutusu
          _InfoBox(
            color: const Color(0xFFE0F2FE),
            border: const Color(0xFF38BDF8),
            child: Text(
              l10n.spFormulaInfo,
              style: const TextStyle(fontSize: 11, height: 1.5),
            ),
          ),
          const SizedBox(height: 16),

          // ¦¦ Bina boyutları
          Text(
            l10n.buildingDimensions,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _enCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: _spDecor(
                    l10n.spFieldWidthM,
                    Icons.width_full_rounded,
                    suffix: 'm',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _boyCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: _spDecor(
                    l10n.spFieldLengthM,
                    Icons.height_rounded,
                    suffix: 'm',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _yuksCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: _spDecor(
                    l10n.spFieldCeilingM,
                    Icons.vertical_align_top_rounded,
                    suffix: 'm',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ¦¦ Asma Tavan
          Text(
            l10n.ceilingSuspended,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFCBD5E1)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Checkbox(
                  value: _asmaTavan,
                  activeColor: _kC,
                  onChanged: (v) => setState(() {
                    _asmaTavan = v ?? false;
                    _sonuc = null;
                  }),
                ),
                Expanded(
                  child: Text(
                    l10n.spSuspendedCeilingCheckbox,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          if (_asmaTavan) ...[
            const SizedBox(height: 8),
            TextFormField(
              controller: _asmaBoslukCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: _spDecor(
                l10n.spVoidDepthLabel,
                Icons.layers_rounded,
                suffix: 'cm',
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFCD34D)),
              ),
              child: Text(
                l10n.spVoidDepthInfo,
                style: const TextStyle(fontSize: 11, height: 1.4),
              ),
            ),
          ],

          // ¦¦ Bina faaliyeti seçimi devam
          Text(
            l10n.buildingActivity,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _faaliyetSec(context),
            child: InputDecorator(
              decoration: _spDecor(
                l10n.spBuildingActivityFieldLabel,
                Icons.business_center_rounded,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _secilenFaaliyet != null
                          ? _spFaaliyetL10n(l10n, _secilenFaaliyet!)
                          : l10n.spSelectActivityPlaceholder,
                      style: TextStyle(
                        fontSize: 13,
                        color: _secilenFaaliyet == null ? Colors.grey : null,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.search, size: 18, color: Colors.grey),
                ],
              ),
            ),
          ),

          // ¦¦ Otomatik belirlenen tehlike sınıfı
          if (_sinifIdx != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0EA5E9).withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF0EA5E9).withOpacity(0.45),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.verified_rounded,
                        color: Color(0xFF0369A1),
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          l10n.spHazardClassInline(
                            _spSinifAdL10n(l10n, _spSiniflar[_sinifIdx!].kod),
                          ),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFF0369A1),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.spHazardClassDetail(
                      '${_spSiniflar[_sinifIdx!].yogunluk}',
                      '${_spSiniflar[_sinifIdx!].tasarimAlani.toInt()}',
                      '${_spSiniflar[_sinifIdx!].maxKapsama.toInt()}',
                    ),
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.black54,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),

          // ¦¦ Gelişmiş Tasarım Seçenekleri
          Text(
            l10n.advancedDesignOptions,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<int>(
            value: _boruMalzemeIdx,
            isExpanded: true,
            decoration: _spDecor(l10n.pipeMaterial, Icons.plumbing_rounded),
            items: [
              for (int i = 0; i < _spBoruMalzemeleri.length; i++)
                DropdownMenuItem(
                  value: i,
                  child: Text(
                    '${_spBoruAdiL10n(l10n, _spBoruMalzemeleri[i].$1)}  —  C=${_spBoruMalzemeleri[i].$2.toInt()}',
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
            ],
            onChanged: (v) => setState(() {
              _boruMalzemeIdx = v ?? 0;
              _sonuc = null;
            }),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<int>(
            value: _sprinklerTipiIdx,
            isExpanded: true,
            decoration: _spDecor(
              l10n.spSprinklerTypeLabel,
              Icons.water_drop_rounded,
            ),
            items: [
              for (int i = 0; i < _spSprinklerTipleri.length; i++)
                DropdownMenuItem(
                  value: i,
                  child: Text(
                    _spTipiAdL10n(l10n, _spSprinklerTipleri[i].ad),
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
            ],
            onChanged: (v) => setState(() {
              _sprinklerTipiIdx = v ?? 0;
              _sonuc = null;
            }),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              _spTipiAciklamaL10n(l10n, _spSprinklerTipleri[_sprinklerTipiIdx].ad),
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black54,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<int>(
            value: _kurulumSinifIdx,
            isExpanded: true,
            decoration: _spDecor(
              l10n.spInstallationClassLabel,
              Icons.settings_input_component_rounded,
            ),
            items: [
              for (int i = 0; i < _spKurulumSiniflari.length; i++)
                DropdownMenuItem(
                  value: i,
                  child: Text(
                    _spKurulumAdL10n(l10n, _spKurulumSiniflari[i].ad),
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
            ],
            onChanged: (v) => setState(() {
              _kurulumSinifIdx = v ?? 1;
              _sonuc = null;
            }),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              _spKurulumAciklamaL10n(l10n, _spKurulumSiniflari[_kurulumSinifIdx].ad),
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black54,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFCBD5E1)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Checkbox(
                  value: _kuruBoru,
                  activeColor: _kC,
                  onChanged: (v) => setState(() {
                    _kuruBoru = v ?? false;
                    _sonuc = null;
                  }),
                ),
                Expanded(
                  child: Text(
                    l10n.spDryPipeCheckbox,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          if (_kuruBoru)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFCD34D)),
                ),
                child: Text(
                  l10n.spDryPipeInfo,
                  style: const TextStyle(fontSize: 11, height: 1.4),
                ),
              ),
            ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFCBD5E1)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Checkbox(
                  value: _rafDepolama,
                  activeColor: _kC,
                  onChanged: (v) => setState(() {
                    _rafDepolama = v ?? false;
                    _sonuc = null;
                  }),
                ),
                Expanded(
                  child: Text(
                    l10n.spRackStorageCheckbox,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          if (_rafDepolama) ...[
            const SizedBox(height: 8),
            TextFormField(
              controller: _rafKatSayisiCtrl,
              keyboardType: TextInputType.number,
              decoration: _spDecor(
                l10n.spRackLevelsLabel,
                Icons.view_agenda_rounded,
                suffix: l10n.spUnitLevel,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFCD34D)),
              ),
              child: Text(
                l10n.spRackInfo,
                style: const TextStyle(fontSize: 11, height: 1.4),
              ),
            ),
          ],

          const SizedBox(height: 16),

          // ¦¦ Köpük Sistemi
          Text(
            l10n.foamSystem,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFCBD5E1)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Checkbox(
                  value: _kopukAktif,
                  activeColor: _kC,
                  onChanged: (v) => setState(() {
                    _kopukAktif = v ?? false;
                    _sonuc = null;
                  }),
                ),
                Expanded(
                  child: Text(
                    l10n.spFoamSystemCheckbox,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          if (_kopukAktif) ...[
            const SizedBox(height: 10),
            // Sıvı kategorisi
            Text(
              l10n.flammableLiquidCategory,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: _KopukRadio(
                    label: l10n.hydrocarbon,
                    sub: l10n.spHydrocarbonSub,
                    value: 'HC',
                    group: _kopukSiviKat,
                    renk: _kC,
                    onChanged: (v) => setState(() {
                      _kopukSiviKat = v!;
                      _sonuc = null;
                    }),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _KopukRadio(
                    label: l10n.polarSolvent,
                    sub: l10n.spPolarSolventSub,
                    value: 'PS',
                    group: _kopukSiviKat,
                    renk: _kC,
                    onChanged: (v) => setState(() {
                      _kopukSiviKat = v!;
                      if (_kopukTipleri
                              .firstWhere((t) => t.kod == _kopukTipKod)
                              .hizPS ==
                          null) {
                        _kopukTipKod = 'ARAFFF3';
                      }
                      _sonuc = null;
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Köpük tipi
            Text(
              l10n.foamConcentrateType,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _kopukTipKod,
              decoration: _spDecor(l10n.foamType, Icons.bubble_chart_rounded),
              items: [
                for (final t in _kopukTipleri)
                  if (_kopukSiviKat == 'HC' || t.hizPS != null)
                    DropdownMenuItem(
                      value: t.kod,
                      child: Text(
                        '${t.ad}  —  '
                        '${_kopukSiviKat == "PS" && t.hizPS != null ? t.hizPS!.toStringAsFixed(1) : t.hizHC.toStringAsFixed(1)} L/min/m²',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
              ],
              onChanged: (v) => setState(() {
                _kopukTipKod = v!;
                _sonuc = null;
              }),
            ),
            const SizedBox(height: 10),
            // Uygulama süresi
            Text(
              l10n.minimumApplicationTime,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                for (final sure in [10, 15, 20, 30])
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: _kopukSure == sure
                              ? _kC.withOpacity(0.12)
                              : null,
                          side: BorderSide(
                            color: _kopukSure == sure
                                ? _kC
                                : const Color(0xFFCBD5E1),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => setState(() {
                          _kopukSure = sure;
                          _sonuc = null;
                        }),
                        child: Text(
                          l10n.spFoamDurationMin('$sure'),
                          style: TextStyle(
                            fontSize: 12,
                            color: _kopukSure == sure ? _kC : Colors.black87,
                            fontWeight: _kopukSure == sure
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2FE),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF7DD3FC)),
              ),
              child: Text(
                l10n.spFoamPolarSolventInfo,
                style: const TextStyle(
                  fontSize: 11,
                  height: 1.4,
                  color: Color(0xFF0369A1),
                ),
              ),
            ),
          ],

          // Hata mesajı
          if (_hata != null)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFCA5A5)),
              ),
              child: Text(
                _hata!,
                style: const TextStyle(color: Color(0xFFDC2626), fontSize: 13),
              ),
            ),

          // Hesapla butonu
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: _kC,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.calculate_rounded),
              label: Text(
                l10n.calculate,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              onPressed: _hesapla,
            ),
          ),

          // ¦¦ Sonuçlar
          if (_sonuc != null) ...[
            const SizedBox(height: 20),
            if (_sonuc!.sinif.kod == 'HHP4')
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFCA5A5)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Color(0xFFDC2626),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.spHHP4Warning,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFFDC2626),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            _SpResultCard(sonuc: _sonuc!, renk: _kC),
          ],
        ],
      ),
    );
  }
}

// ¦¦ Sonuç kartı
class _SpResultCard extends StatelessWidget {
  final _SpSonuc sonuc;
  final Color renk;

  const _SpResultCard({required this.sonuc, required this.renk});

  @override
  Widget build(BuildContext context) {
    final s = sonuc;
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Bina & Tasarım
        _spHeader(l10n.spRcHeaderBuilding, Icons.domain_rounded, renk),
        _spTable([
          (
            l10n.spRcBuildingArea,
            '${s.binaAlani.toStringAsFixed(1)} m²   '
                '(${s.en.toStringAsFixed(1)} m × ${s.boy.toStringAsFixed(1)} m)',
          ),
          (
            l10n.spRcCeilingHeight,
            '${s.yuks.toStringAsFixed(1)} m'
                '${s.maxKapsamaEfektif < s.sinif.maxKapsama ? l10n.spRcCoverageAdjustedSuffix('${s.maxKapsamaEfektif.toInt()}') : ""}',
          ),
          (
            l10n.spRcHazardClass,
            '${s.sinif.kod}  —  ${_spSinifAdL10n(l10n, s.sinif.kod)}',
          ),
          (
            l10n.spRcDesignDensity,
            '${s.sinif.yogunluk} mm/min  (= L/min/m²)',
          ),
          (l10n.spRcDesignArea, '${s.sinif.tasarimAlani.toInt()} m²'),
          (
            l10n.spRcMaxCoveragePerSprinklerCap,
            s.maxKapsamaEfektif == s.sinif.maxKapsama
                ? '${s.sinif.maxKapsama.toInt()} m²'
                : '${s.sinif.maxKapsama.toInt()} m² › ${s.maxKapsamaEfektif.toInt()} m²  ${l10n.spRcHeightAdjustSuffix}',
          ),
        ], renk),
        if (s.yuksUyari != null)
          Container(
            margin: const EdgeInsets.only(top: 6, bottom: 0),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFCD34D)),
            ),
            child: Text(
              '⚠  ${s.yuksUyari}',
              style: const TextStyle(fontSize: 11, height: 1.4),
            ),
          ),
        const SizedBox(height: 12),

        // 2. Sprinkler Yerleşimi
        _spHeader(l10n.spRcHeaderLayout, Icons.grid_on_rounded, renk),
        _spTable([
          (
            l10n.spRcTheoreticalSpacing,
            '${math.sqrt(s.maxKapsamaEfektif).toStringAsFixed(2)} m'
                '  (${s.maxKapsamaEfektif.toInt()} m² → √ = ${math.sqrt(s.maxKapsamaEfektif).toStringAsFixed(2)} m)',
          ),
          (
            l10n.spRcTable19MaxDistance,
            '${s.sinif.maxMesafe.toStringAsFixed(1)} m',
          ),
          (
            l10n.spRcAppliedGridSpacing,
            '${s.aralik.toStringAsFixed(2)} m'
                '  ${math.sqrt(s.maxKapsamaEfektif) > s.sinif.maxMesafe ? l10n.spRcDistanceConstraintBinding : l10n.spRcAreaConstraintBinding}',
          ),
          (
            l10n.spRcHorizontalRow,
            '${s.nX} ${l10n.spUnitAdet}  ›  ${(s.en / s.nX).toStringAsFixed(2)} m ${l10n.spUnitSpacing}',
          ),
          (
            l10n.spRcVerticalRow,
            '${s.nY} ${l10n.spUnitAdet}  ›  ${(s.boy / s.nY).toStringAsFixed(2)} m ${l10n.spUnitSpacing}',
          ),
          (
            l10n.spRcActualCoveragePerHead,
            '${s.gercekKapsama.toStringAsFixed(2)} m²'
                '  ≤ ${s.maxKapsamaEfektif.toInt()} m²',
          ),
          (
            l10n.spRcTotalSprinklers,
            '${s.nToplam} ${l10n.spUnitAdet}  ${l10n.spRcMainFloorSuffix}',
          ),
          (
            l10n.spRcSprinklersInDesignArea,
            '${s.nTasarim} ${l10n.spUnitAdet}   '
                '(${s.sinif.tasarimAlani.toInt()} m² ÷ ${s.maxKapsamaEfektif.toInt()} m²)',
          ),
          if (s.asmaTavan)
            (
              l10n.spRcSuspendedCeilingVoid,
              '${(s.asmaBosluk * 100).toStringAsFixed(0)} cm  '
                  '›  ${s.asmaSprinklerGerek ? l10n.spRcExtraSprinklerRequired : l10n.spRcExtraSprinklerNotRequired}',
            ),
          if (s.asmaSprinklerGerek)
            (
              l10n.spRcConcealedVoidSprinklerCount,
              '${s.nAsmaSpr} ${l10n.spUnitAdet}  ${l10n.spRcAppliedToUpperGridSuffix}',
            ),
        ], renk),
        // Çizelge 20 — Yan duvar referans kutusu
        if (s.sinif.yanKapsama != null) ...[
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9FF),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF7DD3FC)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.spRcTable20Title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    color: Color(0xFF0369A1),
                  ),
                ),
                const SizedBox(height: 6),
                _spTable([
                  (
                    l10n.spRcMaxCoveragePerSprinklerLow,
                    '${s.sinif.yanKapsama!.toStringAsFixed(1)} m²',
                  ),
                  (
                    l10n.spRcMaxGroupDistance,
                    '${s.sinif.yanAralik!.toStringAsFixed(1)} m${l10n.spRcNote2Suffix}',
                  ),
                  (
                    l10n.spRcMaxToWallEnd,
                    '${s.sinif.yanSonMesafe!.toStringAsFixed(1)} m',
                  ),
                ], renk),
              ],
            ),
          ),
        ],

        // 3. Kritik Devre Hidrolik
        _spHeader(
          l10n.spRcHeaderHydraulic,
          Icons.water_drop_rounded,
          renk,
        ),
        _spTable([
          (
            l10n.spRcFarthestHeadFlow,
            '${s.qHead.toStringAsFixed(1)} L/min   '
                '(K = ${s.sinif.kFactor.toInt()},  P = ${s.pHead.toStringAsFixed(2)} bar)',
          ),
          (
            l10n.spRcDesignTotalFlow,
            '${s.qTasarim.toStringAsFixed(1)} L/min   '
                '= ${(s.qTasarim * 60 / 1000).toStringAsFixed(2)} m³/h',
          ),
          (
            l10n.spRcBranchPipeDN('${s.dnBranch}'),
            '${s.nBranch} sprinkler  ·  Q = ${s.qBranch.toStringAsFixed(0)} L/min   '
                'L = ${s.lBranch.toStringAsFixed(1)} m   '
                '›  P = ${s.dpBranch.toStringAsFixed(3)} bar',
          ),
          (
            l10n.spRcCrossPipeDN('${s.dnCross}'),
            '${s.nCross} sprinkler  ·  Q = ${s.qCross.toStringAsFixed(0)} L/min   '
                'L = ${s.lCross.toStringAsFixed(1)} m   '
                '›  P = ${s.dpCross.toStringAsFixed(3)} bar',
          ),
          (
            l10n.spRcMainPipeDN('${s.dnMain}'),
            '${s.nMain} sprinkler  ·  Q = ${s.qMain.toStringAsFixed(0)} L/min   '
                'L = ${s.lMain.toStringAsFixed(1)} m   '
                '›  P = ${s.dpMain.toStringAsFixed(3)} bar',
          ),
          (
            l10n.spRcTotalFrictionLoss,
            '${s.dpToplam.toStringAsFixed(3)} bar',
          ),
          (
            l10n.spRcStaticHeadFormula(s.yuks.toStringAsFixed(1)),
            '${s.pStatik.toStringAsFixed(3)} bar',
          ),
          (
            l10n.spRcFarthestHeadMinPressure,
            '${s.pHead.toStringAsFixed(2)} bar  (min. ${s.sinif.minBasinc} bar, K=${s.sinif.kFactor.toInt()})',
          ),
          (l10n.spRcSafetyMarginLabel, '0.500 bar'),
        ], renk),
        const SizedBox(height: 8),

        // 3b. Kritik Devre — Tam Hidrolik Hesap (Faz 1: dal, Faz 2: tali, Faz 3: ana)
        _spHeader(
          l10n.spRcHeaderFullHydraulic,
          Icons.format_list_numbered_rounded,
          renk,
        ),
        if (s.kritikDevre.isNotEmpty) ...[
          // Başlık satırı
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: renk.withOpacity(0.12),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                _spKDCell('No', 36, isHeader: true, renk: renk),
                _spKDCell(l10n.spRcColDistance, 54, isHeader: true, renk: renk),
                _spKDCell(l10n.spRcColPressure, 60, isHeader: true, renk: renk),
                _spKDCell(l10n.spRcColFlowLower, 60, isHeader: true, renk: renk),
                Expanded(
                  child: _spKDCell(
                    l10n.spRcColCumFlow,
                    0,
                    isHeader: true,
                    renk: renk,
                  ),
                ),
                _spKDCell(l10n.spRcColNextDeltaP, 72, isHeader: true, renk: renk),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: renk.withOpacity(0.2)),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(8),
              ),
            ),
            child: Column(
              children: () {
                final rows = <Widget>[];
                String? lastTip;
                int rowIdx = 0;
                for (final nd in s.kritikDevre) {
                  // Faz geçişinde bölüm başlığı ekle
                  if (nd.tip != lastTip) {
                    final sectionLabel = nd.tip == 'dal'
                        ? l10n.spRcSectionBranchPipe
                        : nd.tip == 'tali'
                        ? l10n.spRcSectionDistPipe
                        : l10n.spRcSectionMainPipe;
                    rows.add(
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: renk.withOpacity(0.07),
                          border: Border(
                            top: BorderSide(color: renk.withOpacity(0.18)),
                          ),
                        ),
                        child: Text(
                          sectionLabel,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: renk,
                          ),
                        ),
                      ),
                    );
                    lastTip = nd.tip;
                  }
                  final prefix = nd.tip == 'dal'
                      ? 'SP'
                      : (nd.tip == 'tali' ? 'DP' : 'MP');
                  final label = nd.tip == 'ana' ? 'MP' : '$prefix${nd.no}';
                  final isLastNode = nd == s.kritikDevre.last;
                  rows.add(
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: rowIdx.isEven
                            ? Colors.transparent
                            : renk.withOpacity(0.03),
                        border: isLastNode
                            ? null
                            : Border(
                                bottom: BorderSide(
                                  color: renk.withOpacity(0.08),
                                ),
                              ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _spKDCell(
                                label,
                                36,
                                bold: nd.no == 1 && nd.tip == 'dal',
                                renk: renk,
                              ),
                              _spKDCell(
                                nd.mesafe.toStringAsFixed(1),
                                54,
                                renk: renk,
                              ),
                              _spKDCell(
                                nd.p.toStringAsFixed(3),
                                60,
                                bold: nd.no == 1 && nd.tip == 'dal',
                                renk: renk,
                              ),
                              _spKDCell(
                                nd.q.toStringAsFixed(1),
                                60,
                                renk: renk,
                              ),
                              Expanded(
                                child: _spKDCell(
                                  nd.cumQ.toStringAsFixed(1),
                                  0,
                                  renk: renk,
                                ),
                              ),
                              _spKDCell(
                                nd.dpSonraki.toStringAsFixed(4),
                                72,
                                renk: renk,
                              ),
                            ],
                          ),
                          if (nd.note != null)
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 2,
                                top: 2,
                                bottom: 1,
                              ),
                              child: Text(
                                nd.note!,
                                style: TextStyle(
                                  fontSize: 9.5,
                                  color: renk.withOpacity(0.7),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                  rowIdx++;
                }
                return rows;
              }(),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              l10n.spRcHydraulicFootnote,
              style: TextStyle(
                fontSize: 10,
                color: renk.withOpacity(0.65),
                height: 1.4,
              ),
            ),
          ),
        ],
        const SizedBox(height: 12),

        // 4. Pompa
        _spHeader(
          l10n.spRcHeaderPump,
          Icons.settings_input_component_rounded,
          renk,
        ),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [renk.withOpacity(0.08), renk.withOpacity(0.02)],
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: renk.withOpacity(0.4)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _SpPompaBox(
                    label: l10n.spRcPumpFlowLabel,
                    value: s.pompaDeb.toStringAsFixed(0),
                    unit: 'L/min',
                    sub: '${(s.pompaDeb * 60 / 1000).toStringAsFixed(2)} m³/h',
                    renk: renk,
                  ),
                  Container(width: 1, height: 60, color: renk.withOpacity(0.3)),
                  _SpPompaBox(
                    label: l10n.spRcPumpPressureLabel,
                    value: s.pompaBasinc.toStringAsFixed(2),
                    unit: 'bar',
                    sub: '${(s.pompaBasinc * 10.2).toStringAsFixed(1)} m SSS',
                    renk: renk,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                s.tablo6ZorunluDebi
                    ? 'Q = max(Q_tasarım, Tablo 6 min.) × 1.15\n'
                          '  = max(${s.qTasarim.toStringAsFixed(0)}, ${_spT6MinDebi(s.sinif.kod).toStringAsFixed(0)}) × 1.15'
                          ' = ${s.pompaDeb.toStringAsFixed(0)} L/min  ← Tablo 6 bağlayıcı\n'
                          'P = P_sp + P_sürt + P_statik + P_emn = ${s.pHead.toStringAsFixed(2)} + ${s.dpToplam.toStringAsFixed(3)} + ${s.pStatik.toStringAsFixed(3)} + 0.500'
                          '${s.tablo6ZorunluBasinc ? ' → ${((s.pHead + s.dpToplam + s.pStatik + 0.50)).toStringAsFixed(3)} bar\n  Tablo 6 min. basınç (${_spT6MinBasinc(s.sinif.kod).toStringAsFixed(1)} + ${s.pStatik.toStringAsFixed(3)} = ${(s.pompaBasinc).toStringAsFixed(3)} bar) bağlayıcı' : ' = ${s.pompaBasinc.toStringAsFixed(3)} bar'}'
                    : 'Q = Q_tasarım × 1.15 = ${s.qTasarim.toStringAsFixed(0)} × 1.15 = ${s.pompaDeb.toStringAsFixed(0)} L/min\n'
                          'P = P_sprinkler + P_sürtünme + P_statik + P_emniyet\n'
                          '  = ${s.pHead.toStringAsFixed(2)} + ${s.dpToplam.toStringAsFixed(3)} + ${s.pStatik.toStringAsFixed(3)} + 0.500 = ${s.pompaBasinc.toStringAsFixed(3)} bar',
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: 'monospace',
                  color: renk.withOpacity(0.85),
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
        // EN 12845 Tablo 6 bilgi notu (ön-hesaplı LH/OH)
        if (s.tablo6ZorunluDebi || s.tablo6ZorunluBasinc)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade400),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: Colors.amber.shade700,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${l10n.spRcTable6AppliedIntro}\n'
                      '${s.tablo6ZorunluDebi ? '${l10n.spRcTable6FlowLine(s.qTasarim.toStringAsFixed(0), _spT6MinDebi(s.sinif.kod).toStringAsFixed(0))}\n' : ''}'
                      '${s.tablo6ZorunluBasinc ? l10n.spRcTable6PressureLine(_spT6MinBasinc(s.sinif.kod).toStringAsFixed(1), s.pompaBasinc.toStringAsFixed(2)) : ''}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.amber.shade900,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        // EN 12845 §8.2: max 12 bar uyarısı
        if (s.maxBasincUyari)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade400),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 16,
                    color: Colors.red.shade700,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.spRcMaxPressureWarning(
                        s.pompaBasinc.toStringAsFixed(2),
                        '${s.zonSayisi}',
                      ),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.red.shade800,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 12),

        // 4a2. Kurulum Sınıfı & Pompa Yedekliliği
        _spHeader(
          l10n.spRcHeaderInstallation,
          Icons.power_settings_new_rounded,
          renk,
        ),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: renk.withOpacity(0.06),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: renk.withOpacity(0.35)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _spTable([
                (
                  l10n.spRcInstallationClassLabel,
                  _spKurulumAdL10n(l10n, s.kurulum.ad),
                ),
                (
                  l10n.spRcPumpCount,
                  '${s.kurulum.pompaSayisi} ${l10n.spUnitAdet}'
                      '${s.kurulum.dizelGerekli ? l10n.spRcElectricDieselSuffix : ""}',
                ),
                (
                  l10n.spRcWaterSource,
                  s.kurulum.ciftKaynak ? l10n.spRcDualIndependent : l10n.spRcSingle,
                ),
                (
                  l10n.spRcJockeyPump,
                  '${s.jokeyDebi.toStringAsFixed(1)} L/min @ ${s.jokeyBasinc.toStringAsFixed(2)} bar',
                ),
              ], renk),
              const SizedBox(height: 8),
              Text(
                _spKurulumAciklamaL10n(l10n, s.kurulum.ad),
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.black54,
                  fontStyle: FontStyle.italic,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // 4b. Su Deposu
        _spHeader(l10n.spRcHeaderWaterTank, Icons.water_rounded, renk),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: renk.withOpacity(0.06),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: renk.withOpacity(0.35)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _SpPompaBox(
                    label: l10n.spRcWaterSupplyDuration,
                    value: '${s.sinif.sureDk}',
                    unit: l10n.spUnitMinutes,
                    sub: s.sinif.kod == 'LH'
                        ? l10n.spRcSupplyDurationSub('LH', '30')
                        : s.sinif.kod.startsWith('OH')
                        ? l10n.spRcSupplyDurationSub('OH', '60')
                        : l10n.spRcSupplyDurationSub('HH', '90'),
                    renk: renk,
                  ),
                  Container(width: 1, height: 60, color: renk.withOpacity(0.3)),
                  _SpPompaBox(
                    label: l10n.spRcMinWaterTank,
                    value: (s.suDepoHacmi / 1000).toStringAsFixed(1),
                    unit: 'm³',
                    sub: '${s.suDepoHacmi.toStringAsFixed(0)} L',
                    renk: renk,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                s.tablo6ZorunluDebi
                    ? 'V = Q_efektif × t = ${(s.suDepoHacmi / s.sinif.sureDk).toStringAsFixed(0)} L/min × ${s.sinif.sureDk} dk'
                          ' = ${s.suDepoHacmi.toStringAsFixed(0)} L = ${(s.suDepoHacmi / 1000).toStringAsFixed(2)} m³\n'
                          '(Q_tasarım=${s.qTasarim.toStringAsFixed(0)} L/min < Tablo 6 min. ${_spT6MinDebi(s.sinif.kod).toStringAsFixed(0)} L/min → Tablo 6 esas alındı)'
                    : 'V = Q_tasarim × t = ${s.qTasarim.toStringAsFixed(0)} L/min × ${s.sinif.sureDk} dk'
                          ' = ${s.suDepoHacmi.toStringAsFixed(0)} L = ${(s.suDepoHacmi / 1000).toStringAsFixed(2)} m³',
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: 'monospace',
                  color: renk.withOpacity(0.85),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.spRcWaterSupplyNote,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.black54,
                  fontStyle: FontStyle.italic,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // 4c. Kuru Borulu Sistem (isteğe bağlı)
        if (s.kuruBoru) ...[
          _spHeader(
            l10n.spRcHeaderDryPipe,
            Icons.ac_unit_rounded,
            renk,
          ),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: renk.withOpacity(0.06),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: renk.withOpacity(0.35)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _spTable([
                  (
                    l10n.spRcPipeNetworkVolume,
                    '${(s.kuruBoruHacmi! / 1000).toStringAsFixed(2)} m³  (${s.kuruBoruHacmi!.toStringAsFixed(0)} L)',
                  ),
                ], renk),
                const SizedBox(height: 8),
                Text(
                  l10n.spRcDryPipeNote,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],

        // 4d. Raf Depolama (In-Rack Sprinkler) — ön tasarım
        if (s.rafDepolama && s.rafEkSprinkler != null) ...[
          _spHeader(
            l10n.spRcHeaderRackStorage,
            Icons.view_agenda_rounded,
            renk,
          ),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: renk.withOpacity(0.06),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: renk.withOpacity(0.35)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _spTable([
                  (
                    l10n.spRcRackLevelCount,
                    '${s.rafKatSayisi} ${l10n.spUnitLevel}',
                  ),
                  (
                    l10n.spRcEstExtraInRackSprinklers,
                    '${s.rafEkSprinkler} ${l10n.spUnitAdet}',
                  ),
                  (
                    l10n.spRcEstExtraFlow,
                    '${s.rafEkDebi!.toStringAsFixed(0)} L/min',
                  ),
                ], renk),
                const SizedBox(height: 8),
                Text(
                  l10n.spRcRackNote,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],

        // 5. Boru Çapı Özeti
        _spHeader(
          l10n.spRcHeaderPipeDiameterSummary,
          Icons.plumbing_rounded,
          renk,
        ),
        if (s.boruTabloHH)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFCD34D)),
            ),
            child: Text(
              l10n.spRcHHPTable14Warning,
              style: const TextStyle(fontSize: 11, height: 1.4),
            ),
          ),
        _spTable([
          (
            l10n.pipeMaterial,
            '${_spBoruAdiL10n(l10n, s.boruMalzeme)}  (Hazen-Williams C=${s.boruC.toInt()})',
          ),
          (
            l10n.spRcSprinklerTypeKFactor,
            '${_spTipiAdL10n(l10n, s.sprinklerTipi.ad)}  —  K${s.kFactorEfektif.toInt()}',
          ),
          (
            l10n.spRcBranchPipeRow,
            'DN ${s.dnBranch}  —  ${s.nBranch} spr./dal'
                '${s.boruTabloHH ? l10n.spRcVelocityMethodSuffix : l10n.spRcTable14Suffix}',
          ),
          (
            l10n.spRcCrossMainRow,
            'DN ${s.dnCross}  —  ${l10n.spRcBranchConnCount('${s.nBranchPipes}', '${s.nCross}')}'
                '${s.boruTabloHH ? l10n.spRcVelocityMethodSuffix : l10n.spRcTable14Suffix}',
          ),
          (
            l10n.spRcMainSupplyRow,
            'DN ${s.dnMain}  —  ${l10n.spRcDesignAreaHeadsSuffix('${s.nTasarim}')}'
                '${s.boruTabloHH ? l10n.spRcVelocityMethodSuffix : l10n.spRcTable14Suffix}',
          ),
        ], renk),
        if (s.kFactorUyari != null)
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade400),
            ),
            child: Text(
              '⚠  ${s.kFactorUyari}',
              style: TextStyle(
                fontSize: 11,
                height: 1.4,
                color: Colors.red.shade800,
              ),
            ),
          ),
        const SizedBox(height: 4),

        _spHeader(l10n.spRcHeaderPipeLength, Icons.straighten_rounded, renk),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: renk.withOpacity(0.2)),
          ),
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(2.4),
              1: FlexColumnWidth(1.5),
              2: FlexColumnWidth(1.8),
              3: FlexColumnWidth(1.8),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(
                  color: renk.withOpacity(0.12),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                ),
                children: [
                  _spTH(l10n.spRcColPipeType),
                  _spTH('DN'),
                  _spTH(l10n.spRcColCountLength),
                  _spTH(l10n.spRcColTotalM),
                ],
              ),
              _spTR(
                l10n.spRcRowBranchPipe,
                'DN ${s.dnBranch}',
                '${s.nY} × ${(s.nBranch * s.aralik).toStringAsFixed(1)} m × 1.2',
                s.mBranch.toStringAsFixed(1),
                renk,
                even: true,
              ),
              _spTR(
                l10n.spRcRowCrossMain('${s.nBranchPipes}'),
                'DN ${s.dnCross}',
                '${s.nBranchPipes} × ${s.aralik.toStringAsFixed(1)} m × 1.2',
                s.mCross.toStringAsFixed(1),
                renk,
                even: false,
              ),
              _spTR(
                l10n.spRcRowMainPipe,
                'DN ${s.dnMain}',
                'pompa: ${(math.max(s.en, s.boy) / 2).toStringAsFixed(1)} m\n'
                    'kalan: ${math.max(0.0, s.boy - math.sqrt(s.sinif.tasarimAlani)).toStringAsFixed(1)} m  (×1.2)',
                s.mMain.toStringAsFixed(1),
                renk,
                even: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: renk.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: renk.withOpacity(0.35)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.spRcTotalPipeLength,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              Text(
                '${s.mToplam.toStringAsFixed(1)} m',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: renk,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.spRcPipeLengthFootnote,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.black45,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 16),

        // 7. Islak Alarm Vanası
        _spHeader(
          l10n.spRcHeaderAlarmValve,
          Icons.water_damage_rounded,
          renk,
        ),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: renk.withOpacity(0.06),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: renk.withOpacity(0.35)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.check_circle_rounded, color: renk, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                        children: [
                          TextSpan(
                            text: l10n.spRcRequiredAlarmValve,
                            style: const TextStyle(fontSize: 13),
                          ),
                          TextSpan(
                            text: '${s.nAlarmVana} ${l10n.spUnitAdet}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: renk,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _spTable([
                (
                  l10n.spRcTotalSprinklersRow,
                  '${s.nToplam} ${l10n.spUnitAdet}',
                ),
                (
                  l10n.spRcMaxSprinklersPerValve,
                  '${s.maxVanaBasina} ${l10n.spUnitAdet}  '
                      '(${s.sinif.kod.startsWith("HH") ? l10n.spRcHHPClassSuffix : l10n.spRcLHOHClassSuffix})',
                ),
                (
                  l10n.spRcMaxAreaPerValve,
                  '${s.maxAlanPerVana.toStringAsFixed(0)} m²  '
                      '(${s.sinif.kod.startsWith("HH") ? l10n.spRcHHPClassSuffix : l10n.spRcLHOHClassSuffix})',
                ),
                (
                  l10n.spRcAreaPerValve,
                  '${(s.binaAlani / s.nAlarmVana).toStringAsFixed(0)} m²  '
                      '(≤ ${s.maxAlanPerVana.toStringAsFixed(0)} m²)',
                ),
                (
                  l10n.spRcDesignFlowPerValve,
                  '${s.pompaDeb.toStringAsFixed(0)} L/min  '
                      '${l10n.spRcSingleValveSuffix}',
                ),
              ], renk),
              const SizedBox(height: 8),
              Text(
                l10n.spRcAlarmValveNote(
                  s.sinif.kod.startsWith("HH")
                      ? l10n.spRcAlarmValveScopeHH
                      : l10n.spRcAlarmValveScopeLHOH,
                ),
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.black54,
                  fontStyle: FontStyle.italic,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // 8. Köpük Sistemi
        if (s.kopuk != null) ...[
          _spHeader(
            l10n.spRcHeaderFoamSystem,
            Icons.bubble_chart_rounded,
            renk,
          ),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: renk.withOpacity(0.06),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: renk.withOpacity(0.35)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _spTable([
                  (
                    l10n.spRcConcentrateType,
                    '${s.kopuk!.tip.ad}${l10n.spRcConcentrationSuffix('${s.kopuk!.tip.konsOrani.toInt()}')}',
                  ),
                  (
                    l10n.spRcLiquidCategory,
                    s.kopuk!.siviKat == 'PS'
                        ? l10n.spRcPolarSolventDetail
                        : l10n.spRcHydrocarbonDetail,
                  ),
                  (l10n.spRcProtectedArea, '${s.kopuk!.alan.toStringAsFixed(0)} m²'),
                  (
                    l10n.spRcApplicationRate,
                    '${s.kopuk!.uygulamaHizi.toStringAsFixed(1)} L/min/m²',
                  ),
                  (
                    l10n.spRcApplicationDuration,
                    '${s.kopuk!.sure.toInt()} ${l10n.spUnitMinutes}',
                  ),
                ], renk),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: renk.withOpacity(0.25)),
                  ),
                  child: Column(
                    children: [
                      _spHRow(
                        l10n.spRcSolutionFlow,
                        '${s.kopuk!.cozeltDebi.toStringAsFixed(0)} L/min',
                        renk,
                      ),
                      const Divider(height: 10),
                      _spHRow(
                        l10n.spRcConcentrateFlow,
                        '${s.kopuk!.konsDebi.toStringAsFixed(1)} L/min',
                        renk,
                      ),
                      _spHRow(
                        l10n.spRcWaterFlow,
                        '${s.kopuk!.suDebi.toStringAsFixed(0)} L/min',
                        renk,
                      ),
                      const Divider(height: 10),
                      _spHRow(
                        l10n.spRcConcentrateTankVolume,
                        '${s.kopuk!.konsTankHacmi.toStringAsFixed(0)} L'
                            '  (${(s.kopuk!.konsTankHacmi / 1000).toStringAsFixed(2)} m³)',
                        renk,
                        bold: true,
                      ),
                      _spHRow(
                        l10n.spRcWaterReserve,
                        '${s.kopuk!.suTankHacmi.toStringAsFixed(0)} L'
                            '  (${(s.kopuk!.suTankHacmi / 1000).toStringAsFixed(2)} m³)',
                        renk,
                        bold: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.spRcFoamNote7,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],

        _InfoBox(
          color: const Color(0xFFFEF3C7),
          border: const Color(0xFFFCD34D),
          child: Text(
            l10n.spRcFinalDisclaimer,
            style: const TextStyle(fontSize: 11, height: 1.5),
          ),
        ),
      ],
    );
  }

  Widget _spHeader(String title, IconData icon, Color renk) => Container(
    margin: const EdgeInsets.only(bottom: 6),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: renk.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Icon(icon, color: renk, size: 18),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: renk,
          ),
        ),
      ],
    ),
  );

  /// Kritik devre tablosu hücre yardımcısı
  Widget _spKDCell(
    String text,
    double width, {
    bool isHeader = false,
    bool bold = false,
    required Color renk,
  }) {
    final content = Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: isHeader ? 10 : 11,
        fontWeight: isHeader || bold ? FontWeight.bold : FontWeight.normal,
        color: isHeader ? renk : (bold ? renk : Colors.black87),
        height: 1.3,
      ),
    );
    return width > 0 ? SizedBox(width: width, child: content) : content;
  }

  // ¦¦ Metraj tablosu yardımcıları
  Widget _spTH(String text) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    ),
  );

  TableRow _spTR(
    String tip,
    String dn,
    String acikDeger,
    String toplam,
    Color renk, {
    required bool even,
  }) => TableRow(
    decoration: BoxDecoration(
      color: even ? Colors.transparent : renk.withOpacity(0.04),
    ),
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Text(tip, style: const TextStyle(fontSize: 11)),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Text(
          dn,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: renk,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Text(acikDeger, style: const TextStyle(fontSize: 11)),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Text(
          '$toplam m',
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ),
    ],
  );

  Widget _spTable(List<(String, String)> rows, Color renk) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: renk.withOpacity(0.2)),
    ),
    child: Column(
      children: rows.asMap().entries.map((e) {
        final isLast = e.key == rows.length - 1;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: e.key.isEven ? Colors.transparent : renk.withOpacity(0.03),
            borderRadius: isLast
                ? const BorderRadius.vertical(bottom: Radius.circular(10))
                : null,
            border: isLast
                ? null
                : Border(bottom: BorderSide(color: renk.withOpacity(0.1))),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 170,
                child: Text(
                  e.value.$1,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ),
              Expanded(
                child: Text(
                  e.value.$2,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    ),
  );

  Widget _spHRow(String label, String value, Color renk, {bool bold = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: bold ? FontWeight.bold : FontWeight.w600,
                  color: bold ? renk : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      );
}

class _SpPompaBox extends StatelessWidget {
  final String label, value, unit, sub;
  final Color renk;

  const _SpPompaBox({
    required this.label,
    required this.value,
    required this.unit,
    required this.sub,
    required this.renk,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.black54),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: renk,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              unit,
              style: TextStyle(fontSize: 14, color: renk.withOpacity(0.8)),
            ),
          ],
        ),
        Text(sub, style: const TextStyle(fontSize: 11, color: Colors.black45)),
      ],
    );
  }
}

class _KopukRadio extends StatelessWidget {
  final String label, sub, value, group;
  final Color renk;
  final ValueChanged<String?> onChanged;

  const _KopukRadio({
    required this.label,
    required this.sub,
    required this.value,
    required this.group,
    required this.renk,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final sel = value == group;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: sel ? renk.withOpacity(0.1) : null,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: sel ? renk : const Color(0xFFCBD5E1)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Radio<String>(
              value: value,
              groupValue: group,
              activeColor: renk,
              onChanged: onChanged,
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: sel ? renk : Colors.black87,
                    ),
                  ),
                  Text(
                    sub,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.black54,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
