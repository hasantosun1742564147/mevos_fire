// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get languageLabel => 'Sprache';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get logout => 'Abmelden';

  @override
  String get save => 'Speichern';

  @override
  String get saved => 'Gespeichert!';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get deletingAccount => 'Konto wird gelöscht ...';

  @override
  String get accountDeleteTitle => 'Möchten Sie Ihr Konto löschen?';

  @override
  String get accountDeleteWarning =>
      'Ihr Konto wird aus dem aktiven System entfernt. Name, E-Mail-Adresse, vorheriger Mitgliedsstatus sowie Registrierungs- und Löschdatum bleiben für Administratoren im Verlauf gelöschter Mitglieder gespeichert. Dieser Vorgang kann nicht rückgängig gemacht werden.';

  @override
  String get accountManagement => 'Kontoverwaltung';

  @override
  String get accountDeleteInfo =>
      'Sie können Ihr Konto und die auf diesem Gerät gespeicherten Kontoinformationen dauerhaft löschen.';

  @override
  String get deleteAccount => 'Mein Konto dauerhaft löschen';

  @override
  String get feedbackTitle => 'Feedback';

  @override
  String get feedbackSubtitle =>
      'Ein Problem gefunden? Lassen Sie es uns wissen.';

  @override
  String get feedbackSelectPage => 'Um welche Seite geht es?';

  @override
  String get feedbackSelectPageHint => 'Seite auswählen';

  @override
  String get feedbackMessageLabel => 'Beschreiben Sie das Problem';

  @override
  String get feedbackMessageHint =>
      'Schreiben Sie hier das aufgetretene Problem...';

  @override
  String get feedbackSend => 'Senden';

  @override
  String get feedbackSending => 'Wird gesendet...';

  @override
  String get feedbackSentSuccess => 'Danke für Ihr Feedback!';

  @override
  String get feedbackSendFailed =>
      'Feedback konnte nicht gesendet werden. Bitte erneut versuchen.';

  @override
  String get feedbackMessageRequired => 'Bitte schreiben Sie eine Nachricht.';

  @override
  String get feedbackPageHome => 'Startseite';

  @override
  String get feedbackPageOther => 'Sonstiges';

  @override
  String get apiKeyTitle => 'Gemini-API-Schlüssel (KI)';

  @override
  String get apiKeyInstructions =>
      'Unter aistudio.google.com/apikey erhalten Sie einen kostenlosen API-Schlüssel.';

  @override
  String get getApiKey => 'API-Schlüssel abrufen';

  @override
  String get updateApiKey => 'API-Schlüssel aktualisieren';

  @override
  String get add => 'Hinzufügen';

  @override
  String get done => 'Fertig';

  @override
  String get smokeReference =>
      'TS EN 54-7:2006 / EN 54-14:2004 — Anordnung punktförmiger Rauchmelder\nNur Vorbemessung; der endgültige Entwurf muss von einem Systemingenieur freigegeben werden.';

  @override
  String get buildingType => 'Gebäudetyp';

  @override
  String get buildingOffice => 'Büro / Verwaltung';

  @override
  String get buildingHome => 'Wohngebäude / Hotel';

  @override
  String get buildingHospital => 'Krankenhaus';

  @override
  String get buildingCommercial => 'Gewerbe / Einkaufszentrum';

  @override
  String get buildingWarehouseNormal => 'Lager (normal â‰¤ 6 m)';

  @override
  String get buildingWarehouseHigh => 'Lager (Hochregal > 6 m)';

  @override
  String get buildingIndustrial => 'Industrie';

  @override
  String defaultCeilingHeight(String height) {
    return 'Standard-Deckenhöhe: $height m';
  }

  @override
  String get editablePerRoom => 'Für jeden Raum separat anpassbar';

  @override
  String get addFloorZone => 'Geschoss / Bereich hinzufügen';

  @override
  String get floorZone => 'Geschoss / Bereich';

  @override
  String get totalDetectors => 'Melder gesamt';

  @override
  String detectorCount(int count) {
    return '$count';
  }

  @override
  String get addRoomArea => 'Raum / Bereich hinzufügen';

  @override
  String get editRoomArea => 'Raum bearbeiten';

  @override
  String get roomAreaName => 'Raum- / Bereichsname';

  @override
  String get roomAreaExample => 'z. B. Kantine, Serverraum …';

  @override
  String get areaType => 'Bereichstyp';

  @override
  String get validDimensions => 'Gültige Maße eingeben.';

  @override
  String get roomNameRequired => 'Der Raumname darf nicht leer sein.';

  @override
  String get roomStandard => 'Standardraum';

  @override
  String get roomOpenOffice => 'Großraumbüro';

  @override
  String get roomTechnical => 'Technik / Versorgungsraum';

  @override
  String get roomKitchen => 'Küche / Kochbereich';

  @override
  String get roomCorridor => 'Flur (B â‰¤ 3 m)';

  @override
  String get roomProduction => 'Produktion / Montage';

  @override
  String get roomWarehouseRack => 'Hochregallager';

  @override
  String get sourceLabel => 'Quelle';

  @override
  String get deleteProjectTitle => 'Projekt löschen';

  @override
  String deleteProjectConfirm(String name) {
    return 'Projekt „$name“ löschen?';
  }

  @override
  String get noSavedProjects => 'Noch keine gespeicherten Projekte';

  @override
  String get saveProjectPrompt => 'Berechnung als Projekt speichern';

  @override
  String get saveProjectTitle => 'Projekt speichern';

  @override
  String get projectName => 'Projektname';

  @override
  String get projectNameExample => 'z. B. Bürogebäude Erdgeschoss';

  @override
  String projectSaved(String name) {
    return '„$name“ gespeichert';
  }

  @override
  String get copy => 'Kopieren';

  @override
  String get edit => 'Bearbeiten';

  @override
  String floorZoneSummary(int areas, int detectors) {
    return '$areas Bereiche · $detectors Melder';
  }

  @override
  String detectorBadge(int count) {
    return '$count Melder';
  }

  @override
  String get highCeilingNotice =>
      '⚠ H > 12 m — Linienförmige Rauchmelder / ASD erforderlich (EN 54-12 / EN 54-20)';

  @override
  String get beamRecommendation =>
      'ℹ H = 8–12 m — Linienförmige Melder können ebenfalls geprüft werden';

  @override
  String widthSpacing(Object value) {
    return 'Abstand in der Breite: $value m';
  }

  @override
  String lengthSpacing(Object value) {
    return 'Abstand in der Länge: $value m';
  }

  @override
  String wallDistanceWidth(Object value) {
    return 'Wandabstand W: $value m';
  }

  @override
  String wallDistanceLength(Object value) {
    return 'Wandabstand L: $value m';
  }

  @override
  String corridorSpacing(Object value) {
    return 'Flurabstand: $value m';
  }

  @override
  String wallDistance(Object value) {
    return 'Wandabstand: $value m';
  }

  @override
  String snAreaPerDetector(Object value) {
    return 'S_n = $value m²/Melder.';
  }

  @override
  String get systemLanguage => 'Gerätesprache';

  @override
  String get turkish => 'Türkçe';

  @override
  String get english => 'English';

  @override
  String get german => 'Deutsch';

  @override
  String get loginSubtitle => 'Melden Sie sich bei Ihrem Konto an';

  @override
  String get emailAddress => 'E-Mail-Adresse';

  @override
  String get emailRequired => 'E-Mail-Adresse ist erforderlich';

  @override
  String get validEmailRequired => 'Geben Sie eine gültige E-Mail-Adresse ein';

  @override
  String get password => 'Passwort';

  @override
  String get passwordRequired => 'Passwort ist erforderlich';

  @override
  String get loggingIn => 'Anmeldung läuft ...';

  @override
  String get login => 'Anmelden';

  @override
  String get demoLogin => 'Demo öffnen (Küchenhaubenlöschung)';

  @override
  String get accountPrompt => 'Sie haben noch kein Konto? ';

  @override
  String get register => 'Konto erstellen â†’';

  @override
  String get preliminaryToolDisclaimer =>
      'Vorläufiges Berechnungstool · Keine offizielle Projektberechnung';

  @override
  String get fireSafetyCalculator => 'Berechnungszentrum für Brandschutz';

  @override
  String get fireLoadTitle => 'Berechnung der Brandlast';

  @override
  String get fireLoadDescription =>
      'Brandlastdichte nach EN 1991-1-2 und Löschmittelberechnung nach ISO 14520 / EN 12845';

  @override
  String get kitchenSuppressionTitle => 'Küchenhaubenlöschanlage';

  @override
  String get kitchenSuppressionDescription =>
      'Löschanlage für gewerbliche Küchenhauben — NFPA 17A / TS EN 15751 / UL 300';

  @override
  String get gasSuppressionTitle => 'Gaslöschanlage';

  @override
  String get gasSuppressionDescription =>
      'Raumflutung und Druckmaschinen — EN 15004 / NFPA 2001 · FM-200 · Novec 1230 · CO₂ · Inertgase';

  @override
  String get lithiumFireTitle => 'Brand von Lithiumbatterien';

  @override
  String get lithiumFireDescription =>
      'Kühlungsanforderungen für ESS — ISO 3941:2026 · NFPA 855:2023 · IEC 62619 · FM Global DS 5-33';

  @override
  String get sprinklerTitle => 'Sprinkleranlage';

  @override
  String get sprinklerDescription =>
      'Hydraulische Berechnung, Pumpenauslegung und Rohrdurchmesser nach Gefahrenklasse gemäß EN 12845';

  @override
  String get smokeDetectionTitle => 'Rauchdetektion';

  @override
  String get smokeDetectionDescription =>
      'Melderanordnung und Raumtypen — EN 54-7 / EN 54-14';

  @override
  String get smokeControlTitle => 'Rauchschutz';

  @override
  String get smokeControlDescription =>
      'Natürliche und maschinelle Entrauchung, Druckbelüftung — EN 12101-2 / EN 12101-3 / EN 12101-6';

  @override
  String get demoMode =>
      'DEMOMODUS · Nur das Modul „Küchenhaubenlöschanlage“ ist verfügbar. Erstellen Sie ein Konto und schließen Sie ein Abonnement ab, um weitere Module zu nutzen.';

  @override
  String get standardSearch => 'Normensuche';

  @override
  String get standardSearchDescription =>
      'Brand- und Sicherheitsnormen nach Nummer, Titel oder Kategorie durchsuchen';

  @override
  String get standardGuide => 'Normenleitfaden';

  @override
  String get standardGuideDescription =>
      'Kategorien, Geltungsbereiche und Referenzübersicht für Brandschutzsystemnormen';

  @override
  String get fireAndSuppression => 'Brandlast und Löschung';

  @override
  String get kitchenSuppression => 'Küchenhaubenlöschung';

  @override
  String get gasSuppression => 'Gaslöschanlage';

  @override
  String get printingSuppression => 'Löschanlage für Druckmaschinen';

  @override
  String get sprinklerSystems => 'Sprinkleranlage';

  @override
  String get fireAlarm => 'Brandmeldung und Detektion';

  @override
  String get fireExtinguishers => 'Feuerlöscher';

  @override
  String get smokeControl => 'Rauchschutz und Evakuierung';

  @override
  String get savedProjects => 'Gespeicherte Projekte';

  @override
  String get savedProjectsDescription =>
      'Alle gespeicherten Berechnungsprojekte';

  @override
  String get addStandard => 'Norm hinzufügen';

  @override
  String get allCategories => 'Alle Kategorien';

  @override
  String get standardSearchHint => 'Nummer, Titel oder Kategorie ...';

  @override
  String standardsFound(int count) {
    return '$count Normen gefunden';
  }

  @override
  String category(String name) {
    return 'Kategorie: $name';
  }

  @override
  String get close => 'Schließen';

  @override
  String get searchWeb => 'Im Web suchen';

  @override
  String get askAi => 'KI fragen';

  @override
  String get moduleDisclaimer =>
      'MEVOS Fire · Vorläufiges Brandschutz-Berechnungstool, keine offizielle Projektberechnung.';

  @override
  String get hoodSystemDescription =>
      'Dimensionierung einer gewerblichen Küchenlöschanlage.\nReferenzen: NFPA 17A:2021 · TS EN 15751:2016 · UL 300 · Ansul R-102';

  @override
  String get hoodEquipmentHeading => 'Geräte unter der Haube';

  @override
  String get hoodEquipmentInstructions =>
      'Passen Sie die Geräteanzahl mit + / - an. Die Gefahrenklasse wird anhand Ihrer Auswahl automatisch berechnet.';

  @override
  String hoodHazardClass(Object category) {
    return 'Gefahrenklasse: $category';
  }

  @override
  String hoodEquipmentScore(Object count, Object score) {
    return 'Gerätebewertung: $score · $count ausgewählt · < 2 › Niedrig · 2–5 › Mittel · ≥ 5 › Hoch';
  }

  @override
  String get hoodFilterArea => 'Filterfläche der Haube (Innenmaß)';

  @override
  String get singleLength => 'Länge';

  @override
  String get singleWidth => 'Breite';

  @override
  String get hazardLight => 'Niedrig';

  @override
  String get hazardMedium => 'Mittel';

  @override
  String get hazardMediumHigh => 'Mittel–Hoch';

  @override
  String get hazardHigh => 'Hoch';

  @override
  String get hazardVeryHigh => 'Sehr hoch';

  @override
  String get hoodToastSandwichMachine => 'Toaster / Sandwichgerät';

  @override
  String get hoodSmallElectricOven => 'Kleiner Elektroofen';

  @override
  String get hoodConvectionOven => 'Umluftofen';

  @override
  String get hoodSingleBurnerRange => 'Herd (1 Kochstelle)';

  @override
  String get hoodDoubleBurnerRange => 'Herd (2 Kochstellen)';

  @override
  String get hoodFourToSixBurnerRange => 'Herd (4–6 Kochstellen)';

  @override
  String get hoodWokRange => 'Wokherd';

  @override
  String get hoodDoubleWokRange => 'Doppel-Wokherd';

  @override
  String get hoodSalamanderGrill => 'Salamandergrill';

  @override
  String get hoodCharbroilerGrill => 'Charbroiler / Grill';

  @override
  String get hoodFryerUpTo22L => 'Fritteuse (≤ 22 L)';

  @override
  String get hoodFryerOver22L => 'Fritteuse (> 22 L)';

  @override
  String get hoodTiltingSkillet => 'Kippbratpfanne';

  @override
  String get calculate => 'Berechnen';

  @override
  String get calculateExtinguishingAgent => 'Löschmittel berechnen';

  @override
  String get calculateCooling => 'Kühlbedarf berechnen';

  @override
  String get recalculate => 'Neu berechnen';

  @override
  String get calculationResults => 'Berechnungsergebnisse';

  @override
  String get noResults => 'Keine Ergebnisse gefunden';

  @override
  String get extinguishingAgent => 'Löschmittel';

  @override
  String get chemicalAgentAmount => 'Menge des chemischen Löschmittels';

  @override
  String get minimumNozzleCount => 'Mindestanzahl der Düsen';

  @override
  String get minimumDischargeTime => 'Mindest-Austrittszeit';

  @override
  String get systemType => 'Systemtyp';

  @override
  String get naturalExhaust => 'Natürliche Entrauchung';

  @override
  String get mechanicalExhaust => 'Maschinelle Entrauchung';

  @override
  String get pressurization => 'Druckbelüftung';

  @override
  String get roomArea => 'Raumfläche';

  @override
  String get ceilingHeight => 'Deckenhöhe';

  @override
  String get designFirePower => 'Bemessungs-HRR (Brandlastleistung)';

  @override
  String get ambientTemperature => 'Umgebungstemperatur';

  @override
  String get doorWidth => 'Türbreite';

  @override
  String get doorHeight => 'Türhöhe';

  @override
  String get stairShaftWidth => 'Breite des Treppenraums';

  @override
  String get stairShaftDepth => 'Tiefe des Treppenraums';

  @override
  String get floorHeight => 'Geschosshöhe';

  @override
  String get floorCount => 'Anzahl der Geschosse';

  @override
  String get shaftWallMaterial => 'Material der Schachtwand';

  @override
  String get extinguishingDesignResult => 'Ergebnis der Löschanlagen-Auslegung';

  @override
  String get smokeTemperature => 'Rauchgastemperatur';

  @override
  String get temperatureRise => 'Temperaturanstieg';

  @override
  String get effectiveOpening => 'Erforderliche freie Öffnungsfläche';

  @override
  String get freshAirInlet => 'Mindest-Zuluftöffnung';

  @override
  String get fanDesignFlow => 'Auslegungsvolumenstrom des Ventilators';

  @override
  String get calculatedAirChanges => 'Berechneter Luftwechsel';

  @override
  String get targetPressureDifference => 'Soll-Druckdifferenz';

  @override
  String get openDoorFlow => 'Volumenstrom bei offener Tür';

  @override
  String get closedDoorLeakage => 'Leckage bei geschlossener Tür / Geschoss';

  @override
  String get wallLeakage => 'Wandleckage (alle Geschosse)';

  @override
  String get totalFanFlow => 'Gesamtvolumenstrom des Ventilators';

  @override
  String get sourceStandards => 'Referenznormen';

  @override
  String get unknown => 'Unbekannt';

  @override
  String get smokeControlStandards =>
      'EN 12101-2 Natürlich · EN 12101-3 Maschinell · EN 12101-6 Druckbelüftung';

  @override
  String get designFirePowerHint =>
      'Bemessungsbrandlast — EN 1991-1-2 Anhang E. Beispiel: Büro mit mittlerem Risiko ≈ 500 kW';

  @override
  String get unknownFirePowerButton => 'HRR unbekannt — Brandlast berechnen';

  @override
  String get smokeLayerHeight => 'Höhe der Rauchschichtgrenze z';

  @override
  String get smokeLayerHeightHint =>
      'Obergrenze der klaren Luftschicht, gemessen ab Fußboden. z muss < H sein. Ziel z ≥ 2,5 m';

  @override
  String get pressurizationConditions =>
      'Soll-ΔP = 50 Pa, Türspalt 10 mm (EN 12101-6 §7.3.3 / Anhang F Tabelle F.1)';

  @override
  String get naturalExhaustResult =>
      'Ergebnisse natürliche Entrauchung (EN 12101-2)';

  @override
  String get mechanicalExhaustResult =>
      'Ergebnisse maschinelle Entrauchung (EN 12101-3)';

  @override
  String get pressurizationResult => 'Ergebnisse Druckbelüftung (EN 12101-6)';

  @override
  String get smokeMassFlow => 'Rauchmassenstrom';

  @override
  String get smokeVolumeFlow => 'Rauchvolumenstrom';

  @override
  String get minimumFreshAir => 'Mindest-Zuluftöffnung';

  @override
  String get batteryTechnology => 'Batterietechnologie';

  @override
  String get nmcDescription =>
      'Nickel-Mangan-Kobalt · 30 MJ/kWh — Hohe Energiedichte, mittlere Stabilität';

  @override
  String get lfpDescription =>
      'Lithium-Eisenphosphat · 12 MJ/kWh — Geringere Wärmefreisetzung, hohe Sicherheit';

  @override
  String get ncaDescription =>
      'Nickel-Kobalt-Aluminium · 35 MJ/kWh — Höchste Energiedichte';

  @override
  String get lcoDescription =>
      'Lithium-Kobaltoxid · 35 MJ/kWh — Unterhaltungselektronik';

  @override
  String get essLithiumFireInfo =>
      'ISO 3941:2026 · NFPA 855:2023 · IEC 62619:2022 · FM Global DS 5-33\nBei Lithium-Ionen-/Polymer-Batteriebränden ist aufgrund des thermischen Durchgehens (Thermal Runaway) Kühlung – nicht die Gaslöschung – maßgeblich. Die folgende Berechnung dient nur der Vorauslegung.';

  @override
  String get nmcThermalRunawayNote =>
      'NMC/NCM: Nickel-Mangan-Kobalt — 30 MJ/kWh Wärmeenergie beim thermischen Durchgehen (IEC 62619)';

  @override
  String get lfpThermalRunawayNote =>
      'LFP: Lithium-Eisenphosphat — 12 MJ/kWh Wärmeenergie beim thermischen Durchgehen (IEC 62619)';

  @override
  String get ncaThermalRunawayNote =>
      'NCA: Nickel-Kobalt-Aluminium — 35 MJ/kWh Wärmeenergie beim thermischen Durchgehen (IEC 62619)';

  @override
  String get lcoThermalRunawayNote =>
      'LCO: Lithium-Kobaltoxid — 35 MJ/kWh Wärmeenergie beim thermischen Durchgehen (IEC 62619)';

  @override
  String get hazardClassificationBasisNote =>
      'NFPA 855:2023 §4.4.2 — Grundlage der Gefahrenklassifizierung';

  @override
  String get fmGlobalMinDurationNote =>
      'FM Global DS 5-33 Mindestdauer: 30 min  —  NFPA 855:2023 §12.4';

  @override
  String get essHazardCategoryInfo =>
      'NFPA 855:2023 Gefahrenkategorie & FM DS 5-33 Anwendungsdichte:\n  • Niedrig  (< 20 kWh)  ›  8,2 L/min/m²\n  • Mittel   (20–600 kWh)  ›  12,2 L/min/m²\n  • Hoch (> 600 kWh)  ›  16,3 L/min/m²';

  @override
  String get essResultsFooterNote =>
      '• Wärmekoeffizient: NMC 30 · LFP 12 · NCA/LCO 35 MJ/kWh  (IEC 62619:2022)\n• Spitzen-HRR-Koeffizient: NMC 3,0 · LFP 1,5 · NCA/LCO 3,5 kW/kWh  (SP 2022:08)\n• t²-Wachstum: α=0,0469 kW/s² (schnelle Klasse · ISO 16734 / NFPA 72)\n• F-500-Konzentration: 1,5 % (Herstellertestdaten — Enviro Voraxial)\n• Alternative Wassernebel: NFPA 750 / TS EN 14972-1\n• Große ESS (> 600 kWh): IEC 63272-, UL 9540A-Tests zwingend erforderlich\n• Diese Berechnung dient nur der Vorauslegung. Ein von FM Global DS 5-33 zugelassenes System ist erforderlich.';

  @override
  String get evLithiumFireInfo =>
      'ISO 6469 · NFPA 88A:2021 · VdS 3471:2023 · IEC 62619:2022\nBei Elektrofahrzeugbränden wird das thermische Durchgehen durch Kühlung beherrscht; Gas- oder Pulverlöschung ist wirkungslos.';

  @override
  String get passengerCarSpecNote =>
      'PKW — 30–100 kWh\n400–600 L/min · 60 min Mindestdauer (VdS 3471)';

  @override
  String get lightCommercialSpecNote =>
      'Transporter / Kleinbus — 60–120 kWh\n600 L/min · 60 min Mindestdauer';

  @override
  String get heavyCommercialSpecNote =>
      'Elektrobus/-lkw — 200–600 kWh\n1.000 L/min · 90 min Mindestdauer';

  @override
  String get nmcHeatValue => 'Nickel-Mangan-Kobalt — 30 MJ/kWh';

  @override
  String get lfpHeatValue => 'Lithium-Eisenphosphat — 12 MJ/kWh';

  @override
  String get ncaHeatValue => 'Nickel-Kobalt-Aluminium — 35 MJ/kWh';

  @override
  String get lcoHeatValue => 'Lithium-Kobaltoxid — 35 MJ/kWh';

  @override
  String get vehicleBatteryCapacityNote =>
      'Batteriekapazität eines einzelnen Fahrzeugs — Grundlage der Berechnung des thermischen Durchgehens nach IEC 62619';

  @override
  String get maxSimultaneousVehiclesNote =>
      'VdS 3471:2023 — max. 2 gleichzeitig brennende Fahrzeuge angenommen';

  @override
  String get vehicleApplicationDurationNote =>
      'PKW / leichte Nutzfahrzeuge min. 60 min · schwere Nutzfahrzeuge min. 90 min  (VdS 3471:2023)';

  @override
  String get vdsMinimumFlowInfo =>
      'VdS 3471:2023 Mindestdurchfluss pro Fahrzeug:\n  • PKW < 60 kWh  ›  400 L/min\n  • PKW ? 60 kWh  ›  600 L/min\n  • Leichtes Nutzfahrzeug           ›  600 L/min\n  • Schweres Nutzfahrzeug / Bus  ›  1.000 L/min';

  @override
  String get evResultsFooterNote =>
      '• Wärmekoeffizient: NMC 30 · LFP 12 · NCA/LCO 35 MJ/kWh  (IEC 62619:2022)\n• Spitzen-HRR: PKW <60kWh›3MW, ?60kWh›6MW · leichtes Nutzfahrzeug›8MW · schwer›15MW  (SP 2021:11)\n• t²-Wachstumsmodell: ?=0,1876 kW/s² (ultra-fast · ISO 16734 / NFPA 72 Tabelle B.2.3)\n• Wasserdurchfluss: VdS 3471:2023 — 2 Fahrzeuge gleichzeitig (Parkgarage)\n• Container-Eintauchung: 3.000 L/Fahrzeug (BRE Global / SFPE)\n• Geschlossene Parkgarage: NFPA 88A:2021 Sprinkler erforderlich\n• Diese Berechnung dient nur der Vorauslegung.';

  @override
  String heatPerVehicleMj(String value) {
    return '$value MJ/Fahrzeug';
  }

  @override
  String avgHrrPerVehicleMw(String value) {
    return '$value MW/Fahrzeug';
  }

  @override
  String get installedCapacity => 'Installierte Kapazität (ESS)';

  @override
  String get protectedArea => 'Geschützte Fläche (ESS-Aufstellfläche)';

  @override
  String get applicationDuration => 'Anwendungsdauer';

  @override
  String get batteryCapacity => 'Fahrzeug-Batteriekapazität';

  @override
  String get vehicleCount => 'Anzahl Fahrzeuge (Risikobereich)';

  @override
  String get vehicleType => 'Fahrzeugtyp';

  @override
  String get passengerCar => 'Pkw';

  @override
  String get lightCommercial => 'Leichtes Nutzfahrzeug';

  @override
  String get heavyCommercialBus => 'Schweres Nutzfahrzeug / Bus';

  @override
  String get essStationary => 'ESS / Stationärer Speicher';

  @override
  String get electricVehicleMode => 'Elektrofahrzeug';

  @override
  String get coolingCalculationResult => 'Ergebnis der Kühlberechnung';

  @override
  String get electricVehicleFireResult =>
      'Brandberechnung für Elektrofahrzeuge';

  @override
  String get thermalRunawayHeat =>
      'Wärmefreisetzung beim thermischen Durchgehen';

  @override
  String get estimatedPeakHrr => 'Geschätzte HRR-Spitze';

  @override
  String get timeToPeak => 'Zeit bis zur Spitze';

  @override
  String get minimumFlowRate => 'Mindestvolumenstrom';

  @override
  String get totalWaterVolume => 'Gesamtwasservolumen';

  @override
  String get f500Amount => 'F-500-Menge (1,5-%-Lösung)';

  @override
  String get averageHeatReleaseRate => 'Mittlere Wärmefreisetzungsrate (HRR)';

  @override
  String get vehicleMinimumFlow => 'Mindestvolumenstrom je Fahrzeug';

  @override
  String get simultaneousVehicleFlow =>
      'Gesamtvolumenstrom (max. 2 Fahrzeuge gleichzeitig)';

  @override
  String get containerImmersion => 'Container-Eintauchung (Alternative)';

  @override
  String get fireRiskCategory => 'Gefahrenkategorie nach NFPA 855';

  @override
  String get netProtectionVolume => 'Netto-Schutzvolumen';

  @override
  String get minimumDesignTemperature => 'Mindest-Auslegungstemperatur';

  @override
  String get altitudeCorrection => 'Höhenkorrektur (TS EN 15004-1 Anhang A)';

  @override
  String get safetyMargin => '10 % Sicherheitszuschlag (TS EN 15004-1 §5.5)';

  @override
  String get fireClass => 'Brandklasse';

  @override
  String get surfaceClassA => 'Klasse A (Oberflächenbrand)';

  @override
  String get deepClassA => 'Klasse A (Tiefenbrand)';

  @override
  String get classB => 'Klasse B';

  @override
  String get classC => 'Klasse C';

  @override
  String get gasAgent => 'Löschgas';

  @override
  String get designConcentration => 'Auslegungskonzentration (%)';

  @override
  String get dischargeDuration => 'Austrittszeit';

  @override
  String get nozzleDiameter => 'Düsendurchmesser';

  @override
  String get automaticNozzle => 'Automatisch (flächen-/volumenbasiert)';

  @override
  String get roomDimensions => 'Raummaße';

  @override
  String get directVolume => 'Direkte Volumeneingabe';

  @override
  String get gasRoomTab => 'Raum';

  @override
  String get gasPrintingTab => 'Druckmaschine';

  @override
  String get gasPanelTab => 'Im Schaltschrank';

  @override
  String get machineType => 'Maschinentyp';

  @override
  String get inkSolventType => 'Tinte / Lösungsmitteltyp';

  @override
  String get measureCabinet => 'Schrank ausmessen';

  @override
  String get unitCabinetVolume => 'Schrankvolumen je Einheit';

  @override
  String get printingUnitCount => 'Anzahl der Druckeinheiten';

  @override
  String get agentPerUnit => 'Löschmittel je Einheit';

  @override
  String get totalAgent => 'Gesamtmenge des Löschmittels';

  @override
  String get backupCylinderCount => 'Anzahl Reserveflaschen';

  @override
  String get totalCylinders => 'Gesamtzahl Flaschen (Haupt + Reserve)';

  @override
  String get cleanAgent => 'Sauberes Löschmittel';

  @override
  String get panelDimensions => 'Schaltschrankmaße';

  @override
  String get panelCabinetVolume => 'Schaltschrankvolumen';

  @override
  String get standard => 'Norm';

  @override
  String get certification => 'Zertifizierung';

  @override
  String get maximumTubingLength => 'Maximale Schlauchlänge';

  @override
  String get estimatedAgentAmount => 'Geschätzte Löschmittelmenge';

  @override
  String get buildingDimensions => 'Gebäudeabmessungen';

  @override
  String get buildingActivity => 'Gebäudenutzung';

  @override
  String get activitySearch => 'Nutzungsart suchen…';

  @override
  String get advancedDesignOptions => 'Erweiterte Auslegungsoptionen';

  @override
  String get pipeMaterial => 'Rohrmaterial';

  @override
  String get spPipeGalvanizedSteel => 'Verzinkter Stahl (Sch.40)';

  @override
  String get spPipeBlackCarbonSteelWelded =>
      'Schwarzer Kohlenstoffstahl — geschweißt';

  @override
  String get spPipeCopper => 'Kupferrohr';

  @override
  String get spPipeStainlessSteel => 'Edelstahl';

  @override
  String get spPipeCpvcPlastic => 'CPVC-Kunststoffrohr';

  @override
  String get sprinklerType => 'Sprinklertyp (K-Faktor)';

  @override
  String get installationClassPump => 'Anlagenklasse / Pumpenredundanz';

  @override
  String get dryPipeSystem => 'Trockenrohrsystem (frostgefährdete Bereiche)';

  @override
  String get rackStorage =>
      'Regal- / Palettenlagerung — In-Rack-Sprinkler (Vorplanung)';

  @override
  String get rackLevels => 'Regalebenen (In-Rack-Ebenen)';

  @override
  String get foamSystem => 'Schaumlöschanlage';

  @override
  String get addFoamSystem => 'Schaumlöschanlage hinzufügen (EN 13565-2)';

  @override
  String get flammableLiquidCategory => 'Kategorie der brennbaren Flüssigkeit';

  @override
  String get hydrocarbon => 'Kohlenwasserstoff (B1)';

  @override
  String get polarSolvent => 'Polar-Lösemittel (B2)';

  @override
  String get foamConcentrateType => 'Schaummittelkonzentrat';

  @override
  String get foamType => 'Schaumtyp';

  @override
  String get minimumApplicationTime => 'Mindest-Anwendungsdauer';

  @override
  String get ceilingSuspended => 'Abgehängte Decke';

  @override
  String get suspendedCeilingExists => 'Abgehängte Decke vorhanden (Hohlraum)';

  @override
  String get voidDepth => 'Hohlraumtiefe (cm)';

  @override
  String get building => 'Gebäude';

  @override
  String get electricalPanel => 'Schaltschrank';

  @override
  String get fuelOrStorage => 'Brennstoff / Lager';

  @override
  String get buildingUseType => 'Gebäude- / Nutzungsart';

  @override
  String get chooseBuildingUseType => 'Gebäude- / Nutzungsart auswählen';

  @override
  String get referenceDensity => 'Referenz-Brandlastdichte';

  @override
  String get growthRate => 'Brandwachstumsrate';

  @override
  String get growthRateVerySlow => 'Sehr Langsam';

  @override
  String get growthRateSlow => 'Langsam';

  @override
  String get growthRateMedium => 'Mittel';

  @override
  String get growthRateFast => 'Schnell';

  @override
  String get growthRateVeryFast => 'Sehr Schnell';

  @override
  String get floorArea => 'Geschossfläche A (m²)';

  @override
  String get cabinetNozzlePressure => 'Druck am Wandhydranten (mind. 4 bar)';

  @override
  String get combustibleMaterials => 'Brennbare Materialien';

  @override
  String get addMaterial => 'Material hinzufügen';

  @override
  String get woodTimber => 'Holz / Bauholz';

  @override
  String get savedValues => 'Gespeicherte Werte';

  @override
  String get noSavedCalculationResult =>
      'Für dieses Projekt ist kein gespeichertes Berechnungsergebnis vorhanden.';

  @override
  String get apiKeyEnter => 'Gemini-API-Schlüssel eingeben';

  @override
  String get searchBuildingTypes => 'Gebäudearten suchen…';

  @override
  String get material => 'Material';

  @override
  String get massKg => 'Masse (kg)';

  @override
  String get netCalorificValue => 'Heizwert (MJ/kg)';

  @override
  String get capacityTank => 'Kapazität / Tank';

  @override
  String get unit => 'Einheit';

  @override
  String get quantity => 'Anzahl';

  @override
  String get standardNumber => 'Normnummer *';

  @override
  String get standardNumberExample => 'z. B. EN 12345';

  @override
  String get description => 'Beschreibung *';

  @override
  String get shortDescriptionHint => 'Kurze Beschreibung der Norm…';

  @override
  String get topicKeyword => 'Thema oder Stichwort';

  @override
  String get topicKeywordExample => 'z. B. Rauchschürze, Bürosprinkler…';

  @override
  String get questionHint => 'Frage eingeben…';

  @override
  String get searchActivity => 'Nutzungsarten suchen…';

  @override
  String get unitWidth => 'B (m)';

  @override
  String get unitLength => 'L (m)';

  @override
  String get unitHeight => 'H (m)';

  @override
  String get searchMaterials => 'Materialien suchen…';

  @override
  String get solid => 'Feststoffe';

  @override
  String get liquid => 'Flüssigkeiten';

  @override
  String get gas => 'Gase';

  @override
  String get other => 'Sonstiges';

  @override
  String get lowHazardAppendix => 'Geringe Gefahr (Anhang 1/A)';

  @override
  String get ordinaryHazardAppendix => 'Mittlere Gefahr (Anhang 1/B)';

  @override
  String get highHazardAppendix => 'Hohe Gefahr (Anhang 1/C)';

  @override
  String get unclassified => 'Nicht klassifiziert';

  @override
  String materialGroupCount(String category, int count) {
    return '$category · $count Materialien';
  }

  @override
  String get materialWoodTimber => 'Holz / Bauholz';

  @override
  String get materialPlywoodMdf => 'Sperrholz / MDF';

  @override
  String get materialPaperCardboard => 'Papier / Karton';

  @override
  String get materialCottonTextile => 'Textilien (Baumwolle)';

  @override
  String get materialSyntheticTextile => 'Textilien (Kunstfaser)';

  @override
  String get materialWool => 'Wolle';

  @override
  String get materialClothing => 'Kleidung';

  @override
  String get materialLeather => 'Leder';

  @override
  String get materialPolyethylene => 'Polyethylen (PE)';

  @override
  String get materialPolypropylene => 'Polypropylen (PP)';

  @override
  String get materialRigidPvc => 'PVC (hart)';

  @override
  String get materialFlexiblePvc => 'PVC (flexibel/Kabel)';

  @override
  String get materialPolystyrene => 'Polystyrol (PS)';

  @override
  String get materialEpsFoam => 'EPS-Schaum';

  @override
  String get materialXpsFoam => 'XPS-Schaum';

  @override
  String get materialAbsPlastic => 'ABS-Kunststoff';

  @override
  String get materialPmma => 'PMMA (Acrylglas)';

  @override
  String get materialEpoxyResin => 'Epoxidharz';

  @override
  String get materialPolyesterResin => 'Polyesterharz (GFK/CFK)';

  @override
  String get materialRigidPolyurethaneFoam => 'Polyurethanschaum (hart)';

  @override
  String get materialFlexiblePolyurethaneFoam => 'Polyurethanschaum (flexibel)';

  @override
  String get materialNaturalRubber => 'Kautschuk (Natur)';

  @override
  String get materialVehicleTire => 'Reifen (Fahrzeug)';

  @override
  String get materialGasoline => 'Benzin';

  @override
  String get materialDiesel => 'Diesel';

  @override
  String get materialLpg => 'LPG';

  @override
  String get materialPropane => 'Propan';

  @override
  String get materialNaturalGasCng => 'Erdgas (CNG)';

  @override
  String get materialMethanol => 'Methanol';

  @override
  String get materialEthanol => 'Ethanol';

  @override
  String get materialAcetoneSolvent => 'Aceton / Lösemittel (allgemein)';

  @override
  String get materialSolventBasedPaint => 'Farbe / Lack (lösemittelhaltig)';

  @override
  String get materialAsphaltBitumen => 'Asphalt / Bitumen';

  @override
  String get materialCoal => 'Kohle';

  @override
  String get materialMineralTransformerOil => 'Transformatorenöl (mineralisch)';

  @override
  String get materialHydraulicOil => 'Hydrauliköl';

  @override
  String get materialPvcCable => 'Elektrokabel (PVC)';

  @override
  String get materialXlpeCable => 'Elektrokabel (XLPE)';

  @override
  String get materialLithiumIonBattery => 'Li-Ionen-Batterie';

  @override
  String get materialMixedFurniture => 'Möbel (gemischt)';

  @override
  String get materialOtherManual => 'Sonstiges (manuell)';

  @override
  String get fireLoadFormulaInfo =>
      'q = (m × H) / A\nm = Masse des brennbaren Materials (kg)  ·  H = NCV (MJ/kg)  ·  A = Grundfläche (m²)';

  @override
  String get panelInnerDimensions => 'Innenmaße des Schaltschranks (cm)';

  @override
  String get panelWidth => 'Breite';

  @override
  String get panelHeight => 'Höhe';

  @override
  String get panelDepth => 'Tiefe';

  @override
  String cableFillRatio(Object value) {
    return 'Kabelfüllgrad: % $value';
  }

  @override
  String get fuelStorageInstructions =>
      'Geben Sie für jeden Tanktyp die Menge und Kapazität ein.\nFür LPG können Sie Tonnen verwenden, für Flüssigbrennstoffe m³ oder Tonnen.\nDie Auffangwannen-/Beckenfläche ist für die Brandlastdichte optional.';

  @override
  String get fuelChemicalTanks => 'Kraftstoff-/Chemikalientanks';

  @override
  String totalApproxMass(Object value) {
    return 'Ungefähre Gesamtmasse: $value t';
  }

  @override
  String get bundPoolArea => 'Auffangwannen-/Beckenfläche  (m²)  —  optional';

  @override
  String get fireLoadDensityIfEntered =>
      'Wenn eingegeben, wird die Brandlastdichte (MJ/m²) berechnet.';

  @override
  String get ventilationLimitedQmaxInclude =>
      'Lüftungsbegrenztes Q_max in die Berechnung einbeziehen (optional)';

  @override
  String get ventilationLimitedQmaxNote =>
      'Hinweis: Die Standardberechnung verwendet nur das brennstoffflächenbegrenzte Q_max (RHRf×A); das öffnungsbegrenzte (Fenster/Tür) Q_max wird nicht berücksichtigt (EN 1991-1-2 Anhang E).';

  @override
  String get openingArea => 'Öffnungsfläche (Fenster/Tür)  Aᵥ';

  @override
  String get openingHeight => 'Öffnungshöhe  h_eq';

  @override
  String get openingAreaHeightExplanation =>
      'Aᵥ: Gesamtfläche aller Fenster-/Türöffnungen im Raum  ·  h_eq: durchschnittliche Höhe dieser Öffnungen (NICHT die Raumhöhe).';

  @override
  String get ventilationQmaxFormulaNote =>
      'Q̇ₘₐₓ,ᵥ ≈ 0,09×Aᵥ×√h_eq × Hu_Durchschnitt × 0,8  —  ungefährer Kawagoe-Lüftungsfaktor (Drysdale / SFPE); für die exakte Auslegung ist eine vollständige Öffnungsfaktorberechnung erforderlich.';

  @override
  String get totalFireEnergyLabel => 'GESAMTE BRANDENERGIE';

  @override
  String get totalEnergy => 'Gesamtenergie';

  @override
  String get totalEnergyGJ => 'Gesamtenergie (GJ)';

  @override
  String get totalEnergyMWh => 'Gesamtenergie (MWh)';

  @override
  String get totalEnergyGWh => 'Gesamtenergie (GWh)';

  @override
  String get bundAreaIfEnteredNote =>
      'Wenn die Auffangwannen-/Beckenfläche eingegeben wird, wird die Brandlastdichte (MJ/m²) berechnet.';

  @override
  String get calculationResultLabel => 'BERECHNUNGSERGEBNIS';

  @override
  String get totalFireLoad => 'Gesamtbrandlast';

  @override
  String get fireLoadDensityLabel => 'Brandlastdichte  q';

  @override
  String exceedsReferenceLabel(Object value) {
    return '^ +$value MJ/m² — ÜBERSCHREITET Referenz';
  }

  @override
  String belowReferenceLabel(Object value) {
    return ' $value MJ/m² — Unter Referenz';
  }

  @override
  String get fireGrowthTimeline => 'Brandwachstumszeitplan (EN 1991-1-2 E.4)';

  @override
  String get growthPhaseEnd => 'Ende der Wachstumsphase';

  @override
  String get decayPhaseStart => 'Beginn der Abklingphase (% 70 Verbrauch)';

  @override
  String get totalFireDuration => 'Gesamtbranddauer';

  @override
  String peakHeatReleaseLabel(Object factor, Object value) {
    return 'Spitzen-Q̇: $value MW  ·  Begrenzender Faktor: $factor';
  }

  @override
  String get limitingFactorFuelSurface => 'Brennstofffläche (RHRf × A)';

  @override
  String get limitingFactorTotalEnergy => 'Gesamtenergie (niedrige Brandlast)';

  @override
  String get limitingFactorVentilation => 'Lüftung (Öffnung — näherungsweise)';

  @override
  String get extinguishingAgentCalcTitle => 'Berechnung des Löschmittels';

  @override
  String panelVolumeHeight(Object value) {
    return 'Rauminnenhöhe (Schaltschrank): $value';
  }

  @override
  String get panelAgentRecommendation =>
      'Für Schaltschränke wird FM-200 (HFC-227ea) oder Novec 1230 empfohlen — ISO 14520 / NFPA 2001.';

  @override
  String get extinguishingAgentLabel => 'Löschmittel';

  @override
  String get altitudeCorrectionLabel => 'Höhenkorrektur (ISO 14520-1 Anhang A)';

  @override
  String get altitudeLabel => 'Höhe über NN (m)';

  @override
  String get requiredAgent => 'Erforderliches Löschmittel';

  @override
  String get requiredAgentMass => 'Erforderliche Löschmittelmasse';

  @override
  String get cylinderCountApprox => 'Flaschenanzahl (80L/200bar≈16Nm³)';

  @override
  String get cylinderContainerCount => 'Flaschen-/Behälteranzahl';

  @override
  String get portableExtinguisherTitle =>
      'Tragbarer Feuerlöscher (TS 862-7 EN 3-7)';

  @override
  String get fireLoadSourcesFooter =>
      'Quelle: EN 1991-1-2:2002 Anhang E · ISO 14520 · EN 12845 · TS 862-7 EN 3-7+A1';

  @override
  String get portableExtinguisherSourceFooter =>
      'Quelle: TS 862-7 EN 3-7+A1 (2010) · BYKHY Artikel 94-96';

  @override
  String get fireCabinetSourceFooter =>
      'Quelle: BYKHY Art. 91-93 · TS EN 671-1 · TS 9811';

  @override
  String get fireCabinetTitle => 'Wandhydrant (BYKHY Art. 91-93 / TS EN 671-1)';

  @override
  String fireCabinetTechSpecs(Object capacity, Object flow, Object p) {
    return 'DN25 (1\") halbstarre Schlauchhaspel · TS EN 671-1 · K=50\nQ = K × √P = 50 × √$p bar = $flow L/min\nPraktische Löschkapazität:\n  $capacity';
  }

  @override
  String get classACapacityPerCabinet => 'Klasse A: 2,0 MW/Schrank';

  @override
  String get classBCapacityPerCabinet => 'Klasse B: 0,6 MW/Schrank';

  @override
  String get hazardClassLabel => 'Gefahrenklasse';

  @override
  String get hazardClassLow => 'Niedrig';

  @override
  String get hazardClassMedium => 'Mittel';

  @override
  String get hazardClassHigh => 'Hoch';

  @override
  String get requiredCabinetCount => 'Erforderliche Anzahl Wandhydranten';

  @override
  String get totalExtinguishingCapacityLabel => 'Gesamtlöschkapazität';

  @override
  String waterReserveVolumeLabel(Object minutes) {
    return 'Wasserreservevolumen ($minutes Min)';
  }

  @override
  String cabinetSufficientLabel(Object count, Object load, Object q) {
    return '$count Wandhydrant(e) AUSREICHEND  —  Löschleistung $q MW ≥ Brandlast $load MW';
  }

  @override
  String cabinetInsufficientLabel(
    Object count,
    Object load,
    Object minNeeded,
    Object q,
  ) {
    return '$count Wandhydrant(e) NICHT AUSREICHEND  —  Löschleistung $q MW < Brandlast $load MW (mind. $minNeeded erforderlich)';
  }

  @override
  String get roomHeightLabel => 'Raumhöhe (m)';

  @override
  String get fireClassPanel =>
      'Klasse B/C (Öl/Gas elektrischer Anlagen) — Pulver oder CO₂';

  @override
  String get fireClassGasStorage =>
      'Klasse C (komprimiertes brennbares Gas) — ABC-Pulver, CO₂ oder Schaum';

  @override
  String get fireClassLiquidGasStorage =>
      'Klasse B + Klasse C (Flüssig-/Gaskraftstoff) — ABC-Pulver oder Schaum';

  @override
  String get fireClassLiquidStorage =>
      'Klasse B (brennbare Flüssigkeit) — ABC-Pulverlöscher oder Schaum';

  @override
  String get fireClassSolidLiquidStorage =>
      'Klasse A + Klasse B (fester/flüssiger brennbarer Stoff) — ABC-Pulverlöscher';

  @override
  String get fireClassParking =>
      'Klasse B (Flüssigkraftstoff) — ABC-Pulver oder Schaum';

  @override
  String get fireClassSolidDefault =>
      'Klasse A (fester brennbarer Stoff) — ABC-Pulverlöscher oder Wasser';

  @override
  String get riskClassLow => 'Niedriges Risiko  (≤ 200 MJ/m²)';

  @override
  String get riskClassMedium => 'Mittleres Risiko  (200–600 MJ/m²)';

  @override
  String get riskClassHigh => 'Hohes Risiko  (600–1200 MJ/m²)';

  @override
  String get riskClassVeryHigh => 'Sehr hohes Risiko  (> 1200 MJ/m²)';

  @override
  String get loginServerUnreachable =>
      'Verbindung zum Server nicht möglich. Überprüfen Sie Ihre Internetverbindung.';

  @override
  String genericErrorWithDetail(String detail) {
    return 'Fehler: $detail';
  }

  @override
  String fireModuleSubscriptionMissing(String perms) {
    return 'Sie haben kein aktives Abonnement für das Brandschutzmodul. Starten Sie ein Abonnement über Ihr Konto.\nVom Server erhaltene Berechtigungen: $perms';
  }

  @override
  String get loginFailed => 'Anmeldung fehlgeschlagen';

  @override
  String get sessionNotFoundRelogin =>
      'Sitzung nicht gefunden. Bitte melden Sie sich erneut an.';

  @override
  String get accountDeleteFailed => 'Konto konnte nicht gelöscht werden.';

  @override
  String get enterPanelInnerDimensionsCm =>
      'Geben Sie die vollständigen Innenmaße des Schaltschranks ein (cm).';

  @override
  String get addAtLeastOneFuelTank =>
      'Fügen Sie mindestens einen Brennstofftank hinzu.';

  @override
  String enterQuantityForFuel(String name) {
    return 'Geben Sie eine Menge für „$name“ ein.';
  }

  @override
  String get enterValidFloorAreaM2 =>
      'Geben Sie eine gültige Geschossfläche ein (m²).';

  @override
  String materialMassMissing(String name) {
    return 'Für „$name“ fehlt die Masse.';
  }

  @override
  String materialNcvMissing(String name) {
    return 'Für „$name“ fehlt der Heizwert.';
  }

  @override
  String get calculateFireLoadFirst => 'Berechnen Sie zuerst die Brandlast.';

  @override
  String get enterValidArea => 'Geben Sie eine gültige Fläche ein.';

  @override
  String get enterRoomHeightM => 'Geben Sie die Raumhöhe ein (m).';

  @override
  String get enterHoodLengthWidthCm =>
      'Geben Sie Länge und Breite der Dunstabzugshaube ein (cm).';

  @override
  String get enterRoomDimensionsFullyM =>
      'Geben Sie die vollständigen Raummaße ein (m).';

  @override
  String get enterNetProtectedVolumeM3 =>
      'Geben Sie das Netto-Schutzvolumen ein (m³).';

  @override
  String get enterValidConcentrationPercent =>
      'Geben Sie einen gültigen Konzentrationswert ein (0–100 %).';

  @override
  String get enterValidUnitCount1to50 =>
      'Geben Sie eine gültige Anzahl an Einheiten ein (1–50).';

  @override
  String get enterMachineCabinDimensionsFullyM =>
      'Geben Sie die vollständigen Maße des Maschinengehäuses ein (m).';

  @override
  String get enterUnitCabinVolumeM3 =>
      'Geben Sie das Volumen des Einheitengehäuses ein (m³).';

  @override
  String get enterPanelCabinDimensionsFullyM =>
      'Geben Sie die vollständigen Maße des Schaltschranks/Gehäuses ein (m).';

  @override
  String get enterPanelCabinVolumeM3 =>
      'Geben Sie das Volumen des Schaltschranks/Gehäuses ein (m³).';

  @override
  String get enterRoomAreaM2 => 'Geben Sie die Raumfläche ein (m²).';

  @override
  String get enterCeilingHeightM => 'Geben Sie die Deckenhöhe ein (m).';

  @override
  String get enterDesignHrrKw => 'Geben Sie die Bemessungs-HRR ein (kW).';

  @override
  String get smokeLayerHeightRangeError =>
      'Basishöhe der Rauchschicht: 0 < z < H';

  @override
  String get enterInstalledCapacityKwh =>
      'Geben Sie die installierte Kapazität ein (kWh).';

  @override
  String get enterProtectionAreaM2 => 'Geben Sie die Schutzfläche ein (m²).';

  @override
  String get enterApplicationDurationMin =>
      'Geben Sie die Anwendungsdauer ein (min).';

  @override
  String get enterVehicleBatteryCapacityKwh =>
      'Geben Sie die Fahrzeugbatteriekapazität ein (kWh).';

  @override
  String get enterVehicleCount => 'Geben Sie die Anzahl der Fahrzeuge ein.';

  @override
  String get enterValidBuildingWidthM =>
      'Geben Sie eine gültige Gebäudebreite ein (m).';

  @override
  String get enterValidBuildingLengthM =>
      'Geben Sie eine gültige Gebäudelänge ein (m).';

  @override
  String get selectBuildingActivity =>
      'Bitte wählen Sie die Gebäudenutzung aus.';

  @override
  String get enterCeilingHeightSimpleM => 'Geben Sie die Deckenhöhe ein (m).';

  @override
  String get hoodHideComparison => 'Vergleich ausblenden';

  @override
  String get hoodCompareAgents => 'Löschmittel vergleichen';

  @override
  String get hoodTableAgentCol => 'Löschmittel';

  @override
  String get hoodTableEffectivenessCol => 'Wirksamkeit';

  @override
  String get hoodColLowAbbr => 'N';

  @override
  String get hoodColMediumAbbr => 'M';

  @override
  String get hoodColHighAbbr => 'H';

  @override
  String get hoodComparisonLegend =>
      'N = Niedrig  ·  M = Mittel  ·  H = Hohe Gefährdungsklasse\nFarbige Spalte = berechnete Gefährdungsklasse';

  @override
  String get hoodResultTitleCaps => 'LÖSCHAUSLEGUNG – ERGEBNIS';

  @override
  String get hoodNfpa96RequirementsTitle => 'NFPA 96 – Zwingende Anforderungen';

  @override
  String get hoodReqFuelElectric =>
      'Kraftstoff- & Stromabschaltung (§10.4): Bei Aktivierung des Systems müssen Kraftstoffzufuhr und Stromversorgung aller Wärmequellen automatisch unterbrochen werden. Manueller Reset erforderlich.';

  @override
  String get hoodReqManualPull =>
      'Manuelle Auslösestation (§10.5): In 1067–1219 mm Höhe über dem Boden, min. 3 m – max. 6 m von der Haube entfernt, entlang des Fluchtwegs anzuordnen.';

  @override
  String get hoodReqAlarm =>
      'Alarm (§10.6): Bei Systemaktivierung ist ein akustischer Alarm oder eine optische Anzeige zwingend erforderlich.';

  @override
  String get hoodReqFanMakeupAir =>
      'Lüfter & Zuluft (§8.2.3 / §8.3.2): Der Abluftventilator läuft nach der Aktivierung weiter. Die Zuluft (Makeup Air) in die Haube wird bei Systemaktivierung abgeschaltet.';

  @override
  String get hoodReqClassKExtinguisher =>
      'Feuerlöscher Klasse K (§10.10.2): Für Geräte mit pflanzlichem/tierischem Fett ist ein Feuerlöscher der Klasse K zwingend erforderlich.';

  @override
  String hoodReqFilterDistance(String warning) {
    return 'Filterabstand (§6.2.1): Mindestens 457 mm (18 in.) zwischen Filterunterkante und Kochfläche.$warning';
  }

  @override
  String get hoodFilterDistanceWarning =>
      'Chargrill/Grill vorhanden → mindestens 1220 mm (4 ft) zwischen Filterunterkante und Kochfläche (NFPA 96 §6.2.1.2)';

  @override
  String get hoodReqMaintenance =>
      'Wartung (§11.2.1): Wartung durch zertifizierten Techniker mindestens alle 6 Monate. Schmelzlotverbindungen (Fusible Links) werden alle 6 Monate ausgetauscht (§11.2.4).';

  @override
  String hoodReqCleaningFrequency(String frequency) {
    return 'Reinigungshäufigkeit (Tabelle 11.4): $frequency.';
  }

  @override
  String get hoodCleaningFreqHighVolume =>
      'Alle 3 Monate (Wok / Chargrill / großer Fritteuse)';

  @override
  String get hoodCleaningFreqLow => 'Jährlich (geringes Volumen)';

  @override
  String get hoodCleaningFreqMedium => 'Alle 6 Monate (mittleres Volumen)';

  @override
  String get hoodReqSimultaneousOperation =>
      'Gleichzeitiger Betrieb (§10.3): Alle stationären Löschanlagen innerhalb einer Gefahrenzone müssen gleichzeitig auslösen.';

  @override
  String hoodReqFryerDistance(String warning) {
    return 'Fritteusenabstand (§12.1.2.4): Die Fritteuse muss horizontal mindestens 406 mm (16 in.) von offenen Flammenquellen entfernt sein. Bei Verwendung einer Prallplatte (Baffle) genügt eine Mindesthöhe von 203 mm (8 in.) (§12.1.2.5).$warning';
  }

  @override
  String get hoodFryerDistanceWarning =>
      'Fritteuse vorhanden → muss horizontal mindestens 406 mm (16 in.) von offenen Flammenquellen entfernt positioniert werden (§12.1.2.4). Bei Verwendung einer Prallplatte (Baffle) genügt eine Mindesthöhe von 203 mm (8 in.) (§12.1.2.5).';

  @override
  String get hoodReqFryerHighTempLimiter =>
      'Übertemperaturbegrenzer für Fritteusen (§12.2): Ein automatischer Temperaturbegrenzer ist bei Fritteusen zwingend erforderlich. Er schaltet die Wärmequelle automatisch ab, sobald die Temperatur 25,4 mm (1 in.) unter der Ölfläche 246 °C (475 °F) erreicht.';

  @override
  String get hoodReqHoodDuctClearance =>
      'Haube-/Kanalabstände (§4.2.1): Mindestens 457 mm (18 in.) zu brennbaren Oberflächen, mindestens 76 mm (3 in.) zu bedingt brennbaren Oberflächen; zu nichtbrennbaren Oberflächen ist 0 mm Abstand zulässig.';

  @override
  String get hoodReqDuctSlope =>
      'Kanalneigung (§7.1.4): Bei horizontaler Kanallänge ≤ 22,86 m (75 ft) ist ein Mindestgefälle von 2 % anzuwenden, bei > 22,86 m (75 ft) ein Mindestgefälle von 8 % (zur Ableitung von Fettablagerungen).';

  @override
  String get hoodReqDuctFireBarrier =>
      'Feuerwiderstand der Kanaldurchführung (§7.7.2.1): Für Kanaldurchführungen: Gebäude < 4 Geschosse → mindestens 1-stündige Feuerwiderstandsklasse; Gebäude ≥ 4 Geschosse → mindestens 2-stündige Feuerwiderstandsklasse.';

  @override
  String hoodNotesText(
    String agent,
    String hazardClass,
    String score,
    String area,
  ) {
    return 'NFPA 17A §7.3 — Anwendung $agent.\nGefährdungsklasse: $hazardClass  ·  Gerätepunktzahl: $score  ·  Min. Auslösezeit: 30 s  ·  Filterfläche: $area m².\nFür zusätzliche Kanäle/Abzüge ist eine zusätzliche Düsenberechnung erforderlich.';
  }

  @override
  String get hoodAgentPotassiumCarbonateName => 'Kaliumkarbonat';

  @override
  String get hoodAgentPotassiumAcetateName => 'Kaliumacetat';

  @override
  String get hoodAgentPotassiumCitrateName => 'Kaliumcitrat';

  @override
  String get hoodAgentSodiumBicarbonateName => 'Natriumbicarbonat';

  @override
  String get hoodAgentPotassiumCarbonateDesc =>
      'Am weitesten verbreitet. Wirksam gegen Fett-/Oberflächenbrände.';

  @override
  String get hoodAgentPotassiumAcetateDesc =>
      'Hocheffizient. Ansul R-102, Amerex B500 Systeme.';

  @override
  String get hoodAgentPotassiumCitrateDesc =>
      'Verträglich mit Edelstahlgeräten. Geringes Korrosionsrisiko.';

  @override
  String get hoodAgentSodiumBicarbonateDesc =>
      'Ältere Generation. Kostengünstig, begrenzte Wirksamkeit.';

  @override
  String get hoodAgentPotassiumCarbonateReco =>
      'Universell einsetzbar. Für jede Gefährdungsklasse geeignet.';

  @override
  String get hoodAgentPotassiumAcetateReco =>
      'Erste Wahl bei hoher Gefährdung. Beste Löschleistung.';

  @override
  String get hoodAgentPotassiumCitrateReco =>
      'Edelstahlküchen / Lebensmittelindustrie. Niedrige–mittlere Gefährdung.';

  @override
  String get hoodAgentSodiumBicarbonateReco =>
      'Nur für geringe Gefährdung. Bei großvolumigen Fettbränden unzureichend.';

  @override
  String get hoodStdNfpa96Desc =>
      'Lüftungskontrolle und Brandschutz für gewerbliche Kochbetriebe. Haubenauslegung, Filterabstände, Anforderungen an Löschanlagen, manuelle Auslösestation, Kraftstoffabschaltung, Wartungs- und Reinigungsintervalle.';

  @override
  String get hoodStdNfpa17aDesc =>
      'Norm für nasschemische Löschanlagen. Auslösezeit, Löschmittelmenge, Düsenabstände.';

  @override
  String get hoodStdTsEn15751Desc =>
      'Europäische Norm — Löschanlagen für gewerbliche Kochgeräte.';

  @override
  String get hoodStdUl300Desc =>
      'USA — Produktzulassungsnorm für Küchenlöschanlagen (Ansul R-102, Amerex B500 usw.).';

  @override
  String get hoodStdTsEn1825Desc =>
      'Fettfiltersysteme und Brandschutzklappen für Küchenhauben.';

  @override
  String get calculationResultCaps => 'BERECHNUNGSERGEBNIS';

  @override
  String get gasInfoBoxText =>
      'TS EN 15004-1:2019 · NFPA 2001:2022\nVorauslegungswerkzeug für die Löschmittelmenge einer Gaslöschanlage mit Vollflutung.';

  @override
  String get gasNetVolumeHint =>
      'Netto-Schutzvolumen — bei vorhandenen fest eingebauten Möbeln/Geräten vom Bruttovolumen abziehen.';

  @override
  String get gasMinDesignTempHint =>
      'Minimale Lufttemperatur im Raum — TS EN 15004-1 §A.2  (Standard: 20 °C)';

  @override
  String get gasClassAMaterial1 => 'PMMA (Polymethylmethacrylat / Plexiglas) ';

  @override
  String get gasClassAMaterial2 => 'PP (Polypropylen)';

  @override
  String get gasClassAMaterial3 => 'ABS (Acrylnitril-Butadien-Styrol) ';

  @override
  String get gasClassAMaterial4 => 'Holz, Möbel und Polstermaterialien';

  @override
  String get gasClassAMaterial5 => 'Papier und Karton';

  @override
  String get gasClassAMaterial6 => 'Textilien / Stoffe';

  @override
  String get gasClassAMaterial7 => 'Kautschuk (Gummi)';

  @override
  String get gasClassAMaterial8 => 'Weitere Thermoplaste (PE, PS, PVC usw.)';

  @override
  String get gasClassASource =>
      'TS EN 15004-1:2019 Anhang C.6.3.2 (Prüfbrennstoff-Plattenanordnung aus Polymer) · ISO 14520-1 Definition Klasse A (allgemeine Beispiele)';

  @override
  String get gasClassADTitle =>
      'Higher Hazard Class A  —  Brände mit hoher Gefährdung';

  @override
  String get gasClassADMaterial1 =>
      'Schüttgut-/gestapelte Kunststofflagerung (Regal/Palette, tief liegend — unterscheidet sich von einzelnen/offenen Kunststoffteilen der Oberflächenklasse A)';

  @override
  String get gasClassADMaterial2 => 'Dichte Kabelbündel > 100 mm';

  @override
  String get gasClassADMaterial3 => 'Kabelpritschen-Füllgrad > 20 %';

  @override
  String get gasClassADMaterial4 => 'Abstand der Kabelpritschen < 250 mm';

  @override
  String get gasClassADMaterial5 =>
      'Unter Spannung stehende Geräte > 5 kW während der Löschung';

  @override
  String get gasClassADMaterial6 => 'Telekommunikation';

  @override
  String get gasClassADMaterial7 => 'Leitwarten';

  @override
  String get gasClassADMaterial8 =>
      'Bereiche mit dichter Elektro-/Elektronikausstattung';

  @override
  String get gasClassADSource => 'TS EN 15004-1:2019 Tabelle 4';

  @override
  String get gasClassBTitle =>
      'Class B  —  Brände von Flüssigkeiten und schmelzbaren Feststoffen';

  @override
  String get gasClassBMaterial1 => 'Benzin, Diesel, Heizöl';

  @override
  String get gasClassBMaterial2 => 'Lösungsmittel, Alkohol, Aceton';

  @override
  String get gasClassBMaterial3 => 'Ölgefüllter Transformator';

  @override
  String get gasClassBMaterial4 => 'Farbe, Lack, Harz';

  @override
  String get gasClassBMaterial5 =>
      'Schmelzbare Feststoffe wie Kerzenwachs, Paraffin';

  @override
  String get gasClassCMaterial1 => 'Elektrische Schaltschränke (lokal)';

  @override
  String get gasClassCMaterial2 => 'Motorsteuergeräte';

  @override
  String get gasClassCMaterial3 => 'USV- und Batteriesysteme';

  @override
  String get gasClassCMaterial4 => 'Beleuchtungs- und Stromverteilungsanlagen';

  @override
  String get gasClassCSource =>
      'Für Telekommunikation / Leitwarten / dichte Verkabelung → Higher Hazard Class A\nISO 3941 / NFPA 2001';

  @override
  String gasStandardDefaultInfo(
    String className,
    String percent,
    String capacity,
    String unit,
  ) {
    return 'Standardvorgabe — $className: $percent %  ·  Zylinder: $capacity $unit';
  }

  @override
  String get gasConcentrationHint =>
      'Sie können diesen Wert anpassen, wenn Sie einen Wert außerhalb des Geltungsbereichs von TS EN 15004-1 verwenden. Bei Auswahl von Löschmittel/Klasse wird er automatisch aktualisiert.';

  @override
  String get gasDischargeDurationHintClassB =>
      'Klasse B: max. 10 s  (TS EN 15004-1 §8.3)  —  für die Rohrauslegung erforderlich';

  @override
  String get gasDischargeDurationHintOther =>
      'Klasse A/A(Tief)/C: max. 60 s  (TS EN 15004-1 §8.3)  —  für die Rohrauslegung erforderlich';

  @override
  String gasNozzleFlowRange(String mm, String min, String max) {
    return '$mm mm  ($min–$max kg/s)';
  }

  @override
  String get gasNozzleHint =>
      'Wird ein Düsendurchmesser gewählt, erfolgt die Berechnung massenstrombasiert; im Automatikmodus gilt die Flächen-/Volumenregel.';

  @override
  String get gasRequiredAgentVolume => 'Erforderliches Löschmittelvolumen';

  @override
  String get gasSafetyMarginSuffix => '  (+10 % Zuschlag)';

  @override
  String get gasExcludingMarginLabel => 'Berechnung ohne Zuschlag';

  @override
  String get gasDischargeRequirementsTitle =>
      'Anforderungen an die Auslösezeit — TS EN 15004-1:2019 §8.3 / NFPA 2001:2022 §6.7.1';

  @override
  String get gasDischargeReqInert =>
      '• Max. Auslösezeit: ≤ 60 s  (NFPA 2001:2022 §6.7.1)\n• Min. Haltezeit (Soak): ≥ 10 Minuten  (NFPA 2001:2022 §6.7.4)\n• Rohrströmungsgeschwindigkeit: vollständige hydraulische Berechnung erforderlich (TS EN 15004-1 Anhang E)\n• Zylinderlagertemperatur: −20 °C – +54 °C  (NFPA 2001:2022 §4.4.1)';

  @override
  String get gasDischargeReqCo2 =>
      '• Max. Auslösezeit: ≤ 60 s  (TS EN 15004-2 §8.3 / NFPA 12 §5.4.1)\n• Min. Haltezeit (Soak): ≥ 20 Minuten\n• NUR für Räume ohne Personenbelegung — Evakuierung zwingend erforderlich';

  @override
  String get gasMaxDischargeClassB => '10 s  (Klasse B)';

  @override
  String get gasMaxDischargeClassOther => '60 s  (Klasse A/C)';

  @override
  String gasDischargeReqFm200(String maxDischarge) {
    return '• Max. Auslösezeit: ≤ $maxDischarge  (EN 15004-5:2020 §8.3 / NFPA 2001:2022 §6.7.1)\n• Min. Haltezeit (Soak): ≥ 10 Minuten  (NFPA 2001:2022 §6.7.4)\n• Zylinderlagertemperatur: −20 °C – +54 °C\n• Spezifisches Volumen: S = 0,1269 + 0,000513×T m³/kg  (EN 15004-5 §6.3 Tabelle 3)';
  }

  @override
  String gasDischargeReqDefault(String maxDischarge) {
    return '• Max. Auslösezeit: ≤ $maxDischarge  (TS EN 15004-1:2019 §8.3 / NFPA 2001:2022 §6.7.1)\n• Min. Haltezeit (Soak): ≥ 10 Minuten  (NFPA 2001:2022 §6.7.4)\n• Zylinderlagertemperatur: −20 °C – +54 °C  (NFPA 2001:2022 §4.4.1)';
  }

  @override
  String get gasIg01SpecsTitle =>
      'IG-01 Zylindereigenschaften  —  TS EN 15004-7:2009 §6.1';

  @override
  String get gasTablePropertyHeader => 'Eigenschaft';

  @override
  String get gasFillPressureLabel => 'Fülldruck @15 °C (bar)';

  @override
  String get gasMaxOperatingPressureLabel => 'Max. Betriebsdruck @50 °C (bar)';

  @override
  String get gasOverpressurizationLabel => 'Überdruckbeaufschlagung';

  @override
  String get gasNotApplicable => 'Nicht zutreffend';

  @override
  String get gasIg01Note =>
      'IG-01-Zylinder werden nicht überdruckbeaufschlagt (TS EN 15004-7 §6.2). Bei der Auslegungstemperatur gilt die Formel S = 0,56119 + 0,002055×T m³/kg.';

  @override
  String get gasFm200SpecsTitle =>
      'HFC-227ea Zylindereigenschaften  —  EN 15004-5:2020 §6.1';

  @override
  String get gasMaxFillDensityLabel => 'Max. Fülldichte (kg/m³)';

  @override
  String get gasN2FillingPressureLabel => 'N₂-Überdruckfüllung @21 °C (bar)';

  @override
  String get gasFm200Note =>
      'Bei Überschreitung der maximalen Fülldichte führen bereits geringe Temperaturanstiege zu sehr hohem Druck; die Zylinderintegrität wird gefährdet. (EN 15004-5:2020 §6.1)';

  @override
  String get gasNfpa2001RequirementsTitle =>
      'NFPA 2001:2022 – Zwingende Anforderungen';

  @override
  String get gasReqPreDischargeAlarm =>
      '§6.6.1 — Voralarm: In belegten Bereichen muss vor der Löschmittelauslösung ein akustisch/optisches Warnsignal ertönen; es muss ausreichend Zeit für die Evakuierung eingeräumt werden.';

  @override
  String get gasReqAbortSwitch =>
      '§6.6.6 — Abbruchschalter: In belegten Bereichen ist ein manueller Abbruchschalter zwingend erforderlich; er verzögert das System um mindestens 30 Sekunden.';

  @override
  String get gasReqVolumeIntegrity =>
      '§6.5.4 — Raumdichtheit: Der Raum muss während der Haltezeit ausreichend dicht sein, um die Auslegungskonzentration zu halten. Ein Door-Fan-Test wird empfohlen.';

  @override
  String get gasReqCylinderStorage =>
      '§4.4.1 — Zylinderlagerung: Aufbewahrung zwischen −20 °C und +54 °C; der Fülldruck muss der Herstellerliste entsprechen.';

  @override
  String get gasReqPostDischargeVentilation =>
      '§6.9 — Belüftung nach der Auslösung: Vor dem Betreten muss zwangsbelüftet werden, bis der O₂-Gehalt ≥ 19,5 % erreicht.';

  @override
  String get gasReqInterlockedSystems =>
      '§6.1.2 — Verriegelte Systeme: HVAC und alle Zuluftklappen müssen bei Auslösung automatisch schließen.';

  @override
  String gasReqSafetyMargin(String status) {
    return '§5.4.1.3 — Sicherheitszuschlag: Ein Sicherheitszuschlag von mindestens 10 % ist zwingend erforderlich; in dieser Berechnung wurde er $status';
  }

  @override
  String get gasSafetyMarginApplied => 'berücksichtigt.';

  @override
  String get gasSafetyMarginNotApplied => '⚠ nicht berücksichtigt!';

  @override
  String get gasReqPeriodicInspection =>
      '§7.2.2 — Regelmäßige Prüfung: Zylinder müssen jährlich durch Gewichts-/Druckkontrolle geprüft werden; die Halogenkohlenwasserstoff-Füllmenge ist durch Steigrohrmessung zu verifizieren.';

  @override
  String get gasMainPipeSizeTitle => 'Rohrdurchmesser — Hauptleitung';

  @override
  String get gasMinInnerDiameterLabel => 'Min. Innendurchmesser';

  @override
  String get gasStandardDnLabel => 'Standard-DN';

  @override
  String get gasDnOver150 => 'DN > 150';

  @override
  String gasVolumetricFlowLabel(String ls, String m3s) {
    return 'Volumenstrom (Q): $ls l/s  ($m3s m³/s)';
  }

  @override
  String gasPipeActualSpeedLabel(String dn, String speed, String status) {
    return 'Tatsächliche Geschwindigkeit bei DN $dn: $speed m/s$status';
  }

  @override
  String get gasSpeedOkSuffix => ' ✓';

  @override
  String get gasSpeedOverLimitSuffix => '  ⚠ über 30 m/s';

  @override
  String get gasMainPipeSizingNote =>
      'Die Hauptleitung ist eine Vorauslegung — Q = Löschmittelmenge ÷ Auslösezeit. Verteilerrohre und Düsenleitungen sind separat zu berechnen. Für die endgültige Auslegung eine vollständige Strömungsberechnung nach TS EN 15004-1 Anhang E durchführen.';

  @override
  String get gasNozzleDistributionTitle => 'Düsen & Verteilerrohr';

  @override
  String get gasNozzleCountLabel => 'Düsenanzahl';

  @override
  String gasNozzleAltMassBased(String mm) {
    return '$mm mm Düse\n(massenstrombasiert)';
  }

  @override
  String get gasNozzleAltAreaBased => 'max. 50 m²/Düse\n(flächenbasiert)';

  @override
  String get gasNozzleAltVolumeBased =>
      'max. 150 m³/Düse\n(volumenbasiert — Schätzwert)';

  @override
  String get gasBranchPipeLabel => 'Verteilerrohr';

  @override
  String gasBranchMinInnerDiameter(String mm) {
    return 'min. Innendurchmesser:\n$mm mm';
  }

  @override
  String gasFlowPerNozzleLabel(
    String flow,
    String min,
    String max,
    String status,
  ) {
    return 'Je Düse: $flow kg/s  (zulässig: $min–$max kg/s)  $status';
  }

  @override
  String get gasFlowOk => '✓';

  @override
  String get gasFlowOutOfRange =>
      '⚠ Außerhalb des Bereichs — anderen Durchmesser wählen';

  @override
  String gasBranchSpeedLabel(String speed, String ls, String status) {
    return 'Verteilergeschwindigkeit: $speed m/s  (Q je Düse: $ls l/s)$status';
  }

  @override
  String get gasBranchSpeedWarning => '  ⚠ über 30 m/s!';

  @override
  String get gasBranchSpeedOk => '  ✓';

  @override
  String gasEstimatedPipeLengthLabel(String m) {
    return 'Geschätzte Rohrlänge: ≈ $m m (Hauptleitung + Verteilung + Düsensteigleitungen)';
  }

  @override
  String get gasNozzlePlacementNote =>
      'Düsenanordnung: gemäß den Anforderungen der Herstellerliste nach TS EN 15004-1 / NFPA 2001 auf Deckenebene, gleichmäßig verteilt anzuordnen.\nDie Rohrlänge ist ein Schätzwert — die tatsächliche Projektlänge hängt vom Raumlayout ab.';

  @override
  String get gasSourceFooter =>
      'Quelle: TS EN 15004-1:2019 · NFPA 2001:2022 · NFPA 12:2022';

  @override
  String get baskiOffsetName => 'Offsetdruck';

  @override
  String get baskiFlexoName => 'Flexodruck';

  @override
  String get baskiGravureName => 'Tiefdruck / Rotogravur';

  @override
  String get baskiUvOffsetName => 'UV-Offset / UV-Flexo';

  @override
  String get baskiDigitalName => 'Digital (Inkjet/Toner)';

  @override
  String get baskiPadName => 'Tampondruck';

  @override
  String get baskiOffsetDesc =>
      'Nassoffset — IPA-/alkoholbasierte Feuchtlösung';

  @override
  String get baskiFlexoDesc => 'Lösungsmittel- oder wasserbasierte Farbe';

  @override
  String get baskiGravureDesc =>
      'Toluol-/Ethylacetat-basiert — hohes Lösungsmittelrisiko';

  @override
  String get baskiUvOffsetDesc => 'UV-Härtung — photoinitiatorbasiert';

  @override
  String get baskiDigitalDesc =>
      'Flüssige Tinte oder Toner — geringer Lösungsmittelanteil';

  @override
  String get baskiPadDesc => 'Lösungsmittelbasierte Farbe — geschlossener Napf';

  @override
  String get baskiIpaName => 'IPA (Isopropylalkohol)';

  @override
  String get baskiIpaDesc => 'Feuchtlösung im Offsetdruck — Explosionsrisiko';

  @override
  String get baskiTolueneName => 'Toluol';

  @override
  String get baskiTolueneDesc => 'Tiefdruck — hohes Risiko, GWP 0';

  @override
  String get baskiEthylAcetateName => 'Ethylacetat';

  @override
  String get baskiEthylAcetateDesc => 'Flexo/Tiefdruck — niedriger Flammpunkt';

  @override
  String get baskiMethanolName => 'Methanol';

  @override
  String get baskiMethanolDesc => 'Holzbearbeitung und Sonderanwendungen';

  @override
  String get baskiNPropylName => 'n-Propylalkohol';

  @override
  String get baskiNPropylDesc => 'Zusätzliches Lösungsmittel für UV-Offset';

  @override
  String get baskiSolventMixName => 'Lösungsmittelgemisch (allgemein)';

  @override
  String get baskiSolventMixDesc => 'Nach Herstellerdatenblatt bestimmen';

  @override
  String get baskiWaterBasedInkName => 'Wasserbasierte Farbe';

  @override
  String get baskiWaterBasedInkDesc =>
      'Kein brennbares Lösungsmittel — Anwendung Klasse A';

  @override
  String get baskiInfoBoxText =>
      'NFPA 34:2024 §10.6 · NFPA 2001:2022 · NFPA 12:2022 · TS EN 15004-1:2019\nVorauslegungswerkzeug für die Gaslöschung von Druckmaschinengehäusen.';

  @override
  String baskiIgnitionPointLabel(String temp, String desc) {
    return 'Flammpunkt: $temp °C  ·  $desc';
  }

  @override
  String get baskiUnitCountHint =>
      'Für jede Einheit gleichen Volumens wird ein separater Zylinder berechnet. Bei unterschiedlichen Volumina mehrere Berechnungen durchführen.';

  @override
  String get baskiLengthDepthLabel => 'Länge / Tiefe';

  @override
  String get baskiCabinetDimensionsHint =>
      'Innenmaße eines Einheitengehäuses — Netto-Innenvolumen, nicht brutto.';

  @override
  String get baskiUnitNetVolumeLabel => 'Netto-Volumen des Einheitengehäuses';

  @override
  String get baskiMinTempHint =>
      'Minimale Temperatur im Maschinengehäuse — TS EN 15004-1 §A.2 (Standard: 20 °C)';

  @override
  String get baskiLocalApplicationLabel =>
      'Lokale Anwendung +30 % (NFPA 2001 §6.4) — für offene Maschinengehäuse';

  @override
  String get baskiDischargeModeTitle => 'Auslösemodus (mehrere Einheiten)';

  @override
  String get baskiSimultaneousLabel => 'Gleichzeitig (Gesamt)';

  @override
  String get baskiSelectiveValveLabel => 'Selektivventil (unabhängig)';

  @override
  String get baskiSimultaneousHint =>
      'Wählen Sie dies, wenn alle Einheiten in einem gemeinsamen Bereich gleichzeitig auslösen können — die Hauptversorgung entspricht dem Gesamtbedarf aller Einheiten.';

  @override
  String get baskiSelectiveValveHint =>
      'Wählen Sie dies, wenn jede Einheit über eine unabhängige Erkennung und ein Selektivventil verfügt — die Hauptversorgung wird nur für den Bedarf einer einzelnen Einheit ausgelegt (NFPA 2001 §7.5.2 / NFPA 12 §4.3.4.2).';

  @override
  String get baskiBackupSupplyLabel =>
      'Reserve-(100 %-)Versorgungsgruppe (NFPA 12 §4.5.3) — empfohlen für ständig belegte Bereiche';

  @override
  String get baskiClassAPlain => 'Klasse A';

  @override
  String baskiClassSummaryLabel(String cls, String value, String noael) {
    return 'Brandklasse: $cls  ·  Standardmin.: $value %  ·  NOAEL: $noael';
  }

  @override
  String get baskiDischargeHint =>
      'Klasse-B-Maschinen: max. 10 s  ·  Klasse-A-Maschinen: max. 60 s  (TS EN 15004-1 §8.3)';

  @override
  String get baskiMainSupplySimultaneous =>
      'Hauptversorgungsbedarf (gleichzeitig — gesamt)';

  @override
  String get baskiMainSupplySelective =>
      'Hauptversorgungsbedarf (Selektivventil — einzelne Einheit)';

  @override
  String baskiMainSupplyCylinderCount(String capacity, String unit) {
    return 'Anzahl Hauptversorgungszylinder ($capacity $unit/Zylinder)';
  }

  @override
  String get baskiSelectiveValveInfo =>
      'Auslegung mit Selektivventil: Jedes Einheitengehäuse muss über einen unabhängigen Erkennungsstromkreis verfügen; es öffnet nur das Ventil der Einheit, in der ein Brand erkannt wird. Die Hauptversorgung ist für den Bedarf einer einzelnen Einheit ausgelegt — bei Risiko gleichzeitiger Brände in mehreren Einheiten ist \"Gleichzeitig\" zu wählen (NFPA 2001 §7.5.2 / NFPA 12 §4.3.4.2).';

  @override
  String get baskiLocalApplicationInfo =>
      'Es wurde ein Faktor für lokale Anwendung von +30 % angewendet (NFPA 2001 §6.4).\nGilt für offene Maschinen oder nicht vollständig geschlossene Gehäuse.';

  @override
  String get baskiApplicationNotesTitle => 'Anwendungshinweise';

  @override
  String baskiAppNotesBody(String ignitionNote) {
    return '• Jedes Druckwerkgehäuse muss einzeln geschützt werden.\n• Die Düsenanordnung innerhalb der Maschine unterliegt der Herstellerfreigabe.\n• Die Farb-/Lösungsmittelzufuhr muss vor der Auslösung automatisch abgeschaltet werden.\n• $ignitionNote\n• Die Zylinderanzahl hängt vom gewählten Auslösemodus (gleichzeitig/Selektivventil) und der Entscheidung zur Reserveversorgung ab — sie ist herstellerspezifisch endgültig festzulegen.';
  }

  @override
  String get baskiIgnitionNoteAtex =>
      'Flammpunkt < 23 °C — eine ATEX-Zonenbewertung ist zwingend erforderlich.';

  @override
  String get baskiIgnitionNoteExplosionRisk =>
      'Für diesen Lösungsmitteltyp ist eine Explosionsrisikoanalyse durchzuführen.';

  @override
  String get baskiSourceFooter =>
      'Quelle: NFPA 34:2024 §10 · NFPA 2001:2022 · NFPA 12:2022 · TS EN 15004-1:2019 · EN 1010-2';

  @override
  String get panoAgentGroupClean =>
      'Sauberlöschmittel (FK-5-1-12(Novec 1230)/HFC-227ea)';

  @override
  String get panoAgentGroupCo2 => 'CO₂ (Kohlendioxid)';

  @override
  String get panoDlpName => 'DLP — Direkt-Niederdruck';

  @override
  String get panoIlpName => 'ILP — Indirekt-Niederdruck';

  @override
  String get panoDhpName => 'DHP — Direkt-Hochdruck (CO₂)';

  @override
  String get panoIhpName => 'IHP — Indirekt-Hochdruck (CO₂)';

  @override
  String get panoDlpDesarjNotu =>
      'Die Tubing-Leitung dient zugleich der Erkennung und der direkten Löschmittelabgabe — keine Berechnung erforderlich.';

  @override
  String get panoIlpDesarjNotu =>
      'Das Tubing übernimmt nur die Erkennung; die Abgabe erfolgt über separate Düse(n).';

  @override
  String get panoDhpDesarjNotu =>
      'Feste Auslösezeit ≈ 60 s @ 60 bar — keine Benutzereingabe erforderlich.';

  @override
  String get panoIhpDesarjNotu =>
      'Die Auslösezeit ist normativ festgelegt; siehe die vom Hersteller freigegebene Tabelle.';

  @override
  String get panoDlpAciklama =>
      'Der am häufigsten verwendete Typ der Schaltschrank-Löschung. Das rote Erkennungs-Tubing fungiert selbst als direkte Löschleitung; zusätzliche Rohrleitungen und Düsen sind nicht erforderlich. Platzt das Tubing am Brandort, tritt dort das Löschmittel aus. Ein pre-engineered System, das keine hydraulische Strömungsberechnung erfordert.';

  @override
  String get panoIlpAciklama =>
      'Das Erkennungs-Tubing dient nur als Auslöser; das Löschmittel wird über Edelstahlrohrleitungen und Düsen in den Schaltschrank abgegeben. Bei mehrfach unterteilten, großvolumigen Schaltschränken werden Düsen an strategischen Punkten platziert, um eine homogene Löschkonzentration zu erreichen. Ein manueller Auslöseknopf ist vorhanden; der Schaltschrank muss vollständig dicht sein.';

  @override
  String get panoDhpAciklama =>
      'Ein System mit CO₂-Löschmittel, bei dem das Erkennungs-Tubing sowohl als Detektor als auch als Abgabeleitung fungiert. Da CO₂ unter hohem Druck gespeichert wird, bietet dies gegenüber DLP Vorteile bei Tubing-Länge und Höchstvolumen. Bevorzugt, wenn keine Düsenöffnung gewünscht ist und bei Schaltschränken mit größeren Lüftungsöffnungen als bei DLP.';

  @override
  String get panoIhpAciklama =>
      'Die umfassendste Schaltschrank-Löschlösung mit CO₂. Bevorzugt bei großvolumigen Schaltschränken mit mehreren Abteilen und Verbindungsöffnungen zwischen den Abteilen. Ein Verteilsystem aus Edelstahlrohrleitungen, flexiblen Verbindungsschläuchen und Düsen sorgt für eine homogene Löschung über große Flächen.';

  @override
  String get panoInfoBoxText =>
      'LPS 1666 · UL 2166 / FM 5600 · VdS 2093\nEmpfehlungswerkzeug für vorkonfigurierte (pre-engineered) pneumatische Tubing-Löschanlagentypen für Elektro-/Telekom-Schaltschränke und -Gehäuse — keine hydraulische Berechnung.';

  @override
  String get panoNoOpeningLabel =>
      'Keine nicht verschließbare Öffnung (Kabeldurchführungen, Lüftung usw. sind abgedichtet)';

  @override
  String get panoOpeningWarning =>
      'Bei einer nicht verschließbaren Öffnung kann das Löschmittel nicht gehalten werden und das System kann wirkungslos bleiben. Öffnungen müssen abgedichtet werden, oder Lüftung/Klappen müssen bei Aktivierung automatisch schließen.';

  @override
  String get panoTubingLengthLabel => 'Benötigte Tubing-Länge (optional)';

  @override
  String get panoRecommendedSystemCaps => 'EMPFOHLENES SYSTEM';

  @override
  String panoVolumeExceededWarning(String detail, String roomTab) {
    return 'Das Volumen überschreitet die Grenzen vorkonfigurierter Schaltschrank-Löschsysteme ($detail). Für dieses Volumen ist ein technisch berechnetes Vollflutungssystem erforderlich — verwenden Sie den Tab \"$roomTab\".';
  }

  @override
  String panoIlpMaxVolume(String v) {
    return 'ILP max. $v m³';
  }

  @override
  String panoIhpMaxVolume(String v) {
    return 'IHP max. $v m³';
  }

  @override
  String panoAgentAmountNote(String percent) {
    return 'Diese Menge ist eine Näherungsberechnung auf Basis einer Auslegungskonzentration von $percent % und einer Referenztemperatur von 20 °C. Die genaue Zylinderfüllmenge ist der vom Hersteller freigegebenen Tabelle des vorkonfigurierten Systems zu entnehmen.';
  }

  @override
  String panoTubingExceededWarning(String len, String kod, String max) {
    return 'Die eingegebene Tubing-Länge ($len m) überschreitet die Grenze von $max m des Systems $kod. Es muss auf einen leistungsfähigeren Systemtyp gewechselt oder es müssen mehrere unabhängige Systeme eingesetzt werden.';
  }

  @override
  String get panoSealingWarning =>
      'Das ILP-System erfordert einen vollständig dichten Schaltschrank (UL/FM-Prüfanforderung). Aufgrund der markierten nicht verschließbaren Öffnung ist dieses System nicht zuverlässig — dichten Sie den Schaltschrank ab oder wechseln Sie zur CO₂-Löschmittelgruppe (DHP/IHP, keine Dichtheit erforderlich).';

  @override
  String get panoCo2ToxicityWarning =>
      'CO₂ ist toxisch: Im Umfeld des Schaltschranks dürfen sich keine Personen dauerhaft aufhalten. Bei Leckagerisiko in angrenzende Bereiche ist die 5-%-LOAEL-Grenze zu beachten; ggf. sind Evakuierung und Belüftung zu planen.';

  @override
  String get panoNoSealingRequiredNote =>
      'Dichtheit ist nicht zwingend erforderlich, jedoch muss die Menge der nicht verschließbaren Öffnung dem Hersteller mitgeteilt werden; sie ist in der VdS-2093-Berechnung als zusätzliche Löschmittelmenge zu berücksichtigen.';

  @override
  String get panoDesignRequirementsTitle => 'Auslegungsanforderungen';

  @override
  String panoManualReleaseNote(String kod) {
    return '• Manueller Auslöseknopf: Da die Tubing-Leitung bei $kod-Systemen separat ist, ist zusätzlich zur automatischen Auslösung ein manueller Notauslöseknopf erforderlich.\n';
  }

  @override
  String get panoDesignRequirementsBody =>
      '• Alarmintegration: Bei Systemaktivierung müssen ein akustisch/optischer Voralarm sowie eine Signalübertragung an die Brandmeldezentrale des Gebäudes erfolgen.\n• Der Zylindersatz muss CE/TPED (Richtlinie für ortsbewegliche Druckgeräte) entsprechen.\n• Vor dem Kauf ist eine unabhängige Systemzertifizierung (LPCB/UL/FM/VdS) zu verlangen; eine reine Komponentenzertifizierung (Zylinder, Düse) reicht nicht aus. Die Installation muss durch einen autorisierten/zugelassenen Partner erfolgen.';

  @override
  String get panoMaintenanceScheduleTitle => 'Wartungsplan';

  @override
  String get panoMaintenanceScheduleBody =>
      '• Monatlich: Sichtkontrolle (Druckanzeige, Tubing-Beschädigung/Korrosion).\n• Alle 6 Monate: Kontrolle von Druckschalter, Dichtung und Anschlüssen.\n• Alle 5 Jahre: hydrostatische Zylinderprüfung.\n• Alle 10 Jahre: Systemüberholung / Bewertung des Lebensendes der Komponenten.\n• Bei jeder Füllung ist ein Füllzertifikat des Herstellers einzuholen; ist das System außer Betrieb (impaired), ist es schnellstmöglich (gemäß Hersteller-/Behördenvorgabe innerhalb von max. 48 Stunden) wieder in Betrieb zu nehmen oder eine Brandwache einzuteilen.';

  @override
  String get panoSourceFooter =>
      'Quelle: LPS 1666 · UL 2166 · FM 5600 · VdS 2093';

  @override
  String get gasAltitudeFieldLabel => 'Höhenlage';

  @override
  String get gasNoaelCo2Warning =>
      '⚠ CO₂ stellt bei hohen Konzentrationen eine Lebensgefahr dar. Es darf nur für Räume ohne Personenbelegung verwendet werden. TS EN 15004-2 / NFPA 12.';

  @override
  String gasNoaelLoaelExceeded(String percent, String loael) {
    return '⚠ Die Auslegungskonzentration ($percent %) ÜBERSCHREITET den LOAEL-Grenzwert ($loael %) — Evakuierung zwingend erforderlich, hohes Risiko!  (NFPA 2001:2022 Tabelle 5.6.2.1)';
  }

  @override
  String gasNoaelReached(String percent, String noael) {
    return '⚠ Die Auslegungskonzentration ($percent %) erreicht oder überschreitet den NOAEL-Grenzwert ($noael %) — vor der Nutzung ist eine Evakuierung erforderlich.  (NFPA 2001:2022 Tabelle 5.6.2.1)';
  }

  @override
  String gasNoaelOk(String percent, String noael, String loael) {
    return '✓ Die Auslegungskonzentration ($percent %) liegt unter dem NOAEL ($noael %). Nach NFPA 2001:2022 in belegten Bereichen einsetzbar.  LOAEL: $loael %';
  }

  @override
  String get gasAgentHfc227Desc =>
      'Verflüssigtes Halogenkohlenwasserstoff. 25/42/50 bar N₂-Überdruckfüllung. Max. Fülldichte 1150 kg/m³. Ideal für Elektro-/Elektronikräume. (EN 15004-5 Tabelle 6-8)';

  @override
  String get gasAgentFk512Desc =>
      'Niedriges GWP. Empfindliche Geräteräume, Archive, Museen.';

  @override
  String get gasAgentCo2Desc =>
      'Vollflutung — NUR für Räume ohne Personenbelegung. Die Klasse-B-Konzentration ist brennstoffspezifisch: Heptan 34 %, Toluol/Benzol 37 %, Ethylacetat 38 %, MEK 40 %, IPA/Ethanol/Methanol 53 % (NFPA 12 Tabelle A.5.3.2.1).';

  @override
  String get gasAgentIg541Desc =>
      'N₂/Ar/CO₂-Gemisch (52/40/8). Sauerstoffverdrängung. In belegten Bereichen einsetzbar.';

  @override
  String get gasAgentIg55Desc =>
      'N₂/Ar-Gemisch (50/50). Umweltfreundlich. In belegten Bereichen einsetzbar.';

  @override
  String get gasAgentIg100Desc =>
      'Reiner Stickstoff. Sauerstoffverdrängung. Leicht verfügbar.';

  @override
  String get gasAgentIg01Desc =>
      'Reines Argon. Löscht durch Sauerstoffverdrängung. 160 / 200 / 300 bar Befüllung. Hinterlässt keine chemischen Rückstände. In belegten Bereichen einsetzbar. (TS EN 15004-7 Tabelle 6-8)';

  @override
  String get wallMaterialConcrete => 'Beton / Mauerwerk';

  @override
  String get wallMaterialLightBlock => 'Leichtbeton-Blockstein';

  @override
  String get wallMaterialGypsum => 'Gipskarton (doppelt)';

  @override
  String smokeLayerHeightError(String height) {
    return 'Fehler: z ≥ H — es kann sich keine Rauchschicht bilden. z muss < $height m sein.';
  }

  @override
  String smokeLayerLowWarning(String z, String d) {
    return 'Warnung: z = $z m < 2,5 m — unzureichende Evakuierungssicherheit.  d (Rauchschichtdicke) = $d m';
  }

  @override
  String smokeLayerDepthInfo(String z, String d, String height) {
    return 'z = $z m  →  d (Rauchschichtdicke) = $d m  (H − z = $height − $z)';
  }

  @override
  String get smokeNoteNaturalPlume =>
      'Plume: die über dem Brand aufsteigende heiße Gas-/Rauchsäule. Massenstrom (Thomas-Formel, EN 12101-2 Anhang B): ṁₚ = 0.071×Qc¹³×z⁵³ + 0.0018×Qc';

  @override
  String get smokeNoteNaturalCd => 'Cd = 0,5 (Dachöffnung, EN 12101-2 §6.4)';

  @override
  String get smokeNoteNaturalFreshAir =>
      'Zuluft aus dem unteren Bereich; Öffnungen sollten gleichmäßig verteilt werden';

  @override
  String get smokeNoteMinimumAreaCaveat =>
      'Die berechnete Fläche ist ein Minimum; Sektorierung und ein Sicherheitszuschlag müssen zusätzlich berücksichtigt werden';

  @override
  String get smokeNoteResponsibilityNatural =>
      'Haftungsausschluss: Diese Berechnung dient Vorentwurfszwecken. Die endgültige Auslegung muss von einem qualifizierten Brandschutzingenieur genehmigt werden.';

  @override
  String get smokeNoteMechanicalPlume =>
      'Plume: die über dem Brand aufsteigende heiße Gas-/Rauchsäule. Die Ventilatorkapazität wird so gewählt, dass sie den Plume-Volumenstrom deckt.';

  @override
  String get smokeNoteMinAirChange =>
      'Min. Luftwechselrate ≥ 10/h (EN 12101-3 §5.2)';

  @override
  String get smokeNoteFanTempRating =>
      'Ventilator-Temperaturbeständigkeit ≥ 400 °C / 120 min (F400) — EN 12101-3';

  @override
  String get smokeNoteFreshAirPercent =>
      'Die Zuluft muss mindestens 70 % des Rauchabführstroms betragen';

  @override
  String get smokeNoteResponsibility =>
      'Haftungsausschluss: Diese Berechnung dient Vorentwurfszwecken. Die endgültige Auslegung muss von einem qualifizierten Brandschutzingenieur genehmigt werden.';

  @override
  String get smokeNoteDoorFlowExplain =>
      'Offentür-Übertrittsstrom: die Luft, die bei der Evakuierung durch das Treppenhaus strömt, während eine Geschosstür offen ist — die größte momentane Last, die der Ventilator abdecken muss';

  @override
  String get smokeNoteDoorFlowFormula =>
      'Berechnung: Q = A_Tür × √(2ΔP/ρ)  — Annahme: Tür vollständig offen, volle ΔP wirksam (sichere Seite)';

  @override
  String get smokeNoteWallLeakageConcrete =>
      'Wandleckage: 1,3×10⁻⁴ m²/m² für einen Beton-/Mauerwerksschacht  (EN 12101-6 Anhang F Tabelle F.1)';

  @override
  String get smokeNoteDoorGapCd =>
      'Türspaltbreite 10 mm, Cd = 0,83  (EN 12101-6 Anhang F)';

  @override
  String get smokeNoteDoorForceCheck =>
      'Türöffnungskraft ≤ 100 N muss bei offener Tür geprüft werden';

  @override
  String get smokeNotePressureLimit =>
      'ΔP-Grenze: ≥ 50 Pa (auf der Brandetage) / ≤ 60 Pa (andere Etagen)';

  @override
  String get fanCriterionMinAirChange => 'Kriterium min. Luftwechsel';

  @override
  String get fanCriterionPlumeFlow => 'Kriterium Plume-Volumenstrom';

  @override
  String get spFormulaInfo =>
      'EN 12845 / TS EN 12845 — Ortsfeste Feuerlöschanlagen · Automatische Sprinkler\nHydraulische Berechnung des kritischen Kreises nach Gefahrenklasse  ·  Hazen–Williams (wählbarer C-Koeffizient des Rohrmaterials)';

  @override
  String get spFieldWidthM => 'Breite  (m)';

  @override
  String get spFieldLengthM => 'Länge  (m)';

  @override
  String get spFieldCeilingM => 'Decke  (m)';

  @override
  String get spSuspendedCeilingCheckbox =>
      'Abgehängte Decke vorhanden (verdeckter Hohlraum)';

  @override
  String get spVoidDepthLabel => 'Hohlraumtiefe  (cm)';

  @override
  String get spVoidDepthInfo =>
      'EN 12845 Abschn. 5.4: Beträgt die Hohlraumtiefe > 80 cm, muss im verdeckten Hohlraum eine zusätzliche Sprinkleranlage installiert werden.';

  @override
  String get spBuildingActivityFieldLabel => 'Gebäudenutzung';

  @override
  String get spSelectActivityPlaceholder => 'Nutzung auswählen…';

  @override
  String spHazardClassInline(String name) {
    return 'Gefahrenklasse: $name';
  }

  @override
  String spHazardClassDetail(String density, String area, String coverage) {
    return 'Dichte: $density mm/min  ·  Bemessungsfläche: $area m²  ·  Max. Abdeckung: $coverage m²/Sprinkler';
  }

  @override
  String get spSprinklerTypeLabel => 'Sprinklertyp (K-Faktor)';

  @override
  String get spInstallationClassLabel =>
      'Installationsklasse / Pumpenredundanz';

  @override
  String get spDryPipeCheckbox =>
      'Trockenrohrsystem (frostgefährdeter Bereich)';

  @override
  String get spDryPipeInfo =>
      'Bei Trockenrohrsystemen wird das Rohrnetz mit Luft/Stickstoff beaufschlagt; Auslösezeit, Kompressorkapazität und Rohrgefälle (Entwässerung) müssen gesondert ausgelegt werden. In Bereichen ohne Frostrisiko ist ein Nasssystem vorzuziehen.';

  @override
  String get spRackStorageCheckbox =>
      'Regal-/Palettenlagerung — In-Rack-Sprinkler (Vorentwurf)';

  @override
  String get spRackLevelsLabel => 'Anzahl Regalebenen (In-Rack-Stufen)';

  @override
  String get spUnitLevel => 'Ebene';

  @override
  String get spRackInfo =>
      'Dies ist nur eine vereinfachte Vorabschätzung. Die genaue Anzahl der In-Rack-Sprinkler, die Flue-Space-Breite und der Ebenenabstand müssen durch eine vollständige Auslegung nach EN 12845 Anhang H bestimmt werden.';

  @override
  String get spFoamSystemCheckbox =>
      'Schaumlöschanlage hinzufügen (EN 13565-2)';

  @override
  String get spHydrocarbonSub => 'Benzin, Diesel,\nKraftstoff, Öl';

  @override
  String get spPolarSolventSub => 'Aceton, Ethanol,\nLösemittel, Keton';

  @override
  String spFoamDurationMin(String minutes) {
    return '$minutes Min.';
  }

  @override
  String get spFoamPolarSolventInfo =>
      'EN 13565-2: Für polare Lösemittel darf nur AR-AFFF-, FFFP- oder MF-FFF-Konzentrat verwendet werden. Als Schutzfläche wird die Gebäudefläche (Breite × Länge) zugrunde gelegt.';

  @override
  String get spHHP4Warning =>
      '⚠  HHP4 — HOCHDICHTE-WASSERSYSTEM\nEN 12845 Tabelle 3 Anmerkung: Diese Klasse liegt außerhalb des Anwendungsbereichs von Standardsprinklern. Eine gesonderte Bewertung und Freigabe durch einen befähigten Ingenieur sind zwingend erforderlich. Die nachfolgende Berechnung dient nur der Vorabinformation und darf nicht als offizielle Auslegung verwendet werden.';

  @override
  String get spActivityDialogTitle => 'Nutzungsbereich auswählen';

  @override
  String get spNoResultsFound => 'Keine Ergebnisse gefunden';

  @override
  String spKFactorWarning(String selected, String sinifKod, String minK) {
    return 'Der gewählte K-Faktor (K$selected) liegt unter dem für die Klasse $sinifKod erforderlichen Mindestwert K$minK — eine Herstellerfreigabe und Überprüfung durch eine vollständige hydraulische Berechnung sind zwingend erforderlich.';
  }

  @override
  String get spCeilingWarningLH =>
      'LH — Deckenhöhe > 6 m: Die Leistung von Standardsprinklern kann unzureichend sein. Eine ESFR- oder hochvolumige Sonderauslegung wird empfohlen.';

  @override
  String get spCeilingWarningOH =>
      'OH — Deckenhöhe > 6 m: Die Wirksamkeit von Standardsprinklern kann abnehmen. Eine Abstimmung mit der zuständigen Behörde vor der Auslegung wird empfohlen.';

  @override
  String get spCeilingWarningHH =>
      'HHP/HHS — Deckenhöhe > 6 m: Beträgt der Abstand nach §7.2.2.3 > 4 m, sind eine Erhöhung der Berieselungsdichte (+1 mm/min je zusätzlichem Meter) und mindestens K115-Sprinkler erforderlich.';

  @override
  String get spSinifAdLH => 'Niedrige Gefährdung (LH)';

  @override
  String get spSinifAdOH1 => 'Mittlere Gefährdung Gruppe 1 (OH1)';

  @override
  String get spSinifAdOH2 => 'Mittlere Gefährdung Gruppe 2 (OH2)';

  @override
  String get spSinifAdOH3 => 'Mittlere Gefährdung Gruppe 3 (OH3)';

  @override
  String get spSinifAdOH4 => 'Mittlere Gefährdung Gruppe 4 (OH4)';

  @override
  String get spSinifAdHHP1 => 'Hohe Gefährdung Prozess Gruppe 1 (HHP1)';

  @override
  String get spSinifAdHHP2 => 'Hohe Gefährdung Prozess Gruppe 2 (HHP2)';

  @override
  String get spSinifAdHHP3 => 'Hohe Gefährdung Prozess Gruppe 3 (HHP3)';

  @override
  String get spSinifAdHHP4 =>
      'Hohe Gefährdung Prozess Gruppe 4 (HHP4) — ⚠ Hochdichte-Wasser / Sondersystem';

  @override
  String get spSinifAdSF1 => 'Lagerkategorie I — Freie Bodenlagerung (≤ 3 m)';

  @override
  String get spSinifAdSF2 =>
      'Lagerkategorie II — Freie Bodenlagerung (≤ 3,5 m)';

  @override
  String get spSinifAdSF3 =>
      'Lagerkategorie III — Freie Bodenlagerung (≤ 3,5 m)';

  @override
  String get spSinifAdSF4 =>
      'Lagerkategorie IV — Freie Bodenlagerung (≤ 3,5 m)';

  @override
  String get spSinifAdRS1 => 'Lagerkategorie I — Regal-/Palettenlagerung';

  @override
  String get spSinifAdRS2 => 'Lagerkategorie II — Regal-/Palettenlagerung';

  @override
  String get spSinifAdRS3 => 'Lagerkategorie III — Regal-/Palettenlagerung';

  @override
  String get spSinifAdRS4 => 'Lagerkategorie IV — Regal-/Palettenlagerung';

  @override
  String get spTipAdAuto => 'Automatisch nach Klasse';

  @override
  String get spTipDescAuto =>
      'Standard K80 (LH/OH) oder K115 (HH) — Standardeinstellung';

  @override
  String get spTipAdK57 => 'Standard K57';

  @override
  String get spTipDescK57 =>
      'Nur bei speziell freigegebenen Anwendungen mit geringem Durchfluss';

  @override
  String get spTipAdK80 => 'Standard K80';

  @override
  String get spTipDescK80 => 'Standard für LH/OH-Klassen';

  @override
  String get spTipAdK115 => 'Hochdurchfluss K115';

  @override
  String get spTipDescK115 => 'Standard für HH-Klassen';

  @override
  String get spTipAdK161 => 'Großtropfen K161';

  @override
  String get spTipDescK161 =>
      'Hochregal-/Regalsysteme — Herstellerfreigabe erforderlich';

  @override
  String get spTipAdK200 => 'Extra-Großtropfen K200';

  @override
  String get spTipDescK200 =>
      'Spezielle Hochdurchfluss-Anwendungen — Herstellerfreigabe erforderlich';

  @override
  String get spTipAdEsfr => 'ESFR K242 (informativ)';

  @override
  String get spTipDescEsfr =>
      'Schnelle Unterdrückung (Early Suppression Fast Response) — außerhalb des Anwendungsbereichs von EN 12845; NFPA 13 / Listungsdaten sind maßgeblich';

  @override
  String get spKurulumAdSingle => 'Einzelquelle + Einzelpumpe';

  @override
  String get spKurulumDescSingle =>
      'Keine Redundanz — nur für LH und Objekte mit geringem Risiko und einer Wasserquelle akzeptabel.';

  @override
  String get spKurulumAdDual => 'Doppelpumpe (Elektro + Diesel)';

  @override
  String get spKurulumDescDual =>
      'Gängige Lösung für OH- und die meisten HH-Objekte — bei Stromausfall startet die Dieselpumpe automatisch.';

  @override
  String get spKurulumAdSuperior => 'Doppelquelle + Doppelpumpe (Superior)';

  @override
  String get spKurulumDescSuperior =>
      'Höchste Zuverlässigkeit — empfohlen für kritische Objekte, HH-Klassen und Hochrisikolager; zwei unabhängige Wasserquellen und Pumpensätze.';

  @override
  String get spUnitAdet => 'Stück';

  @override
  String get spUnitSpacing => 'Abstand';

  @override
  String get spUnitMinutes => 'Minuten';

  @override
  String get spRcHeaderBuilding => 'Gebäude- & Bemessungsparameter';

  @override
  String get spRcHeaderLayout => 'Sprinkler-Layoutberechnung';

  @override
  String get spRcHeaderHydraulic =>
      'Hydraulische Berechnung des kritischen Kreises';

  @override
  String get spRcHeaderFullHydraulic =>
      'Kritischer Kreis — Vollständige hydraulische Berechnung';

  @override
  String get spRcHeaderPump => 'Pumpenanforderungen';

  @override
  String get spRcHeaderInstallation => 'Installationsklasse & Pumpenredundanz';

  @override
  String get spRcHeaderWaterTank => 'Wasserbehälter  —  EN 12845 Tabelle 2';

  @override
  String get spRcHeaderDryPipe => 'Trockenrohrsystem  —  Frostrisiko';

  @override
  String get spRcHeaderRackStorage =>
      'Regallagerung — In-Rack-Sprinkler (Vorentwurf)';

  @override
  String get spRcHeaderPipeDiameterSummary =>
      'Rohrdurchmesser-Übersicht  —  EN 12845 Tabelle 14';

  @override
  String get spRcHeaderPipeLength => 'Rohrlänge (ungefähr)';

  @override
  String get spRcHeaderAlarmValve =>
      'Nassalarmventil  —  EN 12845 Abschn. 11.2';

  @override
  String get spRcHeaderFoamSystem => 'Schaumsystem  —  EN 13565-2';

  @override
  String get spRcBuildingArea => 'Gebäudefläche';

  @override
  String get spRcCeilingHeight => 'Deckenhöhe';

  @override
  String spRcCoverageAdjustedSuffix(String value) {
    return '  ›  Abdeckung angepasst: $value m² (Höheneinfluss)';
  }

  @override
  String get spRcHazardClass => 'Gefahrenklasse';

  @override
  String get spRcDesignDensity => 'Bemessungsdichte';

  @override
  String get spRcDesignArea => 'Bemessungsfläche';

  @override
  String get spRcMaxCoveragePerSprinklerCap => 'Max. Abdeckung / Sprinkler';

  @override
  String get spRcMaxCoveragePerSprinklerLow => 'Max. Abdeckung / Sprinkler';

  @override
  String get spRcHeightAdjustSuffix => '(Höhenanpassung)';

  @override
  String get spRcTable20Title =>
      'Tabelle 20 — Seitenwand-Sprühgruppen (Referenz)';

  @override
  String get spRcMaxGroupDistance => 'Max. Abstand zwischen Gruppen';

  @override
  String get spRcNote2Suffix =>
      '  (Anmerkung 2: kann bei 120-minütiger feuerwiderstandsfähiger Decke auf 3,7 m erhöht werden)';

  @override
  String get spRcMaxToWallEnd => 'Max. bis Wandende';

  @override
  String get spRcTheoreticalSpacing =>
      'Flächenbasierter theoretischer Abstand  √A';

  @override
  String get spRcTable19MaxDistance => 'Tabelle 19 — Max. S- und D-Abstand';

  @override
  String get spRcAppliedGridSpacing => 'Angewendeter Rasterabstand';

  @override
  String get spRcDistanceConstraintBinding =>
      '⚠ ABSTANDSGRENZE maßgeblich (√A > max. Abstand)';

  @override
  String get spRcAreaConstraintBinding => '✓ Flächengrenze maßgeblich';

  @override
  String get spRcHorizontalRow => 'Horizontale Reihe (entlang der Breite)';

  @override
  String get spRcVerticalRow => 'Vertikale Reihe (entlang der Länge)';

  @override
  String get spRcActualCoveragePerHead => 'Tatsächliche Abdeckung je Sprinkler';

  @override
  String get spRcTotalSprinklers => 'SPRINKLER GESAMT';

  @override
  String get spRcMainFloorSuffix => '(Hauptgeschoss)';

  @override
  String get spRcSprinklersInDesignArea => 'Sprinkler in der Bemessungsfläche';

  @override
  String get spRcSuspendedCeilingVoid => 'Hohlraum der abgehängten Decke';

  @override
  String get spRcExtraSprinklerRequired =>
      '⚠ Zusätzliche Sprinkler erforderlich (> 80 cm)';

  @override
  String get spRcExtraSprinklerNotRequired =>
      '✓ Zusätzliche Sprinkler nicht erforderlich (≤ 80 cm)';

  @override
  String get spRcConcealedVoidSprinklerCount =>
      'Anzahl Sprinkler im verdeckten Hohlraum';

  @override
  String get spRcAppliedToUpperGridSuffix =>
      '(auf dasselbe Raster der oberen Ebene angewendet)';

  @override
  String get spRcFarthestHeadFlow =>
      'Durchfluss des am weitesten entfernten Sprinklers  q';

  @override
  String get spRcDesignTotalFlow => 'Gesamt-Bemessungsdurchfluss  Q';

  @override
  String spRcBranchPipeDN(String dn) {
    return 'Zweigrohr  DN$dn';
  }

  @override
  String spRcCrossPipeDN(String dn) {
    return 'Verteilerrohr  DN$dn';
  }

  @override
  String spRcMainPipeDN(String dn) {
    return 'Versorgungs-/Hauptrohr  DN$dn';
  }

  @override
  String get spRcTotalFrictionLoss => 'Gesamter Reibungsverlust';

  @override
  String spRcStaticHeadFormula(String height) {
    return 'Statische Förderhöhe  ($height m × 0,098)';
  }

  @override
  String get spRcFarthestHeadMinPressure =>
      'Mindestdruck am entferntesten Sprinkler';

  @override
  String get spRcSafetyMarginLabel => 'Sicherheitsmarge';

  @override
  String get spRcColDistance => 'Abstand\n(m)';

  @override
  String get spRcColPressure => 'Druck\n(bar)';

  @override
  String get spRcColFlowLower => 'q\n(L/min)';

  @override
  String get spRcColCumFlow => 'ΣQ\n(L/min)';

  @override
  String get spRcColNextDeltaP => 'ΔP nächst.\n(bar)';

  @override
  String get spRcSectionBranchPipe => '── Zweigrohr (Range Pipe) ──';

  @override
  String get spRcSectionDistPipe => '── Verteilerrohr (Distribution Pipe) ──';

  @override
  String get spRcSectionMainPipe => '── Hauptrohr (Main Pipe) ──';

  @override
  String get spRcHydraulicFootnote =>
      'SP1 = am weitesten entfernter Sprinkler  ·  DP1 = Bemessungspunkt (Design Point)  ·  MP = Hauptrohr  ·  K-Proportionierung: Q_j = Q_krit×√(P_j/P_DP)  ·  Hazen-Williams C=120, 20 % Fitting-Zuschlag enthalten  (EN 12845 §13.3.2)';

  @override
  String get spRcPumpFlowLabel => 'Pumpendurchfluss';

  @override
  String get spRcPumpPressureLabel => 'Pumpendruck';

  @override
  String get spRcTable6AppliedIntro =>
      'TS EN 12845+A1 Tabelle 6 angewendet — bindende Mindestwerte für die Pumpenauslegung bei vorberechneten Systemen:';

  @override
  String spRcTable6FlowLine(String calc, String min) {
    return '• Durchfluss: iterativer hydraulischer Durchfluss $calc L/min < Tabelle-6-Min. $min L/min → $min L/min verwendet';
  }

  @override
  String spRcTable6PressureLine(String min, String applied) {
    return '• Druck: berechnet < Tabelle-6-Min. ($min + ps) bar → $applied bar angewendet';
  }

  @override
  String spRcMaxPressureWarning(String pressure, String zones) {
    return '⚠ EN 12845 §8.2 — Pumpendruck $pressure bar; der maximale Betriebsdruck an jeder Sprinklerposition im System darf 12 bar nicht überschreiten. Eine Aufteilung mittels Druckminderventil (PRV) in $zones Druckzonen oder eine Neuauslegung des Systems sollte in Betracht gezogen werden.';
  }

  @override
  String get spRcInstallationClassLabel => 'Installationsklasse';

  @override
  String get spRcPumpCount => 'Anzahl Pumpen';

  @override
  String get spRcElectricDieselSuffix => '  (elektrisch + Diesel)';

  @override
  String get spRcWaterSource => 'Wasserquelle';

  @override
  String get spRcDualIndependent => 'Doppelt (unabhängig)';

  @override
  String get spRcSingle => 'Einzeln';

  @override
  String get spRcJockeyPump => 'Druckhaltepumpe';

  @override
  String get spRcWaterSupplyDuration => 'Wasserversorgungsdauer';

  @override
  String spRcSupplyDurationSub(String cls, String minutes) {
    return '$cls → $minutes Min.';
  }

  @override
  String get spRcMinWaterTank => 'Min. Wasserbehälter';

  @override
  String get spRcWaterSupplyNote =>
      'EN 12845:2015 Tabelle 2 — Die Wasserversorgung kann über einen Behälter oder einen direkten Netzanschluss erfolgen. Unabhängig von der gewählten Option wird empfohlen, dem Behälter eine Sicherheitsmarge hinzuzufügen.';

  @override
  String get spRcPipeNetworkVolume => 'Innenvolumen des Rohrnetzes';

  @override
  String get spRcDryPipeNote =>
      'Dieses Volumen dient nur als Referenz für die Vorauslegung des Luftkompressors / Stickstoffgenerators und des Füllwassers. Auslösezeit, Zubehörbedarf (Accelerator/Exhauster) und Rohrgefälle müssen gesondert nach den Vorgaben des Herstellers bzw. der Auslegungsnorm festgelegt werden.';

  @override
  String get spRcRackLevelCount => 'Anzahl Regalebenen';

  @override
  String get spRcEstExtraInRackSprinklers =>
      'Geschätzte zusätzliche In-Rack-Sprinkler';

  @override
  String get spRcEstExtraFlow => 'Geschätzter Zusatzdurchfluss';

  @override
  String get spRcRackNote =>
      'Dies ist ein vereinfachter Vorentwurfswert (Annahme: 3 m horizontaler Abstand, K80, 1,0 bar). Die genaue In-Rack-Anordnung — Flue-Space-Breite, Ebenenabstand und tatsächlicher hydraulischer Bedarf — muss durch eine vollständige Auslegung nach EN 12845 Anhang H bestimmt und der Pumpen-/Wasserbehälterberechnung gesondert hinzugefügt werden.';

  @override
  String get spRcHHPTable14Warning =>
      '⚠  HHP-Klasse: EN 12845 Tabelle 14 gilt nicht. Die Durchmesser werden durch eine vollständige hydraulische Berechnung nach EN 12845 Anhang C bestimmt. Die nachstehenden Werte basieren auf einer vorläufigen Geschwindigkeitsmethode ≤ 5 m/s.';

  @override
  String get spRcSprinklerTypeKFactor => 'Sprinklertyp / K-Faktor';

  @override
  String get spRcBranchPipeRow => 'Zweigrohr (Branch Line)';

  @override
  String get spRcVelocityMethodSuffix => '  (Geschwindigkeitsmethode)';

  @override
  String get spRcTable14Suffix => '  (Tab.14)';

  @override
  String get spRcCrossMainRow => 'Verteilerrohr (Cross Main)';

  @override
  String spRcBranchConnCount(String branches, String heads) {
    return '$branches Zweigleitungen / $heads Spr.';
  }

  @override
  String get spRcMainSupplyRow => 'Hauptrohr / Versorgung';

  @override
  String spRcDesignAreaHeadsSuffix(String n) {
    return '$n Spr. (Bemessungsfläche)';
  }

  @override
  String get spRcColPipeType => 'Rohrtyp';

  @override
  String get spRcColCountLength => 'Anzahl × Länge';

  @override
  String get spRcColTotalM => 'Gesamt (m)';

  @override
  String get spRcRowBranchPipe => 'Zweigrohr (Branch)';

  @override
  String spRcRowCrossMain(String n) {
    return 'Verteiler (Cross Main)\n[$n Zweigleitungsanschlüsse]';
  }

  @override
  String get spRcRowMainPipe => 'Hauptrohr (Main)\n[Pumpenstrecke + Restlänge]';

  @override
  String get spRcTotalPipeLength => 'ROHRLÄNGE GESAMT';

  @override
  String get spRcPipeLengthFootnote =>
      '* Die Rohrlänge ist ungefähr. Ein 20 % Fitting-Zuschlag wurde berücksichtigt. Die genaue Länge muss auf dem Architekturplan berechnet werden.';

  @override
  String get spRcRequiredAlarmValve => 'Erforderliche Nassalarmventile:  ';

  @override
  String get spRcTotalSprinklersRow => 'Sprinkler gesamt';

  @override
  String get spRcMaxSprinklersPerValve => 'Max. Sprinkler / Ventil';

  @override
  String get spRcHHPClassSuffix => 'HHP-Klasse';

  @override
  String get spRcLHOHClassSuffix => 'LH/OH-Klasse';

  @override
  String get spRcMaxAreaPerValve => 'Max. Fläche / Ventil';

  @override
  String get spRcAreaPerValve => 'Fläche je Ventil';

  @override
  String get spRcDesignFlowPerValve => 'Bemessungsdurchfluss je Ventil';

  @override
  String get spRcSingleValveSuffix =>
      '  (das gesamte System wird über ein einziges Ventil berechnet)';

  @override
  String spRcAlarmValveNote(String scope) {
    return 'EN 12845:2015 Abschnitt 11.2.1: Eine Nassalarmventilzone kann $scope Nutzfläche schützen.';
  }

  @override
  String get spRcAlarmValveScopeHH =>
      'in HHP-Klassen höchstens 500 Sprinkler und 2 300 m²';

  @override
  String get spRcAlarmValveScopeLHOH =>
      'in LH/OH-Klassen höchstens 1 000 Sprinkler und 4 800 m²';

  @override
  String get spRcConcentrateType => 'Konzentrattyp';

  @override
  String spRcConcentrationSuffix(String pct) {
    return '  —  $pct % Konzentration';
  }

  @override
  String get spRcLiquidCategory => 'Flüssigkeitskategorie';

  @override
  String get spRcPolarSolventDetail =>
      'Polares Lösemittel (B2) — Aceton, Ethanol, Keton, Lösemittel';

  @override
  String get spRcHydrocarbonDetail =>
      'Kohlenwasserstoff (B1) — Benzin, Diesel, Öl';

  @override
  String get spRcProtectedArea => 'Schutzfläche';

  @override
  String get spRcApplicationRate => 'Aufbringungsrate';

  @override
  String get spRcApplicationDuration => 'Aufbringungsdauer';

  @override
  String get spRcSolutionFlow => 'Lösungsdurchfluss (Q)';

  @override
  String get spRcConcentrateFlow => '  Konzentratdurchfluss';

  @override
  String get spRcWaterFlow => '  Wasserdurchfluss';

  @override
  String get spRcConcentrateTankVolume => 'Konzentrattankvolumen';

  @override
  String get spRcWaterReserve => 'Wasserreserve';

  @override
  String get spRcFoamNote7 =>
      'EN 13565-2 Abschnitt 7: Konzentrattankvolumen und Wasserreserve sind Mindestwerte. Bei der tatsächlichen Auslegung müssen eine Sicherheitsmarge und die gleichzeitige Nutzung berücksichtigt werden.';

  @override
  String get spRcFinalDisclaimer =>
      '⚠  Dies ist eine überschlägige Vorabberechnung. Für die offizielle Projektauslegung sind eine vollständige hydraulische Berechnung nach EN 12845 Anhang C und die Freigabe durch einen befähigten Ingenieur zwingend erforderlich. Für Verbindungsverluste wurde den Längen ein Zuschlag von +20 % hinzugefügt.';

  @override
  String get updateAvailableTitle => 'Neue Version verfügbar';

  @override
  String updateAvailableMessage(String version) {
    return 'Die App wurde auf Version v$version aktualisiert.\nAktualisieren Sie, um die neuesten Funktionen zu nutzen.';
  }

  @override
  String get updateLaterButton => 'Später';

  @override
  String get updateNowButton => 'Aktualisieren';

  @override
  String loginRateLimitMessage(String time) {
    return 'Zu viele fehlgeschlagene Anmeldeversuche. Versuchen Sie es in $time erneut.';
  }

  @override
  String savedOnLabel(String date) {
    return 'Gespeichert: $date';
  }

  @override
  String get upgradeRequiredTitle => 'Upgrade erforderlich';

  @override
  String get upgradeRequiredMessage =>
      'Dieses Modul ist in der Demoversion nicht verfügbar. Erstellen Sie Ihr MEVOS-Konto und starten Sie das Fire-Modul-Abonnement, um auf alle Module zuzugreifen.';

  @override
  String get upgradeSignUpButton => 'Registrieren';

  @override
  String get geminiApiKeyRequiredInfo =>
      'Für die KI-Funktion ist ein kostenloser Google Gemini API-Schlüssel erforderlich.';

  @override
  String get enterStandardNumberFirst =>
      'Geben Sie zuerst die Standardnummer ein.';

  @override
  String get apiKeyRequiredError => 'API-Schlüssel erforderlich.';

  @override
  String get standardNotFoundError => 'Standard nicht gefunden.';

  @override
  String get enterTopicOrKeywordFirst =>
      'Geben Sie zuerst ein Thema oder Stichwort ein.';

  @override
  String get relatedStandardNotFound => 'Kein zugehöriger Standard gefunden.';

  @override
  String get addCustomStandardTitle =>
      'Benutzerdefinierten Standard hinzufügen';

  @override
  String get byNumberTab => 'Nach Nummer';

  @override
  String get byTopicTab => 'Nach Thema';

  @override
  String get findDescriptionWithAiTooltip => 'Beschreibung mit KI finden';

  @override
  String get searchStandardsWithAiTooltip => 'Standards mit KI suchen';

  @override
  String get selectAllButton => 'Alle auswählen';

  @override
  String get deselectAllButton => 'Alle abwählen';

  @override
  String addSelectedButton(int count) {
    return 'Ausgewählte hinzufügen ($count)';
  }

  @override
  String get customAddedStandardsHeader =>
      'Benutzerdefiniert hinzugefügte Standards';

  @override
  String get deleteStandardTitle => 'Standard löschen';

  @override
  String deleteStandardConfirm(String number) {
    return '„$number“ aus der Liste entfernen?';
  }

  @override
  String get aiAssistantTitle => 'KI-Assistent';

  @override
  String aiChatGreeting(String standard) {
    return 'Ich kann Ihre Fragen zum Standard $standard beantworten.';
  }

  @override
  String get rehberFireLoadScenario => 'Brandlast & Brandszenario';

  @override
  String get rehberGasSuppressionSystems => 'Gaslöschanlagen';

  @override
  String get rehberWaterBasedSuppression => 'Wasserbasierte Löschanlagen';

  @override
  String get rehberFoamSuppressionSystems => 'Schaumlöschanlagen';

  @override
  String get rehberKitchenHoodSuppression => 'Küchenhauben- & Kochlöschung';

  @override
  String get rehberFireExtinguishersPortable =>
      'Feuerlöscher & tragbare Ausrüstung';

  @override
  String get rehberStructuralFireResistance => 'Bauteilbrandwiderstand';

  @override
  String get rehberRiskAssessmentSafety =>
      'Risikobewertung & Sicherheitsmanagement';

  @override
  String get rehberIndustrialSpecialRisk =>
      'Industrielle & Sondergefahrenanlagen';

  @override
  String get stdDescEn1991FireLoad =>
      'Eurocode 1 Teil 1-2: Einwirkungen auf Tragwerke — Brandeinwirkungen. Berechnung der Brandlastdichte, Wachstumsrate und des Brandszenarios.';

  @override
  String get stdDescIso1716Ncv =>
      'Bestimmung der Verbrennungswärme von Baustoffen und -produkten — Verfahren zur Bestimmung des Netto-Heizwerts (NCV).';

  @override
  String get stdDescIso5660ConeCalorimeter =>
      'Prüfungen zum Brandverhalten — Wärmefreisetzungsrate, Rauchentwicklungsrate und Massenverlustrate. Cone-Kalorimeter-Verfahren.';

  @override
  String get stdDescNfpa557FireLoadDensity =>
      'Standard zur Ermittlung der Brandlast für den baulichen Brandschutz — Referenztabellen für die Dichte nach Gebäudenutzungsart.';

  @override
  String get stdDescIso24679FireBehaviour =>
      'Brandschutzingenieurwesen — Bewertung des Brandverhaltens von Tragwerken.';

  @override
  String get stdDescIso16733FireScenario =>
      'Brandschutzingenieurwesen — Auswahl von Bemessungsbrandszenarien und Bemessungsbränden.';

  @override
  String get stdDescSfpeHandbook =>
      'Nachschlagewerk für Brandschutzingenieurwesen — Berechnungsmethoden, Branddynamik, Rauchbewegung.';

  @override
  String get stdDescPd7974FireInitiation =>
      'BSI — Anwendung von Brandschutzingenieurprinzipien bei der Gebäudeplanung: Brandentstehung und -entwicklung.';

  @override
  String get stdDescIso145201GeneralRules =>
      'Gaslöschanlagen — Allgemeine Anforderungen: Auslegung, Installation, Inbetriebnahme, Wartung und Sicherheit.';

  @override
  String get stdDescIso145202Co2 =>
      'CO2-Löschanlagen — Verfahren für Totalflutung und örtliche Anwendung.';

  @override
  String get stdDescIso145205Hfc227 =>
      'HFC-227ea (FM-200) Gaslöschanlagen — Konzentrations- und Volumenberechnung.';

  @override
  String get stdDescIso145208Hcfc =>
      'HCFC-Mischung A (Halotron I) Löschanlagen.';

  @override
  String get stdDescIso145209Hfc23 => 'HFC 23 (Trifluormethan) Löschanlagen.';

  @override
  String get stdDescIso1452010Ig55 =>
      'IG-55 (Argonite) Anlagen — N2/Ar-Gemisch, Inertgas.';

  @override
  String get stdDescIso1452011Ig541 =>
      'IG-541 (Inergen) — N2/Ar/CO2-Gemisch, Inertgaslöschung.';

  @override
  String get stdDescIso1452012Ig01 => 'IG-01 (Argon) Löschanlagen.';

  @override
  String get stdDescIso1452013Ig100 => 'IG-100 (Stickstoff) Löschanlagen.';

  @override
  String get stdDescIso1452015Novec =>
      'FK-5-1-12 (Novec 1230) — Niedriger GWP-Wert, für empfindliche Geräteräume.';

  @override
  String get stdDescNfpa2001CleanAgent =>
      'USA — Standard für Feuerlöschanlagen mit sauberen Löschmitteln (Clean Agent).';

  @override
  String get stdDescNfpa12Co2Us =>
      'CO2-Löschanlagen — US-Standard, Totalflutung und örtliche Anwendung.';

  @override
  String get stdDescNfpa12aHalon =>
      'Halon-1301-Löschanlagen — USA, Bestandsanlagen.';

  @override
  String get stdDescTsEn150041GeneralReq =>
      'Ortsfeste Feuerlöschanlagen — Gaslöschanlagen, allgemeine Anforderungen.';

  @override
  String get stdDescVds2380Design =>
      'Deutschland — Richtlinien für Planung und Einbau von Gaslöschanlagen.';

  @override
  String get stdDescNfpa34DippingCoating =>
      'Tauch-, Beschichtungs- und Druckprozesse mit brennbaren Flüssigkeiten — grundlegender Sicherheitsstandard.';

  @override
  String get stdDescNfpa34Sec10PrintingOps =>
      'Printing Operations: Bauweise des Druckbereichs, Belüftung, elektrische Klassifizierung und Brandschutz.';

  @override
  String get stdDescNfpa34Sec106AutoSuppression =>
      'Pflicht zur automatischen Brandbekämpfung — Sprinkler für Flüssigkeiten der Klasse I; örtliches CO2/Clean Agent für Trocknerkammern.';

  @override
  String get stdDescNfpa12PrintingPressLocal =>
      'CO2-Löschung — örtliche Löschanlagen für Druckmaschine und Trocknerkammer.';

  @override
  String get stdDescNfpa2001PrintingCabin =>
      'Clean-Agent-Löschung — Schutz der Druckmaschinenkabine, bevorzugt bei Personalanwesenheit.';

  @override
  String get stdDescNfpa30PrintingSolvent =>
      'Code für brennbare und entzündliche Flüssigkeiten — Lagerung und Verwendung von Lösemitteln in Druckereien.';

  @override
  String get stdDescNfpa70Article516 =>
      'ATEX/NEC-Einstufung explosionsgefährdeter Bereiche und elektrische Ausrüstung im Druckbereich.';

  @override
  String get stdDescEn10101PrintingSafetyGeneral =>
      'Sicherheit von Druck- und Papierverarbeitungsmaschinen — Allgemeine Anforderungen.';

  @override
  String get stdDescEn10102PrintingSafetyMachines =>
      'Sicherheit von Druckmaschinen — Druck- und Lackiermaschinen (Offset, Flexo, Tiefdruck).';

  @override
  String get stdDescEn13463AtexEquipment =>
      'ATEX-Geräte — Sicherheitskriterien für Geräte zur Verwendung in explosionsgefährdeten Bereichen.';

  @override
  String get stdDescTsEn150041PrintingCabinet =>
      'Gaslöschanlagen — Allgemeine Anforderungen (Clean-Agent-Berechnung für Druckkabinen).';

  @override
  String get stdDescTsEn12845Sprinkler =>
      'Ortsfeste Sprinkleranlagen — Planung, Einbau und Instandhaltung. Gefahrenklasse, Berieselungsdichte, Durchfluss und Speichervolumen.';

  @override
  String get stdDescNfpa13SprinklerInstallation =>
      'Standard für die Installation von Sprinkleranlagen — USA, alle Gebäudetypen.';

  @override
  String get stdDescNfpa13rResidential =>
      'Sprinkleranlagen in Wohngebäuden — Gebäude bis zu vier Geschossen.';

  @override
  String get stdDescNfpa13dOneTwoFamily =>
      'Sprinkleranlagen in Ein- und Zweifamilienhäusern.';

  @override
  String get stdDescNfpa15WaterSpray =>
      'Ortsfeste Wassersprühlöschanlagen — Schutz von Anlagen und Gefahrenbereichen.';

  @override
  String get stdDescNfpa16FoamWaterSpray =>
      'Schaum-Wasser-Sprüh- und Schaum-Wasser-Sprinkleranlagen.';

  @override
  String get stdDescEn14339UndergroundHydrant =>
      'Unterflurhydrantenanlagen — Planung und Einbau.';

  @override
  String get stdDescEn14384AboveGroundHydrant => 'Überflurhydrantenanlagen.';

  @override
  String get stdDescEn6711SemiRigidHose =>
      'Ortsfeste Feuerlöscheinrichtungen — Wandhydranten mit formstabilem Schlauch.';

  @override
  String get stdDescEn6712FlatHoseHydrant =>
      'Ortsfeste Feuerlöscheinrichtungen — Wandhydranten mit Flachschlauch.';

  @override
  String get stdDescEn6713Maintenance =>
      'Ortsfeste Feuerlöscheinrichtungen — Instandhaltung, Teil 3.';

  @override
  String get stdDescEn122591Components =>
      'Ortsfeste Feuerlöschanlagen — Komponenten für Sprinkler- und Sprühwasseranlagen.';

  @override
  String get stdDescTsEn149721WaterMistDesign =>
      'Ortsfeste Feuerlöschanlagen — Wassernebelanlagen, Teil 1: Planung und Einbau.';

  @override
  String get stdDescNfpa750WaterMist =>
      'Standard für Wassernebel-Feuerlöschanlagen — USA.';

  @override
  String get stdDescNfpa11ExpansionFoam =>
      'Schwer-, Mittel- und Leichtschaumlöschanlagen — US-Standard.';

  @override
  String get stdDescEn135651FoamRequirements =>
      'Ortsfeste Schaumlöschanlagen — Teil 1: Anforderungen und Prüfverfahren.';

  @override
  String get stdDescEn135652FoamDesignInstall =>
      'Ortsfeste Schaumlöschanlagen — Teil 2: Planung, Einbau und Instandhaltung.';

  @override
  String get stdDescIso72031FoamConcentrates =>
      'Feuerlöschmittel — Schaummittel für Flüssigbrandstoffbrände.';

  @override
  String get stdDescNfpa30StorageTransfer =>
      'Code für brennbare und entzündliche Flüssigkeiten — Lagerung und Umschlag.';

  @override
  String get stdDescApi2021TankFirePrevention =>
      'Erdölindustrie — Brandverhütung und -bekämpfung bei Lagertanks.';

  @override
  String get stdDescNfpa17aWetChemical =>
      'Nasschemische Löschanlagen (Wet Chemical) — Anwendungen in Gewerbeküchen.';

  @override
  String get stdDescNfpa17DryChemical =>
      'Trockenchemische Löschanlagen — Allgemeine industrielle Anwendungen.';

  @override
  String get stdDescTsEn15751CommercialKitchen =>
      'Europa — Ortsfeste Feuerlöschanlagen für gewerbliche Küchengeräte.';

  @override
  String get stdDescUl300CookingSuppression =>
      'US-Produktzulassungsstandard — Feuerlöschanlagen für Kochbereiche (Ansul, Amerex u. a.).';

  @override
  String get stdDescUl300aAutoSuppressionCooking =>
      'Automatische Löschanlagen — Brandgefahr oberhalb von Kochgeräten.';

  @override
  String get stdDescTsEn18251GreaseSeparators =>
      'Fettabscheider und Filter für Küchenabzugshauben.';

  @override
  String get stdDescTsEn18252GreaseSelection =>
      'Fettabscheider für Küchenabzugshauben — Auswahl, Einbau und Wartung.';

  @override
  String get stdDescNfpa96VentilationCooking =>
      'Standard für Lüftungskontrolle und Brandschutz gewerblicher Kochbetriebe — Kanäle, Abzugshauben und Brandverhütung.';

  @override
  String get stdDescEn541Introduction =>
      'Brandmeldeanlagen — Teil 1: Einführung.';

  @override
  String get stdDescEn542ControlIndicating => 'Brandmelderzentralen.';

  @override
  String get stdDescEn543SoundersDevices =>
      'Feuerwehr-Signalgeber — Akustische Signalgeber.';

  @override
  String get stdDescEn544PowerSupply => 'Energieversorgungseinrichtungen.';

  @override
  String get stdDescEn545HeatDetectors => 'Wärmemelder — Punktförmige Melder.';

  @override
  String get stdDescEn547SmokeDetectorsOptical =>
      'Rauchmelder — Punktförmige Melder nach dem Streulicht-, Durchlicht- oder Ionisationsprinzip.';

  @override
  String get stdDescEn5410FlameDetectors =>
      'Flammenmelder — Punktförmige Melder.';

  @override
  String get stdDescEn5411ManualCallPoint =>
      'Handfeuermelder (mit Glasscheibe).';

  @override
  String get stdDescEn5412SmokeDetectorsLinear =>
      'Rauchmelder — Linienförmige Melder nach dem Lichtstrahlprinzip.';

  @override
  String get stdDescEn5413SystemCompatibility =>
      'Bewertung der Kompatibilität und Verbindbarkeit von Systembestandteilen.';

  @override
  String get stdDescEn5414PlanningGuide =>
      'Brandmeldeanlagen — Leitfaden für Planung, Projektierung, Einbau, Abnahme, Betrieb und Instandhaltung.';

  @override
  String get stdDescEn5416VoiceAlarm => 'Sprachalarmzentralen.';

  @override
  String get stdDescEn5417ShortCircuitIsolators => 'Kurzschlussisolatoren.';

  @override
  String get stdDescEn5418InputOutputDevices => 'Ein-/Ausgabegeräte.';

  @override
  String get stdDescEn5420AspiratingSmoke => 'Rauchmelder — Ansaugrauchmelder.';

  @override
  String get stdDescEn5421AlarmTransmission =>
      'Alarmübertragungs- und Störungsmeldeeinrichtungen.';

  @override
  String get stdDescEn5423VisualAlarm =>
      'Feueralarmeinrichtungen — Optische Signalgeber.';

  @override
  String get stdDescEn5425RadioComponents =>
      'Komponenten mit Funkverbindung (drahtlose Systemkomponenten).';

  @override
  String get stdDescNfpa72NationalCode =>
      'USA — Nationaler Code für Brandmelde- und Signalanlagen. Adressierung, Alarmierung, Infrastruktur.';

  @override
  String get stdDescVds2095PlanningInstall =>
      'Deutschland — Richtlinien für Planung und Einbau von Brandmeldeanlagen.';

  @override
  String get stdDescEn121011SmokeCurtains =>
      'Rauch- und Wärmefreihaltung — Teil 1: Festlegungen für Rauchschürzen.';

  @override
  String get stdDescEn121012NaturalVentilators =>
      'Natürliche Rauch- und Wärmeabzugsgeräte — Anforderungen.';

  @override
  String get stdDescEn121013PoweredExhaust =>
      'Maschinelle Rauchabzugsanlagen — Maschinelle Rauch- und Wärmeabzugsventilatoren.';

  @override
  String get stdDescEn121014InstallCommission =>
      'Leitfaden für Einbau, Abnahmeprüfung, regelmäßige Wartung und Instandsetzung.';

  @override
  String get stdDescEn121016PressureDifferential =>
      'Differenzdruck-Rauchschutzanlagen — Festlegungen für Bausätze.';

  @override
  String get stdDescEn121017DuctlessNaturalVent =>
      'Rauch- und Wärmeabzugsgeräte — Kanallose natürliche Rauchabführung.';

  @override
  String get stdDescEn121018TunnelControlPanels =>
      'Steuertafeln für natürliche Rauch- und Wärmeabzugsanlagen in Tunneln.';

  @override
  String get stdDescEn121019FireDamperControl =>
      'Steuereinrichtungen für Rauchschutzklappen.';

  @override
  String get stdDescEn1210110PowerSupplyKits => 'Energieversorgungs-Bausätze.';

  @override
  String get stdDescNfpa92SmokeControlUs =>
      'USA — Standard für Rauchschutzanlagen. Druckbelüftete Treppenhäuser, Rauchmanagement in Atrien.';

  @override
  String get stdDescNfpa101LifeSafety =>
      'USA — Life-Safety-Code, Fluchtwege, Ausgangsanforderungen.';

  @override
  String get stdDescEn16341DoorFireResistance =>
      'Feuer- und Rauchschutzabschlüsse — Feuerwiderstandsprüfung.';

  @override
  String get stdDescEn16343SmokeControl =>
      'Feuerschutzabschlüsse — Rauchschutzprüfung.';

  @override
  String get stdDescEn15650FireDampers =>
      'Brandschutzklappen für Lüftungsanlagen.';

  @override
  String get stdDescEn158821ExtendedApplication =>
      'Erweiterte Anwendung der Ergebnisse von Feuerwiderstandsprüfungen für Rauchschutzklappen.';

  @override
  String get stdDescEn37PortableExtPerformance =>
      'Tragbare Feuerlöscher — Leistung, Prüfverfahren und Bauart.';

  @override
  String get stdDescEn38PortableExtAdditional =>
      'Tragbare Feuerlöscher — Zusätzliche Anforderungen und Prüfungen.';

  @override
  String get stdDescEn39PortableExtCo2 =>
      'Tragbare Feuerlöscher — CO2-Feuerlöscher.';

  @override
  String get stdDescEn310PortableExtSpecial =>
      'Tragbare Feuerlöscher — Besondere Anforderungen.';

  @override
  String get stdDescNfpa10PortableUs =>
      'USA — Standard für tragbare Feuerlöscher.';

  @override
  String get stdDescEn18661MobileCo2 => 'Fahrbare CO2-Feuerlöscher.';

  @override
  String get stdDescTsEn615DryChemicalPowder =>
      'Feuerlöschmittel — Anforderungen an Pulverlöschmittel.';

  @override
  String get stdDescTsEn15683FoamConcentrates =>
      'Feuerlöschmittel — Schaummittel.';

  @override
  String get stdDescEn1992Eurocode2 =>
      'Stahlbetontragwerke — Tragwerksbemessung für den Brandfall (Eurocode 2).';

  @override
  String get stdDescEn1993Eurocode3 =>
      'Stahltragwerke — Tragwerksbemessung für den Brandfall (Eurocode 3).';

  @override
  String get stdDescEn1994Eurocode4 =>
      'Verbundtragwerke aus Stahl und Beton — Bemessung für den Brandfall (Eurocode 4).';

  @override
  String get stdDescEn1995Eurocode5 =>
      'Holztragwerke — Tragwerksbemessung für den Brandfall (Eurocode 5).';

  @override
  String get stdDescEn1996Eurocode6 =>
      'Mauerwerksbauten — Tragwerksbemessung für den Brandfall (Eurocode 6).';

  @override
  String get stdDescIso8341StandardFireCurve =>
      'Einheitstemperaturkurve — Feuerwiderstandsprüfung für Bauteile.';

  @override
  String get stdDescIso8342AlternativeCurves =>
      'Alternative und parametrische Brandkurven.';

  @override
  String get stdDescEn135011ReactionToFire =>
      'Klassifizierung von Bauprodukten und Bauarten zu ihrem Brandverhalten.';

  @override
  String get stdDescEn135012FireResistanceClass =>
      'Klassifizierung von Bauteilen nach ihrem Feuerwiderstand.';

  @override
  String get stdDescEn135013VentilationServices =>
      'Klassifizierung des Feuerwiderstands von Lüftungsanlagen-Bauprodukten.';

  @override
  String get stdDescEn135014SmokeControlDoors =>
      'Klassifizierung von Rauchschutztüren und Bauteilen.';

  @override
  String get stdDescEn135015Roofs =>
      'Dächer — Klassifizierung anhand von Prüfungen zur Beanspruchung durch ein Feuer von außen.';

  @override
  String get stdDescNfpa220ConstructionTypes =>
      'USA — Standard für Bauarten von Gebäuden.';

  @override
  String get stdDescUl263FireResistanceTests =>
      'USA — Feuerwiderstandsprüfungen für Bauteile und Baustoffe.';

  @override
  String get stdDescAstmE119FireEndurance =>
      'USA — Prüfverfahren für die Feuerbeständigkeit von Baustoffen und Bausystemen.';

  @override
  String get stdDescIso31000RiskManagement =>
      'Risikomanagement — Leitlinien und allgemeiner Rahmen.';

  @override
  String get stdDescIso45001Ohs =>
      'Managementsysteme für Sicherheit und Gesundheit bei der Arbeit — Anforderungen mit Anleitung zur Anwendung.';

  @override
  String get stdDescIso16069SafetyWayGuidance =>
      'Grafische Symbole — Sicherheitszeichen — Sicherheitsleitsysteme (Notbeleuchtung und Fluchtwegkennzeichnung).';

  @override
  String get stdDescEn50172EmergencyLighting =>
      'Sicherheitsbeleuchtungsanlagen für Rettungswege — Einbau und Betrieb.';

  @override
  String get stdDescNfpa1FireCode =>
      'USA — Fire Code. Gebäudenutzung, Ausgänge, Evakuierung und Gefahren.';

  @override
  String get stdDescNfpa25InspectionTesting =>
      'Wasserbasierte Feuerlöschanlagen — Inspektion, Prüfung und Instandhaltung.';

  @override
  String get stdDescEnIso7010SafetySigns =>
      'Sicherheitszeichen — Registrierte Sicherheitszeichen für Notausgänge, Brandschutzeinrichtungen und Gefahrenwarnungen.';

  @override
  String get stdDescTs9811FireSafetySigns =>
      'Türkei — Sicherheitszeichen für den Brandschutz.';

  @override
  String get stdDescTbdy2018SeismicSteelFire =>
      'Türkische Erdbebenbauverordnung — Abschnitt 3: Stahltragwerke, Brandeinwirkung.';

  @override
  String get stdDescTrFireRegulation2015 =>
      'Türkei — Anforderungen an Brandschutz, Evakuierung, Löschanlagen und Alarmsysteme in Gebäuden.';

  @override
  String get stdDescNfpa850PowerGeneration =>
      'Brandschutz für Kraftwerke — Turbinenhallen, Transformatoren und Kabeltrassen.';

  @override
  String get stdDescNfpa804NuclearPlants =>
      'Standard für den Brandschutz von Kernkraftwerken.';

  @override
  String get stdDescNfpa409AircraftHangars =>
      'Standard für den Brandschutz von Flugzeughangars.';

  @override
  String get stdDescNfpa415AircraftFueling =>
      'Flugzeugbetankungsanlagen und Arbeitsbereiche.';

  @override
  String get stdDescEn11271ExplosivePrevention =>
      'Explosionsfähige Atmosphären — Explosionsschutz, Grundlagen und Methodik.';

  @override
  String get stdDescEn6007910ZoneClassification =>
      'Explosionsfähige Atmosphären — Einteilung der Bereiche (Gase).';

  @override
  String get stdDescIec61511FunctionalSafety =>
      'Funktionale Sicherheit — Sicherheitstechnische Systeme für die Prozessindustrie.';

  @override
  String get stdDescApi610PetrochemPumps =>
      'Pumpen in petrochemischen Anlagen — Brandschutzanforderungen.';

  @override
  String get stdDescNfpa654CombustibleDust =>
      'Schutz vor Brand und Explosion durch brennbaren Staub.';

  @override
  String get stdDescNfpa68ExplosionVenting =>
      'Standard für Explosionsschutz durch Druckentlastung.';

  @override
  String get stdDescNfpa69ExplosionPrevention =>
      'Standard für Explosionsschutzsysteme.';

  @override
  String get spActOfficesAdmin => 'Büros und Verwaltungsgebäude';

  @override
  String get spActHotelsHostelsGuesthouses => 'Hotels, Herbergen, Pensionen';

  @override
  String get spActHospitalsClinics =>
      'Krankenhäuser, Kliniken, Gesundheitszentren';

  @override
  String get spActSchoolsUniversities =>
      'Schulen, Universitäten und Bildungseinrichtungen';

  @override
  String get spActResidentialApartments => 'Wohnhäuser und Apartmentgebäude';

  @override
  String get spActPrisonsReformatories => 'Gefängnisse und Besserungsanstalten';

  @override
  String get spActChurchesMosquesWorship =>
      'Kirchen, Moscheen und Gotteshäuser';

  @override
  String get spActTheatresCinemaSeating =>
      'Theater / Kinos (nur Zuschauersitzbereiche)';

  @override
  String get spActMuseumsGalleries => 'Museen und Kunstgalerien';

  @override
  String get spActBreweriesExclDistilleries => 'Brauereien (ohne Brennereien)';

  @override
  String get spActMultiStoreyBasementCarParks =>
      'Mehrgeschossige und Tiefgaragen (geschlossen)';

  @override
  String get spActCeramicsProduction => 'Herstellung von Keramikprodukten';

  @override
  String get spActGlassGlasswareExclFibre =>
      'Glas- und Glaswarenherstellung (ohne Glasfasern)';

  @override
  String get spActChemResearchLabs => 'Chemische Forschungslabore';

  @override
  String get spActDairyProcessing =>
      'Molkereien und Milchverarbeitungsbetriebe';

  @override
  String get spActElectronicsAssembly =>
      'Montagewerkstätten für elektronische Geräte';

  @override
  String get spActFoodProcessingPackaging =>
      'Lebensmittelverarbeitungs- und Verpackungsbetriebe';

  @override
  String get spActHotelsKitchenLaundryService =>
      'Hotels — Küchen-, Wäscherei- und Servicebereiche';

  @override
  String get spActInstitutionalCommercialLaundries =>
      'Institutionelle und gewerbliche Wäschereien';

  @override
  String get spActLeatherProductsProduction =>
      'Herstellung von Leder und Lederwaren';

  @override
  String get spActLightMetalworkingWorkshops =>
      'Leichte Metallverarbeitungswerkstätten';

  @override
  String get spActPharmaceuticalProduction =>
      'Pharmazeutische Produktionsanlagen';

  @override
  String get spActResearchLabsNonflamLiquids =>
      'Forschungslabore (Einsatz nicht brennbarer Flüssigkeiten)';

  @override
  String get spActTextileWeavingNaturalFibresUntreated =>
      'Textilweberei — Baumwolle/Wolle/Naturfaser (unbehandelt)';

  @override
  String get spActTobaccoProcessingPackaging =>
      'Tabakverarbeitung und -verpackung';

  @override
  String get spActAgriIndustrialMachineryAssembly =>
      'Montagebetriebe für Landmaschinen und Industriemaschinen';

  @override
  String get spActGrainFlourMillFoodProcessing =>
      'Getreide-, Mehlmühlen und ähnliche Lebensmittelverarbeitung';

  @override
  String get spActChemProductionNonflamLiquidsOnly =>
      'Chemische Produktion (nur nicht brennbare Flüssigprodukte)';

  @override
  String get spActDeptStoresShoppingCentresSingleStorey =>
      'Kaufhäuser und Einkaufszentren (eingeschossig)';

  @override
  String get spActElectricalEquipmentFactories =>
      'Fabriken für elektrische Ausrüstung';

  @override
  String get spActComputerDataProcessingRooms =>
      'Computer- und elektronische Datenverarbeitungsräume';

  @override
  String get spActGeneralEngineeringWorkshopsFactories =>
      'Allgemeine Maschinenbauwerkstätten und -fabriken';

  @override
  String get spActFruitVegCanningFacilities =>
      'Obst-, Gemüse- und Konservenverarbeitungsbetriebe';

  @override
  String get spActVehicleMaintenanceRepairGarages =>
      'Kfz-Wartungs- und Reparaturwerkstätten';

  @override
  String get spActFibreglassProductionAssembly =>
      'Herstellung und Montage von Glasfaserprodukten';

  @override
  String get spActHardwareIronmongeryStores =>
      'Eisenwaren- und Baumarktgeschäfte';

  @override
  String get spActHospitalsTreatmentSurgeryAreas =>
      'Krankenhäuser — Behandlungs- und Operationsbereiche';

  @override
  String get spActKnittingHosieryFactories => 'Strickwarenfabriken (Hosiery)';

  @override
  String get spActLibrariesOpenShelfAreas =>
      'Bibliotheken — allgemeine Freihandbereiche';

  @override
  String get spActGeneralMetalworkingFactories =>
      'Allgemeine Metallverarbeitungsfabriken';

  @override
  String get spActPaperBoardProductionFacilities =>
      'Papier- und Kartonproduktionsanlagen';

  @override
  String get spActPlasticsManufNonflamOnly =>
      'Kunststoffherstellung (nur nicht brennbare Kunststoffe)';

  @override
  String get spActGeneralPrintingWaterBasedInk =>
      'Allgemeiner Druck (Farbe auf Wasserbasis)';

  @override
  String get spActSupermarketsHypermarkets => 'Supermärkte und Hypermärkte';

  @override
  String get spActTailoringGarmentManufacture =>
      'Schneiderei, Bekleidungs- und Konfektionsherstellung';

  @override
  String get spActTextileSpinningWeavingSynthetic =>
      'Textilspinnerei und -weberei (Synthetikfaser)';

  @override
  String get spActLoadingShippingDocks => 'Lade-, Versand- und Verladerampen';

  @override
  String get spActGeneralStorageUpTo4m =>
      'Allgemeine Lagerung (Stapelhöhe ≤ 4 m)';

  @override
  String get spActAircraftHangarsMaintenance =>
      'Flugzeughangars — Wartungs- und Reparaturbereiche';

  @override
  String get spActOilclothTarpaulinCanvasProduction =>
      'Herstellung von Wachstuch, Planen und Segeltuch';

  @override
  String get spActChemProductionFpAbove55 =>
      'Chemische Produktion (Produkte mit Flammpunkt > 55 °C)';

  @override
  String get spActColdStores => 'Kühllager';

  @override
  String get spActFilmTvStudiosProduction =>
      'Film- und Fernsehstudios (Produktionsbereiche)';

  @override
  String get spActFurnitureUpholsteryProduction =>
      'Möbel- und Polsterherstellung (Schaumstoff, Stoff)';

  @override
  String get spActJoineryWoodworkingWorkshops =>
      'Schreinerei — Holzverarbeitungswerkstätten';

  @override
  String get spActMatchProductionFacilities => 'Zündholzherstellungsbetriebe';

  @override
  String get spActOfficesLargePaperArchives =>
      'Büros mit großen Papierarchivbereichen';

  @override
  String get spActWaterBasedPaintVarnishProduction =>
      'Herstellung von Farben und Lacken auf Wasserbasis';

  @override
  String get spActPaperCorrugatedBoxProduction =>
      'Verarbeitung/Herstellung von Papier, Karton und Wellpappkartons';

  @override
  String get spActThermoplasticsManufShaping =>
      'Herstellung und Formgebung von Thermoplasten';

  @override
  String get spActHighSpeedOffsetPrintingOilInk =>
      'Hochgeschwindigkeits-Offsetdruck (Farbe auf Ölbasis)';

  @override
  String get spActRubberProductsProduction =>
      'Produktionsanlagen für Gummiprodukte';

  @override
  String get spActTextileDyeingFinishingFacilities =>
      'Textilfärberei- und Veredelungsbetriebe';

  @override
  String get spActGeneralStorage4to8m =>
      'Allgemeine Lagerung (Stapelhöhe > 4 m – 8 m)';

  @override
  String get spActChemProductionClosedProcessFp55 =>
      'Chemische Produktion (geschlossener Prozess, Flammpunkt > 55 °C)';

  @override
  String get spActPlasticRubberPartsClosedMoulding =>
      'Herstellung von Kunststoff- und Gummiteilen (geschlossene Extrusion/Formgebung)';

  @override
  String get spActTextileDyeingFinishingWaterBased =>
      'Textilfärbe- und Veredelungsbetriebe (wasserbasiert)';

  @override
  String get spActPharmacyCosmeticsDetergentProduction =>
      'Produktionsanlagen für Pharmazeutika, Kosmetika und Waschmittel';

  @override
  String get spActFoodBeverageProductionHighVolume =>
      'Lebensmittel- und Getränkeproduktionsanlagen (hohes Volumen)';

  @override
  String get spActPaperProductionDryCuttingSorting =>
      'Papierproduktions- und Verarbeitungsanlagen (Trockenschneiden/-sortieren)';

  @override
  String get spActPaintShopsWaterUvCuring =>
      'Lackierbetriebe mit Wasser- oder UV-härtender Farbe';

  @override
  String get spActMetalworkingMachineryHeavySwarfOilMist =>
      'Metallverarbeitungs- und Maschinenbaubetriebe (starker Späneanfall, Ölnebel)';

  @override
  String get spActFlammableLiquidProcessFp55Plus =>
      'Verarbeitungs-/Lagerungsprozesse brennbarer Flüssigkeiten (Flammpunkt ≥ 55 °C)';

  @override
  String get spActFoamRubberFoamPlasticProduction =>
      'Produktionsanlagen für Schaumgummi und Schaumkunststoff (PU, EPS/XPS)';

  @override
  String get spActFlowCoatingMetalPlasticParts =>
      'Flutlackierung (Flow Coating) von Metall- und Kunststoffteilen';

  @override
  String get spActIndustrialPrintingFlammableInkSolvent =>
      'Industriedruckbetriebe mit brennbarer Farbe/Lösungsmittel';

  @override
  String get spActAerosolSprayPackagingFilling =>
      'Verpackungs-/Abfüllanlagen für Aerosol- und Sprühprodukte';

  @override
  String get spActFlammableLiquidProcessFpBelow55Open =>
      'Verarbeitung brennbarer Flüssigkeiten (Flammpunkt < 55 °C, offene Behälter)';

  @override
  String get spActChemProductionContainingFp55Liquids =>
      'Chemische Produktion (Produkte mit brennbarer Flüssigkeit, Flammpunkt ≥ 55 °C)';

  @override
  String get spActSolventBasedPaintVarnishProduction =>
      'Produktionsanlagen für lösungsmittelbasierte Farben und Lacke';

  @override
  String get spActSpraySolventPaintApplication =>
      'Sprühlackierbetrieb — Anwendung lösungsmittelbasierter brennbarer Farbe';

  @override
  String get spActDryCleaningPerchloroethyleneSolvent =>
      'Chemische Reinigungsbetriebe (Perchlorethylen / lösungsmittelbasiert)';

  @override
  String get spActSolventExtractionFacilities =>
      'Lösungsmittelextraktionsanlagen';

  @override
  String get spActPrintingGravureFlammableInk =>
      'Druck-/Tiefdruckbetriebe mit brennbarer Farbe';

  @override
  String get spActSprayCoatingBoothsFlammableLiquid =>
      'Sprühbeschichtungs-/Lackierkabinen mit brennbarer Flüssigkeit';

  @override
  String get spActRubberMasticFlammableRawMaterialProcessing =>
      'Verarbeitungsanlagen für Gummimastix und brennbare Rohstoffe';

  @override
  String get spActPaintInkVarnishPackagingFilling =>
      'Verpackungs- und Abfüllanlagen für Farbe, Druckfarbe oder Lack';

  @override
  String get spActHighRackPalletStorageSolidAbove4m =>
      'Hochregal-Palettenlagerung — feste Materialien, Stapelhöhe > 4 m';

  @override
  String get spActTyresRubberProductsStorage =>
      'Lagerung von Fahrzeugreifen und Gummiprodukten';

  @override
  String get spActPaperRollsReelsStorage => 'Lagerung von Papierrollen';

  @override
  String get spActSolidPlasticRawProductStoragePalletRack =>
      'Lagerung fester Kunststoffrohstoffe und -produkte (palettiert/im Regal)';

  @override
  String get spActBaledCottonTextileSyntheticFibreStorage =>
      'Lagerung von Baumwollballen, Textilrohstoffen und Synthetikfasern';

  @override
  String get spActHighRackPalletStorageFlammableLiquidAbove4m =>
      'Hochregal-Palettenlagerung — Produkte mit brennbarer Flüssigkeit, > 4 m  ⚠ Wasserintensives Sondersystem';

  @override
  String get spActAerosolStoreFlammablePropellantHighRack =>
      'Aerosolproduktlager (brennbares Treibgas, Hochregal)  ⚠ Sondersystem erforderlich';

  @override
  String get spActFlammableLiquidPackagedProductStorage =>
      'Lagerung verpackter Produkte mit brennbarer Flüssigkeit (Farbe, Lösungsmittel, Lack)  ⚠ Sondersystem';

  @override
  String get spActHighDensityStorageWaterSensitiveHighCalorific =>
      'Hochdichte Lagerung wasserempfindlicher oder hochkalorischer Produkte';

  @override
  String get spActNoncombustibleStorageMetalGlassCeramicConcrete =>
      'Lagerung nicht brennbarer Produkte — Metall-, Glas-, Keramik-, Betonprodukte';

  @override
  String get spActFrozenFoodColdChainStorage =>
      'Lagerung von Tiefkühlkost und Kühlkettenprodukten';

  @override
  String get spActNoncombustibleInSealedMetalCansDrums =>
      'Nicht brennbare Produkte in verschlossenen Metalldosen/-fässern';

  @override
  String get spActWetFoodFreshProduceCannedStorage =>
      'Lager für feuchte Lebensmittel (Frischwaren, Konserven)';

  @override
  String get spActPorcelainSanitarywareStorage =>
      'Lagerung von Porzellan- und Sanitärkeramikprodukten';

  @override
  String get spActEmptyGlassBottlesMetalCansStorage =>
      'Lagerung leerer Glasflaschen/leerer Metalldosen';

  @override
  String get spActNoncombustibleCartonPackagedStorage =>
      'Lagerung nicht brennbarer Produkte in Kartonverpackung';

  @override
  String get spActNoncombustibleGoodsWoodenCratesStorage =>
      'Lagerung nicht brennbarer Güter in Holzkisten';

  @override
  String get spActNoncombustibleLiquidGlassPlasticContainersStorage =>
      'Lagerung nicht brennbarer Flüssigkeiten in Glasflaschen/Kunststoffbehältern';

  @override
  String get spActMixedProductsLowCombustibleContentStorage =>
      'Lagerung gemischter Produkte mit geringem brennbarem Anteil';

  @override
  String get spActGlassCeramicWrappedStorage =>
      'Lagerung von in Packmaterial gewickelten Glas- und Keramikprodukten';

  @override
  String get spActPaperBoardCorrugatedProductStorage =>
      'Lagerung von Papier-, Karton- und Wellpappprodukten';

  @override
  String get spActTextileYarnFabricGarmentStorage =>
      'Lagerung von Textilien, Garn, Stoff und Bekleidung';

  @override
  String get spActWoodWoodBasedProductStorage =>
      'Lagerung von Holz- und Holzwerkstoffprodukten';

  @override
  String get spActFurnitureUpholsteryMaterialsStorage =>
      'Lagerung von Möbeln und Polstermaterialien';

  @override
  String get spActMixedPackagedGoodsPaperPlastic =>
      'Lagerung gemischt verpackter Güter (Papier + Kunststoff kombiniert)';

  @override
  String get spActDryFoodAgriculturalProductsStorage =>
      'Lagerung von Trockenlebensmitteln und Agrarprodukten (nicht lose)';

  @override
  String get spActLeatherProductsStorage => 'Lagerung von Leder und Lederwaren';

  @override
  String get spActSmallElectricalApplianceStoragePackaged =>
      'Lagerung kleiner elektrischer Haushaltsgeräte (verpackt)';

  @override
  String get spActExpandedPlasticProductStorageFloor =>
      'Lagerung von Schaumkunststoffprodukten (EPS, PU, XPS) (bodengestapelt)';

  @override
  String get spActRubberTyreProductStorageFloor =>
      'Lagerung von Gummi- und Reifenprodukten (bodengestapelt)';

  @override
  String get spActFlammableLiquidPlasticContainersStorageFloor =>
      'Lagerung von Kunststoffbehältern mit brennbarer Flüssigkeit (bodengestapelt)';

  @override
  String get spActAerosolProductStorageFloor35m =>
      'Lagerung von Aerosolprodukten — bodengestapelt, ≤ 3,5 m';

  @override
  String get spActPolystyreneFoamPackagedProductStorage =>
      'Lagerung von Polystyrolschaum-verpackten Produkten';

  @override
  String get spActHighCalorificCombustibleGoodsStorageFloor =>
      'Lagerung brennbarer Güter mit hohem Heizwert (bodengestapelt)';

  @override
  String get spActRackPalletCategoryIGoods =>
      'Regal-/Palettensystem — Güter der Kategorie I (Metall, Glas, Keramik)';

  @override
  String get spActHighRackNoncombustibleStorageAbove3m =>
      'Hochregallagerung — nicht brennbare Produkte, Stapelhöhe > 3 m';

  @override
  String get spActPalletSealedMetalGlassStorage =>
      'Palettierte Lagerung verschlossener Metall-/Glasprodukte';

  @override
  String get spActColdStoreHighRackSystem => 'Kühllager mit Hochregalsystem';

  @override
  String get spActRackPalletCategoryIIGoods =>
      'Regal-/Palettensystem — Güter der Kategorie II (kartonverpackt)';

  @override
  String get spActHighRackCartonBoxedNoncombustibleStorage =>
      'Hochregallagerung — nicht brennbare Produkte in Kartons';

  @override
  String get spActPalletCartonPackagedStorageAbove3m =>
      'Palettierte Lagerung kartonverpackter Produkte, > 3 m';

  @override
  String get spActWoodenCrateStorageHighRack =>
      'Lagerung in Holzkisten, Hochregalsystem';

  @override
  String get spActRackPalletCategoryIIIGoods =>
      'Regal-/Palettensystem — Güter der Kategorie III (Papier, Textil, Holz)';

  @override
  String get spActHighRackFurnitureWoodProductsStorage =>
      'Hochregallagerung — Möbel, Holzprodukte';

  @override
  String get spActBaledCottonTextileRackStorageAbove3m =>
      'Regallagerung von Baumwoll-/Textilballen, > 3 m';

  @override
  String get spActPaperRollsRackStorageAbove3m =>
      'Regallagerung von Papierrollen, > 3 m';

  @override
  String get spActMixedPackagedHighRackStorage =>
      'Hochregallagerung gemischt verpackter Güter (Papier + Kunststoff)';

  @override
  String get spActRackPalletCategoryIVGoods =>
      'Regal-/Palettensystem — Güter der Kategorie IV (Kunststoff, Gummi, Schaumstoff)';

  @override
  String get spActExpandedPlasticFoamHighRackStorage =>
      'Hochregallagerung von Schaumkunststoff- und Schaumprodukten';

  @override
  String get spActAerosolRackStorageFlammablePropellantAbove3m =>
      'Regallagerung von Aerosolprodukten — brennbares Treibgas, > 3 m';

  @override
  String get spActSolidPlasticRawProductHighRackStorage =>
      'Hochregallagerung fester Kunststoffrohstoffe und -produkte';

  @override
  String get spActFlammablePackagedProductHighRackStorage =>
      'Hochregallagerung verpackter brennbarer Produkte (Farbe, Lack, Lösungsmittel)';

  @override
  String get spActRubberTyreProductHighRackStorageAbove3m =>
      'Hochregallagerung von Gummi- und Reifenprodukten, > 3 m';
}
