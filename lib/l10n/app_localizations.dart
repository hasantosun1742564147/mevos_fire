import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @languageLabel.
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get languageLabel;

  /// No description provided for @settingsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settingsTitle;

  /// No description provided for @logout.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış'**
  String get logout;

  /// No description provided for @save.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get save;

  /// No description provided for @saved.
  ///
  /// In tr, this message translates to:
  /// **'Kaydedildi!'**
  String get saved;

  /// No description provided for @cancel.
  ///
  /// In tr, this message translates to:
  /// **'Vazgeç'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get delete;

  /// No description provided for @deletingAccount.
  ///
  /// In tr, this message translates to:
  /// **'Hesap siliniyor...'**
  String get deletingAccount;

  /// No description provided for @accountDeleteTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hesabınızı silmeyi onaylıyor musunuz?'**
  String get accountDeleteTitle;

  /// No description provided for @accountDeleteWarning.
  ///
  /// In tr, this message translates to:
  /// **'Hesabınız aktif sistemden silinir. Ad-soyad, e-posta, önceki üyelik durumu ve kayıt/silinme tarihleri silinen üyeler geçmişinde adminlere gösterilmek üzere tutulur. Bu işlem geri alınamaz.'**
  String get accountDeleteWarning;

  /// No description provided for @accountManagement.
  ///
  /// In tr, this message translates to:
  /// **'Hesap Yönetimi'**
  String get accountManagement;

  /// No description provided for @accountDeleteInfo.
  ///
  /// In tr, this message translates to:
  /// **'Hesabınızı ve bu cihazda saklanan hesap bilgilerinizi kalıcı olarak silebilirsiniz.'**
  String get accountDeleteInfo;

  /// No description provided for @deleteAccount.
  ///
  /// In tr, this message translates to:
  /// **'Hesabımı Kalıcı Olarak Sil'**
  String get deleteAccount;

  /// No description provided for @feedbackTitle.
  ///
  /// In tr, this message translates to:
  /// **'Geri Bildirim'**
  String get feedbackTitle;

  /// No description provided for @feedbackSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Bir sorun mu buldunuz? Bize bildirin.'**
  String get feedbackSubtitle;

  /// No description provided for @feedbackSelectPage.
  ///
  /// In tr, this message translates to:
  /// **'Hangi sayfa ile ilgili?'**
  String get feedbackSelectPage;

  /// No description provided for @feedbackSelectPageHint.
  ///
  /// In tr, this message translates to:
  /// **'Sayfa seçin'**
  String get feedbackSelectPageHint;

  /// No description provided for @feedbackMessageLabel.
  ///
  /// In tr, this message translates to:
  /// **'Hata mesajınızı yazın'**
  String get feedbackMessageLabel;

  /// No description provided for @feedbackMessageHint.
  ///
  /// In tr, this message translates to:
  /// **'Karşılaştığınız sorunu buraya yazın...'**
  String get feedbackMessageHint;

  /// No description provided for @feedbackSend.
  ///
  /// In tr, this message translates to:
  /// **'Gönder'**
  String get feedbackSend;

  /// No description provided for @feedbackSending.
  ///
  /// In tr, this message translates to:
  /// **'Gönderiliyor...'**
  String get feedbackSending;

  /// No description provided for @feedbackSentSuccess.
  ///
  /// In tr, this message translates to:
  /// **'Geri bildiriminiz için teşekkürler!'**
  String get feedbackSentSuccess;

  /// No description provided for @feedbackSendFailed.
  ///
  /// In tr, this message translates to:
  /// **'Geri bildirim gönderilemedi. Lütfen tekrar deneyin.'**
  String get feedbackSendFailed;

  /// No description provided for @feedbackMessageRequired.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen bir mesaj yazın.'**
  String get feedbackMessageRequired;

  /// No description provided for @feedbackPageHome.
  ///
  /// In tr, this message translates to:
  /// **'Ana Sayfa'**
  String get feedbackPageHome;

  /// No description provided for @feedbackPageOther.
  ///
  /// In tr, this message translates to:
  /// **'Diğer'**
  String get feedbackPageOther;

  /// No description provided for @apiKeyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Gemini API Anahtarı (AI)'**
  String get apiKeyTitle;

  /// No description provided for @apiKeyInstructions.
  ///
  /// In tr, this message translates to:
  /// **'aistudio.google.com/apikey adresinden ücretsiz API anahtarı alabilirsiniz.'**
  String get apiKeyInstructions;

  /// No description provided for @getApiKey.
  ///
  /// In tr, this message translates to:
  /// **'API Anahtarı al'**
  String get getApiKey;

  /// No description provided for @updateApiKey.
  ///
  /// In tr, this message translates to:
  /// **'API Anahtarını Güncelle'**
  String get updateApiKey;

  /// No description provided for @add.
  ///
  /// In tr, this message translates to:
  /// **'Ekle'**
  String get add;

  /// No description provided for @done.
  ///
  /// In tr, this message translates to:
  /// **'Tamam'**
  String get done;

  /// No description provided for @smokeReference.
  ///
  /// In tr, this message translates to:
  /// **'TS EN 54-7:2006 / EN 54-14:2004 — Nokta tipi duman dedektörü yerleşimi\nÖn boyutlandırmadır; kesin tasarım için sistem mühendisinin onayı gerekir.'**
  String get smokeReference;

  /// No description provided for @buildingType.
  ///
  /// In tr, this message translates to:
  /// **'Yapı Tipi'**
  String get buildingType;

  /// No description provided for @buildingOffice.
  ///
  /// In tr, this message translates to:
  /// **'Ofis / İdari'**
  String get buildingOffice;

  /// No description provided for @buildingHome.
  ///
  /// In tr, this message translates to:
  /// **'Konut / Otel'**
  String get buildingHome;

  /// No description provided for @buildingHospital.
  ///
  /// In tr, this message translates to:
  /// **'Hastane'**
  String get buildingHospital;

  /// No description provided for @buildingCommercial.
  ///
  /// In tr, this message translates to:
  /// **'Ticari / AVM'**
  String get buildingCommercial;

  /// No description provided for @buildingWarehouseNormal.
  ///
  /// In tr, this message translates to:
  /// **'Depo (normal ≤ 6 m)'**
  String get buildingWarehouseNormal;

  /// No description provided for @buildingWarehouseHigh.
  ///
  /// In tr, this message translates to:
  /// **'Depo (yüksek > 6 m)'**
  String get buildingWarehouseHigh;

  /// No description provided for @buildingIndustrial.
  ///
  /// In tr, this message translates to:
  /// **'Endüstriyel'**
  String get buildingIndustrial;

  /// No description provided for @defaultCeilingHeight.
  ///
  /// In tr, this message translates to:
  /// **'Varsayılan tavan yüksekliği: {height} m'**
  String defaultCeilingHeight(String height);

  /// No description provided for @editablePerRoom.
  ///
  /// In tr, this message translates to:
  /// **'Her odada ayrıca düzenlenebilir'**
  String get editablePerRoom;

  /// No description provided for @addFloorZone.
  ///
  /// In tr, this message translates to:
  /// **'Kat / Bölge Ekle'**
  String get addFloorZone;

  /// No description provided for @floorZone.
  ///
  /// In tr, this message translates to:
  /// **'Kat / Bölge'**
  String get floorZone;

  /// No description provided for @totalDetectors.
  ///
  /// In tr, this message translates to:
  /// **'Toplam Dedektör'**
  String get totalDetectors;

  /// No description provided for @detectorCount.
  ///
  /// In tr, this message translates to:
  /// **'{count} adet'**
  String detectorCount(int count);

  /// No description provided for @addRoomArea.
  ///
  /// In tr, this message translates to:
  /// **'Oda / Alan Ekle'**
  String get addRoomArea;

  /// No description provided for @editRoomArea.
  ///
  /// In tr, this message translates to:
  /// **'Oda Düzenle'**
  String get editRoomArea;

  /// No description provided for @roomAreaName.
  ///
  /// In tr, this message translates to:
  /// **'Oda / Alan Adı'**
  String get roomAreaName;

  /// No description provided for @roomAreaExample.
  ///
  /// In tr, this message translates to:
  /// **'örn. Yemekhane, Sunucu Odası…'**
  String get roomAreaExample;

  /// No description provided for @areaType.
  ///
  /// In tr, this message translates to:
  /// **'Alan Tipi'**
  String get areaType;

  /// No description provided for @validDimensions.
  ///
  /// In tr, this message translates to:
  /// **'Geçerli ölçüler giriniz.'**
  String get validDimensions;

  /// No description provided for @roomNameRequired.
  ///
  /// In tr, this message translates to:
  /// **'Oda adı boş bırakılamaz.'**
  String get roomNameRequired;

  /// No description provided for @roomStandard.
  ///
  /// In tr, this message translates to:
  /// **'Standart Oda'**
  String get roomStandard;

  /// No description provided for @roomOpenOffice.
  ///
  /// In tr, this message translates to:
  /// **'Açık Ofis'**
  String get roomOpenOffice;

  /// No description provided for @roomTechnical.
  ///
  /// In tr, this message translates to:
  /// **'Teknik / Tesisat'**
  String get roomTechnical;

  /// No description provided for @roomKitchen.
  ///
  /// In tr, this message translates to:
  /// **'Mutfak / Pişirme'**
  String get roomKitchen;

  /// No description provided for @roomCorridor.
  ///
  /// In tr, this message translates to:
  /// **'Koridor (G ≤ 3 m)'**
  String get roomCorridor;

  /// No description provided for @roomProduction.
  ///
  /// In tr, this message translates to:
  /// **'Üretim / Montaj'**
  String get roomProduction;

  /// No description provided for @roomWarehouseRack.
  ///
  /// In tr, this message translates to:
  /// **'Depo Rafı'**
  String get roomWarehouseRack;

  /// No description provided for @sourceLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kaynak'**
  String get sourceLabel;

  /// No description provided for @deleteProjectTitle.
  ///
  /// In tr, this message translates to:
  /// **'Projeyi Sil'**
  String get deleteProjectTitle;

  /// No description provided for @deleteProjectConfirm.
  ///
  /// In tr, this message translates to:
  /// **'\"{name}\" projesi silinecek. Emin misiniz?'**
  String deleteProjectConfirm(String name);

  /// No description provided for @noSavedProjects.
  ///
  /// In tr, this message translates to:
  /// **'Henüz kayıtlı proje yok'**
  String get noSavedProjects;

  /// No description provided for @saveProjectPrompt.
  ///
  /// In tr, this message translates to:
  /// **'Hesabı proje olarak kaydet'**
  String get saveProjectPrompt;

  /// No description provided for @saveProjectTitle.
  ///
  /// In tr, this message translates to:
  /// **'Projeyi Kaydet'**
  String get saveProjectTitle;

  /// No description provided for @projectName.
  ///
  /// In tr, this message translates to:
  /// **'Proje Adı'**
  String get projectName;

  /// No description provided for @projectNameExample.
  ///
  /// In tr, this message translates to:
  /// **'örn. Ofis Binası Zemin Kat'**
  String get projectNameExample;

  /// No description provided for @projectSaved.
  ///
  /// In tr, this message translates to:
  /// **'\"{name}\" kaydedildi'**
  String projectSaved(String name);

  /// No description provided for @copy.
  ///
  /// In tr, this message translates to:
  /// **'Kopyala'**
  String get copy;

  /// No description provided for @edit.
  ///
  /// In tr, this message translates to:
  /// **'Düzenle'**
  String get edit;

  /// No description provided for @floorZoneSummary.
  ///
  /// In tr, this message translates to:
  /// **'{areas} alan · {detectors} det.'**
  String floorZoneSummary(int areas, int detectors);

  /// No description provided for @detectorBadge.
  ///
  /// In tr, this message translates to:
  /// **'{count} det.'**
  String detectorBadge(int count);

  /// No description provided for @highCeilingNotice.
  ///
  /// In tr, this message translates to:
  /// **'⚠ H > 12 m — Işın tipi / ASD dedektör gereklidir (EN 54-12 / EN 54-20)'**
  String get highCeilingNotice;

  /// No description provided for @beamRecommendation.
  ///
  /// In tr, this message translates to:
  /// **'ℹ H = 8–12 m — Işın dedektör de değerlendirilebilir'**
  String get beamRecommendation;

  /// No description provided for @widthSpacing.
  ///
  /// In tr, this message translates to:
  /// **'Genişlik aralığı: {value} m'**
  String widthSpacing(Object value);

  /// No description provided for @lengthSpacing.
  ///
  /// In tr, this message translates to:
  /// **'Uzunluk aralığı: {value} m'**
  String lengthSpacing(Object value);

  /// No description provided for @wallDistanceWidth.
  ///
  /// In tr, this message translates to:
  /// **'Duvar mesafesi W: {value} m'**
  String wallDistanceWidth(Object value);

  /// No description provided for @wallDistanceLength.
  ///
  /// In tr, this message translates to:
  /// **'Duvar mesafesi L: {value} m'**
  String wallDistanceLength(Object value);

  /// No description provided for @corridorSpacing.
  ///
  /// In tr, this message translates to:
  /// **'Koridor aralığı: {value} m'**
  String corridorSpacing(Object value);

  /// No description provided for @wallDistance.
  ///
  /// In tr, this message translates to:
  /// **'Duvar mesafesi: {value} m'**
  String wallDistance(Object value);

  /// No description provided for @snAreaPerDetector.
  ///
  /// In tr, this message translates to:
  /// **'S_n = {value} m²/adet.'**
  String snAreaPerDetector(Object value);

  /// No description provided for @systemLanguage.
  ///
  /// In tr, this message translates to:
  /// **'Cihaz dili'**
  String get systemLanguage;

  /// No description provided for @turkish.
  ///
  /// In tr, this message translates to:
  /// **'Türkçe'**
  String get turkish;

  /// No description provided for @english.
  ///
  /// In tr, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @german.
  ///
  /// In tr, this message translates to:
  /// **'Deutsch'**
  String get german;

  /// No description provided for @loginSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Hesabınıza giriş yapın'**
  String get loginSubtitle;

  /// No description provided for @emailAddress.
  ///
  /// In tr, this message translates to:
  /// **'E-posta adresi'**
  String get emailAddress;

  /// No description provided for @emailRequired.
  ///
  /// In tr, this message translates to:
  /// **'E-posta gereklidir'**
  String get emailRequired;

  /// No description provided for @validEmailRequired.
  ///
  /// In tr, this message translates to:
  /// **'Geçerli bir e-posta girin'**
  String get validEmailRequired;

  /// No description provided for @password.
  ///
  /// In tr, this message translates to:
  /// **'Şifre'**
  String get password;

  /// No description provided for @passwordRequired.
  ///
  /// In tr, this message translates to:
  /// **'Şifre gereklidir'**
  String get passwordRequired;

  /// No description provided for @loggingIn.
  ///
  /// In tr, this message translates to:
  /// **'Giriş yapılıyor...'**
  String get loggingIn;

  /// No description provided for @login.
  ///
  /// In tr, this message translates to:
  /// **'Giriş Yap'**
  String get login;

  /// No description provided for @demoLogin.
  ///
  /// In tr, this message translates to:
  /// **'Demo ile Gir (Davlumbaz Söndürme)'**
  String get demoLogin;

  /// No description provided for @accountPrompt.
  ///
  /// In tr, this message translates to:
  /// **'Henüz hesabınız yok mu? '**
  String get accountPrompt;

  /// No description provided for @register.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt olun →'**
  String get register;

  /// No description provided for @preliminaryToolDisclaimer.
  ///
  /// In tr, this message translates to:
  /// **'Ön hesap aracıdır · Resmi proje hesabı değildir'**
  String get preliminaryToolDisclaimer;

  /// No description provided for @fireSafetyCalculator.
  ///
  /// In tr, this message translates to:
  /// **'Yangın Güvenliği Hesap Merkezi'**
  String get fireSafetyCalculator;

  /// No description provided for @fireLoadTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yangın Yükü Hesabı'**
  String get fireLoadTitle;

  /// No description provided for @fireLoadDescription.
  ///
  /// In tr, this message translates to:
  /// **'EN 1991-1-2 yangın yükü yoğunluğu ve ISO 14520 / EN 12845 söndürme maddesi hesabı'**
  String get fireLoadDescription;

  /// No description provided for @kitchenSuppressionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Davlumbaz Söndürme'**
  String get kitchenSuppressionTitle;

  /// No description provided for @kitchenSuppressionDescription.
  ///
  /// In tr, this message translates to:
  /// **'Ticari mutfak davlumbaz söndürme sistemi — NFPA 17A / TS EN 15751 / UL 300'**
  String get kitchenSuppressionDescription;

  /// No description provided for @gasSuppressionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Gazlı Söndürme Sistemi'**
  String get gasSuppressionTitle;

  /// No description provided for @gasSuppressionDescription.
  ///
  /// In tr, this message translates to:
  /// **'Toplam hacim gazlı söndürme ve baskı makineleri — TS EN 15004 / NFPA 2001 · FM-200 · Novec 1230 · CO₂ · inert gazlar'**
  String get gasSuppressionDescription;

  /// No description provided for @lithiumFireTitle.
  ///
  /// In tr, this message translates to:
  /// **'Lityum Pil Yangını'**
  String get lithiumFireTitle;

  /// No description provided for @lithiumFireDescription.
  ///
  /// In tr, this message translates to:
  /// **'ESS soğutma gereksinimi — ISO 3941:2026 · NFPA 855:2023 · IEC 62619 · FM Global DS 5-33'**
  String get lithiumFireDescription;

  /// No description provided for @sprinklerTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sprinkler Sistemi'**
  String get sprinklerTitle;

  /// No description provided for @sprinklerDescription.
  ///
  /// In tr, this message translates to:
  /// **'EN 12845 tehlike sınıfına dayalı hidrolik hesap, pompa ve boru çapı'**
  String get sprinklerDescription;

  /// No description provided for @smokeDetectionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Duman Algılama'**
  String get smokeDetectionTitle;

  /// No description provided for @smokeDetectionDescription.
  ///
  /// In tr, this message translates to:
  /// **'Dedektör yerleşimi ve oda tipleri — TS EN 54-7 / EN 54-14'**
  String get smokeDetectionDescription;

  /// No description provided for @smokeControlTitle.
  ///
  /// In tr, this message translates to:
  /// **'Duman Kontrolü'**
  String get smokeControlTitle;

  /// No description provided for @smokeControlDescription.
  ///
  /// In tr, this message translates to:
  /// **'Doğal ve mekanik tahliye, basınçlandırma — EN 12101-2 / EN 12101-3 / EN 12101-6'**
  String get smokeControlDescription;

  /// No description provided for @demoMode.
  ///
  /// In tr, this message translates to:
  /// **'DEMO MODU · Yalnızca \"Davlumbaz Söndürme\" modülü açıktır. Diğer modüller için hesap oluşturup abone olun.'**
  String get demoMode;

  /// No description provided for @standardSearch.
  ///
  /// In tr, this message translates to:
  /// **'Standart Arama'**
  String get standardSearch;

  /// No description provided for @standardSearchDescription.
  ///
  /// In tr, this message translates to:
  /// **'Yangın ve güvenlik standartları veritabanında numara, ad veya kategori ile arama'**
  String get standardSearchDescription;

  /// No description provided for @standardGuide.
  ///
  /// In tr, this message translates to:
  /// **'Standart Rehberi'**
  String get standardGuide;

  /// No description provided for @standardGuideDescription.
  ///
  /// In tr, this message translates to:
  /// **'Yangın sistemleri standart kategorileri, kapsam ve referans özeti'**
  String get standardGuideDescription;

  /// No description provided for @fireAndSuppression.
  ///
  /// In tr, this message translates to:
  /// **'Yangın Yükü & Söndürme'**
  String get fireAndSuppression;

  /// No description provided for @kitchenSuppression.
  ///
  /// In tr, this message translates to:
  /// **'Davlumbaz Söndürme'**
  String get kitchenSuppression;

  /// No description provided for @gasSuppression.
  ///
  /// In tr, this message translates to:
  /// **'Gazlı Söndürme Sistemi'**
  String get gasSuppression;

  /// No description provided for @printingSuppression.
  ///
  /// In tr, this message translates to:
  /// **'Baskı Makinesi Söndürme'**
  String get printingSuppression;

  /// No description provided for @sprinklerSystems.
  ///
  /// In tr, this message translates to:
  /// **'Sprinkler Sistemi'**
  String get sprinklerSystems;

  /// No description provided for @fireAlarm.
  ///
  /// In tr, this message translates to:
  /// **'Yangın Alarm & Algılama'**
  String get fireAlarm;

  /// No description provided for @fireExtinguishers.
  ///
  /// In tr, this message translates to:
  /// **'Yangın Söndürücüler'**
  String get fireExtinguishers;

  /// No description provided for @smokeControl.
  ///
  /// In tr, this message translates to:
  /// **'Duman Kontrolü & Tahliye'**
  String get smokeControl;

  /// No description provided for @savedProjects.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlı Projeler'**
  String get savedProjects;

  /// No description provided for @savedProjectsDescription.
  ///
  /// In tr, this message translates to:
  /// **'Kaydettiğiniz tüm hesap projeleri'**
  String get savedProjectsDescription;

  /// No description provided for @addStandard.
  ///
  /// In tr, this message translates to:
  /// **'Standart Ekle'**
  String get addStandard;

  /// No description provided for @allCategories.
  ///
  /// In tr, this message translates to:
  /// **'Tüm Kategoriler'**
  String get allCategories;

  /// No description provided for @standardSearchHint.
  ///
  /// In tr, this message translates to:
  /// **'Numara, ad veya kategori...'**
  String get standardSearchHint;

  /// No description provided for @standardsFound.
  ///
  /// In tr, this message translates to:
  /// **'{count} standart bulundu'**
  String standardsFound(int count);

  /// No description provided for @category.
  ///
  /// In tr, this message translates to:
  /// **'Kategori: {name}'**
  String category(String name);

  /// No description provided for @close.
  ///
  /// In tr, this message translates to:
  /// **'Kapat'**
  String get close;

  /// No description provided for @searchWeb.
  ///
  /// In tr, this message translates to:
  /// **'Web\'de Ara'**
  String get searchWeb;

  /// No description provided for @askAi.
  ///
  /// In tr, this message translates to:
  /// **'AI\'ya Sor'**
  String get askAi;

  /// No description provided for @moduleDisclaimer.
  ///
  /// In tr, this message translates to:
  /// **'MEVOS Fire · Yangın güvenliği ön hesap aracıdır, resmi proje hesabı değildir.'**
  String get moduleDisclaimer;

  /// No description provided for @hoodSystemDescription.
  ///
  /// In tr, this message translates to:
  /// **'Ticari mutfak davlumbaz söndürme sistemi boyutlandırması.\nReferans: NFPA 17A:2021 · TS EN 15751:2016 · UL 300 · Ansul R-102'**
  String get hoodSystemDescription;

  /// No description provided for @hoodEquipmentHeading.
  ///
  /// In tr, this message translates to:
  /// **'Davlumbaz Altı Ekipmanlar'**
  String get hoodEquipmentHeading;

  /// No description provided for @hoodEquipmentInstructions.
  ///
  /// In tr, this message translates to:
  /// **'Ekipman sayısını + / - ile ayarlayın. Seçime göre tehlike sınıfı otomatik hesaplanır.'**
  String get hoodEquipmentInstructions;

  /// No description provided for @hoodHazardClass.
  ///
  /// In tr, this message translates to:
  /// **'Tehlike Sınıfı: {category}'**
  String hoodHazardClass(Object category);

  /// No description provided for @hoodEquipmentScore.
  ///
  /// In tr, this message translates to:
  /// **'Ekipman puanı: {score} · {count} adet seçildi · < 2 › Düşük · 2–5 › Orta · ≥ 5 › Yüksek'**
  String hoodEquipmentScore(Object count, Object score);

  /// No description provided for @hoodFilterArea.
  ///
  /// In tr, this message translates to:
  /// **'Davlumbaz Filtre Alanı (iç ölçü)'**
  String get hoodFilterArea;

  /// No description provided for @singleLength.
  ///
  /// In tr, this message translates to:
  /// **'Uzunluk'**
  String get singleLength;

  /// No description provided for @singleWidth.
  ///
  /// In tr, this message translates to:
  /// **'Genişlik'**
  String get singleWidth;

  /// No description provided for @hazardLight.
  ///
  /// In tr, this message translates to:
  /// **'Hafif'**
  String get hazardLight;

  /// No description provided for @hazardMedium.
  ///
  /// In tr, this message translates to:
  /// **'Orta'**
  String get hazardMedium;

  /// No description provided for @hazardMediumHigh.
  ///
  /// In tr, this message translates to:
  /// **'Orta–Yüksek'**
  String get hazardMediumHigh;

  /// No description provided for @hazardHigh.
  ///
  /// In tr, this message translates to:
  /// **'Yüksek'**
  String get hazardHigh;

  /// No description provided for @hazardVeryHigh.
  ///
  /// In tr, this message translates to:
  /// **'Çok Yüksek'**
  String get hazardVeryHigh;

  /// No description provided for @hoodToastSandwichMachine.
  ///
  /// In tr, this message translates to:
  /// **'Tost / Sandviç Makinesi'**
  String get hoodToastSandwichMachine;

  /// No description provided for @hoodSmallElectricOven.
  ///
  /// In tr, this message translates to:
  /// **'Küçük Elektrikli Fırın'**
  String get hoodSmallElectricOven;

  /// No description provided for @hoodConvectionOven.
  ///
  /// In tr, this message translates to:
  /// **'Konveksiyon Fırın'**
  String get hoodConvectionOven;

  /// No description provided for @hoodSingleBurnerRange.
  ///
  /// In tr, this message translates to:
  /// **'Ocak (1 gözlü)'**
  String get hoodSingleBurnerRange;

  /// No description provided for @hoodDoubleBurnerRange.
  ///
  /// In tr, this message translates to:
  /// **'Ocak (2 gözlü)'**
  String get hoodDoubleBurnerRange;

  /// No description provided for @hoodFourToSixBurnerRange.
  ///
  /// In tr, this message translates to:
  /// **'Ocak (4–6 gözlü)'**
  String get hoodFourToSixBurnerRange;

  /// No description provided for @hoodWokRange.
  ///
  /// In tr, this message translates to:
  /// **'Wok Ocağı'**
  String get hoodWokRange;

  /// No description provided for @hoodDoubleWokRange.
  ///
  /// In tr, this message translates to:
  /// **'Çift Wok Ocağı'**
  String get hoodDoubleWokRange;

  /// No description provided for @hoodSalamanderGrill.
  ///
  /// In tr, this message translates to:
  /// **'Salamander Izgara'**
  String get hoodSalamanderGrill;

  /// No description provided for @hoodCharbroilerGrill.
  ///
  /// In tr, this message translates to:
  /// **'Charbroiler / Mangal'**
  String get hoodCharbroilerGrill;

  /// No description provided for @hoodFryerUpTo22L.
  ///
  /// In tr, this message translates to:
  /// **'Fritöz (≤ 22 L)'**
  String get hoodFryerUpTo22L;

  /// No description provided for @hoodFryerOver22L.
  ///
  /// In tr, this message translates to:
  /// **'Fritöz (> 22 L)'**
  String get hoodFryerOver22L;

  /// No description provided for @hoodTiltingSkillet.
  ///
  /// In tr, this message translates to:
  /// **'Devrilebilir Tava'**
  String get hoodTiltingSkillet;

  /// No description provided for @calculate.
  ///
  /// In tr, this message translates to:
  /// **'Hesapla'**
  String get calculate;

  /// No description provided for @calculateExtinguishingAgent.
  ///
  /// In tr, this message translates to:
  /// **'Söndürme Maddesini Hesapla'**
  String get calculateExtinguishingAgent;

  /// No description provided for @calculateCooling.
  ///
  /// In tr, this message translates to:
  /// **'Soğutma Gereksinimini Hesapla'**
  String get calculateCooling;

  /// No description provided for @recalculate.
  ///
  /// In tr, this message translates to:
  /// **'Yeniden Hesapla'**
  String get recalculate;

  /// No description provided for @calculationResults.
  ///
  /// In tr, this message translates to:
  /// **'Hesap Sonuçları'**
  String get calculationResults;

  /// No description provided for @noResults.
  ///
  /// In tr, this message translates to:
  /// **'Sonuç bulunamadı'**
  String get noResults;

  /// No description provided for @extinguishingAgent.
  ///
  /// In tr, this message translates to:
  /// **'Söndürme Maddesi'**
  String get extinguishingAgent;

  /// No description provided for @chemicalAgentAmount.
  ///
  /// In tr, this message translates to:
  /// **'Kimyasal Ajan Miktarı'**
  String get chemicalAgentAmount;

  /// No description provided for @minimumNozzleCount.
  ///
  /// In tr, this message translates to:
  /// **'Min. Nozul Sayısı'**
  String get minimumNozzleCount;

  /// No description provided for @minimumDischargeTime.
  ///
  /// In tr, this message translates to:
  /// **'Min. Deşarj Süresi'**
  String get minimumDischargeTime;

  /// No description provided for @systemType.
  ///
  /// In tr, this message translates to:
  /// **'Sistem Türü'**
  String get systemType;

  /// No description provided for @naturalExhaust.
  ///
  /// In tr, this message translates to:
  /// **'Doğal Tahliye'**
  String get naturalExhaust;

  /// No description provided for @mechanicalExhaust.
  ///
  /// In tr, this message translates to:
  /// **'Mekanik Tahliye'**
  String get mechanicalExhaust;

  /// No description provided for @pressurization.
  ///
  /// In tr, this message translates to:
  /// **'Basınçlandırma'**
  String get pressurization;

  /// No description provided for @roomArea.
  ///
  /// In tr, this message translates to:
  /// **'Oda Alanı'**
  String get roomArea;

  /// No description provided for @ceilingHeight.
  ///
  /// In tr, this message translates to:
  /// **'Tavan Yüksekliği'**
  String get ceilingHeight;

  /// No description provided for @designFirePower.
  ///
  /// In tr, this message translates to:
  /// **'Tasarım HRR (Yangın Gücü)'**
  String get designFirePower;

  /// No description provided for @ambientTemperature.
  ///
  /// In tr, this message translates to:
  /// **'Ortam Sıcaklığı'**
  String get ambientTemperature;

  /// No description provided for @doorWidth.
  ///
  /// In tr, this message translates to:
  /// **'Kapı Genişliği'**
  String get doorWidth;

  /// No description provided for @doorHeight.
  ///
  /// In tr, this message translates to:
  /// **'Kapı Yüksekliği'**
  String get doorHeight;

  /// No description provided for @stairShaftWidth.
  ///
  /// In tr, this message translates to:
  /// **'Merdiven Şaft Genişliği'**
  String get stairShaftWidth;

  /// No description provided for @stairShaftDepth.
  ///
  /// In tr, this message translates to:
  /// **'Merdiven Şaft Derinliği'**
  String get stairShaftDepth;

  /// No description provided for @floorHeight.
  ///
  /// In tr, this message translates to:
  /// **'Kat Yüksekliği'**
  String get floorHeight;

  /// No description provided for @floorCount.
  ///
  /// In tr, this message translates to:
  /// **'Kat Sayısı'**
  String get floorCount;

  /// No description provided for @shaftWallMaterial.
  ///
  /// In tr, this message translates to:
  /// **'Şaft Duvarı Malzemesi'**
  String get shaftWallMaterial;

  /// No description provided for @extinguishingDesignResult.
  ///
  /// In tr, this message translates to:
  /// **'Söndürme Boyutlandırma Sonucu'**
  String get extinguishingDesignResult;

  /// No description provided for @smokeTemperature.
  ///
  /// In tr, this message translates to:
  /// **'Duman Sıcaklığı'**
  String get smokeTemperature;

  /// No description provided for @temperatureRise.
  ///
  /// In tr, this message translates to:
  /// **'Sıcaklık Artışı'**
  String get temperatureRise;

  /// No description provided for @effectiveOpening.
  ///
  /// In tr, this message translates to:
  /// **'Gerekli efektif açıklık'**
  String get effectiveOpening;

  /// No description provided for @freshAirInlet.
  ///
  /// In tr, this message translates to:
  /// **'Min. taze hava girişi'**
  String get freshAirInlet;

  /// No description provided for @fanDesignFlow.
  ///
  /// In tr, this message translates to:
  /// **'Fan tasarım debisi'**
  String get fanDesignFlow;

  /// No description provided for @calculatedAirChanges.
  ///
  /// In tr, this message translates to:
  /// **'Hesaplanan hava değişimi'**
  String get calculatedAirChanges;

  /// No description provided for @targetPressureDifference.
  ///
  /// In tr, this message translates to:
  /// **'Hedef basınç farkı'**
  String get targetPressureDifference;

  /// No description provided for @openDoorFlow.
  ///
  /// In tr, this message translates to:
  /// **'Açık kapı geçiş debisi'**
  String get openDoorFlow;

  /// No description provided for @closedDoorLeakage.
  ///
  /// In tr, this message translates to:
  /// **'Kapalı kapı sızıntısı / kat'**
  String get closedDoorLeakage;

  /// No description provided for @wallLeakage.
  ///
  /// In tr, this message translates to:
  /// **'Duvar sızıntısı (tüm katlar)'**
  String get wallLeakage;

  /// No description provided for @totalFanFlow.
  ///
  /// In tr, this message translates to:
  /// **'Toplam fan debisi'**
  String get totalFanFlow;

  /// No description provided for @sourceStandards.
  ///
  /// In tr, this message translates to:
  /// **'Referans Standartlar'**
  String get sourceStandards;

  /// No description provided for @unknown.
  ///
  /// In tr, this message translates to:
  /// **'Bilinmiyor'**
  String get unknown;

  /// No description provided for @smokeControlStandards.
  ///
  /// In tr, this message translates to:
  /// **'EN 12101-2 Doğal · EN 12101-3 Mekanik · EN 12101-6 Basınçlandırma'**
  String get smokeControlStandards;

  /// No description provided for @designFirePowerHint.
  ///
  /// In tr, this message translates to:
  /// **'Tasarım yangın gücü — EN 1991-1-2 Ek E. Örn: orta tehlike ofis ≈ 500 kW'**
  String get designFirePowerHint;

  /// No description provided for @unknownFirePowerButton.
  ///
  /// In tr, this message translates to:
  /// **'HRR değerini bilmiyorum — Yangın yükü hesabı yap'**
  String get unknownFirePowerButton;

  /// No description provided for @smokeLayerHeight.
  ///
  /// In tr, this message translates to:
  /// **'Duman Katmanı Taban Yüksekliği z'**
  String get smokeLayerHeight;

  /// No description provided for @smokeLayerHeightHint.
  ///
  /// In tr, this message translates to:
  /// **'Temiz hava katmanının üst sınırı (zeminden ölçülür). z < H olmalı. Hedef z ≥ 2,5 m'**
  String get smokeLayerHeightHint;

  /// No description provided for @pressurizationConditions.
  ///
  /// In tr, this message translates to:
  /// **'Hedef ΔP = 50 Pa, kapı aralığı 10 mm (EN 12101-6 §7.3.3 / Ek F Tablo F.1)'**
  String get pressurizationConditions;

  /// No description provided for @naturalExhaustResult.
  ///
  /// In tr, this message translates to:
  /// **'Doğal Tahliye Sonuçları (EN 12101-2)'**
  String get naturalExhaustResult;

  /// No description provided for @mechanicalExhaustResult.
  ///
  /// In tr, this message translates to:
  /// **'Mekanik Tahliye Sonuçları (EN 12101-3)'**
  String get mechanicalExhaustResult;

  /// No description provided for @pressurizationResult.
  ///
  /// In tr, this message translates to:
  /// **'Basınçlandırma Sonuçları (EN 12101-6)'**
  String get pressurizationResult;

  /// No description provided for @smokeMassFlow.
  ///
  /// In tr, this message translates to:
  /// **'Duman kütle debisi'**
  String get smokeMassFlow;

  /// No description provided for @smokeVolumeFlow.
  ///
  /// In tr, this message translates to:
  /// **'Hacimsel duman debisi'**
  String get smokeVolumeFlow;

  /// No description provided for @minimumFreshAir.
  ///
  /// In tr, this message translates to:
  /// **'Min. taze hava girişi'**
  String get minimumFreshAir;

  /// No description provided for @batteryTechnology.
  ///
  /// In tr, this message translates to:
  /// **'Pil Teknolojisi'**
  String get batteryTechnology;

  /// No description provided for @nmcDescription.
  ///
  /// In tr, this message translates to:
  /// **'Nikel-Manganez-Kobalt · 30 MJ/kWh — Yüksek yoğunluk, orta stabilite'**
  String get nmcDescription;

  /// No description provided for @lfpDescription.
  ///
  /// In tr, this message translates to:
  /// **'Lityum Demir Fosfat · 12 MJ/kWh — Düşük ısı, yüksek güvenlik'**
  String get lfpDescription;

  /// No description provided for @ncaDescription.
  ///
  /// In tr, this message translates to:
  /// **'Nikel-Kobalt-Alüminyum · 35 MJ/kWh — En yüksek enerji yoğunluğu'**
  String get ncaDescription;

  /// No description provided for @lcoDescription.
  ///
  /// In tr, this message translates to:
  /// **'Lityum Kobalt Oksit · 35 MJ/kWh — Tüketici elektroniği'**
  String get lcoDescription;

  /// No description provided for @essLithiumFireInfo.
  ///
  /// In tr, this message translates to:
  /// **'ISO 3941:2026 · NFPA 855:2023 · IEC 62619:2022 · FM Global DS 5-33\nLityum iyon/polimer pil yangınlarında termik kaçış (thermal runaway) nedeniyle gazlı baskılama değil soğutma esastır. Aşağıdaki hesap ön boyutlandırma amaçlıdır.'**
  String get essLithiumFireInfo;

  /// No description provided for @nmcThermalRunawayNote.
  ///
  /// In tr, this message translates to:
  /// **'NMC/NCM: Nikel-Manganez-Kobalt — 30 MJ/kWh termik kaçış ısısı (IEC 62619)'**
  String get nmcThermalRunawayNote;

  /// No description provided for @lfpThermalRunawayNote.
  ///
  /// In tr, this message translates to:
  /// **'LFP: Lityum Demir Fosfat — 12 MJ/kWh termik kaçış ısısı (IEC 62619)'**
  String get lfpThermalRunawayNote;

  /// No description provided for @ncaThermalRunawayNote.
  ///
  /// In tr, this message translates to:
  /// **'NCA: Nikel-Kobalt-Alüminyum — 35 MJ/kWh termik kaçış ısısı (IEC 62619)'**
  String get ncaThermalRunawayNote;

  /// No description provided for @lcoThermalRunawayNote.
  ///
  /// In tr, this message translates to:
  /// **'LCO: Lityum Kobalt Oksit — 35 MJ/kWh termik kaçış ısısı (IEC 62619)'**
  String get lcoThermalRunawayNote;

  /// No description provided for @hazardClassificationBasisNote.
  ///
  /// In tr, this message translates to:
  /// **'NFPA 855:2023 §4.4.2 — Tehlike sınıflandırmasına esas'**
  String get hazardClassificationBasisNote;

  /// No description provided for @fmGlobalMinDurationNote.
  ///
  /// In tr, this message translates to:
  /// **'FM Global DS 5-33 min. süre: 30 dk  —  NFPA 855:2023 §12.4'**
  String get fmGlobalMinDurationNote;

  /// No description provided for @essHazardCategoryInfo.
  ///
  /// In tr, this message translates to:
  /// **'NFPA 855:2023 Tehlike Kategorisi & FM DS 5-33 Uygulama Yoğunluğu:\n  • Düşük  (< 20 kWh)  ›  8,2 L/min/m²\n  • Orta   (20–600 kWh)  ›  12,2 L/min/m²\n  • Yüksek (> 600 kWh)  ›  16,3 L/min/m²'**
  String get essHazardCategoryInfo;

  /// No description provided for @essResultsFooterNote.
  ///
  /// In tr, this message translates to:
  /// **'• Isı katsayısı: NMC 30 · LFP 12 · NCA/LCO 35 MJ/kWh  (IEC 62619:2022)\n• Tepe HRR katsayısı: NMC 3,0 · LFP 1,5 · NCA/LCO 3,5 kW/kWh  (SP 2022:08)\n• t² büyüme: α=0,0469 kW/s² (hızlı sınıf · ISO 16734 / NFPA 72)\n• F-500 konsantrasyonu: %1,5 (üretici test verisi — Enviro Voraxial)\n• Su sisi alternatif: NFPA 750 / TS EN 14972-1\n• Büyük ESS (> 600 kWh): IEC 63272, UL 9540A testleri zorunludur\n• Bu hesap ön boyutlandırma amaçlıdır. FM Global DS 5-33 onaylı sistem zorunludur.'**
  String get essResultsFooterNote;

  /// No description provided for @evLithiumFireInfo.
  ///
  /// In tr, this message translates to:
  /// **'ISO 6469 · NFPA 88A:2021 · VdS 3471:2023 · IEC 62619:2022\nElektrikli araç yangınlarında termik kaçış soğutma ile yönetilir; gazlı veya kuru baskılama etkisizdir.'**
  String get evLithiumFireInfo;

  /// No description provided for @passengerCarSpecNote.
  ///
  /// In tr, this message translates to:
  /// **'Otomobil — 30–100 kWh\n400–600 L/min · 60 dk min. (VdS 3471)'**
  String get passengerCarSpecNote;

  /// No description provided for @lightCommercialSpecNote.
  ///
  /// In tr, this message translates to:
  /// **'Van / Minibüs — 60–120 kWh\n600 L/min · 60 dk min.'**
  String get lightCommercialSpecNote;

  /// No description provided for @heavyCommercialSpecNote.
  ///
  /// In tr, this message translates to:
  /// **'Elektrikli otobüs/kamyon — 200–600 kWh\n1 000 L/min · 90 dk min.'**
  String get heavyCommercialSpecNote;

  /// No description provided for @nmcHeatValue.
  ///
  /// In tr, this message translates to:
  /// **'Nikel-Manganez-Kobalt — 30 MJ/kWh'**
  String get nmcHeatValue;

  /// No description provided for @lfpHeatValue.
  ///
  /// In tr, this message translates to:
  /// **'Lityum Demir Fosfat — 12 MJ/kWh'**
  String get lfpHeatValue;

  /// No description provided for @ncaHeatValue.
  ///
  /// In tr, this message translates to:
  /// **'Nikel-Kobalt-Alüminyum — 35 MJ/kWh'**
  String get ncaHeatValue;

  /// No description provided for @lcoHeatValue.
  ///
  /// In tr, this message translates to:
  /// **'Lityum Kobalt Oksit — 35 MJ/kWh'**
  String get lcoHeatValue;

  /// No description provided for @vehicleBatteryCapacityNote.
  ///
  /// In tr, this message translates to:
  /// **'Tek araç batarya kapasitesi — IEC 62619 termik kaçış hesabına esas'**
  String get vehicleBatteryCapacityNote;

  /// No description provided for @maxSimultaneousVehiclesNote.
  ///
  /// In tr, this message translates to:
  /// **'VdS 3471:2023 — maks. 2 araç eş zamanlı yanma kabul edilir'**
  String get maxSimultaneousVehiclesNote;

  /// No description provided for @vehicleApplicationDurationNote.
  ///
  /// In tr, this message translates to:
  /// **'Binek / Hafif ticari min. 60 dk · Ağır ticari min. 90 dk  (VdS 3471:2023)'**
  String get vehicleApplicationDurationNote;

  /// No description provided for @vdsMinimumFlowInfo.
  ///
  /// In tr, this message translates to:
  /// **'VdS 3471:2023 Araç Başına Minimum Debi:\n  • Binek araç < 60 kWh  ›  400 L/min\n  • Binek araç ≥ 60 kWh  ›  600 L/min\n  • Hafif ticari           ›  600 L/min\n  • Ağır ticari / Otobüs  ›  1 000 L/min'**
  String get vdsMinimumFlowInfo;

  /// No description provided for @evResultsFooterNote.
  ///
  /// In tr, this message translates to:
  /// **'• Isı katsayısı: NMC 30 · LFP 12 · NCA/LCO 35 MJ/kWh  (IEC 62619:2022)\n• Tepe HRR: binek <60kWh›3MW, ?60kWh›6MW · hafif ticari›8MW · ağır›15MW  (SP 2021:11)\n• t² büyüme modeli: ?=0,1876 kW/s² (ultra-fast · ISO 16734 / NFPA 72 Tablo B.2.3)\n• Su debisi: VdS 3471:2023 — 2 araç eş zamanlı (otopark)\n• Container daldırma: 3 000 L/araç (BRE Global / SFPE)\n• Kapalı otopark: NFPA 88A:2021 sprinkler gereklidir\n• Bu hesap ön boyutlandırma amaçlıdır.'**
  String get evResultsFooterNote;

  /// No description provided for @heatPerVehicleMj.
  ///
  /// In tr, this message translates to:
  /// **'{value} MJ/araç'**
  String heatPerVehicleMj(String value);

  /// No description provided for @avgHrrPerVehicleMw.
  ///
  /// In tr, this message translates to:
  /// **'{value} MW/araç'**
  String avgHrrPerVehicleMw(String value);

  /// No description provided for @installedCapacity.
  ///
  /// In tr, this message translates to:
  /// **'Kurulu Kapasite (ESS)'**
  String get installedCapacity;

  /// No description provided for @protectedArea.
  ///
  /// In tr, this message translates to:
  /// **'Koruma Alanı (ESS ayak izi)'**
  String get protectedArea;

  /// No description provided for @applicationDuration.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama Süresi'**
  String get applicationDuration;

  /// No description provided for @batteryCapacity.
  ///
  /// In tr, this message translates to:
  /// **'Araç Batarya Kapasitesi'**
  String get batteryCapacity;

  /// No description provided for @vehicleCount.
  ///
  /// In tr, this message translates to:
  /// **'Araç Sayısı (risk bölgesi)'**
  String get vehicleCount;

  /// No description provided for @vehicleType.
  ///
  /// In tr, this message translates to:
  /// **'Araç Tipi'**
  String get vehicleType;

  /// No description provided for @passengerCar.
  ///
  /// In tr, this message translates to:
  /// **'Binek Araç'**
  String get passengerCar;

  /// No description provided for @lightCommercial.
  ///
  /// In tr, this message translates to:
  /// **'Hafif Ticari'**
  String get lightCommercial;

  /// No description provided for @heavyCommercialBus.
  ///
  /// In tr, this message translates to:
  /// **'Ağır Ticari / Otobüs'**
  String get heavyCommercialBus;

  /// No description provided for @essStationary.
  ///
  /// In tr, this message translates to:
  /// **'ESS / Sabit Depo'**
  String get essStationary;

  /// No description provided for @electricVehicleMode.
  ///
  /// In tr, this message translates to:
  /// **'Elektrikli Araç'**
  String get electricVehicleMode;

  /// No description provided for @coolingCalculationResult.
  ///
  /// In tr, this message translates to:
  /// **'Soğutma Hesabı Sonucu'**
  String get coolingCalculationResult;

  /// No description provided for @electricVehicleFireResult.
  ///
  /// In tr, this message translates to:
  /// **'Elektrikli Araç Yangın Hesabı'**
  String get electricVehicleFireResult;

  /// No description provided for @thermalRunawayHeat.
  ///
  /// In tr, this message translates to:
  /// **'Termik Kaçış Isısı'**
  String get thermalRunawayHeat;

  /// No description provided for @estimatedPeakHrr.
  ///
  /// In tr, this message translates to:
  /// **'Tahmini Tepe HRR'**
  String get estimatedPeakHrr;

  /// No description provided for @timeToPeak.
  ///
  /// In tr, this message translates to:
  /// **'Tepeye Ulaşma Süresi'**
  String get timeToPeak;

  /// No description provided for @minimumFlowRate.
  ///
  /// In tr, this message translates to:
  /// **'Minimum Debi'**
  String get minimumFlowRate;

  /// No description provided for @totalWaterVolume.
  ///
  /// In tr, this message translates to:
  /// **'Toplam Su Hacmi'**
  String get totalWaterVolume;

  /// No description provided for @f500Amount.
  ///
  /// In tr, this message translates to:
  /// **'F-500 Miktarı (%1,5 çözelti)'**
  String get f500Amount;

  /// No description provided for @averageHeatReleaseRate.
  ///
  /// In tr, this message translates to:
  /// **'Ortalama Isı Salım Hızı (HRR)'**
  String get averageHeatReleaseRate;

  /// No description provided for @vehicleMinimumFlow.
  ///
  /// In tr, this message translates to:
  /// **'Araç Başı Minimum Debi'**
  String get vehicleMinimumFlow;

  /// No description provided for @simultaneousVehicleFlow.
  ///
  /// In tr, this message translates to:
  /// **'Toplam Debi (en fazla 2 araç eş zamanlı)'**
  String get simultaneousVehicleFlow;

  /// No description provided for @containerImmersion.
  ///
  /// In tr, this message translates to:
  /// **'Container Daldırma (alternatif)'**
  String get containerImmersion;

  /// No description provided for @fireRiskCategory.
  ///
  /// In tr, this message translates to:
  /// **'NFPA 855 Tehlike Kategorisi'**
  String get fireRiskCategory;

  /// No description provided for @netProtectionVolume.
  ///
  /// In tr, this message translates to:
  /// **'Net Koruma Hacmi'**
  String get netProtectionVolume;

  /// No description provided for @minimumDesignTemperature.
  ///
  /// In tr, this message translates to:
  /// **'Min. Tasarım Sıcaklığı'**
  String get minimumDesignTemperature;

  /// No description provided for @altitudeCorrection.
  ///
  /// In tr, this message translates to:
  /// **'Rakım düzeltmesi (TS EN 15004-1 Ek A)'**
  String get altitudeCorrection;

  /// No description provided for @safetyMargin.
  ///
  /// In tr, this message translates to:
  /// **'%10 Güvenlik Payı (TS EN 15004-1 §5.5)'**
  String get safetyMargin;

  /// No description provided for @fireClass.
  ///
  /// In tr, this message translates to:
  /// **'Yangın Sınıfı'**
  String get fireClass;

  /// No description provided for @surfaceClassA.
  ///
  /// In tr, this message translates to:
  /// **'Sınıf A (Yüzey)'**
  String get surfaceClassA;

  /// No description provided for @deepClassA.
  ///
  /// In tr, this message translates to:
  /// **'Sınıf A (Derin)'**
  String get deepClassA;

  /// No description provided for @classB.
  ///
  /// In tr, this message translates to:
  /// **'Sınıf B'**
  String get classB;

  /// No description provided for @classC.
  ///
  /// In tr, this message translates to:
  /// **'Sınıf C'**
  String get classC;

  /// No description provided for @gasAgent.
  ///
  /// In tr, this message translates to:
  /// **'Söndürme Gazı'**
  String get gasAgent;

  /// No description provided for @designConcentration.
  ///
  /// In tr, this message translates to:
  /// **'Tasarım Konsantrasyonu (%)'**
  String get designConcentration;

  /// No description provided for @dischargeDuration.
  ///
  /// In tr, this message translates to:
  /// **'Deşarj Süresi'**
  String get dischargeDuration;

  /// No description provided for @nozzleDiameter.
  ///
  /// In tr, this message translates to:
  /// **'Nozul Çapı'**
  String get nozzleDiameter;

  /// No description provided for @automaticNozzle.
  ///
  /// In tr, this message translates to:
  /// **'Otomatik (alan/hacim bazlı)'**
  String get automaticNozzle;

  /// No description provided for @roomDimensions.
  ///
  /// In tr, this message translates to:
  /// **'Oda Ölçüsü'**
  String get roomDimensions;

  /// No description provided for @directVolume.
  ///
  /// In tr, this message translates to:
  /// **'Doğrudan Hacim'**
  String get directVolume;

  /// No description provided for @gasRoomTab.
  ///
  /// In tr, this message translates to:
  /// **'Mahal'**
  String get gasRoomTab;

  /// No description provided for @gasPrintingTab.
  ///
  /// In tr, this message translates to:
  /// **'Baskı Makinesi'**
  String get gasPrintingTab;

  /// No description provided for @gasPanelTab.
  ///
  /// In tr, this message translates to:
  /// **'Pano İçi'**
  String get gasPanelTab;

  /// No description provided for @machineType.
  ///
  /// In tr, this message translates to:
  /// **'Makine Tipi'**
  String get machineType;

  /// No description provided for @inkSolventType.
  ///
  /// In tr, this message translates to:
  /// **'Mürekkep / Çözücü Tipi'**
  String get inkSolventType;

  /// No description provided for @measureCabinet.
  ///
  /// In tr, this message translates to:
  /// **'Kabini Ölç'**
  String get measureCabinet;

  /// No description provided for @unitCabinetVolume.
  ///
  /// In tr, this message translates to:
  /// **'Ünite Kabini Hacmi'**
  String get unitCabinetVolume;

  /// No description provided for @printingUnitCount.
  ///
  /// In tr, this message translates to:
  /// **'Baskı Ünitesi Sayısı'**
  String get printingUnitCount;

  /// No description provided for @agentPerUnit.
  ///
  /// In tr, this message translates to:
  /// **'Ünite Başına Ajan'**
  String get agentPerUnit;

  /// No description provided for @totalAgent.
  ///
  /// In tr, this message translates to:
  /// **'Toplam Ajan'**
  String get totalAgent;

  /// No description provided for @backupCylinderCount.
  ///
  /// In tr, this message translates to:
  /// **'Yedek Besleme Silindir Sayısı'**
  String get backupCylinderCount;

  /// No description provided for @totalCylinders.
  ///
  /// In tr, this message translates to:
  /// **'Toplam Silindir (Ana + Yedek)'**
  String get totalCylinders;

  /// No description provided for @cleanAgent.
  ///
  /// In tr, this message translates to:
  /// **'Temiz Gaz'**
  String get cleanAgent;

  /// No description provided for @panelDimensions.
  ///
  /// In tr, this message translates to:
  /// **'Pano Ölçüsü'**
  String get panelDimensions;

  /// No description provided for @panelCabinetVolume.
  ///
  /// In tr, this message translates to:
  /// **'Pano/Kabin Hacmi'**
  String get panelCabinetVolume;

  /// No description provided for @standard.
  ///
  /// In tr, this message translates to:
  /// **'Standart'**
  String get standard;

  /// No description provided for @certification.
  ///
  /// In tr, this message translates to:
  /// **'Sertifikasyon'**
  String get certification;

  /// No description provided for @maximumTubingLength.
  ///
  /// In tr, this message translates to:
  /// **'Maks. Tubing Uzunluğu'**
  String get maximumTubingLength;

  /// No description provided for @estimatedAgentAmount.
  ///
  /// In tr, this message translates to:
  /// **'Tahmini Ajan Miktarı'**
  String get estimatedAgentAmount;

  /// No description provided for @buildingDimensions.
  ///
  /// In tr, this message translates to:
  /// **'Bina Boyutları'**
  String get buildingDimensions;

  /// No description provided for @buildingActivity.
  ///
  /// In tr, this message translates to:
  /// **'Bina Faaliyeti'**
  String get buildingActivity;

  /// No description provided for @activitySearch.
  ///
  /// In tr, this message translates to:
  /// **'Faaliyet ara…'**
  String get activitySearch;

  /// No description provided for @advancedDesignOptions.
  ///
  /// In tr, this message translates to:
  /// **'Gelişmiş Tasarım Seçenekleri'**
  String get advancedDesignOptions;

  /// No description provided for @pipeMaterial.
  ///
  /// In tr, this message translates to:
  /// **'Boru Malzemesi'**
  String get pipeMaterial;

  /// No description provided for @spPipeGalvanizedSteel.
  ///
  /// In tr, this message translates to:
  /// **'Galvanizli Çelik (Sch.40)'**
  String get spPipeGalvanizedSteel;

  /// No description provided for @spPipeBlackCarbonSteelWelded.
  ///
  /// In tr, this message translates to:
  /// **'Siyah Karbon Çelik — kaynaklı'**
  String get spPipeBlackCarbonSteelWelded;

  /// No description provided for @spPipeCopper.
  ///
  /// In tr, this message translates to:
  /// **'Bakır Boru'**
  String get spPipeCopper;

  /// No description provided for @spPipeStainlessSteel.
  ///
  /// In tr, this message translates to:
  /// **'Paslanmaz Çelik'**
  String get spPipeStainlessSteel;

  /// No description provided for @spPipeCpvcPlastic.
  ///
  /// In tr, this message translates to:
  /// **'CPVC Plastik Boru'**
  String get spPipeCpvcPlastic;

  /// No description provided for @sprinklerType.
  ///
  /// In tr, this message translates to:
  /// **'Sprinkler Tipi (K-Faktör)'**
  String get sprinklerType;

  /// No description provided for @installationClassPump.
  ///
  /// In tr, this message translates to:
  /// **'Kurulum Sınıfı / Pompa Yedekliliği'**
  String get installationClassPump;

  /// No description provided for @dryPipeSystem.
  ///
  /// In tr, this message translates to:
  /// **'Kuru borulu sistem (donma riskli alan)'**
  String get dryPipeSystem;

  /// No description provided for @rackStorage.
  ///
  /// In tr, this message translates to:
  /// **'Raf / palet depolama — In-Rack sprinkler (ön tasarım)'**
  String get rackStorage;

  /// No description provided for @rackLevels.
  ///
  /// In tr, this message translates to:
  /// **'Raf Kat Sayısı (in-rack seviyesi)'**
  String get rackLevels;

  /// No description provided for @foamSystem.
  ///
  /// In tr, this message translates to:
  /// **'Köpük Sistemi'**
  String get foamSystem;

  /// No description provided for @addFoamSystem.
  ///
  /// In tr, this message translates to:
  /// **'Köpük söndürme sistemi ekle (EN 13565-2)'**
  String get addFoamSystem;

  /// No description provided for @flammableLiquidCategory.
  ///
  /// In tr, this message translates to:
  /// **'Sıvı Yanıcı Kategorisi'**
  String get flammableLiquidCategory;

  /// No description provided for @hydrocarbon.
  ///
  /// In tr, this message translates to:
  /// **'Hidrokarbon (B1)'**
  String get hydrocarbon;

  /// No description provided for @polarSolvent.
  ///
  /// In tr, this message translates to:
  /// **'Polar Solvent (B2)'**
  String get polarSolvent;

  /// No description provided for @foamConcentrateType.
  ///
  /// In tr, this message translates to:
  /// **'Köpük Konsantresi Tipi'**
  String get foamConcentrateType;

  /// No description provided for @foamType.
  ///
  /// In tr, this message translates to:
  /// **'Köpük Tipi'**
  String get foamType;

  /// No description provided for @minimumApplicationTime.
  ///
  /// In tr, this message translates to:
  /// **'Minimum Uygulama Süresi'**
  String get minimumApplicationTime;

  /// No description provided for @ceilingSuspended.
  ///
  /// In tr, this message translates to:
  /// **'Asma Tavan'**
  String get ceilingSuspended;

  /// No description provided for @suspendedCeilingExists.
  ///
  /// In tr, this message translates to:
  /// **'Asma tavan mevcut (gizli boşluk)'**
  String get suspendedCeilingExists;

  /// No description provided for @voidDepth.
  ///
  /// In tr, this message translates to:
  /// **'Boşluk Derinliği (cm)'**
  String get voidDepth;

  /// No description provided for @building.
  ///
  /// In tr, this message translates to:
  /// **'Bina'**
  String get building;

  /// No description provided for @electricalPanel.
  ///
  /// In tr, this message translates to:
  /// **'Elektrik Panosu'**
  String get electricalPanel;

  /// No description provided for @fuelOrStorage.
  ///
  /// In tr, this message translates to:
  /// **'Yakıt / Depo'**
  String get fuelOrStorage;

  /// No description provided for @buildingUseType.
  ///
  /// In tr, this message translates to:
  /// **'Bina / Kullanım Türü'**
  String get buildingUseType;

  /// No description provided for @chooseBuildingUseType.
  ///
  /// In tr, this message translates to:
  /// **'Bina / Kullanım Türü Seçiniz'**
  String get chooseBuildingUseType;

  /// No description provided for @referenceDensity.
  ///
  /// In tr, this message translates to:
  /// **'Referans yoğunluk'**
  String get referenceDensity;

  /// No description provided for @growthRate.
  ///
  /// In tr, this message translates to:
  /// **'Büyüme hızı'**
  String get growthRate;

  /// No description provided for @growthRateVerySlow.
  ///
  /// In tr, this message translates to:
  /// **'Çok Yavaş'**
  String get growthRateVerySlow;

  /// No description provided for @growthRateSlow.
  ///
  /// In tr, this message translates to:
  /// **'Yavaş'**
  String get growthRateSlow;

  /// No description provided for @growthRateMedium.
  ///
  /// In tr, this message translates to:
  /// **'Orta'**
  String get growthRateMedium;

  /// No description provided for @growthRateFast.
  ///
  /// In tr, this message translates to:
  /// **'Hızlı'**
  String get growthRateFast;

  /// No description provided for @growthRateVeryFast.
  ///
  /// In tr, this message translates to:
  /// **'Çok Hızlı'**
  String get growthRateVeryFast;

  /// No description provided for @floorArea.
  ///
  /// In tr, this message translates to:
  /// **'Kat Alanı A (m²)'**
  String get floorArea;

  /// No description provided for @cabinetNozzlePressure.
  ///
  /// In tr, this message translates to:
  /// **'Yangın Dolabı Nozul Basıncı (min 4 bar)'**
  String get cabinetNozzlePressure;

  /// No description provided for @combustibleMaterials.
  ///
  /// In tr, this message translates to:
  /// **'Yanıcı Malzemeler'**
  String get combustibleMaterials;

  /// No description provided for @addMaterial.
  ///
  /// In tr, this message translates to:
  /// **'Malzeme Ekle'**
  String get addMaterial;

  /// No description provided for @woodTimber.
  ///
  /// In tr, this message translates to:
  /// **'Ahşap / Kereste'**
  String get woodTimber;

  /// No description provided for @savedValues.
  ///
  /// In tr, this message translates to:
  /// **'Kaydedilen Değerler'**
  String get savedValues;

  /// No description provided for @noSavedCalculationResult.
  ///
  /// In tr, this message translates to:
  /// **'Bu proje için kaydedilmiş hesap sonucu bulunamadı.'**
  String get noSavedCalculationResult;

  /// No description provided for @apiKeyEnter.
  ///
  /// In tr, this message translates to:
  /// **'Gemini API anahtarını girin'**
  String get apiKeyEnter;

  /// No description provided for @searchBuildingTypes.
  ///
  /// In tr, this message translates to:
  /// **'Bina türü ara…'**
  String get searchBuildingTypes;

  /// No description provided for @material.
  ///
  /// In tr, this message translates to:
  /// **'Malzeme'**
  String get material;

  /// No description provided for @massKg.
  ///
  /// In tr, this message translates to:
  /// **'Kütle (kg)'**
  String get massKg;

  /// No description provided for @netCalorificValue.
  ///
  /// In tr, this message translates to:
  /// **'NCV (MJ/kg)'**
  String get netCalorificValue;

  /// No description provided for @capacityTank.
  ///
  /// In tr, this message translates to:
  /// **'Kapasite / tank'**
  String get capacityTank;

  /// No description provided for @unit.
  ///
  /// In tr, this message translates to:
  /// **'Birim'**
  String get unit;

  /// No description provided for @quantity.
  ///
  /// In tr, this message translates to:
  /// **'Adet'**
  String get quantity;

  /// No description provided for @standardNumber.
  ///
  /// In tr, this message translates to:
  /// **'Standart Numarası *'**
  String get standardNumber;

  /// No description provided for @standardNumberExample.
  ///
  /// In tr, this message translates to:
  /// **'ör: EN 12345'**
  String get standardNumberExample;

  /// No description provided for @description.
  ///
  /// In tr, this message translates to:
  /// **'Açıklama *'**
  String get description;

  /// No description provided for @shortDescriptionHint.
  ///
  /// In tr, this message translates to:
  /// **'Standardın kısa açıklaması…'**
  String get shortDescriptionHint;

  /// No description provided for @topicKeyword.
  ///
  /// In tr, this message translates to:
  /// **'Konu veya Anahtar Kelime'**
  String get topicKeyword;

  /// No description provided for @topicKeywordExample.
  ///
  /// In tr, this message translates to:
  /// **'ör: baca brandası, ofis sprinkler…'**
  String get topicKeywordExample;

  /// No description provided for @questionHint.
  ///
  /// In tr, this message translates to:
  /// **'Sorunuzu yazın…'**
  String get questionHint;

  /// No description provided for @searchActivity.
  ///
  /// In tr, this message translates to:
  /// **'Faaliyet ara…'**
  String get searchActivity;

  /// No description provided for @unitWidth.
  ///
  /// In tr, this message translates to:
  /// **'G (m)'**
  String get unitWidth;

  /// No description provided for @unitLength.
  ///
  /// In tr, this message translates to:
  /// **'U (m)'**
  String get unitLength;

  /// No description provided for @unitHeight.
  ///
  /// In tr, this message translates to:
  /// **'H (m)'**
  String get unitHeight;

  /// No description provided for @searchMaterials.
  ///
  /// In tr, this message translates to:
  /// **'Malzeme ara…'**
  String get searchMaterials;

  /// No description provided for @solid.
  ///
  /// In tr, this message translates to:
  /// **'Katı'**
  String get solid;

  /// No description provided for @liquid.
  ///
  /// In tr, this message translates to:
  /// **'Sıvı'**
  String get liquid;

  /// No description provided for @gas.
  ///
  /// In tr, this message translates to:
  /// **'Gaz'**
  String get gas;

  /// No description provided for @other.
  ///
  /// In tr, this message translates to:
  /// **'Diğer'**
  String get other;

  /// No description provided for @lowHazardAppendix.
  ///
  /// In tr, this message translates to:
  /// **'Düşük Tehlike (Ek-1/A)'**
  String get lowHazardAppendix;

  /// No description provided for @ordinaryHazardAppendix.
  ///
  /// In tr, this message translates to:
  /// **'Orta Tehlike (Ek-1/B)'**
  String get ordinaryHazardAppendix;

  /// No description provided for @highHazardAppendix.
  ///
  /// In tr, this message translates to:
  /// **'Yüksek Tehlike (Ek-1/C)'**
  String get highHazardAppendix;

  /// No description provided for @unclassified.
  ///
  /// In tr, this message translates to:
  /// **'Sınıflandırılmamış'**
  String get unclassified;

  /// No description provided for @materialGroupCount.
  ///
  /// In tr, this message translates to:
  /// **'{category} · {count} malzeme'**
  String materialGroupCount(String category, int count);

  /// No description provided for @materialWoodTimber.
  ///
  /// In tr, this message translates to:
  /// **'Ahşap / Kereste'**
  String get materialWoodTimber;

  /// No description provided for @materialPlywoodMdf.
  ///
  /// In tr, this message translates to:
  /// **'Kontrplak / MDF'**
  String get materialPlywoodMdf;

  /// No description provided for @materialPaperCardboard.
  ///
  /// In tr, this message translates to:
  /// **'Kâğıt / Karton'**
  String get materialPaperCardboard;

  /// No description provided for @materialCottonTextile.
  ///
  /// In tr, this message translates to:
  /// **'Tekstil (pamuklu)'**
  String get materialCottonTextile;

  /// No description provided for @materialSyntheticTextile.
  ///
  /// In tr, this message translates to:
  /// **'Tekstil (sentetik)'**
  String get materialSyntheticTextile;

  /// No description provided for @materialWool.
  ///
  /// In tr, this message translates to:
  /// **'Yün'**
  String get materialWool;

  /// No description provided for @materialClothing.
  ///
  /// In tr, this message translates to:
  /// **'Giysi'**
  String get materialClothing;

  /// No description provided for @materialLeather.
  ///
  /// In tr, this message translates to:
  /// **'Deri'**
  String get materialLeather;

  /// No description provided for @materialPolyethylene.
  ///
  /// In tr, this message translates to:
  /// **'Polietilen (PE)'**
  String get materialPolyethylene;

  /// No description provided for @materialPolypropylene.
  ///
  /// In tr, this message translates to:
  /// **'Polipropilen (PP)'**
  String get materialPolypropylene;

  /// No description provided for @materialRigidPvc.
  ///
  /// In tr, this message translates to:
  /// **'PVC (sert)'**
  String get materialRigidPvc;

  /// No description provided for @materialFlexiblePvc.
  ///
  /// In tr, this message translates to:
  /// **'PVC (esnek/kablo)'**
  String get materialFlexiblePvc;

  /// No description provided for @materialPolystyrene.
  ///
  /// In tr, this message translates to:
  /// **'Polistiren (PS)'**
  String get materialPolystyrene;

  /// No description provided for @materialEpsFoam.
  ///
  /// In tr, this message translates to:
  /// **'EPS köpük'**
  String get materialEpsFoam;

  /// No description provided for @materialXpsFoam.
  ///
  /// In tr, this message translates to:
  /// **'XPS köpük'**
  String get materialXpsFoam;

  /// No description provided for @materialAbsPlastic.
  ///
  /// In tr, this message translates to:
  /// **'ABS Plastik'**
  String get materialAbsPlastic;

  /// No description provided for @materialPmma.
  ///
  /// In tr, this message translates to:
  /// **'PMMA (Pleksiglas)'**
  String get materialPmma;

  /// No description provided for @materialEpoxyResin.
  ///
  /// In tr, this message translates to:
  /// **'Epoksi Reçine'**
  String get materialEpoxyResin;

  /// No description provided for @materialPolyesterResin.
  ///
  /// In tr, this message translates to:
  /// **'Polyester Reçine (CTP/FRP)'**
  String get materialPolyesterResin;

  /// No description provided for @materialRigidPolyurethaneFoam.
  ///
  /// In tr, this message translates to:
  /// **'Poliüretan köpük (sert)'**
  String get materialRigidPolyurethaneFoam;

  /// No description provided for @materialFlexiblePolyurethaneFoam.
  ///
  /// In tr, this message translates to:
  /// **'Poliüretan köpük (esnek)'**
  String get materialFlexiblePolyurethaneFoam;

  /// No description provided for @materialNaturalRubber.
  ///
  /// In tr, this message translates to:
  /// **'Kauçuk (doğal)'**
  String get materialNaturalRubber;

  /// No description provided for @materialVehicleTire.
  ///
  /// In tr, this message translates to:
  /// **'Lastik (araç)'**
  String get materialVehicleTire;

  /// No description provided for @materialGasoline.
  ///
  /// In tr, this message translates to:
  /// **'Benzin'**
  String get materialGasoline;

  /// No description provided for @materialDiesel.
  ///
  /// In tr, this message translates to:
  /// **'Dizel'**
  String get materialDiesel;

  /// No description provided for @materialLpg.
  ///
  /// In tr, this message translates to:
  /// **'LPG'**
  String get materialLpg;

  /// No description provided for @materialPropane.
  ///
  /// In tr, this message translates to:
  /// **'Propan'**
  String get materialPropane;

  /// No description provided for @materialNaturalGasCng.
  ///
  /// In tr, this message translates to:
  /// **'Doğalgaz (CNG)'**
  String get materialNaturalGasCng;

  /// No description provided for @materialMethanol.
  ///
  /// In tr, this message translates to:
  /// **'Metanol'**
  String get materialMethanol;

  /// No description provided for @materialEthanol.
  ///
  /// In tr, this message translates to:
  /// **'Etanol'**
  String get materialEthanol;

  /// No description provided for @materialAcetoneSolvent.
  ///
  /// In tr, this message translates to:
  /// **'Aseton / Solvent (genel)'**
  String get materialAcetoneSolvent;

  /// No description provided for @materialSolventBasedPaint.
  ///
  /// In tr, this message translates to:
  /// **'Boya / Vernik (solventli)'**
  String get materialSolventBasedPaint;

  /// No description provided for @materialAsphaltBitumen.
  ///
  /// In tr, this message translates to:
  /// **'Asfalt / Bitüm'**
  String get materialAsphaltBitumen;

  /// No description provided for @materialCoal.
  ///
  /// In tr, this message translates to:
  /// **'Kömür'**
  String get materialCoal;

  /// No description provided for @materialMineralTransformerOil.
  ///
  /// In tr, this message translates to:
  /// **'Trafo Yağı (mineral)'**
  String get materialMineralTransformerOil;

  /// No description provided for @materialHydraulicOil.
  ///
  /// In tr, this message translates to:
  /// **'Hidrolik Yağ'**
  String get materialHydraulicOil;

  /// No description provided for @materialPvcCable.
  ///
  /// In tr, this message translates to:
  /// **'Elektrik Kablosu (PVC)'**
  String get materialPvcCable;

  /// No description provided for @materialXlpeCable.
  ///
  /// In tr, this message translates to:
  /// **'Elektrik Kablosu (XLPE)'**
  String get materialXlpeCable;

  /// No description provided for @materialLithiumIonBattery.
  ///
  /// In tr, this message translates to:
  /// **'Li-ion Batarya'**
  String get materialLithiumIonBattery;

  /// No description provided for @materialMixedFurniture.
  ///
  /// In tr, this message translates to:
  /// **'Mobilya (karma)'**
  String get materialMixedFurniture;

  /// No description provided for @materialOtherManual.
  ///
  /// In tr, this message translates to:
  /// **'Diğer (manuel)'**
  String get materialOtherManual;

  /// No description provided for @fireLoadFormulaInfo.
  ///
  /// In tr, this message translates to:
  /// **'q = (m × H) / A\nm = yanıcı malzeme kütlesi (kg)  ·  H = NCV (MJ/kg)  ·  A = kat alanı (m²)'**
  String get fireLoadFormulaInfo;

  /// No description provided for @panelInnerDimensions.
  ///
  /// In tr, this message translates to:
  /// **'Pano İç Ölçüleri (cm)'**
  String get panelInnerDimensions;

  /// No description provided for @panelWidth.
  ///
  /// In tr, this message translates to:
  /// **'Genişlik'**
  String get panelWidth;

  /// No description provided for @panelHeight.
  ///
  /// In tr, this message translates to:
  /// **'Yükseklik'**
  String get panelHeight;

  /// No description provided for @panelDepth.
  ///
  /// In tr, this message translates to:
  /// **'Derinlik'**
  String get panelDepth;

  /// No description provided for @cableFillRatio.
  ///
  /// In tr, this message translates to:
  /// **'Kablo dolum oranı: % {value}'**
  String cableFillRatio(Object value);

  /// No description provided for @fuelStorageInstructions.
  ///
  /// In tr, this message translates to:
  /// **'Her tank türü, adedi ve kapasitesini girin.\nLPG için ton, sıvı yakıtlar için m³ veya ton kullanabilirsiniz.\nYangın yükü yoğunluğu için bund/havuz alanı opsiyoneldir.'**
  String get fuelStorageInstructions;

  /// No description provided for @fuelChemicalTanks.
  ///
  /// In tr, this message translates to:
  /// **'Yakıt / Kimyasal Tanklar'**
  String get fuelChemicalTanks;

  /// No description provided for @totalApproxMass.
  ///
  /// In tr, this message translates to:
  /// **'Toplam yaklaşık kütle: {value} ton'**
  String totalApproxMass(Object value);

  /// No description provided for @bundPoolArea.
  ///
  /// In tr, this message translates to:
  /// **'Bund / Havuz Alanı  (m²)  —  opsiyonel'**
  String get bundPoolArea;

  /// No description provided for @fireLoadDensityIfEntered.
  ///
  /// In tr, this message translates to:
  /// **'Girilirse yangın yükü yoğunluğu (MJ/m²) hesaplanır.'**
  String get fireLoadDensityIfEntered;

  /// No description provided for @ventilationLimitedQmaxInclude.
  ///
  /// In tr, this message translates to:
  /// **'Havalandırma sınırlı Q_max hesabına dahil et (opsiyonel)'**
  String get ventilationLimitedQmaxInclude;

  /// No description provided for @ventilationLimitedQmaxNote.
  ///
  /// In tr, this message translates to:
  /// **'Not: Varsayılan hesap yalnızca yakıt yüzeyi sınırlı Q_max (RHRf×A) kullanır; açıklık (pencere/kapı) sınırlı Q_max hesaba katılmaz (EN 1991-1-2 Ek E).'**
  String get ventilationLimitedQmaxNote;

  /// No description provided for @openingArea.
  ///
  /// In tr, this message translates to:
  /// **'Açıklık (Pencere/Kapı) Alanı  Aᵥ'**
  String get openingArea;

  /// No description provided for @openingHeight.
  ///
  /// In tr, this message translates to:
  /// **'Açıklık Yüksekliği  h_eq'**
  String get openingHeight;

  /// No description provided for @openingAreaHeightExplanation.
  ///
  /// In tr, this message translates to:
  /// **'Aᵥ: mahaldeki tüm pencere/kapı açıklıklarının toplam alanı  ·  h_eq: bu açıklıkların ortalama yüksekliği (mahal/oda yüksekliği DEĞİL).'**
  String get openingAreaHeightExplanation;

  /// No description provided for @ventilationQmaxFormulaNote.
  ///
  /// In tr, this message translates to:
  /// **'Q̇ₘₐₓ,ᵥ ≈ 0,09×Aᵥ×√h_eq × Hu_ort × 0,8  —  yaklaşık Kawagoe ventilasyon faktörü (Drysdale / SFPE); kesin tasarım için tam açıklık faktörü hesabı gereklidir.'**
  String get ventilationQmaxFormulaNote;

  /// No description provided for @totalFireEnergyLabel.
  ///
  /// In tr, this message translates to:
  /// **'TOPLAM YANGIN ENERJİSİ'**
  String get totalFireEnergyLabel;

  /// No description provided for @totalEnergy.
  ///
  /// In tr, this message translates to:
  /// **'Toplam Enerji'**
  String get totalEnergy;

  /// No description provided for @totalEnergyGJ.
  ///
  /// In tr, this message translates to:
  /// **'Toplam Enerji (GJ)'**
  String get totalEnergyGJ;

  /// No description provided for @totalEnergyMWh.
  ///
  /// In tr, this message translates to:
  /// **'Toplam Enerji (MWh)'**
  String get totalEnergyMWh;

  /// No description provided for @totalEnergyGWh.
  ///
  /// In tr, this message translates to:
  /// **'Toplam Enerji (GWh)'**
  String get totalEnergyGWh;

  /// No description provided for @bundAreaIfEnteredNote.
  ///
  /// In tr, this message translates to:
  /// **'Bund/havuz alanı girilirse yangın yükü yoğunluğu (MJ/m²) hesaplanır.'**
  String get bundAreaIfEnteredNote;

  /// No description provided for @calculationResultLabel.
  ///
  /// In tr, this message translates to:
  /// **'HESAPLAMA SONUCU'**
  String get calculationResultLabel;

  /// No description provided for @totalFireLoad.
  ///
  /// In tr, this message translates to:
  /// **'Toplam Yangın Yükü'**
  String get totalFireLoad;

  /// No description provided for @fireLoadDensityLabel.
  ///
  /// In tr, this message translates to:
  /// **'Yangın Yükü Yoğunluğu  q'**
  String get fireLoadDensityLabel;

  /// No description provided for @exceedsReferenceLabel.
  ///
  /// In tr, this message translates to:
  /// **'^ +{value} MJ/m² — Referansı AŞIYOR'**
  String exceedsReferenceLabel(Object value);

  /// No description provided for @belowReferenceLabel.
  ///
  /// In tr, this message translates to:
  /// **' {value} MJ/m² — Referans Altında'**
  String belowReferenceLabel(Object value);

  /// No description provided for @fireGrowthTimeline.
  ///
  /// In tr, this message translates to:
  /// **'Yangın Büyüme Takvimi (EN 1991-1-2 E.4)'**
  String get fireGrowthTimeline;

  /// No description provided for @growthPhaseEnd.
  ///
  /// In tr, this message translates to:
  /// **'Büyüme fazı sonu'**
  String get growthPhaseEnd;

  /// No description provided for @decayPhaseStart.
  ///
  /// In tr, this message translates to:
  /// **'Bozunma başlangıcı (% 70 tüketim)'**
  String get decayPhaseStart;

  /// No description provided for @totalFireDuration.
  ///
  /// In tr, this message translates to:
  /// **'Toplam yangın süresi'**
  String get totalFireDuration;

  /// No description provided for @peakHeatReleaseLabel.
  ///
  /// In tr, this message translates to:
  /// **'Tepe Q̇: {value} MW  ·  Sınırlayan faktör: {factor}'**
  String peakHeatReleaseLabel(Object factor, Object value);

  /// No description provided for @limitingFactorFuelSurface.
  ///
  /// In tr, this message translates to:
  /// **'Yakıt Yüzeyi (RHRf × A)'**
  String get limitingFactorFuelSurface;

  /// No description provided for @limitingFactorTotalEnergy.
  ///
  /// In tr, this message translates to:
  /// **'Toplam Enerji (düşük yangın yükü)'**
  String get limitingFactorTotalEnergy;

  /// No description provided for @limitingFactorVentilation.
  ///
  /// In tr, this message translates to:
  /// **'Havalandırma (açıklık — yaklaşık)'**
  String get limitingFactorVentilation;

  /// No description provided for @extinguishingAgentCalcTitle.
  ///
  /// In tr, this message translates to:
  /// **'Söndürme Maddesi Hesabı'**
  String get extinguishingAgentCalcTitle;

  /// No description provided for @panelVolumeHeight.
  ///
  /// In tr, this message translates to:
  /// **'Hacim yüksekliği (pano): {value}'**
  String panelVolumeHeight(Object value);

  /// No description provided for @panelAgentRecommendation.
  ///
  /// In tr, this message translates to:
  /// **'Elektrik panosu için FM-200 (HFC-227ea) veya Novec 1230 önerilir — ISO 14520 / NFPA 2001.'**
  String get panelAgentRecommendation;

  /// No description provided for @extinguishingAgentLabel.
  ///
  /// In tr, this message translates to:
  /// **'Söndürme Maddesi'**
  String get extinguishingAgentLabel;

  /// No description provided for @altitudeCorrectionLabel.
  ///
  /// In tr, this message translates to:
  /// **'Rakım düzeltmesi (ISO 14520-1 Ek A)'**
  String get altitudeCorrectionLabel;

  /// No description provided for @altitudeLabel.
  ///
  /// In tr, this message translates to:
  /// **'Rakım (m)'**
  String get altitudeLabel;

  /// No description provided for @requiredAgent.
  ///
  /// In tr, this message translates to:
  /// **'Gerekli Ajan'**
  String get requiredAgent;

  /// No description provided for @requiredAgentMass.
  ///
  /// In tr, this message translates to:
  /// **'Gerekli Ajan Kütlesi'**
  String get requiredAgentMass;

  /// No description provided for @cylinderCountApprox.
  ///
  /// In tr, this message translates to:
  /// **'Şişe Sayısı (80L/200bar≈16Nm³)'**
  String get cylinderCountApprox;

  /// No description provided for @cylinderContainerCount.
  ///
  /// In tr, this message translates to:
  /// **'Şişe / Kap Sayısı'**
  String get cylinderContainerCount;

  /// No description provided for @portableExtinguisherTitle.
  ///
  /// In tr, this message translates to:
  /// **'Taşınabilir Yangın Söndürücü (TS 862-7 EN 3-7)'**
  String get portableExtinguisherTitle;

  /// No description provided for @fireLoadSourcesFooter.
  ///
  /// In tr, this message translates to:
  /// **'Kaynak: EN 1991-1-2:2002 Ek E · ISO 14520 · EN 12845 · TS 862-7 EN 3-7+A1'**
  String get fireLoadSourcesFooter;

  /// No description provided for @portableExtinguisherSourceFooter.
  ///
  /// In tr, this message translates to:
  /// **'Kaynak: TS 862-7 EN 3-7+A1 (2010) · BYKHY Madde 94-96'**
  String get portableExtinguisherSourceFooter;

  /// No description provided for @fireCabinetSourceFooter.
  ///
  /// In tr, this message translates to:
  /// **'Kaynak: BYKHY Md. 91-93 · TS EN 671-1 · TS 9811'**
  String get fireCabinetSourceFooter;

  /// No description provided for @fireCabinetTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yangın Dolabı (BYKHY Md. 91-93 / TS EN 671-1)'**
  String get fireCabinetTitle;

  /// No description provided for @fireCabinetTechSpecs.
  ///
  /// In tr, this message translates to:
  /// **'DN25 (1\") yarı sert hortumlu makara · TS EN 671-1 · K=50\nQ = K × √P = 50 × √{p} bar = {flow} L/min\nPratik söndürme kapasitesi:\n  {capacity}'**
  String fireCabinetTechSpecs(Object capacity, Object flow, Object p);

  /// No description provided for @classACapacityPerCabinet.
  ///
  /// In tr, this message translates to:
  /// **'A sınıfı: 2.0 MW/dolap'**
  String get classACapacityPerCabinet;

  /// No description provided for @classBCapacityPerCabinet.
  ///
  /// In tr, this message translates to:
  /// **'B sınıfı: 0.6 MW/dolap'**
  String get classBCapacityPerCabinet;

  /// No description provided for @hazardClassLabel.
  ///
  /// In tr, this message translates to:
  /// **'Tehlike sınıfı'**
  String get hazardClassLabel;

  /// No description provided for @hazardClassLow.
  ///
  /// In tr, this message translates to:
  /// **'Düşük'**
  String get hazardClassLow;

  /// No description provided for @hazardClassMedium.
  ///
  /// In tr, this message translates to:
  /// **'Orta'**
  String get hazardClassMedium;

  /// No description provided for @hazardClassHigh.
  ///
  /// In tr, this message translates to:
  /// **'Yüksek'**
  String get hazardClassHigh;

  /// No description provided for @requiredCabinetCount.
  ///
  /// In tr, this message translates to:
  /// **'Gerekli dolap adedi'**
  String get requiredCabinetCount;

  /// No description provided for @totalExtinguishingCapacityLabel.
  ///
  /// In tr, this message translates to:
  /// **'Toplam söndürme kapasitesi'**
  String get totalExtinguishingCapacityLabel;

  /// No description provided for @waterReserveVolumeLabel.
  ///
  /// In tr, this message translates to:
  /// **'Su rezerv hacmi ({minutes} dk)'**
  String waterReserveVolumeLabel(Object minutes);

  /// No description provided for @cabinetSufficientLabel.
  ///
  /// In tr, this message translates to:
  /// **'{count} dolap YETERLİ  —  söndürme {q} MW ≥ yangın yükü {load} MW'**
  String cabinetSufficientLabel(Object count, Object load, Object q);

  /// No description provided for @cabinetInsufficientLabel.
  ///
  /// In tr, this message translates to:
  /// **'{count} dolap YETERSİZ  —  söndürme {q} MW < yangın yükü {load} MW (min {minNeeded} dolap gerekli)'**
  String cabinetInsufficientLabel(
    Object count,
    Object load,
    Object minNeeded,
    Object q,
  );

  /// No description provided for @roomHeightLabel.
  ///
  /// In tr, this message translates to:
  /// **'Oda Yüksekliği (m)'**
  String get roomHeightLabel;

  /// No description provided for @fireClassPanel.
  ///
  /// In tr, this message translates to:
  /// **'Sınıf B/C (elektrik ekipmanı yağı / gaz) — Toz veya CO₂'**
  String get fireClassPanel;

  /// No description provided for @fireClassGasStorage.
  ///
  /// In tr, this message translates to:
  /// **'Sınıf C (sıkıştırılmış yanıcı gaz) — KKP Toz, CO₂ veya Köpük'**
  String get fireClassGasStorage;

  /// No description provided for @fireClassLiquidGasStorage.
  ///
  /// In tr, this message translates to:
  /// **'Sınıf B + Sınıf C (sıvı/gaz yakıt) — KKP ABC Toz veya Köpük'**
  String get fireClassLiquidGasStorage;

  /// No description provided for @fireClassLiquidStorage.
  ///
  /// In tr, this message translates to:
  /// **'Sınıf B (yanıcı sıvı) — ABC Kuru Kimyevi Toz veya Köpük'**
  String get fireClassLiquidStorage;

  /// No description provided for @fireClassSolidLiquidStorage.
  ///
  /// In tr, this message translates to:
  /// **'Sınıf A + Sınıf B (katı/sıvı yanıcı) — ABC Kuru Kimyevi Toz'**
  String get fireClassSolidLiquidStorage;

  /// No description provided for @fireClassParking.
  ///
  /// In tr, this message translates to:
  /// **'Sınıf B (sıvı yakıt) — ABC Toz veya Köpük'**
  String get fireClassParking;

  /// No description provided for @fireClassSolidDefault.
  ///
  /// In tr, this message translates to:
  /// **'Sınıf A (katı yanıcı) — ABC Kuru Kimyevi Toz veya Su'**
  String get fireClassSolidDefault;

  /// No description provided for @riskClassLow.
  ///
  /// In tr, this message translates to:
  /// **'Düşük Risk  (≤ 200 MJ/m²)'**
  String get riskClassLow;

  /// No description provided for @riskClassMedium.
  ///
  /// In tr, this message translates to:
  /// **'Orta Risk  (200–600 MJ/m²)'**
  String get riskClassMedium;

  /// No description provided for @riskClassHigh.
  ///
  /// In tr, this message translates to:
  /// **'Yüksek Risk  (600–1200 MJ/m²)'**
  String get riskClassHigh;

  /// No description provided for @riskClassVeryHigh.
  ///
  /// In tr, this message translates to:
  /// **'Çok Yüksek Risk  (> 1200 MJ/m²)'**
  String get riskClassVeryHigh;

  /// No description provided for @loginServerUnreachable.
  ///
  /// In tr, this message translates to:
  /// **'Sunucuya bağlanılamadı. İnternet bağlantınızı kontrol edin.'**
  String get loginServerUnreachable;

  /// No description provided for @genericErrorWithDetail.
  ///
  /// In tr, this message translates to:
  /// **'Hata: {detail}'**
  String genericErrorWithDetail(String detail);

  /// No description provided for @fireModuleSubscriptionMissing.
  ///
  /// In tr, this message translates to:
  /// **'Yangın modülü aboneliğiniz bulunmuyor. Hesabınızdan abonelik başlatın.\nSunucudan gelen perms: {perms}'**
  String fireModuleSubscriptionMissing(String perms);

  /// No description provided for @loginFailed.
  ///
  /// In tr, this message translates to:
  /// **'Giriş başarısız'**
  String get loginFailed;

  /// No description provided for @sessionNotFoundRelogin.
  ///
  /// In tr, this message translates to:
  /// **'Oturum bulunamadı. Lütfen yeniden giriş yapın.'**
  String get sessionNotFoundRelogin;

  /// No description provided for @accountDeleteFailed.
  ///
  /// In tr, this message translates to:
  /// **'Hesap silinemedi.'**
  String get accountDeleteFailed;

  /// No description provided for @enterPanelInnerDimensionsCm.
  ///
  /// In tr, this message translates to:
  /// **'Pano iç ölçülerini eksiksiz giriniz (cm).'**
  String get enterPanelInnerDimensionsCm;

  /// No description provided for @addAtLeastOneFuelTank.
  ///
  /// In tr, this message translates to:
  /// **'En az bir yakıt deposu ekleyiniz.'**
  String get addAtLeastOneFuelTank;

  /// No description provided for @enterQuantityForFuel.
  ///
  /// In tr, this message translates to:
  /// **'\"{name}\" için miktar giriniz.'**
  String enterQuantityForFuel(String name);

  /// No description provided for @enterValidFloorAreaM2.
  ///
  /// In tr, this message translates to:
  /// **'Geçerli kat alanı giriniz (m²).'**
  String get enterValidFloorAreaM2;

  /// No description provided for @materialMassMissing.
  ///
  /// In tr, this message translates to:
  /// **'\"{name}\" kütlesi eksik.'**
  String materialMassMissing(String name);

  /// No description provided for @materialNcvMissing.
  ///
  /// In tr, this message translates to:
  /// **'\"{name}\" ısıl değeri eksik.'**
  String materialNcvMissing(String name);

  /// No description provided for @calculateFireLoadFirst.
  ///
  /// In tr, this message translates to:
  /// **'Önce Yangın Yükü hesaplayınız.'**
  String get calculateFireLoadFirst;

  /// No description provided for @enterValidArea.
  ///
  /// In tr, this message translates to:
  /// **'Geçerli alan giriniz.'**
  String get enterValidArea;

  /// No description provided for @enterRoomHeightM.
  ///
  /// In tr, this message translates to:
  /// **'Oda yüksekliğini giriniz (m).'**
  String get enterRoomHeightM;

  /// No description provided for @enterHoodLengthWidthCm.
  ///
  /// In tr, this message translates to:
  /// **'Davlumbaz uzunluk ve genişliğini giriniz (cm).'**
  String get enterHoodLengthWidthCm;

  /// No description provided for @enterRoomDimensionsFullyM.
  ///
  /// In tr, this message translates to:
  /// **'Oda ölçülerini eksiksiz giriniz (m).'**
  String get enterRoomDimensionsFullyM;

  /// No description provided for @enterNetProtectedVolumeM3.
  ///
  /// In tr, this message translates to:
  /// **'Net koruma hacmini giriniz (m³).'**
  String get enterNetProtectedVolumeM3;

  /// No description provided for @enterValidConcentrationPercent.
  ///
  /// In tr, this message translates to:
  /// **'Geçerli bir konsantrasyon değeri giriniz (0–100%).'**
  String get enterValidConcentrationPercent;

  /// No description provided for @enterValidUnitCount1to50.
  ///
  /// In tr, this message translates to:
  /// **'Geçerli ünite sayısı giriniz (1–50).'**
  String get enterValidUnitCount1to50;

  /// No description provided for @enterMachineCabinDimensionsFullyM.
  ///
  /// In tr, this message translates to:
  /// **'Makine kabini ölçülerini eksiksiz giriniz (m).'**
  String get enterMachineCabinDimensionsFullyM;

  /// No description provided for @enterUnitCabinVolumeM3.
  ///
  /// In tr, this message translates to:
  /// **'Ünite kabini hacmini giriniz (m³).'**
  String get enterUnitCabinVolumeM3;

  /// No description provided for @enterPanelCabinDimensionsFullyM.
  ///
  /// In tr, this message translates to:
  /// **'Pano/kabin ölçülerini eksiksiz giriniz (m).'**
  String get enterPanelCabinDimensionsFullyM;

  /// No description provided for @enterPanelCabinVolumeM3.
  ///
  /// In tr, this message translates to:
  /// **'Pano/kabin hacmini giriniz (m³).'**
  String get enterPanelCabinVolumeM3;

  /// No description provided for @enterRoomAreaM2.
  ///
  /// In tr, this message translates to:
  /// **'Oda alanı giriniz (m²).'**
  String get enterRoomAreaM2;

  /// No description provided for @enterCeilingHeightM.
  ///
  /// In tr, this message translates to:
  /// **'Tavan yüksekliğini giriniz (m).'**
  String get enterCeilingHeightM;

  /// No description provided for @enterDesignHrrKw.
  ///
  /// In tr, this message translates to:
  /// **'Tasarım HRR giriniz (kW).'**
  String get enterDesignHrrKw;

  /// No description provided for @smokeLayerHeightRangeError.
  ///
  /// In tr, this message translates to:
  /// **'Duman katmanı taban yüksekliği: 0 < z < H'**
  String get smokeLayerHeightRangeError;

  /// No description provided for @enterInstalledCapacityKwh.
  ///
  /// In tr, this message translates to:
  /// **'Kurulu kapasiteyi giriniz (kWh).'**
  String get enterInstalledCapacityKwh;

  /// No description provided for @enterProtectionAreaM2.
  ///
  /// In tr, this message translates to:
  /// **'Koruma alanını giriniz (m²).'**
  String get enterProtectionAreaM2;

  /// No description provided for @enterApplicationDurationMin.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama süresini giriniz (dk).'**
  String get enterApplicationDurationMin;

  /// No description provided for @enterVehicleBatteryCapacityKwh.
  ///
  /// In tr, this message translates to:
  /// **'Araç batarya kapasitesini giriniz (kWh).'**
  String get enterVehicleBatteryCapacityKwh;

  /// No description provided for @enterVehicleCount.
  ///
  /// In tr, this message translates to:
  /// **'Araç sayısını giriniz.'**
  String get enterVehicleCount;

  /// No description provided for @enterValidBuildingWidthM.
  ///
  /// In tr, this message translates to:
  /// **'Geçerli bina eni giriniz (m).'**
  String get enterValidBuildingWidthM;

  /// No description provided for @enterValidBuildingLengthM.
  ///
  /// In tr, this message translates to:
  /// **'Geçerli bina boyu giriniz (m).'**
  String get enterValidBuildingLengthM;

  /// No description provided for @selectBuildingActivity.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen bina faaliyetini seçiniz.'**
  String get selectBuildingActivity;

  /// No description provided for @enterCeilingHeightSimpleM.
  ///
  /// In tr, this message translates to:
  /// **'Tavan yüksekliği giriniz (m).'**
  String get enterCeilingHeightSimpleM;

  /// No description provided for @hoodHideComparison.
  ///
  /// In tr, this message translates to:
  /// **'Karşılaştırmayı Gizle'**
  String get hoodHideComparison;

  /// No description provided for @hoodCompareAgents.
  ///
  /// In tr, this message translates to:
  /// **'Maddeleri Karşılaştır'**
  String get hoodCompareAgents;

  /// No description provided for @hoodTableAgentCol.
  ///
  /// In tr, this message translates to:
  /// **'Madde'**
  String get hoodTableAgentCol;

  /// No description provided for @hoodTableEffectivenessCol.
  ///
  /// In tr, this message translates to:
  /// **'Etkinlik'**
  String get hoodTableEffectivenessCol;

  /// No description provided for @hoodColLowAbbr.
  ///
  /// In tr, this message translates to:
  /// **'D'**
  String get hoodColLowAbbr;

  /// No description provided for @hoodColMediumAbbr.
  ///
  /// In tr, this message translates to:
  /// **'O'**
  String get hoodColMediumAbbr;

  /// No description provided for @hoodColHighAbbr.
  ///
  /// In tr, this message translates to:
  /// **'Y'**
  String get hoodColHighAbbr;

  /// No description provided for @hoodComparisonLegend.
  ///
  /// In tr, this message translates to:
  /// **'D = Düşük  ·  O = Orta  ·  Y = Yüksek tehlike sınıfı\nRenkli sütun = hesaplanan tehlike sınıfı'**
  String get hoodComparisonLegend;

  /// No description provided for @hoodResultTitleCaps.
  ///
  /// In tr, this message translates to:
  /// **'SÖNDÜRME BOYUTLANDIRMA SONUCU'**
  String get hoodResultTitleCaps;

  /// No description provided for @hoodNfpa96RequirementsTitle.
  ///
  /// In tr, this message translates to:
  /// **'NFPA 96 Zorunlu Gereklilikler'**
  String get hoodNfpa96RequirementsTitle;

  /// No description provided for @hoodReqFuelElectric.
  ///
  /// In tr, this message translates to:
  /// **'Yakıt & Elektrik Kesilmesi (§10.4): Sistem devreye girdiğinde tüm ısı kaynaklarının yakıtı ve elektriği otomatik kesilmelidir. Manuel sıfırlama gerekir.'**
  String get hoodReqFuelElectric;

  /// No description provided for @hoodReqManualPull.
  ///
  /// In tr, this message translates to:
  /// **'Manuel Çekme Kolu (§10.5): Yerden 1067–1219 mm yükseklikte, davlumbazdan min. 3 m – maks. 6 m uzaklıkta, kaçış yolu üzerinde konumlandırılmalıdır.'**
  String get hoodReqManualPull;

  /// No description provided for @hoodReqAlarm.
  ///
  /// In tr, this message translates to:
  /// **'Alarm (§10.6): Sistem aktivasyonunda sesli alarm veya görsel gösterge zorunludur.'**
  String get hoodReqAlarm;

  /// No description provided for @hoodReqFanMakeupAir.
  ///
  /// In tr, this message translates to:
  /// **'Fan & Takviye Hava (§8.2.3 / §8.3.2): Egzoz fanı aktivasyon sonrası çalışmaya devam eder. Hood içi takviye hava (makeup air) sistem aktivasyonunda kesilir.'**
  String get hoodReqFanMakeupAir;

  /// No description provided for @hoodReqClassKExtinguisher.
  ///
  /// In tr, this message translates to:
  /// **'Sınıf K Söndürücü (§10.10.2): Bitkisel / hayvansal yağ kullanan ekipmanlar için Sınıf K yangın söndürücü zorunludur.'**
  String get hoodReqClassKExtinguisher;

  /// No description provided for @hoodReqFilterDistance.
  ///
  /// In tr, this message translates to:
  /// **'Filtre Mesafesi (§6.2.1): Filtre alt kenarı – pişirme yüzeyi arası en az 457 mm (18 in.).{warning}'**
  String hoodReqFilterDistance(String warning);

  /// No description provided for @hoodFilterDistanceWarning.
  ///
  /// In tr, this message translates to:
  /// **'Charbroiler/mangal mevcut → Filtre alt kenarı ile pişirme yüzeyi arası en az 1220 mm (4 ft) (NFPA 96 §6.2.1.2)'**
  String get hoodFilterDistanceWarning;

  /// No description provided for @hoodReqMaintenance.
  ///
  /// In tr, this message translates to:
  /// **'Bakım (§11.2.1): Sertifikalı teknisyen tarafından en az 6 ayda bir bakım. Ergitme bağlantıları (fusible link) 6 ayda bir değiştirilir (§11.2.4).'**
  String get hoodReqMaintenance;

  /// No description provided for @hoodReqCleaningFrequency.
  ///
  /// In tr, this message translates to:
  /// **'Temizlik Sıklığı (Tablo 11.4): {frequency}.'**
  String hoodReqCleaningFrequency(String frequency);

  /// No description provided for @hoodCleaningFreqHighVolume.
  ///
  /// In tr, this message translates to:
  /// **'3 ayda bir (wok / charbroiler / büyük fritöz)'**
  String get hoodCleaningFreqHighVolume;

  /// No description provided for @hoodCleaningFreqLow.
  ///
  /// In tr, this message translates to:
  /// **'Yıllık (düşük hacimli)'**
  String get hoodCleaningFreqLow;

  /// No description provided for @hoodCleaningFreqMedium.
  ///
  /// In tr, this message translates to:
  /// **'6 ayda bir (orta hacimli)'**
  String get hoodCleaningFreqMedium;

  /// No description provided for @hoodReqSimultaneousOperation.
  ///
  /// In tr, this message translates to:
  /// **'Eşzamanlı Çalışma (§10.3): Tek tehlike bölgesindeki tüm sabit söndürme sistemleri aynı anda devreye girmelidir.'**
  String get hoodReqSimultaneousOperation;

  /// No description provided for @hoodReqFryerDistance.
  ///
  /// In tr, this message translates to:
  /// **'Fritöz Mesafesi (§12.1.2.4): Fritöz, açık alev kaynaklarından yatayda min. 406 mm (16 in.) uzakta olmalıdır. Ara plaka (baffle) kullanıldığında min. 203 mm (8 in.) yükseklik yeterlidir (§12.1.2.5).{warning}'**
  String hoodReqFryerDistance(String warning);

  /// No description provided for @hoodFryerDistanceWarning.
  ///
  /// In tr, this message translates to:
  /// **'Fritöz mevcut → Açık alev kaynaklarından yatayda min. 406 mm (16 in.) uzakta konumlandırılmalıdır (§12.1.2.4). Ara plaka (baffle) kullanılıyorsa min. 203 mm (8 in.) yükseklik yeterlidir (§12.1.2.5).'**
  String get hoodFryerDistanceWarning;

  /// No description provided for @hoodReqFryerHighTempLimiter.
  ///
  /// In tr, this message translates to:
  /// **'Fritöz Yüksek Sıcaklık Sınırlayıcısı (§12.2): Derin yağda kızartma ekipmanında otomatik sıcaklık sınırlayıcı zorunludur. Yağ yüzeyinden 25,4 mm (1 in.) aşağıda 246°C (475°F) sıcaklığa ulaştığında ısı kaynağını otomatik olarak keser.'**
  String get hoodReqFryerHighTempLimiter;

  /// No description provided for @hoodReqHoodDuctClearance.
  ///
  /// In tr, this message translates to:
  /// **'Davlumbaz / Kanal Mesafeleri (§4.2.1): Yanıcı yüzeylere min. 457 mm (18 in.), sınırlı yanıcı yüzeylere min. 76 mm (3 in.), yanmaz yüzeylere 0 mm boşluk bırakılabilir.'**
  String get hoodReqHoodDuctClearance;

  /// No description provided for @hoodReqDuctSlope.
  ///
  /// In tr, this message translates to:
  /// **'Kanal Eğimi (§7.1.4): Yatay kanal uzunluğu ≤ 22,86 m (75 ft) ise min. %2, > 22,86 m (75 ft) ise min. %8 eğim uygulanmalıdır (gres birikiminin tahliyesi için).'**
  String get hoodReqDuctSlope;

  /// No description provided for @hoodReqDuctFireBarrier.
  ///
  /// In tr, this message translates to:
  /// **'Kanal Yangın Bölmesi Direnci (§7.7.2.1): Kanal geçişleri için yangın bölmesi: < 4 katlı yapılar → min. 1 saatlik yangına dayanıklı bölme; ≥ 4 katlı yapılar → min. 2 saatlik yangına dayanıklı bölme.'**
  String get hoodReqDuctFireBarrier;

  /// No description provided for @hoodNotesText.
  ///
  /// In tr, this message translates to:
  /// **'NFPA 17A §7.3 — {agent} uygulaması.\nTehlike sınıfı: {hazardClass}  ·  Ekipman puanı: {score}  ·  Min. deşarj: 30 s  ·  Filtre alanı: {area} m².\nEk baca / kanallar için ek nozul hesabı yapılmalıdır.'**
  String hoodNotesText(
    String agent,
    String hazardClass,
    String score,
    String area,
  );

  /// No description provided for @hoodAgentPotassiumCarbonateName.
  ///
  /// In tr, this message translates to:
  /// **'Potasyum Karbonat'**
  String get hoodAgentPotassiumCarbonateName;

  /// No description provided for @hoodAgentPotassiumAcetateName.
  ///
  /// In tr, this message translates to:
  /// **'Potasyum Asetat'**
  String get hoodAgentPotassiumAcetateName;

  /// No description provided for @hoodAgentPotassiumCitrateName.
  ///
  /// In tr, this message translates to:
  /// **'Potasyum Sitrat'**
  String get hoodAgentPotassiumCitrateName;

  /// No description provided for @hoodAgentSodiumBicarbonateName.
  ///
  /// In tr, this message translates to:
  /// **'Sodyum Bikarbonat'**
  String get hoodAgentSodiumBicarbonateName;

  /// No description provided for @hoodAgentPotassiumCarbonateDesc.
  ///
  /// In tr, this message translates to:
  /// **'En yaygın. Yağ/yüzey yangınlarına karşı etkili.'**
  String get hoodAgentPotassiumCarbonateDesc;

  /// No description provided for @hoodAgentPotassiumAcetateDesc.
  ///
  /// In tr, this message translates to:
  /// **'Yüksek verimli. Ansul R-102, Amerex B500 sistemleri.'**
  String get hoodAgentPotassiumAcetateDesc;

  /// No description provided for @hoodAgentPotassiumCitrateDesc.
  ///
  /// In tr, this message translates to:
  /// **'Paslanmaz çelik ekipmanlara uyumlu. Korozyon riski düşük.'**
  String get hoodAgentPotassiumCitrateDesc;

  /// No description provided for @hoodAgentSodiumBicarbonateDesc.
  ///
  /// In tr, this message translates to:
  /// **'Eski nesil. Düşük maliyetli, sınırlı etkinlik.'**
  String get hoodAgentSodiumBicarbonateDesc;

  /// No description provided for @hoodAgentPotassiumCarbonateReco.
  ///
  /// In tr, this message translates to:
  /// **'Genel amaçlı. Her tehlike sınıfı için uygundur.'**
  String get hoodAgentPotassiumCarbonateReco;

  /// No description provided for @hoodAgentPotassiumAcetateReco.
  ///
  /// In tr, this message translates to:
  /// **'Yüksek tehlike için birinci tercih. En iyi söndürme verimi.'**
  String get hoodAgentPotassiumAcetateReco;

  /// No description provided for @hoodAgentPotassiumCitrateReco.
  ///
  /// In tr, this message translates to:
  /// **'Paslanmaz çelik mutfak / gıda endüstrisi. Düşük–Orta tehlike.'**
  String get hoodAgentPotassiumCitrateReco;

  /// No description provided for @hoodAgentSodiumBicarbonateReco.
  ///
  /// In tr, this message translates to:
  /// **'Yalnızca düşük tehlike. Yüksek yağ yangınlarında yeterli değil.'**
  String get hoodAgentSodiumBicarbonateReco;

  /// No description provided for @hoodStdNfpa96Desc.
  ///
  /// In tr, this message translates to:
  /// **'Ticari yemek pişirme operasyonları için havalandırma kontrolü ve yangın koruması. Davlumbaz boyutlandırma, filtre mesafeleri, söndürme sistemi gereklilikleri, manuel çekme kolu, yakıt kesme, bakım ve temizlik sıklıkları.'**
  String get hoodStdNfpa96Desc;

  /// No description provided for @hoodStdNfpa17aDesc.
  ///
  /// In tr, this message translates to:
  /// **'Islak kimyasal söndürme sistemleri standardı. Deşarj süresi, ajan miktarı, nozul aralıkları.'**
  String get hoodStdNfpa17aDesc;

  /// No description provided for @hoodStdTsEn15751Desc.
  ///
  /// In tr, this message translates to:
  /// **'Avrupa standardı — Ticari yemek pişirme ekipmanı söndürme sistemleri.'**
  String get hoodStdTsEn15751Desc;

  /// No description provided for @hoodStdUl300Desc.
  ///
  /// In tr, this message translates to:
  /// **'ABD — Mutfak söndürme sistemleri için ürün onay standardı (Ansul R-102, Amerex B500 vb.).'**
  String get hoodStdUl300Desc;

  /// No description provided for @hoodStdTsEn1825Desc.
  ///
  /// In tr, this message translates to:
  /// **'Mutfak davlumbazı için gres filtre sistemleri ve yangın kapakları.'**
  String get hoodStdTsEn1825Desc;

  /// No description provided for @calculationResultCaps.
  ///
  /// In tr, this message translates to:
  /// **'HESAPLAMA SONUCU'**
  String get calculationResultCaps;

  /// No description provided for @gasInfoBoxText.
  ///
  /// In tr, this message translates to:
  /// **'TS EN 15004-1:2019 · NFPA 2001:2022\nToplam taşkın gazlı söndürme sistemi ajan miktarı ön hesap aracı.'**
  String get gasInfoBoxText;

  /// No description provided for @gasNetVolumeHint.
  ///
  /// In tr, this message translates to:
  /// **'Net koruma hacmi — sabit mobilya/ekipman varsa brüt hacimden çıkarınız.'**
  String get gasNetVolumeHint;

  /// No description provided for @gasMinDesignTempHint.
  ///
  /// In tr, this message translates to:
  /// **'Hacimdeki minimum hava sıcaklığı — TS EN 15004-1 §A.2  (varsayılan: 20 °C)'**
  String get gasMinDesignTempHint;

  /// No description provided for @gasClassAMaterial1.
  ///
  /// In tr, this message translates to:
  /// **'PMMA (polimetilmetakrilat / pleksiglas) '**
  String get gasClassAMaterial1;

  /// No description provided for @gasClassAMaterial2.
  ///
  /// In tr, this message translates to:
  /// **'PP (polipropilen)'**
  String get gasClassAMaterial2;

  /// No description provided for @gasClassAMaterial3.
  ///
  /// In tr, this message translates to:
  /// **'ABS (akrilonitril bütadien stiren) '**
  String get gasClassAMaterial3;

  /// No description provided for @gasClassAMaterial4.
  ///
  /// In tr, this message translates to:
  /// **'Ahşap, mobilya ve döşeme malzemeleri'**
  String get gasClassAMaterial4;

  /// No description provided for @gasClassAMaterial5.
  ///
  /// In tr, this message translates to:
  /// **'Kağıt ve karton'**
  String get gasClassAMaterial5;

  /// No description provided for @gasClassAMaterial6.
  ///
  /// In tr, this message translates to:
  /// **'Tekstil / kumaş'**
  String get gasClassAMaterial6;

  /// No description provided for @gasClassAMaterial7.
  ///
  /// In tr, this message translates to:
  /// **'Kauçuk (lastik)'**
  String get gasClassAMaterial7;

  /// No description provided for @gasClassAMaterial8.
  ///
  /// In tr, this message translates to:
  /// **'Diğer termoplastikler (PE, PS, PVC vb.)'**
  String get gasClassAMaterial8;

  /// No description provided for @gasClassASource.
  ///
  /// In tr, this message translates to:
  /// **'TS EN 15004-1:2019 Ek C.6.3.2 (polimerik test yakıtı levha dizisi) · ISO 14520-1 Sınıf A tanımı (genel örnekler)'**
  String get gasClassASource;

  /// No description provided for @gasClassADTitle.
  ///
  /// In tr, this message translates to:
  /// **'Higher Hazard Class A  —  Yüksek Tehlikeli Yangınlar'**
  String get gasClassADTitle;

  /// No description provided for @gasClassADMaterial1.
  ///
  /// In tr, this message translates to:
  /// **'Yığın/istifli plastik depolama (raf/palet, derin yerleşik — yüzey Sınıf A\'daki tekil/açık plastik parçalardan farklıdır)'**
  String get gasClassADMaterial1;

  /// No description provided for @gasClassADMaterial2.
  ///
  /// In tr, this message translates to:
  /// **'Yoğun kablo demetleri > 100 mm'**
  String get gasClassADMaterial2;

  /// No description provided for @gasClassADMaterial3.
  ///
  /// In tr, this message translates to:
  /// **'Kablo tavası doluluk > %20'**
  String get gasClassADMaterial3;

  /// No description provided for @gasClassADMaterial4.
  ///
  /// In tr, this message translates to:
  /// **'Kablo tavaları arası < 250 mm'**
  String get gasClassADMaterial4;

  /// No description provided for @gasClassADMaterial5.
  ///
  /// In tr, this message translates to:
  /// **'Söndürme sırasında enerjili ekipman > 5 kW'**
  String get gasClassADMaterial5;

  /// No description provided for @gasClassADMaterial6.
  ///
  /// In tr, this message translates to:
  /// **'Telekomünikasyon'**
  String get gasClassADMaterial6;

  /// No description provided for @gasClassADMaterial7.
  ///
  /// In tr, this message translates to:
  /// **'Kontrol odaları'**
  String get gasClassADMaterial7;

  /// No description provided for @gasClassADMaterial8.
  ///
  /// In tr, this message translates to:
  /// **'Elektrik/elektronik ekipman yoğun alanlar'**
  String get gasClassADMaterial8;

  /// No description provided for @gasClassADSource.
  ///
  /// In tr, this message translates to:
  /// **'TS EN 15004-1:2019 Tablo 4'**
  String get gasClassADSource;

  /// No description provided for @gasClassBTitle.
  ///
  /// In tr, this message translates to:
  /// **'Class B  —  Sıvı ve Eriyebilir Katı Madde Yangınları'**
  String get gasClassBTitle;

  /// No description provided for @gasClassBMaterial1.
  ///
  /// In tr, this message translates to:
  /// **'Benzin, dizel, fuel-oil'**
  String get gasClassBMaterial1;

  /// No description provided for @gasClassBMaterial2.
  ///
  /// In tr, this message translates to:
  /// **'Solvent, alkol, aseton'**
  String get gasClassBMaterial2;

  /// No description provided for @gasClassBMaterial3.
  ///
  /// In tr, this message translates to:
  /// **'Yağlı trafo'**
  String get gasClassBMaterial3;

  /// No description provided for @gasClassBMaterial4.
  ///
  /// In tr, this message translates to:
  /// **'Boya, vernik, reçine'**
  String get gasClassBMaterial4;

  /// No description provided for @gasClassBMaterial5.
  ///
  /// In tr, this message translates to:
  /// **'Mum, parafin gibi eriyebilir katılar'**
  String get gasClassBMaterial5;

  /// No description provided for @gasClassCMaterial1.
  ///
  /// In tr, this message translates to:
  /// **'Elektrik panoları (lokal)'**
  String get gasClassCMaterial1;

  /// No description provided for @gasClassCMaterial2.
  ///
  /// In tr, this message translates to:
  /// **'Motor kontrol üniteleri'**
  String get gasClassCMaterial2;

  /// No description provided for @gasClassCMaterial3.
  ///
  /// In tr, this message translates to:
  /// **'UPS ve akü sistemleri'**
  String get gasClassCMaterial3;

  /// No description provided for @gasClassCMaterial4.
  ///
  /// In tr, this message translates to:
  /// **'Aydınlatma ve güç dağıtım ekipmanı'**
  String get gasClassCMaterial4;

  /// No description provided for @gasClassCSource.
  ///
  /// In tr, this message translates to:
  /// **'Telekomünikasyon / kontrol odaları / yoğun kablo için → Sınıf A (Derin)\nISO 3941 / NFPA 2001'**
  String get gasClassCSource;

  /// No description provided for @gasStandardDefaultInfo.
  ///
  /// In tr, this message translates to:
  /// **'Standart varsayılan — {className}: {percent}%  ·  Silindir: {capacity} {unit}'**
  String gasStandardDefaultInfo(
    String className,
    String percent,
    String capacity,
    String unit,
  );

  /// No description provided for @gasConcentrationHint.
  ///
  /// In tr, this message translates to:
  /// **'TS EN 15004-1 kapsamı dışı değer kullanıyorsanız düzenleyebilirsiniz. Standart değer için ajan/sınıf seçiminde otomatik güncellenir.'**
  String get gasConcentrationHint;

  /// No description provided for @gasDischargeDurationHintClassB.
  ///
  /// In tr, this message translates to:
  /// **'Sınıf B: maks. 10 s  (TS EN 15004-1 §8.3)  —  boru çapı hesabı için gerekli'**
  String get gasDischargeDurationHintClassB;

  /// No description provided for @gasDischargeDurationHintOther.
  ///
  /// In tr, this message translates to:
  /// **'Sınıf A/A(Derin)/C: maks. 60 s  (TS EN 15004-1 §8.3)  —  boru çapı hesabı için gerekli'**
  String get gasDischargeDurationHintOther;

  /// No description provided for @gasNozzleFlowRange.
  ///
  /// In tr, this message translates to:
  /// **'{mm} mm  ({min}–{max} kg/s)'**
  String gasNozzleFlowRange(String mm, String min, String max);

  /// No description provided for @gasNozzleHint.
  ///
  /// In tr, this message translates to:
  /// **'Nozul çapı seçilirse hesap kütle debisi bazlı yapılır; otomatik modda alan/hacim kuralı uygulanır.'**
  String get gasNozzleHint;

  /// No description provided for @gasRequiredAgentVolume.
  ///
  /// In tr, this message translates to:
  /// **'Gerekli Ajan Hacmi'**
  String get gasRequiredAgentVolume;

  /// No description provided for @gasSafetyMarginSuffix.
  ///
  /// In tr, this message translates to:
  /// **'  (+%10 pay)'**
  String get gasSafetyMarginSuffix;

  /// No description provided for @gasExcludingMarginLabel.
  ///
  /// In tr, this message translates to:
  /// **'Pay Hariç Hesap'**
  String get gasExcludingMarginLabel;

  /// No description provided for @gasDischargeRequirementsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Deşarj Süresi Gereklilikleri — TS EN 15004-1:2019 §8.3 / NFPA 2001:2022 §6.7.1'**
  String get gasDischargeRequirementsTitle;

  /// No description provided for @gasDischargeReqInert.
  ///
  /// In tr, this message translates to:
  /// **'• Maks. deşarj süresi: ≤ 60 s  (NFPA 2001:2022 §6.7.1)\n• Min. bekleme süresi (soak): ≥ 10 dakika  (NFPA 2001:2022 §6.7.4)\n• Boru akış hızı: Tam hidrolik hesap gereklidir (TS EN 15004-1 Ek E)\n• Silindir dep. sıcaklığı: −20 °C – +54 °C  (NFPA 2001:2022 §4.4.1)'**
  String get gasDischargeReqInert;

  /// No description provided for @gasDischargeReqCo2.
  ///
  /// In tr, this message translates to:
  /// **'• Maks. deşarj süresi: ≤ 60 s  (TS EN 15004-2 §8.3 / NFPA 12 §5.4.1)\n• Min. bekleme süresi (soak): ≥ 20 dakika\n• YALNIZCA insan bulunmayan hacimler — tahliye zorunludur'**
  String get gasDischargeReqCo2;

  /// No description provided for @gasMaxDischargeClassB.
  ///
  /// In tr, this message translates to:
  /// **'10 s  (Sınıf B)'**
  String get gasMaxDischargeClassB;

  /// No description provided for @gasMaxDischargeClassOther.
  ///
  /// In tr, this message translates to:
  /// **'60 s  (Sınıf A/C)'**
  String get gasMaxDischargeClassOther;

  /// No description provided for @gasDischargeReqFm200.
  ///
  /// In tr, this message translates to:
  /// **'• Maks. deşarj süresi: ≤ {maxDischarge}  (EN 15004-5:2020 §8.3 / NFPA 2001:2022 §6.7.1)\n• Min. bekleme süresi (soak): ≥ 10 dakika  (NFPA 2001:2022 §6.7.4)\n• Silindir depolama sıcaklığı: −20 °C – +54 °C\n• Özgül hacim: S = 0,1269 + 0,000513×T m³/kg  (EN 15004-5 §6.3 Tablo 3)'**
  String gasDischargeReqFm200(String maxDischarge);

  /// No description provided for @gasDischargeReqDefault.
  ///
  /// In tr, this message translates to:
  /// **'• Maks. deşarj süresi: ≤ {maxDischarge}  (TS EN 15004-1:2019 §8.3 / NFPA 2001:2022 §6.7.1)\n• Min. bekleme süresi (soak): ≥ 10 dakika  (NFPA 2001:2022 §6.7.4)\n• Silindir depolama sıcaklığı: −20 °C – +54 °C  (NFPA 2001:2022 §4.4.1)'**
  String gasDischargeReqDefault(String maxDischarge);

  /// No description provided for @gasIg01SpecsTitle.
  ///
  /// In tr, this message translates to:
  /// **'IG-01 Silindir Özellikleri  —  TS EN 15004-7:2009 §6.1'**
  String get gasIg01SpecsTitle;

  /// No description provided for @gasTablePropertyHeader.
  ///
  /// In tr, this message translates to:
  /// **'Özellik'**
  String get gasTablePropertyHeader;

  /// No description provided for @gasFillPressureLabel.
  ///
  /// In tr, this message translates to:
  /// **'Doldurma basıncı @15°C (bar)'**
  String get gasFillPressureLabel;

  /// No description provided for @gasMaxOperatingPressureLabel.
  ///
  /// In tr, this message translates to:
  /// **'Maks. çalışma basıncı @50°C (bar)'**
  String get gasMaxOperatingPressureLabel;

  /// No description provided for @gasOverpressurizationLabel.
  ///
  /// In tr, this message translates to:
  /// **'Aşırı basınçlandırma'**
  String get gasOverpressurizationLabel;

  /// No description provided for @gasNotApplicable.
  ///
  /// In tr, this message translates to:
  /// **'Uygulanmaz'**
  String get gasNotApplicable;

  /// No description provided for @gasIg01Note.
  ///
  /// In tr, this message translates to:
  /// **'IG-01 tanklar aşırı basınçlandırılmaz (TS EN 15004-7 §6.2). Tasarım sıcaklığında S = 0,56119 + 0,002055×T m³/kg formülü kullanılır.'**
  String get gasIg01Note;

  /// No description provided for @gasFm200SpecsTitle.
  ///
  /// In tr, this message translates to:
  /// **'HFC-227ea Silindir Özellikleri  —  EN 15004-5:2020 §6.1'**
  String get gasFm200SpecsTitle;

  /// No description provided for @gasMaxFillDensityLabel.
  ///
  /// In tr, this message translates to:
  /// **'Maks. dolum yoğunluğu (kg/m³)'**
  String get gasMaxFillDensityLabel;

  /// No description provided for @gasN2FillingPressureLabel.
  ///
  /// In tr, this message translates to:
  /// **'N₂ şişeleme basıncı @21°C (bar)'**
  String get gasN2FillingPressureLabel;

  /// No description provided for @gasFm200Note.
  ///
  /// In tr, this message translates to:
  /// **'Maks. dolum yoğunluğu aşılması durumunda küçük sıcaklık artışlarında çok yüksek basınç oluşur; silindir bütünlüğü tehlikeye girer. (EN 15004-5:2020 §6.1)'**
  String get gasFm200Note;

  /// No description provided for @gasNfpa2001RequirementsTitle.
  ///
  /// In tr, this message translates to:
  /// **'NFPA 2001:2022 Zorunlu Gereklilikler'**
  String get gasNfpa2001RequirementsTitle;

  /// No description provided for @gasReqPreDischargeAlarm.
  ///
  /// In tr, this message translates to:
  /// **'§6.6.1 — Ön Deşarj Alarmı: Dolu alanlarda ajan devreye girmeden önce sesli/ışıklı uyarı verilmeli; tahliye için yeterli süre tanınmalıdır.'**
  String get gasReqPreDischargeAlarm;

  /// No description provided for @gasReqAbortSwitch.
  ///
  /// In tr, this message translates to:
  /// **'§6.6.6 — Abort Anahtarı: Dolu alanlarda el ile iptal (abort) düğmesi zorunludur; sistemi en az 30 saniye geciktirir.'**
  String get gasReqAbortSwitch;

  /// No description provided for @gasReqVolumeIntegrity.
  ///
  /// In tr, this message translates to:
  /// **'§6.5.4 — Koruma Hacmi Bütünlüğü: Hacim, soak süresi boyunca tasarım konsantrasyonunu koruyacak sızdırmazlığa sahip olmalıdır. Kapı fan testi (door fan test) tavsiye edilir.'**
  String get gasReqVolumeIntegrity;

  /// No description provided for @gasReqCylinderStorage.
  ///
  /// In tr, this message translates to:
  /// **'§4.4.1 — Silindir Depolama: −20 °C ile +54 °C arasında muhafaza; dolum basıncı üretici listesine uygun olmalıdır.'**
  String get gasReqCylinderStorage;

  /// No description provided for @gasReqPostDischargeVentilation.
  ///
  /// In tr, this message translates to:
  /// **'§6.9 — Deşarj Sonrası Havalandırma: Ortama girişten önce O₂ seviyesi ≥ %19,5\'e ulaşana dek zorlamalı havalandırma yapılmalıdır.'**
  String get gasReqPostDischargeVentilation;

  /// No description provided for @gasReqInterlockedSystems.
  ///
  /// In tr, this message translates to:
  /// **'§6.1.2 — Bağlantılı Sistemler: Deşarj anında HVAC ve tüm hava sağlayan damperler otomatik kapanmalıdır.'**
  String get gasReqInterlockedSystems;

  /// No description provided for @gasReqSafetyMargin.
  ///
  /// In tr, this message translates to:
  /// **'§5.4.1.3 — Güvenlik Payı: Min. %10 güvenlik payı zorunludur; bu hesapta {status}'**
  String gasReqSafetyMargin(String status);

  /// No description provided for @gasSafetyMarginApplied.
  ///
  /// In tr, this message translates to:
  /// **'uygulandı.'**
  String get gasSafetyMarginApplied;

  /// No description provided for @gasSafetyMarginNotApplied.
  ///
  /// In tr, this message translates to:
  /// **'⚠ uygulanmadı!'**
  String get gasSafetyMarginNotApplied;

  /// No description provided for @gasReqPeriodicInspection.
  ///
  /// In tr, this message translates to:
  /// **'§7.2.2 — Periyodik Muayene: Silindirler yılda bir ağırlık/basınç ile kontrol edilmeli; halokarbon dolum miktarı çiçek valf ölçümü ile doğrulanmalıdır.'**
  String get gasReqPeriodicInspection;

  /// No description provided for @gasMainPipeSizeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Boru Çapı — Ana Hat'**
  String get gasMainPipeSizeTitle;

  /// No description provided for @gasMinInnerDiameterLabel.
  ///
  /// In tr, this message translates to:
  /// **'Min. iç çap'**
  String get gasMinInnerDiameterLabel;

  /// No description provided for @gasStandardDnLabel.
  ///
  /// In tr, this message translates to:
  /// **'Standart DN'**
  String get gasStandardDnLabel;

  /// No description provided for @gasDnOver150.
  ///
  /// In tr, this message translates to:
  /// **'DN > 150'**
  String get gasDnOver150;

  /// No description provided for @gasVolumetricFlowLabel.
  ///
  /// In tr, this message translates to:
  /// **'Hacimsel debi (Q): {ls} L/s  ({m3s} m³/s)'**
  String gasVolumetricFlowLabel(String ls, String m3s);

  /// No description provided for @gasPipeActualSpeedLabel.
  ///
  /// In tr, this message translates to:
  /// **'DN {dn} için gerçek hız: {speed} m/s{status}'**
  String gasPipeActualSpeedLabel(String dn, String speed, String status);

  /// No description provided for @gasSpeedOkSuffix.
  ///
  /// In tr, this message translates to:
  /// **' ✓'**
  String get gasSpeedOkSuffix;

  /// No description provided for @gasSpeedOverLimitSuffix.
  ///
  /// In tr, this message translates to:
  /// **'  ? 30 m/s üstünde'**
  String get gasSpeedOverLimitSuffix;

  /// No description provided for @gasMainPipeSizingNote.
  ///
  /// In tr, this message translates to:
  /// **'Ana hat ön boyutlandırmadır — Q = gaz miktarı ÷ boşalma süresi. Dağıtım boruları ve nozul hatları ayrıca hesaplanmalıdır. Kesin tasarım için TS EN 15004-1 Ek E akış hesabı yapınız.'**
  String get gasMainPipeSizingNote;

  /// No description provided for @gasNozzleDistributionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Nozul & Dağıtım Borusu'**
  String get gasNozzleDistributionTitle;

  /// No description provided for @gasNozzleCountLabel.
  ///
  /// In tr, this message translates to:
  /// **'Nozul Sayısı'**
  String get gasNozzleCountLabel;

  /// No description provided for @gasNozzleAltMassBased.
  ///
  /// In tr, this message translates to:
  /// **'{mm} mm nozul\n(kütle debisi bazlı)'**
  String gasNozzleAltMassBased(String mm);

  /// No description provided for @gasNozzleAltAreaBased.
  ///
  /// In tr, this message translates to:
  /// **'maks. 50 m²/nozul\n(alan bazlı)'**
  String get gasNozzleAltAreaBased;

  /// No description provided for @gasNozzleAltVolumeBased.
  ///
  /// In tr, this message translates to:
  /// **'maks. 150 m³/nozul\n(hacim bazlı — tahmini)'**
  String get gasNozzleAltVolumeBased;

  /// No description provided for @gasBranchPipeLabel.
  ///
  /// In tr, this message translates to:
  /// **'Şube Boru'**
  String get gasBranchPipeLabel;

  /// No description provided for @gasBranchMinInnerDiameter.
  ///
  /// In tr, this message translates to:
  /// **'min. iç çap:\n{mm} mm'**
  String gasBranchMinInnerDiameter(String mm);

  /// No description provided for @gasFlowPerNozzleLabel.
  ///
  /// In tr, this message translates to:
  /// **'Nozul başına: {flow} kg/s  (izin verilen: {min}–{max} kg/s)  {status}'**
  String gasFlowPerNozzleLabel(
    String flow,
    String min,
    String max,
    String status,
  );

  /// No description provided for @gasFlowOk.
  ///
  /// In tr, this message translates to:
  /// **'✓'**
  String get gasFlowOk;

  /// No description provided for @gasFlowOutOfRange.
  ///
  /// In tr, this message translates to:
  /// **'⚠ Aralık dışı — farklı çap seçin'**
  String get gasFlowOutOfRange;

  /// No description provided for @gasBranchSpeedLabel.
  ///
  /// In tr, this message translates to:
  /// **'Şube hız: {speed} m/s  (nozul başına Q: {ls} L/s){status}'**
  String gasBranchSpeedLabel(String speed, String ls, String status);

  /// No description provided for @gasBranchSpeedWarning.
  ///
  /// In tr, this message translates to:
  /// **'  ⚠ 30 m/s üstünde!'**
  String get gasBranchSpeedWarning;

  /// No description provided for @gasBranchSpeedOk.
  ///
  /// In tr, this message translates to:
  /// **'  ✓'**
  String get gasBranchSpeedOk;

  /// No description provided for @gasEstimatedPipeLengthLabel.
  ///
  /// In tr, this message translates to:
  /// **'Tahmini boru metrajı: ≈ {m} m (ana hat + dağıtım + nozul düşeyleri)'**
  String gasEstimatedPipeLengthLabel(String m);

  /// No description provided for @gasNozzlePlacementNote.
  ///
  /// In tr, this message translates to:
  /// **'Nozul yerleşimi: TS EN 15004-1 / NFPA 2001 üretici listesi şartlarına uygun olarak tavan düzeyine, eşit aralıklı konumlandırılmalıdır.\nBoru metrajı tahminidir — gerçek proje metrajı mekan planına göre değişir.'**
  String get gasNozzlePlacementNote;

  /// No description provided for @gasSourceFooter.
  ///
  /// In tr, this message translates to:
  /// **'Kaynak: TS EN 15004-1:2019 · NFPA 2001:2022 · NFPA 12:2022'**
  String get gasSourceFooter;

  /// No description provided for @baskiOffsetName.
  ///
  /// In tr, this message translates to:
  /// **'Ofset Baskı'**
  String get baskiOffsetName;

  /// No description provided for @baskiFlexoName.
  ///
  /// In tr, this message translates to:
  /// **'Flexo Baskı'**
  String get baskiFlexoName;

  /// No description provided for @baskiGravureName.
  ///
  /// In tr, this message translates to:
  /// **'Gravür / Rotogravür'**
  String get baskiGravureName;

  /// No description provided for @baskiUvOffsetName.
  ///
  /// In tr, this message translates to:
  /// **'UV Ofset / UV Flex'**
  String get baskiUvOffsetName;

  /// No description provided for @baskiDigitalName.
  ///
  /// In tr, this message translates to:
  /// **'Dijital (Inkjet/Toner)'**
  String get baskiDigitalName;

  /// No description provided for @baskiPadName.
  ///
  /// In tr, this message translates to:
  /// **'Şilte / Tampon Baskı'**
  String get baskiPadName;

  /// No description provided for @baskiOffsetDesc.
  ///
  /// In tr, this message translates to:
  /// **'Islak ofset — IPA/alkol bazlı çözücü'**
  String get baskiOffsetDesc;

  /// No description provided for @baskiFlexoDesc.
  ///
  /// In tr, this message translates to:
  /// **'Solvent veya su bazlı mürekkep'**
  String get baskiFlexoDesc;

  /// No description provided for @baskiGravureDesc.
  ///
  /// In tr, this message translates to:
  /// **'Toluen/etil asetat bazlı — yüksek solvent riski'**
  String get baskiGravureDesc;

  /// No description provided for @baskiUvOffsetDesc.
  ///
  /// In tr, this message translates to:
  /// **'UV kürleme — fotoinitiator bazlı'**
  String get baskiUvOffsetDesc;

  /// No description provided for @baskiDigitalDesc.
  ///
  /// In tr, this message translates to:
  /// **'Sıvı mürekkep veya toner — düşük solvent'**
  String get baskiDigitalDesc;

  /// No description provided for @baskiPadDesc.
  ///
  /// In tr, this message translates to:
  /// **'Solvent bazlı mürekkep — kapalı kap'**
  String get baskiPadDesc;

  /// No description provided for @baskiIpaName.
  ///
  /// In tr, this message translates to:
  /// **'IPA (İzopropil Alkol)'**
  String get baskiIpaName;

  /// No description provided for @baskiIpaDesc.
  ///
  /// In tr, this message translates to:
  /// **'Ofset baskı çeşme solüsyonu — patlama riski'**
  String get baskiIpaDesc;

  /// No description provided for @baskiTolueneName.
  ///
  /// In tr, this message translates to:
  /// **'Toluen'**
  String get baskiTolueneName;

  /// No description provided for @baskiTolueneDesc.
  ///
  /// In tr, this message translates to:
  /// **'Gravür baskı — yüksek risk, GWP 0'**
  String get baskiTolueneDesc;

  /// No description provided for @baskiEthylAcetateName.
  ///
  /// In tr, this message translates to:
  /// **'Etil Asetat'**
  String get baskiEthylAcetateName;

  /// No description provided for @baskiEthylAcetateDesc.
  ///
  /// In tr, this message translates to:
  /// **'Flexo/gravür — düşük tutuşma noktası'**
  String get baskiEthylAcetateDesc;

  /// No description provided for @baskiMethanolName.
  ///
  /// In tr, this message translates to:
  /// **'Metanol'**
  String get baskiMethanolName;

  /// No description provided for @baskiMethanolDesc.
  ///
  /// In tr, this message translates to:
  /// **'Ağaç işleme ve özel uygulamalar'**
  String get baskiMethanolDesc;

  /// No description provided for @baskiNPropylName.
  ///
  /// In tr, this message translates to:
  /// **'n-Propil Alkol'**
  String get baskiNPropylName;

  /// No description provided for @baskiNPropylDesc.
  ///
  /// In tr, this message translates to:
  /// **'UV ofset ek solvent'**
  String get baskiNPropylDesc;

  /// No description provided for @baskiSolventMixName.
  ///
  /// In tr, this message translates to:
  /// **'Solvent Karışımı (genel)'**
  String get baskiSolventMixName;

  /// No description provided for @baskiSolventMixDesc.
  ///
  /// In tr, this message translates to:
  /// **'Üretici veri sayfasına göre belirleyin'**
  String get baskiSolventMixDesc;

  /// No description provided for @baskiWaterBasedInkName.
  ///
  /// In tr, this message translates to:
  /// **'Su Bazlı Mürekkep'**
  String get baskiWaterBasedInkName;

  /// No description provided for @baskiWaterBasedInkDesc.
  ///
  /// In tr, this message translates to:
  /// **'Yanıcı solvent yok — Sınıf A uygulaması'**
  String get baskiWaterBasedInkDesc;

  /// No description provided for @baskiInfoBoxText.
  ///
  /// In tr, this message translates to:
  /// **'NFPA 34:2024 §10.6 · NFPA 2001:2022 · NFPA 12:2022 · TS EN 15004-1:2019\nMatbaa / baskı makinesi kabini gazlı söndürme ön hesap aracı.'**
  String get baskiInfoBoxText;

  /// No description provided for @baskiIgnitionPointLabel.
  ///
  /// In tr, this message translates to:
  /// **'Tutuşma noktası: {temp} °C  ·  {desc}'**
  String baskiIgnitionPointLabel(String temp, String desc);

  /// No description provided for @baskiUnitCountHint.
  ///
  /// In tr, this message translates to:
  /// **'Aynı hacimdeki her ünite için ayrı silindir hesaplanır. Farklı hacimliyse birden fazla hesap yapınız.'**
  String get baskiUnitCountHint;

  /// No description provided for @baskiLengthDepthLabel.
  ///
  /// In tr, this message translates to:
  /// **'Uzunluk / Derinlik'**
  String get baskiLengthDepthLabel;

  /// No description provided for @baskiCabinetDimensionsHint.
  ///
  /// In tr, this message translates to:
  /// **'Bir ünite kabininin iç boyutları — brüt değil, net iç hacim.'**
  String get baskiCabinetDimensionsHint;

  /// No description provided for @baskiUnitNetVolumeLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ünite Kabini Net Hacmi'**
  String get baskiUnitNetVolumeLabel;

  /// No description provided for @baskiMinTempHint.
  ///
  /// In tr, this message translates to:
  /// **'Makine kabin içi minimum sıcaklık — TS EN 15004-1 §A.2 (varsayılan: 20 °C)'**
  String get baskiMinTempHint;

  /// No description provided for @baskiLocalApplicationLabel.
  ///
  /// In tr, this message translates to:
  /// **'Lokal Uygulama +%30 (NFPA 2001 §6.4) — Açık makine kabinleri için'**
  String get baskiLocalApplicationLabel;

  /// No description provided for @baskiDischargeModeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Tahliye Şekli (Birden Fazla Ünite)'**
  String get baskiDischargeModeTitle;

  /// No description provided for @baskiSimultaneousLabel.
  ///
  /// In tr, this message translates to:
  /// **'Eşzamanlı (Toplam)'**
  String get baskiSimultaneousLabel;

  /// No description provided for @baskiSelectiveValveLabel.
  ///
  /// In tr, this message translates to:
  /// **'Seçici Vana (Bağımsız)'**
  String get baskiSelectiveValveLabel;

  /// No description provided for @baskiSimultaneousHint.
  ///
  /// In tr, this message translates to:
  /// **'Tüm üniteler ortak alanda ve tek seferde tahliye olacaksa seçin — ana besleme = tüm ünitelerin toplam ihtiyacı.'**
  String get baskiSimultaneousHint;

  /// No description provided for @baskiSelectiveValveHint.
  ///
  /// In tr, this message translates to:
  /// **'Her ünite bağımsız algılama + seçici vana ile korunuyorsa seçin — ana besleme yalnızca tek ünite ihtiyacına göre boyutlandırılır (NFPA 2001 §7.5.2 / NFPA 12 §4.3.4.2).'**
  String get baskiSelectiveValveHint;

  /// No description provided for @baskiBackupSupplyLabel.
  ///
  /// In tr, this message translates to:
  /// **'Yedek (%100) Besleme Grubu (NFPA 12 §4.5.3) — normal işgal edilen alanlar için önerilir'**
  String get baskiBackupSupplyLabel;

  /// No description provided for @baskiClassAPlain.
  ///
  /// In tr, this message translates to:
  /// **'Sınıf A'**
  String get baskiClassAPlain;

  /// No description provided for @baskiClassSummaryLabel.
  ///
  /// In tr, this message translates to:
  /// **'Yangın sınıfı: {cls}  ·  Standart min.: {value} %  ·  NOAEL: {noael}'**
  String baskiClassSummaryLabel(String cls, String value, String noael);

  /// No description provided for @baskiDischargeHint.
  ///
  /// In tr, this message translates to:
  /// **'Sınıf B makineler: maks. 10 s  ·  Sınıf A makineler: maks. 60 s  (TS EN 15004-1 §8.3)'**
  String get baskiDischargeHint;

  /// No description provided for @baskiMainSupplySimultaneous.
  ///
  /// In tr, this message translates to:
  /// **'Ana Besleme İhtiyacı (eşzamanlı — toplam)'**
  String get baskiMainSupplySimultaneous;

  /// No description provided for @baskiMainSupplySelective.
  ///
  /// In tr, this message translates to:
  /// **'Ana Besleme İhtiyacı (seçici vana — tek ünite)'**
  String get baskiMainSupplySelective;

  /// No description provided for @baskiMainSupplyCylinderCount.
  ///
  /// In tr, this message translates to:
  /// **'Ana Besleme Silindir Sayısı ({capacity} {unit}/silindir)'**
  String baskiMainSupplyCylinderCount(String capacity, String unit);

  /// No description provided for @baskiSelectiveValveInfo.
  ///
  /// In tr, this message translates to:
  /// **'Seçici vana tasarımı: her ünite kabini bağımsız algılama devresine sahip olmalı; yalnızca yangın algılanan ünitenin vanası açılır. Ana besleme tek ünite ihtiyacına göre boyutlandırılmıştır — birden fazla ünitede eşzamanlı yangın riski varsa \"Eşzamanlı\" seçilmelidir (NFPA 2001 §7.5.2 / NFPA 12 §4.3.4.2).'**
  String get baskiSelectiveValveInfo;

  /// No description provided for @baskiLocalApplicationInfo.
  ///
  /// In tr, this message translates to:
  /// **'Lokal uygulama +%30 faktörü uygulandı (NFPA 2001 §6.4).\nAçık makinelerde veya tam kapalı olmayan kabinlerde uygulanır.'**
  String get baskiLocalApplicationInfo;

  /// No description provided for @baskiApplicationNotesTitle.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama Notları'**
  String get baskiApplicationNotesTitle;

  /// No description provided for @baskiAppNotesBody.
  ///
  /// In tr, this message translates to:
  /// **'• Her baskı ünitesi kabini ayrı ayrı korunmalıdır.\n• Makine içi nozul yerleşimi üretici onayına tabidir.\n• Deşarj öncesi mürekkep/solvent kaynağı otomatik kesilmelidir.\n• {ignitionNote}\n• Silindir sayısı, seçilen tahliye şekli (eşzamanlı/seçici vana) ve yedek besleme kararına göre değişir — üretici tipine göre kesinleştirilmelidir.'**
  String baskiAppNotesBody(String ignitionNote);

  /// No description provided for @baskiIgnitionNoteAtex.
  ///
  /// In tr, this message translates to:
  /// **'Tutuşma noktası < 23 °C — ATEX bölgesi değerlendirmesi zorunludur.'**
  String get baskiIgnitionNoteAtex;

  /// No description provided for @baskiIgnitionNoteExplosionRisk.
  ///
  /// In tr, this message translates to:
  /// **'Solvent tipi için patlama riski analizi yapılmalıdır.'**
  String get baskiIgnitionNoteExplosionRisk;

  /// No description provided for @baskiSourceFooter.
  ///
  /// In tr, this message translates to:
  /// **'Kaynak: NFPA 34:2024 §10 · NFPA 2001:2022 · NFPA 12:2022 · TS EN 15004-1:2019 · EN 1010-2'**
  String get baskiSourceFooter;

  /// No description provided for @panoAgentGroupClean.
  ///
  /// In tr, this message translates to:
  /// **'Temiz Gaz (FK-5-1-12(Novec 1230)/HFC-227ea)'**
  String get panoAgentGroupClean;

  /// No description provided for @panoAgentGroupCo2.
  ///
  /// In tr, this message translates to:
  /// **'CO₂ (Karbondioksit)'**
  String get panoAgentGroupCo2;

  /// No description provided for @panoDlpName.
  ///
  /// In tr, this message translates to:
  /// **'DLP — Doğrudan Düşük Basınç'**
  String get panoDlpName;

  /// No description provided for @panoIlpName.
  ///
  /// In tr, this message translates to:
  /// **'ILP — Dolaylı Düşük Basınç'**
  String get panoIlpName;

  /// No description provided for @panoDhpName.
  ///
  /// In tr, this message translates to:
  /// **'DHP — Doğrudan Yüksek Basınç (CO₂)'**
  String get panoDhpName;

  /// No description provided for @panoIhpName.
  ///
  /// In tr, this message translates to:
  /// **'IHP — Dolaylı Yüksek Basınç (CO₂)'**
  String get panoIhpName;

  /// No description provided for @panoDlpDesarjNotu.
  ///
  /// In tr, this message translates to:
  /// **'Tubing hattı hem algılama hem doğrudan boşaltma görevi görür — hesap gerektirmez.'**
  String get panoDlpDesarjNotu;

  /// No description provided for @panoIlpDesarjNotu.
  ///
  /// In tr, this message translates to:
  /// **'Tubing algılama yapar; boşaltma ayrı nozul(lar) üzerinden gerçekleşir.'**
  String get panoIlpDesarjNotu;

  /// No description provided for @panoDhpDesarjNotu.
  ///
  /// In tr, this message translates to:
  /// **'Sabit deşarj süresi ≈ 60 sn @ 60 bar — kullanıcı girdisi gerekmez.'**
  String get panoDhpDesarjNotu;

  /// No description provided for @panoIhpDesarjNotu.
  ///
  /// In tr, this message translates to:
  /// **'Deşarj süresi standarda göre sabittir; üretici onaylı tabloya bakınız.'**
  String get panoIhpDesarjNotu;

  /// No description provided for @panoDlpAciklama.
  ///
  /// In tr, this message translates to:
  /// **'En yaygın kullanılan pano içi söndürme tipidir. Kırmızı algılama tubingi doğrudan söndürme hattı olarak işlev görür; ek boru hattına ve nozula gerek yoktur. Tubing yangın noktasında patladığında ajan o noktadan boşalır. Hidrolik akış hesabı gerektirmeyen pre-engineered bir sistemdir.'**
  String get panoDlpAciklama;

  /// No description provided for @panoIlpAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Algılama tubingi yalnızca tetikleyici işlev görür; söndürücü ajan paslanmaz çelik boru hattı ve nozullar aracılığıyla panoya boşaltılır. Çok bölmeli ve büyük hacimli panolarda nozullar stratejik noktalara yerleştirilerek homojen söndürme konsantrasyonu sağlanır. Manuel boşaltma butonu bulunur; panonun tam sızdırmaz olması zorunludur.'**
  String get panoIlpAciklama;

  /// No description provided for @panoDhpAciklama.
  ///
  /// In tr, this message translates to:
  /// **'CO₂ ajanı kullanan ve algılama tubinginin hem dedektör hem de boşaltma hattı olarak işlev gördüğü sistemdir. CO₂ yüksek basınçta depolandığından tubing uzunluğu ve maksimum hacim açısından DLP\'ye göre avantajlıdır. Nozul deliği açılması istenmeyen ve DLP\'ye göre daha büyük havalandırma açıklığına sahip panolarda tercih edilir.'**
  String get panoDhpAciklama;

  /// No description provided for @panoIhpAciklama.
  ///
  /// In tr, this message translates to:
  /// **'CO₂ kullanılan en kapsamlı pano içi söndürme çözümüdür. Büyük hacimli, birden fazla bölmesi olan ve bölmeler arası geçişlerin bulunduğu panolarda tercih edilir. Paslanmaz çelik boru hattı, esnek bağlantı hortumları ve nozullardan oluşan dağıtım sistemi ile geniş alanlarda homojen söndürme sağlanır.'**
  String get panoIhpAciklama;

  /// No description provided for @panoInfoBoxText.
  ///
  /// In tr, this message translates to:
  /// **'LPS 1666 · UL 2166 / FM 5600 · VdS 2093\nElektrik/telekom pano ve kabinleri için önceden mühendislik hesabı yapılmış (pre-engineered) pnömatik tubing söndürme sistemi tipi öneri aracı — hidrolik hesap değildir.'**
  String get panoInfoBoxText;

  /// No description provided for @panoNoOpeningLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kapatılamayan açıklık yok (kablo geçişi, havalandırma vb. sızdırmaz)'**
  String get panoNoOpeningLabel;

  /// No description provided for @panoOpeningWarning.
  ///
  /// In tr, this message translates to:
  /// **'Kapatılamayan açıklık varsa ajan tutulamaz ve sistem etkisiz kalabilir. Açıklıklar kapatılmalı veya devreye girişte havalandırma/damper otomatik olarak kesilmelidir.'**
  String get panoOpeningWarning;

  /// No description provided for @panoTubingLengthLabel.
  ///
  /// In tr, this message translates to:
  /// **'İhtiyaç Duyulan Tubing Uzunluğu (opsiyonel)'**
  String get panoTubingLengthLabel;

  /// No description provided for @panoRecommendedSystemCaps.
  ///
  /// In tr, this message translates to:
  /// **'ÖNERİLEN SİSTEM'**
  String get panoRecommendedSystemCaps;

  /// No description provided for @panoVolumeExceededWarning.
  ///
  /// In tr, this message translates to:
  /// **'Hacim, pre-engineered pano içi sistem sınırlarını aşıyor ({detail}). Bu hacim için mühendislik hesaplı toplam taşkın sistemi gereklidir — \"{roomTab}\" sekmesini kullanınız.'**
  String panoVolumeExceededWarning(String detail, String roomTab);

  /// No description provided for @panoIlpMaxVolume.
  ///
  /// In tr, this message translates to:
  /// **'ILP maks. {v} m³'**
  String panoIlpMaxVolume(String v);

  /// No description provided for @panoIhpMaxVolume.
  ///
  /// In tr, this message translates to:
  /// **'IHP maks. {v} m³'**
  String panoIhpMaxVolume(String v);

  /// No description provided for @panoAgentAmountNote.
  ///
  /// In tr, this message translates to:
  /// **'Bu miktar, %{percent} tasarım konsantrasyonu ve 20°C referans alınarak yapılan bir yaklaşık hesaptır. Kesin silindir dolum miktarı üretici onaylı pre-engineered sistem tablosundan seçilmelidir.'**
  String panoAgentAmountNote(String percent);

  /// No description provided for @panoTubingExceededWarning.
  ///
  /// In tr, this message translates to:
  /// **'Girilen tubing uzunluğu ({len} m), {kod} sisteminin {max} m sınırını aşıyor. Bir üst sistem tipine geçilmeli veya birden fazla bağımsız sistem kullanılmalıdır.'**
  String panoTubingExceededWarning(String len, String kod, String max);

  /// No description provided for @panoSealingWarning.
  ///
  /// In tr, this message translates to:
  /// **'ILP sistemi tam sızdırmaz kabin gerektirir (UL/FM test şartı). İşaretli kapatılamayan açıklık nedeniyle bu sistem güvenilir değildir — panoyu sızdırmaz hâle getiriniz ya da CO₂ ajan grubuna (DHP/IHP, sızdırmazlık gerekmez) geçiniz.'**
  String get panoSealingWarning;

  /// No description provided for @panoCo2ToxicityWarning.
  ///
  /// In tr, this message translates to:
  /// **'CO₂ toksiktir: pano çevresinde sürekli insan bulunmamalıdır. Komşu/bitişik alanlara sızıntı riski varsa %5 LOAEL sınırı gözetilmeli, gerekirse tahliye ve havalandırma planlanmalıdır.'**
  String get panoCo2ToxicityWarning;

  /// No description provided for @panoNoSealingRequiredNote.
  ///
  /// In tr, this message translates to:
  /// **'Sızdırmazlık şart değildir ancak kapatılamayan açıklık miktarı üreticiye bildirilmeli; VdS 2093 hesabında ek ajan miktarı olarak dikkate alınmalıdır.'**
  String get panoNoSealingRequiredNote;

  /// No description provided for @panoDesignRequirementsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Tasarım Gereklilikleri'**
  String get panoDesignRequirementsTitle;

  /// No description provided for @panoManualReleaseNote.
  ///
  /// In tr, this message translates to:
  /// **'• Manuel boşaltma butonu: {kod} sistemlerinde tubing hattı ayrı olduğundan, otomatik tetiklemeye ek olarak acil manuel boşaltma butonu bulunmalıdır.\n'**
  String panoManualReleaseNote(String kod);

  /// No description provided for @panoDesignRequirementsBody.
  ///
  /// In tr, this message translates to:
  /// **'• Alarm entegrasyonu: sistem aktivasyonunda sesli/ışıklı ön deşarj alarmı ve bina yangın alarm paneline sinyal aktarımı sağlanmalıdır.\n• Silindir seti CE/TPED (Taşınabilir Basınçlı Ekipman Yönetmeliği) uygunluğuna sahip olmalıdır.\n• Satın alma öncesi bağımsız sistem sertifikası (LPCB/UL/FM/VdS) aranmalı; sadece bileşen (silindir, nozul) sertifikası yeterli değildir. Kurulum yetkili/onaylı partner tarafından yapılmalıdır.'**
  String get panoDesignRequirementsBody;

  /// No description provided for @panoMaintenanceScheduleTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bakım Takvimi'**
  String get panoMaintenanceScheduleTitle;

  /// No description provided for @panoMaintenanceScheduleBody.
  ///
  /// In tr, this message translates to:
  /// **'• Aylık: görsel kontrol (basınç göstergesi, tubing hasarı/korozyonu).\n• 6 ayda bir: basınç anahtarı, conta ve bağlantı kontrolü.\n• 5 yılda bir: silindir hidrostatik testi.\n• 10 yılda bir: sistem revizyonu / bileşen ömür sonu değerlendirmesi.\n• Her dolumda üretici dolum sertifikası alınmalı; sistem devre dışıysa (impaired) en kısa sürede (üretici/otorite talimatına göre azami 48 saat) devreye alınmalı veya yangın gözcüsü tahsis edilmelidir.'**
  String get panoMaintenanceScheduleBody;

  /// No description provided for @panoSourceFooter.
  ///
  /// In tr, this message translates to:
  /// **'Kaynak: LPS 1666 · UL 2166 · FM 5600 · VdS 2093'**
  String get panoSourceFooter;

  /// No description provided for @gasAltitudeFieldLabel.
  ///
  /// In tr, this message translates to:
  /// **'Rakım'**
  String get gasAltitudeFieldLabel;

  /// No description provided for @gasNoaelCo2Warning.
  ///
  /// In tr, this message translates to:
  /// **'⚠ CO² yüksek konsantrasyonlarda hayati tehlike oluşturur. Yalnızca insan bulunmayan hacimler için kullanılmalıdır. TS EN 15004-2 / NFPA 12.'**
  String get gasNoaelCo2Warning;

  /// No description provided for @gasNoaelLoaelExceeded.
  ///
  /// In tr, this message translates to:
  /// **'⚠ Tasarım konsantrasyonu ({percent}%) LOAEL sınırını ({loael}%) ASIYOR — tahliye zorunludur, yüksek risk!  (NFPA 2001:2022 Tablo 5.6.2.1)'**
  String gasNoaelLoaelExceeded(String percent, String loael);

  /// No description provided for @gasNoaelReached.
  ///
  /// In tr, this message translates to:
  /// **'⚠ Tasarım konsantrasyonu ({percent}%) NOAEL sınırına ({noael}%) ulaşıyor veya aşıyor — kullanım öncesi tahliye şarttır.  (NFPA 2001:2022 Tablo 5.6.2.1)'**
  String gasNoaelReached(String percent, String noael);

  /// No description provided for @gasNoaelOk.
  ///
  /// In tr, this message translates to:
  /// **'✓ Tasarım konsantrasyonu ({percent}%) NOAEL ({noael}%) altında. NFPA 2001:2022 kapsamında insan varlığında kullanılabilir.  LOAEL: {loael}%'**
  String gasNoaelOk(String percent, String noael, String loael);

  /// No description provided for @gasAgentHfc227Desc.
  ///
  /// In tr, this message translates to:
  /// **'Sıvılaşmış halokarbon. 25/42/50 bar N₂ şişeleme. Maks. dolum yoğunluğu 1150 kg/m³. Elektrik/elektronik odalar için idealdir. (EN 15004-5 Tablo 6-8)'**
  String get gasAgentHfc227Desc;

  /// No description provided for @gasAgentFk512Desc.
  ///
  /// In tr, this message translates to:
  /// **'Düşük GWP. Hassas ekipman odaları, arşivler, müzeler.'**
  String get gasAgentFk512Desc;

  /// No description provided for @gasAgentCo2Desc.
  ///
  /// In tr, this message translates to:
  /// **'Toplam taşkın — YALNIZCA insan bulunmayan hacimler. Sınıf B konsantrasyonu yakıta özel: heptan %34, toluen/benzen %37, etil asetat %38, MEK %40, IPA/etanol/metanol %53 (NFPA 12 Tablo A.5.3.2.1).'**
  String get gasAgentCo2Desc;

  /// No description provided for @gasAgentIg541Desc.
  ///
  /// In tr, this message translates to:
  /// **'N²/Ar/CO² (52/40/8) karışımı. Oksijen seyreltme. İnsan varlığında kullanılabilir.'**
  String get gasAgentIg541Desc;

  /// No description provided for @gasAgentIg55Desc.
  ///
  /// In tr, this message translates to:
  /// **'N²/Ar (50/50) karışımı. Çevre dostu. İnsan varlığında kullanılabilir.'**
  String get gasAgentIg55Desc;

  /// No description provided for @gasAgentIg100Desc.
  ///
  /// In tr, this message translates to:
  /// **'Saf azot. Oksijen seyreltme. Kolay temin edilebilir.'**
  String get gasAgentIg100Desc;

  /// No description provided for @gasAgentIg01Desc.
  ///
  /// In tr, this message translates to:
  /// **'Saf argon. Oksijen seyreltme ile söndürme. 160 / 200 / 300 bar şişeleme. Kimyasal kalıntı bırakmaz. İnsan varlığında kullanılabilir. (TS EN 15004-7 Çizelge 6-8)'**
  String get gasAgentIg01Desc;

  /// No description provided for @wallMaterialConcrete.
  ///
  /// In tr, this message translates to:
  /// **'Beton / Kagir'**
  String get wallMaterialConcrete;

  /// No description provided for @wallMaterialLightBlock.
  ///
  /// In tr, this message translates to:
  /// **'Hafif Beton Blok'**
  String get wallMaterialLightBlock;

  /// No description provided for @wallMaterialGypsum.
  ///
  /// In tr, this message translates to:
  /// **'Alçıpan (Çift)'**
  String get wallMaterialGypsum;

  /// No description provided for @smokeLayerHeightError.
  ///
  /// In tr, this message translates to:
  /// **'Hata: z ≥ H — duman katmanı oluşamaz. z < {height} m olmalı.'**
  String smokeLayerHeightError(String height);

  /// No description provided for @smokeLayerLowWarning.
  ///
  /// In tr, this message translates to:
  /// **'Uyarı: z = {z} m < 2.5 m — tahliye güvenliği yetersiz.  d (duman derinliği) = {d} m'**
  String smokeLayerLowWarning(String z, String d);

  /// No description provided for @smokeLayerDepthInfo.
  ///
  /// In tr, this message translates to:
  /// **'z = {z} m  →  d (duman derinliği) = {d} m  (H − z = {height} − {z})'**
  String smokeLayerDepthInfo(String z, String d, String height);

  /// No description provided for @smokeNoteNaturalPlume.
  ///
  /// In tr, this message translates to:
  /// **'Plume: Yangın üzerine yükselen sıcak gaz/duman sütunu. Kütle debisi (Thomas formülü, EN 12101-2 Ek B): ṁₚ = 0.071×Qc¹³×z⁵³ + 0.0018×Qc'**
  String get smokeNoteNaturalPlume;

  /// No description provided for @smokeNoteNaturalCd.
  ///
  /// In tr, this message translates to:
  /// **'Cd = 0.5 (çatı menfezi, EN 12101-2 §6.4)'**
  String get smokeNoteNaturalCd;

  /// No description provided for @smokeNoteNaturalFreshAir.
  ///
  /// In tr, this message translates to:
  /// **'Taze hava girişi alt bölgeden; açıklıklar eşit dağıtılmalı'**
  String get smokeNoteNaturalFreshAir;

  /// No description provided for @smokeNoteMinimumAreaCaveat.
  ///
  /// In tr, this message translates to:
  /// **'Hesap minimum alandır; sektörleme ve güvenlik payı ayrıca eklenmeli'**
  String get smokeNoteMinimumAreaCaveat;

  /// No description provided for @smokeNoteResponsibilityNatural.
  ///
  /// In tr, this message translates to:
  /// **'Sorumluluk: Bu hesap gerçekleştirilen ön tasarım amaçlıdır. Kesin tasarım yetkili yangın mühendisi tarafından onaylanmalıdır.'**
  String get smokeNoteResponsibilityNatural;

  /// No description provided for @smokeNoteMechanicalPlume.
  ///
  /// In tr, this message translates to:
  /// **'Plume: Yangın üzerine yükselen sıcak gaz/duman sütunu. Fan kapasitesi plume debisini karşılayacak büyüklükte seçilir.'**
  String get smokeNoteMechanicalPlume;

  /// No description provided for @smokeNoteMinAirChange.
  ///
  /// In tr, this message translates to:
  /// **'Min. hava değişimi ≥ 10/h (EN 12101-3 §5.2)'**
  String get smokeNoteMinAirChange;

  /// No description provided for @smokeNoteFanTempRating.
  ///
  /// In tr, this message translates to:
  /// **'Fan sıcaklık dayanımı ≥ 400 °C / 120 dk (F400) — EN 12101-3'**
  String get smokeNoteFanTempRating;

  /// No description provided for @smokeNoteFreshAirPercent.
  ///
  /// In tr, this message translates to:
  /// **'Taze hava girişi duman tahliye debisinin en az %70\'i olmalı'**
  String get smokeNoteFreshAirPercent;

  /// No description provided for @smokeNoteResponsibility.
  ///
  /// In tr, this message translates to:
  /// **'Sorumluluk: Bu hesap ön tasarım amaçlıdır. Kesin tasarım yetkili yangın mühendisi tarafından onaylanmalıdır.'**
  String get smokeNoteResponsibility;

  /// No description provided for @smokeNoteDoorFlowExplain.
  ///
  /// In tr, this message translates to:
  /// **'Açık kapı geçiş debisi: tahliye sırasında bir kat kapısı açıkken merdivenden akan hava — fanın karşılaması gereken en büyük ani yük'**
  String get smokeNoteDoorFlowExplain;

  /// No description provided for @smokeNoteDoorFlowFormula.
  ///
  /// In tr, this message translates to:
  /// **'Hesap: Q = A_kapı × √(2ΔP/ρ)  — kapı tam açık, tam ΔP geçerli kabulü (güvenli taraf)'**
  String get smokeNoteDoorFlowFormula;

  /// No description provided for @smokeNoteWallLeakageConcrete.
  ///
  /// In tr, this message translates to:
  /// **'Duvar sızıntısı: beton/kagir şaft için 1.3×10⁻⁴ m²/m²  (EN 12101-6 Ek F Tablo F.1)'**
  String get smokeNoteWallLeakageConcrete;

  /// No description provided for @smokeNoteDoorGapCd.
  ///
  /// In tr, this message translates to:
  /// **'Kapı aralık genişliği 10 mm, Cd = 0.83  (EN 12101-6 Ek F)'**
  String get smokeNoteDoorGapCd;

  /// No description provided for @smokeNoteDoorForceCheck.
  ///
  /// In tr, this message translates to:
  /// **'Açık kapı koşulunda kapı itme kuvveti ≤ 100 N kontrol edilmeli'**
  String get smokeNoteDoorForceCheck;

  /// No description provided for @smokeNotePressureLimit.
  ///
  /// In tr, this message translates to:
  /// **'ΔP sınır: ≥ 50 Pa (yangın katında) / ≤ 60 Pa (diğer katlar)'**
  String get smokeNotePressureLimit;

  /// No description provided for @fanCriterionMinAirChange.
  ///
  /// In tr, this message translates to:
  /// **'min. hava değişimi kriteri'**
  String get fanCriterionMinAirChange;

  /// No description provided for @fanCriterionPlumeFlow.
  ///
  /// In tr, this message translates to:
  /// **'plume debisi kriteri'**
  String get fanCriterionPlumeFlow;

  /// No description provided for @spFormulaInfo.
  ///
  /// In tr, this message translates to:
  /// **'EN 12845 / TS EN 12845 — Sabit Söndürücü Sistemler · Otomatik Sprinkler\nTehlike sınıfına göre kritik devre hidrolik hesabı  ·  Hazen–Williams (seçilebilir boru malzemesi C katsayısı)'**
  String get spFormulaInfo;

  /// No description provided for @spFieldWidthM.
  ///
  /// In tr, this message translates to:
  /// **'En  (m)'**
  String get spFieldWidthM;

  /// No description provided for @spFieldLengthM.
  ///
  /// In tr, this message translates to:
  /// **'Boy  (m)'**
  String get spFieldLengthM;

  /// No description provided for @spFieldCeilingM.
  ///
  /// In tr, this message translates to:
  /// **'Tavan  (m)'**
  String get spFieldCeilingM;

  /// No description provided for @spSuspendedCeilingCheckbox.
  ///
  /// In tr, this message translates to:
  /// **'Asma tavan mevcut (gizli boşluk)'**
  String get spSuspendedCeilingCheckbox;

  /// No description provided for @spVoidDepthLabel.
  ///
  /// In tr, this message translates to:
  /// **'Boşluk Derinliği  (cm)'**
  String get spVoidDepthLabel;

  /// No description provided for @spVoidDepthInfo.
  ///
  /// In tr, this message translates to:
  /// **'EN 12845 Md. 5.4: Boşluk derinliği > 80 cm ise gizli boşluğa ek sprinkler sistemi kurulması gerekir.'**
  String get spVoidDepthInfo;

  /// No description provided for @spBuildingActivityFieldLabel.
  ///
  /// In tr, this message translates to:
  /// **'Bina Faaliyeti'**
  String get spBuildingActivityFieldLabel;

  /// No description provided for @spSelectActivityPlaceholder.
  ///
  /// In tr, this message translates to:
  /// **'Faaliyeti seçiniz…'**
  String get spSelectActivityPlaceholder;

  /// No description provided for @spHazardClassInline.
  ///
  /// In tr, this message translates to:
  /// **'Tehlike Sınıfı: {name}'**
  String spHazardClassInline(String name);

  /// No description provided for @spHazardClassDetail.
  ///
  /// In tr, this message translates to:
  /// **'Yoğunluk: {density} mm/min  ·  Tasarım alanı: {area} m²  ·  Maks. kapsama: {coverage} m²/sprinkler'**
  String spHazardClassDetail(String density, String area, String coverage);

  /// No description provided for @spSprinklerTypeLabel.
  ///
  /// In tr, this message translates to:
  /// **'Sprinkler Tipi (K-Faktör)'**
  String get spSprinklerTypeLabel;

  /// No description provided for @spInstallationClassLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kurulum Sınıfı / Pompa Yedekliliği'**
  String get spInstallationClassLabel;

  /// No description provided for @spDryPipeCheckbox.
  ///
  /// In tr, this message translates to:
  /// **'Kuru borulu sistem (donma riskli alan)'**
  String get spDryPipeCheckbox;

  /// No description provided for @spDryPipeInfo.
  ///
  /// In tr, this message translates to:
  /// **'Kuru borulu sistemlerde şebekeye hava/nitrojen basılır ve tetikleme (trip) süresi, kompresör kapasitesi ve boru eğimi (drenaj) ayrıca tasarlanmalıdır. Donma riski olmayan alanlarda ıslak sistem tercih edilmelidir.'**
  String get spDryPipeInfo;

  /// No description provided for @spRackStorageCheckbox.
  ///
  /// In tr, this message translates to:
  /// **'Raf / palet depolama — In-Rack sprinkler (ön tasarım)'**
  String get spRackStorageCheckbox;

  /// No description provided for @spRackLevelsLabel.
  ///
  /// In tr, this message translates to:
  /// **'Raf Kat Sayısı (in-rack seviyesi)'**
  String get spRackLevelsLabel;

  /// No description provided for @spUnitLevel.
  ///
  /// In tr, this message translates to:
  /// **'kat'**
  String get spUnitLevel;

  /// No description provided for @spRackInfo.
  ///
  /// In tr, this message translates to:
  /// **'Bu yalnızca ön fikir amaçlı basitleştirilmiş bir tahmindir. Kesin in-rack sprinkler sayısı, flue space (boşluk) genişliği ve kat aralığı EN 12845 Ek H kapsamında tam tasarımla belirlenmelidir.'**
  String get spRackInfo;

  /// No description provided for @spFoamSystemCheckbox.
  ///
  /// In tr, this message translates to:
  /// **'Köpük söndürme sistemi ekle (EN 13565-2)'**
  String get spFoamSystemCheckbox;

  /// No description provided for @spHydrocarbonSub.
  ///
  /// In tr, this message translates to:
  /// **'Benzin, motorin,\nakaryakıt, yağ'**
  String get spHydrocarbonSub;

  /// No description provided for @spPolarSolventSub.
  ///
  /// In tr, this message translates to:
  /// **'Aseton, etanol,\nsolvent, keton'**
  String get spPolarSolventSub;

  /// No description provided for @spFoamDurationMin.
  ///
  /// In tr, this message translates to:
  /// **'{minutes} dk'**
  String spFoamDurationMin(String minutes);

  /// No description provided for @spFoamPolarSolventInfo.
  ///
  /// In tr, this message translates to:
  /// **'EN 13565-2: Polar solventler için yalnızca AR-AFFF, FFFP veya MF-FFF konsantresi kullanılır. Koruma alanı olarak bina alanı (en × boy) baz alınır.'**
  String get spFoamPolarSolventInfo;

  /// No description provided for @spHHP4Warning.
  ///
  /// In tr, this message translates to:
  /// **'⚠  HHP4 — YOĞUN SU SİSTEMİ\nEN 12845 Çizelge 3 Notu: Bu sınıf standart sprinkler kapsamı dışındadır. Özel değerlendirme ve yetkili mühendis onayı zorunludur. Aşağıdaki hesap yalnızca ön fikir vermek amacıyla yapılmıştır; resmi tasarım olarak kullanılamaz.'**
  String get spHHP4Warning;

  /// No description provided for @spActivityDialogTitle.
  ///
  /// In tr, this message translates to:
  /// **'Faaliyet Alanı Seç'**
  String get spActivityDialogTitle;

  /// No description provided for @spNoResultsFound.
  ///
  /// In tr, this message translates to:
  /// **'Sonuç bulunamadı'**
  String get spNoResultsFound;

  /// No description provided for @spKFactorWarning.
  ///
  /// In tr, this message translates to:
  /// **'Seçilen K-Faktör (K{selected}), {sinifKod} sınıfının gerektirdiği minimum K{minK} değerinin altındadır — üretici onayı ve tam hidrolik hesap doğrulaması zorunludur.'**
  String spKFactorWarning(String selected, String sinifKod, String minK);

  /// No description provided for @spCeilingWarningLH.
  ///
  /// In tr, this message translates to:
  /// **'LH — Tavan yüksekliği > 6 m: Standart sprinkler performansı yetersiz kalabilir. ESFR veya yüksek hacim tipi özel tasarım önerilir.'**
  String get spCeilingWarningLH;

  /// No description provided for @spCeilingWarningOH.
  ///
  /// In tr, this message translates to:
  /// **'OH — Tavan yüksekliği > 6 m: Standart sprinkler etkinliği düşebilir. Tasarım öncesinde yetkili merciyle görüşülmesi tavsiye edilir.'**
  String get spCeilingWarningOH;

  /// No description provided for @spCeilingWarningHH.
  ///
  /// In tr, this message translates to:
  /// **'HHP/HHS — Tavan yüksekliği > 6 m: §7.2.2.3 kapsamında boşluk > 4 m ise yoğunluk artırımı (her ilave metre için +1 mm/dk) ve min. K115 sprinkler gereklidir.'**
  String get spCeilingWarningHH;

  /// No description provided for @spSinifAdLH.
  ///
  /// In tr, this message translates to:
  /// **'Düşük Tehlike (LH)'**
  String get spSinifAdLH;

  /// No description provided for @spSinifAdOH1.
  ///
  /// In tr, this message translates to:
  /// **'Orta Tehlike Grup 1 (OH1)'**
  String get spSinifAdOH1;

  /// No description provided for @spSinifAdOH2.
  ///
  /// In tr, this message translates to:
  /// **'Orta Tehlike Grup 2 (OH2)'**
  String get spSinifAdOH2;

  /// No description provided for @spSinifAdOH3.
  ///
  /// In tr, this message translates to:
  /// **'Orta Tehlike Grup 3 (OH3)'**
  String get spSinifAdOH3;

  /// No description provided for @spSinifAdOH4.
  ///
  /// In tr, this message translates to:
  /// **'Orta Tehlike Grup 4 (OH4)'**
  String get spSinifAdOH4;

  /// No description provided for @spSinifAdHHP1.
  ///
  /// In tr, this message translates to:
  /// **'Yüksek Tehlike Püskürtme Grup 1 (HHP1)'**
  String get spSinifAdHHP1;

  /// No description provided for @spSinifAdHHP2.
  ///
  /// In tr, this message translates to:
  /// **'Yüksek Tehlike Püskürtme Grup 2 (HHP2)'**
  String get spSinifAdHHP2;

  /// No description provided for @spSinifAdHHP3.
  ///
  /// In tr, this message translates to:
  /// **'Yüksek Tehlike Püskürtme Grup 3 (HHP3)'**
  String get spSinifAdHHP3;

  /// No description provided for @spSinifAdHHP4.
  ///
  /// In tr, this message translates to:
  /// **'Yüksek Tehlike Püskürtme Grup 4 (HHP4) — ⚠ Yoğun Su / Özel Sistem'**
  String get spSinifAdHHP4;

  /// No description provided for @spSinifAdSF1.
  ///
  /// In tr, this message translates to:
  /// **'Depolama Kat. I — Serbest Döşeme (≤ 3 m)'**
  String get spSinifAdSF1;

  /// No description provided for @spSinifAdSF2.
  ///
  /// In tr, this message translates to:
  /// **'Depolama Kat. II — Serbest Döşeme (≤ 3,5 m)'**
  String get spSinifAdSF2;

  /// No description provided for @spSinifAdSF3.
  ///
  /// In tr, this message translates to:
  /// **'Depolama Kat. III — Serbest Döşeme (≤ 3,5 m)'**
  String get spSinifAdSF3;

  /// No description provided for @spSinifAdSF4.
  ///
  /// In tr, this message translates to:
  /// **'Depolama Kat. IV — Serbest Döşeme (≤ 3,5 m)'**
  String get spSinifAdSF4;

  /// No description provided for @spSinifAdRS1.
  ///
  /// In tr, this message translates to:
  /// **'Depolama Kat. I — Raf / Palet Depolama'**
  String get spSinifAdRS1;

  /// No description provided for @spSinifAdRS2.
  ///
  /// In tr, this message translates to:
  /// **'Depolama Kat. II — Raf / Palet Depolama'**
  String get spSinifAdRS2;

  /// No description provided for @spSinifAdRS3.
  ///
  /// In tr, this message translates to:
  /// **'Depolama Kat. III — Raf / Palet Depolama'**
  String get spSinifAdRS3;

  /// No description provided for @spSinifAdRS4.
  ///
  /// In tr, this message translates to:
  /// **'Depolama Kat. IV — Raf / Palet Depolama'**
  String get spSinifAdRS4;

  /// No description provided for @spTipAdAuto.
  ///
  /// In tr, this message translates to:
  /// **'Sınıfa Göre Otomatik'**
  String get spTipAdAuto;

  /// No description provided for @spTipDescAuto.
  ///
  /// In tr, this message translates to:
  /// **'Standart K80 (LH/OH) veya K115 (HH) — varsayılan'**
  String get spTipDescAuto;

  /// No description provided for @spTipAdK57.
  ///
  /// In tr, this message translates to:
  /// **'Standart K57'**
  String get spTipAdK57;

  /// No description provided for @spTipDescK57.
  ///
  /// In tr, this message translates to:
  /// **'Yalnızca özel onaylı düşük debili uygulamalarda'**
  String get spTipDescK57;

  /// No description provided for @spTipAdK80.
  ///
  /// In tr, this message translates to:
  /// **'Standart K80'**
  String get spTipAdK80;

  /// No description provided for @spTipDescK80.
  ///
  /// In tr, this message translates to:
  /// **'LH/OH sınıfları için standart'**
  String get spTipDescK80;

  /// No description provided for @spTipAdK115.
  ///
  /// In tr, this message translates to:
  /// **'Yüksek Debili K115'**
  String get spTipAdK115;

  /// No description provided for @spTipDescK115.
  ///
  /// In tr, this message translates to:
  /// **'HH sınıfları için standart'**
  String get spTipDescK115;

  /// No description provided for @spTipAdK161.
  ///
  /// In tr, this message translates to:
  /// **'Büyük Damla K161'**
  String get spTipAdK161;

  /// No description provided for @spTipDescK161.
  ///
  /// In tr, this message translates to:
  /// **'Yüksek depolama / raf sistemleri — üretici onayı gerekir'**
  String get spTipDescK161;

  /// No description provided for @spTipAdK200.
  ///
  /// In tr, this message translates to:
  /// **'Ekstra Büyük Damla K200'**
  String get spTipAdK200;

  /// No description provided for @spTipDescK200.
  ///
  /// In tr, this message translates to:
  /// **'Özel yüksek debili uygulamalar — üretici onayı gerekir'**
  String get spTipDescK200;

  /// No description provided for @spTipAdEsfr.
  ///
  /// In tr, this message translates to:
  /// **'ESFR K242 (bilgi amaçlı)'**
  String get spTipAdEsfr;

  /// No description provided for @spTipDescEsfr.
  ///
  /// In tr, this message translates to:
  /// **'Erken bastırma hızlı tepki — EN 12845 kapsamı dışıdır; NFPA 13 / listeleme verisi esas alınmalıdır'**
  String get spTipDescEsfr;

  /// No description provided for @spKurulumAdSingle.
  ///
  /// In tr, this message translates to:
  /// **'Tekli Kaynak + Tek Pompa'**
  String get spKurulumAdSingle;

  /// No description provided for @spKurulumDescSingle.
  ///
  /// In tr, this message translates to:
  /// **'Yedekliliği yoktur — yalnızca LH ve düşük riskli, tek kaynaklı tesislerde kabul edilebilir.'**
  String get spKurulumDescSingle;

  /// No description provided for @spKurulumAdDual.
  ///
  /// In tr, this message translates to:
  /// **'Çiftli Pompa (Elektrik + Dizel)'**
  String get spKurulumAdDual;

  /// No description provided for @spKurulumDescDual.
  ///
  /// In tr, this message translates to:
  /// **'OH ve çoğu HH tesisinde yaygın çözüm — elektrik kesintisinde dizel pompa otomatik devreye girer.'**
  String get spKurulumDescDual;

  /// No description provided for @spKurulumAdSuperior.
  ///
  /// In tr, this message translates to:
  /// **'Çiftli Kaynak + Çiftli Pompa (Superior)'**
  String get spKurulumAdSuperior;

  /// No description provided for @spKurulumDescSuperior.
  ///
  /// In tr, this message translates to:
  /// **'En yüksek güvenilirlik — kritik tesisler, HH sınıfları ve yüksek riskli depolarda önerilir; iki bağımsız su kaynağı ve pompa seti.'**
  String get spKurulumDescSuperior;

  /// No description provided for @spUnitAdet.
  ///
  /// In tr, this message translates to:
  /// **'adet'**
  String get spUnitAdet;

  /// No description provided for @spUnitSpacing.
  ///
  /// In tr, this message translates to:
  /// **'aralık'**
  String get spUnitSpacing;

  /// No description provided for @spUnitMinutes.
  ///
  /// In tr, this message translates to:
  /// **'dakika'**
  String get spUnitMinutes;

  /// No description provided for @spRcHeaderBuilding.
  ///
  /// In tr, this message translates to:
  /// **'Bina & Tasarım Parametreleri'**
  String get spRcHeaderBuilding;

  /// No description provided for @spRcHeaderLayout.
  ///
  /// In tr, this message translates to:
  /// **'Sprinkler Yerleşim Hesabı'**
  String get spRcHeaderLayout;

  /// No description provided for @spRcHeaderHydraulic.
  ///
  /// In tr, this message translates to:
  /// **'Kritik Devre Hidrolik Hesabı'**
  String get spRcHeaderHydraulic;

  /// No description provided for @spRcHeaderFullHydraulic.
  ///
  /// In tr, this message translates to:
  /// **'Kritik Devre — Tam Hidrolik Hesap'**
  String get spRcHeaderFullHydraulic;

  /// No description provided for @spRcHeaderPump.
  ///
  /// In tr, this message translates to:
  /// **'Pompa Gereksinimleri'**
  String get spRcHeaderPump;

  /// No description provided for @spRcHeaderInstallation.
  ///
  /// In tr, this message translates to:
  /// **'Kurulum Sınıfı & Pompa Yedekliliği'**
  String get spRcHeaderInstallation;

  /// No description provided for @spRcHeaderWaterTank.
  ///
  /// In tr, this message translates to:
  /// **'Su Deposu  —  EN 12845 Tablo 2'**
  String get spRcHeaderWaterTank;

  /// No description provided for @spRcHeaderDryPipe.
  ///
  /// In tr, this message translates to:
  /// **'Kuru Borulu Sistem  —  Donma Riski'**
  String get spRcHeaderDryPipe;

  /// No description provided for @spRcHeaderRackStorage.
  ///
  /// In tr, this message translates to:
  /// **'Raf Depolama — In-Rack Sprinkler (Ön Tasarım)'**
  String get spRcHeaderRackStorage;

  /// No description provided for @spRcHeaderPipeDiameterSummary.
  ///
  /// In tr, this message translates to:
  /// **'Boru Çapı Özeti  —  EN 12845 Tablo 14'**
  String get spRcHeaderPipeDiameterSummary;

  /// No description provided for @spRcHeaderPipeLength.
  ///
  /// In tr, this message translates to:
  /// **'Boru Metrajı (Yaklaşık)'**
  String get spRcHeaderPipeLength;

  /// No description provided for @spRcHeaderAlarmValve.
  ///
  /// In tr, this message translates to:
  /// **'Islak Alarm Vanası  —  EN 12845 Md. 11.2'**
  String get spRcHeaderAlarmValve;

  /// No description provided for @spRcHeaderFoamSystem.
  ///
  /// In tr, this message translates to:
  /// **'Köpük Sistemi  —  EN 13565-2'**
  String get spRcHeaderFoamSystem;

  /// No description provided for @spRcBuildingArea.
  ///
  /// In tr, this message translates to:
  /// **'Bina Alanı'**
  String get spRcBuildingArea;

  /// No description provided for @spRcCeilingHeight.
  ///
  /// In tr, this message translates to:
  /// **'Tavan Yüksekliği'**
  String get spRcCeilingHeight;

  /// No description provided for @spRcCoverageAdjustedSuffix.
  ///
  /// In tr, this message translates to:
  /// **'  ›  kapsama düzetildi: {value} m² (Yükseklik etkisi)'**
  String spRcCoverageAdjustedSuffix(String value);

  /// No description provided for @spRcHazardClass.
  ///
  /// In tr, this message translates to:
  /// **'Tehlike Sınıfı'**
  String get spRcHazardClass;

  /// No description provided for @spRcDesignDensity.
  ///
  /// In tr, this message translates to:
  /// **'Tasarım Yoğunluğu'**
  String get spRcDesignDensity;

  /// No description provided for @spRcDesignArea.
  ///
  /// In tr, this message translates to:
  /// **'Tasarım Alanı'**
  String get spRcDesignArea;

  /// No description provided for @spRcMaxCoveragePerSprinklerCap.
  ///
  /// In tr, this message translates to:
  /// **'Maks. Kapsama / Sprinkler'**
  String get spRcMaxCoveragePerSprinklerCap;

  /// No description provided for @spRcMaxCoveragePerSprinklerLow.
  ///
  /// In tr, this message translates to:
  /// **'Maks. kapsama / sprinkler'**
  String get spRcMaxCoveragePerSprinklerLow;

  /// No description provided for @spRcHeightAdjustSuffix.
  ///
  /// In tr, this message translates to:
  /// **'(yükseklik düzetmesi)'**
  String get spRcHeightAdjustSuffix;

  /// No description provided for @spRcTable20Title.
  ///
  /// In tr, this message translates to:
  /// **'Çizelge 20 — Yan Duvar Püskürtme Grupları (referans)'**
  String get spRcTable20Title;

  /// No description provided for @spRcMaxGroupDistance.
  ///
  /// In tr, this message translates to:
  /// **'Gruplar arası maks. mesafe'**
  String get spRcMaxGroupDistance;

  /// No description provided for @spRcNote2Suffix.
  ///
  /// In tr, this message translates to:
  /// **'  (Not 2: yangına 120 dk dayanımlı tavanda 3,7 m\'ye çıkabilir)'**
  String get spRcNote2Suffix;

  /// No description provided for @spRcMaxToWallEnd.
  ///
  /// In tr, this message translates to:
  /// **'Duvar sonuna kadar maks.'**
  String get spRcMaxToWallEnd;

  /// No description provided for @spRcTheoreticalSpacing.
  ///
  /// In tr, this message translates to:
  /// **'Alan bazlı teorik aralık  √A'**
  String get spRcTheoreticalSpacing;

  /// No description provided for @spRcTable19MaxDistance.
  ///
  /// In tr, this message translates to:
  /// **'Çizelge 19 — Maks. S ve D mesafesi'**
  String get spRcTable19MaxDistance;

  /// No description provided for @spRcAppliedGridSpacing.
  ///
  /// In tr, this message translates to:
  /// **'Uygulanan ızgara aralığı'**
  String get spRcAppliedGridSpacing;

  /// No description provided for @spRcDistanceConstraintBinding.
  ///
  /// In tr, this message translates to:
  /// **'⚠ MESAFE KISITI bağlayıcı (√A > maks.mesafe)'**
  String get spRcDistanceConstraintBinding;

  /// No description provided for @spRcAreaConstraintBinding.
  ///
  /// In tr, this message translates to:
  /// **'✓ Alan kısıtı bağlayıcı'**
  String get spRcAreaConstraintBinding;

  /// No description provided for @spRcHorizontalRow.
  ///
  /// In tr, this message translates to:
  /// **'Yatay sıra (en boyunca)'**
  String get spRcHorizontalRow;

  /// No description provided for @spRcVerticalRow.
  ///
  /// In tr, this message translates to:
  /// **'Dikey sıra (boy boyunca)'**
  String get spRcVerticalRow;

  /// No description provided for @spRcActualCoveragePerHead.
  ///
  /// In tr, this message translates to:
  /// **'Sprinkler başına gerçek kapsama'**
  String get spRcActualCoveragePerHead;

  /// No description provided for @spRcTotalSprinklers.
  ///
  /// In tr, this message translates to:
  /// **'TOPLAM SPRİNKLER'**
  String get spRcTotalSprinklers;

  /// No description provided for @spRcMainFloorSuffix.
  ///
  /// In tr, this message translates to:
  /// **'(ana kat)'**
  String get spRcMainFloorSuffix;

  /// No description provided for @spRcSprinklersInDesignArea.
  ///
  /// In tr, this message translates to:
  /// **'Tasarım alanındaki sprinklerler'**
  String get spRcSprinklersInDesignArea;

  /// No description provided for @spRcSuspendedCeilingVoid.
  ///
  /// In tr, this message translates to:
  /// **'Asma tavan boşluğu'**
  String get spRcSuspendedCeilingVoid;

  /// No description provided for @spRcExtraSprinklerRequired.
  ///
  /// In tr, this message translates to:
  /// **'⚠ Ek sprinkler zorunlu (> 80 cm)'**
  String get spRcExtraSprinklerRequired;

  /// No description provided for @spRcExtraSprinklerNotRequired.
  ///
  /// In tr, this message translates to:
  /// **'✓ Ek sprinkler gerekmez (≤ 80 cm)'**
  String get spRcExtraSprinklerNotRequired;

  /// No description provided for @spRcConcealedVoidSprinklerCount.
  ///
  /// In tr, this message translates to:
  /// **'Gizli boşluk sprinkler sayısı'**
  String get spRcConcealedVoidSprinklerCount;

  /// No description provided for @spRcAppliedToUpperGridSuffix.
  ///
  /// In tr, this message translates to:
  /// **'(aynı ızgara üst kata uygulanır)'**
  String get spRcAppliedToUpperGridSuffix;

  /// No description provided for @spRcFarthestHeadFlow.
  ///
  /// In tr, this message translates to:
  /// **'En uzak sprinkler debisi  q'**
  String get spRcFarthestHeadFlow;

  /// No description provided for @spRcDesignTotalFlow.
  ///
  /// In tr, this message translates to:
  /// **'Tasarım toplam debi  Q'**
  String get spRcDesignTotalFlow;

  /// No description provided for @spRcBranchPipeDN.
  ///
  /// In tr, this message translates to:
  /// **'Dal boru  DN{dn}'**
  String spRcBranchPipeDN(String dn);

  /// No description provided for @spRcCrossPipeDN.
  ///
  /// In tr, this message translates to:
  /// **'Dağıtım boru  DN{dn}'**
  String spRcCrossPipeDN(String dn);

  /// No description provided for @spRcMainPipeDN.
  ///
  /// In tr, this message translates to:
  /// **'Besleme / esas boru  DN{dn}'**
  String spRcMainPipeDN(String dn);

  /// No description provided for @spRcTotalFrictionLoss.
  ///
  /// In tr, this message translates to:
  /// **'Toplam sürtünme kaybı'**
  String get spRcTotalFrictionLoss;

  /// No description provided for @spRcStaticHeadFormula.
  ///
  /// In tr, this message translates to:
  /// **'Statik yük  ({height} m × 0.098)'**
  String spRcStaticHeadFormula(String height);

  /// No description provided for @spRcFarthestHeadMinPressure.
  ///
  /// In tr, this message translates to:
  /// **'Uzak sprinkler min. basıncı'**
  String get spRcFarthestHeadMinPressure;

  /// No description provided for @spRcSafetyMarginLabel.
  ///
  /// In tr, this message translates to:
  /// **'Emniyet marjı'**
  String get spRcSafetyMarginLabel;

  /// No description provided for @spRcColDistance.
  ///
  /// In tr, this message translates to:
  /// **'Mesafe\n(m)'**
  String get spRcColDistance;

  /// No description provided for @spRcColPressure.
  ///
  /// In tr, this message translates to:
  /// **'Basınç\n(bar)'**
  String get spRcColPressure;

  /// No description provided for @spRcColFlowLower.
  ///
  /// In tr, this message translates to:
  /// **'q\n(L/min)'**
  String get spRcColFlowLower;

  /// No description provided for @spRcColCumFlow.
  ///
  /// In tr, this message translates to:
  /// **'ΣQ\n(L/min)'**
  String get spRcColCumFlow;

  /// No description provided for @spRcColNextDeltaP.
  ///
  /// In tr, this message translates to:
  /// **'ΔP sonraki\n(bar)'**
  String get spRcColNextDeltaP;

  /// No description provided for @spRcSectionBranchPipe.
  ///
  /// In tr, this message translates to:
  /// **'── Dal Boru (Range Pipe) ──'**
  String get spRcSectionBranchPipe;

  /// No description provided for @spRcSectionDistPipe.
  ///
  /// In tr, this message translates to:
  /// **'── Tali Boru (Distribution Pipe) ──'**
  String get spRcSectionDistPipe;

  /// No description provided for @spRcSectionMainPipe.
  ///
  /// In tr, this message translates to:
  /// **'── Ana Boru (Main Pipe) ──'**
  String get spRcSectionMainPipe;

  /// No description provided for @spRcHydraulicFootnote.
  ///
  /// In tr, this message translates to:
  /// **'SP1 = en uzak sprinkler  ·  DP1 = tasarım noktası (design point)  ·  MP = esas boru  ·  K-orantılama: Q_j = Q_krit×√(P_j/P_DP)  ·  Hazen-Williams C=120, fitting payı %20 dahil  (EN 12845 §13.3.2)'**
  String get spRcHydraulicFootnote;

  /// No description provided for @spRcPumpFlowLabel.
  ///
  /// In tr, this message translates to:
  /// **'Pompa Debisi'**
  String get spRcPumpFlowLabel;

  /// No description provided for @spRcPumpPressureLabel.
  ///
  /// In tr, this message translates to:
  /// **'Pompa Basıncı'**
  String get spRcPumpPressureLabel;

  /// No description provided for @spRcTable6AppliedIntro.
  ///
  /// In tr, this message translates to:
  /// **'TS EN 12845+A1 Tablo 6 uygulandı — Ön-hesaplı sistemlerde pompa boyutlandırması için bağlayıcı minimum değerler:'**
  String get spRcTable6AppliedIntro;

  /// No description provided for @spRcTable6FlowLine.
  ///
  /// In tr, this message translates to:
  /// **'• Debi: iteratif hidrolik debi {calc} L/min < Tablo 6 min. {min} L/min → {min} L/min kullanıldı'**
  String spRcTable6FlowLine(String calc, String min);

  /// No description provided for @spRcTable6PressureLine.
  ///
  /// In tr, this message translates to:
  /// **'• Basınç: hesaplanan < Tablo 6 min. ({min} + ps) bar → {applied} bar uygulandı'**
  String spRcTable6PressureLine(String min, String applied);

  /// No description provided for @spRcMaxPressureWarning.
  ///
  /// In tr, this message translates to:
  /// **'⚠ EN 12845 §8.2 — Pompa basıncı {pressure} bar, sistemdeki herhangi bir sprinkler konumundaki maksimum işletme basıncı 12 bar\'ı aşmamalıdır. Basınç düşürücü vana (PRV) ile {zones} basınç zonuna ayrılması veya sistem yeniden tasarımı değerlendirilmelidir.'**
  String spRcMaxPressureWarning(String pressure, String zones);

  /// No description provided for @spRcInstallationClassLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kurulum Sınıfı'**
  String get spRcInstallationClassLabel;

  /// No description provided for @spRcPumpCount.
  ///
  /// In tr, this message translates to:
  /// **'Pompa Sayısı'**
  String get spRcPumpCount;

  /// No description provided for @spRcElectricDieselSuffix.
  ///
  /// In tr, this message translates to:
  /// **'  (elektrik + dizel)'**
  String get spRcElectricDieselSuffix;

  /// No description provided for @spRcWaterSource.
  ///
  /// In tr, this message translates to:
  /// **'Su Kaynağı'**
  String get spRcWaterSource;

  /// No description provided for @spRcDualIndependent.
  ///
  /// In tr, this message translates to:
  /// **'Çiftli (bağımsız)'**
  String get spRcDualIndependent;

  /// No description provided for @spRcSingle.
  ///
  /// In tr, this message translates to:
  /// **'Tekli'**
  String get spRcSingle;

  /// No description provided for @spRcJockeyPump.
  ///
  /// In tr, this message translates to:
  /// **'Jokey Pompa'**
  String get spRcJockeyPump;

  /// No description provided for @spRcWaterSupplyDuration.
  ///
  /// In tr, this message translates to:
  /// **'Su Besleme Süresi'**
  String get spRcWaterSupplyDuration;

  /// No description provided for @spRcSupplyDurationSub.
  ///
  /// In tr, this message translates to:
  /// **'{cls} → {minutes} dk'**
  String spRcSupplyDurationSub(String cls, String minutes);

  /// No description provided for @spRcMinWaterTank.
  ///
  /// In tr, this message translates to:
  /// **'Min. Su Deposu'**
  String get spRcMinWaterTank;

  /// No description provided for @spRcWaterSupplyNote.
  ///
  /// In tr, this message translates to:
  /// **'EN 12845:2015 Tablo 2 — Su beslemesi; depo veya dorudan şebeke bağlantısı ile sağlanabilir. Depoda hangi konum seçilirse emniyet payı eklenmesi tavsiye edilir.'**
  String get spRcWaterSupplyNote;

  /// No description provided for @spRcPipeNetworkVolume.
  ///
  /// In tr, this message translates to:
  /// **'Boru Şebekesi İç Hacmi'**
  String get spRcPipeNetworkVolume;

  /// No description provided for @spRcDryPipeNote.
  ///
  /// In tr, this message translates to:
  /// **'Bu hacim yalnızca hava kompresörü / nitrojen jeneratörü ve priming suyu ön boyutlandırması için bir referanstır. Tetikleme (trip) süresi, aksesuar (accelerator/exhauster) ihtiyacı ve boru eğimi ayrıca üretici/tasarım standardına göre kesinleştirilmelidir.'**
  String get spRcDryPipeNote;

  /// No description provided for @spRcRackLevelCount.
  ///
  /// In tr, this message translates to:
  /// **'Raf Kat Sayısı'**
  String get spRcRackLevelCount;

  /// No description provided for @spRcEstExtraInRackSprinklers.
  ///
  /// In tr, this message translates to:
  /// **'Tahmini Ek In-Rack Sprinkler'**
  String get spRcEstExtraInRackSprinklers;

  /// No description provided for @spRcEstExtraFlow.
  ///
  /// In tr, this message translates to:
  /// **'Tahmini Ek Debi'**
  String get spRcEstExtraFlow;

  /// No description provided for @spRcRackNote.
  ///
  /// In tr, this message translates to:
  /// **'Basitleştirilmiş ön tasarım değeridir (3 m yatay aralık varsayımı, K80, 1,0 bar). Kesin in-rack yerleşimi — flue space genişliği, kat aralığı ve gerçek hidrolik talep — EN 12845 Ek H kapsamında tam tasarımla belirlenmeli ve pompa/su deposu hesabına ayrıca eklenmelidir.'**
  String get spRcRackNote;

  /// No description provided for @spRcHHPTable14Warning.
  ///
  /// In tr, this message translates to:
  /// **'⚠  HHP sınıfı: EN 12845 Tablo 14 uygulanmaz. Çaplar EN 12845 Ek C kapsamında tam hidrolik hesapla belirlenir. Aşağıdaki değerler hız ≤ 5 m/s ön hesap yöntemine göre verilmiştir.'**
  String get spRcHHPTable14Warning;

  /// No description provided for @spRcSprinklerTypeKFactor.
  ///
  /// In tr, this message translates to:
  /// **'Sprinkler Tipi / K-Faktör'**
  String get spRcSprinklerTypeKFactor;

  /// No description provided for @spRcBranchPipeRow.
  ///
  /// In tr, this message translates to:
  /// **'Dal boru (branch line)'**
  String get spRcBranchPipeRow;

  /// No description provided for @spRcVelocityMethodSuffix.
  ///
  /// In tr, this message translates to:
  /// **'  (hız yöntemi)'**
  String get spRcVelocityMethodSuffix;

  /// No description provided for @spRcTable14Suffix.
  ///
  /// In tr, this message translates to:
  /// **'  (Tb.14)'**
  String get spRcTable14Suffix;

  /// No description provided for @spRcCrossMainRow.
  ///
  /// In tr, this message translates to:
  /// **'Dağıtım borusu (cross main)'**
  String get spRcCrossMainRow;

  /// No description provided for @spRcBranchConnCount.
  ///
  /// In tr, this message translates to:
  /// **'{branches} dal kol / {heads} spr.'**
  String spRcBranchConnCount(String branches, String heads);

  /// No description provided for @spRcMainSupplyRow.
  ///
  /// In tr, this message translates to:
  /// **'Esas boru / besleme'**
  String get spRcMainSupplyRow;

  /// No description provided for @spRcDesignAreaHeadsSuffix.
  ///
  /// In tr, this message translates to:
  /// **'{n} spr. (tasarım alanı)'**
  String spRcDesignAreaHeadsSuffix(String n);

  /// No description provided for @spRcColPipeType.
  ///
  /// In tr, this message translates to:
  /// **'Boru Türü'**
  String get spRcColPipeType;

  /// No description provided for @spRcColCountLength.
  ///
  /// In tr, this message translates to:
  /// **'Adet × Uzunluk'**
  String get spRcColCountLength;

  /// No description provided for @spRcColTotalM.
  ///
  /// In tr, this message translates to:
  /// **'Toplam (m)'**
  String get spRcColTotalM;

  /// No description provided for @spRcRowBranchPipe.
  ///
  /// In tr, this message translates to:
  /// **'Dal boru (branch)'**
  String get spRcRowBranchPipe;

  /// No description provided for @spRcRowCrossMain.
  ///
  /// In tr, this message translates to:
  /// **'Dağıtım (cross main)\n[{n} dal kol bağlantısı]'**
  String spRcRowCrossMain(String n);

  /// No description provided for @spRcRowMainPipe.
  ///
  /// In tr, this message translates to:
  /// **'Esas boru (main)\n[pompa + kalan boy]'**
  String get spRcRowMainPipe;

  /// No description provided for @spRcTotalPipeLength.
  ///
  /// In tr, this message translates to:
  /// **'TOPLAM BORU METRAJ'**
  String get spRcTotalPipeLength;

  /// No description provided for @spRcPipeLengthFootnote.
  ///
  /// In tr, this message translates to:
  /// **'* Metraj yaklaşık değerdir. %20 bağlantı eklentisi hesaba katılmıştır. Gerçek metraj için mimari plan üzerinde tam hesap yapılmalıdır.'**
  String get spRcPipeLengthFootnote;

  /// No description provided for @spRcRequiredAlarmValve.
  ///
  /// In tr, this message translates to:
  /// **'Gerekli Islak Alarm Vanası:  '**
  String get spRcRequiredAlarmValve;

  /// No description provided for @spRcTotalSprinklersRow.
  ///
  /// In tr, this message translates to:
  /// **'Toplam sprinkler'**
  String get spRcTotalSprinklersRow;

  /// No description provided for @spRcMaxSprinklersPerValve.
  ///
  /// In tr, this message translates to:
  /// **'Maks. sprinkler / vana'**
  String get spRcMaxSprinklersPerValve;

  /// No description provided for @spRcHHPClassSuffix.
  ///
  /// In tr, this message translates to:
  /// **'HHP sınıfı'**
  String get spRcHHPClassSuffix;

  /// No description provided for @spRcLHOHClassSuffix.
  ///
  /// In tr, this message translates to:
  /// **'LH/OH sınıfı'**
  String get spRcLHOHClassSuffix;

  /// No description provided for @spRcMaxAreaPerValve.
  ///
  /// In tr, this message translates to:
  /// **'Maks. alan / vana'**
  String get spRcMaxAreaPerValve;

  /// No description provided for @spRcAreaPerValve.
  ///
  /// In tr, this message translates to:
  /// **'Vana başına alan'**
  String get spRcAreaPerValve;

  /// No description provided for @spRcDesignFlowPerValve.
  ///
  /// In tr, this message translates to:
  /// **'Her vana için tasarım debisi'**
  String get spRcDesignFlowPerValve;

  /// No description provided for @spRcSingleValveSuffix.
  ///
  /// In tr, this message translates to:
  /// **'  (tüm sistem tek vana üzerinden hesaplanır)'**
  String get spRcSingleValveSuffix;

  /// No description provided for @spRcAlarmValveNote.
  ///
  /// In tr, this message translates to:
  /// **'EN 12845:2015 Madde 11.2.1: Bir ıslak alarm vanası bölgesi {scope} yüzey alanı koruyabilir.'**
  String spRcAlarmValveNote(String scope);

  /// No description provided for @spRcAlarmValveScopeHH.
  ///
  /// In tr, this message translates to:
  /// **'HHP sınıflarında en fazla 500 sprinkler ve 2 300 m²'**
  String get spRcAlarmValveScopeHH;

  /// No description provided for @spRcAlarmValveScopeLHOH.
  ///
  /// In tr, this message translates to:
  /// **'LH/OH sınıflarında en fazla 1 000 sprinkler ve 4 800 m²'**
  String get spRcAlarmValveScopeLHOH;

  /// No description provided for @spRcConcentrateType.
  ///
  /// In tr, this message translates to:
  /// **'Konsantre tipi'**
  String get spRcConcentrateType;

  /// No description provided for @spRcConcentrationSuffix.
  ///
  /// In tr, this message translates to:
  /// **'  —  %{pct} konsantrasyon'**
  String spRcConcentrationSuffix(String pct);

  /// No description provided for @spRcLiquidCategory.
  ///
  /// In tr, this message translates to:
  /// **'Sıvı kategorisi'**
  String get spRcLiquidCategory;

  /// No description provided for @spRcPolarSolventDetail.
  ///
  /// In tr, this message translates to:
  /// **'Polar Solvent (B2) — aseton, etanol, keton, solvent'**
  String get spRcPolarSolventDetail;

  /// No description provided for @spRcHydrocarbonDetail.
  ///
  /// In tr, this message translates to:
  /// **'Hidrokarbon (B1) — benzin, motorin, yağ'**
  String get spRcHydrocarbonDetail;

  /// No description provided for @spRcProtectedArea.
  ///
  /// In tr, this message translates to:
  /// **'Koruma alanı'**
  String get spRcProtectedArea;

  /// No description provided for @spRcApplicationRate.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama hızı'**
  String get spRcApplicationRate;

  /// No description provided for @spRcApplicationDuration.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama süresi'**
  String get spRcApplicationDuration;

  /// No description provided for @spRcSolutionFlow.
  ///
  /// In tr, this message translates to:
  /// **'Çözelti debisi (Q)'**
  String get spRcSolutionFlow;

  /// No description provided for @spRcConcentrateFlow.
  ///
  /// In tr, this message translates to:
  /// **'  Konsantre debisi'**
  String get spRcConcentrateFlow;

  /// No description provided for @spRcWaterFlow.
  ///
  /// In tr, this message translates to:
  /// **'  Su debisi'**
  String get spRcWaterFlow;

  /// No description provided for @spRcConcentrateTankVolume.
  ///
  /// In tr, this message translates to:
  /// **'Konsantre tank hacmi'**
  String get spRcConcentrateTankVolume;

  /// No description provided for @spRcWaterReserve.
  ///
  /// In tr, this message translates to:
  /// **'Su rezervi'**
  String get spRcWaterReserve;

  /// No description provided for @spRcFoamNote7.
  ///
  /// In tr, this message translates to:
  /// **'EN 13565-2 Madde 7: Konsantre tank hacmi ve su rezervi minimum değerlerdir. Gerçek tasarımda emniyet payı ve eş zamanlı kullanım dikkate alınmalıdır.'**
  String get spRcFoamNote7;

  /// No description provided for @spRcFinalDisclaimer.
  ///
  /// In tr, this message translates to:
  /// **'⚠  Bu yaklaşık ön hesap niteliğindedir. Resmi proje tasarımında EN 12845 Ek C kapsamında tam hidrolik hesap ve yetkili mühendis onayı zorunludur. Bağlantı elemanı kayıpları için uzunluklara +%20 eklentisi hesaba katılmıştır.'**
  String get spRcFinalDisclaimer;

  /// No description provided for @updateAvailableTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Sürüm Mevcut'**
  String get updateAvailableTitle;

  /// No description provided for @updateAvailableMessage.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama v{version} sürümüne güncellendi.\nEn yeni özellikleri kullanmak için güncelleyiniz.'**
  String updateAvailableMessage(String version);

  /// No description provided for @updateLaterButton.
  ///
  /// In tr, this message translates to:
  /// **'Sonra'**
  String get updateLaterButton;

  /// No description provided for @updateNowButton.
  ///
  /// In tr, this message translates to:
  /// **'Güncelle'**
  String get updateNowButton;

  /// No description provided for @loginRateLimitMessage.
  ///
  /// In tr, this message translates to:
  /// **'Çok fazla hatalı giriş denemesi. {time} sonra tekrar deneyin.'**
  String loginRateLimitMessage(String time);

  /// No description provided for @savedOnLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kaydedilme: {date}'**
  String savedOnLabel(String date);

  /// No description provided for @upgradeRequiredTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sürüm Yükselt'**
  String get upgradeRequiredTitle;

  /// No description provided for @upgradeRequiredMessage.
  ///
  /// In tr, this message translates to:
  /// **'Bu modül demo sürümünde kullanılamaz. Tüm modüllere erişmek için MEVOS hesabınızı oluşturup Yangın modülü aboneliğini başlatın.'**
  String get upgradeRequiredMessage;

  /// No description provided for @upgradeSignUpButton.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt Ol'**
  String get upgradeSignUpButton;

  /// No description provided for @geminiApiKeyRequiredInfo.
  ///
  /// In tr, this message translates to:
  /// **'Yapay zeka için ücretsiz Google Gemini API anahtarı gereklidir.'**
  String get geminiApiKeyRequiredInfo;

  /// No description provided for @enterStandardNumberFirst.
  ///
  /// In tr, this message translates to:
  /// **'Önce standart numarasını girin.'**
  String get enterStandardNumberFirst;

  /// No description provided for @apiKeyRequiredError.
  ///
  /// In tr, this message translates to:
  /// **'API anahtarı gerekli.'**
  String get apiKeyRequiredError;

  /// No description provided for @standardNotFoundError.
  ///
  /// In tr, this message translates to:
  /// **'Standart bulunamadı.'**
  String get standardNotFoundError;

  /// No description provided for @enterTopicOrKeywordFirst.
  ///
  /// In tr, this message translates to:
  /// **'Önce konu veya anahtar kelime girin.'**
  String get enterTopicOrKeywordFirst;

  /// No description provided for @relatedStandardNotFound.
  ///
  /// In tr, this message translates to:
  /// **'İlgili standart bulunamadı.'**
  String get relatedStandardNotFound;

  /// No description provided for @addCustomStandardTitle.
  ///
  /// In tr, this message translates to:
  /// **'Özel Standart Ekle'**
  String get addCustomStandardTitle;

  /// No description provided for @byNumberTab.
  ///
  /// In tr, this message translates to:
  /// **'Numara ile'**
  String get byNumberTab;

  /// No description provided for @byTopicTab.
  ///
  /// In tr, this message translates to:
  /// **'Konuya Göre'**
  String get byTopicTab;

  /// No description provided for @findDescriptionWithAiTooltip.
  ///
  /// In tr, this message translates to:
  /// **'AI ile açıklamayı bul'**
  String get findDescriptionWithAiTooltip;

  /// No description provided for @searchStandardsWithAiTooltip.
  ///
  /// In tr, this message translates to:
  /// **'AI ile standartları ara'**
  String get searchStandardsWithAiTooltip;

  /// No description provided for @selectAllButton.
  ///
  /// In tr, this message translates to:
  /// **'Tümünü Seç'**
  String get selectAllButton;

  /// No description provided for @deselectAllButton.
  ///
  /// In tr, this message translates to:
  /// **'Tümünü Kaldır'**
  String get deselectAllButton;

  /// No description provided for @addSelectedButton.
  ///
  /// In tr, this message translates to:
  /// **'Seçilenleri Ekle ({count})'**
  String addSelectedButton(int count);

  /// No description provided for @customAddedStandardsHeader.
  ///
  /// In tr, this message translates to:
  /// **'Özel Eklenmiş Standartlar'**
  String get customAddedStandardsHeader;

  /// No description provided for @deleteStandardTitle.
  ///
  /// In tr, this message translates to:
  /// **'Standardı Sil'**
  String get deleteStandardTitle;

  /// No description provided for @deleteStandardConfirm.
  ///
  /// In tr, this message translates to:
  /// **'\"{number}\" standardını listeden kaldırmak istiyor musunuz?'**
  String deleteStandardConfirm(String number);

  /// No description provided for @aiAssistantTitle.
  ///
  /// In tr, this message translates to:
  /// **'YZ Asistan'**
  String get aiAssistantTitle;

  /// No description provided for @aiChatGreeting.
  ///
  /// In tr, this message translates to:
  /// **'{standard} standardı hakkında sorularınızı alabilir, açıklayabilirim.'**
  String aiChatGreeting(String standard);

  /// No description provided for @rehberFireLoadScenario.
  ///
  /// In tr, this message translates to:
  /// **'Yangın Yükü & Yangın Senaryosu'**
  String get rehberFireLoadScenario;

  /// No description provided for @rehberGasSuppressionSystems.
  ///
  /// In tr, this message translates to:
  /// **'Gazlı Söndürme Sistemleri'**
  String get rehberGasSuppressionSystems;

  /// No description provided for @rehberWaterBasedSuppression.
  ///
  /// In tr, this message translates to:
  /// **'Su Bazlı Söndürme Sistemleri'**
  String get rehberWaterBasedSuppression;

  /// No description provided for @rehberFoamSuppressionSystems.
  ///
  /// In tr, this message translates to:
  /// **'Köpüklü Söndürme Sistemleri'**
  String get rehberFoamSuppressionSystems;

  /// No description provided for @rehberKitchenHoodSuppression.
  ///
  /// In tr, this message translates to:
  /// **'Davlumbaz & Mutfak Söndürme'**
  String get rehberKitchenHoodSuppression;

  /// No description provided for @rehberFireExtinguishersPortable.
  ///
  /// In tr, this message translates to:
  /// **'Yangın Söndürücüler & Taşınabilir Donanım'**
  String get rehberFireExtinguishersPortable;

  /// No description provided for @rehberStructuralFireResistance.
  ///
  /// In tr, this message translates to:
  /// **'Yapısal Yangına Direnç'**
  String get rehberStructuralFireResistance;

  /// No description provided for @rehberRiskAssessmentSafety.
  ///
  /// In tr, this message translates to:
  /// **'Risk Değerlendirme & Güvenlik Yönetimi'**
  String get rehberRiskAssessmentSafety;

  /// No description provided for @rehberIndustrialSpecialRisk.
  ///
  /// In tr, this message translates to:
  /// **'Endüstriyel & Özel Risk Sistemleri'**
  String get rehberIndustrialSpecialRisk;

  /// No description provided for @stdDescEn1991FireLoad.
  ///
  /// In tr, this message translates to:
  /// **'Eurocode 1 Bölüm 1-2: Yapılara etkiyen yükler — Yangın etkileri. Yangın yükü yoğunluğu, büyüme hızı ve yangın senaryosu hesabı.'**
  String get stdDescEn1991FireLoad;

  /// No description provided for @stdDescIso1716Ncv.
  ///
  /// In tr, this message translates to:
  /// **'Yapı malzemeleri ve ürünlerinin yanma ısısının tayini — Net ısıl değer (NCV) belirleme yöntemi.'**
  String get stdDescIso1716Ncv;

  /// No description provided for @stdDescIso5660ConeCalorimeter.
  ///
  /// In tr, this message translates to:
  /// **'Yangın tepkisi deneyleri — Isı salım hızı, duman üretim hızı ve kütle kaybı hızı. Koni kalorimetre yöntemi.'**
  String get stdDescIso5660ConeCalorimeter;

  /// No description provided for @stdDescNfpa557FireLoadDensity.
  ///
  /// In tr, this message translates to:
  /// **'Yangın yükü yoğunluğu hesabı standardı — Bina kullanım tipine göre referans yoğunluk tabloları.'**
  String get stdDescNfpa557FireLoadDensity;

  /// No description provided for @stdDescIso24679FireBehaviour.
  ///
  /// In tr, this message translates to:
  /// **'Yangın güvenliği mühendisliği — Yapıda yangın davranışının değerlendirilmesi.'**
  String get stdDescIso24679FireBehaviour;

  /// No description provided for @stdDescIso16733FireScenario.
  ///
  /// In tr, this message translates to:
  /// **'Yangın güvenliği mühendisliği — Yangın senaryosu ve yangın modellemesi seçimi.'**
  String get stdDescIso16733FireScenario;

  /// No description provided for @stdDescSfpeHandbook.
  ///
  /// In tr, this message translates to:
  /// **'Yangın koruma mühendisliği başvuru kitabı — Hesap yöntemleri, yangın dinamiği, duman hareketi.'**
  String get stdDescSfpeHandbook;

  /// No description provided for @stdDescPd7974FireInitiation.
  ///
  /// In tr, this message translates to:
  /// **'BSI — Yapılarda yangın güvenliği mühendisliği uygulaması: Yangın başlangıcı ve gelişimi.'**
  String get stdDescPd7974FireInitiation;

  /// No description provided for @stdDescIso145201GeneralRules.
  ///
  /// In tr, this message translates to:
  /// **'Gazlı söndürme sistemleri — Genel kurallar: tasarım, kurulum, devreye alma, bakım ve güvenlik.'**
  String get stdDescIso145201GeneralRules;

  /// No description provided for @stdDescIso145202Co2.
  ///
  /// In tr, this message translates to:
  /// **'CO² söndürme sistemleri — Toplam taşkın ve yerel uygulama yöntemleri.'**
  String get stdDescIso145202Co2;

  /// No description provided for @stdDescIso145205Hfc227.
  ///
  /// In tr, this message translates to:
  /// **'HFC-227ea (FM-200) gazlı söndürme sistemleri — Konsantrasyon ve hacim hesabı.'**
  String get stdDescIso145205Hfc227;

  /// No description provided for @stdDescIso145208Hcfc.
  ///
  /// In tr, this message translates to:
  /// **'HCFC Blend A (Halotron I) söndürme sistemleri.'**
  String get stdDescIso145208Hcfc;

  /// No description provided for @stdDescIso145209Hfc23.
  ///
  /// In tr, this message translates to:
  /// **'HFC 23 (Triflorometan) söndürme sistemleri.'**
  String get stdDescIso145209Hfc23;

  /// No description provided for @stdDescIso1452010Ig55.
  ///
  /// In tr, this message translates to:
  /// **'IG-55 (Argonite) sistemleri — N²/Ar karışımı, inert gaz.'**
  String get stdDescIso1452010Ig55;

  /// No description provided for @stdDescIso1452011Ig541.
  ///
  /// In tr, this message translates to:
  /// **'IG-541 (Inergen) — N²/Ar/CO² karışımı, inert gazlı söndürme.'**
  String get stdDescIso1452011Ig541;

  /// No description provided for @stdDescIso1452012Ig01.
  ///
  /// In tr, this message translates to:
  /// **'IG-01 (Argon) söndürme sistemleri.'**
  String get stdDescIso1452012Ig01;

  /// No description provided for @stdDescIso1452013Ig100.
  ///
  /// In tr, this message translates to:
  /// **'IG-100 (Azot) söndürme sistemleri.'**
  String get stdDescIso1452013Ig100;

  /// No description provided for @stdDescIso1452015Novec.
  ///
  /// In tr, this message translates to:
  /// **'FK-5-1-12 (Novec 1230) — Düşük GWP değeri, hassas ekipman odaları.'**
  String get stdDescIso1452015Novec;

  /// No description provided for @stdDescNfpa2001CleanAgent.
  ///
  /// In tr, this message translates to:
  /// **'ABD — Temiz ajan (clean agent) söndürme sistemleri standardı.'**
  String get stdDescNfpa2001CleanAgent;

  /// No description provided for @stdDescNfpa12Co2Us.
  ///
  /// In tr, this message translates to:
  /// **'CO² söndürme sistemleri — ABD standardı, toplam taşkın ve yerel uygulama.'**
  String get stdDescNfpa12Co2Us;

  /// No description provided for @stdDescNfpa12aHalon.
  ///
  /// In tr, this message translates to:
  /// **'Halon 1301 söndürme sistemleri — ABD, mevcut sistemler.'**
  String get stdDescNfpa12aHalon;

  /// No description provided for @stdDescTsEn150041GeneralReq.
  ///
  /// In tr, this message translates to:
  /// **'Sabit yangın söndürme sistemleri — Gazlı söndürme sistemleri, genel gereksinimler.'**
  String get stdDescTsEn150041GeneralReq;

  /// No description provided for @stdDescVds2380Design.
  ///
  /// In tr, this message translates to:
  /// **'Almanya — Gazlı söndürme sistemleri tasarım ve kurulum yönergeleri.'**
  String get stdDescVds2380Design;

  /// No description provided for @stdDescNfpa34DippingCoating.
  ///
  /// In tr, this message translates to:
  /// **'Yanıcı/tutuşabilir sıvı kullanan daldırma, kaplama ve baskı prosesleri — temel güvenlik standardı.'**
  String get stdDescNfpa34DippingCoating;

  /// No description provided for @stdDescNfpa34Sec10PrintingOps.
  ///
  /// In tr, this message translates to:
  /// **'Printing Operations: baskı alanı yapısı, havalandırma, elektrik sınıflandırması ve yangın koruma.'**
  String get stdDescNfpa34Sec10PrintingOps;

  /// No description provided for @stdDescNfpa34Sec106AutoSuppression.
  ///
  /// In tr, this message translates to:
  /// **'Otomatik yangın söndürme zorunluluğu — Sınıf I sıvı için sprinkler; kurutucu bölmeler için yerel CO₂/temiz ajan.'**
  String get stdDescNfpa34Sec106AutoSuppression;

  /// No description provided for @stdDescNfpa12PrintingPressLocal.
  ///
  /// In tr, this message translates to:
  /// **'CO₂ söndürme — baskı makinesi ve kurutucu bölme yerel uygulama sistemleri.'**
  String get stdDescNfpa12PrintingPressLocal;

  /// No description provided for @stdDescNfpa2001PrintingCabin.
  ///
  /// In tr, this message translates to:
  /// **'Temiz ajan söndürme — baskı makinesi kabin koruma, insan varlığında tercih edilir.'**
  String get stdDescNfpa2001PrintingCabin;

  /// No description provided for @stdDescNfpa30PrintingSolvent.
  ///
  /// In tr, this message translates to:
  /// **'Yanıcı ve tutuşabilir sıvılar kodu — baskı tesisinde solvent depolama ve kullanım.'**
  String get stdDescNfpa30PrintingSolvent;

  /// No description provided for @stdDescNfpa70Article516.
  ///
  /// In tr, this message translates to:
  /// **'Baskı alanı ATEX/NEC patlayıcı atmosfer sınıflandırması ve elektrik ekipmanı.'**
  String get stdDescNfpa70Article516;

  /// No description provided for @stdDescEn10101PrintingSafetyGeneral.
  ///
  /// In tr, this message translates to:
  /// **'Baskı makinelerinin güvenliği — Genel gereksinimler.'**
  String get stdDescEn10101PrintingSafetyGeneral;

  /// No description provided for @stdDescEn10102PrintingSafetyMachines.
  ///
  /// In tr, this message translates to:
  /// **'Baskı makinelerinin güvenliği — Baskı ve baskı lakı uygulama makineleri (ofset, flexo, gravür).'**
  String get stdDescEn10102PrintingSafetyMachines;

  /// No description provided for @stdDescEn13463AtexEquipment.
  ///
  /// In tr, this message translates to:
  /// **'ATEX ekipmanlar — Potansiyel patlayıcı ortamda kullanılacak ekipmanlar için güvenlik kriterleri.'**
  String get stdDescEn13463AtexEquipment;

  /// No description provided for @stdDescTsEn150041PrintingCabinet.
  ///
  /// In tr, this message translates to:
  /// **'Gazlı söndürme sistemleri — Genel şartlar (baskı kabini için temiz ajan hesabı).'**
  String get stdDescTsEn150041PrintingCabinet;

  /// No description provided for @stdDescTsEn12845Sprinkler.
  ///
  /// In tr, this message translates to:
  /// **'Sabit sprinkler sistemleri — Tasarım, tesis ve bakım. Tehlike sınıfı, yoğunluk, debi ve depo hacmi.'**
  String get stdDescTsEn12845Sprinkler;

  /// No description provided for @stdDescNfpa13SprinklerInstallation.
  ///
  /// In tr, this message translates to:
  /// **'Sprinkler sistemi kurulumu standardı — ABD, tüm bina tipleri.'**
  String get stdDescNfpa13SprinklerInstallation;

  /// No description provided for @stdDescNfpa13rResidential.
  ///
  /// In tr, this message translates to:
  /// **'Konut binalarında sprinkler sistemleri — 4 kata kadar yapılar.'**
  String get stdDescNfpa13rResidential;

  /// No description provided for @stdDescNfpa13dOneTwoFamily.
  ///
  /// In tr, this message translates to:
  /// **'Tek ve iki ailelik konutlarda sprinkler sistemleri.'**
  String get stdDescNfpa13dOneTwoFamily;

  /// No description provided for @stdDescNfpa15WaterSpray.
  ///
  /// In tr, this message translates to:
  /// **'Sabit su spreyi söndürme sistemleri — Ekipman ve risk koruma.'**
  String get stdDescNfpa15WaterSpray;

  /// No description provided for @stdDescNfpa16FoamWaterSpray.
  ///
  /// In tr, this message translates to:
  /// **'Köpük-su sprey ve köpük-su sprinkler sistemleri.'**
  String get stdDescNfpa16FoamWaterSpray;

  /// No description provided for @stdDescEn14339UndergroundHydrant.
  ///
  /// In tr, this message translates to:
  /// **'Yeraltı yangın hidranti sistemleri — Tasarım ve kurulum.'**
  String get stdDescEn14339UndergroundHydrant;

  /// No description provided for @stdDescEn14384AboveGroundHydrant.
  ///
  /// In tr, this message translates to:
  /// **'Yerüstü yangın hidranti sistemleri.'**
  String get stdDescEn14384AboveGroundHydrant;

  /// No description provided for @stdDescEn6711SemiRigidHose.
  ///
  /// In tr, this message translates to:
  /// **'Sabit yangın söndürme donanımı — Yarı sert hortumlu makara sistemleri.'**
  String get stdDescEn6711SemiRigidHose;

  /// No description provided for @stdDescEn6712FlatHoseHydrant.
  ///
  /// In tr, this message translates to:
  /// **'Sabit yangın söndürme donanımı — Düz hortumlu hidrant sistemleri.'**
  String get stdDescEn6712FlatHoseHydrant;

  /// No description provided for @stdDescEn6713Maintenance.
  ///
  /// In tr, this message translates to:
  /// **'Sabit yangın söndürme donanımı — Bakım, Bölüm 3.'**
  String get stdDescEn6713Maintenance;

  /// No description provided for @stdDescEn122591Components.
  ///
  /// In tr, this message translates to:
  /// **'Sabit yangın söndürme sistemleri — Sprinkler ve su spreyi bileşenleri.'**
  String get stdDescEn122591Components;

  /// No description provided for @stdDescTsEn149721WaterMistDesign.
  ///
  /// In tr, this message translates to:
  /// **'Sabit söndürme sistemleri — Su sisi sistemleri, Bölüm 1: Tasarım ve kurulum.'**
  String get stdDescTsEn149721WaterMistDesign;

  /// No description provided for @stdDescNfpa750WaterMist.
  ///
  /// In tr, this message translates to:
  /// **'Su sisi (water mist) söndürme sistemleri standardı — ABD.'**
  String get stdDescNfpa750WaterMist;

  /// No description provided for @stdDescNfpa11ExpansionFoam.
  ///
  /// In tr, this message translates to:
  /// **'Düşük, orta ve yüksek genleşmeli köpük söndürme sistemleri — ABD standardı.'**
  String get stdDescNfpa11ExpansionFoam;

  /// No description provided for @stdDescEn135651FoamRequirements.
  ///
  /// In tr, this message translates to:
  /// **'Sabit köpük söndürme sistemleri — Bölüm 1: Gereksinimler ve test yöntemleri.'**
  String get stdDescEn135651FoamRequirements;

  /// No description provided for @stdDescEn135652FoamDesignInstall.
  ///
  /// In tr, this message translates to:
  /// **'Sabit köpük söndürme sistemleri — Bölüm 2: Tasarım, kurulum ve bakım.'**
  String get stdDescEn135652FoamDesignInstall;

  /// No description provided for @stdDescIso72031FoamConcentrates.
  ///
  /// In tr, this message translates to:
  /// **'Yangın söndürücü maddeler — Sıvı akaryakıt yangınları için köpük konsantreleri.'**
  String get stdDescIso72031FoamConcentrates;

  /// No description provided for @stdDescNfpa30StorageTransfer.
  ///
  /// In tr, this message translates to:
  /// **'Yanıcı ve tutuşabilir sıvılar kodu — Depolama ve taşıma.'**
  String get stdDescNfpa30StorageTransfer;

  /// No description provided for @stdDescApi2021TankFirePrevention.
  ///
  /// In tr, this message translates to:
  /// **'Petrol endüstrisi — Depo tankları yangın önleme ve söndürme.'**
  String get stdDescApi2021TankFirePrevention;

  /// No description provided for @stdDescNfpa17aWetChemical.
  ///
  /// In tr, this message translates to:
  /// **'Islak kimyasal (wet chemical) söndürme sistemleri — Ticari mutfak uygulamaları.'**
  String get stdDescNfpa17aWetChemical;

  /// No description provided for @stdDescNfpa17DryChemical.
  ///
  /// In tr, this message translates to:
  /// **'Kuru kimyasal söndürme sistemleri — Genel sanayi uygulamaları.'**
  String get stdDescNfpa17DryChemical;

  /// No description provided for @stdDescTsEn15751CommercialKitchen.
  ///
  /// In tr, this message translates to:
  /// **'Avrupa — Ticari mutfak ekipmanı için sabit yangın söndürme sistemleri.'**
  String get stdDescTsEn15751CommercialKitchen;

  /// No description provided for @stdDescUl300CookingSuppression.
  ///
  /// In tr, this message translates to:
  /// **'ABD ürün onay standardı — Yemek pişirme alanları söndürme sistemleri (Ansul, Amerex vb.).'**
  String get stdDescUl300CookingSuppression;

  /// No description provided for @stdDescUl300aAutoSuppressionCooking.
  ///
  /// In tr, this message translates to:
  /// **'Otomatik söndürme sistemleri — Pişirme aleti üstü yangın tehlikesi.'**
  String get stdDescUl300aAutoSuppressionCooking;

  /// No description provided for @stdDescTsEn18251GreaseSeparators.
  ///
  /// In tr, this message translates to:
  /// **'Mutfak davlumbazı gres tutucular ve filtreler.'**
  String get stdDescTsEn18251GreaseSeparators;

  /// No description provided for @stdDescTsEn18252GreaseSelection.
  ///
  /// In tr, this message translates to:
  /// **'Mutfak davlumbazı gres tutucular — Seçim, kurulum ve bakım.'**
  String get stdDescTsEn18252GreaseSelection;

  /// No description provided for @stdDescNfpa96VentilationCooking.
  ///
  /// In tr, this message translates to:
  /// **'Ticari mutfak havalandırma sistemi standardı — Kanal, davlumbaz ve yangın önleme.'**
  String get stdDescNfpa96VentilationCooking;

  /// No description provided for @stdDescEn541Introduction.
  ///
  /// In tr, this message translates to:
  /// **'Yangın algılama ve alarm sistemleri — Bölüm 1: Sisteme genel bakış.'**
  String get stdDescEn541Introduction;

  /// No description provided for @stdDescEn542ControlIndicating.
  ///
  /// In tr, this message translates to:
  /// **'Yangın alarm kontrol ve gösterge paneli.'**
  String get stdDescEn542ControlIndicating;

  /// No description provided for @stdDescEn543SoundersDevices.
  ///
  /// In tr, this message translates to:
  /// **'Yangın alarm sesli uyarı cihazları.'**
  String get stdDescEn543SoundersDevices;

  /// No description provided for @stdDescEn544PowerSupply.
  ///
  /// In tr, this message translates to:
  /// **'Güç besleme donanımı.'**
  String get stdDescEn544PowerSupply;

  /// No description provided for @stdDescEn545HeatDetectors.
  ///
  /// In tr, this message translates to:
  /// **'Isı detektörleri — Noktasal.'**
  String get stdDescEn545HeatDetectors;

  /// No description provided for @stdDescEn547SmokeDetectorsOptical.
  ///
  /// In tr, this message translates to:
  /// **'Duman detektörleri — Dağılım tipi optik detektörler.'**
  String get stdDescEn547SmokeDetectorsOptical;

  /// No description provided for @stdDescEn5410FlameDetectors.
  ///
  /// In tr, this message translates to:
  /// **'Alev detektörleri — Noktasal.'**
  String get stdDescEn5410FlameDetectors;

  /// No description provided for @stdDescEn5411ManualCallPoint.
  ///
  /// In tr, this message translates to:
  /// **'Manuel yangın alarm butonu (kırılır camlı).'**
  String get stdDescEn5411ManualCallPoint;

  /// No description provided for @stdDescEn5412SmokeDetectorsLinear.
  ///
  /// In tr, this message translates to:
  /// **'Duman detektörleri — Doğrusal ışın tipi.'**
  String get stdDescEn5412SmokeDetectorsLinear;

  /// No description provided for @stdDescEn5413SystemCompatibility.
  ///
  /// In tr, this message translates to:
  /// **'Sistem bileşenlerinin uyumluluğu ve bağlanabilirliği değerlendirmesi.'**
  String get stdDescEn5413SystemCompatibility;

  /// No description provided for @stdDescEn5414PlanningGuide.
  ///
  /// In tr, this message translates to:
  /// **'Yangın algılama ve alarm sistemleri — Planlama, tasarım, kurulum, devreye alma, kullanım ve bakım kılavuzu.'**
  String get stdDescEn5414PlanningGuide;

  /// No description provided for @stdDescEn5416VoiceAlarm.
  ///
  /// In tr, this message translates to:
  /// **'Sesli alarm kontrol ve gösterge donanımı.'**
  String get stdDescEn5416VoiceAlarm;

  /// No description provided for @stdDescEn5417ShortCircuitIsolators.
  ///
  /// In tr, this message translates to:
  /// **'Kısa devre izolatörleri.'**
  String get stdDescEn5417ShortCircuitIsolators;

  /// No description provided for @stdDescEn5418InputOutputDevices.
  ///
  /// In tr, this message translates to:
  /// **'Giriş/çıkış cihazları.'**
  String get stdDescEn5418InputOutputDevices;

  /// No description provided for @stdDescEn5420AspiratingSmoke.
  ///
  /// In tr, this message translates to:
  /// **'Duman detektörleri — Aspirasyonlu tip.'**
  String get stdDescEn5420AspiratingSmoke;

  /// No description provided for @stdDescEn5421AlarmTransmission.
  ///
  /// In tr, this message translates to:
  /// **'Alarm iletim ve arıza uyarı yönlendirme donanımı.'**
  String get stdDescEn5421AlarmTransmission;

  /// No description provided for @stdDescEn5423VisualAlarm.
  ///
  /// In tr, this message translates to:
  /// **'Yangın alarm görsel uyarı cihazları.'**
  String get stdDescEn5423VisualAlarm;

  /// No description provided for @stdDescEn5425RadioComponents.
  ///
  /// In tr, this message translates to:
  /// **'Radyo bağlantılı (kablosuz) sistem bileşenleri.'**
  String get stdDescEn5425RadioComponents;

  /// No description provided for @stdDescNfpa72NationalCode.
  ///
  /// In tr, this message translates to:
  /// **'ABD — Ulusal yangın alarm ve sinyalizasyon kodu. Adresleme, bildirim, altyapı.'**
  String get stdDescNfpa72NationalCode;

  /// No description provided for @stdDescVds2095PlanningInstall.
  ///
  /// In tr, this message translates to:
  /// **'Almanya — Yangın alarm sistemleri planlama ve kurulum yönergeleri.'**
  String get stdDescVds2095PlanningInstall;

  /// No description provided for @stdDescEn121011SmokeCurtains.
  ///
  /// In tr, this message translates to:
  /// **'Duman ve ısı tahliye sistemleri — Bölüm 1: Duman ve ısı kontrol perdelerinin özellikleri.'**
  String get stdDescEn121011SmokeCurtains;

  /// No description provided for @stdDescEn121012NaturalVentilators.
  ///
  /// In tr, this message translates to:
  /// **'Doğal duman ve ısı tahliye ventilatörleri — Performans gereksinimleri.'**
  String get stdDescEn121012NaturalVentilators;

  /// No description provided for @stdDescEn121013PoweredExhaust.
  ///
  /// In tr, this message translates to:
  /// **'Mekanik duman tahliye sistemleri — Motorlu duman egzoz fanları.'**
  String get stdDescEn121013PoweredExhaust;

  /// No description provided for @stdDescEn121014InstallCommission.
  ///
  /// In tr, this message translates to:
  /// **'Kurulum, kabul testi, rutin bakım ve onarım kılavuzu.'**
  String get stdDescEn121014InstallCommission;

  /// No description provided for @stdDescEn121016PressureDifferential.
  ///
  /// In tr, this message translates to:
  /// **'Basınçlı duman kontrol sistemleri — Kit özellikleri.'**
  String get stdDescEn121016PressureDifferential;

  /// No description provided for @stdDescEn121017DuctlessNaturalVent.
  ///
  /// In tr, this message translates to:
  /// **'Duman ve ısı tahliye ventilatörleri — Kanalsız doğal duman tahliyesi.'**
  String get stdDescEn121017DuctlessNaturalVent;

  /// No description provided for @stdDescEn121018TunnelControlPanels.
  ///
  /// In tr, this message translates to:
  /// **'Tünel için doğal duman tahliye sistemi kontrol panelleri.'**
  String get stdDescEn121018TunnelControlPanels;

  /// No description provided for @stdDescEn121019FireDamperControl.
  ///
  /// In tr, this message translates to:
  /// **'Yangın kontrol damperlerinin kontrolü.'**
  String get stdDescEn121019FireDamperControl;

  /// No description provided for @stdDescEn1210110PowerSupplyKits.
  ///
  /// In tr, this message translates to:
  /// **'Güç besleme kitleri.'**
  String get stdDescEn1210110PowerSupplyKits;

  /// No description provided for @stdDescNfpa92SmokeControlUs.
  ///
  /// In tr, this message translates to:
  /// **'ABD — Duman kontrol sistemleri standardı. Basınçlı merdivenler, atrium duman yönetimi.'**
  String get stdDescNfpa92SmokeControlUs;

  /// No description provided for @stdDescNfpa101LifeSafety.
  ///
  /// In tr, this message translates to:
  /// **'ABD — Can güvenliği kodu, tahliye yolları, çıkış gereksinimleri.'**
  String get stdDescNfpa101LifeSafety;

  /// No description provided for @stdDescEn16341DoorFireResistance.
  ///
  /// In tr, this message translates to:
  /// **'Yangın ve duman kontrol kapı ve pencere takımları — Yangına direnç deneyi.'**
  String get stdDescEn16341DoorFireResistance;

  /// No description provided for @stdDescEn16343SmokeControl.
  ///
  /// In tr, this message translates to:
  /// **'Yangın kapıları — Yangın ve duman geçirgenliği deneyi.'**
  String get stdDescEn16343SmokeControl;

  /// No description provided for @stdDescEn15650FireDampers.
  ///
  /// In tr, this message translates to:
  /// **'Havalandırma sistemleri için yangın damperleri.'**
  String get stdDescEn15650FireDampers;

  /// No description provided for @stdDescEn158821ExtendedApplication.
  ///
  /// In tr, this message translates to:
  /// **'Yangın kontrol damperlerinin genişletilmiş uygulama.'**
  String get stdDescEn158821ExtendedApplication;

  /// No description provided for @stdDescEn37PortableExtPerformance.
  ///
  /// In tr, this message translates to:
  /// **'Taşınabilir yangın söndürücüler — Performans, test yöntemleri ve yapı.'**
  String get stdDescEn37PortableExtPerformance;

  /// No description provided for @stdDescEn38PortableExtAdditional.
  ///
  /// In tr, this message translates to:
  /// **'Taşınabilir yangın söndürücüler — Ek gereksinimler ve testler.'**
  String get stdDescEn38PortableExtAdditional;

  /// No description provided for @stdDescEn39PortableExtCo2.
  ///
  /// In tr, this message translates to:
  /// **'Taşınabilir yangın söndürücüler — CO² söndürücüler.'**
  String get stdDescEn39PortableExtCo2;

  /// No description provided for @stdDescEn310PortableExtSpecial.
  ///
  /// In tr, this message translates to:
  /// **'Taşınabilir yangın söndürücüler — Özel gereksinimler.'**
  String get stdDescEn310PortableExtSpecial;

  /// No description provided for @stdDescNfpa10PortableUs.
  ///
  /// In tr, this message translates to:
  /// **'ABD — Taşınabilir yangın söndürücüler standardı.'**
  String get stdDescNfpa10PortableUs;

  /// No description provided for @stdDescEn18661MobileCo2.
  ///
  /// In tr, this message translates to:
  /// **'Taşınabilir CO² söndürücüler.'**
  String get stdDescEn18661MobileCo2;

  /// No description provided for @stdDescTsEn615DryChemicalPowder.
  ///
  /// In tr, this message translates to:
  /// **'Yangın söndürücü maddeler — Kuru kimyasal toz özellikleri.'**
  String get stdDescTsEn615DryChemicalPowder;

  /// No description provided for @stdDescTsEn15683FoamConcentrates.
  ///
  /// In tr, this message translates to:
  /// **'Yangın söndürücü maddeler — Köpük konsantreleri.'**
  String get stdDescTsEn15683FoamConcentrates;

  /// No description provided for @stdDescEn1992Eurocode2.
  ///
  /// In tr, this message translates to:
  /// **'Betonarme yapılar — Yangın etkisi altında yapısal tasarım (Eurocode 2).'**
  String get stdDescEn1992Eurocode2;

  /// No description provided for @stdDescEn1993Eurocode3.
  ///
  /// In tr, this message translates to:
  /// **'Çelik yapılar — Yangın etkisi altında yapısal tasarım (Eurocode 3).'**
  String get stdDescEn1993Eurocode3;

  /// No description provided for @stdDescEn1994Eurocode4.
  ///
  /// In tr, this message translates to:
  /// **'Kompozit çelik-beton yapılar — Yangın etkisi altında tasarım (Eurocode 4).'**
  String get stdDescEn1994Eurocode4;

  /// No description provided for @stdDescEn1995Eurocode5.
  ///
  /// In tr, this message translates to:
  /// **'Ahşap yapılar — Yangın etkisi altında yapısal tasarım (Eurocode 5).'**
  String get stdDescEn1995Eurocode5;

  /// No description provided for @stdDescEn1996Eurocode6.
  ///
  /// In tr, this message translates to:
  /// **'Yığma yapılar — Yangın etkisi altında yapısal tasarım (Eurocode 6).'**
  String get stdDescEn1996Eurocode6;

  /// No description provided for @stdDescIso8341StandardFireCurve.
  ///
  /// In tr, this message translates to:
  /// **'Standart yangın eğrisi — Yapı elemanlarının yangına direnç deneyi.'**
  String get stdDescIso8341StandardFireCurve;

  /// No description provided for @stdDescIso8342AlternativeCurves.
  ///
  /// In tr, this message translates to:
  /// **'Alternatif ve parametrik yangın eğrileri.'**
  String get stdDescIso8342AlternativeCurves;

  /// No description provided for @stdDescEn135011ReactionToFire.
  ///
  /// In tr, this message translates to:
  /// **'Yapı malzemeleri ve ürünlerinin yangın performansı sınıflandırması.'**
  String get stdDescEn135011ReactionToFire;

  /// No description provided for @stdDescEn135012FireResistanceClass.
  ///
  /// In tr, this message translates to:
  /// **'Yapı elemanlarının yangına direnç sınıflandırması.'**
  String get stdDescEn135012FireResistanceClass;

  /// No description provided for @stdDescEn135013VentilationServices.
  ///
  /// In tr, this message translates to:
  /// **'Yangın durumundaki havalandırma servis ürünleri sınıflandırması.'**
  String get stdDescEn135013VentilationServices;

  /// No description provided for @stdDescEn135014SmokeControlDoors.
  ///
  /// In tr, this message translates to:
  /// **'Duman kontrol kapılar ve yapı elemanları sınıflandırması.'**
  String get stdDescEn135014SmokeControlDoors;

  /// No description provided for @stdDescEn135015Roofs.
  ///
  /// In tr, this message translates to:
  /// **'Çatılar — Dışarıdan gelen yangına maruz kalma sınıflandırması.'**
  String get stdDescEn135015Roofs;

  /// No description provided for @stdDescNfpa220ConstructionTypes.
  ///
  /// In tr, this message translates to:
  /// **'ABD — Yapı inşaat tipleri standardı.'**
  String get stdDescNfpa220ConstructionTypes;

  /// No description provided for @stdDescUl263FireResistanceTests.
  ///
  /// In tr, this message translates to:
  /// **'ABD — Yapı elemanlarının yangına direnç deneyleri.'**
  String get stdDescUl263FireResistanceTests;

  /// No description provided for @stdDescAstmE119FireEndurance.
  ///
  /// In tr, this message translates to:
  /// **'ABD — Yapı malzemeleri ve sistemlerinin yangın dayanımı deneyleri.'**
  String get stdDescAstmE119FireEndurance;

  /// No description provided for @stdDescIso31000RiskManagement.
  ///
  /// In tr, this message translates to:
  /// **'Risk yönetimi — Kılavuz ilkeler ve genel çerçeve.'**
  String get stdDescIso31000RiskManagement;

  /// No description provided for @stdDescIso45001Ohs.
  ///
  /// In tr, this message translates to:
  /// **'İSG yönetim sistemleri — Gereksinimler ve kullanım kılavuzu.'**
  String get stdDescIso45001Ohs;

  /// No description provided for @stdDescIso16069SafetyWayGuidance.
  ///
  /// In tr, this message translates to:
  /// **'Güvenlik işaret sistemleri — Acil kaçış aydınlatması ve yönlendirmesi.'**
  String get stdDescIso16069SafetyWayGuidance;

  /// No description provided for @stdDescEn50172EmergencyLighting.
  ///
  /// In tr, this message translates to:
  /// **'Acil kaçış aydınlatma sistemleri — Kurulum ve işletme.'**
  String get stdDescEn50172EmergencyLighting;

  /// No description provided for @stdDescNfpa1FireCode.
  ///
  /// In tr, this message translates to:
  /// **'ABD — Yangın kodu. Bina kullanımı, çıkış, tahliye ve risk.'**
  String get stdDescNfpa1FireCode;

  /// No description provided for @stdDescNfpa25InspectionTesting.
  ///
  /// In tr, this message translates to:
  /// **'Su bazlı söndürme sistemleri — Denetim, test ve bakım.'**
  String get stdDescNfpa25InspectionTesting;

  /// No description provided for @stdDescEnIso7010SafetySigns.
  ///
  /// In tr, this message translates to:
  /// **'Güvenlik işaretleri — Acil çıkış, yangın teçhizatı ve tehlike işaretleri.'**
  String get stdDescEnIso7010SafetySigns;

  /// No description provided for @stdDescTs9811FireSafetySigns.
  ///
  /// In tr, this message translates to:
  /// **'Türkiye — Yangın İçin Güvenlik İşaretleri.'**
  String get stdDescTs9811FireSafetySigns;

  /// No description provided for @stdDescTbdy2018SeismicSteelFire.
  ///
  /// In tr, this message translates to:
  /// **'Türkiye Bina Deprem Yönetmeliği — Bölüm 3: Yapısal çelik, yangın etkisi.'**
  String get stdDescTbdy2018SeismicSteelFire;

  /// No description provided for @stdDescTrFireRegulation2015.
  ///
  /// In tr, this message translates to:
  /// **'Türkiye — Yapılarda yangından korunma, tahliye, söndürme ve alarm sistemleri gereksinimleri.'**
  String get stdDescTrFireRegulation2015;

  /// No description provided for @stdDescNfpa850PowerGeneration.
  ///
  /// In tr, this message translates to:
  /// **'Elektrik santrallerinde yangın koruması — Türbin sahaları, trafo ve kablo güzergâhları.'**
  String get stdDescNfpa850PowerGeneration;

  /// No description provided for @stdDescNfpa804NuclearPlants.
  ///
  /// In tr, this message translates to:
  /// **'Nükleer santraller için yangın koruma standardı.'**
  String get stdDescNfpa804NuclearPlants;

  /// No description provided for @stdDescNfpa409AircraftHangars.
  ///
  /// In tr, this message translates to:
  /// **'Uçak hangarları yangın koruma standardı.'**
  String get stdDescNfpa409AircraftHangars;

  /// No description provided for @stdDescNfpa415AircraftFueling.
  ///
  /// In tr, this message translates to:
  /// **'Uçak yakıt ikmal sistemleri ve çalışma alanları.'**
  String get stdDescNfpa415AircraftFueling;

  /// No description provided for @stdDescEn11271ExplosivePrevention.
  ///
  /// In tr, this message translates to:
  /// **'Patlayıcı ortamlar — Patlamadan korunma, temel kavramlar.'**
  String get stdDescEn11271ExplosivePrevention;

  /// No description provided for @stdDescEn6007910ZoneClassification.
  ///
  /// In tr, this message translates to:
  /// **'Patlayıcı ortamlar — Tehlikeli bölgelerin sınıflandırılması (gaz).'**
  String get stdDescEn6007910ZoneClassification;

  /// No description provided for @stdDescIec61511FunctionalSafety.
  ///
  /// In tr, this message translates to:
  /// **'İşlevsel güvenlik — Proses endüstrisi güvenlik enstrüman sistemleri.'**
  String get stdDescIec61511FunctionalSafety;

  /// No description provided for @stdDescApi610PetrochemPumps.
  ///
  /// In tr, this message translates to:
  /// **'Petrokimya tesislerinde pompalar — Yangın güvenliği gereksinimleri.'**
  String get stdDescApi610PetrochemPumps;

  /// No description provided for @stdDescNfpa654CombustibleDust.
  ///
  /// In tr, this message translates to:
  /// **'Yanıcı toz yangını ve patlamasına karşı koruma.'**
  String get stdDescNfpa654CombustibleDust;

  /// No description provided for @stdDescNfpa68ExplosionVenting.
  ///
  /// In tr, this message translates to:
  /// **'Patlama basıncı tahliyesi standardı.'**
  String get stdDescNfpa68ExplosionVenting;

  /// No description provided for @stdDescNfpa69ExplosionPrevention.
  ///
  /// In tr, this message translates to:
  /// **'Patlama önleme sistemleri standardı.'**
  String get stdDescNfpa69ExplosionPrevention;

  /// No description provided for @spActOfficesAdmin.
  ///
  /// In tr, this message translates to:
  /// **'Ofisler ve yönetim binaları'**
  String get spActOfficesAdmin;

  /// No description provided for @spActHotelsHostelsGuesthouses.
  ///
  /// In tr, this message translates to:
  /// **'Oteller, misafirhaneler, pansiyonlar'**
  String get spActHotelsHostelsGuesthouses;

  /// No description provided for @spActHospitalsClinics.
  ///
  /// In tr, this message translates to:
  /// **'Hastaneler, klinikler, sağlık merkezleri'**
  String get spActHospitalsClinics;

  /// No description provided for @spActSchoolsUniversities.
  ///
  /// In tr, this message translates to:
  /// **'Okullar, üniversiteler ve eğitim binaları'**
  String get spActSchoolsUniversities;

  /// No description provided for @spActResidentialApartments.
  ///
  /// In tr, this message translates to:
  /// **'Konutlar ve apartmanlar'**
  String get spActResidentialApartments;

  /// No description provided for @spActPrisonsReformatories.
  ///
  /// In tr, this message translates to:
  /// **'Cezaevleri ve ıslahevleri'**
  String get spActPrisonsReformatories;

  /// No description provided for @spActChurchesMosquesWorship.
  ///
  /// In tr, this message translates to:
  /// **'Kiliseler, camiler ve ibadethaneler'**
  String get spActChurchesMosquesWorship;

  /// No description provided for @spActTheatresCinemaSeating.
  ///
  /// In tr, this message translates to:
  /// **'Tiyatrolar / sinema (yalnızca seyirci oturma alanları)'**
  String get spActTheatresCinemaSeating;

  /// No description provided for @spActMuseumsGalleries.
  ///
  /// In tr, this message translates to:
  /// **'Müzeler ve sanat galerileri'**
  String get spActMuseumsGalleries;

  /// No description provided for @spActBreweriesExclDistilleries.
  ///
  /// In tr, this message translates to:
  /// **'Bira fabrikaları (damıtma tesisleri hariç)'**
  String get spActBreweriesExclDistilleries;

  /// No description provided for @spActMultiStoreyBasementCarParks.
  ///
  /// In tr, this message translates to:
  /// **'Çok katlı ve bodrum katlı kapalı otoparklar'**
  String get spActMultiStoreyBasementCarParks;

  /// No description provided for @spActCeramicsProduction.
  ///
  /// In tr, this message translates to:
  /// **'Seramik ürünleri üretimi'**
  String get spActCeramicsProduction;

  /// No description provided for @spActGlassGlasswareExclFibre.
  ///
  /// In tr, this message translates to:
  /// **'Cam ve cam eşya üretimi (cam elyafı hariç)'**
  String get spActGlassGlasswareExclFibre;

  /// No description provided for @spActChemResearchLabs.
  ///
  /// In tr, this message translates to:
  /// **'Kimya araştırma laboratuvarları'**
  String get spActChemResearchLabs;

  /// No description provided for @spActDairyProcessing.
  ///
  /// In tr, this message translates to:
  /// **'Süt ve süt ürünleri işleme tesisleri (mandıralar)'**
  String get spActDairyProcessing;

  /// No description provided for @spActElectronicsAssembly.
  ///
  /// In tr, this message translates to:
  /// **'Elektronik ekipman montaj atölyeleri'**
  String get spActElectronicsAssembly;

  /// No description provided for @spActFoodProcessingPackaging.
  ///
  /// In tr, this message translates to:
  /// **'Gıda işleme ve paketleme tesisleri'**
  String get spActFoodProcessingPackaging;

  /// No description provided for @spActHotelsKitchenLaundryService.
  ///
  /// In tr, this message translates to:
  /// **'Oteller — mutfak, çamaşırhane ve servis alanları'**
  String get spActHotelsKitchenLaundryService;

  /// No description provided for @spActInstitutionalCommercialLaundries.
  ///
  /// In tr, this message translates to:
  /// **'Kurumsal ve ticari çamaşırhaneler'**
  String get spActInstitutionalCommercialLaundries;

  /// No description provided for @spActLeatherProductsProduction.
  ///
  /// In tr, this message translates to:
  /// **'Deri ve deri ürünleri üretimi'**
  String get spActLeatherProductsProduction;

  /// No description provided for @spActLightMetalworkingWorkshops.
  ///
  /// In tr, this message translates to:
  /// **'Hafif metal işleme atölyeleri'**
  String get spActLightMetalworkingWorkshops;

  /// No description provided for @spActPharmaceuticalProduction.
  ///
  /// In tr, this message translates to:
  /// **'Farmasötik (ilaç) üretim tesisleri'**
  String get spActPharmaceuticalProduction;

  /// No description provided for @spActResearchLabsNonflamLiquids.
  ///
  /// In tr, this message translates to:
  /// **'Araştırma laboratuvarları (yanmaz sıvı kullanımı)'**
  String get spActResearchLabsNonflamLiquids;

  /// No description provided for @spActTextileWeavingNaturalFibresUntreated.
  ///
  /// In tr, this message translates to:
  /// **'Tekstil dokuma — pamuk/yün/doğal elyaf (terbiye işlemsiz)'**
  String get spActTextileWeavingNaturalFibresUntreated;

  /// No description provided for @spActTobaccoProcessingPackaging.
  ///
  /// In tr, this message translates to:
  /// **'Tütün işleme ve paketleme'**
  String get spActTobaccoProcessingPackaging;

  /// No description provided for @spActAgriIndustrialMachineryAssembly.
  ///
  /// In tr, this message translates to:
  /// **'Tarım ve iş makinesi montaj tesisleri'**
  String get spActAgriIndustrialMachineryAssembly;

  /// No description provided for @spActGrainFlourMillFoodProcessing.
  ///
  /// In tr, this message translates to:
  /// **'Tahıl, un değirmeni ve benzeri gıda işleme'**
  String get spActGrainFlourMillFoodProcessing;

  /// No description provided for @spActChemProductionNonflamLiquidsOnly.
  ///
  /// In tr, this message translates to:
  /// **'Kimyasal üretim (yalnızca yanmaz sıvılı ürünler)'**
  String get spActChemProductionNonflamLiquidsOnly;

  /// No description provided for @spActDeptStoresShoppingCentresSingleStorey.
  ///
  /// In tr, this message translates to:
  /// **'Büyük mağazalar ve alışveriş merkezleri (tek katlı)'**
  String get spActDeptStoresShoppingCentresSingleStorey;

  /// No description provided for @spActElectricalEquipmentFactories.
  ///
  /// In tr, this message translates to:
  /// **'Elektrikli ekipman üretim fabrikaları'**
  String get spActElectricalEquipmentFactories;

  /// No description provided for @spActComputerDataProcessingRooms.
  ///
  /// In tr, this message translates to:
  /// **'Bilgisayar ve elektronik veri işleme odaları'**
  String get spActComputerDataProcessingRooms;

  /// No description provided for @spActGeneralEngineeringWorkshopsFactories.
  ///
  /// In tr, this message translates to:
  /// **'Genel mühendislik atölyeleri ve fabrikalar'**
  String get spActGeneralEngineeringWorkshopsFactories;

  /// No description provided for @spActFruitVegCanningFacilities.
  ///
  /// In tr, this message translates to:
  /// **'Meyve, sebze ve konserve işleme tesisleri'**
  String get spActFruitVegCanningFacilities;

  /// No description provided for @spActVehicleMaintenanceRepairGarages.
  ///
  /// In tr, this message translates to:
  /// **'Araç bakım-onarım garajları'**
  String get spActVehicleMaintenanceRepairGarages;

  /// No description provided for @spActFibreglassProductionAssembly.
  ///
  /// In tr, this message translates to:
  /// **'Cam elyafı (fiberglas) üretimi ve montajı'**
  String get spActFibreglassProductionAssembly;

  /// No description provided for @spActHardwareIronmongeryStores.
  ///
  /// In tr, this message translates to:
  /// **'Hırdavat ve demir-çelik ürünleri mağazaları'**
  String get spActHardwareIronmongeryStores;

  /// No description provided for @spActHospitalsTreatmentSurgeryAreas.
  ///
  /// In tr, this message translates to:
  /// **'Hastaneler — tedavi ve ameliyat alanları'**
  String get spActHospitalsTreatmentSurgeryAreas;

  /// No description provided for @spActKnittingHosieryFactories.
  ///
  /// In tr, this message translates to:
  /// **'Örme (triko/hosiery) fabrikaları'**
  String get spActKnittingHosieryFactories;

  /// No description provided for @spActLibrariesOpenShelfAreas.
  ///
  /// In tr, this message translates to:
  /// **'Kütüphaneler — genel açık raf alanları'**
  String get spActLibrariesOpenShelfAreas;

  /// No description provided for @spActGeneralMetalworkingFactories.
  ///
  /// In tr, this message translates to:
  /// **'Genel metal işleme fabrikaları'**
  String get spActGeneralMetalworkingFactories;

  /// No description provided for @spActPaperBoardProductionFacilities.
  ///
  /// In tr, this message translates to:
  /// **'Kâğıt ve karton üretim tesisleri'**
  String get spActPaperBoardProductionFacilities;

  /// No description provided for @spActPlasticsManufNonflamOnly.
  ///
  /// In tr, this message translates to:
  /// **'Plastik ürün imalatı (yalnızca yanmaz plastikler)'**
  String get spActPlasticsManufNonflamOnly;

  /// No description provided for @spActGeneralPrintingWaterBasedInk.
  ///
  /// In tr, this message translates to:
  /// **'Genel baskı / matbaa (su bazlı mürekkep)'**
  String get spActGeneralPrintingWaterBasedInk;

  /// No description provided for @spActSupermarketsHypermarkets.
  ///
  /// In tr, this message translates to:
  /// **'Süpermarketler ve hipermarketler'**
  String get spActSupermarketsHypermarkets;

  /// No description provided for @spActTailoringGarmentManufacture.
  ///
  /// In tr, this message translates to:
  /// **'Terzilik, konfeksiyon ve giyim üretimi'**
  String get spActTailoringGarmentManufacture;

  /// No description provided for @spActTextileSpinningWeavingSynthetic.
  ///
  /// In tr, this message translates to:
  /// **'Tekstil eğirme ve dokuma (sentetik elyaf)'**
  String get spActTextileSpinningWeavingSynthetic;

  /// No description provided for @spActLoadingShippingDocks.
  ///
  /// In tr, this message translates to:
  /// **'Yükleme-boşaltma, sevkiyat/nakliye rampaları'**
  String get spActLoadingShippingDocks;

  /// No description provided for @spActGeneralStorageUpTo4m.
  ///
  /// In tr, this message translates to:
  /// **'Genel depolama (istiflenmiş yükseklik ≤ 4 m)'**
  String get spActGeneralStorageUpTo4m;

  /// No description provided for @spActAircraftHangarsMaintenance.
  ///
  /// In tr, this message translates to:
  /// **'Uçak hangarları — bakım ve onarım alanları'**
  String get spActAircraftHangarsMaintenance;

  /// No description provided for @spActOilclothTarpaulinCanvasProduction.
  ///
  /// In tr, this message translates to:
  /// **'Muşamba, branda, çadır bezi ve branda üretimi'**
  String get spActOilclothTarpaulinCanvasProduction;

  /// No description provided for @spActChemProductionFpAbove55.
  ///
  /// In tr, this message translates to:
  /// **'Kimyasal üretim (parlama noktası > 55 °C ürünler)'**
  String get spActChemProductionFpAbove55;

  /// No description provided for @spActColdStores.
  ///
  /// In tr, this message translates to:
  /// **'Soğuk hava depoları'**
  String get spActColdStores;

  /// No description provided for @spActFilmTvStudiosProduction.
  ///
  /// In tr, this message translates to:
  /// **'Film ve televizyon stüdyoları (üretim alanı)'**
  String get spActFilmTvStudiosProduction;

  /// No description provided for @spActFurnitureUpholsteryProduction.
  ///
  /// In tr, this message translates to:
  /// **'Mobilya ve döşeme üretimi (sünger, kumaş)'**
  String get spActFurnitureUpholsteryProduction;

  /// No description provided for @spActJoineryWoodworkingWorkshops.
  ///
  /// In tr, this message translates to:
  /// **'Marangoz / doğrama — ahşap işleme atölyeleri'**
  String get spActJoineryWoodworkingWorkshops;

  /// No description provided for @spActMatchProductionFacilities.
  ///
  /// In tr, this message translates to:
  /// **'Kibrit üretim tesisleri'**
  String get spActMatchProductionFacilities;

  /// No description provided for @spActOfficesLargePaperArchives.
  ///
  /// In tr, this message translates to:
  /// **'Büyük kâğıt arşiv alanları olan ofisler'**
  String get spActOfficesLargePaperArchives;

  /// No description provided for @spActWaterBasedPaintVarnishProduction.
  ///
  /// In tr, this message translates to:
  /// **'Su bazlı boya ve vernik üretimi'**
  String get spActWaterBasedPaintVarnishProduction;

  /// No description provided for @spActPaperCorrugatedBoxProduction.
  ///
  /// In tr, this message translates to:
  /// **'Kâğıt, karton ve oluklu mukavva kutu işleme/üretimi'**
  String get spActPaperCorrugatedBoxProduction;

  /// No description provided for @spActThermoplasticsManufShaping.
  ///
  /// In tr, this message translates to:
  /// **'Termoplastik plastik imalat ve şekillendirme'**
  String get spActThermoplasticsManufShaping;

  /// No description provided for @spActHighSpeedOffsetPrintingOilInk.
  ///
  /// In tr, this message translates to:
  /// **'Yüksek hızlı ofset baskı (petrol bazlı mürekkep)'**
  String get spActHighSpeedOffsetPrintingOilInk;

  /// No description provided for @spActRubberProductsProduction.
  ///
  /// In tr, this message translates to:
  /// **'Kauçuk ürünleri üretim tesisleri'**
  String get spActRubberProductsProduction;

  /// No description provided for @spActTextileDyeingFinishingFacilities.
  ///
  /// In tr, this message translates to:
  /// **'Tekstil boyama ve terbiye işleme tesisleri'**
  String get spActTextileDyeingFinishingFacilities;

  /// No description provided for @spActGeneralStorage4to8m.
  ///
  /// In tr, this message translates to:
  /// **'Genel depolama (istiflenmiş yükseklik > 4 m – 8 m)'**
  String get spActGeneralStorage4to8m;

  /// No description provided for @spActChemProductionClosedProcessFp55.
  ///
  /// In tr, this message translates to:
  /// **'Kimyasal üretim (kapalı proses, parlama noktası > 55 °C)'**
  String get spActChemProductionClosedProcessFp55;

  /// No description provided for @spActPlasticRubberPartsClosedMoulding.
  ///
  /// In tr, this message translates to:
  /// **'Plastik ve kauçuk parça üretimi (kapalı ekstrüzyon/kalıplama)'**
  String get spActPlasticRubberPartsClosedMoulding;

  /// No description provided for @spActTextileDyeingFinishingWaterBased.
  ///
  /// In tr, this message translates to:
  /// **'Tekstil boyama ve terbiye tesisleri (su bazlı)'**
  String get spActTextileDyeingFinishingWaterBased;

  /// No description provided for @spActPharmacyCosmeticsDetergentProduction.
  ///
  /// In tr, this message translates to:
  /// **'Eczane, kozmetik ve deterjan üretim tesisleri'**
  String get spActPharmacyCosmeticsDetergentProduction;

  /// No description provided for @spActFoodBeverageProductionHighVolume.
  ///
  /// In tr, this message translates to:
  /// **'Gıda ve içecek üretim tesisleri (yüksek hacimli)'**
  String get spActFoodBeverageProductionHighVolume;

  /// No description provided for @spActPaperProductionDryCuttingSorting.
  ///
  /// In tr, this message translates to:
  /// **'Kağıt üretim ve işleme tesisleri (kuru kesi/tasnif)'**
  String get spActPaperProductionDryCuttingSorting;

  /// No description provided for @spActPaintShopsWaterUvCuring.
  ///
  /// In tr, this message translates to:
  /// **'Su bazlı boya, vernik veya UV-kürleme boyasi kullanan boyahaneler'**
  String get spActPaintShopsWaterUvCuring;

  /// No description provided for @spActMetalworkingMachineryHeavySwarfOilMist.
  ///
  /// In tr, this message translates to:
  /// **'Metal işleme ve makine üretim tesisleri (yoğun talaş, yağ buharı)'**
  String get spActMetalworkingMachineryHeavySwarfOilMist;

  /// No description provided for @spActFlammableLiquidProcessFp55Plus.
  ///
  /// In tr, this message translates to:
  /// **'Parlama noktası ≥ 55 °C yanıcı sıvı işleme/depolama prosesleri'**
  String get spActFlammableLiquidProcessFp55Plus;

  /// No description provided for @spActFoamRubberFoamPlasticProduction.
  ///
  /// In tr, this message translates to:
  /// **'Köpük kauçuk ve köpük plastik (PU, EPS/XPS) üretim tesisleri'**
  String get spActFoamRubberFoamPlasticProduction;

  /// No description provided for @spActFlowCoatingMetalPlasticParts.
  ///
  /// In tr, this message translates to:
  /// **'Metal ve plastik parçalar için akış kaplama (flow coating)'**
  String get spActFlowCoatingMetalPlasticParts;

  /// No description provided for @spActIndustrialPrintingFlammableInkSolvent.
  ///
  /// In tr, this message translates to:
  /// **'Yanıcı mürekkep / solvent kullanan endüstriyel baskı tesisleri'**
  String get spActIndustrialPrintingFlammableInkSolvent;

  /// No description provided for @spActAerosolSprayPackagingFilling.
  ///
  /// In tr, this message translates to:
  /// **'Aerosol ve sprey ürünleri paketleme/dolum tesisleri'**
  String get spActAerosolSprayPackagingFilling;

  /// No description provided for @spActFlammableLiquidProcessFpBelow55Open.
  ///
  /// In tr, this message translates to:
  /// **'Parlama noktası < 55 °C yanıcı sıvı işleme prosesleri (açık kap)'**
  String get spActFlammableLiquidProcessFpBelow55Open;

  /// No description provided for @spActChemProductionContainingFp55Liquids.
  ///
  /// In tr, this message translates to:
  /// **'Kimyasal üretim (parlama noktası ≥ 55 °C yanıcı sıvı içeren ürünler)'**
  String get spActChemProductionContainingFp55Liquids;

  /// No description provided for @spActSolventBasedPaintVarnishProduction.
  ///
  /// In tr, this message translates to:
  /// **'Solvent bazlı boya ve vernik üretim tesisleri'**
  String get spActSolventBasedPaintVarnishProduction;

  /// No description provided for @spActSpraySolventPaintApplication.
  ///
  /// In tr, this message translates to:
  /// **'Sprey boyahane — yanıcı solvent bazlı boya uygulaması'**
  String get spActSpraySolventPaintApplication;

  /// No description provided for @spActDryCleaningPerchloroethyleneSolvent.
  ///
  /// In tr, this message translates to:
  /// **'Kuru temizleme tesisleri (perkloretilen / solvent bazlı)'**
  String get spActDryCleaningPerchloroethyleneSolvent;

  /// No description provided for @spActSolventExtractionFacilities.
  ///
  /// In tr, this message translates to:
  /// **'Solvent ekstraksiyon tesisleri'**
  String get spActSolventExtractionFacilities;

  /// No description provided for @spActPrintingGravureFlammableInk.
  ///
  /// In tr, this message translates to:
  /// **'Yanıcı mürekkep kullanan baskı / gravür tesisleri'**
  String get spActPrintingGravureFlammableInk;

  /// No description provided for @spActSprayCoatingBoothsFlammableLiquid.
  ///
  /// In tr, this message translates to:
  /// **'Yanıcı sıvı ile sprey kaplama / boyama kabinleri'**
  String get spActSprayCoatingBoothsFlammableLiquid;

  /// No description provided for @spActRubberMasticFlammableRawMaterialProcessing.
  ///
  /// In tr, this message translates to:
  /// **'Kauçuk mastik ve yanıcı hammadde işleme tesisleri'**
  String get spActRubberMasticFlammableRawMaterialProcessing;

  /// No description provided for @spActPaintInkVarnishPackagingFilling.
  ///
  /// In tr, this message translates to:
  /// **'Boya, mürekkep veya vernik ambalajlama ve dolum tesisleri'**
  String get spActPaintInkVarnishPackagingFilling;

  /// No description provided for @spActHighRackPalletStorageSolidAbove4m.
  ///
  /// In tr, this message translates to:
  /// **'Yüksek raflı palet depolama — katı malzeme, istif yüksekliği > 4 m'**
  String get spActHighRackPalletStorageSolidAbove4m;

  /// No description provided for @spActTyresRubberProductsStorage.
  ///
  /// In tr, this message translates to:
  /// **'Araç lastikleri ve kauçuk ürün depolaması'**
  String get spActTyresRubberProductsStorage;

  /// No description provided for @spActPaperRollsReelsStorage.
  ///
  /// In tr, this message translates to:
  /// **'Rulo kâğıt ve kâğıt topu depolaması'**
  String get spActPaperRollsReelsStorage;

  /// No description provided for @spActSolidPlasticRawProductStoragePalletRack.
  ///
  /// In tr, this message translates to:
  /// **'Katı plastik hammadde ve ürün depolaması (paletli/raflı)'**
  String get spActSolidPlasticRawProductStoragePalletRack;

  /// No description provided for @spActBaledCottonTextileSyntheticFibreStorage.
  ///
  /// In tr, this message translates to:
  /// **'Balya pamuk, tekstil hammaddesi ve sentetik elyaf depolaması'**
  String get spActBaledCottonTextileSyntheticFibreStorage;

  /// No description provided for @spActHighRackPalletStorageFlammableLiquidAbove4m.
  ///
  /// In tr, this message translates to:
  /// **'Yüksek raflı palet depolama — yanıcı sıvı içeren ürünler, > 4 m  ⚠ Yoğun su sistemi'**
  String get spActHighRackPalletStorageFlammableLiquidAbove4m;

  /// No description provided for @spActAerosolStoreFlammablePropellantHighRack.
  ///
  /// In tr, this message translates to:
  /// **'Aerosol ürün depoları (yanıcı itici gazlı, yüksek raf)  ⚠ Özel sistem gerektirir'**
  String get spActAerosolStoreFlammablePropellantHighRack;

  /// No description provided for @spActFlammableLiquidPackagedProductStorage.
  ///
  /// In tr, this message translates to:
  /// **'Yanıcı sıvı ambalajlı ürün depolaması (boya, solvent, vernik)  ⚠ Özel sistem'**
  String get spActFlammableLiquidPackagedProductStorage;

  /// No description provided for @spActHighDensityStorageWaterSensitiveHighCalorific.
  ///
  /// In tr, this message translates to:
  /// **'Islanmaya dayanıksız veya yüksek ısıl değerli ürünlerin yoğun depolanması'**
  String get spActHighDensityStorageWaterSensitiveHighCalorific;

  /// No description provided for @spActNoncombustibleStorageMetalGlassCeramicConcrete.
  ///
  /// In tr, this message translates to:
  /// **'Yanmaz ürün depolama — metal, cam, seramik, beton ürünler'**
  String get spActNoncombustibleStorageMetalGlassCeramicConcrete;

  /// No description provided for @spActFrozenFoodColdChainStorage.
  ///
  /// In tr, this message translates to:
  /// **'Dondurulmuş gıda ve soğuk zincir ürün depolama'**
  String get spActFrozenFoodColdChainStorage;

  /// No description provided for @spActNoncombustibleInSealedMetalCansDrums.
  ///
  /// In tr, this message translates to:
  /// **'Kapalı metal kutu / bidon içindeki yanmaz ürünler'**
  String get spActNoncombustibleInSealedMetalCansDrums;

  /// No description provided for @spActWetFoodFreshProduceCannedStorage.
  ///
  /// In tr, this message translates to:
  /// **'Islak gıda (taze meyve-sebze, konserve) depoları'**
  String get spActWetFoodFreshProduceCannedStorage;

  /// No description provided for @spActPorcelainSanitarywareStorage.
  ///
  /// In tr, this message translates to:
  /// **'Porselen ve sıhhi tesisat ürünleri depolama'**
  String get spActPorcelainSanitarywareStorage;

  /// No description provided for @spActEmptyGlassBottlesMetalCansStorage.
  ///
  /// In tr, this message translates to:
  /// **'Boş cam şişe / boş metal kutu depolama'**
  String get spActEmptyGlassBottlesMetalCansStorage;

  /// No description provided for @spActNoncombustibleCartonPackagedStorage.
  ///
  /// In tr, this message translates to:
  /// **'Karton ambalajlı yanmaz ürün depolama'**
  String get spActNoncombustibleCartonPackagedStorage;

  /// No description provided for @spActNoncombustibleGoodsWoodenCratesStorage.
  ///
  /// In tr, this message translates to:
  /// **'Tahta kutu / kasalarda yanmaz mal depolama'**
  String get spActNoncombustibleGoodsWoodenCratesStorage;

  /// No description provided for @spActNoncombustibleLiquidGlassPlasticContainersStorage.
  ///
  /// In tr, this message translates to:
  /// **'Cam şişe / plastik kaplar içinde yanmaz sıvı depolama'**
  String get spActNoncombustibleLiquidGlassPlasticContainersStorage;

  /// No description provided for @spActMixedProductsLowCombustibleContentStorage.
  ///
  /// In tr, this message translates to:
  /// **'Küçük oranda yanabilir içerikli karışık ürün depolama'**
  String get spActMixedProductsLowCombustibleContentStorage;

  /// No description provided for @spActGlassCeramicWrappedStorage.
  ///
  /// In tr, this message translates to:
  /// **'Boya bezlerinde cam ve seramik ürün depolama'**
  String get spActGlassCeramicWrappedStorage;

  /// No description provided for @spActPaperBoardCorrugatedProductStorage.
  ///
  /// In tr, this message translates to:
  /// **'Kâğıt, karton ve oluklu mukavva ürün depolama'**
  String get spActPaperBoardCorrugatedProductStorage;

  /// No description provided for @spActTextileYarnFabricGarmentStorage.
  ///
  /// In tr, this message translates to:
  /// **'Tekstil, iplik, kumaş ve hazır giyim depolama'**
  String get spActTextileYarnFabricGarmentStorage;

  /// No description provided for @spActWoodWoodBasedProductStorage.
  ///
  /// In tr, this message translates to:
  /// **'Ahşap ve ahşap esaslı ürün depolama'**
  String get spActWoodWoodBasedProductStorage;

  /// No description provided for @spActFurnitureUpholsteryMaterialsStorage.
  ///
  /// In tr, this message translates to:
  /// **'Mobilya ve döşeme malzemeleri depolama'**
  String get spActFurnitureUpholsteryMaterialsStorage;

  /// No description provided for @spActMixedPackagedGoodsPaperPlastic.
  ///
  /// In tr, this message translates to:
  /// **'Karışık ambalajlı mallar (kağıt + plastik kombine)'**
  String get spActMixedPackagedGoodsPaperPlastic;

  /// No description provided for @spActDryFoodAgriculturalProductsStorage.
  ///
  /// In tr, this message translates to:
  /// **'Kuru gıda ve tarım ürünleri (dökme olmayan) depolama'**
  String get spActDryFoodAgriculturalProductsStorage;

  /// No description provided for @spActLeatherProductsStorage.
  ///
  /// In tr, this message translates to:
  /// **'Deri ve deri ürünleri depolama'**
  String get spActLeatherProductsStorage;

  /// No description provided for @spActSmallElectricalApplianceStoragePackaged.
  ///
  /// In tr, this message translates to:
  /// **'Küçük elektrikli ev aletleri (ambalajlı) depolama'**
  String get spActSmallElectricalApplianceStoragePackaged;

  /// No description provided for @spActExpandedPlasticProductStorageFloor.
  ///
  /// In tr, this message translates to:
  /// **'Ekspande plastik (EPS, PU, XPS) ürün depolama (döşeme)'**
  String get spActExpandedPlasticProductStorageFloor;

  /// No description provided for @spActRubberTyreProductStorageFloor.
  ///
  /// In tr, this message translates to:
  /// **'Kauçuk ve lastik ürün depolama (döşeme)'**
  String get spActRubberTyreProductStorageFloor;

  /// No description provided for @spActFlammableLiquidPlasticContainersStorageFloor.
  ///
  /// In tr, this message translates to:
  /// **'Yanıcı sıvı içeren plastik kaplar depolama (döşeme)'**
  String get spActFlammableLiquidPlasticContainersStorageFloor;

  /// No description provided for @spActAerosolProductStorageFloor35m.
  ///
  /// In tr, this message translates to:
  /// **'Aerosol ürün depolama — döşeme, ≤ 3,5 m'**
  String get spActAerosolProductStorageFloor35m;

  /// No description provided for @spActPolystyreneFoamPackagedProductStorage.
  ///
  /// In tr, this message translates to:
  /// **'Polistiren köpük ambalajlı ürün depolama'**
  String get spActPolystyreneFoamPackagedProductStorage;

  /// No description provided for @spActHighCalorificCombustibleGoodsStorageFloor.
  ///
  /// In tr, this message translates to:
  /// **'Yüksek kalorili yanabilir mal depolama (döşeme)'**
  String get spActHighCalorificCombustibleGoodsStorageFloor;

  /// No description provided for @spActRackPalletCategoryIGoods.
  ///
  /// In tr, this message translates to:
  /// **'Raf / palet sistemi — Kategori I mallar (metal, cam, seramik)'**
  String get spActRackPalletCategoryIGoods;

  /// No description provided for @spActHighRackNoncombustibleStorageAbove3m.
  ///
  /// In tr, this message translates to:
  /// **'Yüksek raflı depo — yanmaz ürünler, istif > 3 m'**
  String get spActHighRackNoncombustibleStorageAbove3m;

  /// No description provided for @spActPalletSealedMetalGlassStorage.
  ///
  /// In tr, this message translates to:
  /// **'Palet üzeri kapalı metal / cam ürün depolama'**
  String get spActPalletSealedMetalGlassStorage;

  /// No description provided for @spActColdStoreHighRackSystem.
  ///
  /// In tr, this message translates to:
  /// **'Soğuk hava deposu yüksek raf sistemi'**
  String get spActColdStoreHighRackSystem;

  /// No description provided for @spActRackPalletCategoryIIGoods.
  ///
  /// In tr, this message translates to:
  /// **'Raf / palet sistemi — Kategori II mallar (karton ambalajlı)'**
  String get spActRackPalletCategoryIIGoods;

  /// No description provided for @spActHighRackCartonBoxedNoncombustibleStorage.
  ///
  /// In tr, this message translates to:
  /// **'Yüksek raflı depo — karton kutu içinde yanmaz ürünler'**
  String get spActHighRackCartonBoxedNoncombustibleStorage;

  /// No description provided for @spActPalletCartonPackagedStorageAbove3m.
  ///
  /// In tr, this message translates to:
  /// **'Palet üzeri karton ambalajlı ürün depolama, > 3 m'**
  String get spActPalletCartonPackagedStorageAbove3m;

  /// No description provided for @spActWoodenCrateStorageHighRack.
  ///
  /// In tr, this message translates to:
  /// **'Tahta kasalarda depolama, yüksek raf sistemi'**
  String get spActWoodenCrateStorageHighRack;

  /// No description provided for @spActRackPalletCategoryIIIGoods.
  ///
  /// In tr, this message translates to:
  /// **'Raf / palet sistemi — Kategori III mallar (kâğıt, tekstil, ahşap)'**
  String get spActRackPalletCategoryIIIGoods;

  /// No description provided for @spActHighRackFurnitureWoodProductsStorage.
  ///
  /// In tr, this message translates to:
  /// **'Yüksek raflı depo — mobilya, ahşap ürünler'**
  String get spActHighRackFurnitureWoodProductsStorage;

  /// No description provided for @spActBaledCottonTextileRackStorageAbove3m.
  ///
  /// In tr, this message translates to:
  /// **'Balya (pamuk, tekstil) raf depolama, > 3 m'**
  String get spActBaledCottonTextileRackStorageAbove3m;

  /// No description provided for @spActPaperRollsRackStorageAbove3m.
  ///
  /// In tr, this message translates to:
  /// **'Rulo kâğıt ve kâğıt topu raf depolama, > 3 m'**
  String get spActPaperRollsRackStorageAbove3m;

  /// No description provided for @spActMixedPackagedHighRackStorage.
  ///
  /// In tr, this message translates to:
  /// **'Karışık ambalajlı (kağıt + plastik) yüksek raf depolama'**
  String get spActMixedPackagedHighRackStorage;

  /// No description provided for @spActRackPalletCategoryIVGoods.
  ///
  /// In tr, this message translates to:
  /// **'Raf / palet sistemi — Kategori IV mallar (plastik, kauçuk, köpük)'**
  String get spActRackPalletCategoryIVGoods;

  /// No description provided for @spActExpandedPlasticFoamHighRackStorage.
  ///
  /// In tr, this message translates to:
  /// **'Ekspande plastik ve köpük ürün yüksek raf depolama'**
  String get spActExpandedPlasticFoamHighRackStorage;

  /// No description provided for @spActAerosolRackStorageFlammablePropellantAbove3m.
  ///
  /// In tr, this message translates to:
  /// **'Aerosol ürün raf depolama — yanıcı itici gazlı, > 3 m'**
  String get spActAerosolRackStorageFlammablePropellantAbove3m;

  /// No description provided for @spActSolidPlasticRawProductHighRackStorage.
  ///
  /// In tr, this message translates to:
  /// **'Katı plastik hammadde ve ürün yüksek raf depolama'**
  String get spActSolidPlasticRawProductHighRackStorage;

  /// No description provided for @spActFlammablePackagedProductHighRackStorage.
  ///
  /// In tr, this message translates to:
  /// **'Yanıcı ambalajlı ürün yüksek raf depolama (boya, vernik, solvent)'**
  String get spActFlammablePackagedProductHighRackStorage;

  /// No description provided for @spActRubberTyreProductHighRackStorageAbove3m.
  ///
  /// In tr, this message translates to:
  /// **'Kauçuk ve lastik ürün yüksek raf depolama, > 3 m'**
  String get spActRubberTyreProductHighRackStorageAbove3m;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
