// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get languageLabel => 'Dil';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get logout => 'Çıkış';

  @override
  String get save => 'Kaydet';

  @override
  String get saved => 'Kaydedildi!';

  @override
  String get cancel => 'Vazgeç';

  @override
  String get delete => 'Sil';

  @override
  String get deletingAccount => 'Hesap siliniyor...';

  @override
  String get accountDeleteTitle => 'Hesabınızı silmeyi onaylıyor musunuz?';

  @override
  String get accountDeleteWarning =>
      'Hesabınız aktif sistemden silinir. Ad-soyad, e-posta, önceki üyelik durumu ve kayıt/silinme tarihleri silinen üyeler geçmişinde adminlere gösterilmek üzere tutulur. Bu işlem geri alınamaz.';

  @override
  String get accountManagement => 'Hesap Yönetimi';

  @override
  String get accountDeleteInfo =>
      'Hesabınızı ve bu cihazda saklanan hesap bilgilerinizi kalıcı olarak silebilirsiniz.';

  @override
  String get deleteAccount => 'Hesabımı Kalıcı Olarak Sil';

  @override
  String get feedbackTitle => 'Geri Bildirim';

  @override
  String get feedbackSubtitle => 'Bir sorun mu buldunuz? Bize bildirin.';

  @override
  String get feedbackSelectPage => 'Hangi sayfa ile ilgili?';

  @override
  String get feedbackSelectPageHint => 'Sayfa seçin';

  @override
  String get feedbackMessageLabel => 'Hata mesajınızı yazın';

  @override
  String get feedbackMessageHint => 'Karşılaştığınız sorunu buraya yazın...';

  @override
  String get feedbackSend => 'Gönder';

  @override
  String get feedbackSending => 'Gönderiliyor...';

  @override
  String get feedbackSentSuccess => 'Geri bildiriminiz için teşekkürler!';

  @override
  String get feedbackSendFailed =>
      'Geri bildirim gönderilemedi. Lütfen tekrar deneyin.';

  @override
  String get feedbackMessageRequired => 'Lütfen bir mesaj yazın.';

  @override
  String get feedbackPageHome => 'Ana Sayfa';

  @override
  String get feedbackPageOther => 'Diğer';

  @override
  String get apiKeyTitle => 'Gemini API Anahtarı (AI)';

  @override
  String get apiKeyInstructions =>
      'aistudio.google.com/apikey adresinden ücretsiz API anahtarı alabilirsiniz.';

  @override
  String get getApiKey => 'API Anahtarı al';

  @override
  String get updateApiKey => 'API Anahtarını Güncelle';

  @override
  String get add => 'Ekle';

  @override
  String get done => 'Tamam';

  @override
  String get smokeReference =>
      'TS EN 54-7:2006 / EN 54-14:2004 — Nokta tipi duman dedektörü yerleşimi\nÖn boyutlandırmadır; kesin tasarım için sistem mühendisinin onayı gerekir.';

  @override
  String get buildingType => 'Yapı Tipi';

  @override
  String get buildingOffice => 'Ofis / İdari';

  @override
  String get buildingHome => 'Konut / Otel';

  @override
  String get buildingHospital => 'Hastane';

  @override
  String get buildingCommercial => 'Ticari / AVM';

  @override
  String get buildingWarehouseNormal => 'Depo (normal ≤ 6 m)';

  @override
  String get buildingWarehouseHigh => 'Depo (yüksek > 6 m)';

  @override
  String get buildingIndustrial => 'Endüstriyel';

  @override
  String defaultCeilingHeight(String height) {
    return 'Varsayılan tavan yüksekliği: $height m';
  }

  @override
  String get editablePerRoom => 'Her odada ayrıca düzenlenebilir';

  @override
  String get addFloorZone => 'Kat / Bölge Ekle';

  @override
  String get floorZone => 'Kat / Bölge';

  @override
  String get totalDetectors => 'Toplam Dedektör';

  @override
  String detectorCount(int count) {
    return '$count adet';
  }

  @override
  String get addRoomArea => 'Oda / Alan Ekle';

  @override
  String get editRoomArea => 'Oda Düzenle';

  @override
  String get roomAreaName => 'Oda / Alan Adı';

  @override
  String get roomAreaExample => 'örn. Yemekhane, Sunucu Odası…';

  @override
  String get areaType => 'Alan Tipi';

  @override
  String get validDimensions => 'Geçerli ölçüler giriniz.';

  @override
  String get roomNameRequired => 'Oda adı boş bırakılamaz.';

  @override
  String get roomStandard => 'Standart Oda';

  @override
  String get roomOpenOffice => 'Açık Ofis';

  @override
  String get roomTechnical => 'Teknik / Tesisat';

  @override
  String get roomKitchen => 'Mutfak / Pişirme';

  @override
  String get roomCorridor => 'Koridor (G ≤ 3 m)';

  @override
  String get roomProduction => 'Üretim / Montaj';

  @override
  String get roomWarehouseRack => 'Depo Rafı';

  @override
  String get sourceLabel => 'Kaynak';

  @override
  String get deleteProjectTitle => 'Projeyi Sil';

  @override
  String deleteProjectConfirm(String name) {
    return '\"$name\" projesi silinecek. Emin misiniz?';
  }

  @override
  String get noSavedProjects => 'Henüz kayıtlı proje yok';

  @override
  String get saveProjectPrompt => 'Hesabı proje olarak kaydet';

  @override
  String get saveProjectTitle => 'Projeyi Kaydet';

  @override
  String get projectName => 'Proje Adı';

  @override
  String get projectNameExample => 'örn. Ofis Binası Zemin Kat';

  @override
  String projectSaved(String name) {
    return '\"$name\" kaydedildi';
  }

  @override
  String get copy => 'Kopyala';

  @override
  String get edit => 'Düzenle';

  @override
  String floorZoneSummary(int areas, int detectors) {
    return '$areas alan · $detectors det.';
  }

  @override
  String detectorBadge(int count) {
    return '$count det.';
  }

  @override
  String get highCeilingNotice =>
      '⚠ H > 12 m — Işın tipi / ASD dedektör gereklidir (EN 54-12 / EN 54-20)';

  @override
  String get beamRecommendation =>
      'ℹ H = 8–12 m — Işın dedektör de değerlendirilebilir';

  @override
  String widthSpacing(Object value) {
    return 'Genişlik aralığı: $value m';
  }

  @override
  String lengthSpacing(Object value) {
    return 'Uzunluk aralığı: $value m';
  }

  @override
  String wallDistanceWidth(Object value) {
    return 'Duvar mesafesi W: $value m';
  }

  @override
  String wallDistanceLength(Object value) {
    return 'Duvar mesafesi L: $value m';
  }

  @override
  String corridorSpacing(Object value) {
    return 'Koridor aralığı: $value m';
  }

  @override
  String wallDistance(Object value) {
    return 'Duvar mesafesi: $value m';
  }

  @override
  String snAreaPerDetector(Object value) {
    return 'S_n = $value m²/adet.';
  }

  @override
  String get systemLanguage => 'Cihaz dili';

  @override
  String get turkish => 'Türkçe';

  @override
  String get english => 'English';

  @override
  String get german => 'Deutsch';

  @override
  String get loginSubtitle => 'Hesabınıza giriş yapın';

  @override
  String get emailAddress => 'E-posta adresi';

  @override
  String get emailRequired => 'E-posta gereklidir';

  @override
  String get validEmailRequired => 'Geçerli bir e-posta girin';

  @override
  String get password => 'Şifre';

  @override
  String get passwordRequired => 'Şifre gereklidir';

  @override
  String get loggingIn => 'Giriş yapılıyor...';

  @override
  String get login => 'Giriş Yap';

  @override
  String get demoLogin => 'Demo ile Gir (Davlumbaz Söndürme)';

  @override
  String get accountPrompt => 'Henüz hesabınız yok mu? ';

  @override
  String get register => 'Kayıt olun →';

  @override
  String get preliminaryToolDisclaimer =>
      'Ön hesap aracıdır · Resmi proje hesabı değildir';

  @override
  String get fireSafetyCalculator => 'Yangın Güvenliği Hesap Merkezi';

  @override
  String get fireLoadTitle => 'Yangın Yükü Hesabı';

  @override
  String get fireLoadDescription =>
      'EN 1991-1-2 yangın yükü yoğunluğu ve ISO 14520 / EN 12845 söndürme maddesi hesabı';

  @override
  String get kitchenSuppressionTitle => 'Davlumbaz Söndürme';

  @override
  String get kitchenSuppressionDescription =>
      'Ticari mutfak davlumbaz söndürme sistemi — NFPA 17A / TS EN 15751 / UL 300';

  @override
  String get gasSuppressionTitle => 'Gazlı Söndürme Sistemi';

  @override
  String get gasSuppressionDescription =>
      'Toplam hacim gazlı söndürme ve baskı makineleri — TS EN 15004 / NFPA 2001 · FM-200 · Novec 1230 · CO₂ · inert gazlar';

  @override
  String get lithiumFireTitle => 'Lityum Pil Yangını';

  @override
  String get lithiumFireDescription =>
      'ESS soğutma gereksinimi — ISO 3941:2026 · NFPA 855:2023 · IEC 62619 · FM Global DS 5-33';

  @override
  String get sprinklerTitle => 'Sprinkler Sistemi';

  @override
  String get sprinklerDescription =>
      'EN 12845 tehlike sınıfına dayalı hidrolik hesap, pompa ve boru çapı';

  @override
  String get smokeDetectionTitle => 'Duman Algılama';

  @override
  String get smokeDetectionDescription =>
      'Dedektör yerleşimi ve oda tipleri — TS EN 54-7 / EN 54-14';

  @override
  String get smokeControlTitle => 'Duman Kontrolü';

  @override
  String get smokeControlDescription =>
      'Doğal ve mekanik tahliye, basınçlandırma — EN 12101-2 / EN 12101-3 / EN 12101-6';

  @override
  String get demoMode =>
      'DEMO MODU · Yalnızca \"Davlumbaz Söndürme\" modülü açıktır. Diğer modüller için hesap oluşturup abone olun.';

  @override
  String get standardSearch => 'Standart Arama';

  @override
  String get standardSearchDescription =>
      'Yangın ve güvenlik standartları veritabanında numara, ad veya kategori ile arama';

  @override
  String get standardGuide => 'Standart Rehberi';

  @override
  String get standardGuideDescription =>
      'Yangın sistemleri standart kategorileri, kapsam ve referans özeti';

  @override
  String get fireAndSuppression => 'Yangın Yükü & Söndürme';

  @override
  String get kitchenSuppression => 'Davlumbaz Söndürme';

  @override
  String get gasSuppression => 'Gazlı Söndürme Sistemi';

  @override
  String get printingSuppression => 'Baskı Makinesi Söndürme';

  @override
  String get sprinklerSystems => 'Sprinkler Sistemi';

  @override
  String get fireAlarm => 'Yangın Alarm & Algılama';

  @override
  String get fireExtinguishers => 'Yangın Söndürücüler';

  @override
  String get smokeControl => 'Duman Kontrolü & Tahliye';

  @override
  String get savedProjects => 'Kayıtlı Projeler';

  @override
  String get savedProjectsDescription => 'Kaydettiğiniz tüm hesap projeleri';

  @override
  String get addStandard => 'Standart Ekle';

  @override
  String get allCategories => 'Tüm Kategoriler';

  @override
  String get standardSearchHint => 'Numara, ad veya kategori...';

  @override
  String standardsFound(int count) {
    return '$count standart bulundu';
  }

  @override
  String category(String name) {
    return 'Kategori: $name';
  }

  @override
  String get close => 'Kapat';

  @override
  String get searchWeb => 'Web\'de Ara';

  @override
  String get askAi => 'AI\'ya Sor';

  @override
  String get moduleDisclaimer =>
      'MEVOS Fire · Yangın güvenliği ön hesap aracıdır, resmi proje hesabı değildir.';

  @override
  String get hoodSystemDescription =>
      'Ticari mutfak davlumbaz söndürme sistemi boyutlandırması.\nReferans: NFPA 17A:2021 · TS EN 15751:2016 · UL 300 · Ansul R-102';

  @override
  String get hoodEquipmentHeading => 'Davlumbaz Altı Ekipmanlar';

  @override
  String get hoodEquipmentInstructions =>
      'Ekipman sayısını + / - ile ayarlayın. Seçime göre tehlike sınıfı otomatik hesaplanır.';

  @override
  String hoodHazardClass(Object category) {
    return 'Tehlike Sınıfı: $category';
  }

  @override
  String hoodEquipmentScore(Object count, Object score) {
    return 'Ekipman puanı: $score · $count adet seçildi · < 2 › Düşük · 2–5 › Orta · ≥ 5 › Yüksek';
  }

  @override
  String get hoodFilterArea => 'Davlumbaz Filtre Alanı (iç ölçü)';

  @override
  String get singleLength => 'Uzunluk';

  @override
  String get singleWidth => 'Genişlik';

  @override
  String get hazardLight => 'Hafif';

  @override
  String get hazardMedium => 'Orta';

  @override
  String get hazardMediumHigh => 'Orta–Yüksek';

  @override
  String get hazardHigh => 'Yüksek';

  @override
  String get hazardVeryHigh => 'Çok Yüksek';

  @override
  String get hoodToastSandwichMachine => 'Tost / Sandviç Makinesi';

  @override
  String get hoodSmallElectricOven => 'Küçük Elektrikli Fırın';

  @override
  String get hoodConvectionOven => 'Konveksiyon Fırın';

  @override
  String get hoodSingleBurnerRange => 'Ocak (1 gözlü)';

  @override
  String get hoodDoubleBurnerRange => 'Ocak (2 gözlü)';

  @override
  String get hoodFourToSixBurnerRange => 'Ocak (4–6 gözlü)';

  @override
  String get hoodWokRange => 'Wok Ocağı';

  @override
  String get hoodDoubleWokRange => 'Çift Wok Ocağı';

  @override
  String get hoodSalamanderGrill => 'Salamander Izgara';

  @override
  String get hoodCharbroilerGrill => 'Charbroiler / Mangal';

  @override
  String get hoodFryerUpTo22L => 'Fritöz (≤ 22 L)';

  @override
  String get hoodFryerOver22L => 'Fritöz (> 22 L)';

  @override
  String get hoodTiltingSkillet => 'Devrilebilir Tava';

  @override
  String get calculate => 'Hesapla';

  @override
  String get calculateExtinguishingAgent => 'Söndürme Maddesini Hesapla';

  @override
  String get calculateCooling => 'Soğutma Gereksinimini Hesapla';

  @override
  String get recalculate => 'Yeniden Hesapla';

  @override
  String get calculationResults => 'Hesap Sonuçları';

  @override
  String get noResults => 'Sonuç bulunamadı';

  @override
  String get extinguishingAgent => 'Söndürme Maddesi';

  @override
  String get chemicalAgentAmount => 'Kimyasal Ajan Miktarı';

  @override
  String get minimumNozzleCount => 'Min. Nozul Sayısı';

  @override
  String get minimumDischargeTime => 'Min. Deşarj Süresi';

  @override
  String get systemType => 'Sistem Türü';

  @override
  String get naturalExhaust => 'Doğal Tahliye';

  @override
  String get mechanicalExhaust => 'Mekanik Tahliye';

  @override
  String get pressurization => 'Basınçlandırma';

  @override
  String get roomArea => 'Oda Alanı';

  @override
  String get ceilingHeight => 'Tavan Yüksekliği';

  @override
  String get designFirePower => 'Tasarım HRR (Yangın Gücü)';

  @override
  String get ambientTemperature => 'Ortam Sıcaklığı';

  @override
  String get doorWidth => 'Kapı Genişliği';

  @override
  String get doorHeight => 'Kapı Yüksekliği';

  @override
  String get stairShaftWidth => 'Merdiven Şaft Genişliği';

  @override
  String get stairShaftDepth => 'Merdiven Şaft Derinliği';

  @override
  String get floorHeight => 'Kat Yüksekliği';

  @override
  String get floorCount => 'Kat Sayısı';

  @override
  String get shaftWallMaterial => 'Şaft Duvarı Malzemesi';

  @override
  String get extinguishingDesignResult => 'Söndürme Boyutlandırma Sonucu';

  @override
  String get smokeTemperature => 'Duman Sıcaklığı';

  @override
  String get temperatureRise => 'Sıcaklık Artışı';

  @override
  String get effectiveOpening => 'Gerekli efektif açıklık';

  @override
  String get freshAirInlet => 'Min. taze hava girişi';

  @override
  String get fanDesignFlow => 'Fan tasarım debisi';

  @override
  String get calculatedAirChanges => 'Hesaplanan hava değişimi';

  @override
  String get targetPressureDifference => 'Hedef basınç farkı';

  @override
  String get openDoorFlow => 'Açık kapı geçiş debisi';

  @override
  String get closedDoorLeakage => 'Kapalı kapı sızıntısı / kat';

  @override
  String get wallLeakage => 'Duvar sızıntısı (tüm katlar)';

  @override
  String get totalFanFlow => 'Toplam fan debisi';

  @override
  String get sourceStandards => 'Referans Standartlar';

  @override
  String get unknown => 'Bilinmiyor';

  @override
  String get smokeControlStandards =>
      'EN 12101-2 Doğal · EN 12101-3 Mekanik · EN 12101-6 Basınçlandırma';

  @override
  String get designFirePowerHint =>
      'Tasarım yangın gücü — EN 1991-1-2 Ek E. Örn: orta tehlike ofis ≈ 500 kW';

  @override
  String get unknownFirePowerButton =>
      'HRR değerini bilmiyorum — Yangın yükü hesabı yap';

  @override
  String get smokeLayerHeight => 'Duman Katmanı Taban Yüksekliği z';

  @override
  String get smokeLayerHeightHint =>
      'Temiz hava katmanının üst sınırı (zeminden ölçülür). z < H olmalı. Hedef z ≥ 2,5 m';

  @override
  String get pressurizationConditions =>
      'Hedef ΔP = 50 Pa, kapı aralığı 10 mm (EN 12101-6 §7.3.3 / Ek F Tablo F.1)';

  @override
  String get naturalExhaustResult => 'Doğal Tahliye Sonuçları (EN 12101-2)';

  @override
  String get mechanicalExhaustResult =>
      'Mekanik Tahliye Sonuçları (EN 12101-3)';

  @override
  String get pressurizationResult => 'Basınçlandırma Sonuçları (EN 12101-6)';

  @override
  String get smokeMassFlow => 'Duman kütle debisi';

  @override
  String get smokeVolumeFlow => 'Hacimsel duman debisi';

  @override
  String get minimumFreshAir => 'Min. taze hava girişi';

  @override
  String get batteryTechnology => 'Pil Teknolojisi';

  @override
  String get nmcDescription =>
      'Nikel-Manganez-Kobalt · 30 MJ/kWh — Yüksek yoğunluk, orta stabilite';

  @override
  String get lfpDescription =>
      'Lityum Demir Fosfat · 12 MJ/kWh — Düşük ısı, yüksek güvenlik';

  @override
  String get ncaDescription =>
      'Nikel-Kobalt-Alüminyum · 35 MJ/kWh — En yüksek enerji yoğunluğu';

  @override
  String get lcoDescription =>
      'Lityum Kobalt Oksit · 35 MJ/kWh — Tüketici elektroniği';

  @override
  String get essLithiumFireInfo =>
      'ISO 3941:2026 · NFPA 855:2023 · IEC 62619:2022 · FM Global DS 5-33\nLityum iyon/polimer pil yangınlarında termik kaçış (thermal runaway) nedeniyle gazlı baskılama değil soğutma esastır. Aşağıdaki hesap ön boyutlandırma amaçlıdır.';

  @override
  String get nmcThermalRunawayNote =>
      'NMC/NCM: Nikel-Manganez-Kobalt — 30 MJ/kWh termik kaçış ısısı (IEC 62619)';

  @override
  String get lfpThermalRunawayNote =>
      'LFP: Lityum Demir Fosfat — 12 MJ/kWh termik kaçış ısısı (IEC 62619)';

  @override
  String get ncaThermalRunawayNote =>
      'NCA: Nikel-Kobalt-Alüminyum — 35 MJ/kWh termik kaçış ısısı (IEC 62619)';

  @override
  String get lcoThermalRunawayNote =>
      'LCO: Lityum Kobalt Oksit — 35 MJ/kWh termik kaçış ısısı (IEC 62619)';

  @override
  String get hazardClassificationBasisNote =>
      'NFPA 855:2023 §4.4.2 — Tehlike sınıflandırmasına esas';

  @override
  String get fmGlobalMinDurationNote =>
      'FM Global DS 5-33 min. süre: 30 dk  —  NFPA 855:2023 §12.4';

  @override
  String get essHazardCategoryInfo =>
      'NFPA 855:2023 Tehlike Kategorisi & FM DS 5-33 Uygulama Yoğunluğu:\n  • Düşük  (< 20 kWh)  ›  8,2 L/min/m²\n  • Orta   (20–600 kWh)  ›  12,2 L/min/m²\n  • Yüksek (> 600 kWh)  ›  16,3 L/min/m²';

  @override
  String get essResultsFooterNote =>
      '• Isı katsayısı: NMC 30 · LFP 12 · NCA/LCO 35 MJ/kWh  (IEC 62619:2022)\n• Tepe HRR katsayısı: NMC 3,0 · LFP 1,5 · NCA/LCO 3,5 kW/kWh  (SP 2022:08)\n• t² büyüme: α=0,0469 kW/s² (hızlı sınıf · ISO 16734 / NFPA 72)\n• F-500 konsantrasyonu: %1,5 (üretici test verisi — Enviro Voraxial)\n• Su sisi alternatif: NFPA 750 / TS EN 14972-1\n• Büyük ESS (> 600 kWh): IEC 63272, UL 9540A testleri zorunludur\n• Bu hesap ön boyutlandırma amaçlıdır. FM Global DS 5-33 onaylı sistem zorunludur.';

  @override
  String get evLithiumFireInfo =>
      'ISO 6469 · NFPA 88A:2021 · VdS 3471:2023 · IEC 62619:2022\nElektrikli araç yangınlarında termik kaçış soğutma ile yönetilir; gazlı veya kuru baskılama etkisizdir.';

  @override
  String get passengerCarSpecNote =>
      'Otomobil — 30–100 kWh\n400–600 L/min · 60 dk min. (VdS 3471)';

  @override
  String get lightCommercialSpecNote =>
      'Van / Minibüs — 60–120 kWh\n600 L/min · 60 dk min.';

  @override
  String get heavyCommercialSpecNote =>
      'Elektrikli otobüs/kamyon — 200–600 kWh\n1 000 L/min · 90 dk min.';

  @override
  String get nmcHeatValue => 'Nikel-Manganez-Kobalt — 30 MJ/kWh';

  @override
  String get lfpHeatValue => 'Lityum Demir Fosfat — 12 MJ/kWh';

  @override
  String get ncaHeatValue => 'Nikel-Kobalt-Alüminyum — 35 MJ/kWh';

  @override
  String get lcoHeatValue => 'Lityum Kobalt Oksit — 35 MJ/kWh';

  @override
  String get vehicleBatteryCapacityNote =>
      'Tek araç batarya kapasitesi — IEC 62619 termik kaçış hesabına esas';

  @override
  String get maxSimultaneousVehiclesNote =>
      'VdS 3471:2023 — maks. 2 araç eş zamanlı yanma kabul edilir';

  @override
  String get vehicleApplicationDurationNote =>
      'Binek / Hafif ticari min. 60 dk · Ağır ticari min. 90 dk  (VdS 3471:2023)';

  @override
  String get vdsMinimumFlowInfo =>
      'VdS 3471:2023 Araç Başına Minimum Debi:\n  • Binek araç < 60 kWh  ›  400 L/min\n  • Binek araç ≥ 60 kWh  ›  600 L/min\n  • Hafif ticari           ›  600 L/min\n  • Ağır ticari / Otobüs  ›  1 000 L/min';

  @override
  String get evResultsFooterNote =>
      '• Isı katsayısı: NMC 30 · LFP 12 · NCA/LCO 35 MJ/kWh  (IEC 62619:2022)\n• Tepe HRR: binek <60kWh›3MW, ?60kWh›6MW · hafif ticari›8MW · ağır›15MW  (SP 2021:11)\n• t² büyüme modeli: ?=0,1876 kW/s² (ultra-fast · ISO 16734 / NFPA 72 Tablo B.2.3)\n• Su debisi: VdS 3471:2023 — 2 araç eş zamanlı (otopark)\n• Container daldırma: 3 000 L/araç (BRE Global / SFPE)\n• Kapalı otopark: NFPA 88A:2021 sprinkler gereklidir\n• Bu hesap ön boyutlandırma amaçlıdır.';

  @override
  String heatPerVehicleMj(String value) {
    return '$value MJ/araç';
  }

  @override
  String avgHrrPerVehicleMw(String value) {
    return '$value MW/araç';
  }

  @override
  String get installedCapacity => 'Kurulu Kapasite (ESS)';

  @override
  String get protectedArea => 'Koruma Alanı (ESS ayak izi)';

  @override
  String get applicationDuration => 'Uygulama Süresi';

  @override
  String get batteryCapacity => 'Araç Batarya Kapasitesi';

  @override
  String get vehicleCount => 'Araç Sayısı (risk bölgesi)';

  @override
  String get vehicleType => 'Araç Tipi';

  @override
  String get passengerCar => 'Binek Araç';

  @override
  String get lightCommercial => 'Hafif Ticari';

  @override
  String get heavyCommercialBus => 'Ağır Ticari / Otobüs';

  @override
  String get essStationary => 'ESS / Sabit Depo';

  @override
  String get electricVehicleMode => 'Elektrikli Araç';

  @override
  String get coolingCalculationResult => 'Soğutma Hesabı Sonucu';

  @override
  String get electricVehicleFireResult => 'Elektrikli Araç Yangın Hesabı';

  @override
  String get thermalRunawayHeat => 'Termik Kaçış Isısı';

  @override
  String get estimatedPeakHrr => 'Tahmini Tepe HRR';

  @override
  String get timeToPeak => 'Tepeye Ulaşma Süresi';

  @override
  String get minimumFlowRate => 'Minimum Debi';

  @override
  String get totalWaterVolume => 'Toplam Su Hacmi';

  @override
  String get f500Amount => 'F-500 Miktarı (%1,5 çözelti)';

  @override
  String get averageHeatReleaseRate => 'Ortalama Isı Salım Hızı (HRR)';

  @override
  String get vehicleMinimumFlow => 'Araç Başı Minimum Debi';

  @override
  String get simultaneousVehicleFlow =>
      'Toplam Debi (en fazla 2 araç eş zamanlı)';

  @override
  String get containerImmersion => 'Container Daldırma (alternatif)';

  @override
  String get fireRiskCategory => 'NFPA 855 Tehlike Kategorisi';

  @override
  String get netProtectionVolume => 'Net Koruma Hacmi';

  @override
  String get minimumDesignTemperature => 'Min. Tasarım Sıcaklığı';

  @override
  String get altitudeCorrection => 'Rakım düzeltmesi (TS EN 15004-1 Ek A)';

  @override
  String get safetyMargin => '%10 Güvenlik Payı (TS EN 15004-1 §5.5)';

  @override
  String get fireClass => 'Yangın Sınıfı';

  @override
  String get surfaceClassA => 'Sınıf A (Yüzey)';

  @override
  String get deepClassA => 'Sınıf A (Derin)';

  @override
  String get classB => 'Sınıf B';

  @override
  String get classC => 'Sınıf C';

  @override
  String get gasAgent => 'Söndürme Gazı';

  @override
  String get designConcentration => 'Tasarım Konsantrasyonu (%)';

  @override
  String get dischargeDuration => 'Deşarj Süresi';

  @override
  String get nozzleDiameter => 'Nozul Çapı';

  @override
  String get automaticNozzle => 'Otomatik (alan/hacim bazlı)';

  @override
  String get roomDimensions => 'Oda Ölçüsü';

  @override
  String get directVolume => 'Doğrudan Hacim';

  @override
  String get gasRoomTab => 'Mahal';

  @override
  String get gasPrintingTab => 'Baskı Makinesi';

  @override
  String get gasPanelTab => 'Pano İçi';

  @override
  String get machineType => 'Makine Tipi';

  @override
  String get inkSolventType => 'Mürekkep / Çözücü Tipi';

  @override
  String get measureCabinet => 'Kabini Ölç';

  @override
  String get unitCabinetVolume => 'Ünite Kabini Hacmi';

  @override
  String get printingUnitCount => 'Baskı Ünitesi Sayısı';

  @override
  String get agentPerUnit => 'Ünite Başına Ajan';

  @override
  String get totalAgent => 'Toplam Ajan';

  @override
  String get backupCylinderCount => 'Yedek Besleme Silindir Sayısı';

  @override
  String get totalCylinders => 'Toplam Silindir (Ana + Yedek)';

  @override
  String get cleanAgent => 'Temiz Gaz';

  @override
  String get panelDimensions => 'Pano Ölçüsü';

  @override
  String get panelCabinetVolume => 'Pano/Kabin Hacmi';

  @override
  String get standard => 'Standart';

  @override
  String get certification => 'Sertifikasyon';

  @override
  String get maximumTubingLength => 'Maks. Tubing Uzunluğu';

  @override
  String get estimatedAgentAmount => 'Tahmini Ajan Miktarı';

  @override
  String get buildingDimensions => 'Bina Boyutları';

  @override
  String get buildingActivity => 'Bina Faaliyeti';

  @override
  String get activitySearch => 'Faaliyet ara…';

  @override
  String get advancedDesignOptions => 'Gelişmiş Tasarım Seçenekleri';

  @override
  String get pipeMaterial => 'Boru Malzemesi';

  @override
  String get spPipeGalvanizedSteel => 'Galvanizli Çelik (Sch.40)';

  @override
  String get spPipeBlackCarbonSteelWelded => 'Siyah Karbon Çelik — kaynaklı';

  @override
  String get spPipeCopper => 'Bakır Boru';

  @override
  String get spPipeStainlessSteel => 'Paslanmaz Çelik';

  @override
  String get spPipeCpvcPlastic => 'CPVC Plastik Boru';

  @override
  String get sprinklerType => 'Sprinkler Tipi (K-Faktör)';

  @override
  String get installationClassPump => 'Kurulum Sınıfı / Pompa Yedekliliği';

  @override
  String get dryPipeSystem => 'Kuru borulu sistem (donma riskli alan)';

  @override
  String get rackStorage =>
      'Raf / palet depolama — In-Rack sprinkler (ön tasarım)';

  @override
  String get rackLevels => 'Raf Kat Sayısı (in-rack seviyesi)';

  @override
  String get foamSystem => 'Köpük Sistemi';

  @override
  String get addFoamSystem => 'Köpük söndürme sistemi ekle (EN 13565-2)';

  @override
  String get flammableLiquidCategory => 'Sıvı Yanıcı Kategorisi';

  @override
  String get hydrocarbon => 'Hidrokarbon (B1)';

  @override
  String get polarSolvent => 'Polar Solvent (B2)';

  @override
  String get foamConcentrateType => 'Köpük Konsantresi Tipi';

  @override
  String get foamType => 'Köpük Tipi';

  @override
  String get minimumApplicationTime => 'Minimum Uygulama Süresi';

  @override
  String get ceilingSuspended => 'Asma Tavan';

  @override
  String get suspendedCeilingExists => 'Asma tavan mevcut (gizli boşluk)';

  @override
  String get voidDepth => 'Boşluk Derinliği (cm)';

  @override
  String get building => 'Bina';

  @override
  String get electricalPanel => 'Elektrik Panosu';

  @override
  String get fuelOrStorage => 'Yakıt / Depo';

  @override
  String get buildingUseType => 'Bina / Kullanım Türü';

  @override
  String get chooseBuildingUseType => 'Bina / Kullanım Türü Seçiniz';

  @override
  String get referenceDensity => 'Referans yoğunluk';

  @override
  String get growthRate => 'Büyüme hızı';

  @override
  String get growthRateVerySlow => 'Çok Yavaş';

  @override
  String get growthRateSlow => 'Yavaş';

  @override
  String get growthRateMedium => 'Orta';

  @override
  String get growthRateFast => 'Hızlı';

  @override
  String get growthRateVeryFast => 'Çok Hızlı';

  @override
  String get floorArea => 'Kat Alanı A (m²)';

  @override
  String get cabinetNozzlePressure => 'Yangın Dolabı Nozul Basıncı (min 4 bar)';

  @override
  String get combustibleMaterials => 'Yanıcı Malzemeler';

  @override
  String get addMaterial => 'Malzeme Ekle';

  @override
  String get woodTimber => 'Ahşap / Kereste';

  @override
  String get savedValues => 'Kaydedilen Değerler';

  @override
  String get noSavedCalculationResult =>
      'Bu proje için kaydedilmiş hesap sonucu bulunamadı.';

  @override
  String get apiKeyEnter => 'Gemini API anahtarını girin';

  @override
  String get searchBuildingTypes => 'Bina türü ara…';

  @override
  String get material => 'Malzeme';

  @override
  String get massKg => 'Kütle (kg)';

  @override
  String get netCalorificValue => 'NCV (MJ/kg)';

  @override
  String get capacityTank => 'Kapasite / tank';

  @override
  String get unit => 'Birim';

  @override
  String get quantity => 'Adet';

  @override
  String get standardNumber => 'Standart Numarası *';

  @override
  String get standardNumberExample => 'ör: EN 12345';

  @override
  String get description => 'Açıklama *';

  @override
  String get shortDescriptionHint => 'Standardın kısa açıklaması…';

  @override
  String get topicKeyword => 'Konu veya Anahtar Kelime';

  @override
  String get topicKeywordExample => 'ör: baca brandası, ofis sprinkler…';

  @override
  String get questionHint => 'Sorunuzu yazın…';

  @override
  String get searchActivity => 'Faaliyet ara…';

  @override
  String get unitWidth => 'G (m)';

  @override
  String get unitLength => 'U (m)';

  @override
  String get unitHeight => 'H (m)';

  @override
  String get searchMaterials => 'Malzeme ara…';

  @override
  String get solid => 'Katı';

  @override
  String get liquid => 'Sıvı';

  @override
  String get gas => 'Gaz';

  @override
  String get other => 'Diğer';

  @override
  String get lowHazardAppendix => 'Düşük Tehlike (Ek-1/A)';

  @override
  String get ordinaryHazardAppendix => 'Orta Tehlike (Ek-1/B)';

  @override
  String get highHazardAppendix => 'Yüksek Tehlike (Ek-1/C)';

  @override
  String get unclassified => 'Sınıflandırılmamış';

  @override
  String materialGroupCount(String category, int count) {
    return '$category · $count malzeme';
  }

  @override
  String get materialWoodTimber => 'Ahşap / Kereste';

  @override
  String get materialPlywoodMdf => 'Kontrplak / MDF';

  @override
  String get materialPaperCardboard => 'Kâğıt / Karton';

  @override
  String get materialCottonTextile => 'Tekstil (pamuklu)';

  @override
  String get materialSyntheticTextile => 'Tekstil (sentetik)';

  @override
  String get materialWool => 'Yün';

  @override
  String get materialClothing => 'Giysi';

  @override
  String get materialLeather => 'Deri';

  @override
  String get materialPolyethylene => 'Polietilen (PE)';

  @override
  String get materialPolypropylene => 'Polipropilen (PP)';

  @override
  String get materialRigidPvc => 'PVC (sert)';

  @override
  String get materialFlexiblePvc => 'PVC (esnek/kablo)';

  @override
  String get materialPolystyrene => 'Polistiren (PS)';

  @override
  String get materialEpsFoam => 'EPS köpük';

  @override
  String get materialXpsFoam => 'XPS köpük';

  @override
  String get materialAbsPlastic => 'ABS Plastik';

  @override
  String get materialPmma => 'PMMA (Pleksiglas)';

  @override
  String get materialEpoxyResin => 'Epoksi Reçine';

  @override
  String get materialPolyesterResin => 'Polyester Reçine (CTP/FRP)';

  @override
  String get materialRigidPolyurethaneFoam => 'Poliüretan köpük (sert)';

  @override
  String get materialFlexiblePolyurethaneFoam => 'Poliüretan köpük (esnek)';

  @override
  String get materialNaturalRubber => 'Kauçuk (doğal)';

  @override
  String get materialVehicleTire => 'Lastik (araç)';

  @override
  String get materialGasoline => 'Benzin';

  @override
  String get materialDiesel => 'Dizel';

  @override
  String get materialLpg => 'LPG';

  @override
  String get materialPropane => 'Propan';

  @override
  String get materialNaturalGasCng => 'Doğalgaz (CNG)';

  @override
  String get materialMethanol => 'Metanol';

  @override
  String get materialEthanol => 'Etanol';

  @override
  String get materialAcetoneSolvent => 'Aseton / Solvent (genel)';

  @override
  String get materialSolventBasedPaint => 'Boya / Vernik (solventli)';

  @override
  String get materialAsphaltBitumen => 'Asfalt / Bitüm';

  @override
  String get materialCoal => 'Kömür';

  @override
  String get materialMineralTransformerOil => 'Trafo Yağı (mineral)';

  @override
  String get materialHydraulicOil => 'Hidrolik Yağ';

  @override
  String get materialPvcCable => 'Elektrik Kablosu (PVC)';

  @override
  String get materialXlpeCable => 'Elektrik Kablosu (XLPE)';

  @override
  String get materialLithiumIonBattery => 'Li-ion Batarya';

  @override
  String get materialMixedFurniture => 'Mobilya (karma)';

  @override
  String get materialOtherManual => 'Diğer (manuel)';

  @override
  String get fireLoadFormulaInfo =>
      'q = (m × H) / A\nm = yanıcı malzeme kütlesi (kg)  ·  H = NCV (MJ/kg)  ·  A = kat alanı (m²)';

  @override
  String get panelInnerDimensions => 'Pano İç Ölçüleri (cm)';

  @override
  String get panelWidth => 'Genişlik';

  @override
  String get panelHeight => 'Yükseklik';

  @override
  String get panelDepth => 'Derinlik';

  @override
  String cableFillRatio(Object value) {
    return 'Kablo dolum oranı: % $value';
  }

  @override
  String get fuelStorageInstructions =>
      'Her tank türü, adedi ve kapasitesini girin.\nLPG için ton, sıvı yakıtlar için m³ veya ton kullanabilirsiniz.\nYangın yükü yoğunluğu için bund/havuz alanı opsiyoneldir.';

  @override
  String get fuelChemicalTanks => 'Yakıt / Kimyasal Tanklar';

  @override
  String totalApproxMass(Object value) {
    return 'Toplam yaklaşık kütle: $value ton';
  }

  @override
  String get bundPoolArea => 'Bund / Havuz Alanı  (m²)  —  opsiyonel';

  @override
  String get fireLoadDensityIfEntered =>
      'Girilirse yangın yükü yoğunluğu (MJ/m²) hesaplanır.';

  @override
  String get ventilationLimitedQmaxInclude =>
      'Havalandırma sınırlı Q_max hesabına dahil et (opsiyonel)';

  @override
  String get ventilationLimitedQmaxNote =>
      'Not: Varsayılan hesap yalnızca yakıt yüzeyi sınırlı Q_max (RHRf×A) kullanır; açıklık (pencere/kapı) sınırlı Q_max hesaba katılmaz (EN 1991-1-2 Ek E).';

  @override
  String get openingArea => 'Açıklık (Pencere/Kapı) Alanı  Aᵥ';

  @override
  String get openingHeight => 'Açıklık Yüksekliği  h_eq';

  @override
  String get openingAreaHeightExplanation =>
      'Aᵥ: mahaldeki tüm pencere/kapı açıklıklarının toplam alanı  ·  h_eq: bu açıklıkların ortalama yüksekliği (mahal/oda yüksekliği DEĞİL).';

  @override
  String get ventilationQmaxFormulaNote =>
      'Q̇ₘₐₓ,ᵥ ≈ 0,09×Aᵥ×√h_eq × Hu_ort × 0,8  —  yaklaşık Kawagoe ventilasyon faktörü (Drysdale / SFPE); kesin tasarım için tam açıklık faktörü hesabı gereklidir.';

  @override
  String get totalFireEnergyLabel => 'TOPLAM YANGIN ENERJİSİ';

  @override
  String get totalEnergy => 'Toplam Enerji';

  @override
  String get totalEnergyGJ => 'Toplam Enerji (GJ)';

  @override
  String get totalEnergyMWh => 'Toplam Enerji (MWh)';

  @override
  String get totalEnergyGWh => 'Toplam Enerji (GWh)';

  @override
  String get bundAreaIfEnteredNote =>
      'Bund/havuz alanı girilirse yangın yükü yoğunluğu (MJ/m²) hesaplanır.';

  @override
  String get calculationResultLabel => 'HESAPLAMA SONUCU';

  @override
  String get totalFireLoad => 'Toplam Yangın Yükü';

  @override
  String get fireLoadDensityLabel => 'Yangın Yükü Yoğunluğu  q';

  @override
  String exceedsReferenceLabel(Object value) {
    return '^ +$value MJ/m² — Referansı AŞIYOR';
  }

  @override
  String belowReferenceLabel(Object value) {
    return ' $value MJ/m² — Referans Altında';
  }

  @override
  String get fireGrowthTimeline => 'Yangın Büyüme Takvimi (EN 1991-1-2 E.4)';

  @override
  String get growthPhaseEnd => 'Büyüme fazı sonu';

  @override
  String get decayPhaseStart => 'Bozunma başlangıcı (% 70 tüketim)';

  @override
  String get totalFireDuration => 'Toplam yangın süresi';

  @override
  String peakHeatReleaseLabel(Object factor, Object value) {
    return 'Tepe Q̇: $value MW  ·  Sınırlayan faktör: $factor';
  }

  @override
  String get limitingFactorFuelSurface => 'Yakıt Yüzeyi (RHRf × A)';

  @override
  String get limitingFactorTotalEnergy => 'Toplam Enerji (düşük yangın yükü)';

  @override
  String get limitingFactorVentilation => 'Havalandırma (açıklık — yaklaşık)';

  @override
  String get extinguishingAgentCalcTitle => 'Söndürme Maddesi Hesabı';

  @override
  String panelVolumeHeight(Object value) {
    return 'Hacim yüksekliği (pano): $value';
  }

  @override
  String get panelAgentRecommendation =>
      'Elektrik panosu için FM-200 (HFC-227ea) veya Novec 1230 önerilir — ISO 14520 / NFPA 2001.';

  @override
  String get extinguishingAgentLabel => 'Söndürme Maddesi';

  @override
  String get altitudeCorrectionLabel => 'Rakım düzeltmesi (ISO 14520-1 Ek A)';

  @override
  String get altitudeLabel => 'Rakım (m)';

  @override
  String get requiredAgent => 'Gerekli Ajan';

  @override
  String get requiredAgentMass => 'Gerekli Ajan Kütlesi';

  @override
  String get cylinderCountApprox => 'Şişe Sayısı (80L/200bar≈16Nm³)';

  @override
  String get cylinderContainerCount => 'Şişe / Kap Sayısı';

  @override
  String get portableExtinguisherTitle =>
      'Taşınabilir Yangın Söndürücü (TS 862-7 EN 3-7)';

  @override
  String get fireLoadSourcesFooter =>
      'Kaynak: EN 1991-1-2:2002 Ek E · ISO 14520 · EN 12845 · TS 862-7 EN 3-7+A1';

  @override
  String get portableExtinguisherSourceFooter =>
      'Kaynak: TS 862-7 EN 3-7+A1 (2010) · BYKHY Madde 94-96';

  @override
  String get fireCabinetSourceFooter =>
      'Kaynak: BYKHY Md. 91-93 · TS EN 671-1 · TS 9811';

  @override
  String get fireCabinetTitle =>
      'Yangın Dolabı (BYKHY Md. 91-93 / TS EN 671-1)';

  @override
  String fireCabinetTechSpecs(Object capacity, Object flow, Object p) {
    return 'DN25 (1\") yarı sert hortumlu makara · TS EN 671-1 · K=50\nQ = K × √P = 50 × √$p bar = $flow L/min\nPratik söndürme kapasitesi:\n  $capacity';
  }

  @override
  String get classACapacityPerCabinet => 'A sınıfı: 2.0 MW/dolap';

  @override
  String get classBCapacityPerCabinet => 'B sınıfı: 0.6 MW/dolap';

  @override
  String get hazardClassLabel => 'Tehlike sınıfı';

  @override
  String get hazardClassLow => 'Düşük';

  @override
  String get hazardClassMedium => 'Orta';

  @override
  String get hazardClassHigh => 'Yüksek';

  @override
  String get requiredCabinetCount => 'Gerekli dolap adedi';

  @override
  String get totalExtinguishingCapacityLabel => 'Toplam söndürme kapasitesi';

  @override
  String waterReserveVolumeLabel(Object minutes) {
    return 'Su rezerv hacmi ($minutes dk)';
  }

  @override
  String cabinetSufficientLabel(Object count, Object load, Object q) {
    return '$count dolap YETERLİ  —  söndürme $q MW ≥ yangın yükü $load MW';
  }

  @override
  String cabinetInsufficientLabel(
    Object count,
    Object load,
    Object minNeeded,
    Object q,
  ) {
    return '$count dolap YETERSİZ  —  söndürme $q MW < yangın yükü $load MW (min $minNeeded dolap gerekli)';
  }

  @override
  String get roomHeightLabel => 'Oda Yüksekliği (m)';

  @override
  String get fireClassPanel =>
      'Sınıf B/C (elektrik ekipmanı yağı / gaz) — Toz veya CO₂';

  @override
  String get fireClassGasStorage =>
      'Sınıf C (sıkıştırılmış yanıcı gaz) — KKP Toz, CO₂ veya Köpük';

  @override
  String get fireClassLiquidGasStorage =>
      'Sınıf B + Sınıf C (sıvı/gaz yakıt) — KKP ABC Toz veya Köpük';

  @override
  String get fireClassLiquidStorage =>
      'Sınıf B (yanıcı sıvı) — ABC Kuru Kimyevi Toz veya Köpük';

  @override
  String get fireClassSolidLiquidStorage =>
      'Sınıf A + Sınıf B (katı/sıvı yanıcı) — ABC Kuru Kimyevi Toz';

  @override
  String get fireClassParking => 'Sınıf B (sıvı yakıt) — ABC Toz veya Köpük';

  @override
  String get fireClassSolidDefault =>
      'Sınıf A (katı yanıcı) — ABC Kuru Kimyevi Toz veya Su';

  @override
  String get riskClassLow => 'Düşük Risk  (≤ 200 MJ/m²)';

  @override
  String get riskClassMedium => 'Orta Risk  (200–600 MJ/m²)';

  @override
  String get riskClassHigh => 'Yüksek Risk  (600–1200 MJ/m²)';

  @override
  String get riskClassVeryHigh => 'Çok Yüksek Risk  (> 1200 MJ/m²)';

  @override
  String get loginServerUnreachable =>
      'Sunucuya bağlanılamadı. İnternet bağlantınızı kontrol edin.';

  @override
  String genericErrorWithDetail(String detail) {
    return 'Hata: $detail';
  }

  @override
  String fireModuleSubscriptionMissing(String perms) {
    return 'Yangın modülü aboneliğiniz bulunmuyor. Hesabınızdan abonelik başlatın.\nSunucudan gelen perms: $perms';
  }

  @override
  String get loginFailed => 'Giriş başarısız';

  @override
  String get sessionNotFoundRelogin =>
      'Oturum bulunamadı. Lütfen yeniden giriş yapın.';

  @override
  String get accountDeleteFailed => 'Hesap silinemedi.';

  @override
  String get enterPanelInnerDimensionsCm =>
      'Pano iç ölçülerini eksiksiz giriniz (cm).';

  @override
  String get addAtLeastOneFuelTank => 'En az bir yakıt deposu ekleyiniz.';

  @override
  String enterQuantityForFuel(String name) {
    return '\"$name\" için miktar giriniz.';
  }

  @override
  String get enterValidFloorAreaM2 => 'Geçerli kat alanı giriniz (m²).';

  @override
  String materialMassMissing(String name) {
    return '\"$name\" kütlesi eksik.';
  }

  @override
  String materialNcvMissing(String name) {
    return '\"$name\" ısıl değeri eksik.';
  }

  @override
  String get calculateFireLoadFirst => 'Önce Yangın Yükü hesaplayınız.';

  @override
  String get enterValidArea => 'Geçerli alan giriniz.';

  @override
  String get enterRoomHeightM => 'Oda yüksekliğini giriniz (m).';

  @override
  String get enterHoodLengthWidthCm =>
      'Davlumbaz uzunluk ve genişliğini giriniz (cm).';

  @override
  String get enterRoomDimensionsFullyM =>
      'Oda ölçülerini eksiksiz giriniz (m).';

  @override
  String get enterNetProtectedVolumeM3 => 'Net koruma hacmini giriniz (m³).';

  @override
  String get enterValidConcentrationPercent =>
      'Geçerli bir konsantrasyon değeri giriniz (0–100%).';

  @override
  String get enterValidUnitCount1to50 => 'Geçerli ünite sayısı giriniz (1–50).';

  @override
  String get enterMachineCabinDimensionsFullyM =>
      'Makine kabini ölçülerini eksiksiz giriniz (m).';

  @override
  String get enterUnitCabinVolumeM3 => 'Ünite kabini hacmini giriniz (m³).';

  @override
  String get enterPanelCabinDimensionsFullyM =>
      'Pano/kabin ölçülerini eksiksiz giriniz (m).';

  @override
  String get enterPanelCabinVolumeM3 => 'Pano/kabin hacmini giriniz (m³).';

  @override
  String get enterRoomAreaM2 => 'Oda alanı giriniz (m²).';

  @override
  String get enterCeilingHeightM => 'Tavan yüksekliğini giriniz (m).';

  @override
  String get enterDesignHrrKw => 'Tasarım HRR giriniz (kW).';

  @override
  String get smokeLayerHeightRangeError =>
      'Duman katmanı taban yüksekliği: 0 < z < H';

  @override
  String get enterInstalledCapacityKwh => 'Kurulu kapasiteyi giriniz (kWh).';

  @override
  String get enterProtectionAreaM2 => 'Koruma alanını giriniz (m²).';

  @override
  String get enterApplicationDurationMin => 'Uygulama süresini giriniz (dk).';

  @override
  String get enterVehicleBatteryCapacityKwh =>
      'Araç batarya kapasitesini giriniz (kWh).';

  @override
  String get enterVehicleCount => 'Araç sayısını giriniz.';

  @override
  String get enterValidBuildingWidthM => 'Geçerli bina eni giriniz (m).';

  @override
  String get enterValidBuildingLengthM => 'Geçerli bina boyu giriniz (m).';

  @override
  String get selectBuildingActivity => 'Lütfen bina faaliyetini seçiniz.';

  @override
  String get enterCeilingHeightSimpleM => 'Tavan yüksekliği giriniz (m).';

  @override
  String get hoodHideComparison => 'Karşılaştırmayı Gizle';

  @override
  String get hoodCompareAgents => 'Maddeleri Karşılaştır';

  @override
  String get hoodTableAgentCol => 'Madde';

  @override
  String get hoodTableEffectivenessCol => 'Etkinlik';

  @override
  String get hoodColLowAbbr => 'D';

  @override
  String get hoodColMediumAbbr => 'O';

  @override
  String get hoodColHighAbbr => 'Y';

  @override
  String get hoodComparisonLegend =>
      'D = Düşük  ·  O = Orta  ·  Y = Yüksek tehlike sınıfı\nRenkli sütun = hesaplanan tehlike sınıfı';

  @override
  String get hoodResultTitleCaps => 'SÖNDÜRME BOYUTLANDIRMA SONUCU';

  @override
  String get hoodNfpa96RequirementsTitle => 'NFPA 96 Zorunlu Gereklilikler';

  @override
  String get hoodReqFuelElectric =>
      'Yakıt & Elektrik Kesilmesi (§10.4): Sistem devreye girdiğinde tüm ısı kaynaklarının yakıtı ve elektriği otomatik kesilmelidir. Manuel sıfırlama gerekir.';

  @override
  String get hoodReqManualPull =>
      'Manuel Çekme Kolu (§10.5): Yerden 1067–1219 mm yükseklikte, davlumbazdan min. 3 m – maks. 6 m uzaklıkta, kaçış yolu üzerinde konumlandırılmalıdır.';

  @override
  String get hoodReqAlarm =>
      'Alarm (§10.6): Sistem aktivasyonunda sesli alarm veya görsel gösterge zorunludur.';

  @override
  String get hoodReqFanMakeupAir =>
      'Fan & Takviye Hava (§8.2.3 / §8.3.2): Egzoz fanı aktivasyon sonrası çalışmaya devam eder. Hood içi takviye hava (makeup air) sistem aktivasyonunda kesilir.';

  @override
  String get hoodReqClassKExtinguisher =>
      'Sınıf K Söndürücü (§10.10.2): Bitkisel / hayvansal yağ kullanan ekipmanlar için Sınıf K yangın söndürücü zorunludur.';

  @override
  String hoodReqFilterDistance(String warning) {
    return 'Filtre Mesafesi (§6.2.1): Filtre alt kenarı – pişirme yüzeyi arası en az 457 mm (18 in.).$warning';
  }

  @override
  String get hoodFilterDistanceWarning =>
      'Charbroiler/mangal mevcut → Filtre alt kenarı ile pişirme yüzeyi arası en az 1220 mm (4 ft) (NFPA 96 §6.2.1.2)';

  @override
  String get hoodReqMaintenance =>
      'Bakım (§11.2.1): Sertifikalı teknisyen tarafından en az 6 ayda bir bakım. Ergitme bağlantıları (fusible link) 6 ayda bir değiştirilir (§11.2.4).';

  @override
  String hoodReqCleaningFrequency(String frequency) {
    return 'Temizlik Sıklığı (Tablo 11.4): $frequency.';
  }

  @override
  String get hoodCleaningFreqHighVolume =>
      '3 ayda bir (wok / charbroiler / büyük fritöz)';

  @override
  String get hoodCleaningFreqLow => 'Yıllık (düşük hacimli)';

  @override
  String get hoodCleaningFreqMedium => '6 ayda bir (orta hacimli)';

  @override
  String get hoodReqSimultaneousOperation =>
      'Eşzamanlı Çalışma (§10.3): Tek tehlike bölgesindeki tüm sabit söndürme sistemleri aynı anda devreye girmelidir.';

  @override
  String hoodReqFryerDistance(String warning) {
    return 'Fritöz Mesafesi (§12.1.2.4): Fritöz, açık alev kaynaklarından yatayda min. 406 mm (16 in.) uzakta olmalıdır. Ara plaka (baffle) kullanıldığında min. 203 mm (8 in.) yükseklik yeterlidir (§12.1.2.5).$warning';
  }

  @override
  String get hoodFryerDistanceWarning =>
      'Fritöz mevcut → Açık alev kaynaklarından yatayda min. 406 mm (16 in.) uzakta konumlandırılmalıdır (§12.1.2.4). Ara plaka (baffle) kullanılıyorsa min. 203 mm (8 in.) yükseklik yeterlidir (§12.1.2.5).';

  @override
  String get hoodReqFryerHighTempLimiter =>
      'Fritöz Yüksek Sıcaklık Sınırlayıcısı (§12.2): Derin yağda kızartma ekipmanında otomatik sıcaklık sınırlayıcı zorunludur. Yağ yüzeyinden 25,4 mm (1 in.) aşağıda 246°C (475°F) sıcaklığa ulaştığında ısı kaynağını otomatik olarak keser.';

  @override
  String get hoodReqHoodDuctClearance =>
      'Davlumbaz / Kanal Mesafeleri (§4.2.1): Yanıcı yüzeylere min. 457 mm (18 in.), sınırlı yanıcı yüzeylere min. 76 mm (3 in.), yanmaz yüzeylere 0 mm boşluk bırakılabilir.';

  @override
  String get hoodReqDuctSlope =>
      'Kanal Eğimi (§7.1.4): Yatay kanal uzunluğu ≤ 22,86 m (75 ft) ise min. %2, > 22,86 m (75 ft) ise min. %8 eğim uygulanmalıdır (gres birikiminin tahliyesi için).';

  @override
  String get hoodReqDuctFireBarrier =>
      'Kanal Yangın Bölmesi Direnci (§7.7.2.1): Kanal geçişleri için yangın bölmesi: < 4 katlı yapılar → min. 1 saatlik yangına dayanıklı bölme; ≥ 4 katlı yapılar → min. 2 saatlik yangına dayanıklı bölme.';

  @override
  String hoodNotesText(
    String agent,
    String hazardClass,
    String score,
    String area,
  ) {
    return 'NFPA 17A §7.3 — $agent uygulaması.\nTehlike sınıfı: $hazardClass  ·  Ekipman puanı: $score  ·  Min. deşarj: 30 s  ·  Filtre alanı: $area m².\nEk baca / kanallar için ek nozul hesabı yapılmalıdır.';
  }

  @override
  String get hoodAgentPotassiumCarbonateName => 'Potasyum Karbonat';

  @override
  String get hoodAgentPotassiumAcetateName => 'Potasyum Asetat';

  @override
  String get hoodAgentPotassiumCitrateName => 'Potasyum Sitrat';

  @override
  String get hoodAgentSodiumBicarbonateName => 'Sodyum Bikarbonat';

  @override
  String get hoodAgentPotassiumCarbonateDesc =>
      'En yaygın. Yağ/yüzey yangınlarına karşı etkili.';

  @override
  String get hoodAgentPotassiumAcetateDesc =>
      'Yüksek verimli. Ansul R-102, Amerex B500 sistemleri.';

  @override
  String get hoodAgentPotassiumCitrateDesc =>
      'Paslanmaz çelik ekipmanlara uyumlu. Korozyon riski düşük.';

  @override
  String get hoodAgentSodiumBicarbonateDesc =>
      'Eski nesil. Düşük maliyetli, sınırlı etkinlik.';

  @override
  String get hoodAgentPotassiumCarbonateReco =>
      'Genel amaçlı. Her tehlike sınıfı için uygundur.';

  @override
  String get hoodAgentPotassiumAcetateReco =>
      'Yüksek tehlike için birinci tercih. En iyi söndürme verimi.';

  @override
  String get hoodAgentPotassiumCitrateReco =>
      'Paslanmaz çelik mutfak / gıda endüstrisi. Düşük–Orta tehlike.';

  @override
  String get hoodAgentSodiumBicarbonateReco =>
      'Yalnızca düşük tehlike. Yüksek yağ yangınlarında yeterli değil.';

  @override
  String get hoodStdNfpa96Desc =>
      'Ticari yemek pişirme operasyonları için havalandırma kontrolü ve yangın koruması. Davlumbaz boyutlandırma, filtre mesafeleri, söndürme sistemi gereklilikleri, manuel çekme kolu, yakıt kesme, bakım ve temizlik sıklıkları.';

  @override
  String get hoodStdNfpa17aDesc =>
      'Islak kimyasal söndürme sistemleri standardı. Deşarj süresi, ajan miktarı, nozul aralıkları.';

  @override
  String get hoodStdTsEn15751Desc =>
      'Avrupa standardı — Ticari yemek pişirme ekipmanı söndürme sistemleri.';

  @override
  String get hoodStdUl300Desc =>
      'ABD — Mutfak söndürme sistemleri için ürün onay standardı (Ansul R-102, Amerex B500 vb.).';

  @override
  String get hoodStdTsEn1825Desc =>
      'Mutfak davlumbazı için gres filtre sistemleri ve yangın kapakları.';

  @override
  String get calculationResultCaps => 'HESAPLAMA SONUCU';

  @override
  String get gasInfoBoxText =>
      'TS EN 15004-1:2019 · NFPA 2001:2022\nToplam taşkın gazlı söndürme sistemi ajan miktarı ön hesap aracı.';

  @override
  String get gasNetVolumeHint =>
      'Net koruma hacmi — sabit mobilya/ekipman varsa brüt hacimden çıkarınız.';

  @override
  String get gasMinDesignTempHint =>
      'Hacimdeki minimum hava sıcaklığı — TS EN 15004-1 §A.2  (varsayılan: 20 °C)';

  @override
  String get gasClassAMaterial1 => 'PMMA (polimetilmetakrilat / pleksiglas) ';

  @override
  String get gasClassAMaterial2 => 'PP (polipropilen)';

  @override
  String get gasClassAMaterial3 => 'ABS (akrilonitril bütadien stiren) ';

  @override
  String get gasClassAMaterial4 => 'Ahşap, mobilya ve döşeme malzemeleri';

  @override
  String get gasClassAMaterial5 => 'Kağıt ve karton';

  @override
  String get gasClassAMaterial6 => 'Tekstil / kumaş';

  @override
  String get gasClassAMaterial7 => 'Kauçuk (lastik)';

  @override
  String get gasClassAMaterial8 => 'Diğer termoplastikler (PE, PS, PVC vb.)';

  @override
  String get gasClassASource =>
      'TS EN 15004-1:2019 Ek C.6.3.2 (polimerik test yakıtı levha dizisi) · ISO 14520-1 Sınıf A tanımı (genel örnekler)';

  @override
  String get gasClassADTitle =>
      'Higher Hazard Class A  —  Yüksek Tehlikeli Yangınlar';

  @override
  String get gasClassADMaterial1 =>
      'Yığın/istifli plastik depolama (raf/palet, derin yerleşik — yüzey Sınıf A\'daki tekil/açık plastik parçalardan farklıdır)';

  @override
  String get gasClassADMaterial2 => 'Yoğun kablo demetleri > 100 mm';

  @override
  String get gasClassADMaterial3 => 'Kablo tavası doluluk > %20';

  @override
  String get gasClassADMaterial4 => 'Kablo tavaları arası < 250 mm';

  @override
  String get gasClassADMaterial5 =>
      'Söndürme sırasında enerjili ekipman > 5 kW';

  @override
  String get gasClassADMaterial6 => 'Telekomünikasyon';

  @override
  String get gasClassADMaterial7 => 'Kontrol odaları';

  @override
  String get gasClassADMaterial8 => 'Elektrik/elektronik ekipman yoğun alanlar';

  @override
  String get gasClassADSource => 'TS EN 15004-1:2019 Tablo 4';

  @override
  String get gasClassBTitle =>
      'Class B  —  Sıvı ve Eriyebilir Katı Madde Yangınları';

  @override
  String get gasClassBMaterial1 => 'Benzin, dizel, fuel-oil';

  @override
  String get gasClassBMaterial2 => 'Solvent, alkol, aseton';

  @override
  String get gasClassBMaterial3 => 'Yağlı trafo';

  @override
  String get gasClassBMaterial4 => 'Boya, vernik, reçine';

  @override
  String get gasClassBMaterial5 => 'Mum, parafin gibi eriyebilir katılar';

  @override
  String get gasClassCMaterial1 => 'Elektrik panoları (lokal)';

  @override
  String get gasClassCMaterial2 => 'Motor kontrol üniteleri';

  @override
  String get gasClassCMaterial3 => 'UPS ve akü sistemleri';

  @override
  String get gasClassCMaterial4 => 'Aydınlatma ve güç dağıtım ekipmanı';

  @override
  String get gasClassCSource =>
      'Telekomünikasyon / kontrol odaları / yoğun kablo için → Sınıf A (Derin)\nISO 3941 / NFPA 2001';

  @override
  String gasStandardDefaultInfo(
    String className,
    String percent,
    String capacity,
    String unit,
  ) {
    return 'Standart varsayılan — $className: $percent%  ·  Silindir: $capacity $unit';
  }

  @override
  String get gasConcentrationHint =>
      'TS EN 15004-1 kapsamı dışı değer kullanıyorsanız düzenleyebilirsiniz. Standart değer için ajan/sınıf seçiminde otomatik güncellenir.';

  @override
  String get gasDischargeDurationHintClassB =>
      'Sınıf B: maks. 10 s  (TS EN 15004-1 §8.3)  —  boru çapı hesabı için gerekli';

  @override
  String get gasDischargeDurationHintOther =>
      'Sınıf A/A(Derin)/C: maks. 60 s  (TS EN 15004-1 §8.3)  —  boru çapı hesabı için gerekli';

  @override
  String gasNozzleFlowRange(String mm, String min, String max) {
    return '$mm mm  ($min–$max kg/s)';
  }

  @override
  String get gasNozzleHint =>
      'Nozul çapı seçilirse hesap kütle debisi bazlı yapılır; otomatik modda alan/hacim kuralı uygulanır.';

  @override
  String get gasRequiredAgentVolume => 'Gerekli Ajan Hacmi';

  @override
  String get gasSafetyMarginSuffix => '  (+%10 pay)';

  @override
  String get gasExcludingMarginLabel => 'Pay Hariç Hesap';

  @override
  String get gasDischargeRequirementsTitle =>
      'Deşarj Süresi Gereklilikleri — TS EN 15004-1:2019 §8.3 / NFPA 2001:2022 §6.7.1';

  @override
  String get gasDischargeReqInert =>
      '• Maks. deşarj süresi: ≤ 60 s  (NFPA 2001:2022 §6.7.1)\n• Min. bekleme süresi (soak): ≥ 10 dakika  (NFPA 2001:2022 §6.7.4)\n• Boru akış hızı: Tam hidrolik hesap gereklidir (TS EN 15004-1 Ek E)\n• Silindir dep. sıcaklığı: −20 °C – +54 °C  (NFPA 2001:2022 §4.4.1)';

  @override
  String get gasDischargeReqCo2 =>
      '• Maks. deşarj süresi: ≤ 60 s  (TS EN 15004-2 §8.3 / NFPA 12 §5.4.1)\n• Min. bekleme süresi (soak): ≥ 20 dakika\n• YALNIZCA insan bulunmayan hacimler — tahliye zorunludur';

  @override
  String get gasMaxDischargeClassB => '10 s  (Sınıf B)';

  @override
  String get gasMaxDischargeClassOther => '60 s  (Sınıf A/C)';

  @override
  String gasDischargeReqFm200(String maxDischarge) {
    return '• Maks. deşarj süresi: ≤ $maxDischarge  (EN 15004-5:2020 §8.3 / NFPA 2001:2022 §6.7.1)\n• Min. bekleme süresi (soak): ≥ 10 dakika  (NFPA 2001:2022 §6.7.4)\n• Silindir depolama sıcaklığı: −20 °C – +54 °C\n• Özgül hacim: S = 0,1269 + 0,000513×T m³/kg  (EN 15004-5 §6.3 Tablo 3)';
  }

  @override
  String gasDischargeReqDefault(String maxDischarge) {
    return '• Maks. deşarj süresi: ≤ $maxDischarge  (TS EN 15004-1:2019 §8.3 / NFPA 2001:2022 §6.7.1)\n• Min. bekleme süresi (soak): ≥ 10 dakika  (NFPA 2001:2022 §6.7.4)\n• Silindir depolama sıcaklığı: −20 °C – +54 °C  (NFPA 2001:2022 §4.4.1)';
  }

  @override
  String get gasIg01SpecsTitle =>
      'IG-01 Silindir Özellikleri  —  TS EN 15004-7:2009 §6.1';

  @override
  String get gasTablePropertyHeader => 'Özellik';

  @override
  String get gasFillPressureLabel => 'Doldurma basıncı @15°C (bar)';

  @override
  String get gasMaxOperatingPressureLabel =>
      'Maks. çalışma basıncı @50°C (bar)';

  @override
  String get gasOverpressurizationLabel => 'Aşırı basınçlandırma';

  @override
  String get gasNotApplicable => 'Uygulanmaz';

  @override
  String get gasIg01Note =>
      'IG-01 tanklar aşırı basınçlandırılmaz (TS EN 15004-7 §6.2). Tasarım sıcaklığında S = 0,56119 + 0,002055×T m³/kg formülü kullanılır.';

  @override
  String get gasFm200SpecsTitle =>
      'HFC-227ea Silindir Özellikleri  —  EN 15004-5:2020 §6.1';

  @override
  String get gasMaxFillDensityLabel => 'Maks. dolum yoğunluğu (kg/m³)';

  @override
  String get gasN2FillingPressureLabel => 'N₂ şişeleme basıncı @21°C (bar)';

  @override
  String get gasFm200Note =>
      'Maks. dolum yoğunluğu aşılması durumunda küçük sıcaklık artışlarında çok yüksek basınç oluşur; silindir bütünlüğü tehlikeye girer. (EN 15004-5:2020 §6.1)';

  @override
  String get gasNfpa2001RequirementsTitle =>
      'NFPA 2001:2022 Zorunlu Gereklilikler';

  @override
  String get gasReqPreDischargeAlarm =>
      '§6.6.1 — Ön Deşarj Alarmı: Dolu alanlarda ajan devreye girmeden önce sesli/ışıklı uyarı verilmeli; tahliye için yeterli süre tanınmalıdır.';

  @override
  String get gasReqAbortSwitch =>
      '§6.6.6 — Abort Anahtarı: Dolu alanlarda el ile iptal (abort) düğmesi zorunludur; sistemi en az 30 saniye geciktirir.';

  @override
  String get gasReqVolumeIntegrity =>
      '§6.5.4 — Koruma Hacmi Bütünlüğü: Hacim, soak süresi boyunca tasarım konsantrasyonunu koruyacak sızdırmazlığa sahip olmalıdır. Kapı fan testi (door fan test) tavsiye edilir.';

  @override
  String get gasReqCylinderStorage =>
      '§4.4.1 — Silindir Depolama: −20 °C ile +54 °C arasında muhafaza; dolum basıncı üretici listesine uygun olmalıdır.';

  @override
  String get gasReqPostDischargeVentilation =>
      '§6.9 — Deşarj Sonrası Havalandırma: Ortama girişten önce O₂ seviyesi ≥ %19,5\'e ulaşana dek zorlamalı havalandırma yapılmalıdır.';

  @override
  String get gasReqInterlockedSystems =>
      '§6.1.2 — Bağlantılı Sistemler: Deşarj anında HVAC ve tüm hava sağlayan damperler otomatik kapanmalıdır.';

  @override
  String gasReqSafetyMargin(String status) {
    return '§5.4.1.3 — Güvenlik Payı: Min. %10 güvenlik payı zorunludur; bu hesapta $status';
  }

  @override
  String get gasSafetyMarginApplied => 'uygulandı.';

  @override
  String get gasSafetyMarginNotApplied => '⚠ uygulanmadı!';

  @override
  String get gasReqPeriodicInspection =>
      '§7.2.2 — Periyodik Muayene: Silindirler yılda bir ağırlık/basınç ile kontrol edilmeli; halokarbon dolum miktarı çiçek valf ölçümü ile doğrulanmalıdır.';

  @override
  String get gasMainPipeSizeTitle => 'Boru Çapı — Ana Hat';

  @override
  String get gasMinInnerDiameterLabel => 'Min. iç çap';

  @override
  String get gasStandardDnLabel => 'Standart DN';

  @override
  String get gasDnOver150 => 'DN > 150';

  @override
  String gasVolumetricFlowLabel(String ls, String m3s) {
    return 'Hacimsel debi (Q): $ls L/s  ($m3s m³/s)';
  }

  @override
  String gasPipeActualSpeedLabel(String dn, String speed, String status) {
    return 'DN $dn için gerçek hız: $speed m/s$status';
  }

  @override
  String get gasSpeedOkSuffix => ' ✓';

  @override
  String get gasSpeedOverLimitSuffix => '  ? 30 m/s üstünde';

  @override
  String get gasMainPipeSizingNote =>
      'Ana hat ön boyutlandırmadır — Q = gaz miktarı ÷ boşalma süresi. Dağıtım boruları ve nozul hatları ayrıca hesaplanmalıdır. Kesin tasarım için TS EN 15004-1 Ek E akış hesabı yapınız.';

  @override
  String get gasNozzleDistributionTitle => 'Nozul & Dağıtım Borusu';

  @override
  String get gasNozzleCountLabel => 'Nozul Sayısı';

  @override
  String gasNozzleAltMassBased(String mm) {
    return '$mm mm nozul\n(kütle debisi bazlı)';
  }

  @override
  String get gasNozzleAltAreaBased => 'maks. 50 m²/nozul\n(alan bazlı)';

  @override
  String get gasNozzleAltVolumeBased =>
      'maks. 150 m³/nozul\n(hacim bazlı — tahmini)';

  @override
  String get gasBranchPipeLabel => 'Şube Boru';

  @override
  String gasBranchMinInnerDiameter(String mm) {
    return 'min. iç çap:\n$mm mm';
  }

  @override
  String gasFlowPerNozzleLabel(
    String flow,
    String min,
    String max,
    String status,
  ) {
    return 'Nozul başına: $flow kg/s  (izin verilen: $min–$max kg/s)  $status';
  }

  @override
  String get gasFlowOk => '✓';

  @override
  String get gasFlowOutOfRange => '⚠ Aralık dışı — farklı çap seçin';

  @override
  String gasBranchSpeedLabel(String speed, String ls, String status) {
    return 'Şube hız: $speed m/s  (nozul başına Q: $ls L/s)$status';
  }

  @override
  String get gasBranchSpeedWarning => '  ⚠ 30 m/s üstünde!';

  @override
  String get gasBranchSpeedOk => '  ✓';

  @override
  String gasEstimatedPipeLengthLabel(String m) {
    return 'Tahmini boru metrajı: ≈ $m m (ana hat + dağıtım + nozul düşeyleri)';
  }

  @override
  String get gasNozzlePlacementNote =>
      'Nozul yerleşimi: TS EN 15004-1 / NFPA 2001 üretici listesi şartlarına uygun olarak tavan düzeyine, eşit aralıklı konumlandırılmalıdır.\nBoru metrajı tahminidir — gerçek proje metrajı mekan planına göre değişir.';

  @override
  String get gasSourceFooter =>
      'Kaynak: TS EN 15004-1:2019 · NFPA 2001:2022 · NFPA 12:2022';

  @override
  String get baskiOffsetName => 'Ofset Baskı';

  @override
  String get baskiFlexoName => 'Flexo Baskı';

  @override
  String get baskiGravureName => 'Gravür / Rotogravür';

  @override
  String get baskiUvOffsetName => 'UV Ofset / UV Flex';

  @override
  String get baskiDigitalName => 'Dijital (Inkjet/Toner)';

  @override
  String get baskiPadName => 'Şilte / Tampon Baskı';

  @override
  String get baskiOffsetDesc => 'Islak ofset — IPA/alkol bazlı çözücü';

  @override
  String get baskiFlexoDesc => 'Solvent veya su bazlı mürekkep';

  @override
  String get baskiGravureDesc =>
      'Toluen/etil asetat bazlı — yüksek solvent riski';

  @override
  String get baskiUvOffsetDesc => 'UV kürleme — fotoinitiator bazlı';

  @override
  String get baskiDigitalDesc => 'Sıvı mürekkep veya toner — düşük solvent';

  @override
  String get baskiPadDesc => 'Solvent bazlı mürekkep — kapalı kap';

  @override
  String get baskiIpaName => 'IPA (İzopropil Alkol)';

  @override
  String get baskiIpaDesc => 'Ofset baskı çeşme solüsyonu — patlama riski';

  @override
  String get baskiTolueneName => 'Toluen';

  @override
  String get baskiTolueneDesc => 'Gravür baskı — yüksek risk, GWP 0';

  @override
  String get baskiEthylAcetateName => 'Etil Asetat';

  @override
  String get baskiEthylAcetateDesc => 'Flexo/gravür — düşük tutuşma noktası';

  @override
  String get baskiMethanolName => 'Metanol';

  @override
  String get baskiMethanolDesc => 'Ağaç işleme ve özel uygulamalar';

  @override
  String get baskiNPropylName => 'n-Propil Alkol';

  @override
  String get baskiNPropylDesc => 'UV ofset ek solvent';

  @override
  String get baskiSolventMixName => 'Solvent Karışımı (genel)';

  @override
  String get baskiSolventMixDesc => 'Üretici veri sayfasına göre belirleyin';

  @override
  String get baskiWaterBasedInkName => 'Su Bazlı Mürekkep';

  @override
  String get baskiWaterBasedInkDesc =>
      'Yanıcı solvent yok — Sınıf A uygulaması';

  @override
  String get baskiInfoBoxText =>
      'NFPA 34:2024 §10.6 · NFPA 2001:2022 · NFPA 12:2022 · TS EN 15004-1:2019\nMatbaa / baskı makinesi kabini gazlı söndürme ön hesap aracı.';

  @override
  String baskiIgnitionPointLabel(String temp, String desc) {
    return 'Tutuşma noktası: $temp °C  ·  $desc';
  }

  @override
  String get baskiUnitCountHint =>
      'Aynı hacimdeki her ünite için ayrı silindir hesaplanır. Farklı hacimliyse birden fazla hesap yapınız.';

  @override
  String get baskiLengthDepthLabel => 'Uzunluk / Derinlik';

  @override
  String get baskiCabinetDimensionsHint =>
      'Bir ünite kabininin iç boyutları — brüt değil, net iç hacim.';

  @override
  String get baskiUnitNetVolumeLabel => 'Ünite Kabini Net Hacmi';

  @override
  String get baskiMinTempHint =>
      'Makine kabin içi minimum sıcaklık — TS EN 15004-1 §A.2 (varsayılan: 20 °C)';

  @override
  String get baskiLocalApplicationLabel =>
      'Lokal Uygulama +%30 (NFPA 2001 §6.4) — Açık makine kabinleri için';

  @override
  String get baskiDischargeModeTitle => 'Tahliye Şekli (Birden Fazla Ünite)';

  @override
  String get baskiSimultaneousLabel => 'Eşzamanlı (Toplam)';

  @override
  String get baskiSelectiveValveLabel => 'Seçici Vana (Bağımsız)';

  @override
  String get baskiSimultaneousHint =>
      'Tüm üniteler ortak alanda ve tek seferde tahliye olacaksa seçin — ana besleme = tüm ünitelerin toplam ihtiyacı.';

  @override
  String get baskiSelectiveValveHint =>
      'Her ünite bağımsız algılama + seçici vana ile korunuyorsa seçin — ana besleme yalnızca tek ünite ihtiyacına göre boyutlandırılır (NFPA 2001 §7.5.2 / NFPA 12 §4.3.4.2).';

  @override
  String get baskiBackupSupplyLabel =>
      'Yedek (%100) Besleme Grubu (NFPA 12 §4.5.3) — normal işgal edilen alanlar için önerilir';

  @override
  String get baskiClassAPlain => 'Sınıf A';

  @override
  String baskiClassSummaryLabel(String cls, String value, String noael) {
    return 'Yangın sınıfı: $cls  ·  Standart min.: $value %  ·  NOAEL: $noael';
  }

  @override
  String get baskiDischargeHint =>
      'Sınıf B makineler: maks. 10 s  ·  Sınıf A makineler: maks. 60 s  (TS EN 15004-1 §8.3)';

  @override
  String get baskiMainSupplySimultaneous =>
      'Ana Besleme İhtiyacı (eşzamanlı — toplam)';

  @override
  String get baskiMainSupplySelective =>
      'Ana Besleme İhtiyacı (seçici vana — tek ünite)';

  @override
  String baskiMainSupplyCylinderCount(String capacity, String unit) {
    return 'Ana Besleme Silindir Sayısı ($capacity $unit/silindir)';
  }

  @override
  String get baskiSelectiveValveInfo =>
      'Seçici vana tasarımı: her ünite kabini bağımsız algılama devresine sahip olmalı; yalnızca yangın algılanan ünitenin vanası açılır. Ana besleme tek ünite ihtiyacına göre boyutlandırılmıştır — birden fazla ünitede eşzamanlı yangın riski varsa \"Eşzamanlı\" seçilmelidir (NFPA 2001 §7.5.2 / NFPA 12 §4.3.4.2).';

  @override
  String get baskiLocalApplicationInfo =>
      'Lokal uygulama +%30 faktörü uygulandı (NFPA 2001 §6.4).\nAçık makinelerde veya tam kapalı olmayan kabinlerde uygulanır.';

  @override
  String get baskiApplicationNotesTitle => 'Uygulama Notları';

  @override
  String baskiAppNotesBody(String ignitionNote) {
    return '• Her baskı ünitesi kabini ayrı ayrı korunmalıdır.\n• Makine içi nozul yerleşimi üretici onayına tabidir.\n• Deşarj öncesi mürekkep/solvent kaynağı otomatik kesilmelidir.\n• $ignitionNote\n• Silindir sayısı, seçilen tahliye şekli (eşzamanlı/seçici vana) ve yedek besleme kararına göre değişir — üretici tipine göre kesinleştirilmelidir.';
  }

  @override
  String get baskiIgnitionNoteAtex =>
      'Tutuşma noktası < 23 °C — ATEX bölgesi değerlendirmesi zorunludur.';

  @override
  String get baskiIgnitionNoteExplosionRisk =>
      'Solvent tipi için patlama riski analizi yapılmalıdır.';

  @override
  String get baskiSourceFooter =>
      'Kaynak: NFPA 34:2024 §10 · NFPA 2001:2022 · NFPA 12:2022 · TS EN 15004-1:2019 · EN 1010-2';

  @override
  String get panoAgentGroupClean =>
      'Temiz Gaz (FK-5-1-12(Novec 1230)/HFC-227ea)';

  @override
  String get panoAgentGroupCo2 => 'CO₂ (Karbondioksit)';

  @override
  String get panoDlpName => 'DLP — Doğrudan Düşük Basınç';

  @override
  String get panoIlpName => 'ILP — Dolaylı Düşük Basınç';

  @override
  String get panoDhpName => 'DHP — Doğrudan Yüksek Basınç (CO₂)';

  @override
  String get panoIhpName => 'IHP — Dolaylı Yüksek Basınç (CO₂)';

  @override
  String get panoDlpDesarjNotu =>
      'Tubing hattı hem algılama hem doğrudan boşaltma görevi görür — hesap gerektirmez.';

  @override
  String get panoIlpDesarjNotu =>
      'Tubing algılama yapar; boşaltma ayrı nozul(lar) üzerinden gerçekleşir.';

  @override
  String get panoDhpDesarjNotu =>
      'Sabit deşarj süresi ≈ 60 sn @ 60 bar — kullanıcı girdisi gerekmez.';

  @override
  String get panoIhpDesarjNotu =>
      'Deşarj süresi standarda göre sabittir; üretici onaylı tabloya bakınız.';

  @override
  String get panoDlpAciklama =>
      'En yaygın kullanılan pano içi söndürme tipidir. Kırmızı algılama tubingi doğrudan söndürme hattı olarak işlev görür; ek boru hattına ve nozula gerek yoktur. Tubing yangın noktasında patladığında ajan o noktadan boşalır. Hidrolik akış hesabı gerektirmeyen pre-engineered bir sistemdir.';

  @override
  String get panoIlpAciklama =>
      'Algılama tubingi yalnızca tetikleyici işlev görür; söndürücü ajan paslanmaz çelik boru hattı ve nozullar aracılığıyla panoya boşaltılır. Çok bölmeli ve büyük hacimli panolarda nozullar stratejik noktalara yerleştirilerek homojen söndürme konsantrasyonu sağlanır. Manuel boşaltma butonu bulunur; panonun tam sızdırmaz olması zorunludur.';

  @override
  String get panoDhpAciklama =>
      'CO₂ ajanı kullanan ve algılama tubinginin hem dedektör hem de boşaltma hattı olarak işlev gördüğü sistemdir. CO₂ yüksek basınçta depolandığından tubing uzunluğu ve maksimum hacim açısından DLP\'ye göre avantajlıdır. Nozul deliği açılması istenmeyen ve DLP\'ye göre daha büyük havalandırma açıklığına sahip panolarda tercih edilir.';

  @override
  String get panoIhpAciklama =>
      'CO₂ kullanılan en kapsamlı pano içi söndürme çözümüdür. Büyük hacimli, birden fazla bölmesi olan ve bölmeler arası geçişlerin bulunduğu panolarda tercih edilir. Paslanmaz çelik boru hattı, esnek bağlantı hortumları ve nozullardan oluşan dağıtım sistemi ile geniş alanlarda homojen söndürme sağlanır.';

  @override
  String get panoInfoBoxText =>
      'LPS 1666 · UL 2166 / FM 5600 · VdS 2093\nElektrik/telekom pano ve kabinleri için önceden mühendislik hesabı yapılmış (pre-engineered) pnömatik tubing söndürme sistemi tipi öneri aracı — hidrolik hesap değildir.';

  @override
  String get panoNoOpeningLabel =>
      'Kapatılamayan açıklık yok (kablo geçişi, havalandırma vb. sızdırmaz)';

  @override
  String get panoOpeningWarning =>
      'Kapatılamayan açıklık varsa ajan tutulamaz ve sistem etkisiz kalabilir. Açıklıklar kapatılmalı veya devreye girişte havalandırma/damper otomatik olarak kesilmelidir.';

  @override
  String get panoTubingLengthLabel =>
      'İhtiyaç Duyulan Tubing Uzunluğu (opsiyonel)';

  @override
  String get panoRecommendedSystemCaps => 'ÖNERİLEN SİSTEM';

  @override
  String panoVolumeExceededWarning(String detail, String roomTab) {
    return 'Hacim, pre-engineered pano içi sistem sınırlarını aşıyor ($detail). Bu hacim için mühendislik hesaplı toplam taşkın sistemi gereklidir — \"$roomTab\" sekmesini kullanınız.';
  }

  @override
  String panoIlpMaxVolume(String v) {
    return 'ILP maks. $v m³';
  }

  @override
  String panoIhpMaxVolume(String v) {
    return 'IHP maks. $v m³';
  }

  @override
  String panoAgentAmountNote(String percent) {
    return 'Bu miktar, %$percent tasarım konsantrasyonu ve 20°C referans alınarak yapılan bir yaklaşık hesaptır. Kesin silindir dolum miktarı üretici onaylı pre-engineered sistem tablosundan seçilmelidir.';
  }

  @override
  String panoTubingExceededWarning(String len, String kod, String max) {
    return 'Girilen tubing uzunluğu ($len m), $kod sisteminin $max m sınırını aşıyor. Bir üst sistem tipine geçilmeli veya birden fazla bağımsız sistem kullanılmalıdır.';
  }

  @override
  String get panoSealingWarning =>
      'ILP sistemi tam sızdırmaz kabin gerektirir (UL/FM test şartı). İşaretli kapatılamayan açıklık nedeniyle bu sistem güvenilir değildir — panoyu sızdırmaz hâle getiriniz ya da CO₂ ajan grubuna (DHP/IHP, sızdırmazlık gerekmez) geçiniz.';

  @override
  String get panoCo2ToxicityWarning =>
      'CO₂ toksiktir: pano çevresinde sürekli insan bulunmamalıdır. Komşu/bitişik alanlara sızıntı riski varsa %5 LOAEL sınırı gözetilmeli, gerekirse tahliye ve havalandırma planlanmalıdır.';

  @override
  String get panoNoSealingRequiredNote =>
      'Sızdırmazlık şart değildir ancak kapatılamayan açıklık miktarı üreticiye bildirilmeli; VdS 2093 hesabında ek ajan miktarı olarak dikkate alınmalıdır.';

  @override
  String get panoDesignRequirementsTitle => 'Tasarım Gereklilikleri';

  @override
  String panoManualReleaseNote(String kod) {
    return '• Manuel boşaltma butonu: $kod sistemlerinde tubing hattı ayrı olduğundan, otomatik tetiklemeye ek olarak acil manuel boşaltma butonu bulunmalıdır.\n';
  }

  @override
  String get panoDesignRequirementsBody =>
      '• Alarm entegrasyonu: sistem aktivasyonunda sesli/ışıklı ön deşarj alarmı ve bina yangın alarm paneline sinyal aktarımı sağlanmalıdır.\n• Silindir seti CE/TPED (Taşınabilir Basınçlı Ekipman Yönetmeliği) uygunluğuna sahip olmalıdır.\n• Satın alma öncesi bağımsız sistem sertifikası (LPCB/UL/FM/VdS) aranmalı; sadece bileşen (silindir, nozul) sertifikası yeterli değildir. Kurulum yetkili/onaylı partner tarafından yapılmalıdır.';

  @override
  String get panoMaintenanceScheduleTitle => 'Bakım Takvimi';

  @override
  String get panoMaintenanceScheduleBody =>
      '• Aylık: görsel kontrol (basınç göstergesi, tubing hasarı/korozyonu).\n• 6 ayda bir: basınç anahtarı, conta ve bağlantı kontrolü.\n• 5 yılda bir: silindir hidrostatik testi.\n• 10 yılda bir: sistem revizyonu / bileşen ömür sonu değerlendirmesi.\n• Her dolumda üretici dolum sertifikası alınmalı; sistem devre dışıysa (impaired) en kısa sürede (üretici/otorite talimatına göre azami 48 saat) devreye alınmalı veya yangın gözcüsü tahsis edilmelidir.';

  @override
  String get panoSourceFooter =>
      'Kaynak: LPS 1666 · UL 2166 · FM 5600 · VdS 2093';

  @override
  String get gasAltitudeFieldLabel => 'Rakım';

  @override
  String get gasNoaelCo2Warning =>
      '⚠ CO² yüksek konsantrasyonlarda hayati tehlike oluşturur. Yalnızca insan bulunmayan hacimler için kullanılmalıdır. TS EN 15004-2 / NFPA 12.';

  @override
  String gasNoaelLoaelExceeded(String percent, String loael) {
    return '⚠ Tasarım konsantrasyonu ($percent%) LOAEL sınırını ($loael%) ASIYOR — tahliye zorunludur, yüksek risk!  (NFPA 2001:2022 Tablo 5.6.2.1)';
  }

  @override
  String gasNoaelReached(String percent, String noael) {
    return '⚠ Tasarım konsantrasyonu ($percent%) NOAEL sınırına ($noael%) ulaşıyor veya aşıyor — kullanım öncesi tahliye şarttır.  (NFPA 2001:2022 Tablo 5.6.2.1)';
  }

  @override
  String gasNoaelOk(String percent, String noael, String loael) {
    return '✓ Tasarım konsantrasyonu ($percent%) NOAEL ($noael%) altında. NFPA 2001:2022 kapsamında insan varlığında kullanılabilir.  LOAEL: $loael%';
  }

  @override
  String get gasAgentHfc227Desc =>
      'Sıvılaşmış halokarbon. 25/42/50 bar N₂ şişeleme. Maks. dolum yoğunluğu 1150 kg/m³. Elektrik/elektronik odalar için idealdir. (EN 15004-5 Tablo 6-8)';

  @override
  String get gasAgentFk512Desc =>
      'Düşük GWP. Hassas ekipman odaları, arşivler, müzeler.';

  @override
  String get gasAgentCo2Desc =>
      'Toplam taşkın — YALNIZCA insan bulunmayan hacimler. Sınıf B konsantrasyonu yakıta özel: heptan %34, toluen/benzen %37, etil asetat %38, MEK %40, IPA/etanol/metanol %53 (NFPA 12 Tablo A.5.3.2.1).';

  @override
  String get gasAgentIg541Desc =>
      'N²/Ar/CO² (52/40/8) karışımı. Oksijen seyreltme. İnsan varlığında kullanılabilir.';

  @override
  String get gasAgentIg55Desc =>
      'N²/Ar (50/50) karışımı. Çevre dostu. İnsan varlığında kullanılabilir.';

  @override
  String get gasAgentIg100Desc =>
      'Saf azot. Oksijen seyreltme. Kolay temin edilebilir.';

  @override
  String get gasAgentIg01Desc =>
      'Saf argon. Oksijen seyreltme ile söndürme. 160 / 200 / 300 bar şişeleme. Kimyasal kalıntı bırakmaz. İnsan varlığında kullanılabilir. (TS EN 15004-7 Çizelge 6-8)';

  @override
  String get wallMaterialConcrete => 'Beton / Kagir';

  @override
  String get wallMaterialLightBlock => 'Hafif Beton Blok';

  @override
  String get wallMaterialGypsum => 'Alçıpan (Çift)';

  @override
  String smokeLayerHeightError(String height) {
    return 'Hata: z ≥ H — duman katmanı oluşamaz. z < $height m olmalı.';
  }

  @override
  String smokeLayerLowWarning(String z, String d) {
    return 'Uyarı: z = $z m < 2.5 m — tahliye güvenliği yetersiz.  d (duman derinliği) = $d m';
  }

  @override
  String smokeLayerDepthInfo(String z, String d, String height) {
    return 'z = $z m  →  d (duman derinliği) = $d m  (H − z = $height − $z)';
  }

  @override
  String get smokeNoteNaturalPlume =>
      'Plume: Yangın üzerine yükselen sıcak gaz/duman sütunu. Kütle debisi (Thomas formülü, EN 12101-2 Ek B): ṁₚ = 0.071×Qc¹³×z⁵³ + 0.0018×Qc';

  @override
  String get smokeNoteNaturalCd => 'Cd = 0.5 (çatı menfezi, EN 12101-2 §6.4)';

  @override
  String get smokeNoteNaturalFreshAir =>
      'Taze hava girişi alt bölgeden; açıklıklar eşit dağıtılmalı';

  @override
  String get smokeNoteMinimumAreaCaveat =>
      'Hesap minimum alandır; sektörleme ve güvenlik payı ayrıca eklenmeli';

  @override
  String get smokeNoteResponsibilityNatural =>
      'Sorumluluk: Bu hesap gerçekleştirilen ön tasarım amaçlıdır. Kesin tasarım yetkili yangın mühendisi tarafından onaylanmalıdır.';

  @override
  String get smokeNoteMechanicalPlume =>
      'Plume: Yangın üzerine yükselen sıcak gaz/duman sütunu. Fan kapasitesi plume debisini karşılayacak büyüklükte seçilir.';

  @override
  String get smokeNoteMinAirChange =>
      'Min. hava değişimi ≥ 10/h (EN 12101-3 §5.2)';

  @override
  String get smokeNoteFanTempRating =>
      'Fan sıcaklık dayanımı ≥ 400 °C / 120 dk (F400) — EN 12101-3';

  @override
  String get smokeNoteFreshAirPercent =>
      'Taze hava girişi duman tahliye debisinin en az %70\'i olmalı';

  @override
  String get smokeNoteResponsibility =>
      'Sorumluluk: Bu hesap ön tasarım amaçlıdır. Kesin tasarım yetkili yangın mühendisi tarafından onaylanmalıdır.';

  @override
  String get smokeNoteDoorFlowExplain =>
      'Açık kapı geçiş debisi: tahliye sırasında bir kat kapısı açıkken merdivenden akan hava — fanın karşılaması gereken en büyük ani yük';

  @override
  String get smokeNoteDoorFlowFormula =>
      'Hesap: Q = A_kapı × √(2ΔP/ρ)  — kapı tam açık, tam ΔP geçerli kabulü (güvenli taraf)';

  @override
  String get smokeNoteWallLeakageConcrete =>
      'Duvar sızıntısı: beton/kagir şaft için 1.3×10⁻⁴ m²/m²  (EN 12101-6 Ek F Tablo F.1)';

  @override
  String get smokeNoteDoorGapCd =>
      'Kapı aralık genişliği 10 mm, Cd = 0.83  (EN 12101-6 Ek F)';

  @override
  String get smokeNoteDoorForceCheck =>
      'Açık kapı koşulunda kapı itme kuvveti ≤ 100 N kontrol edilmeli';

  @override
  String get smokeNotePressureLimit =>
      'ΔP sınır: ≥ 50 Pa (yangın katında) / ≤ 60 Pa (diğer katlar)';

  @override
  String get fanCriterionMinAirChange => 'min. hava değişimi kriteri';

  @override
  String get fanCriterionPlumeFlow => 'plume debisi kriteri';

  @override
  String get spFormulaInfo =>
      'EN 12845 / TS EN 12845 — Sabit Söndürücü Sistemler · Otomatik Sprinkler\nTehlike sınıfına göre kritik devre hidrolik hesabı  ·  Hazen–Williams (seçilebilir boru malzemesi C katsayısı)';

  @override
  String get spFieldWidthM => 'En  (m)';

  @override
  String get spFieldLengthM => 'Boy  (m)';

  @override
  String get spFieldCeilingM => 'Tavan  (m)';

  @override
  String get spSuspendedCeilingCheckbox => 'Asma tavan mevcut (gizli boşluk)';

  @override
  String get spVoidDepthLabel => 'Boşluk Derinliği  (cm)';

  @override
  String get spVoidDepthInfo =>
      'EN 12845 Md. 5.4: Boşluk derinliği > 80 cm ise gizli boşluğa ek sprinkler sistemi kurulması gerekir.';

  @override
  String get spBuildingActivityFieldLabel => 'Bina Faaliyeti';

  @override
  String get spSelectActivityPlaceholder => 'Faaliyeti seçiniz…';

  @override
  String spHazardClassInline(String name) {
    return 'Tehlike Sınıfı: $name';
  }

  @override
  String spHazardClassDetail(String density, String area, String coverage) {
    return 'Yoğunluk: $density mm/min  ·  Tasarım alanı: $area m²  ·  Maks. kapsama: $coverage m²/sprinkler';
  }

  @override
  String get spSprinklerTypeLabel => 'Sprinkler Tipi (K-Faktör)';

  @override
  String get spInstallationClassLabel => 'Kurulum Sınıfı / Pompa Yedekliliği';

  @override
  String get spDryPipeCheckbox => 'Kuru borulu sistem (donma riskli alan)';

  @override
  String get spDryPipeInfo =>
      'Kuru borulu sistemlerde şebekeye hava/nitrojen basılır ve tetikleme (trip) süresi, kompresör kapasitesi ve boru eğimi (drenaj) ayrıca tasarlanmalıdır. Donma riski olmayan alanlarda ıslak sistem tercih edilmelidir.';

  @override
  String get spRackStorageCheckbox =>
      'Raf / palet depolama — In-Rack sprinkler (ön tasarım)';

  @override
  String get spRackLevelsLabel => 'Raf Kat Sayısı (in-rack seviyesi)';

  @override
  String get spUnitLevel => 'kat';

  @override
  String get spRackInfo =>
      'Bu yalnızca ön fikir amaçlı basitleştirilmiş bir tahmindir. Kesin in-rack sprinkler sayısı, flue space (boşluk) genişliği ve kat aralığı EN 12845 Ek H kapsamında tam tasarımla belirlenmelidir.';

  @override
  String get spFoamSystemCheckbox => 'Köpük söndürme sistemi ekle (EN 13565-2)';

  @override
  String get spHydrocarbonSub => 'Benzin, motorin,\nakaryakıt, yağ';

  @override
  String get spPolarSolventSub => 'Aseton, etanol,\nsolvent, keton';

  @override
  String spFoamDurationMin(String minutes) {
    return '$minutes dk';
  }

  @override
  String get spFoamPolarSolventInfo =>
      'EN 13565-2: Polar solventler için yalnızca AR-AFFF, FFFP veya MF-FFF konsantresi kullanılır. Koruma alanı olarak bina alanı (en × boy) baz alınır.';

  @override
  String get spHHP4Warning =>
      '⚠  HHP4 — YOĞUN SU SİSTEMİ\nEN 12845 Çizelge 3 Notu: Bu sınıf standart sprinkler kapsamı dışındadır. Özel değerlendirme ve yetkili mühendis onayı zorunludur. Aşağıdaki hesap yalnızca ön fikir vermek amacıyla yapılmıştır; resmi tasarım olarak kullanılamaz.';

  @override
  String get spActivityDialogTitle => 'Faaliyet Alanı Seç';

  @override
  String get spNoResultsFound => 'Sonuç bulunamadı';

  @override
  String spKFactorWarning(String selected, String sinifKod, String minK) {
    return 'Seçilen K-Faktör (K$selected), $sinifKod sınıfının gerektirdiği minimum K$minK değerinin altındadır — üretici onayı ve tam hidrolik hesap doğrulaması zorunludur.';
  }

  @override
  String get spCeilingWarningLH =>
      'LH — Tavan yüksekliği > 6 m: Standart sprinkler performansı yetersiz kalabilir. ESFR veya yüksek hacim tipi özel tasarım önerilir.';

  @override
  String get spCeilingWarningOH =>
      'OH — Tavan yüksekliği > 6 m: Standart sprinkler etkinliği düşebilir. Tasarım öncesinde yetkili merciyle görüşülmesi tavsiye edilir.';

  @override
  String get spCeilingWarningHH =>
      'HHP/HHS — Tavan yüksekliği > 6 m: §7.2.2.3 kapsamında boşluk > 4 m ise yoğunluk artırımı (her ilave metre için +1 mm/dk) ve min. K115 sprinkler gereklidir.';

  @override
  String get spSinifAdLH => 'Düşük Tehlike (LH)';

  @override
  String get spSinifAdOH1 => 'Orta Tehlike Grup 1 (OH1)';

  @override
  String get spSinifAdOH2 => 'Orta Tehlike Grup 2 (OH2)';

  @override
  String get spSinifAdOH3 => 'Orta Tehlike Grup 3 (OH3)';

  @override
  String get spSinifAdOH4 => 'Orta Tehlike Grup 4 (OH4)';

  @override
  String get spSinifAdHHP1 => 'Yüksek Tehlike Püskürtme Grup 1 (HHP1)';

  @override
  String get spSinifAdHHP2 => 'Yüksek Tehlike Püskürtme Grup 2 (HHP2)';

  @override
  String get spSinifAdHHP3 => 'Yüksek Tehlike Püskürtme Grup 3 (HHP3)';

  @override
  String get spSinifAdHHP4 =>
      'Yüksek Tehlike Püskürtme Grup 4 (HHP4) — ⚠ Yoğun Su / Özel Sistem';

  @override
  String get spSinifAdSF1 => 'Depolama Kat. I — Serbest Döşeme (≤ 3 m)';

  @override
  String get spSinifAdSF2 => 'Depolama Kat. II — Serbest Döşeme (≤ 3,5 m)';

  @override
  String get spSinifAdSF3 => 'Depolama Kat. III — Serbest Döşeme (≤ 3,5 m)';

  @override
  String get spSinifAdSF4 => 'Depolama Kat. IV — Serbest Döşeme (≤ 3,5 m)';

  @override
  String get spSinifAdRS1 => 'Depolama Kat. I — Raf / Palet Depolama';

  @override
  String get spSinifAdRS2 => 'Depolama Kat. II — Raf / Palet Depolama';

  @override
  String get spSinifAdRS3 => 'Depolama Kat. III — Raf / Palet Depolama';

  @override
  String get spSinifAdRS4 => 'Depolama Kat. IV — Raf / Palet Depolama';

  @override
  String get spTipAdAuto => 'Sınıfa Göre Otomatik';

  @override
  String get spTipDescAuto =>
      'Standart K80 (LH/OH) veya K115 (HH) — varsayılan';

  @override
  String get spTipAdK57 => 'Standart K57';

  @override
  String get spTipDescK57 => 'Yalnızca özel onaylı düşük debili uygulamalarda';

  @override
  String get spTipAdK80 => 'Standart K80';

  @override
  String get spTipDescK80 => 'LH/OH sınıfları için standart';

  @override
  String get spTipAdK115 => 'Yüksek Debili K115';

  @override
  String get spTipDescK115 => 'HH sınıfları için standart';

  @override
  String get spTipAdK161 => 'Büyük Damla K161';

  @override
  String get spTipDescK161 =>
      'Yüksek depolama / raf sistemleri — üretici onayı gerekir';

  @override
  String get spTipAdK200 => 'Ekstra Büyük Damla K200';

  @override
  String get spTipDescK200 =>
      'Özel yüksek debili uygulamalar — üretici onayı gerekir';

  @override
  String get spTipAdEsfr => 'ESFR K242 (bilgi amaçlı)';

  @override
  String get spTipDescEsfr =>
      'Erken bastırma hızlı tepki — EN 12845 kapsamı dışıdır; NFPA 13 / listeleme verisi esas alınmalıdır';

  @override
  String get spKurulumAdSingle => 'Tekli Kaynak + Tek Pompa';

  @override
  String get spKurulumDescSingle =>
      'Yedekliliği yoktur — yalnızca LH ve düşük riskli, tek kaynaklı tesislerde kabul edilebilir.';

  @override
  String get spKurulumAdDual => 'Çiftli Pompa (Elektrik + Dizel)';

  @override
  String get spKurulumDescDual =>
      'OH ve çoğu HH tesisinde yaygın çözüm — elektrik kesintisinde dizel pompa otomatik devreye girer.';

  @override
  String get spKurulumAdSuperior => 'Çiftli Kaynak + Çiftli Pompa (Superior)';

  @override
  String get spKurulumDescSuperior =>
      'En yüksek güvenilirlik — kritik tesisler, HH sınıfları ve yüksek riskli depolarda önerilir; iki bağımsız su kaynağı ve pompa seti.';

  @override
  String get spUnitAdet => 'adet';

  @override
  String get spUnitSpacing => 'aralık';

  @override
  String get spUnitMinutes => 'dakika';

  @override
  String get spRcHeaderBuilding => 'Bina & Tasarım Parametreleri';

  @override
  String get spRcHeaderLayout => 'Sprinkler Yerleşim Hesabı';

  @override
  String get spRcHeaderHydraulic => 'Kritik Devre Hidrolik Hesabı';

  @override
  String get spRcHeaderFullHydraulic => 'Kritik Devre — Tam Hidrolik Hesap';

  @override
  String get spRcHeaderPump => 'Pompa Gereksinimleri';

  @override
  String get spRcHeaderInstallation => 'Kurulum Sınıfı & Pompa Yedekliliği';

  @override
  String get spRcHeaderWaterTank => 'Su Deposu  —  EN 12845 Tablo 2';

  @override
  String get spRcHeaderDryPipe => 'Kuru Borulu Sistem  —  Donma Riski';

  @override
  String get spRcHeaderRackStorage =>
      'Raf Depolama — In-Rack Sprinkler (Ön Tasarım)';

  @override
  String get spRcHeaderPipeDiameterSummary =>
      'Boru Çapı Özeti  —  EN 12845 Tablo 14';

  @override
  String get spRcHeaderPipeLength => 'Boru Metrajı (Yaklaşık)';

  @override
  String get spRcHeaderAlarmValve => 'Islak Alarm Vanası  —  EN 12845 Md. 11.2';

  @override
  String get spRcHeaderFoamSystem => 'Köpük Sistemi  —  EN 13565-2';

  @override
  String get spRcBuildingArea => 'Bina Alanı';

  @override
  String get spRcCeilingHeight => 'Tavan Yüksekliği';

  @override
  String spRcCoverageAdjustedSuffix(String value) {
    return '  ›  kapsama düzetildi: $value m² (Yükseklik etkisi)';
  }

  @override
  String get spRcHazardClass => 'Tehlike Sınıfı';

  @override
  String get spRcDesignDensity => 'Tasarım Yoğunluğu';

  @override
  String get spRcDesignArea => 'Tasarım Alanı';

  @override
  String get spRcMaxCoveragePerSprinklerCap => 'Maks. Kapsama / Sprinkler';

  @override
  String get spRcMaxCoveragePerSprinklerLow => 'Maks. kapsama / sprinkler';

  @override
  String get spRcHeightAdjustSuffix => '(yükseklik düzetmesi)';

  @override
  String get spRcTable20Title =>
      'Çizelge 20 — Yan Duvar Püskürtme Grupları (referans)';

  @override
  String get spRcMaxGroupDistance => 'Gruplar arası maks. mesafe';

  @override
  String get spRcNote2Suffix =>
      '  (Not 2: yangına 120 dk dayanımlı tavanda 3,7 m\'ye çıkabilir)';

  @override
  String get spRcMaxToWallEnd => 'Duvar sonuna kadar maks.';

  @override
  String get spRcTheoreticalSpacing => 'Alan bazlı teorik aralık  √A';

  @override
  String get spRcTable19MaxDistance => 'Çizelge 19 — Maks. S ve D mesafesi';

  @override
  String get spRcAppliedGridSpacing => 'Uygulanan ızgara aralığı';

  @override
  String get spRcDistanceConstraintBinding =>
      '⚠ MESAFE KISITI bağlayıcı (√A > maks.mesafe)';

  @override
  String get spRcAreaConstraintBinding => '✓ Alan kısıtı bağlayıcı';

  @override
  String get spRcHorizontalRow => 'Yatay sıra (en boyunca)';

  @override
  String get spRcVerticalRow => 'Dikey sıra (boy boyunca)';

  @override
  String get spRcActualCoveragePerHead => 'Sprinkler başına gerçek kapsama';

  @override
  String get spRcTotalSprinklers => 'TOPLAM SPRİNKLER';

  @override
  String get spRcMainFloorSuffix => '(ana kat)';

  @override
  String get spRcSprinklersInDesignArea => 'Tasarım alanındaki sprinklerler';

  @override
  String get spRcSuspendedCeilingVoid => 'Asma tavan boşluğu';

  @override
  String get spRcExtraSprinklerRequired => '⚠ Ek sprinkler zorunlu (> 80 cm)';

  @override
  String get spRcExtraSprinklerNotRequired =>
      '✓ Ek sprinkler gerekmez (≤ 80 cm)';

  @override
  String get spRcConcealedVoidSprinklerCount => 'Gizli boşluk sprinkler sayısı';

  @override
  String get spRcAppliedToUpperGridSuffix => '(aynı ızgara üst kata uygulanır)';

  @override
  String get spRcFarthestHeadFlow => 'En uzak sprinkler debisi  q';

  @override
  String get spRcDesignTotalFlow => 'Tasarım toplam debi  Q';

  @override
  String spRcBranchPipeDN(String dn) {
    return 'Dal boru  DN$dn';
  }

  @override
  String spRcCrossPipeDN(String dn) {
    return 'Dağıtım boru  DN$dn';
  }

  @override
  String spRcMainPipeDN(String dn) {
    return 'Besleme / esas boru  DN$dn';
  }

  @override
  String get spRcTotalFrictionLoss => 'Toplam sürtünme kaybı';

  @override
  String spRcStaticHeadFormula(String height) {
    return 'Statik yük  ($height m × 0.098)';
  }

  @override
  String get spRcFarthestHeadMinPressure => 'Uzak sprinkler min. basıncı';

  @override
  String get spRcSafetyMarginLabel => 'Emniyet marjı';

  @override
  String get spRcColDistance => 'Mesafe\n(m)';

  @override
  String get spRcColPressure => 'Basınç\n(bar)';

  @override
  String get spRcColFlowLower => 'q\n(L/min)';

  @override
  String get spRcColCumFlow => 'ΣQ\n(L/min)';

  @override
  String get spRcColNextDeltaP => 'ΔP sonraki\n(bar)';

  @override
  String get spRcSectionBranchPipe => '── Dal Boru (Range Pipe) ──';

  @override
  String get spRcSectionDistPipe => '── Tali Boru (Distribution Pipe) ──';

  @override
  String get spRcSectionMainPipe => '── Ana Boru (Main Pipe) ──';

  @override
  String get spRcHydraulicFootnote =>
      'SP1 = en uzak sprinkler  ·  DP1 = tasarım noktası (design point)  ·  MP = esas boru  ·  K-orantılama: Q_j = Q_krit×√(P_j/P_DP)  ·  Hazen-Williams C=120, fitting payı %20 dahil  (EN 12845 §13.3.2)';

  @override
  String get spRcPumpFlowLabel => 'Pompa Debisi';

  @override
  String get spRcPumpPressureLabel => 'Pompa Basıncı';

  @override
  String get spRcTable6AppliedIntro =>
      'TS EN 12845+A1 Tablo 6 uygulandı — Ön-hesaplı sistemlerde pompa boyutlandırması için bağlayıcı minimum değerler:';

  @override
  String spRcTable6FlowLine(String calc, String min) {
    return '• Debi: iteratif hidrolik debi $calc L/min < Tablo 6 min. $min L/min → $min L/min kullanıldı';
  }

  @override
  String spRcTable6PressureLine(String min, String applied) {
    return '• Basınç: hesaplanan < Tablo 6 min. ($min + ps) bar → $applied bar uygulandı';
  }

  @override
  String spRcMaxPressureWarning(String pressure, String zones) {
    return '⚠ EN 12845 §8.2 — Pompa basıncı $pressure bar, sistemdeki herhangi bir sprinkler konumundaki maksimum işletme basıncı 12 bar\'ı aşmamalıdır. Basınç düşürücü vana (PRV) ile $zones basınç zonuna ayrılması veya sistem yeniden tasarımı değerlendirilmelidir.';
  }

  @override
  String get spRcInstallationClassLabel => 'Kurulum Sınıfı';

  @override
  String get spRcPumpCount => 'Pompa Sayısı';

  @override
  String get spRcElectricDieselSuffix => '  (elektrik + dizel)';

  @override
  String get spRcWaterSource => 'Su Kaynağı';

  @override
  String get spRcDualIndependent => 'Çiftli (bağımsız)';

  @override
  String get spRcSingle => 'Tekli';

  @override
  String get spRcJockeyPump => 'Jokey Pompa';

  @override
  String get spRcWaterSupplyDuration => 'Su Besleme Süresi';

  @override
  String spRcSupplyDurationSub(String cls, String minutes) {
    return '$cls → $minutes dk';
  }

  @override
  String get spRcMinWaterTank => 'Min. Su Deposu';

  @override
  String get spRcWaterSupplyNote =>
      'EN 12845:2015 Tablo 2 — Su beslemesi; depo veya dorudan şebeke bağlantısı ile sağlanabilir. Depoda hangi konum seçilirse emniyet payı eklenmesi tavsiye edilir.';

  @override
  String get spRcPipeNetworkVolume => 'Boru Şebekesi İç Hacmi';

  @override
  String get spRcDryPipeNote =>
      'Bu hacim yalnızca hava kompresörü / nitrojen jeneratörü ve priming suyu ön boyutlandırması için bir referanstır. Tetikleme (trip) süresi, aksesuar (accelerator/exhauster) ihtiyacı ve boru eğimi ayrıca üretici/tasarım standardına göre kesinleştirilmelidir.';

  @override
  String get spRcRackLevelCount => 'Raf Kat Sayısı';

  @override
  String get spRcEstExtraInRackSprinklers => 'Tahmini Ek In-Rack Sprinkler';

  @override
  String get spRcEstExtraFlow => 'Tahmini Ek Debi';

  @override
  String get spRcRackNote =>
      'Basitleştirilmiş ön tasarım değeridir (3 m yatay aralık varsayımı, K80, 1,0 bar). Kesin in-rack yerleşimi — flue space genişliği, kat aralığı ve gerçek hidrolik talep — EN 12845 Ek H kapsamında tam tasarımla belirlenmeli ve pompa/su deposu hesabına ayrıca eklenmelidir.';

  @override
  String get spRcHHPTable14Warning =>
      '⚠  HHP sınıfı: EN 12845 Tablo 14 uygulanmaz. Çaplar EN 12845 Ek C kapsamında tam hidrolik hesapla belirlenir. Aşağıdaki değerler hız ≤ 5 m/s ön hesap yöntemine göre verilmiştir.';

  @override
  String get spRcSprinklerTypeKFactor => 'Sprinkler Tipi / K-Faktör';

  @override
  String get spRcBranchPipeRow => 'Dal boru (branch line)';

  @override
  String get spRcVelocityMethodSuffix => '  (hız yöntemi)';

  @override
  String get spRcTable14Suffix => '  (Tb.14)';

  @override
  String get spRcCrossMainRow => 'Dağıtım borusu (cross main)';

  @override
  String spRcBranchConnCount(String branches, String heads) {
    return '$branches dal kol / $heads spr.';
  }

  @override
  String get spRcMainSupplyRow => 'Esas boru / besleme';

  @override
  String spRcDesignAreaHeadsSuffix(String n) {
    return '$n spr. (tasarım alanı)';
  }

  @override
  String get spRcColPipeType => 'Boru Türü';

  @override
  String get spRcColCountLength => 'Adet × Uzunluk';

  @override
  String get spRcColTotalM => 'Toplam (m)';

  @override
  String get spRcRowBranchPipe => 'Dal boru (branch)';

  @override
  String spRcRowCrossMain(String n) {
    return 'Dağıtım (cross main)\n[$n dal kol bağlantısı]';
  }

  @override
  String get spRcRowMainPipe => 'Esas boru (main)\n[pompa + kalan boy]';

  @override
  String get spRcTotalPipeLength => 'TOPLAM BORU METRAJ';

  @override
  String get spRcPipeLengthFootnote =>
      '* Metraj yaklaşık değerdir. %20 bağlantı eklentisi hesaba katılmıştır. Gerçek metraj için mimari plan üzerinde tam hesap yapılmalıdır.';

  @override
  String get spRcRequiredAlarmValve => 'Gerekli Islak Alarm Vanası:  ';

  @override
  String get spRcTotalSprinklersRow => 'Toplam sprinkler';

  @override
  String get spRcMaxSprinklersPerValve => 'Maks. sprinkler / vana';

  @override
  String get spRcHHPClassSuffix => 'HHP sınıfı';

  @override
  String get spRcLHOHClassSuffix => 'LH/OH sınıfı';

  @override
  String get spRcMaxAreaPerValve => 'Maks. alan / vana';

  @override
  String get spRcAreaPerValve => 'Vana başına alan';

  @override
  String get spRcDesignFlowPerValve => 'Her vana için tasarım debisi';

  @override
  String get spRcSingleValveSuffix =>
      '  (tüm sistem tek vana üzerinden hesaplanır)';

  @override
  String spRcAlarmValveNote(String scope) {
    return 'EN 12845:2015 Madde 11.2.1: Bir ıslak alarm vanası bölgesi $scope yüzey alanı koruyabilir.';
  }

  @override
  String get spRcAlarmValveScopeHH =>
      'HHP sınıflarında en fazla 500 sprinkler ve 2 300 m²';

  @override
  String get spRcAlarmValveScopeLHOH =>
      'LH/OH sınıflarında en fazla 1 000 sprinkler ve 4 800 m²';

  @override
  String get spRcConcentrateType => 'Konsantre tipi';

  @override
  String spRcConcentrationSuffix(String pct) {
    return '  —  %$pct konsantrasyon';
  }

  @override
  String get spRcLiquidCategory => 'Sıvı kategorisi';

  @override
  String get spRcPolarSolventDetail =>
      'Polar Solvent (B2) — aseton, etanol, keton, solvent';

  @override
  String get spRcHydrocarbonDetail => 'Hidrokarbon (B1) — benzin, motorin, yağ';

  @override
  String get spRcProtectedArea => 'Koruma alanı';

  @override
  String get spRcApplicationRate => 'Uygulama hızı';

  @override
  String get spRcApplicationDuration => 'Uygulama süresi';

  @override
  String get spRcSolutionFlow => 'Çözelti debisi (Q)';

  @override
  String get spRcConcentrateFlow => '  Konsantre debisi';

  @override
  String get spRcWaterFlow => '  Su debisi';

  @override
  String get spRcConcentrateTankVolume => 'Konsantre tank hacmi';

  @override
  String get spRcWaterReserve => 'Su rezervi';

  @override
  String get spRcFoamNote7 =>
      'EN 13565-2 Madde 7: Konsantre tank hacmi ve su rezervi minimum değerlerdir. Gerçek tasarımda emniyet payı ve eş zamanlı kullanım dikkate alınmalıdır.';

  @override
  String get spRcFinalDisclaimer =>
      '⚠  Bu yaklaşık ön hesap niteliğindedir. Resmi proje tasarımında EN 12845 Ek C kapsamında tam hidrolik hesap ve yetkili mühendis onayı zorunludur. Bağlantı elemanı kayıpları için uzunluklara +%20 eklentisi hesaba katılmıştır.';

  @override
  String get updateAvailableTitle => 'Yeni Sürüm Mevcut';

  @override
  String updateAvailableMessage(String version) {
    return 'Uygulama v$version sürümüne güncellendi.\nEn yeni özellikleri kullanmak için güncelleyiniz.';
  }

  @override
  String get updateLaterButton => 'Sonra';

  @override
  String get updateNowButton => 'Güncelle';

  @override
  String loginRateLimitMessage(String time) {
    return 'Çok fazla hatalı giriş denemesi. $time sonra tekrar deneyin.';
  }

  @override
  String savedOnLabel(String date) {
    return 'Kaydedilme: $date';
  }

  @override
  String get upgradeRequiredTitle => 'Sürüm Yükselt';

  @override
  String get upgradeRequiredMessage =>
      'Bu modül demo sürümünde kullanılamaz. Tüm modüllere erişmek için MEVOS hesabınızı oluşturup Yangın modülü aboneliğini başlatın.';

  @override
  String get upgradeSignUpButton => 'Kayıt Ol';

  @override
  String get geminiApiKeyRequiredInfo =>
      'Yapay zeka için ücretsiz Google Gemini API anahtarı gereklidir.';

  @override
  String get enterStandardNumberFirst => 'Önce standart numarasını girin.';

  @override
  String get apiKeyRequiredError => 'API anahtarı gerekli.';

  @override
  String get standardNotFoundError => 'Standart bulunamadı.';

  @override
  String get enterTopicOrKeywordFirst => 'Önce konu veya anahtar kelime girin.';

  @override
  String get relatedStandardNotFound => 'İlgili standart bulunamadı.';

  @override
  String get addCustomStandardTitle => 'Özel Standart Ekle';

  @override
  String get byNumberTab => 'Numara ile';

  @override
  String get byTopicTab => 'Konuya Göre';

  @override
  String get findDescriptionWithAiTooltip => 'AI ile açıklamayı bul';

  @override
  String get searchStandardsWithAiTooltip => 'AI ile standartları ara';

  @override
  String get selectAllButton => 'Tümünü Seç';

  @override
  String get deselectAllButton => 'Tümünü Kaldır';

  @override
  String addSelectedButton(int count) {
    return 'Seçilenleri Ekle ($count)';
  }

  @override
  String get customAddedStandardsHeader => 'Özel Eklenmiş Standartlar';

  @override
  String get deleteStandardTitle => 'Standardı Sil';

  @override
  String deleteStandardConfirm(String number) {
    return '\"$number\" standardını listeden kaldırmak istiyor musunuz?';
  }

  @override
  String get aiAssistantTitle => 'YZ Asistan';

  @override
  String aiChatGreeting(String standard) {
    return '$standard standardı hakkında sorularınızı alabilir, açıklayabilirim.';
  }

  @override
  String get rehberFireLoadScenario => 'Yangın Yükü & Yangın Senaryosu';

  @override
  String get rehberGasSuppressionSystems => 'Gazlı Söndürme Sistemleri';

  @override
  String get rehberWaterBasedSuppression => 'Su Bazlı Söndürme Sistemleri';

  @override
  String get rehberFoamSuppressionSystems => 'Köpüklü Söndürme Sistemleri';

  @override
  String get rehberKitchenHoodSuppression => 'Davlumbaz & Mutfak Söndürme';

  @override
  String get rehberFireExtinguishersPortable =>
      'Yangın Söndürücüler & Taşınabilir Donanım';

  @override
  String get rehberStructuralFireResistance => 'Yapısal Yangına Direnç';

  @override
  String get rehberRiskAssessmentSafety =>
      'Risk Değerlendirme & Güvenlik Yönetimi';

  @override
  String get rehberIndustrialSpecialRisk =>
      'Endüstriyel & Özel Risk Sistemleri';

  @override
  String get stdDescEn1991FireLoad =>
      'Eurocode 1 Bölüm 1-2: Yapılara etkiyen yükler — Yangın etkileri. Yangın yükü yoğunluğu, büyüme hızı ve yangın senaryosu hesabı.';

  @override
  String get stdDescIso1716Ncv =>
      'Yapı malzemeleri ve ürünlerinin yanma ısısının tayini — Net ısıl değer (NCV) belirleme yöntemi.';

  @override
  String get stdDescIso5660ConeCalorimeter =>
      'Yangın tepkisi deneyleri — Isı salım hızı, duman üretim hızı ve kütle kaybı hızı. Koni kalorimetre yöntemi.';

  @override
  String get stdDescNfpa557FireLoadDensity =>
      'Yangın yükü yoğunluğu hesabı standardı — Bina kullanım tipine göre referans yoğunluk tabloları.';

  @override
  String get stdDescIso24679FireBehaviour =>
      'Yangın güvenliği mühendisliği — Yapıda yangın davranışının değerlendirilmesi.';

  @override
  String get stdDescIso16733FireScenario =>
      'Yangın güvenliği mühendisliği — Yangın senaryosu ve yangın modellemesi seçimi.';

  @override
  String get stdDescSfpeHandbook =>
      'Yangın koruma mühendisliği başvuru kitabı — Hesap yöntemleri, yangın dinamiği, duman hareketi.';

  @override
  String get stdDescPd7974FireInitiation =>
      'BSI — Yapılarda yangın güvenliği mühendisliği uygulaması: Yangın başlangıcı ve gelişimi.';

  @override
  String get stdDescIso145201GeneralRules =>
      'Gazlı söndürme sistemleri — Genel kurallar: tasarım, kurulum, devreye alma, bakım ve güvenlik.';

  @override
  String get stdDescIso145202Co2 =>
      'CO² söndürme sistemleri — Toplam taşkın ve yerel uygulama yöntemleri.';

  @override
  String get stdDescIso145205Hfc227 =>
      'HFC-227ea (FM-200) gazlı söndürme sistemleri — Konsantrasyon ve hacim hesabı.';

  @override
  String get stdDescIso145208Hcfc =>
      'HCFC Blend A (Halotron I) söndürme sistemleri.';

  @override
  String get stdDescIso145209Hfc23 =>
      'HFC 23 (Triflorometan) söndürme sistemleri.';

  @override
  String get stdDescIso1452010Ig55 =>
      'IG-55 (Argonite) sistemleri — N²/Ar karışımı, inert gaz.';

  @override
  String get stdDescIso1452011Ig541 =>
      'IG-541 (Inergen) — N²/Ar/CO² karışımı, inert gazlı söndürme.';

  @override
  String get stdDescIso1452012Ig01 => 'IG-01 (Argon) söndürme sistemleri.';

  @override
  String get stdDescIso1452013Ig100 => 'IG-100 (Azot) söndürme sistemleri.';

  @override
  String get stdDescIso1452015Novec =>
      'FK-5-1-12 (Novec 1230) — Düşük GWP değeri, hassas ekipman odaları.';

  @override
  String get stdDescNfpa2001CleanAgent =>
      'ABD — Temiz ajan (clean agent) söndürme sistemleri standardı.';

  @override
  String get stdDescNfpa12Co2Us =>
      'CO² söndürme sistemleri — ABD standardı, toplam taşkın ve yerel uygulama.';

  @override
  String get stdDescNfpa12aHalon =>
      'Halon 1301 söndürme sistemleri — ABD, mevcut sistemler.';

  @override
  String get stdDescTsEn150041GeneralReq =>
      'Sabit yangın söndürme sistemleri — Gazlı söndürme sistemleri, genel gereksinimler.';

  @override
  String get stdDescVds2380Design =>
      'Almanya — Gazlı söndürme sistemleri tasarım ve kurulum yönergeleri.';

  @override
  String get stdDescNfpa34DippingCoating =>
      'Yanıcı/tutuşabilir sıvı kullanan daldırma, kaplama ve baskı prosesleri — temel güvenlik standardı.';

  @override
  String get stdDescNfpa34Sec10PrintingOps =>
      'Printing Operations: baskı alanı yapısı, havalandırma, elektrik sınıflandırması ve yangın koruma.';

  @override
  String get stdDescNfpa34Sec106AutoSuppression =>
      'Otomatik yangın söndürme zorunluluğu — Sınıf I sıvı için sprinkler; kurutucu bölmeler için yerel CO₂/temiz ajan.';

  @override
  String get stdDescNfpa12PrintingPressLocal =>
      'CO₂ söndürme — baskı makinesi ve kurutucu bölme yerel uygulama sistemleri.';

  @override
  String get stdDescNfpa2001PrintingCabin =>
      'Temiz ajan söndürme — baskı makinesi kabin koruma, insan varlığında tercih edilir.';

  @override
  String get stdDescNfpa30PrintingSolvent =>
      'Yanıcı ve tutuşabilir sıvılar kodu — baskı tesisinde solvent depolama ve kullanım.';

  @override
  String get stdDescNfpa70Article516 =>
      'Baskı alanı ATEX/NEC patlayıcı atmosfer sınıflandırması ve elektrik ekipmanı.';

  @override
  String get stdDescEn10101PrintingSafetyGeneral =>
      'Baskı makinelerinin güvenliği — Genel gereksinimler.';

  @override
  String get stdDescEn10102PrintingSafetyMachines =>
      'Baskı makinelerinin güvenliği — Baskı ve baskı lakı uygulama makineleri (ofset, flexo, gravür).';

  @override
  String get stdDescEn13463AtexEquipment =>
      'ATEX ekipmanlar — Potansiyel patlayıcı ortamda kullanılacak ekipmanlar için güvenlik kriterleri.';

  @override
  String get stdDescTsEn150041PrintingCabinet =>
      'Gazlı söndürme sistemleri — Genel şartlar (baskı kabini için temiz ajan hesabı).';

  @override
  String get stdDescTsEn12845Sprinkler =>
      'Sabit sprinkler sistemleri — Tasarım, tesis ve bakım. Tehlike sınıfı, yoğunluk, debi ve depo hacmi.';

  @override
  String get stdDescNfpa13SprinklerInstallation =>
      'Sprinkler sistemi kurulumu standardı — ABD, tüm bina tipleri.';

  @override
  String get stdDescNfpa13rResidential =>
      'Konut binalarında sprinkler sistemleri — 4 kata kadar yapılar.';

  @override
  String get stdDescNfpa13dOneTwoFamily =>
      'Tek ve iki ailelik konutlarda sprinkler sistemleri.';

  @override
  String get stdDescNfpa15WaterSpray =>
      'Sabit su spreyi söndürme sistemleri — Ekipman ve risk koruma.';

  @override
  String get stdDescNfpa16FoamWaterSpray =>
      'Köpük-su sprey ve köpük-su sprinkler sistemleri.';

  @override
  String get stdDescEn14339UndergroundHydrant =>
      'Yeraltı yangın hidranti sistemleri — Tasarım ve kurulum.';

  @override
  String get stdDescEn14384AboveGroundHydrant =>
      'Yerüstü yangın hidranti sistemleri.';

  @override
  String get stdDescEn6711SemiRigidHose =>
      'Sabit yangın söndürme donanımı — Yarı sert hortumlu makara sistemleri.';

  @override
  String get stdDescEn6712FlatHoseHydrant =>
      'Sabit yangın söndürme donanımı — Düz hortumlu hidrant sistemleri.';

  @override
  String get stdDescEn6713Maintenance =>
      'Sabit yangın söndürme donanımı — Bakım, Bölüm 3.';

  @override
  String get stdDescEn122591Components =>
      'Sabit yangın söndürme sistemleri — Sprinkler ve su spreyi bileşenleri.';

  @override
  String get stdDescTsEn149721WaterMistDesign =>
      'Sabit söndürme sistemleri — Su sisi sistemleri, Bölüm 1: Tasarım ve kurulum.';

  @override
  String get stdDescNfpa750WaterMist =>
      'Su sisi (water mist) söndürme sistemleri standardı — ABD.';

  @override
  String get stdDescNfpa11ExpansionFoam =>
      'Düşük, orta ve yüksek genleşmeli köpük söndürme sistemleri — ABD standardı.';

  @override
  String get stdDescEn135651FoamRequirements =>
      'Sabit köpük söndürme sistemleri — Bölüm 1: Gereksinimler ve test yöntemleri.';

  @override
  String get stdDescEn135652FoamDesignInstall =>
      'Sabit köpük söndürme sistemleri — Bölüm 2: Tasarım, kurulum ve bakım.';

  @override
  String get stdDescIso72031FoamConcentrates =>
      'Yangın söndürücü maddeler — Sıvı akaryakıt yangınları için köpük konsantreleri.';

  @override
  String get stdDescNfpa30StorageTransfer =>
      'Yanıcı ve tutuşabilir sıvılar kodu — Depolama ve taşıma.';

  @override
  String get stdDescApi2021TankFirePrevention =>
      'Petrol endüstrisi — Depo tankları yangın önleme ve söndürme.';

  @override
  String get stdDescNfpa17aWetChemical =>
      'Islak kimyasal (wet chemical) söndürme sistemleri — Ticari mutfak uygulamaları.';

  @override
  String get stdDescNfpa17DryChemical =>
      'Kuru kimyasal söndürme sistemleri — Genel sanayi uygulamaları.';

  @override
  String get stdDescTsEn15751CommercialKitchen =>
      'Avrupa — Ticari mutfak ekipmanı için sabit yangın söndürme sistemleri.';

  @override
  String get stdDescUl300CookingSuppression =>
      'ABD ürün onay standardı — Yemek pişirme alanları söndürme sistemleri (Ansul, Amerex vb.).';

  @override
  String get stdDescUl300aAutoSuppressionCooking =>
      'Otomatik söndürme sistemleri — Pişirme aleti üstü yangın tehlikesi.';

  @override
  String get stdDescTsEn18251GreaseSeparators =>
      'Mutfak davlumbazı gres tutucular ve filtreler.';

  @override
  String get stdDescTsEn18252GreaseSelection =>
      'Mutfak davlumbazı gres tutucular — Seçim, kurulum ve bakım.';

  @override
  String get stdDescNfpa96VentilationCooking =>
      'Ticari mutfak havalandırma sistemi standardı — Kanal, davlumbaz ve yangın önleme.';

  @override
  String get stdDescEn541Introduction =>
      'Yangın algılama ve alarm sistemleri — Bölüm 1: Sisteme genel bakış.';

  @override
  String get stdDescEn542ControlIndicating =>
      'Yangın alarm kontrol ve gösterge paneli.';

  @override
  String get stdDescEn543SoundersDevices =>
      'Yangın alarm sesli uyarı cihazları.';

  @override
  String get stdDescEn544PowerSupply => 'Güç besleme donanımı.';

  @override
  String get stdDescEn545HeatDetectors => 'Isı detektörleri — Noktasal.';

  @override
  String get stdDescEn547SmokeDetectorsOptical =>
      'Duman detektörleri — Dağılım tipi optik detektörler.';

  @override
  String get stdDescEn5410FlameDetectors => 'Alev detektörleri — Noktasal.';

  @override
  String get stdDescEn5411ManualCallPoint =>
      'Manuel yangın alarm butonu (kırılır camlı).';

  @override
  String get stdDescEn5412SmokeDetectorsLinear =>
      'Duman detektörleri — Doğrusal ışın tipi.';

  @override
  String get stdDescEn5413SystemCompatibility =>
      'Sistem bileşenlerinin uyumluluğu ve bağlanabilirliği değerlendirmesi.';

  @override
  String get stdDescEn5414PlanningGuide =>
      'Yangın algılama ve alarm sistemleri — Planlama, tasarım, kurulum, devreye alma, kullanım ve bakım kılavuzu.';

  @override
  String get stdDescEn5416VoiceAlarm =>
      'Sesli alarm kontrol ve gösterge donanımı.';

  @override
  String get stdDescEn5417ShortCircuitIsolators => 'Kısa devre izolatörleri.';

  @override
  String get stdDescEn5418InputOutputDevices => 'Giriş/çıkış cihazları.';

  @override
  String get stdDescEn5420AspiratingSmoke =>
      'Duman detektörleri — Aspirasyonlu tip.';

  @override
  String get stdDescEn5421AlarmTransmission =>
      'Alarm iletim ve arıza uyarı yönlendirme donanımı.';

  @override
  String get stdDescEn5423VisualAlarm => 'Yangın alarm görsel uyarı cihazları.';

  @override
  String get stdDescEn5425RadioComponents =>
      'Radyo bağlantılı (kablosuz) sistem bileşenleri.';

  @override
  String get stdDescNfpa72NationalCode =>
      'ABD — Ulusal yangın alarm ve sinyalizasyon kodu. Adresleme, bildirim, altyapı.';

  @override
  String get stdDescVds2095PlanningInstall =>
      'Almanya — Yangın alarm sistemleri planlama ve kurulum yönergeleri.';

  @override
  String get stdDescEn121011SmokeCurtains =>
      'Duman ve ısı tahliye sistemleri — Bölüm 1: Duman ve ısı kontrol perdelerinin özellikleri.';

  @override
  String get stdDescEn121012NaturalVentilators =>
      'Doğal duman ve ısı tahliye ventilatörleri — Performans gereksinimleri.';

  @override
  String get stdDescEn121013PoweredExhaust =>
      'Mekanik duman tahliye sistemleri — Motorlu duman egzoz fanları.';

  @override
  String get stdDescEn121014InstallCommission =>
      'Kurulum, kabul testi, rutin bakım ve onarım kılavuzu.';

  @override
  String get stdDescEn121016PressureDifferential =>
      'Basınçlı duman kontrol sistemleri — Kit özellikleri.';

  @override
  String get stdDescEn121017DuctlessNaturalVent =>
      'Duman ve ısı tahliye ventilatörleri — Kanalsız doğal duman tahliyesi.';

  @override
  String get stdDescEn121018TunnelControlPanels =>
      'Tünel için doğal duman tahliye sistemi kontrol panelleri.';

  @override
  String get stdDescEn121019FireDamperControl =>
      'Yangın kontrol damperlerinin kontrolü.';

  @override
  String get stdDescEn1210110PowerSupplyKits => 'Güç besleme kitleri.';

  @override
  String get stdDescNfpa92SmokeControlUs =>
      'ABD — Duman kontrol sistemleri standardı. Basınçlı merdivenler, atrium duman yönetimi.';

  @override
  String get stdDescNfpa101LifeSafety =>
      'ABD — Can güvenliği kodu, tahliye yolları, çıkış gereksinimleri.';

  @override
  String get stdDescEn16341DoorFireResistance =>
      'Yangın ve duman kontrol kapı ve pencere takımları — Yangına direnç deneyi.';

  @override
  String get stdDescEn16343SmokeControl =>
      'Yangın kapıları — Yangın ve duman geçirgenliği deneyi.';

  @override
  String get stdDescEn15650FireDampers =>
      'Havalandırma sistemleri için yangın damperleri.';

  @override
  String get stdDescEn158821ExtendedApplication =>
      'Yangın kontrol damperlerinin genişletilmiş uygulama.';

  @override
  String get stdDescEn37PortableExtPerformance =>
      'Taşınabilir yangın söndürücüler — Performans, test yöntemleri ve yapı.';

  @override
  String get stdDescEn38PortableExtAdditional =>
      'Taşınabilir yangın söndürücüler — Ek gereksinimler ve testler.';

  @override
  String get stdDescEn39PortableExtCo2 =>
      'Taşınabilir yangın söndürücüler — CO² söndürücüler.';

  @override
  String get stdDescEn310PortableExtSpecial =>
      'Taşınabilir yangın söndürücüler — Özel gereksinimler.';

  @override
  String get stdDescNfpa10PortableUs =>
      'ABD — Taşınabilir yangın söndürücüler standardı.';

  @override
  String get stdDescEn18661MobileCo2 => 'Taşınabilir CO² söndürücüler.';

  @override
  String get stdDescTsEn615DryChemicalPowder =>
      'Yangın söndürücü maddeler — Kuru kimyasal toz özellikleri.';

  @override
  String get stdDescTsEn15683FoamConcentrates =>
      'Yangın söndürücü maddeler — Köpük konsantreleri.';

  @override
  String get stdDescEn1992Eurocode2 =>
      'Betonarme yapılar — Yangın etkisi altında yapısal tasarım (Eurocode 2).';

  @override
  String get stdDescEn1993Eurocode3 =>
      'Çelik yapılar — Yangın etkisi altında yapısal tasarım (Eurocode 3).';

  @override
  String get stdDescEn1994Eurocode4 =>
      'Kompozit çelik-beton yapılar — Yangın etkisi altında tasarım (Eurocode 4).';

  @override
  String get stdDescEn1995Eurocode5 =>
      'Ahşap yapılar — Yangın etkisi altında yapısal tasarım (Eurocode 5).';

  @override
  String get stdDescEn1996Eurocode6 =>
      'Yığma yapılar — Yangın etkisi altında yapısal tasarım (Eurocode 6).';

  @override
  String get stdDescIso8341StandardFireCurve =>
      'Standart yangın eğrisi — Yapı elemanlarının yangına direnç deneyi.';

  @override
  String get stdDescIso8342AlternativeCurves =>
      'Alternatif ve parametrik yangın eğrileri.';

  @override
  String get stdDescEn135011ReactionToFire =>
      'Yapı malzemeleri ve ürünlerinin yangın performansı sınıflandırması.';

  @override
  String get stdDescEn135012FireResistanceClass =>
      'Yapı elemanlarının yangına direnç sınıflandırması.';

  @override
  String get stdDescEn135013VentilationServices =>
      'Yangın durumundaki havalandırma servis ürünleri sınıflandırması.';

  @override
  String get stdDescEn135014SmokeControlDoors =>
      'Duman kontrol kapılar ve yapı elemanları sınıflandırması.';

  @override
  String get stdDescEn135015Roofs =>
      'Çatılar — Dışarıdan gelen yangına maruz kalma sınıflandırması.';

  @override
  String get stdDescNfpa220ConstructionTypes =>
      'ABD — Yapı inşaat tipleri standardı.';

  @override
  String get stdDescUl263FireResistanceTests =>
      'ABD — Yapı elemanlarının yangına direnç deneyleri.';

  @override
  String get stdDescAstmE119FireEndurance =>
      'ABD — Yapı malzemeleri ve sistemlerinin yangın dayanımı deneyleri.';

  @override
  String get stdDescIso31000RiskManagement =>
      'Risk yönetimi — Kılavuz ilkeler ve genel çerçeve.';

  @override
  String get stdDescIso45001Ohs =>
      'İSG yönetim sistemleri — Gereksinimler ve kullanım kılavuzu.';

  @override
  String get stdDescIso16069SafetyWayGuidance =>
      'Güvenlik işaret sistemleri — Acil kaçış aydınlatması ve yönlendirmesi.';

  @override
  String get stdDescEn50172EmergencyLighting =>
      'Acil kaçış aydınlatma sistemleri — Kurulum ve işletme.';

  @override
  String get stdDescNfpa1FireCode =>
      'ABD — Yangın kodu. Bina kullanımı, çıkış, tahliye ve risk.';

  @override
  String get stdDescNfpa25InspectionTesting =>
      'Su bazlı söndürme sistemleri — Denetim, test ve bakım.';

  @override
  String get stdDescEnIso7010SafetySigns =>
      'Güvenlik işaretleri — Acil çıkış, yangın teçhizatı ve tehlike işaretleri.';

  @override
  String get stdDescTs9811FireSafetySigns =>
      'Türkiye — Yangın İçin Güvenlik İşaretleri.';

  @override
  String get stdDescTbdy2018SeismicSteelFire =>
      'Türkiye Bina Deprem Yönetmeliği — Bölüm 3: Yapısal çelik, yangın etkisi.';

  @override
  String get stdDescTrFireRegulation2015 =>
      'Türkiye — Yapılarda yangından korunma, tahliye, söndürme ve alarm sistemleri gereksinimleri.';

  @override
  String get stdDescNfpa850PowerGeneration =>
      'Elektrik santrallerinde yangın koruması — Türbin sahaları, trafo ve kablo güzergâhları.';

  @override
  String get stdDescNfpa804NuclearPlants =>
      'Nükleer santraller için yangın koruma standardı.';

  @override
  String get stdDescNfpa409AircraftHangars =>
      'Uçak hangarları yangın koruma standardı.';

  @override
  String get stdDescNfpa415AircraftFueling =>
      'Uçak yakıt ikmal sistemleri ve çalışma alanları.';

  @override
  String get stdDescEn11271ExplosivePrevention =>
      'Patlayıcı ortamlar — Patlamadan korunma, temel kavramlar.';

  @override
  String get stdDescEn6007910ZoneClassification =>
      'Patlayıcı ortamlar — Tehlikeli bölgelerin sınıflandırılması (gaz).';

  @override
  String get stdDescIec61511FunctionalSafety =>
      'İşlevsel güvenlik — Proses endüstrisi güvenlik enstrüman sistemleri.';

  @override
  String get stdDescApi610PetrochemPumps =>
      'Petrokimya tesislerinde pompalar — Yangın güvenliği gereksinimleri.';

  @override
  String get stdDescNfpa654CombustibleDust =>
      'Yanıcı toz yangını ve patlamasına karşı koruma.';

  @override
  String get stdDescNfpa68ExplosionVenting =>
      'Patlama basıncı tahliyesi standardı.';

  @override
  String get stdDescNfpa69ExplosionPrevention =>
      'Patlama önleme sistemleri standardı.';

  @override
  String get spActOfficesAdmin => 'Ofisler ve yönetim binaları';

  @override
  String get spActHotelsHostelsGuesthouses =>
      'Oteller, misafirhaneler, pansiyonlar';

  @override
  String get spActHospitalsClinics =>
      'Hastaneler, klinikler, sağlık merkezleri';

  @override
  String get spActSchoolsUniversities =>
      'Okullar, üniversiteler ve eğitim binaları';

  @override
  String get spActResidentialApartments => 'Konutlar ve apartmanlar';

  @override
  String get spActPrisonsReformatories => 'Cezaevleri ve ıslahevleri';

  @override
  String get spActChurchesMosquesWorship =>
      'Kiliseler, camiler ve ibadethaneler';

  @override
  String get spActTheatresCinemaSeating =>
      'Tiyatrolar / sinema (yalnızca seyirci oturma alanları)';

  @override
  String get spActMuseumsGalleries => 'Müzeler ve sanat galerileri';

  @override
  String get spActBreweriesExclDistilleries =>
      'Bira fabrikaları (damıtma tesisleri hariç)';

  @override
  String get spActMultiStoreyBasementCarParks =>
      'Çok katlı ve bodrum katlı kapalı otoparklar';

  @override
  String get spActCeramicsProduction => 'Seramik ürünleri üretimi';

  @override
  String get spActGlassGlasswareExclFibre =>
      'Cam ve cam eşya üretimi (cam elyafı hariç)';

  @override
  String get spActChemResearchLabs => 'Kimya araştırma laboratuvarları';

  @override
  String get spActDairyProcessing =>
      'Süt ve süt ürünleri işleme tesisleri (mandıralar)';

  @override
  String get spActElectronicsAssembly => 'Elektronik ekipman montaj atölyeleri';

  @override
  String get spActFoodProcessingPackaging =>
      'Gıda işleme ve paketleme tesisleri';

  @override
  String get spActHotelsKitchenLaundryService =>
      'Oteller — mutfak, çamaşırhane ve servis alanları';

  @override
  String get spActInstitutionalCommercialLaundries =>
      'Kurumsal ve ticari çamaşırhaneler';

  @override
  String get spActLeatherProductsProduction => 'Deri ve deri ürünleri üretimi';

  @override
  String get spActLightMetalworkingWorkshops => 'Hafif metal işleme atölyeleri';

  @override
  String get spActPharmaceuticalProduction =>
      'Farmasötik (ilaç) üretim tesisleri';

  @override
  String get spActResearchLabsNonflamLiquids =>
      'Araştırma laboratuvarları (yanmaz sıvı kullanımı)';

  @override
  String get spActTextileWeavingNaturalFibresUntreated =>
      'Tekstil dokuma — pamuk/yün/doğal elyaf (terbiye işlemsiz)';

  @override
  String get spActTobaccoProcessingPackaging => 'Tütün işleme ve paketleme';

  @override
  String get spActAgriIndustrialMachineryAssembly =>
      'Tarım ve iş makinesi montaj tesisleri';

  @override
  String get spActGrainFlourMillFoodProcessing =>
      'Tahıl, un değirmeni ve benzeri gıda işleme';

  @override
  String get spActChemProductionNonflamLiquidsOnly =>
      'Kimyasal üretim (yalnızca yanmaz sıvılı ürünler)';

  @override
  String get spActDeptStoresShoppingCentresSingleStorey =>
      'Büyük mağazalar ve alışveriş merkezleri (tek katlı)';

  @override
  String get spActElectricalEquipmentFactories =>
      'Elektrikli ekipman üretim fabrikaları';

  @override
  String get spActComputerDataProcessingRooms =>
      'Bilgisayar ve elektronik veri işleme odaları';

  @override
  String get spActGeneralEngineeringWorkshopsFactories =>
      'Genel mühendislik atölyeleri ve fabrikalar';

  @override
  String get spActFruitVegCanningFacilities =>
      'Meyve, sebze ve konserve işleme tesisleri';

  @override
  String get spActVehicleMaintenanceRepairGarages =>
      'Araç bakım-onarım garajları';

  @override
  String get spActFibreglassProductionAssembly =>
      'Cam elyafı (fiberglas) üretimi ve montajı';

  @override
  String get spActHardwareIronmongeryStores =>
      'Hırdavat ve demir-çelik ürünleri mağazaları';

  @override
  String get spActHospitalsTreatmentSurgeryAreas =>
      'Hastaneler — tedavi ve ameliyat alanları';

  @override
  String get spActKnittingHosieryFactories =>
      'Örme (triko/hosiery) fabrikaları';

  @override
  String get spActLibrariesOpenShelfAreas =>
      'Kütüphaneler — genel açık raf alanları';

  @override
  String get spActGeneralMetalworkingFactories =>
      'Genel metal işleme fabrikaları';

  @override
  String get spActPaperBoardProductionFacilities =>
      'Kâğıt ve karton üretim tesisleri';

  @override
  String get spActPlasticsManufNonflamOnly =>
      'Plastik ürün imalatı (yalnızca yanmaz plastikler)';

  @override
  String get spActGeneralPrintingWaterBasedInk =>
      'Genel baskı / matbaa (su bazlı mürekkep)';

  @override
  String get spActSupermarketsHypermarkets =>
      'Süpermarketler ve hipermarketler';

  @override
  String get spActTailoringGarmentManufacture =>
      'Terzilik, konfeksiyon ve giyim üretimi';

  @override
  String get spActTextileSpinningWeavingSynthetic =>
      'Tekstil eğirme ve dokuma (sentetik elyaf)';

  @override
  String get spActLoadingShippingDocks =>
      'Yükleme-boşaltma, sevkiyat/nakliye rampaları';

  @override
  String get spActGeneralStorageUpTo4m =>
      'Genel depolama (istiflenmiş yükseklik ≤ 4 m)';

  @override
  String get spActAircraftHangarsMaintenance =>
      'Uçak hangarları — bakım ve onarım alanları';

  @override
  String get spActOilclothTarpaulinCanvasProduction =>
      'Muşamba, branda, çadır bezi ve branda üretimi';

  @override
  String get spActChemProductionFpAbove55 =>
      'Kimyasal üretim (parlama noktası > 55 °C ürünler)';

  @override
  String get spActColdStores => 'Soğuk hava depoları';

  @override
  String get spActFilmTvStudiosProduction =>
      'Film ve televizyon stüdyoları (üretim alanı)';

  @override
  String get spActFurnitureUpholsteryProduction =>
      'Mobilya ve döşeme üretimi (sünger, kumaş)';

  @override
  String get spActJoineryWoodworkingWorkshops =>
      'Marangoz / doğrama — ahşap işleme atölyeleri';

  @override
  String get spActMatchProductionFacilities => 'Kibrit üretim tesisleri';

  @override
  String get spActOfficesLargePaperArchives =>
      'Büyük kâğıt arşiv alanları olan ofisler';

  @override
  String get spActWaterBasedPaintVarnishProduction =>
      'Su bazlı boya ve vernik üretimi';

  @override
  String get spActPaperCorrugatedBoxProduction =>
      'Kâğıt, karton ve oluklu mukavva kutu işleme/üretimi';

  @override
  String get spActThermoplasticsManufShaping =>
      'Termoplastik plastik imalat ve şekillendirme';

  @override
  String get spActHighSpeedOffsetPrintingOilInk =>
      'Yüksek hızlı ofset baskı (petrol bazlı mürekkep)';

  @override
  String get spActRubberProductsProduction =>
      'Kauçuk ürünleri üretim tesisleri';

  @override
  String get spActTextileDyeingFinishingFacilities =>
      'Tekstil boyama ve terbiye işleme tesisleri';

  @override
  String get spActGeneralStorage4to8m =>
      'Genel depolama (istiflenmiş yükseklik > 4 m – 8 m)';

  @override
  String get spActChemProductionClosedProcessFp55 =>
      'Kimyasal üretim (kapalı proses, parlama noktası > 55 °C)';

  @override
  String get spActPlasticRubberPartsClosedMoulding =>
      'Plastik ve kauçuk parça üretimi (kapalı ekstrüzyon/kalıplama)';

  @override
  String get spActTextileDyeingFinishingWaterBased =>
      'Tekstil boyama ve terbiye tesisleri (su bazlı)';

  @override
  String get spActPharmacyCosmeticsDetergentProduction =>
      'Eczane, kozmetik ve deterjan üretim tesisleri';

  @override
  String get spActFoodBeverageProductionHighVolume =>
      'Gıda ve içecek üretim tesisleri (yüksek hacimli)';

  @override
  String get spActPaperProductionDryCuttingSorting =>
      'Kağıt üretim ve işleme tesisleri (kuru kesi/tasnif)';

  @override
  String get spActPaintShopsWaterUvCuring =>
      'Su bazlı boya, vernik veya UV-kürleme boyasi kullanan boyahaneler';

  @override
  String get spActMetalworkingMachineryHeavySwarfOilMist =>
      'Metal işleme ve makine üretim tesisleri (yoğun talaş, yağ buharı)';

  @override
  String get spActFlammableLiquidProcessFp55Plus =>
      'Parlama noktası ≥ 55 °C yanıcı sıvı işleme/depolama prosesleri';

  @override
  String get spActFoamRubberFoamPlasticProduction =>
      'Köpük kauçuk ve köpük plastik (PU, EPS/XPS) üretim tesisleri';

  @override
  String get spActFlowCoatingMetalPlasticParts =>
      'Metal ve plastik parçalar için akış kaplama (flow coating)';

  @override
  String get spActIndustrialPrintingFlammableInkSolvent =>
      'Yanıcı mürekkep / solvent kullanan endüstriyel baskı tesisleri';

  @override
  String get spActAerosolSprayPackagingFilling =>
      'Aerosol ve sprey ürünleri paketleme/dolum tesisleri';

  @override
  String get spActFlammableLiquidProcessFpBelow55Open =>
      'Parlama noktası < 55 °C yanıcı sıvı işleme prosesleri (açık kap)';

  @override
  String get spActChemProductionContainingFp55Liquids =>
      'Kimyasal üretim (parlama noktası ≥ 55 °C yanıcı sıvı içeren ürünler)';

  @override
  String get spActSolventBasedPaintVarnishProduction =>
      'Solvent bazlı boya ve vernik üretim tesisleri';

  @override
  String get spActSpraySolventPaintApplication =>
      'Sprey boyahane — yanıcı solvent bazlı boya uygulaması';

  @override
  String get spActDryCleaningPerchloroethyleneSolvent =>
      'Kuru temizleme tesisleri (perkloretilen / solvent bazlı)';

  @override
  String get spActSolventExtractionFacilities =>
      'Solvent ekstraksiyon tesisleri';

  @override
  String get spActPrintingGravureFlammableInk =>
      'Yanıcı mürekkep kullanan baskı / gravür tesisleri';

  @override
  String get spActSprayCoatingBoothsFlammableLiquid =>
      'Yanıcı sıvı ile sprey kaplama / boyama kabinleri';

  @override
  String get spActRubberMasticFlammableRawMaterialProcessing =>
      'Kauçuk mastik ve yanıcı hammadde işleme tesisleri';

  @override
  String get spActPaintInkVarnishPackagingFilling =>
      'Boya, mürekkep veya vernik ambalajlama ve dolum tesisleri';

  @override
  String get spActHighRackPalletStorageSolidAbove4m =>
      'Yüksek raflı palet depolama — katı malzeme, istif yüksekliği > 4 m';

  @override
  String get spActTyresRubberProductsStorage =>
      'Araç lastikleri ve kauçuk ürün depolaması';

  @override
  String get spActPaperRollsReelsStorage =>
      'Rulo kâğıt ve kâğıt topu depolaması';

  @override
  String get spActSolidPlasticRawProductStoragePalletRack =>
      'Katı plastik hammadde ve ürün depolaması (paletli/raflı)';

  @override
  String get spActBaledCottonTextileSyntheticFibreStorage =>
      'Balya pamuk, tekstil hammaddesi ve sentetik elyaf depolaması';

  @override
  String get spActHighRackPalletStorageFlammableLiquidAbove4m =>
      'Yüksek raflı palet depolama — yanıcı sıvı içeren ürünler, > 4 m  ⚠ Yoğun su sistemi';

  @override
  String get spActAerosolStoreFlammablePropellantHighRack =>
      'Aerosol ürün depoları (yanıcı itici gazlı, yüksek raf)  ⚠ Özel sistem gerektirir';

  @override
  String get spActFlammableLiquidPackagedProductStorage =>
      'Yanıcı sıvı ambalajlı ürün depolaması (boya, solvent, vernik)  ⚠ Özel sistem';

  @override
  String get spActHighDensityStorageWaterSensitiveHighCalorific =>
      'Islanmaya dayanıksız veya yüksek ısıl değerli ürünlerin yoğun depolanması';

  @override
  String get spActNoncombustibleStorageMetalGlassCeramicConcrete =>
      'Yanmaz ürün depolama — metal, cam, seramik, beton ürünler';

  @override
  String get spActFrozenFoodColdChainStorage =>
      'Dondurulmuş gıda ve soğuk zincir ürün depolama';

  @override
  String get spActNoncombustibleInSealedMetalCansDrums =>
      'Kapalı metal kutu / bidon içindeki yanmaz ürünler';

  @override
  String get spActWetFoodFreshProduceCannedStorage =>
      'Islak gıda (taze meyve-sebze, konserve) depoları';

  @override
  String get spActPorcelainSanitarywareStorage =>
      'Porselen ve sıhhi tesisat ürünleri depolama';

  @override
  String get spActEmptyGlassBottlesMetalCansStorage =>
      'Boş cam şişe / boş metal kutu depolama';

  @override
  String get spActNoncombustibleCartonPackagedStorage =>
      'Karton ambalajlı yanmaz ürün depolama';

  @override
  String get spActNoncombustibleGoodsWoodenCratesStorage =>
      'Tahta kutu / kasalarda yanmaz mal depolama';

  @override
  String get spActNoncombustibleLiquidGlassPlasticContainersStorage =>
      'Cam şişe / plastik kaplar içinde yanmaz sıvı depolama';

  @override
  String get spActMixedProductsLowCombustibleContentStorage =>
      'Küçük oranda yanabilir içerikli karışık ürün depolama';

  @override
  String get spActGlassCeramicWrappedStorage =>
      'Boya bezlerinde cam ve seramik ürün depolama';

  @override
  String get spActPaperBoardCorrugatedProductStorage =>
      'Kâğıt, karton ve oluklu mukavva ürün depolama';

  @override
  String get spActTextileYarnFabricGarmentStorage =>
      'Tekstil, iplik, kumaş ve hazır giyim depolama';

  @override
  String get spActWoodWoodBasedProductStorage =>
      'Ahşap ve ahşap esaslı ürün depolama';

  @override
  String get spActFurnitureUpholsteryMaterialsStorage =>
      'Mobilya ve döşeme malzemeleri depolama';

  @override
  String get spActMixedPackagedGoodsPaperPlastic =>
      'Karışık ambalajlı mallar (kağıt + plastik kombine)';

  @override
  String get spActDryFoodAgriculturalProductsStorage =>
      'Kuru gıda ve tarım ürünleri (dökme olmayan) depolama';

  @override
  String get spActLeatherProductsStorage => 'Deri ve deri ürünleri depolama';

  @override
  String get spActSmallElectricalApplianceStoragePackaged =>
      'Küçük elektrikli ev aletleri (ambalajlı) depolama';

  @override
  String get spActExpandedPlasticProductStorageFloor =>
      'Ekspande plastik (EPS, PU, XPS) ürün depolama (döşeme)';

  @override
  String get spActRubberTyreProductStorageFloor =>
      'Kauçuk ve lastik ürün depolama (döşeme)';

  @override
  String get spActFlammableLiquidPlasticContainersStorageFloor =>
      'Yanıcı sıvı içeren plastik kaplar depolama (döşeme)';

  @override
  String get spActAerosolProductStorageFloor35m =>
      'Aerosol ürün depolama — döşeme, ≤ 3,5 m';

  @override
  String get spActPolystyreneFoamPackagedProductStorage =>
      'Polistiren köpük ambalajlı ürün depolama';

  @override
  String get spActHighCalorificCombustibleGoodsStorageFloor =>
      'Yüksek kalorili yanabilir mal depolama (döşeme)';

  @override
  String get spActRackPalletCategoryIGoods =>
      'Raf / palet sistemi — Kategori I mallar (metal, cam, seramik)';

  @override
  String get spActHighRackNoncombustibleStorageAbove3m =>
      'Yüksek raflı depo — yanmaz ürünler, istif > 3 m';

  @override
  String get spActPalletSealedMetalGlassStorage =>
      'Palet üzeri kapalı metal / cam ürün depolama';

  @override
  String get spActColdStoreHighRackSystem =>
      'Soğuk hava deposu yüksek raf sistemi';

  @override
  String get spActRackPalletCategoryIIGoods =>
      'Raf / palet sistemi — Kategori II mallar (karton ambalajlı)';

  @override
  String get spActHighRackCartonBoxedNoncombustibleStorage =>
      'Yüksek raflı depo — karton kutu içinde yanmaz ürünler';

  @override
  String get spActPalletCartonPackagedStorageAbove3m =>
      'Palet üzeri karton ambalajlı ürün depolama, > 3 m';

  @override
  String get spActWoodenCrateStorageHighRack =>
      'Tahta kasalarda depolama, yüksek raf sistemi';

  @override
  String get spActRackPalletCategoryIIIGoods =>
      'Raf / palet sistemi — Kategori III mallar (kâğıt, tekstil, ahşap)';

  @override
  String get spActHighRackFurnitureWoodProductsStorage =>
      'Yüksek raflı depo — mobilya, ahşap ürünler';

  @override
  String get spActBaledCottonTextileRackStorageAbove3m =>
      'Balya (pamuk, tekstil) raf depolama, > 3 m';

  @override
  String get spActPaperRollsRackStorageAbove3m =>
      'Rulo kâğıt ve kâğıt topu raf depolama, > 3 m';

  @override
  String get spActMixedPackagedHighRackStorage =>
      'Karışık ambalajlı (kağıt + plastik) yüksek raf depolama';

  @override
  String get spActRackPalletCategoryIVGoods =>
      'Raf / palet sistemi — Kategori IV mallar (plastik, kauçuk, köpük)';

  @override
  String get spActExpandedPlasticFoamHighRackStorage =>
      'Ekspande plastik ve köpük ürün yüksek raf depolama';

  @override
  String get spActAerosolRackStorageFlammablePropellantAbove3m =>
      'Aerosol ürün raf depolama — yanıcı itici gazlı, > 3 m';

  @override
  String get spActSolidPlasticRawProductHighRackStorage =>
      'Katı plastik hammadde ve ürün yüksek raf depolama';

  @override
  String get spActFlammablePackagedProductHighRackStorage =>
      'Yanıcı ambalajlı ürün yüksek raf depolama (boya, vernik, solvent)';

  @override
  String get spActRubberTyreProductHighRackStorageAbove3m =>
      'Kauçuk ve lastik ürün yüksek raf depolama, > 3 m';
}
