// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get languageLabel => 'Language';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get logout => 'Sign out';

  @override
  String get save => 'Save';

  @override
  String get saved => 'Saved!';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get deletingAccount => 'Deleting account...';

  @override
  String get accountDeleteTitle => 'Do you want to delete your account?';

  @override
  String get accountDeleteWarning =>
      'Your account will be removed from the active system. Your name, email, previous membership status, and registration/deletion dates will be retained in the deleted-members history for administrators. This action cannot be undone.';

  @override
  String get accountManagement => 'Account Management';

  @override
  String get accountDeleteInfo =>
      'You can permanently delete your account and account information stored on this device.';

  @override
  String get deleteAccount => 'Permanently Delete My Account';

  @override
  String get feedbackTitle => 'Feedback';

  @override
  String get feedbackSubtitle => 'Found a problem? Let us know.';

  @override
  String get feedbackSelectPage => 'Which page is this about?';

  @override
  String get feedbackSelectPageHint => 'Select a page';

  @override
  String get feedbackMessageLabel => 'Describe the issue';

  @override
  String get feedbackMessageHint => 'Write the problem you encountered here...';

  @override
  String get feedbackSend => 'Send';

  @override
  String get feedbackSending => 'Sending...';

  @override
  String get feedbackSentSuccess => 'Thanks for your feedback!';

  @override
  String get feedbackSendFailed =>
      'Feedback could not be sent. Please try again.';

  @override
  String get feedbackMessageRequired => 'Please write a message.';

  @override
  String get feedbackPageHome => 'Home';

  @override
  String get feedbackPageOther => 'Other';

  @override
  String get apiKeyTitle => 'Gemini API Key (AI)';

  @override
  String get apiKeyInstructions =>
      'Get a free API key at aistudio.google.com/apikey.';

  @override
  String get getApiKey => 'Get an API key';

  @override
  String get updateApiKey => 'Update API key';

  @override
  String get add => 'Add';

  @override
  String get done => 'Done';

  @override
  String get smokeReference =>
      'TS EN 54-7:2006 / EN 54-14:2004 — Point-type smoke detector layout\nPreliminary sizing only; final design requires approval by a system engineer.';

  @override
  String get buildingType => 'Building Type';

  @override
  String get buildingOffice => 'Office / Administrative';

  @override
  String get buildingHome => 'Residential / Hotel';

  @override
  String get buildingHospital => 'Hospital';

  @override
  String get buildingCommercial => 'Commercial / Shopping Centre';

  @override
  String get buildingWarehouseNormal => 'Warehouse (standard â‰¤ 6 m)';

  @override
  String get buildingWarehouseHigh => 'Warehouse (high-bay > 6 m)';

  @override
  String get buildingIndustrial => 'Industrial';

  @override
  String defaultCeilingHeight(String height) {
    return 'Default ceiling height: $height m';
  }

  @override
  String get editablePerRoom => 'Can be adjusted for each room';

  @override
  String get addFloorZone => 'Add Floor / Zone';

  @override
  String get floorZone => 'Floor / Zone';

  @override
  String get totalDetectors => 'Total Detectors';

  @override
  String detectorCount(int count) {
    return '$count';
  }

  @override
  String get addRoomArea => 'Add Room / Area';

  @override
  String get editRoomArea => 'Edit Room';

  @override
  String get roomAreaName => 'Room / Area Name';

  @override
  String get roomAreaExample => 'e.g. Canteen, Server Room…';

  @override
  String get areaType => 'Area Type';

  @override
  String get validDimensions => 'Enter valid dimensions.';

  @override
  String get roomNameRequired => 'Room name cannot be empty.';

  @override
  String get roomStandard => 'Standard Room';

  @override
  String get roomOpenOffice => 'Open-plan Office';

  @override
  String get roomTechnical => 'Technical / Utilities';

  @override
  String get roomKitchen => 'Kitchen / Cooking';

  @override
  String get roomCorridor => 'Corridor (W â‰¤ 3 m)';

  @override
  String get roomProduction => 'Production / Assembly';

  @override
  String get roomWarehouseRack => 'Warehouse Rack';

  @override
  String get sourceLabel => 'Source';

  @override
  String get deleteProjectTitle => 'Delete Project';

  @override
  String deleteProjectConfirm(String name) {
    return 'Delete project \"$name\"?';
  }

  @override
  String get noSavedProjects => 'No saved projects yet';

  @override
  String get saveProjectPrompt => 'Save calculation as a project';

  @override
  String get saveProjectTitle => 'Save Project';

  @override
  String get projectName => 'Project Name';

  @override
  String get projectNameExample => 'e.g. Office Building Ground Floor';

  @override
  String projectSaved(String name) {
    return '\"$name\" saved';
  }

  @override
  String get copy => 'Copy';

  @override
  String get edit => 'Edit';

  @override
  String floorZoneSummary(int areas, int detectors) {
    return '$areas areas · $detectors detectors';
  }

  @override
  String detectorBadge(int count) {
    return '$count det.';
  }

  @override
  String get highCeilingNotice =>
      '⚠ H > 12 m — Beam-type / ASD detectors are required (EN 54-12 / EN 54-20)';

  @override
  String get beamRecommendation => 'ℹ H = 8–12 m — Consider beam detectors';

  @override
  String widthSpacing(Object value) {
    return 'Width spacing: $value m';
  }

  @override
  String lengthSpacing(Object value) {
    return 'Length spacing: $value m';
  }

  @override
  String wallDistanceWidth(Object value) {
    return 'Wall distance W: $value m';
  }

  @override
  String wallDistanceLength(Object value) {
    return 'Wall distance L: $value m';
  }

  @override
  String corridorSpacing(Object value) {
    return 'Corridor spacing: $value m';
  }

  @override
  String wallDistance(Object value) {
    return 'Wall distance: $value m';
  }

  @override
  String snAreaPerDetector(Object value) {
    return 'S_n = $value m²/detector.';
  }

  @override
  String get systemLanguage => 'Device language';

  @override
  String get turkish => 'Türkçe';

  @override
  String get english => 'English';

  @override
  String get german => 'Deutsch';

  @override
  String get loginSubtitle => 'Sign in to your account';

  @override
  String get emailAddress => 'Email address';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get validEmailRequired => 'Enter a valid email address';

  @override
  String get password => 'Password';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get loggingIn => 'Signing in...';

  @override
  String get login => 'Sign In';

  @override
  String get demoLogin => 'Enter Demo (Kitchen Hood Suppression)';

  @override
  String get accountPrompt => 'Don\'t have an account yet? ';

  @override
  String get register => 'Create an account â†’';

  @override
  String get preliminaryToolDisclaimer =>
      'Preliminary calculation tool · Not an official design calculation';

  @override
  String get fireSafetyCalculator => 'Fire Safety Calculation Center';

  @override
  String get fireLoadTitle => 'Fire Load Calculation';

  @override
  String get fireLoadDescription =>
      'Fire load density per EN 1991-1-2 and extinguishing agent calculations per ISO 14520 / EN 12845';

  @override
  String get kitchenSuppressionTitle => 'Kitchen Hood Suppression';

  @override
  String get kitchenSuppressionDescription =>
      'Commercial kitchen hood suppression — NFPA 17A / TS EN 15751 / UL 300';

  @override
  String get gasSuppressionTitle => 'Gaseous Fire Suppression';

  @override
  String get gasSuppressionDescription =>
      'Total flooding systems and printing presses — EN 15004 / NFPA 2001 · FM-200 · Novec 1230 · CO₂ · inert gases';

  @override
  String get lithiumFireTitle => 'Lithium Battery Fire';

  @override
  String get lithiumFireDescription =>
      'ESS cooling requirements — ISO 3941:2026 · NFPA 855:2023 · IEC 62619 · FM Global DS 5-33';

  @override
  String get sprinklerTitle => 'Sprinkler System';

  @override
  String get sprinklerDescription =>
      'Hydraulic calculations, pump sizing and pipe diameters by EN 12845 hazard class';

  @override
  String get smokeDetectionTitle => 'Smoke Detection';

  @override
  String get smokeDetectionDescription =>
      'Detector placement and room types — EN 54-7 / EN 54-14';

  @override
  String get smokeControlTitle => 'Smoke Control';

  @override
  String get smokeControlDescription =>
      'Natural and mechanical exhaust, pressurization — EN 12101-2 / EN 12101-3 / EN 12101-6';

  @override
  String get demoMode =>
      'DEMO MODE · Only the \"Kitchen Hood Suppression\" module is available. Create an account and subscribe to access other modules.';

  @override
  String get standardSearch => 'Standards Search';

  @override
  String get standardSearchDescription =>
      'Search fire and safety standards by number, title or category';

  @override
  String get standardGuide => 'Standards Guide';

  @override
  String get standardGuideDescription =>
      'Fire system standard categories, scope and reference summary';

  @override
  String get fireAndSuppression => 'Fire Load & Suppression';

  @override
  String get kitchenSuppression => 'Kitchen Hood Suppression';

  @override
  String get gasSuppression => 'Gas Suppression System';

  @override
  String get printingSuppression => 'Printing Press Suppression';

  @override
  String get sprinklerSystems => 'Sprinkler System';

  @override
  String get fireAlarm => 'Fire Alarm & Detection';

  @override
  String get fireExtinguishers => 'Fire Extinguishers';

  @override
  String get smokeControl => 'Smoke Control & Evacuation';

  @override
  String get savedProjects => 'Saved Projects';

  @override
  String get savedProjectsDescription =>
      'All calculation projects you have saved';

  @override
  String get addStandard => 'Add Standard';

  @override
  String get allCategories => 'All categories';

  @override
  String get standardSearchHint => 'Number, title or category...';

  @override
  String standardsFound(int count) {
    return '$count standards found';
  }

  @override
  String category(String name) {
    return 'Category: $name';
  }

  @override
  String get close => 'Close';

  @override
  String get searchWeb => 'Search the web';

  @override
  String get askAi => 'Ask AI';

  @override
  String get moduleDisclaimer =>
      'MEVOS Fire · Preliminary fire safety calculation tool; not an official design calculation.';

  @override
  String get hoodSystemDescription =>
      'Commercial kitchen hood suppression system sizing.\nReferences: NFPA 17A:2021 · TS EN 15751:2016 · UL 300 · Ansul R-102';

  @override
  String get hoodEquipmentHeading => 'Appliances Under the Hood';

  @override
  String get hoodEquipmentInstructions =>
      'Adjust appliance quantities with + / -. The hazard class is calculated automatically from your selection.';

  @override
  String hoodHazardClass(Object category) {
    return 'Hazard Class: $category';
  }

  @override
  String hoodEquipmentScore(Object count, Object score) {
    return 'Equipment score: $score · $count selected · < 2 › Low · 2–5 › Medium · ≥ 5 › High';
  }

  @override
  String get hoodFilterArea => 'Hood Filter Area (internal dimensions)';

  @override
  String get singleLength => 'Length';

  @override
  String get singleWidth => 'Width';

  @override
  String get hazardLight => 'Light';

  @override
  String get hazardMedium => 'Medium';

  @override
  String get hazardMediumHigh => 'Medium–High';

  @override
  String get hazardHigh => 'High';

  @override
  String get hazardVeryHigh => 'Very High';

  @override
  String get hoodToastSandwichMachine => 'Toaster / Sandwich Press';

  @override
  String get hoodSmallElectricOven => 'Small Electric Oven';

  @override
  String get hoodConvectionOven => 'Convection Oven';

  @override
  String get hoodSingleBurnerRange => 'Range (1 burner)';

  @override
  String get hoodDoubleBurnerRange => 'Range (2 burners)';

  @override
  String get hoodFourToSixBurnerRange => 'Range (4–6 burners)';

  @override
  String get hoodWokRange => 'Wok Range';

  @override
  String get hoodDoubleWokRange => 'Double Wok Range';

  @override
  String get hoodSalamanderGrill => 'Salamander Grill';

  @override
  String get hoodCharbroilerGrill => 'Charbroiler / Grill';

  @override
  String get hoodFryerUpTo22L => 'Fryer (≤ 22 L)';

  @override
  String get hoodFryerOver22L => 'Fryer (> 22 L)';

  @override
  String get hoodTiltingSkillet => 'Tilting Skillet';

  @override
  String get calculate => 'Calculate';

  @override
  String get calculateExtinguishingAgent => 'Calculate Suppression Agent';

  @override
  String get calculateCooling => 'Calculate Cooling Requirement';

  @override
  String get recalculate => 'Recalculate';

  @override
  String get calculationResults => 'Calculation Results';

  @override
  String get noResults => 'No results found';

  @override
  String get extinguishingAgent => 'Suppression Agent';

  @override
  String get chemicalAgentAmount => 'Chemical Agent Amount';

  @override
  String get minimumNozzleCount => 'Minimum Nozzle Count';

  @override
  String get minimumDischargeTime => 'Minimum Discharge Time';

  @override
  String get systemType => 'System Type';

  @override
  String get naturalExhaust => 'Natural Smoke Exhaust';

  @override
  String get mechanicalExhaust => 'Mechanical Smoke Exhaust';

  @override
  String get pressurization => 'Pressurization';

  @override
  String get roomArea => 'Room Area';

  @override
  String get ceilingHeight => 'Ceiling Height';

  @override
  String get designFirePower => 'Design HRR (Fire Power)';

  @override
  String get ambientTemperature => 'Ambient Temperature';

  @override
  String get doorWidth => 'Door Width';

  @override
  String get doorHeight => 'Door Height';

  @override
  String get stairShaftWidth => 'Stair Shaft Width';

  @override
  String get stairShaftDepth => 'Stair Shaft Depth';

  @override
  String get floorHeight => 'Floor Height';

  @override
  String get floorCount => 'Number of Floors';

  @override
  String get shaftWallMaterial => 'Shaft Wall Material';

  @override
  String get extinguishingDesignResult => 'Suppression System Sizing Result';

  @override
  String get smokeTemperature => 'Smoke Temperature';

  @override
  String get temperatureRise => 'Temperature Rise';

  @override
  String get effectiveOpening => 'Required Effective Opening';

  @override
  String get freshAirInlet => 'Minimum Fresh Air Inlet';

  @override
  String get fanDesignFlow => 'Fan Design Flow Rate';

  @override
  String get calculatedAirChanges => 'Calculated Air Changes';

  @override
  String get targetPressureDifference => 'Target Pressure Difference';

  @override
  String get openDoorFlow => 'Open Door Flow Rate';

  @override
  String get closedDoorLeakage => 'Closed Door Leakage / Floor';

  @override
  String get wallLeakage => 'Wall Leakage (All Floors)';

  @override
  String get totalFanFlow => 'Total Fan Flow Rate';

  @override
  String get sourceStandards => 'Reference Standards';

  @override
  String get unknown => 'Unknown';

  @override
  String get smokeControlStandards =>
      'EN 12101-2 Natural · EN 12101-3 Mechanical · EN 12101-6 Pressurization';

  @override
  String get designFirePowerHint =>
      'Design fire power — EN 1991-1-2 Annex E. Example: medium-risk office ≈ 500 kW';

  @override
  String get unknownFirePowerButton =>
      'I don\'t know the HRR — Calculate the fire load';

  @override
  String get smokeLayerHeight => 'Smoke Layer Interface Height z';

  @override
  String get smokeLayerHeightHint =>
      'Upper boundary of the clear air layer, measured from floor level. z must be < H. Target z ≥ 2.5 m';

  @override
  String get pressurizationConditions =>
      'Target ΔP = 50 Pa, door gap 10 mm (EN 12101-6 §7.3.3 / Annex F Table F.1)';

  @override
  String get naturalExhaustResult =>
      'Natural Smoke Exhaust Results (EN 12101-2)';

  @override
  String get mechanicalExhaustResult =>
      'Mechanical Smoke Exhaust Results (EN 12101-3)';

  @override
  String get pressurizationResult => 'Pressurization Results (EN 12101-6)';

  @override
  String get smokeMassFlow => 'Smoke mass flow rate';

  @override
  String get smokeVolumeFlow => 'Volumetric smoke flow rate';

  @override
  String get minimumFreshAir => 'Minimum fresh air inlet';

  @override
  String get batteryTechnology => 'Battery Chemistry';

  @override
  String get nmcDescription =>
      'Nickel Manganese Cobalt · 30 MJ/kWh — High energy density, moderate stability';

  @override
  String get lfpDescription =>
      'Lithium Iron Phosphate · 12 MJ/kWh — Lower heat release, high safety';

  @override
  String get ncaDescription =>
      'Nickel Cobalt Aluminum · 35 MJ/kWh — Highest energy density';

  @override
  String get lcoDescription =>
      'Lithium Cobalt Oxide · 35 MJ/kWh — Consumer electronics';

  @override
  String get essLithiumFireInfo =>
      'ISO 3941:2026 · NFPA 855:2023 · IEC 62619:2022 · FM Global DS 5-33\nIn lithium-ion/polymer battery fires, cooling — not gaseous suppression — is essential due to thermal runaway. The calculation below is for preliminary sizing only.';

  @override
  String get nmcThermalRunawayNote =>
      'NMC/NCM: Nickel Manganese Cobalt — 30 MJ/kWh thermal runaway heat (IEC 62619)';

  @override
  String get lfpThermalRunawayNote =>
      'LFP: Lithium Iron Phosphate — 12 MJ/kWh thermal runaway heat (IEC 62619)';

  @override
  String get ncaThermalRunawayNote =>
      'NCA: Nickel Cobalt Aluminum — 35 MJ/kWh thermal runaway heat (IEC 62619)';

  @override
  String get lcoThermalRunawayNote =>
      'LCO: Lithium Cobalt Oxide — 35 MJ/kWh thermal runaway heat (IEC 62619)';

  @override
  String get hazardClassificationBasisNote =>
      'NFPA 855:2023 §4.4.2 — Basis for hazard classification';

  @override
  String get fmGlobalMinDurationNote =>
      'FM Global DS 5-33 min. duration: 30 min  —  NFPA 855:2023 §12.4';

  @override
  String get essHazardCategoryInfo =>
      'NFPA 855:2023 Hazard Category & FM DS 5-33 Application Density:\n  • Low  (< 20 kWh)  ›  8.2 L/min/m²\n  • Ordinary   (20–600 kWh)  ›  12.2 L/min/m²\n  • High (> 600 kWh)  ›  16.3 L/min/m²';

  @override
  String get essResultsFooterNote =>
      '• Heat coefficient: NMC 30 · LFP 12 · NCA/LCO 35 MJ/kWh  (IEC 62619:2022)\n• Peak HRR coefficient: NMC 3.0 · LFP 1.5 · NCA/LCO 3.5 kW/kWh  (SP 2022:08)\n• t² growth: α=0.0469 kW/s² (fast class · ISO 16734 / NFPA 72)\n• F-500 concentration: 1.5% (manufacturer test data — Enviro Voraxial)\n• Water mist alternative: NFPA 750 / TS EN 14972-1\n• Large ESS (> 600 kWh): IEC 63272, UL 9540A testing mandatory\n• This calculation is for preliminary sizing only. An FM Global DS 5-33 approved system is required.';

  @override
  String get evLithiumFireInfo =>
      'ISO 6469 · NFPA 88A:2021 · VdS 3471:2023 · IEC 62619:2022\nIn electric vehicle fires, thermal runaway is managed with cooling; gaseous or dry-chemical suppression is ineffective.';

  @override
  String get passengerCarSpecNote =>
      'Automobile — 30–100 kWh\n400–600 L/min · 60 min min. (VdS 3471)';

  @override
  String get lightCommercialSpecNote =>
      'Van / Minibus — 60–120 kWh\n600 L/min · 60 min min.';

  @override
  String get heavyCommercialSpecNote =>
      'Electric bus/truck — 200–600 kWh\n1,000 L/min · 90 min min.';

  @override
  String get nmcHeatValue => 'Nickel Manganese Cobalt — 30 MJ/kWh';

  @override
  String get lfpHeatValue => 'Lithium Iron Phosphate — 12 MJ/kWh';

  @override
  String get ncaHeatValue => 'Nickel Cobalt Aluminum — 35 MJ/kWh';

  @override
  String get lcoHeatValue => 'Lithium Cobalt Oxide — 35 MJ/kWh';

  @override
  String get vehicleBatteryCapacityNote =>
      'Single vehicle battery capacity — basis for the IEC 62619 thermal runaway calculation';

  @override
  String get maxSimultaneousVehiclesNote =>
      'VdS 3471:2023 — max. 2 vehicles burning simultaneously assumed';

  @override
  String get vehicleApplicationDurationNote =>
      'Passenger / light commercial min. 60 min · heavy commercial min. 90 min  (VdS 3471:2023)';

  @override
  String get vdsMinimumFlowInfo =>
      'VdS 3471:2023 Minimum Flow per Vehicle:\n  • Passenger car < 60 kWh  ›  400 L/min\n  • Passenger car ≥ 60 kWh  ›  600 L/min\n  • Light commercial           ›  600 L/min\n  • Heavy commercial / Bus  ›  1,000 L/min';

  @override
  String get evResultsFooterNote =>
      '• Heat coefficient: NMC 30 · LFP 12 · NCA/LCO 35 MJ/kWh  (IEC 62619:2022)\n• Peak HRR: passenger <60kWh›3MW, ?60kWh›6MW · light commercial›8MW · heavy›15MW  (SP 2021:11)\n• t² growth model: ?=0.1876 kW/s² (ultra-fast · ISO 16734 / NFPA 72 Table B.2.3)\n• Water flow: VdS 3471:2023 — 2 vehicles simultaneous (parking garage)\n• Container immersion: 3,000 L/vehicle (BRE Global / SFPE)\n• Enclosed parking garage: NFPA 88A:2021 sprinklers required\n• This calculation is for preliminary sizing only.';

  @override
  String heatPerVehicleMj(String value) {
    return '$value MJ/vehicle';
  }

  @override
  String avgHrrPerVehicleMw(String value) {
    return '$value MW/vehicle';
  }

  @override
  String get installedCapacity => 'Installed Capacity (ESS)';

  @override
  String get protectedArea => 'Protected Area (ESS footprint)';

  @override
  String get applicationDuration => 'Application Duration';

  @override
  String get batteryCapacity => 'Vehicle Battery Capacity';

  @override
  String get vehicleCount => 'Number of Vehicles (risk area)';

  @override
  String get vehicleType => 'Vehicle Type';

  @override
  String get passengerCar => 'Passenger Car';

  @override
  String get lightCommercial => 'Light Commercial Vehicle';

  @override
  String get heavyCommercialBus => 'Heavy Commercial Vehicle / Bus';

  @override
  String get essStationary => 'ESS / Stationary Storage';

  @override
  String get electricVehicleMode => 'Electric Vehicle';

  @override
  String get coolingCalculationResult => 'Cooling Calculation Result';

  @override
  String get electricVehicleFireResult => 'Electric Vehicle Fire Calculation';

  @override
  String get thermalRunawayHeat => 'Thermal Runaway Heat';

  @override
  String get estimatedPeakHrr => 'Estimated Peak HRR';

  @override
  String get timeToPeak => 'Time to Peak';

  @override
  String get minimumFlowRate => 'Minimum Flow Rate';

  @override
  String get totalWaterVolume => 'Total Water Volume';

  @override
  String get f500Amount => 'F-500 Quantity (1.5% solution)';

  @override
  String get averageHeatReleaseRate => 'Average Heat Release Rate (HRR)';

  @override
  String get vehicleMinimumFlow => 'Minimum Flow per Vehicle';

  @override
  String get simultaneousVehicleFlow =>
      'Total Flow (maximum 2 simultaneous vehicles)';

  @override
  String get containerImmersion => 'Container Immersion (alternative)';

  @override
  String get fireRiskCategory => 'NFPA 855 Hazard Category';

  @override
  String get netProtectionVolume => 'Net Protected Volume';

  @override
  String get minimumDesignTemperature => 'Minimum Design Temperature';

  @override
  String get altitudeCorrection =>
      'Altitude correction (TS EN 15004-1 Annex A)';

  @override
  String get safetyMargin => '10% Safety Margin (TS EN 15004-1 §5.5)';

  @override
  String get fireClass => 'Fire Class';

  @override
  String get surfaceClassA => 'Class A (Surface)';

  @override
  String get deepClassA => 'Class A (Deep-Seated)';

  @override
  String get classB => 'Class B';

  @override
  String get classC => 'Class C';

  @override
  String get gasAgent => 'Extinguishing Gas';

  @override
  String get designConcentration => 'Design Concentration (%)';

  @override
  String get dischargeDuration => 'Discharge Time';

  @override
  String get nozzleDiameter => 'Nozzle Diameter';

  @override
  String get automaticNozzle => 'Automatic (area/volume based)';

  @override
  String get roomDimensions => 'Room Dimensions';

  @override
  String get directVolume => 'Direct Volume';

  @override
  String get gasRoomTab => 'Enclosure';

  @override
  String get gasPrintingTab => 'Printing Press';

  @override
  String get gasPanelTab => 'Inside Panel';

  @override
  String get machineType => 'Machine Type';

  @override
  String get inkSolventType => 'Ink / Solvent Type';

  @override
  String get measureCabinet => 'Measure Cabinet';

  @override
  String get unitCabinetVolume => 'Unit Cabinet Volume';

  @override
  String get printingUnitCount => 'Number of Printing Units';

  @override
  String get agentPerUnit => 'Agent per Unit';

  @override
  String get totalAgent => 'Total Agent';

  @override
  String get backupCylinderCount => 'Backup Supply Cylinders';

  @override
  String get totalCylinders => 'Total Cylinders (Main + Backup)';

  @override
  String get cleanAgent => 'Clean Agent';

  @override
  String get panelDimensions => 'Panel Dimensions';

  @override
  String get panelCabinetVolume => 'Panel / Cabinet Volume';

  @override
  String get standard => 'Standard';

  @override
  String get certification => 'Certification';

  @override
  String get maximumTubingLength => 'Maximum Tubing Length';

  @override
  String get estimatedAgentAmount => 'Estimated Agent Quantity';

  @override
  String get buildingDimensions => 'Building Dimensions';

  @override
  String get buildingActivity => 'Building Occupancy';

  @override
  String get activitySearch => 'Search occupancies…';

  @override
  String get advancedDesignOptions => 'Advanced Design Options';

  @override
  String get pipeMaterial => 'Pipe Material';

  @override
  String get spPipeGalvanizedSteel => 'Galvanized Steel (Sch.40)';

  @override
  String get spPipeBlackCarbonSteelWelded => 'Black Carbon Steel — welded';

  @override
  String get spPipeCopper => 'Copper Pipe';

  @override
  String get spPipeStainlessSteel => 'Stainless Steel';

  @override
  String get spPipeCpvcPlastic => 'CPVC Plastic Pipe';

  @override
  String get sprinklerType => 'Sprinkler Type (K-Factor)';

  @override
  String get installationClassPump => 'Installation Class / Pump Redundancy';

  @override
  String get dryPipeSystem => 'Dry-pipe system (areas at risk of freezing)';

  @override
  String get rackStorage =>
      'Rack / pallet storage — In-rack sprinklers (preliminary design)';

  @override
  String get rackLevels => 'Rack Levels (in-rack tiers)';

  @override
  String get foamSystem => 'Foam System';

  @override
  String get addFoamSystem => 'Add foam suppression system (EN 13565-2)';

  @override
  String get flammableLiquidCategory => 'Flammable Liquid Category';

  @override
  String get hydrocarbon => 'Hydrocarbon (B1)';

  @override
  String get polarSolvent => 'Polar Solvent (B2)';

  @override
  String get foamConcentrateType => 'Foam Concentrate Type';

  @override
  String get foamType => 'Foam Type';

  @override
  String get minimumApplicationTime => 'Minimum Application Time';

  @override
  String get ceilingSuspended => 'Suspended Ceiling';

  @override
  String get suspendedCeilingExists =>
      'Suspended ceiling present (concealed void)';

  @override
  String get voidDepth => 'Void Depth (cm)';

  @override
  String get building => 'Building';

  @override
  String get electricalPanel => 'Electrical Panel';

  @override
  String get fuelOrStorage => 'Fuel / Storage';

  @override
  String get buildingUseType => 'Building / Occupancy Type';

  @override
  String get chooseBuildingUseType => 'Select Building / Occupancy Type';

  @override
  String get referenceDensity => 'Reference Fire Load Density';

  @override
  String get growthRate => 'Fire Growth Rate';

  @override
  String get growthRateVerySlow => 'Very Slow';

  @override
  String get growthRateSlow => 'Slow';

  @override
  String get growthRateMedium => 'Medium';

  @override
  String get growthRateFast => 'Fast';

  @override
  String get growthRateVeryFast => 'Very Fast';

  @override
  String get floorArea => 'Floor Area A (m²)';

  @override
  String get cabinetNozzlePressure =>
      'Fire Hose Cabinet Nozzle Pressure (min. 4 bar)';

  @override
  String get combustibleMaterials => 'Combustible Materials';

  @override
  String get addMaterial => 'Add Material';

  @override
  String get woodTimber => 'Wood / Timber';

  @override
  String get savedValues => 'Saved Values';

  @override
  String get noSavedCalculationResult =>
      'No saved calculation result is available for this project.';

  @override
  String get apiKeyEnter => 'Enter your Gemini API key';

  @override
  String get searchBuildingTypes => 'Search building types…';

  @override
  String get material => 'Material';

  @override
  String get massKg => 'Mass (kg)';

  @override
  String get netCalorificValue => 'NCV (MJ/kg)';

  @override
  String get capacityTank => 'Capacity / tank';

  @override
  String get unit => 'Unit';

  @override
  String get quantity => 'Quantity';

  @override
  String get standardNumber => 'Standard Number *';

  @override
  String get standardNumberExample => 'e.g. EN 12345';

  @override
  String get description => 'Description *';

  @override
  String get shortDescriptionHint => 'Short description of the standard…';

  @override
  String get topicKeyword => 'Topic or Keyword';

  @override
  String get topicKeywordExample => 'e.g. smoke curtain, office sprinkler…';

  @override
  String get questionHint => 'Type your question…';

  @override
  String get searchActivity => 'Search occupancies…';

  @override
  String get unitWidth => 'W (m)';

  @override
  String get unitLength => 'L (m)';

  @override
  String get unitHeight => 'H (m)';

  @override
  String get searchMaterials => 'Search materials…';

  @override
  String get solid => 'Solid';

  @override
  String get liquid => 'Liquid';

  @override
  String get gas => 'Gas';

  @override
  String get other => 'Other';

  @override
  String get lowHazardAppendix => 'Light Hazard (Annex 1/A)';

  @override
  String get ordinaryHazardAppendix => 'Ordinary Hazard (Annex 1/B)';

  @override
  String get highHazardAppendix => 'High Hazard (Annex 1/C)';

  @override
  String get unclassified => 'Unclassified';

  @override
  String materialGroupCount(String category, int count) {
    return '$category · $count materials';
  }

  @override
  String get materialWoodTimber => 'Wood / Timber';

  @override
  String get materialPlywoodMdf => 'Plywood / MDF';

  @override
  String get materialPaperCardboard => 'Paper / Cardboard';

  @override
  String get materialCottonTextile => 'Textile (cotton)';

  @override
  String get materialSyntheticTextile => 'Textile (synthetic)';

  @override
  String get materialWool => 'Wool';

  @override
  String get materialClothing => 'Clothing';

  @override
  String get materialLeather => 'Leather';

  @override
  String get materialPolyethylene => 'Polyethylene (PE)';

  @override
  String get materialPolypropylene => 'Polypropylene (PP)';

  @override
  String get materialRigidPvc => 'PVC (rigid)';

  @override
  String get materialFlexiblePvc => 'PVC (flexible/cable)';

  @override
  String get materialPolystyrene => 'Polystyrene (PS)';

  @override
  String get materialEpsFoam => 'EPS foam';

  @override
  String get materialXpsFoam => 'XPS foam';

  @override
  String get materialAbsPlastic => 'ABS plastic';

  @override
  String get materialPmma => 'PMMA (acrylic glass)';

  @override
  String get materialEpoxyResin => 'Epoxy resin';

  @override
  String get materialPolyesterResin => 'Polyester resin (GRP/FRP)';

  @override
  String get materialRigidPolyurethaneFoam => 'Polyurethane foam (rigid)';

  @override
  String get materialFlexiblePolyurethaneFoam => 'Polyurethane foam (flexible)';

  @override
  String get materialNaturalRubber => 'Rubber (natural)';

  @override
  String get materialVehicleTire => 'Tire (vehicle)';

  @override
  String get materialGasoline => 'Gasoline';

  @override
  String get materialDiesel => 'Diesel';

  @override
  String get materialLpg => 'LPG';

  @override
  String get materialPropane => 'Propane';

  @override
  String get materialNaturalGasCng => 'Natural gas (CNG)';

  @override
  String get materialMethanol => 'Methanol';

  @override
  String get materialEthanol => 'Ethanol';

  @override
  String get materialAcetoneSolvent => 'Acetone / solvent (general)';

  @override
  String get materialSolventBasedPaint => 'Paint / varnish (solvent-based)';

  @override
  String get materialAsphaltBitumen => 'Asphalt / bitumen';

  @override
  String get materialCoal => 'Coal';

  @override
  String get materialMineralTransformerOil => 'Transformer oil (mineral)';

  @override
  String get materialHydraulicOil => 'Hydraulic oil';

  @override
  String get materialPvcCable => 'Electrical cable (PVC)';

  @override
  String get materialXlpeCable => 'Electrical cable (XLPE)';

  @override
  String get materialLithiumIonBattery => 'Li-ion battery';

  @override
  String get materialMixedFurniture => 'Furniture (mixed)';

  @override
  String get materialOtherManual => 'Other (manual)';

  @override
  String get fireLoadFormulaInfo =>
      'q = (m × H) / A\nm = combustible material mass (kg)  ·  H = NCV (MJ/kg)  ·  A = floor area (m²)';

  @override
  String get panelInnerDimensions => 'Panel Internal Dimensions (cm)';

  @override
  String get panelWidth => 'Width';

  @override
  String get panelHeight => 'Height';

  @override
  String get panelDepth => 'Depth';

  @override
  String cableFillRatio(Object value) {
    return 'Cable fill ratio: % $value';
  }

  @override
  String get fuelStorageInstructions =>
      'Enter each tank type, quantity, and capacity.\nYou can use tons for LPG, or m³ or tons for liquid fuels.\nThe bund/pool area is optional for fire load density.';

  @override
  String get fuelChemicalTanks => 'Fuel / Chemical Tanks';

  @override
  String totalApproxMass(Object value) {
    return 'Total approximate mass: $value ton';
  }

  @override
  String get bundPoolArea => 'Bund / Pool Area  (m²)  —  optional';

  @override
  String get fireLoadDensityIfEntered =>
      'If entered, the fire load density (MJ/m²) will be calculated.';

  @override
  String get ventilationLimitedQmaxInclude =>
      'Include ventilation-limited Q_max in calculation (optional)';

  @override
  String get ventilationLimitedQmaxNote =>
      'Note: The default calculation uses only the fuel-surface-limited Q_max (RHRf×A); the opening (window/door)-limited Q_max is not included (EN 1991-1-2 Annex E).';

  @override
  String get openingArea => 'Opening (Window/Door) Area  Aᵥ';

  @override
  String get openingHeight => 'Opening Height  h_eq';

  @override
  String get openingAreaHeightExplanation =>
      'Aᵥ: total area of all window/door openings in the space  ·  h_eq: average height of these openings (NOT the room height).';

  @override
  String get ventilationQmaxFormulaNote =>
      'Q̇ₘₐₓ,ᵥ ≈ 0.09×Aᵥ×√h_eq × Hu_avg × 0.8  —  approximate Kawagoe ventilation factor (Drysdale / SFPE); an exact design requires a full opening factor calculation.';

  @override
  String get totalFireEnergyLabel => 'TOTAL FIRE ENERGY';

  @override
  String get totalEnergy => 'Total Energy';

  @override
  String get totalEnergyGJ => 'Total Energy (GJ)';

  @override
  String get totalEnergyMWh => 'Total Energy (MWh)';

  @override
  String get totalEnergyGWh => 'Total Energy (GWh)';

  @override
  String get bundAreaIfEnteredNote =>
      'If the bund/pool area is entered, the fire load density (MJ/m²) will be calculated.';

  @override
  String get calculationResultLabel => 'CALCULATION RESULT';

  @override
  String get totalFireLoad => 'Total Fire Load';

  @override
  String get fireLoadDensityLabel => 'Fire Load Density  q';

  @override
  String exceedsReferenceLabel(Object value) {
    return '^ +$value MJ/m² — EXCEEDS Reference';
  }

  @override
  String belowReferenceLabel(Object value) {
    return ' $value MJ/m² — Below Reference';
  }

  @override
  String get fireGrowthTimeline => 'Fire Growth Timeline (EN 1991-1-2 E.4)';

  @override
  String get growthPhaseEnd => 'Growth phase end';

  @override
  String get decayPhaseStart => 'Decay phase start (% 70 consumption)';

  @override
  String get totalFireDuration => 'Total fire duration';

  @override
  String peakHeatReleaseLabel(Object factor, Object value) {
    return 'Peak Q̇: $value MW  ·  Limiting factor: $factor';
  }

  @override
  String get limitingFactorFuelSurface => 'Fuel Surface (RHRf × A)';

  @override
  String get limitingFactorTotalEnergy => 'Total Energy (low fire load)';

  @override
  String get limitingFactorVentilation => 'Ventilation (opening — approximate)';

  @override
  String get extinguishingAgentCalcTitle => 'Extinguishing Agent Calculation';

  @override
  String panelVolumeHeight(Object value) {
    return 'Volume height (panel): $value';
  }

  @override
  String get panelAgentRecommendation =>
      'FM-200 (HFC-227ea) or Novec 1230 is recommended for electrical panels — ISO 14520 / NFPA 2001.';

  @override
  String get extinguishingAgentLabel => 'Extinguishing Agent';

  @override
  String get altitudeCorrectionLabel =>
      'Altitude correction (ISO 14520-1 Annex A)';

  @override
  String get altitudeLabel => 'Altitude (m)';

  @override
  String get requiredAgent => 'Required Agent';

  @override
  String get requiredAgentMass => 'Required Agent Mass';

  @override
  String get cylinderCountApprox => 'Cylinder Count (80L/200bar≈16Nm³)';

  @override
  String get cylinderContainerCount => 'Cylinder / Container Count';

  @override
  String get portableExtinguisherTitle =>
      'Portable Fire Extinguisher (TS 862-7 EN 3-7)';

  @override
  String get fireLoadSourcesFooter =>
      'Source: EN 1991-1-2:2002 Annex E · ISO 14520 · EN 12845 · TS 862-7 EN 3-7+A1';

  @override
  String get portableExtinguisherSourceFooter =>
      'Source: TS 862-7 EN 3-7+A1 (2010) · BYKHY Article 94-96';

  @override
  String get fireCabinetSourceFooter =>
      'Source: BYKHY Art. 91-93 · TS EN 671-1 · TS 9811';

  @override
  String get fireCabinetTitle =>
      'Fire Hose Cabinet (BYKHY Art. 91-93 / TS EN 671-1)';

  @override
  String fireCabinetTechSpecs(Object capacity, Object flow, Object p) {
    return 'DN25 (1\") semi-rigid hose reel · TS EN 671-1 · K=50\nQ = K × √P = 50 × √$p bar = $flow L/min\nPractical extinguishing capacity:\n  $capacity';
  }

  @override
  String get classACapacityPerCabinet => 'Class A: 2.0 MW/cabinet';

  @override
  String get classBCapacityPerCabinet => 'Class B: 0.6 MW/cabinet';

  @override
  String get hazardClassLabel => 'Hazard class';

  @override
  String get hazardClassLow => 'Low';

  @override
  String get hazardClassMedium => 'Medium';

  @override
  String get hazardClassHigh => 'High';

  @override
  String get requiredCabinetCount => 'Required cabinet count';

  @override
  String get totalExtinguishingCapacityLabel => 'Total extinguishing capacity';

  @override
  String waterReserveVolumeLabel(Object minutes) {
    return 'Water reserve volume ($minutes min)';
  }

  @override
  String cabinetSufficientLabel(Object count, Object load, Object q) {
    return '$count cabinet(s) SUFFICIENT  —  suppression $q MW ≥ fire load $load MW';
  }

  @override
  String cabinetInsufficientLabel(
    Object count,
    Object load,
    Object minNeeded,
    Object q,
  ) {
    return '$count cabinet(s) INSUFFICIENT  —  suppression $q MW < fire load $load MW (min $minNeeded cabinets required)';
  }

  @override
  String get roomHeightLabel => 'Room Height (m)';

  @override
  String get fireClassPanel =>
      'Class B/C (electrical equipment oil / gas) — Powder or CO₂';

  @override
  String get fireClassGasStorage =>
      'Class C (compressed flammable gas) — ABC Powder, CO₂ or Foam';

  @override
  String get fireClassLiquidGasStorage =>
      'Class B + Class C (liquid/gas fuel) — ABC Powder or Foam';

  @override
  String get fireClassLiquidStorage =>
      'Class B (flammable liquid) — ABC Dry Chemical Powder or Foam';

  @override
  String get fireClassSolidLiquidStorage =>
      'Class A + Class B (solid/liquid combustible) — ABC Dry Chemical Powder';

  @override
  String get fireClassParking => 'Class B (liquid fuel) — ABC Powder or Foam';

  @override
  String get fireClassSolidDefault =>
      'Class A (solid combustible) — ABC Dry Chemical Powder or Water';

  @override
  String get riskClassLow => 'Low Risk  (≤ 200 MJ/m²)';

  @override
  String get riskClassMedium => 'Medium Risk  (200–600 MJ/m²)';

  @override
  String get riskClassHigh => 'High Risk  (600–1200 MJ/m²)';

  @override
  String get riskClassVeryHigh => 'Very High Risk  (> 1200 MJ/m²)';

  @override
  String get loginServerUnreachable =>
      'Could not connect to the server. Check your internet connection.';

  @override
  String genericErrorWithDetail(String detail) {
    return 'Error: $detail';
  }

  @override
  String fireModuleSubscriptionMissing(String perms) {
    return 'You do not have an active Fire module subscription. Start a subscription from your account.\nPerms received from server: $perms';
  }

  @override
  String get loginFailed => 'Login failed';

  @override
  String get sessionNotFoundRelogin =>
      'Session not found. Please sign in again.';

  @override
  String get accountDeleteFailed => 'Could not delete account.';

  @override
  String get enterPanelInnerDimensionsCm =>
      'Enter the full panel internal dimensions (cm).';

  @override
  String get addAtLeastOneFuelTank => 'Add at least one fuel tank.';

  @override
  String enterQuantityForFuel(String name) {
    return 'Enter a quantity for \"$name\".';
  }

  @override
  String get enterValidFloorAreaM2 => 'Enter a valid floor area (m²).';

  @override
  String materialMassMissing(String name) {
    return 'Mass is missing for \"$name\".';
  }

  @override
  String materialNcvMissing(String name) {
    return 'Calorific value is missing for \"$name\".';
  }

  @override
  String get calculateFireLoadFirst => 'Calculate the Fire Load first.';

  @override
  String get enterValidArea => 'Enter a valid area.';

  @override
  String get enterRoomHeightM => 'Enter the room height (m).';

  @override
  String get enterHoodLengthWidthCm => 'Enter the hood length and width (cm).';

  @override
  String get enterRoomDimensionsFullyM => 'Enter the full room dimensions (m).';

  @override
  String get enterNetProtectedVolumeM3 =>
      'Enter the net protected volume (m³).';

  @override
  String get enterValidConcentrationPercent =>
      'Enter a valid concentration value (0–100%).';

  @override
  String get enterValidUnitCount1to50 => 'Enter a valid unit count (1–50).';

  @override
  String get enterMachineCabinDimensionsFullyM =>
      'Enter the full machine cabinet dimensions (m).';

  @override
  String get enterUnitCabinVolumeM3 => 'Enter the unit cabinet volume (m³).';

  @override
  String get enterPanelCabinDimensionsFullyM =>
      'Enter the full panel/cabinet dimensions (m).';

  @override
  String get enterPanelCabinVolumeM3 => 'Enter the panel/cabinet volume (m³).';

  @override
  String get enterRoomAreaM2 => 'Enter the room area (m²).';

  @override
  String get enterCeilingHeightM => 'Enter the ceiling height (m).';

  @override
  String get enterDesignHrrKw => 'Enter the design HRR (kW).';

  @override
  String get smokeLayerHeightRangeError => 'Smoke layer base height: 0 < z < H';

  @override
  String get enterInstalledCapacityKwh => 'Enter the installed capacity (kWh).';

  @override
  String get enterProtectionAreaM2 => 'Enter the protection area (m²).';

  @override
  String get enterApplicationDurationMin =>
      'Enter the application duration (min).';

  @override
  String get enterVehicleBatteryCapacityKwh =>
      'Enter the vehicle battery capacity (kWh).';

  @override
  String get enterVehicleCount => 'Enter the number of vehicles.';

  @override
  String get enterValidBuildingWidthM => 'Enter a valid building width (m).';

  @override
  String get enterValidBuildingLengthM => 'Enter a valid building length (m).';

  @override
  String get selectBuildingActivity => 'Please select the building activity.';

  @override
  String get enterCeilingHeightSimpleM => 'Enter the ceiling height (m).';

  @override
  String get hoodHideComparison => 'Hide Comparison';

  @override
  String get hoodCompareAgents => 'Compare Agents';

  @override
  String get hoodTableAgentCol => 'Agent';

  @override
  String get hoodTableEffectivenessCol => 'Effectiveness';

  @override
  String get hoodColLowAbbr => 'L';

  @override
  String get hoodColMediumAbbr => 'M';

  @override
  String get hoodColHighAbbr => 'H';

  @override
  String get hoodComparisonLegend =>
      'L = Low  ·  M = Medium  ·  H = High hazard class\nColored column = calculated hazard class';

  @override
  String get hoodResultTitleCaps => 'EXTINGUISHING SIZING RESULT';

  @override
  String get hoodNfpa96RequirementsTitle => 'NFPA 96 Mandatory Requirements';

  @override
  String get hoodReqFuelElectric =>
      'Fuel & Electrical Shutoff (§10.4): When the system activates, fuel and electricity to all heat sources must be shut off automatically. Manual reset is required.';

  @override
  String get hoodReqManualPull =>
      'Manual Pull Station (§10.5): Must be located 1067–1219 mm above the floor, min. 3 m – max. 6 m from the hood, along the escape route.';

  @override
  String get hoodReqAlarm =>
      'Alarm (§10.6): An audible alarm or visual indicator is mandatory upon system activation.';

  @override
  String get hoodReqFanMakeupAir =>
      'Fan & Makeup Air (§8.2.3 / §8.3.2): The exhaust fan must keep running after activation. Makeup air into the hood must be shut off upon system activation.';

  @override
  String get hoodReqClassKExtinguisher =>
      'Class K Extinguisher (§10.10.2): A Class K fire extinguisher is mandatory for equipment using vegetable/animal oil.';

  @override
  String hoodReqFilterDistance(String warning) {
    return 'Filter Clearance (§6.2.1): At least 457 mm (18 in.) between the filter\'s lower edge and the cooking surface.$warning';
  }

  @override
  String get hoodFilterDistanceWarning =>
      'Charbroiler/grill present → At least 1220 mm (4 ft) between the filter\'s lower edge and the cooking surface (NFPA 96 §6.2.1.2)';

  @override
  String get hoodReqMaintenance =>
      'Maintenance (§11.2.1): Serviced by a certified technician at least every 6 months. Fusible links are replaced every 6 months (§11.2.4).';

  @override
  String hoodReqCleaningFrequency(String frequency) {
    return 'Cleaning Frequency (Table 11.4): $frequency.';
  }

  @override
  String get hoodCleaningFreqHighVolume =>
      'Every 3 months (wok / charbroiler / large fryer)';

  @override
  String get hoodCleaningFreqLow => 'Annually (low volume)';

  @override
  String get hoodCleaningFreqMedium => 'Every 6 months (medium volume)';

  @override
  String get hoodReqSimultaneousOperation =>
      'Simultaneous Operation (§10.3): All fixed extinguishing systems in a single hazard zone must activate at the same time.';

  @override
  String hoodReqFryerDistance(String warning) {
    return 'Fryer Clearance (§12.1.2.4): The fryer must be at least 406 mm (16 in.) horizontally from open flame sources. If a baffle plate is used, a minimum height of 203 mm (8 in.) is sufficient (§12.1.2.5).$warning';
  }

  @override
  String get hoodFryerDistanceWarning =>
      'Fryer present → Must be positioned at least 406 mm (16 in.) horizontally from open flame sources (§12.1.2.4). If a baffle plate is used, a minimum height of 203 mm (8 in.) is sufficient (§12.1.2.5).';

  @override
  String get hoodReqFryerHighTempLimiter =>
      'Fryer High-Temperature Limiter (§12.2): An automatic temperature limiter is mandatory on deep-fat frying equipment. It automatically shuts off the heat source when the temperature 25.4 mm (1 in.) below the oil surface reaches 246°C (475°F).';

  @override
  String get hoodReqHoodDuctClearance =>
      'Hood / Duct Clearances (§4.2.1): Minimum 457 mm (18 in.) to combustible surfaces, minimum 76 mm (3 in.) to limited-combustible surfaces; 0 mm clearance is allowed to noncombustible surfaces.';

  @override
  String get hoodReqDuctSlope =>
      'Duct Slope (§7.1.4): A minimum 2% slope must be applied where horizontal duct length is ≤ 22.86 m (75 ft), and a minimum 8% slope where > 22.86 m (75 ft) (to drain grease accumulation).';

  @override
  String get hoodReqDuctFireBarrier =>
      'Duct Fire-Barrier Rating (§7.7.2.1): For duct penetrations: buildings < 4 stories → minimum 1-hour fire-rated enclosure; buildings ≥ 4 stories → minimum 2-hour fire-rated enclosure.';

  @override
  String hoodNotesText(
    String agent,
    String hazardClass,
    String score,
    String area,
  ) {
    return 'NFPA 17A §7.3 — $agent application.\nHazard class: $hazardClass  ·  Equipment score: $score  ·  Min. discharge: 30 s  ·  Filter area: $area m².\nAdditional ducts/flues require additional nozzle calculations.';
  }

  @override
  String get hoodAgentPotassiumCarbonateName => 'Potassium Carbonate';

  @override
  String get hoodAgentPotassiumAcetateName => 'Potassium Acetate';

  @override
  String get hoodAgentPotassiumCitrateName => 'Potassium Citrate';

  @override
  String get hoodAgentSodiumBicarbonateName => 'Sodium Bicarbonate';

  @override
  String get hoodAgentPotassiumCarbonateDesc =>
      'Most common. Effective against oil/surface fires.';

  @override
  String get hoodAgentPotassiumAcetateDesc =>
      'High efficiency. Ansul R-102, Amerex B500 systems.';

  @override
  String get hoodAgentPotassiumCitrateDesc =>
      'Compatible with stainless-steel equipment. Low corrosion risk.';

  @override
  String get hoodAgentSodiumBicarbonateDesc =>
      'Older generation. Low cost, limited effectiveness.';

  @override
  String get hoodAgentPotassiumCarbonateReco =>
      'General purpose. Suitable for any hazard class.';

  @override
  String get hoodAgentPotassiumAcetateReco =>
      'First choice for high hazard. Best extinguishing efficiency.';

  @override
  String get hoodAgentPotassiumCitrateReco =>
      'Stainless-steel kitchens / food industry. Low–medium hazard.';

  @override
  String get hoodAgentSodiumBicarbonateReco =>
      'Low hazard only. Not adequate for high-volume oil fires.';

  @override
  String get hoodStdNfpa96Desc =>
      'Ventilation control and fire protection for commercial cooking operations. Hood sizing, filter clearances, extinguishing system requirements, manual pull station, fuel shutoff, maintenance and cleaning frequencies.';

  @override
  String get hoodStdNfpa17aDesc =>
      'Wet chemical extinguishing systems standard. Discharge time, agent quantity, nozzle spacing.';

  @override
  String get hoodStdTsEn15751Desc =>
      'European standard — extinguishing systems for commercial cooking equipment.';

  @override
  String get hoodStdUl300Desc =>
      'US — product approval standard for kitchen extinguishing systems (Ansul R-102, Amerex B500, etc.).';

  @override
  String get hoodStdTsEn1825Desc =>
      'Grease filter systems and fire dampers for kitchen hoods.';

  @override
  String get calculationResultCaps => 'CALCULATION RESULT';

  @override
  String get gasInfoBoxText =>
      'TS EN 15004-1:2019 · NFPA 2001:2022\nPreliminary sizing tool for total-flooding clean-agent extinguishing system quantity.';

  @override
  String get gasNetVolumeHint =>
      'Net protected volume — subtract fixed furniture/equipment volume from the gross volume if present.';

  @override
  String get gasMinDesignTempHint =>
      'Minimum air temperature in the volume — TS EN 15004-1 §A.2  (default: 20 °C)';

  @override
  String get gasClassAMaterial1 => 'PMMA (polymethyl methacrylate / acrylic) ';

  @override
  String get gasClassAMaterial2 => 'PP (polypropylene)';

  @override
  String get gasClassAMaterial3 => 'ABS (acrylonitrile butadiene styrene) ';

  @override
  String get gasClassAMaterial4 => 'Wood, furniture and upholstery materials';

  @override
  String get gasClassAMaterial5 => 'Paper and cardboard';

  @override
  String get gasClassAMaterial6 => 'Textiles / fabric';

  @override
  String get gasClassAMaterial7 => 'Rubber';

  @override
  String get gasClassAMaterial8 => 'Other thermoplastics (PE, PS, PVC, etc.)';

  @override
  String get gasClassASource =>
      'TS EN 15004-1:2019 Annex C.6.3.2 (polymeric test-fuel panel array) · ISO 14520-1 Class A definition (general examples)';

  @override
  String get gasClassADTitle => 'Higher Hazard Class A  —  High-Hazard Fires';

  @override
  String get gasClassADMaterial1 =>
      'Bulk/stacked plastic storage (rack/pallet, deep-seated — differs from the single/exposed plastic items of surface Class A)';

  @override
  String get gasClassADMaterial2 => 'Dense cable bundles > 100 mm';

  @override
  String get gasClassADMaterial3 => 'Cable tray fill > 20%';

  @override
  String get gasClassADMaterial4 => 'Cable trays spaced < 250 mm apart';

  @override
  String get gasClassADMaterial5 =>
      'Energized equipment > 5 kW during extinguishment';

  @override
  String get gasClassADMaterial6 => 'Telecommunications';

  @override
  String get gasClassADMaterial7 => 'Control rooms';

  @override
  String get gasClassADMaterial8 =>
      'Dense electrical/electronic equipment areas';

  @override
  String get gasClassADSource => 'TS EN 15004-1:2019 Table 4';

  @override
  String get gasClassBTitle => 'Class B  —  Liquid and Meltable Solid Fires';

  @override
  String get gasClassBMaterial1 => 'Gasoline, diesel, fuel oil';

  @override
  String get gasClassBMaterial2 => 'Solvents, alcohol, acetone';

  @override
  String get gasClassBMaterial3 => 'Oil-filled transformer';

  @override
  String get gasClassBMaterial4 => 'Paint, varnish, resin';

  @override
  String get gasClassBMaterial5 =>
      'Meltable solids such as candle wax, paraffin';

  @override
  String get gasClassCMaterial1 => 'Electrical panels (local)';

  @override
  String get gasClassCMaterial2 => 'Motor control units';

  @override
  String get gasClassCMaterial3 => 'UPS and battery systems';

  @override
  String get gasClassCMaterial4 => 'Lighting and power distribution equipment';

  @override
  String get gasClassCSource =>
      'For telecommunications / control rooms / dense cabling → Higher Hazard Class A\nISO 3941 / NFPA 2001';

  @override
  String gasStandardDefaultInfo(
    String className,
    String percent,
    String capacity,
    String unit,
  ) {
    return 'Standard default — $className: $percent%  ·  Cylinder: $capacity $unit';
  }

  @override
  String get gasConcentrationHint =>
      'You may edit this if using a value outside the TS EN 15004-1 scope. It is auto-updated when the agent/class selection changes.';

  @override
  String get gasDischargeDurationHintClassB =>
      'Class B: max. 10 s  (TS EN 15004-1 §8.3)  —  required for pipe sizing';

  @override
  String get gasDischargeDurationHintOther =>
      'Class A/A(Deep)/C: max. 60 s  (TS EN 15004-1 §8.3)  —  required for pipe sizing';

  @override
  String gasNozzleFlowRange(String mm, String min, String max) {
    return '$mm mm  ($min–$max kg/s)';
  }

  @override
  String get gasNozzleHint =>
      'If a nozzle diameter is selected, the calculation uses the mass flow rate; automatic mode applies the area/volume rule.';

  @override
  String get gasRequiredAgentVolume => 'Required Agent Volume';

  @override
  String get gasSafetyMarginSuffix => '  (+10% margin)';

  @override
  String get gasExcludingMarginLabel => 'Calculation Excluding Margin';

  @override
  String get gasDischargeRequirementsTitle =>
      'Discharge Time Requirements — TS EN 15004-1:2019 §8.3 / NFPA 2001:2022 §6.7.1';

  @override
  String get gasDischargeReqInert =>
      '• Max. discharge time: ≤ 60 s  (NFPA 2001:2022 §6.7.1)\n• Min. soak time: ≥ 10 minutes  (NFPA 2001:2022 §6.7.4)\n• Pipe flow velocity: full hydraulic calculation required (TS EN 15004-1 Annex E)\n• Cylinder storage temperature: −20 °C – +54 °C  (NFPA 2001:2022 §4.4.1)';

  @override
  String get gasDischargeReqCo2 =>
      '• Max. discharge time: ≤ 60 s  (TS EN 15004-2 §8.3 / NFPA 12 §5.4.1)\n• Min. soak time: ≥ 20 minutes\n• ONLY for volumes without human occupancy — evacuation is mandatory';

  @override
  String get gasMaxDischargeClassB => '10 s  (Class B)';

  @override
  String get gasMaxDischargeClassOther => '60 s  (Class A/C)';

  @override
  String gasDischargeReqFm200(String maxDischarge) {
    return '• Max. discharge time: ≤ $maxDischarge  (EN 15004-5:2020 §8.3 / NFPA 2001:2022 §6.7.1)\n• Min. soak time: ≥ 10 minutes  (NFPA 2001:2022 §6.7.4)\n• Cylinder storage temperature: −20 °C – +54 °C\n• Specific volume: S = 0.1269 + 0.000513×T m³/kg  (EN 15004-5 §6.3 Table 3)';
  }

  @override
  String gasDischargeReqDefault(String maxDischarge) {
    return '• Max. discharge time: ≤ $maxDischarge  (TS EN 15004-1:2019 §8.3 / NFPA 2001:2022 §6.7.1)\n• Min. soak time: ≥ 10 minutes  (NFPA 2001:2022 §6.7.4)\n• Cylinder storage temperature: −20 °C – +54 °C  (NFPA 2001:2022 §4.4.1)';
  }

  @override
  String get gasIg01SpecsTitle =>
      'IG-01 Cylinder Specifications  —  TS EN 15004-7:2009 §6.1';

  @override
  String get gasTablePropertyHeader => 'Property';

  @override
  String get gasFillPressureLabel => 'Filling pressure @15°C (bar)';

  @override
  String get gasMaxOperatingPressureLabel =>
      'Max. operating pressure @50°C (bar)';

  @override
  String get gasOverpressurizationLabel => 'Overpressurization';

  @override
  String get gasNotApplicable => 'Not applicable';

  @override
  String get gasIg01Note =>
      'IG-01 cylinders are not overpressurized (TS EN 15004-7 §6.2). At the design temperature the formula S = 0.56119 + 0.002055×T m³/kg is used.';

  @override
  String get gasFm200SpecsTitle =>
      'HFC-227ea Cylinder Specifications  —  EN 15004-5:2020 §6.1';

  @override
  String get gasMaxFillDensityLabel => 'Max. fill density (kg/m³)';

  @override
  String get gasN2FillingPressureLabel => 'N₂ superpressurization @21°C (bar)';

  @override
  String get gasFm200Note =>
      'If the maximum fill density is exceeded, small temperature increases cause very high pressure, endangering cylinder integrity. (EN 15004-5:2020 §6.1)';

  @override
  String get gasNfpa2001RequirementsTitle =>
      'NFPA 2001:2022 Mandatory Requirements';

  @override
  String get gasReqPreDischargeAlarm =>
      '§6.6.1 — Pre-Discharge Alarm: In occupied areas, an audible/visual warning must sound before the agent discharges, allowing sufficient time for evacuation.';

  @override
  String get gasReqAbortSwitch =>
      '§6.6.6 — Abort Switch: A manual abort switch is mandatory in occupied areas; it delays the system by at least 30 seconds.';

  @override
  String get gasReqVolumeIntegrity =>
      '§6.5.4 — Enclosure Integrity: The volume must be sealed well enough to retain the design concentration for the soak time. A door fan test is recommended.';

  @override
  String get gasReqCylinderStorage =>
      '§4.4.1 — Cylinder Storage: Kept between −20 °C and +54 °C; fill pressure must match the manufacturer\'s listing.';

  @override
  String get gasReqPostDischargeVentilation =>
      '§6.9 — Post-Discharge Ventilation: Forced ventilation must be performed until the O₂ level reaches ≥ 19.5% before re-entry.';

  @override
  String get gasReqInterlockedSystems =>
      '§6.1.2 — Interlocked Systems: HVAC and all air-supply dampers must close automatically upon discharge.';

  @override
  String gasReqSafetyMargin(String status) {
    return '§5.4.1.3 — Safety Margin: A minimum 10% safety margin is mandatory; in this calculation it was $status';
  }

  @override
  String get gasSafetyMarginApplied => 'applied.';

  @override
  String get gasSafetyMarginNotApplied => '⚠ not applied!';

  @override
  String get gasReqPeriodicInspection =>
      '§7.2.2 — Periodic Inspection: Cylinders must be checked annually by weight/pressure; halocarbon fill quantity must be verified by pop-valve measurement.';

  @override
  String get gasMainPipeSizeTitle => 'Pipe Diameter — Main Line';

  @override
  String get gasMinInnerDiameterLabel => 'Min. inner diameter';

  @override
  String get gasStandardDnLabel => 'Standard DN';

  @override
  String get gasDnOver150 => 'DN > 150';

  @override
  String gasVolumetricFlowLabel(String ls, String m3s) {
    return 'Volumetric flow (Q): $ls L/s  ($m3s m³/s)';
  }

  @override
  String gasPipeActualSpeedLabel(String dn, String speed, String status) {
    return 'Actual velocity for DN $dn: $speed m/s$status';
  }

  @override
  String get gasSpeedOkSuffix => ' ✓';

  @override
  String get gasSpeedOverLimitSuffix => '  ⚠ above 30 m/s';

  @override
  String get gasMainPipeSizingNote =>
      'The main line is a preliminary sizing — Q = agent quantity ÷ discharge time. Distribution pipes and nozzle lines must be calculated separately. Perform a full flow calculation per TS EN 15004-1 Annex E for the final design.';

  @override
  String get gasNozzleDistributionTitle => 'Nozzle & Distribution Piping';

  @override
  String get gasNozzleCountLabel => 'Nozzle Count';

  @override
  String gasNozzleAltMassBased(String mm) {
    return '$mm mm nozzle\n(mass-flow based)';
  }

  @override
  String get gasNozzleAltAreaBased => 'max. 50 m²/nozzle\n(area based)';

  @override
  String get gasNozzleAltVolumeBased =>
      'max. 150 m³/nozzle\n(volume based — estimate)';

  @override
  String get gasBranchPipeLabel => 'Branch Pipe';

  @override
  String gasBranchMinInnerDiameter(String mm) {
    return 'min. inner diameter:\n$mm mm';
  }

  @override
  String gasFlowPerNozzleLabel(
    String flow,
    String min,
    String max,
    String status,
  ) {
    return 'Per nozzle: $flow kg/s  (allowed: $min–$max kg/s)  $status';
  }

  @override
  String get gasFlowOk => '✓';

  @override
  String get gasFlowOutOfRange =>
      '⚠ Out of range — choose a different diameter';

  @override
  String gasBranchSpeedLabel(String speed, String ls, String status) {
    return 'Branch velocity: $speed m/s  (per-nozzle Q: $ls L/s)$status';
  }

  @override
  String get gasBranchSpeedWarning => '  ⚠ above 30 m/s!';

  @override
  String get gasBranchSpeedOk => '  ✓';

  @override
  String gasEstimatedPipeLengthLabel(String m) {
    return 'Estimated pipe length: ≈ $m m (main line + distribution + nozzle risers)';
  }

  @override
  String get gasNozzlePlacementNote =>
      'Nozzle placement: must be positioned at ceiling level, evenly spaced, per TS EN 15004-1 / NFPA 2001 manufacturer\'s listing requirements.\nThe pipe length is an estimate — actual project length varies with the space layout.';

  @override
  String get gasSourceFooter =>
      'Source: TS EN 15004-1:2019 · NFPA 2001:2022 · NFPA 12:2022';

  @override
  String get baskiOffsetName => 'Offset Printing';

  @override
  String get baskiFlexoName => 'Flexographic Printing';

  @override
  String get baskiGravureName => 'Gravure / Rotogravure';

  @override
  String get baskiUvOffsetName => 'UV Offset / UV Flexo';

  @override
  String get baskiDigitalName => 'Digital (Inkjet/Toner)';

  @override
  String get baskiPadName => 'Pad Printing';

  @override
  String get baskiOffsetDesc =>
      'Wet offset — IPA/alcohol-based fountain solution';

  @override
  String get baskiFlexoDesc => 'Solvent- or water-based ink';

  @override
  String get baskiGravureDesc =>
      'Toluene/ethyl acetate based — high solvent risk';

  @override
  String get baskiUvOffsetDesc => 'UV curing — photoinitiator based';

  @override
  String get baskiDigitalDesc => 'Liquid ink or toner — low solvent content';

  @override
  String get baskiPadDesc => 'Solvent-based ink — closed cup';

  @override
  String get baskiIpaName => 'IPA (Isopropyl Alcohol)';

  @override
  String get baskiIpaDesc =>
      'Offset printing fountain solution — explosion risk';

  @override
  String get baskiTolueneName => 'Toluene';

  @override
  String get baskiTolueneDesc => 'Gravure printing — high risk, GWP 0';

  @override
  String get baskiEthylAcetateName => 'Ethyl Acetate';

  @override
  String get baskiEthylAcetateDesc => 'Flexo/gravure — low flash point';

  @override
  String get baskiMethanolName => 'Methanol';

  @override
  String get baskiMethanolDesc => 'Woodworking and special applications';

  @override
  String get baskiNPropylName => 'n-Propyl Alcohol';

  @override
  String get baskiNPropylDesc => 'UV offset auxiliary solvent';

  @override
  String get baskiSolventMixName => 'Solvent Mixture (general)';

  @override
  String get baskiSolventMixDesc => 'Determine per manufacturer\'s data sheet';

  @override
  String get baskiWaterBasedInkName => 'Water-Based Ink';

  @override
  String get baskiWaterBasedInkDesc =>
      'No flammable solvent — Class A application';

  @override
  String get baskiInfoBoxText =>
      'NFPA 34:2024 §10.6 · NFPA 2001:2022 · NFPA 12:2022 · TS EN 15004-1:2019\nPreliminary sizing tool for printing press cabinet clean-agent extinguishing.';

  @override
  String baskiIgnitionPointLabel(String temp, String desc) {
    return 'Flash point: $temp °C  ·  $desc';
  }

  @override
  String get baskiUnitCountHint =>
      'A separate cylinder is calculated for each unit of the same volume. If volumes differ, perform multiple calculations.';

  @override
  String get baskiLengthDepthLabel => 'Length / Depth';

  @override
  String get baskiCabinetDimensionsHint =>
      'Interior dimensions of one unit cabinet — net interior volume, not gross.';

  @override
  String get baskiUnitNetVolumeLabel => 'Unit Cabinet Net Volume';

  @override
  String get baskiMinTempHint =>
      'Minimum temperature inside the machine cabinet — TS EN 15004-1 §A.2 (default: 20 °C)';

  @override
  String get baskiLocalApplicationLabel =>
      'Local Application +30% (NFPA 2001 §6.4) — For open machine cabinets';

  @override
  String get baskiDischargeModeTitle => 'Discharge Mode (Multiple Units)';

  @override
  String get baskiSimultaneousLabel => 'Simultaneous (Total)';

  @override
  String get baskiSelectiveValveLabel => 'Selective Valve (Independent)';

  @override
  String get baskiSimultaneousHint =>
      'Select this if all units may discharge at once within a shared area — the main supply equals the total demand of all units.';

  @override
  String get baskiSelectiveValveHint =>
      'Select this if each unit has independent detection and a selective valve — the main supply is sized only for a single unit\'s demand (NFPA 2001 §7.5.2 / NFPA 12 §4.3.4.2).';

  @override
  String get baskiBackupSupplyLabel =>
      'Backup (100%) Supply Group (NFPA 12 §4.5.3) — recommended for normally occupied areas';

  @override
  String get baskiClassAPlain => 'Class A';

  @override
  String baskiClassSummaryLabel(String cls, String value, String noael) {
    return 'Fire class: $cls  ·  Standard min.: $value %  ·  NOAEL: $noael';
  }

  @override
  String get baskiDischargeHint =>
      'Class B machines: max. 10 s  ·  Class A machines: max. 60 s  (TS EN 15004-1 §8.3)';

  @override
  String get baskiMainSupplySimultaneous =>
      'Main Supply Demand (simultaneous — total)';

  @override
  String get baskiMainSupplySelective =>
      'Main Supply Demand (selective valve — single unit)';

  @override
  String baskiMainSupplyCylinderCount(String capacity, String unit) {
    return 'Main Supply Cylinder Count ($capacity $unit/cylinder)';
  }

  @override
  String get baskiSelectiveValveInfo =>
      'Selective valve design: each unit cabinet must have an independent detection circuit; only the valve of the unit where fire is detected opens. The main supply is sized for a single unit\'s demand — select \"Simultaneous\" if there is a risk of concurrent fires in multiple units (NFPA 2001 §7.5.2 / NFPA 12 §4.3.4.2).';

  @override
  String get baskiLocalApplicationInfo =>
      'A local application factor of +30% was applied (NFPA 2001 §6.4).\nApplies to open machines or cabinets that are not fully enclosed.';

  @override
  String get baskiApplicationNotesTitle => 'Application Notes';

  @override
  String baskiAppNotesBody(String ignitionNote) {
    return '• Each printing unit cabinet must be protected individually.\n• Nozzle placement inside the machine is subject to manufacturer approval.\n• The ink/solvent supply must be shut off automatically before discharge.\n• $ignitionNote\n• The cylinder count depends on the selected discharge mode (simultaneous/selective valve) and backup supply decision — it must be finalized per the manufacturer\'s model.';
  }

  @override
  String get baskiIgnitionNoteAtex =>
      'Flash point < 23 °C — an ATEX zone assessment is mandatory.';

  @override
  String get baskiIgnitionNoteExplosionRisk =>
      'An explosion risk analysis must be performed for this solvent type.';

  @override
  String get baskiSourceFooter =>
      'Source: NFPA 34:2024 §10 · NFPA 2001:2022 · NFPA 12:2022 · TS EN 15004-1:2019 · EN 1010-2';

  @override
  String get panoAgentGroupClean =>
      'Clean Agent (FK-5-1-12(Novec 1230)/HFC-227ea)';

  @override
  String get panoAgentGroupCo2 => 'CO₂ (Carbon Dioxide)';

  @override
  String get panoDlpName => 'DLP — Direct Low Pressure';

  @override
  String get panoIlpName => 'ILP — Indirect Low Pressure';

  @override
  String get panoDhpName => 'DHP — Direct High Pressure (CO₂)';

  @override
  String get panoIhpName => 'IHP — Indirect High Pressure (CO₂)';

  @override
  String get panoDlpDesarjNotu =>
      'The tubing line acts as both detection and direct discharge — no calculation required.';

  @override
  String get panoIlpDesarjNotu =>
      'The tubing performs detection; discharge occurs through separate nozzle(s).';

  @override
  String get panoDhpDesarjNotu =>
      'Fixed discharge time ≈ 60 s @ 60 bar — no user input required.';

  @override
  String get panoIhpDesarjNotu =>
      'Discharge time is fixed per the standard; refer to the manufacturer\'s approved table.';

  @override
  String get panoDlpAciklama =>
      'The most commonly used type of in-panel extinguishing. The red detection tubing itself functions as the direct extinguishing line; no additional piping or nozzles are needed. When the tubing bursts at the point of fire, agent discharges from that point. A pre-engineered system that requires no hydraulic flow calculation.';

  @override
  String get panoIlpAciklama =>
      'The detection tubing acts only as a trigger; the extinguishing agent is discharged into the panel through stainless steel piping and nozzles. In multi-compartment, large-volume panels, nozzles are placed at strategic points to achieve a homogeneous extinguishing concentration. A manual discharge button is included; the panel must be fully sealed.';

  @override
  String get panoDhpAciklama =>
      'A system using CO₂ agent where the detection tubing functions as both the detector and the discharge line. Because CO₂ is stored at high pressure, this offers an advantage over DLP in tubing length and maximum volume. Preferred where a nozzle opening is undesirable and for panels with larger ventilation openings than DLP allows.';

  @override
  String get panoIhpAciklama =>
      'The most comprehensive in-panel extinguishing solution using CO₂. Preferred for large-volume panels with multiple compartments and interconnecting openings. A distribution system of stainless steel piping, flexible connection hoses and nozzles achieves homogeneous extinguishing over large areas.';

  @override
  String get panoInfoBoxText =>
      'LPS 1666 · UL 2166 / FM 5600 · VdS 2093\nRecommendation tool for pre-engineered pneumatic tubing extinguishing system types for electrical/telecom panels and cabinets — not a hydraulic calculation.';

  @override
  String get panoNoOpeningLabel =>
      'No unsealable opening (cable entries, ventilation, etc. are sealed)';

  @override
  String get panoOpeningWarning =>
      'If an unsealable opening exists, the agent cannot be retained and the system may be rendered ineffective. Openings must be sealed, or ventilation/dampers must close automatically upon activation.';

  @override
  String get panoTubingLengthLabel => 'Required Tubing Length (optional)';

  @override
  String get panoRecommendedSystemCaps => 'RECOMMENDED SYSTEM';

  @override
  String panoVolumeExceededWarning(String detail, String roomTab) {
    return 'The volume exceeds the limits of pre-engineered in-panel systems ($detail). An engineered total-flooding system is required for this volume — use the \"$roomTab\" tab.';
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
    return 'This quantity is an approximate calculation based on a $percent% design concentration and a 20°C reference. The exact cylinder fill quantity must be selected from the manufacturer\'s approved pre-engineered system table.';
  }

  @override
  String panoTubingExceededWarning(String len, String kod, String max) {
    return 'The entered tubing length ($len m) exceeds the $kod system\'s $max m limit. Switch to a higher-capacity system type or use multiple independent systems.';
  }

  @override
  String get panoSealingWarning =>
      'The ILP system requires a fully sealed cabinet (UL/FM test requirement). Because of the marked unsealable opening, this system is not reliable — seal the panel or switch to the CO₂ agent group (DHP/IHP, sealing not required).';

  @override
  String get panoCo2ToxicityWarning =>
      'CO₂ is toxic: people must not be continuously present around the panel. If there is a leak risk into adjacent/neighboring areas, the 5% LOAEL limit must be observed, and evacuation and ventilation planned if necessary.';

  @override
  String get panoNoSealingRequiredNote =>
      'Sealing is not mandatory, but the amount of unsealable opening must be reported to the manufacturer; it must be accounted for as additional agent quantity in the VdS 2093 calculation.';

  @override
  String get panoDesignRequirementsTitle => 'Design Requirements';

  @override
  String panoManualReleaseNote(String kod) {
    return '• Manual discharge button: since the tubing line in $kod systems is separate, an emergency manual discharge button is required in addition to automatic triggering.\n';
  }

  @override
  String get panoDesignRequirementsBody =>
      '• Alarm integration: an audible/visual pre-discharge alarm and a signal to the building fire alarm panel must be provided upon system activation.\n• The cylinder set must comply with CE/TPED (Transportable Pressure Equipment Directive).\n• An independent system certification (LPCB/UL/FM/VdS) must be sought before purchase; a component certification (cylinder, nozzle) alone is not sufficient. Installation must be performed by an authorized/approved partner.';

  @override
  String get panoMaintenanceScheduleTitle => 'Maintenance Schedule';

  @override
  String get panoMaintenanceScheduleBody =>
      '• Monthly: visual inspection (pressure gauge, tubing damage/corrosion).\n• Every 6 months: pressure switch, gasket and connection check.\n• Every 5 years: cylinder hydrostatic test.\n• Every 10 years: system overhaul / component end-of-life assessment.\n• A manufacturer\'s fill certificate must be obtained at every refill; if the system is impaired, it must be restored to service as soon as possible (per manufacturer/authority guidance, within 48 hours max) or a fire watch assigned.';

  @override
  String get panoSourceFooter =>
      'Source: LPS 1666 · UL 2166 · FM 5600 · VdS 2093';

  @override
  String get gasAltitudeFieldLabel => 'Altitude';

  @override
  String get gasNoaelCo2Warning =>
      '⚠ CO₂ poses a life-threatening hazard at high concentrations. It must only be used for volumes without human occupancy. TS EN 15004-2 / NFPA 12.';

  @override
  String gasNoaelLoaelExceeded(String percent, String loael) {
    return '⚠ The design concentration ($percent%) EXCEEDS the LOAEL limit ($loael%) — evacuation is mandatory, high risk!  (NFPA 2001:2022 Table 5.6.2.1)';
  }

  @override
  String gasNoaelReached(String percent, String noael) {
    return '⚠ The design concentration ($percent%) reaches or exceeds the NOAEL limit ($noael%) — evacuation is required before use.  (NFPA 2001:2022 Table 5.6.2.1)';
  }

  @override
  String gasNoaelOk(String percent, String noael, String loael) {
    return '✓ The design concentration ($percent%) is below the NOAEL ($noael%). May be used in occupied spaces under NFPA 2001:2022.  LOAEL: $loael%';
  }

  @override
  String get gasAgentHfc227Desc =>
      'Liquefied halocarbon. 25/42/50 bar N₂ superpressurization. Max. fill density 1150 kg/m³. Ideal for electrical/electronic rooms. (EN 15004-5 Table 6-8)';

  @override
  String get gasAgentFk512Desc =>
      'Low GWP. Sensitive equipment rooms, archives, museums.';

  @override
  String get gasAgentCo2Desc =>
      'Total flooding — ONLY for volumes without human occupancy. Class B concentration is fuel-specific: heptane 34%, toluene/benzene 37%, ethyl acetate 38%, MEK 40%, IPA/ethanol/methanol 53% (NFPA 12 Table A.5.3.2.1).';

  @override
  String get gasAgentIg541Desc =>
      'N₂/Ar/CO₂ (52/40/8) blend. Oxygen depletion. Usable in occupied spaces.';

  @override
  String get gasAgentIg55Desc =>
      'N₂/Ar (50/50) blend. Environmentally friendly. Usable in occupied spaces.';

  @override
  String get gasAgentIg100Desc =>
      'Pure nitrogen. Oxygen depletion. Easily available.';

  @override
  String get gasAgentIg01Desc =>
      'Pure argon. Extinguishes by oxygen depletion. 160 / 200 / 300 bar filling. Leaves no chemical residue. Usable in occupied spaces. (TS EN 15004-7 Table 6-8)';

  @override
  String get wallMaterialConcrete => 'Concrete / Masonry';

  @override
  String get wallMaterialLightBlock => 'Lightweight Concrete Block';

  @override
  String get wallMaterialGypsum => 'Gypsum Board (Double)';

  @override
  String smokeLayerHeightError(String height) {
    return 'Error: z ≥ H — a smoke layer cannot form. z must be < $height m.';
  }

  @override
  String smokeLayerLowWarning(String z, String d) {
    return 'Warning: z = $z m < 2.5 m — insufficient evacuation safety.  d (smoke layer depth) = $d m';
  }

  @override
  String smokeLayerDepthInfo(String z, String d, String height) {
    return 'z = $z m  →  d (smoke layer depth) = $d m  (H − z = $height − $z)';
  }

  @override
  String get smokeNoteNaturalPlume =>
      'Plume: the hot gas/smoke column rising above a fire. Mass flow (Thomas formula, EN 12101-2 Annex B): ṁₚ = 0.071×Qc¹³×z⁵³ + 0.0018×Qc';

  @override
  String get smokeNoteNaturalCd => 'Cd = 0.5 (roof vent, EN 12101-2 §6.4)';

  @override
  String get smokeNoteNaturalFreshAir =>
      'Fresh air inlet from the lower zone; openings should be evenly distributed';

  @override
  String get smokeNoteMinimumAreaCaveat =>
      'This is the minimum calculated area; sectorization and a safety margin must be added separately';

  @override
  String get smokeNoteResponsibilityNatural =>
      'Disclaimer: This calculation is for preliminary design purposes. The final design must be approved by a qualified fire engineer.';

  @override
  String get smokeNoteMechanicalPlume =>
      'Plume: the hot gas/smoke column rising above a fire. The fan capacity is selected to meet the plume flow rate.';

  @override
  String get smokeNoteMinAirChange =>
      'Min. air change rate ≥ 10/h (EN 12101-3 §5.2)';

  @override
  String get smokeNoteFanTempRating =>
      'Fan temperature rating ≥ 400 °C / 120 min (F400) — EN 12101-3';

  @override
  String get smokeNoteFreshAirPercent =>
      'Fresh air inlet must be at least 70% of the smoke exhaust flow rate';

  @override
  String get smokeNoteResponsibility =>
      'Disclaimer: This calculation is for preliminary design purposes. The final design must be approved by a qualified fire engineer.';

  @override
  String get smokeNoteDoorFlowExplain =>
      'Open-door transfer flow: the air flowing through the stairwell while a floor door is open during evacuation — the largest instantaneous load the fan must meet';

  @override
  String get smokeNoteDoorFlowFormula =>
      'Calculation: Q = A_door × √(2ΔP/ρ)  — assumes the door fully open with the full ΔP applied (conservative side)';

  @override
  String get smokeNoteWallLeakageConcrete =>
      'Wall leakage: 1.3×10⁻⁴ m²/m² for a concrete/masonry shaft  (EN 12101-6 Annex F Table F.1)';

  @override
  String get smokeNoteDoorGapCd =>
      'Door gap width 10 mm, Cd = 0.83  (EN 12101-6 Annex F)';

  @override
  String get smokeNoteDoorForceCheck =>
      'Door opening force ≤ 100 N must be checked under the open-door condition';

  @override
  String get smokeNotePressureLimit =>
      'ΔP limit: ≥ 50 Pa (on the fire floor) / ≤ 60 Pa (other floors)';

  @override
  String get fanCriterionMinAirChange => 'min. air change criterion';

  @override
  String get fanCriterionPlumeFlow => 'plume flow criterion';

  @override
  String get spFormulaInfo =>
      'EN 12845 / TS EN 12845 — Fixed Fire-Fighting Systems · Automatic Sprinklers\nCritical-circuit hydraulic calculation by hazard class  ·  Hazen–Williams (selectable pipe material C coefficient)';

  @override
  String get spFieldWidthM => 'Width  (m)';

  @override
  String get spFieldLengthM => 'Length  (m)';

  @override
  String get spFieldCeilingM => 'Ceiling  (m)';

  @override
  String get spSuspendedCeilingCheckbox =>
      'Suspended ceiling present (concealed space)';

  @override
  String get spVoidDepthLabel => 'Void Depth  (cm)';

  @override
  String get spVoidDepthInfo =>
      'EN 12845 Cl. 5.4: If the void depth is > 80 cm, an additional sprinkler system must be installed in the concealed space.';

  @override
  String get spBuildingActivityFieldLabel => 'Building Activity';

  @override
  String get spSelectActivityPlaceholder => 'Select the activity…';

  @override
  String spHazardClassInline(String name) {
    return 'Hazard Class: $name';
  }

  @override
  String spHazardClassDetail(String density, String area, String coverage) {
    return 'Density: $density mm/min  ·  Design area: $area m²  ·  Max. coverage: $coverage m²/sprinkler';
  }

  @override
  String get spSprinklerTypeLabel => 'Sprinkler Type (K-Factor)';

  @override
  String get spInstallationClassLabel => 'Installation Class / Pump Redundancy';

  @override
  String get spDryPipeCheckbox => 'Dry-pipe system (freeze-risk area)';

  @override
  String get spDryPipeInfo =>
      'In dry-pipe systems the network is pressurised with air/nitrogen, and trip time, compressor capacity and pipe slope (drainage) must be designed separately. A wet system should be preferred where there is no freeze risk.';

  @override
  String get spRackStorageCheckbox =>
      'Rack / pallet storage — in-rack sprinklers (preliminary design)';

  @override
  String get spRackLevelsLabel => 'Number of Rack Levels (in-rack tiers)';

  @override
  String get spUnitLevel => 'level';

  @override
  String get spRackInfo =>
      'This is only a simplified preliminary estimate. The exact number of in-rack sprinklers, flue-space width and tier spacing must be determined by a full design under EN 12845 Annex H.';

  @override
  String get spFoamSystemCheckbox =>
      'Add foam extinguishing system (EN 13565-2)';

  @override
  String get spHydrocarbonSub => 'Petrol, diesel,\nfuel, oil';

  @override
  String get spPolarSolventSub => 'Acetone, ethanol,\nsolvent, ketone';

  @override
  String spFoamDurationMin(String minutes) {
    return '$minutes min';
  }

  @override
  String get spFoamPolarSolventInfo =>
      'EN 13565-2: Only AR-AFFF, FFFP or MF-FFF concentrate may be used for polar solvents. The protected area is taken as the building area (width × length).';

  @override
  String get spHHP4Warning =>
      '⚠  HHP4 — HIGH-DENSITY WATER SYSTEM\nEN 12845 Table 3 Note: This class is outside the scope of standard sprinklers. Special evaluation and approval by a qualified engineer are mandatory. The calculation below is for preliminary guidance only and cannot be used as an official design.';

  @override
  String get spActivityDialogTitle => 'Select Activity Area';

  @override
  String get spNoResultsFound => 'No results found';

  @override
  String spKFactorWarning(String selected, String sinifKod, String minK) {
    return 'The selected K-factor (K$selected) is below the minimum K$minK required for the $sinifKod class — manufacturer approval and full hydraulic-calculation verification are mandatory.';
  }

  @override
  String get spCeilingWarningLH =>
      'LH — Ceiling height > 6 m: Standard sprinkler performance may be inadequate. An ESFR or high-volume special design is recommended.';

  @override
  String get spCeilingWarningOH =>
      'OH — Ceiling height > 6 m: Standard sprinkler effectiveness may decrease. Consulting the authority having jurisdiction before design is advised.';

  @override
  String get spCeilingWarningHH =>
      'HHP/HHS — Ceiling height > 6 m: under §7.2.2.3, if the clearance is > 4 m, a density increase (+1 mm/min per additional metre) and min. K115 sprinklers are required.';

  @override
  String get spSinifAdLH => 'Light Hazard (LH)';

  @override
  String get spSinifAdOH1 => 'Ordinary Hazard Group 1 (OH1)';

  @override
  String get spSinifAdOH2 => 'Ordinary Hazard Group 2 (OH2)';

  @override
  String get spSinifAdOH3 => 'Ordinary Hazard Group 3 (OH3)';

  @override
  String get spSinifAdOH4 => 'Ordinary Hazard Group 4 (OH4)';

  @override
  String get spSinifAdHHP1 => 'High Hazard Process Group 1 (HHP1)';

  @override
  String get spSinifAdHHP2 => 'High Hazard Process Group 2 (HHP2)';

  @override
  String get spSinifAdHHP3 => 'High Hazard Process Group 3 (HHP3)';

  @override
  String get spSinifAdHHP4 =>
      'High Hazard Process Group 4 (HHP4) — ⚠ High-Density Water / Special System';

  @override
  String get spSinifAdSF1 => 'Storage Cat. I — Free-Floor Storage (≤ 3 m)';

  @override
  String get spSinifAdSF2 => 'Storage Cat. II — Free-Floor Storage (≤ 3.5 m)';

  @override
  String get spSinifAdSF3 => 'Storage Cat. III — Free-Floor Storage (≤ 3.5 m)';

  @override
  String get spSinifAdSF4 => 'Storage Cat. IV — Free-Floor Storage (≤ 3.5 m)';

  @override
  String get spSinifAdRS1 => 'Storage Cat. I — Rack / Pallet Storage';

  @override
  String get spSinifAdRS2 => 'Storage Cat. II — Rack / Pallet Storage';

  @override
  String get spSinifAdRS3 => 'Storage Cat. III — Rack / Pallet Storage';

  @override
  String get spSinifAdRS4 => 'Storage Cat. IV — Rack / Pallet Storage';

  @override
  String get spTipAdAuto => 'Automatic by Class';

  @override
  String get spTipDescAuto => 'Standard K80 (LH/OH) or K115 (HH) — default';

  @override
  String get spTipAdK57 => 'Standard K57';

  @override
  String get spTipDescK57 => 'Only in specially approved low-flow applications';

  @override
  String get spTipAdK80 => 'Standard K80';

  @override
  String get spTipDescK80 => 'Standard for LH/OH classes';

  @override
  String get spTipAdK115 => 'High-Flow K115';

  @override
  String get spTipDescK115 => 'Standard for HH classes';

  @override
  String get spTipAdK161 => 'Large Drop K161';

  @override
  String get spTipDescK161 =>
      'High-piled storage / rack systems — manufacturer approval required';

  @override
  String get spTipAdK200 => 'Extra-Large Drop K200';

  @override
  String get spTipDescK200 =>
      'Special high-flow applications — manufacturer approval required';

  @override
  String get spTipAdEsfr => 'ESFR K242 (informational)';

  @override
  String get spTipDescEsfr =>
      'Early suppression fast response — outside EN 12845 scope; NFPA 13 / listing data governs';

  @override
  String get spKurulumAdSingle => 'Single Source + Single Pump';

  @override
  String get spKurulumDescSingle =>
      'No redundancy — acceptable only for LH and low-risk, single-source premises.';

  @override
  String get spKurulumAdDual => 'Duplicate Pump (Electric + Diesel)';

  @override
  String get spKurulumDescDual =>
      'Common solution for OH and most HH premises — the diesel pump starts automatically on a power failure.';

  @override
  String get spKurulumAdSuperior =>
      'Duplicate Source + Duplicate Pump (Superior)';

  @override
  String get spKurulumDescSuperior =>
      'Highest reliability — recommended for critical premises, HH classes and high-risk warehouses; two independent water sources and pump sets.';

  @override
  String get spUnitAdet => 'units';

  @override
  String get spUnitSpacing => 'spacing';

  @override
  String get spUnitMinutes => 'minutes';

  @override
  String get spRcHeaderBuilding => 'Building & Design Parameters';

  @override
  String get spRcHeaderLayout => 'Sprinkler Layout Calculation';

  @override
  String get spRcHeaderHydraulic => 'Critical-Circuit Hydraulic Calculation';

  @override
  String get spRcHeaderFullHydraulic =>
      'Critical Circuit — Full Hydraulic Calculation';

  @override
  String get spRcHeaderPump => 'Pump Requirements';

  @override
  String get spRcHeaderInstallation => 'Installation Class & Pump Redundancy';

  @override
  String get spRcHeaderWaterTank => 'Water Tank  —  EN 12845 Table 2';

  @override
  String get spRcHeaderDryPipe => 'Dry-Pipe System  —  Freeze Risk';

  @override
  String get spRcHeaderRackStorage =>
      'Rack Storage — In-Rack Sprinklers (Preliminary Design)';

  @override
  String get spRcHeaderPipeDiameterSummary =>
      'Pipe Diameter Summary  —  EN 12845 Table 14';

  @override
  String get spRcHeaderPipeLength => 'Pipe Length (Approximate)';

  @override
  String get spRcHeaderAlarmValve => 'Wet Alarm Valve  —  EN 12845 Cl. 11.2';

  @override
  String get spRcHeaderFoamSystem => 'Foam System  —  EN 13565-2';

  @override
  String get spRcBuildingArea => 'Building Area';

  @override
  String get spRcCeilingHeight => 'Ceiling Height';

  @override
  String spRcCoverageAdjustedSuffix(String value) {
    return '  ›  coverage adjusted: $value m² (height effect)';
  }

  @override
  String get spRcHazardClass => 'Hazard Class';

  @override
  String get spRcDesignDensity => 'Design Density';

  @override
  String get spRcDesignArea => 'Design Area';

  @override
  String get spRcMaxCoveragePerSprinklerCap => 'Max. Coverage / Sprinkler';

  @override
  String get spRcMaxCoveragePerSprinklerLow => 'Max. coverage / sprinkler';

  @override
  String get spRcHeightAdjustSuffix => '(height adjustment)';

  @override
  String get spRcTable20Title => 'Table 20 — Sidewall Spray Groups (reference)';

  @override
  String get spRcMaxGroupDistance => 'Max. distance between groups';

  @override
  String get spRcNote2Suffix =>
      '  (Note 2: may increase to 3.7 m for a 120-minute fire-resisting ceiling)';

  @override
  String get spRcMaxToWallEnd => 'Max. to end of wall';

  @override
  String get spRcTheoreticalSpacing => 'Area-based theoretical spacing  √A';

  @override
  String get spRcTable19MaxDistance => 'Table 19 — Max. S and D distance';

  @override
  String get spRcAppliedGridSpacing => 'Applied grid spacing';

  @override
  String get spRcDistanceConstraintBinding =>
      '⚠ DISTANCE LIMIT governs (√A > max. distance)';

  @override
  String get spRcAreaConstraintBinding => '✓ Area limit governs';

  @override
  String get spRcHorizontalRow => 'Horizontal row (along width)';

  @override
  String get spRcVerticalRow => 'Vertical row (along length)';

  @override
  String get spRcActualCoveragePerHead => 'Actual coverage per sprinkler';

  @override
  String get spRcTotalSprinklers => 'TOTAL SPRINKLERS';

  @override
  String get spRcMainFloorSuffix => '(main floor)';

  @override
  String get spRcSprinklersInDesignArea => 'Sprinklers within design area';

  @override
  String get spRcSuspendedCeilingVoid => 'Suspended ceiling void';

  @override
  String get spRcExtraSprinklerRequired =>
      '⚠ Extra sprinklers required (> 80 cm)';

  @override
  String get spRcExtraSprinklerNotRequired =>
      '✓ Extra sprinklers not required (≤ 80 cm)';

  @override
  String get spRcConcealedVoidSprinklerCount =>
      'Concealed-void sprinkler count';

  @override
  String get spRcAppliedToUpperGridSuffix =>
      '(applied to the same grid on the upper level)';

  @override
  String get spRcFarthestHeadFlow => 'Farthest sprinkler flow  q';

  @override
  String get spRcDesignTotalFlow => 'Total design flow  Q';

  @override
  String spRcBranchPipeDN(String dn) {
    return 'Branch pipe  DN$dn';
  }

  @override
  String spRcCrossPipeDN(String dn) {
    return 'Distribution pipe  DN$dn';
  }

  @override
  String spRcMainPipeDN(String dn) {
    return 'Supply / main pipe  DN$dn';
  }

  @override
  String get spRcTotalFrictionLoss => 'Total friction loss';

  @override
  String spRcStaticHeadFormula(String height) {
    return 'Static head  ($height m × 0.098)';
  }

  @override
  String get spRcFarthestHeadMinPressure => 'Farthest sprinkler min. pressure';

  @override
  String get spRcSafetyMarginLabel => 'Safety margin';

  @override
  String get spRcColDistance => 'Distance\n(m)';

  @override
  String get spRcColPressure => 'Pressure\n(bar)';

  @override
  String get spRcColFlowLower => 'q\n(L/min)';

  @override
  String get spRcColCumFlow => 'ΣQ\n(L/min)';

  @override
  String get spRcColNextDeltaP => 'ΔP next\n(bar)';

  @override
  String get spRcSectionBranchPipe => '── Branch Pipe (Range Pipe) ──';

  @override
  String get spRcSectionDistPipe => '── Distribution Pipe ──';

  @override
  String get spRcSectionMainPipe => '── Main Pipe ──';

  @override
  String get spRcHydraulicFootnote =>
      'SP1 = farthest sprinkler  ·  DP1 = design point  ·  MP = main pipe  ·  K-proportioning: Q_j = Q_crit×√(P_j/P_DP)  ·  Hazen-Williams C=120, 20% fitting allowance included  (EN 12845 §13.3.2)';

  @override
  String get spRcPumpFlowLabel => 'Pump Flow';

  @override
  String get spRcPumpPressureLabel => 'Pump Pressure';

  @override
  String get spRcTable6AppliedIntro =>
      'TS EN 12845+A1 Table 6 applied — binding minimum values for pump sizing in pre-calculated systems:';

  @override
  String spRcTable6FlowLine(String calc, String min) {
    return '• Flow: iterative hydraulic flow $calc L/min < Table 6 min. $min L/min → $min L/min used';
  }

  @override
  String spRcTable6PressureLine(String min, String applied) {
    return '• Pressure: calculated < Table 6 min. ($min + ps) bar → $applied bar applied';
  }

  @override
  String spRcMaxPressureWarning(String pressure, String zones) {
    return '⚠ EN 12845 §8.2 — Pump pressure $pressure bar; the maximum working pressure at any sprinkler location in the system must not exceed 12 bar. A pressure-reducing valve (PRV) split into $zones pressure zones, or a system redesign, should be considered.';
  }

  @override
  String get spRcInstallationClassLabel => 'Installation Class';

  @override
  String get spRcPumpCount => 'Number of Pumps';

  @override
  String get spRcElectricDieselSuffix => '  (electric + diesel)';

  @override
  String get spRcWaterSource => 'Water Source';

  @override
  String get spRcDualIndependent => 'Duplicate (independent)';

  @override
  String get spRcSingle => 'Single';

  @override
  String get spRcJockeyPump => 'Jockey Pump';

  @override
  String get spRcWaterSupplyDuration => 'Water Supply Duration';

  @override
  String spRcSupplyDurationSub(String cls, String minutes) {
    return '$cls → $minutes min';
  }

  @override
  String get spRcMinWaterTank => 'Min. Water Tank';

  @override
  String get spRcWaterSupplyNote =>
      'EN 12845:2015 Table 2 — Water supply may be provided by a tank or a direct mains connection. Whichever option is chosen, adding a safety margin to the tank is recommended.';

  @override
  String get spRcPipeNetworkVolume => 'Pipe Network Internal Volume';

  @override
  String get spRcDryPipeNote =>
      'This volume is only a reference for preliminary sizing of the air compressor / nitrogen generator and priming water. Trip time, accessory needs (accelerator/exhauster) and pipe slope must be finalised separately per the manufacturer\'s / design standard\'s requirements.';

  @override
  String get spRcRackLevelCount => 'Number of Rack Levels';

  @override
  String get spRcEstExtraInRackSprinklers =>
      'Estimated Extra In-Rack Sprinklers';

  @override
  String get spRcEstExtraFlow => 'Estimated Extra Flow';

  @override
  String get spRcRackNote =>
      'This is a simplified preliminary design value (3 m horizontal spacing assumption, K80, 1.0 bar). The exact in-rack layout — flue-space width, tier spacing and actual hydraulic demand — must be determined by a full design under EN 12845 Annex H and added separately to the pump/water-tank calculation.';

  @override
  String get spRcHHPTable14Warning =>
      '⚠  HHP class: EN 12845 Table 14 does not apply. Diameters are determined by full hydraulic calculation under EN 12845 Annex C. The values below are based on a preliminary velocity ≤ 5 m/s method.';

  @override
  String get spRcSprinklerTypeKFactor => 'Sprinkler Type / K-Factor';

  @override
  String get spRcBranchPipeRow => 'Branch pipe (branch line)';

  @override
  String get spRcVelocityMethodSuffix => '  (velocity method)';

  @override
  String get spRcTable14Suffix => '  (Tb.14)';

  @override
  String get spRcCrossMainRow => 'Distribution pipe (cross main)';

  @override
  String spRcBranchConnCount(String branches, String heads) {
    return '$branches branch lines / $heads spr.';
  }

  @override
  String get spRcMainSupplyRow => 'Main pipe / supply';

  @override
  String spRcDesignAreaHeadsSuffix(String n) {
    return '$n spr. (design area)';
  }

  @override
  String get spRcColPipeType => 'Pipe Type';

  @override
  String get spRcColCountLength => 'Count × Length';

  @override
  String get spRcColTotalM => 'Total (m)';

  @override
  String get spRcRowBranchPipe => 'Branch pipe (branch)';

  @override
  String spRcRowCrossMain(String n) {
    return 'Distribution (cross main)\n[$n branch-line connections]';
  }

  @override
  String get spRcRowMainPipe => 'Main pipe\n[pump run + remaining length]';

  @override
  String get spRcTotalPipeLength => 'TOTAL PIPE LENGTH';

  @override
  String get spRcPipeLengthFootnote =>
      '* The pipe length is approximate. A 20% fitting allowance has been included. The exact length must be calculated on the architectural plan.';

  @override
  String get spRcRequiredAlarmValve => 'Required Wet Alarm Valves:  ';

  @override
  String get spRcTotalSprinklersRow => 'Total sprinklers';

  @override
  String get spRcMaxSprinklersPerValve => 'Max. sprinklers / valve';

  @override
  String get spRcHHPClassSuffix => 'HHP class';

  @override
  String get spRcLHOHClassSuffix => 'LH/OH class';

  @override
  String get spRcMaxAreaPerValve => 'Max. area / valve';

  @override
  String get spRcAreaPerValve => 'Area per valve';

  @override
  String get spRcDesignFlowPerValve => 'Design flow per valve';

  @override
  String get spRcSingleValveSuffix =>
      '  (the whole system is calculated through a single valve)';

  @override
  String spRcAlarmValveNote(String scope) {
    return 'EN 12845:2015 Clause 11.2.1: One wet alarm valve zone can protect $scope of surface area.';
  }

  @override
  String get spRcAlarmValveScopeHH =>
      'up to 500 sprinklers and 2 300 m² in HHP classes';

  @override
  String get spRcAlarmValveScopeLHOH =>
      'up to 1 000 sprinklers and 4 800 m² in LH/OH classes';

  @override
  String get spRcConcentrateType => 'Concentrate type';

  @override
  String spRcConcentrationSuffix(String pct) {
    return '  —  $pct% concentration';
  }

  @override
  String get spRcLiquidCategory => 'Liquid category';

  @override
  String get spRcPolarSolventDetail =>
      'Polar Solvent (B2) — acetone, ethanol, ketone, solvent';

  @override
  String get spRcHydrocarbonDetail => 'Hydrocarbon (B1) — petrol, diesel, oil';

  @override
  String get spRcProtectedArea => 'Protected area';

  @override
  String get spRcApplicationRate => 'Application rate';

  @override
  String get spRcApplicationDuration => 'Application duration';

  @override
  String get spRcSolutionFlow => 'Solution flow (Q)';

  @override
  String get spRcConcentrateFlow => '  Concentrate flow';

  @override
  String get spRcWaterFlow => '  Water flow';

  @override
  String get spRcConcentrateTankVolume => 'Concentrate tank volume';

  @override
  String get spRcWaterReserve => 'Water reserve';

  @override
  String get spRcFoamNote7 =>
      'EN 13565-2 Clause 7: The concentrate tank volume and water reserve are minimum values. The actual design must account for a safety margin and simultaneous use.';

  @override
  String get spRcFinalDisclaimer =>
      '⚠  This is an approximate preliminary calculation. The official project design requires a full hydraulic calculation under EN 12845 Annex C and approval by a qualified engineer. A 20% allowance for fitting losses has been included in the lengths.';

  @override
  String get updateAvailableTitle => 'New Version Available';

  @override
  String updateAvailableMessage(String version) {
    return 'The app has been updated to version v$version.\nUpdate to use the latest features.';
  }

  @override
  String get updateLaterButton => 'Later';

  @override
  String get updateNowButton => 'Update';

  @override
  String loginRateLimitMessage(String time) {
    return 'Too many failed login attempts. Try again in $time.';
  }

  @override
  String savedOnLabel(String date) {
    return 'Saved: $date';
  }

  @override
  String get upgradeRequiredTitle => 'Upgrade Required';

  @override
  String get upgradeRequiredMessage =>
      'This module is not available in the demo version. Create your MEVOS account and start a Fire module subscription to access all modules.';

  @override
  String get upgradeSignUpButton => 'Sign Up';

  @override
  String get geminiApiKeyRequiredInfo =>
      'A free Google Gemini API key is required for the AI feature.';

  @override
  String get enterStandardNumberFirst => 'Enter the standard number first.';

  @override
  String get apiKeyRequiredError => 'API key required.';

  @override
  String get standardNotFoundError => 'Standard not found.';

  @override
  String get enterTopicOrKeywordFirst => 'Enter a topic or keyword first.';

  @override
  String get relatedStandardNotFound => 'No related standard found.';

  @override
  String get addCustomStandardTitle => 'Add Custom Standard';

  @override
  String get byNumberTab => 'By Number';

  @override
  String get byTopicTab => 'By Topic';

  @override
  String get findDescriptionWithAiTooltip => 'Find description with AI';

  @override
  String get searchStandardsWithAiTooltip => 'Search standards with AI';

  @override
  String get selectAllButton => 'Select All';

  @override
  String get deselectAllButton => 'Deselect All';

  @override
  String addSelectedButton(int count) {
    return 'Add Selected ($count)';
  }

  @override
  String get customAddedStandardsHeader => 'Custom Added Standards';

  @override
  String get deleteStandardTitle => 'Delete Standard';

  @override
  String deleteStandardConfirm(String number) {
    return 'Remove \"$number\" from the list?';
  }

  @override
  String get aiAssistantTitle => 'AI Assistant';

  @override
  String aiChatGreeting(String standard) {
    return 'I can answer your questions about the $standard standard.';
  }

  @override
  String get rehberFireLoadScenario => 'Fire Load & Fire Scenario';

  @override
  String get rehberGasSuppressionSystems => 'Gas Suppression Systems';

  @override
  String get rehberWaterBasedSuppression => 'Water-Based Suppression Systems';

  @override
  String get rehberFoamSuppressionSystems => 'Foam Suppression Systems';

  @override
  String get rehberKitchenHoodSuppression =>
      'Kitchen Hood & Cooking Suppression';

  @override
  String get rehberFireExtinguishersPortable =>
      'Fire Extinguishers & Portable Equipment';

  @override
  String get rehberStructuralFireResistance => 'Structural Fire Resistance';

  @override
  String get rehberRiskAssessmentSafety =>
      'Risk Assessment & Safety Management';

  @override
  String get rehberIndustrialSpecialRisk =>
      'Industrial & Special Hazard Systems';

  @override
  String get stdDescEn1991FireLoad =>
      'Eurocode 1 Part 1-2: Actions on structures — Actions on structures exposed to fire. Calculation of fire load density, growth rate and fire scenario.';

  @override
  String get stdDescIso1716Ncv =>
      'Determination of the heat of combustion of construction materials and products — Method for determining net calorific value (NCV).';

  @override
  String get stdDescIso5660ConeCalorimeter =>
      'Reaction-to-fire tests — Heat release rate, smoke production rate and mass loss rate. Cone calorimeter method.';

  @override
  String get stdDescNfpa557FireLoadDensity =>
      'Standard for determination of fire load for structural fire protection design — Reference density tables by building occupancy type.';

  @override
  String get stdDescIso24679FireBehaviour =>
      'Fire safety engineering — Performance of structures in fire.';

  @override
  String get stdDescIso16733FireScenario =>
      'Fire safety engineering — Selection of design fire scenarios and design fires.';

  @override
  String get stdDescSfpeHandbook =>
      'Fire protection engineering reference handbook — Calculation methods, fire dynamics, smoke movement.';

  @override
  String get stdDescPd7974FireInitiation =>
      'BSI — Application of fire safety engineering principles to the design of buildings: Initiation and development of fire.';

  @override
  String get stdDescIso145201GeneralRules =>
      'Gaseous fire-extinguishing systems — General requirements: design, installation, commissioning, maintenance and safety.';

  @override
  String get stdDescIso145202Co2 =>
      'CO2 extinguishing systems — Total flooding and local application methods.';

  @override
  String get stdDescIso145205Hfc227 =>
      'HFC-227ea (FM-200) gaseous extinguishing systems — Concentration and volume calculation.';

  @override
  String get stdDescIso145208Hcfc =>
      'HCFC Blend A (Halotron I) extinguishing systems.';

  @override
  String get stdDescIso145209Hfc23 =>
      'HFC 23 (trifluoromethane) extinguishing systems.';

  @override
  String get stdDescIso1452010Ig55 =>
      'IG-55 (Argonite) systems — N2/Ar mixture, inert gas.';

  @override
  String get stdDescIso1452011Ig541 =>
      'IG-541 (Inergen) — N2/Ar/CO2 mixture, inert gas extinguishing.';

  @override
  String get stdDescIso1452012Ig01 => 'IG-01 (argon) extinguishing systems.';

  @override
  String get stdDescIso1452013Ig100 =>
      'IG-100 (nitrogen) extinguishing systems.';

  @override
  String get stdDescIso1452015Novec =>
      'FK-5-1-12 (Novec 1230) — Low GWP value, for sensitive equipment rooms.';

  @override
  String get stdDescNfpa2001CleanAgent =>
      'USA — Standard for clean agent fire extinguishing systems.';

  @override
  String get stdDescNfpa12Co2Us =>
      'CO2 extinguishing systems — US standard, total flooding and local application.';

  @override
  String get stdDescNfpa12aHalon =>
      'Halon 1301 extinguishing systems — USA, existing systems.';

  @override
  String get stdDescTsEn150041GeneralReq =>
      'Fixed firefighting systems — Gas extinguishing systems, general requirements.';

  @override
  String get stdDescVds2380Design =>
      'Germany — Guidelines for the design and installation of gas extinguishing systems.';

  @override
  String get stdDescNfpa34DippingCoating =>
      'Dipping, coating and printing processes using flammable/combustible liquids — fundamental safety standard.';

  @override
  String get stdDescNfpa34Sec10PrintingOps =>
      'Printing Operations: printing area construction, ventilation, electrical classification and fire protection.';

  @override
  String get stdDescNfpa34Sec106AutoSuppression =>
      'Mandatory automatic fire suppression — Sprinklers for Class I liquids; local CO2/clean agent for drying compartments.';

  @override
  String get stdDescNfpa12PrintingPressLocal =>
      'CO2 extinguishing — local application systems for printing press and drying compartments.';

  @override
  String get stdDescNfpa2001PrintingCabin =>
      'Clean agent extinguishing — printing press enclosure protection, preferred where personnel are present.';

  @override
  String get stdDescNfpa30PrintingSolvent =>
      'Flammable and combustible liquids code — solvent storage and use in printing facilities.';

  @override
  String get stdDescNfpa70Article516 =>
      'ATEX/NEC hazardous (explosive) atmosphere classification and electrical equipment for printing areas.';

  @override
  String get stdDescEn10101PrintingSafetyGeneral =>
      'Safety of printing machinery — General requirements.';

  @override
  String get stdDescEn10102PrintingSafetyMachines =>
      'Safety of printing machinery — Printing and varnishing machines (offset, flexo, gravure).';

  @override
  String get stdDescEn13463AtexEquipment =>
      'ATEX equipment — Safety criteria for equipment intended for use in potentially explosive atmospheres.';

  @override
  String get stdDescTsEn150041PrintingCabinet =>
      'Gas extinguishing systems — General requirements (clean agent calculation for printing cabinets).';

  @override
  String get stdDescTsEn12845Sprinkler =>
      'Fixed sprinkler systems — Design, installation and maintenance. Hazard class, density, flow rate and water storage volume.';

  @override
  String get stdDescNfpa13SprinklerInstallation =>
      'Standard for the installation of sprinkler systems — USA, all building types.';

  @override
  String get stdDescNfpa13rResidential =>
      'Sprinkler systems in residential occupancies — buildings up to four storeys.';

  @override
  String get stdDescNfpa13dOneTwoFamily =>
      'Sprinkler systems in one- and two-family dwellings.';

  @override
  String get stdDescNfpa15WaterSpray =>
      'Fixed water spray extinguishing systems — Equipment and hazard protection.';

  @override
  String get stdDescNfpa16FoamWaterSpray =>
      'Foam-water spray and foam-water sprinkler systems.';

  @override
  String get stdDescEn14339UndergroundHydrant =>
      'Underground fire hydrant systems — Design and installation.';

  @override
  String get stdDescEn14384AboveGroundHydrant =>
      'Above-ground fire hydrant systems.';

  @override
  String get stdDescEn6711SemiRigidHose =>
      'Fixed firefighting equipment — Hose reels with semi-rigid hose.';

  @override
  String get stdDescEn6712FlatHoseHydrant =>
      'Fixed firefighting equipment — Hose systems with flat hose.';

  @override
  String get stdDescEn6713Maintenance =>
      'Fixed firefighting equipment — Maintenance, Part 3.';

  @override
  String get stdDescEn122591Components =>
      'Fixed firefighting systems — Components for sprinkler and water spray systems.';

  @override
  String get stdDescTsEn149721WaterMistDesign =>
      'Fixed firefighting systems — Water mist systems, Part 1: Design and installation.';

  @override
  String get stdDescNfpa750WaterMist =>
      'Standard on water mist fire protection systems — USA.';

  @override
  String get stdDescNfpa11ExpansionFoam =>
      'Low-, medium- and high-expansion foam extinguishing systems — US standard.';

  @override
  String get stdDescEn135651FoamRequirements =>
      'Fixed foam extinguishing systems — Part 1: Requirements and test methods.';

  @override
  String get stdDescEn135652FoamDesignInstall =>
      'Fixed foam extinguishing systems — Part 2: Design, installation and maintenance.';

  @override
  String get stdDescIso72031FoamConcentrates =>
      'Fire extinguishing media — Foam concentrates for liquid fuel fires.';

  @override
  String get stdDescNfpa30StorageTransfer =>
      'Flammable and combustible liquids code — Storage and transfer.';

  @override
  String get stdDescApi2021TankFirePrevention =>
      'Petroleum industry — Storage tank fire prevention and extinguishing.';

  @override
  String get stdDescNfpa17aWetChemical =>
      'Wet chemical extinguishing systems — Commercial kitchen applications.';

  @override
  String get stdDescNfpa17DryChemical =>
      'Dry chemical extinguishing systems — General industrial applications.';

  @override
  String get stdDescTsEn15751CommercialKitchen =>
      'Europe — Fixed firefighting systems for commercial catering equipment.';

  @override
  String get stdDescUl300CookingSuppression =>
      'US product listing standard — Fire extinguishing systems for cooking areas (Ansul, Amerex, etc.).';

  @override
  String get stdDescUl300aAutoSuppressionCooking =>
      'Automatic extinguishing systems — Fire hazards above cooking equipment.';

  @override
  String get stdDescTsEn18251GreaseSeparators =>
      'Kitchen hood grease separators and filters.';

  @override
  String get stdDescTsEn18252GreaseSelection =>
      'Kitchen hood grease separators — Selection, installation and maintenance.';

  @override
  String get stdDescNfpa96VentilationCooking =>
      'Standard for ventilation control and fire protection of commercial cooking operations — Ducts, hoods and fire prevention.';

  @override
  String get stdDescEn541Introduction =>
      'Fire detection and fire alarm systems — Part 1: Introduction.';

  @override
  String get stdDescEn542ControlIndicating =>
      'Fire alarm control and indicating equipment.';

  @override
  String get stdDescEn543SoundersDevices => 'Fire alarm devices — Sounders.';

  @override
  String get stdDescEn544PowerSupply => 'Power supply equipment.';

  @override
  String get stdDescEn545HeatDetectors => 'Heat detectors — Point detectors.';

  @override
  String get stdDescEn547SmokeDetectorsOptical =>
      'Smoke detectors — Point detectors using scattered light, transmitted light or ionization.';

  @override
  String get stdDescEn5410FlameDetectors =>
      'Flame detectors — Point detectors.';

  @override
  String get stdDescEn5411ManualCallPoint =>
      'Manual call points (break-glass type).';

  @override
  String get stdDescEn5412SmokeDetectorsLinear =>
      'Smoke detectors — Line detectors using an optical light beam.';

  @override
  String get stdDescEn5413SystemCompatibility =>
      'Assessment of compatibility and connectability of system components.';

  @override
  String get stdDescEn5414PlanningGuide =>
      'Fire detection and fire alarm systems — Guidelines for planning, design, installation, commissioning, use and maintenance.';

  @override
  String get stdDescEn5416VoiceAlarm =>
      'Voice alarm control and indicating equipment.';

  @override
  String get stdDescEn5417ShortCircuitIsolators => 'Short-circuit isolators.';

  @override
  String get stdDescEn5418InputOutputDevices => 'Input/output devices.';

  @override
  String get stdDescEn5420AspiratingSmoke =>
      'Smoke detectors — Aspirating smoke detectors.';

  @override
  String get stdDescEn5421AlarmTransmission =>
      'Alarm transmission and fault warning routing equipment.';

  @override
  String get stdDescEn5423VisualAlarm =>
      'Fire alarm devices — Visual alarm devices.';

  @override
  String get stdDescEn5425RadioComponents =>
      'Components using radio links (wireless system components).';

  @override
  String get stdDescNfpa72NationalCode =>
      'USA — National Fire Alarm and Signaling Code. Addressing, notification, infrastructure.';

  @override
  String get stdDescVds2095PlanningInstall =>
      'Germany — Guidelines for the planning and installation of fire alarm systems.';

  @override
  String get stdDescEn121011SmokeCurtains =>
      'Smoke and heat control systems — Part 1: Specification for smoke barriers.';

  @override
  String get stdDescEn121012NaturalVentilators =>
      'Natural smoke and heat exhaust ventilators — Performance requirements.';

  @override
  String get stdDescEn121013PoweredExhaust =>
      'Mechanical smoke exhaust systems — Powered smoke and heat exhaust ventilators.';

  @override
  String get stdDescEn121014InstallCommission =>
      'Guide to installation, acceptance testing, routine maintenance and repair.';

  @override
  String get stdDescEn121016PressureDifferential =>
      'Pressure differential smoke control systems — Kit specifications.';

  @override
  String get stdDescEn121017DuctlessNaturalVent =>
      'Smoke and heat exhaust ventilators — Ductless natural smoke exhaust.';

  @override
  String get stdDescEn121018TunnelControlPanels =>
      'Control panels for natural smoke and heat exhaust ventilation systems used in tunnels.';

  @override
  String get stdDescEn121019FireDamperControl =>
      'Control equipment for smoke control dampers.';

  @override
  String get stdDescEn1210110PowerSupplyKits => 'Power supply kits.';

  @override
  String get stdDescNfpa92SmokeControlUs =>
      'USA — Standard for smoke control systems. Pressurized stairwells, atrium smoke management.';

  @override
  String get stdDescNfpa101LifeSafety =>
      'USA — Life Safety Code, means of egress, exit requirements.';

  @override
  String get stdDescEn16341DoorFireResistance =>
      'Fire and smoke control door and shutter assemblies — Fire resistance test.';

  @override
  String get stdDescEn16343SmokeControl => 'Fire doors — Smoke control test.';

  @override
  String get stdDescEn15650FireDampers =>
      'Fire dampers for ventilation systems.';

  @override
  String get stdDescEn158821ExtendedApplication =>
      'Extended application of results from fire resistance tests for smoke control dampers.';

  @override
  String get stdDescEn37PortableExtPerformance =>
      'Portable fire extinguishers — Performance, test methods and construction.';

  @override
  String get stdDescEn38PortableExtAdditional =>
      'Portable fire extinguishers — Additional requirements and tests.';

  @override
  String get stdDescEn39PortableExtCo2 =>
      'Portable fire extinguishers — CO2 extinguishers.';

  @override
  String get stdDescEn310PortableExtSpecial =>
      'Portable fire extinguishers — Special requirements.';

  @override
  String get stdDescNfpa10PortableUs =>
      'USA — Standard for portable fire extinguishers.';

  @override
  String get stdDescEn18661MobileCo2 => 'Mobile CO2 fire extinguishers.';

  @override
  String get stdDescTsEn615DryChemicalPowder =>
      'Fire extinguishing media — Specifications for dry powders.';

  @override
  String get stdDescTsEn15683FoamConcentrates =>
      'Fire extinguishing media — Foam concentrates.';

  @override
  String get stdDescEn1992Eurocode2 =>
      'Reinforced concrete structures — Structural design for fire resistance (Eurocode 2).';

  @override
  String get stdDescEn1993Eurocode3 =>
      'Steel structures — Structural design for fire resistance (Eurocode 3).';

  @override
  String get stdDescEn1994Eurocode4 =>
      'Composite steel and concrete structures — Design for fire resistance (Eurocode 4).';

  @override
  String get stdDescEn1995Eurocode5 =>
      'Timber structures — Structural design for fire resistance (Eurocode 5).';

  @override
  String get stdDescEn1996Eurocode6 =>
      'Masonry structures — Structural design for fire resistance (Eurocode 6).';

  @override
  String get stdDescIso8341StandardFireCurve =>
      'Standard fire curve — Fire resistance test for building elements.';

  @override
  String get stdDescIso8342AlternativeCurves =>
      'Alternative and parametric fire curves.';

  @override
  String get stdDescEn135011ReactionToFire =>
      'Fire classification of construction products and building elements — Reaction to fire.';

  @override
  String get stdDescEn135012FireResistanceClass =>
      'Fire resistance classification of building elements.';

  @override
  String get stdDescEn135013VentilationServices =>
      'Classification of fire resistance of ventilation service products.';

  @override
  String get stdDescEn135014SmokeControlDoors =>
      'Classification of smoke control doors and building elements.';

  @override
  String get stdDescEn135015Roofs =>
      'Roofs — Classification using data from external fire exposure tests.';

  @override
  String get stdDescNfpa220ConstructionTypes =>
      'USA — Standard on types of building construction.';

  @override
  String get stdDescUl263FireResistanceTests =>
      'USA — Fire tests of building construction and materials.';

  @override
  String get stdDescAstmE119FireEndurance =>
      'USA — Standard test methods for fire tests of building construction and materials.';

  @override
  String get stdDescIso31000RiskManagement =>
      'Risk management — Guidelines and general framework.';

  @override
  String get stdDescIso45001Ohs =>
      'Occupational health and safety management systems — Requirements with guidance for use.';

  @override
  String get stdDescIso16069SafetyWayGuidance =>
      'Graphical symbols — Safety signs — Safety way guidance systems (emergency escape lighting and wayfinding).';

  @override
  String get stdDescEn50172EmergencyLighting =>
      'Emergency escape lighting systems — Installation and operation.';

  @override
  String get stdDescNfpa1FireCode =>
      'USA — Fire Code. Building occupancy, exits, evacuation and hazards.';

  @override
  String get stdDescNfpa25InspectionTesting =>
      'Water-based fire protection systems — Inspection, testing and maintenance.';

  @override
  String get stdDescEnIso7010SafetySigns =>
      'Safety signs — Registered safety signs for emergency exits, firefighting equipment and hazard warnings.';

  @override
  String get stdDescTs9811FireSafetySigns =>
      'Turkey — Safety signs for fire protection.';

  @override
  String get stdDescTbdy2018SeismicSteelFire =>
      'Turkish Building Earthquake Code — Section 3: Structural steel, fire effects.';

  @override
  String get stdDescTrFireRegulation2015 =>
      'Turkey — Requirements for fire protection, evacuation, extinguishing and alarm systems in buildings.';

  @override
  String get stdDescNfpa850PowerGeneration =>
      'Fire protection for electric generating plants — Turbine areas, transformers and cable routes.';

  @override
  String get stdDescNfpa804NuclearPlants =>
      'Standard for fire protection for nuclear power generating plants.';

  @override
  String get stdDescNfpa409AircraftHangars =>
      'Standard on aircraft hangars fire protection.';

  @override
  String get stdDescNfpa415AircraftFueling =>
      'Aircraft fuel servicing systems and work areas.';

  @override
  String get stdDescEn11271ExplosivePrevention =>
      'Explosive atmospheres — Explosion prevention and protection, basic concepts.';

  @override
  String get stdDescEn6007910ZoneClassification =>
      'Explosive atmospheres — Classification of areas (gas atmospheres).';

  @override
  String get stdDescIec61511FunctionalSafety =>
      'Functional safety — Safety instrumented systems for the process industry sector.';

  @override
  String get stdDescApi610PetrochemPumps =>
      'Pumps in petrochemical facilities — Fire safety requirements.';

  @override
  String get stdDescNfpa654CombustibleDust =>
      'Protection against fire and explosion from combustible dust.';

  @override
  String get stdDescNfpa68ExplosionVenting =>
      'Standard on explosion protection by deflagration venting.';

  @override
  String get stdDescNfpa69ExplosionPrevention =>
      'Standard on explosion prevention systems.';

  @override
  String get spActOfficesAdmin => 'Offices and administration buildings';

  @override
  String get spActHotelsHostelsGuesthouses =>
      'Hotels, hostels, boarding houses';

  @override
  String get spActHospitalsClinics => 'Hospitals, clinics, health centres';

  @override
  String get spActSchoolsUniversities =>
      'Schools, universities and educational buildings';

  @override
  String get spActResidentialApartments => 'Residences and apartment buildings';

  @override
  String get spActPrisonsReformatories => 'Prisons and reformatories';

  @override
  String get spActChurchesMosquesWorship =>
      'Churches, mosques and places of worship';

  @override
  String get spActTheatresCinemaSeating =>
      'Theatres / cinemas (auditorium seating areas only)';

  @override
  String get spActMuseumsGalleries => 'Museums and art galleries';

  @override
  String get spActBreweriesExclDistilleries =>
      'Breweries (excluding distilleries)';

  @override
  String get spActMultiStoreyBasementCarParks =>
      'Multi-storey and basement enclosed car parks';

  @override
  String get spActCeramicsProduction => 'Ceramic products manufacturing';

  @override
  String get spActGlassGlasswareExclFibre =>
      'Glass and glassware manufacturing (excluding glass fibre)';

  @override
  String get spActChemResearchLabs => 'Chemical research laboratories';

  @override
  String get spActDairyProcessing => 'Dairy processing plants (creameries)';

  @override
  String get spActElectronicsAssembly =>
      'Electronic equipment assembly workshops';

  @override
  String get spActFoodProcessingPackaging =>
      'Food processing and packaging plants';

  @override
  String get spActHotelsKitchenLaundryService =>
      'Hotels — kitchen, laundry and service areas';

  @override
  String get spActInstitutionalCommercialLaundries =>
      'Institutional and commercial laundries';

  @override
  String get spActLeatherProductsProduction =>
      'Leather and leather goods manufacturing';

  @override
  String get spActLightMetalworkingWorkshops => 'Light metalworking workshops';

  @override
  String get spActPharmaceuticalProduction =>
      'Pharmaceutical manufacturing plants';

  @override
  String get spActResearchLabsNonflamLiquids =>
      'Research laboratories (using non-flammable liquids)';

  @override
  String get spActTextileWeavingNaturalFibresUntreated =>
      'Textile weaving — cotton/wool/natural fibre (untreated)';

  @override
  String get spActTobaccoProcessingPackaging =>
      'Tobacco processing and packaging';

  @override
  String get spActAgriIndustrialMachineryAssembly =>
      'Agricultural and industrial machinery assembly plants';

  @override
  String get spActGrainFlourMillFoodProcessing =>
      'Grain, flour mill and similar food processing';

  @override
  String get spActChemProductionNonflamLiquidsOnly =>
      'Chemical production (non-flammable liquid products only)';

  @override
  String get spActDeptStoresShoppingCentresSingleStorey =>
      'Department stores and shopping centres (single storey)';

  @override
  String get spActElectricalEquipmentFactories =>
      'Electrical equipment manufacturing factories';

  @override
  String get spActComputerDataProcessingRooms =>
      'Computer and electronic data processing rooms';

  @override
  String get spActGeneralEngineeringWorkshopsFactories =>
      'General engineering workshops and factories';

  @override
  String get spActFruitVegCanningFacilities =>
      'Fruit, vegetable and canning processing plants';

  @override
  String get spActVehicleMaintenanceRepairGarages =>
      'Vehicle maintenance and repair garages';

  @override
  String get spActFibreglassProductionAssembly =>
      'Glass fibre (fibreglass) production and assembly';

  @override
  String get spActHardwareIronmongeryStores =>
      'Hardware and ironmongery stores';

  @override
  String get spActHospitalsTreatmentSurgeryAreas =>
      'Hospitals — treatment and surgical areas';

  @override
  String get spActKnittingHosieryFactories => 'Knitting (hosiery) factories';

  @override
  String get spActLibrariesOpenShelfAreas =>
      'Libraries — general open-shelf areas';

  @override
  String get spActGeneralMetalworkingFactories =>
      'General metalworking factories';

  @override
  String get spActPaperBoardProductionFacilities =>
      'Paper and board production facilities';

  @override
  String get spActPlasticsManufNonflamOnly =>
      'Plastic products manufacturing (non-flammable plastics only)';

  @override
  String get spActGeneralPrintingWaterBasedInk =>
      'General printing (water-based ink)';

  @override
  String get spActSupermarketsHypermarkets => 'Supermarkets and hypermarkets';

  @override
  String get spActTailoringGarmentManufacture =>
      'Tailoring, garment and clothing manufacture';

  @override
  String get spActTextileSpinningWeavingSynthetic =>
      'Textile spinning and weaving (synthetic fibre)';

  @override
  String get spActLoadingShippingDocks =>
      'Loading, shipping and dispatch docks';

  @override
  String get spActGeneralStorageUpTo4m =>
      'General storage (stack height ≤ 4 m)';

  @override
  String get spActAircraftHangarsMaintenance =>
      'Aircraft hangars — maintenance and repair areas';

  @override
  String get spActOilclothTarpaulinCanvasProduction =>
      'Oilcloth, tarpaulin and canvas manufacturing';

  @override
  String get spActChemProductionFpAbove55 =>
      'Chemical production (products with flash point > 55 °C)';

  @override
  String get spActColdStores => 'Cold stores';

  @override
  String get spActFilmTvStudiosProduction =>
      'Film and television studios (production areas)';

  @override
  String get spActFurnitureUpholsteryProduction =>
      'Furniture and upholstery manufacturing (foam, fabric)';

  @override
  String get spActJoineryWoodworkingWorkshops =>
      'Joinery — woodworking workshops';

  @override
  String get spActMatchProductionFacilities => 'Match production facilities';

  @override
  String get spActOfficesLargePaperArchives =>
      'Offices with large paper archive areas';

  @override
  String get spActWaterBasedPaintVarnishProduction =>
      'Water-based paint and varnish production';

  @override
  String get spActPaperCorrugatedBoxProduction =>
      'Paper, board and corrugated box processing/production';

  @override
  String get spActThermoplasticsManufShaping =>
      'Thermoplastic manufacturing and shaping';

  @override
  String get spActHighSpeedOffsetPrintingOilInk =>
      'High-speed offset printing (oil-based ink)';

  @override
  String get spActRubberProductsProduction =>
      'Rubber products production facilities';

  @override
  String get spActTextileDyeingFinishingFacilities =>
      'Textile dyeing and finishing facilities';

  @override
  String get spActGeneralStorage4to8m =>
      'General storage (stack height > 4 m – 8 m)';

  @override
  String get spActChemProductionClosedProcessFp55 =>
      'Chemical production (closed process, flash point > 55 °C)';

  @override
  String get spActPlasticRubberPartsClosedMoulding =>
      'Plastic and rubber parts manufacturing (closed extrusion/moulding)';

  @override
  String get spActTextileDyeingFinishingWaterBased =>
      'Textile dyeing and finishing plants (water-based)';

  @override
  String get spActPharmacyCosmeticsDetergentProduction =>
      'Pharmacy, cosmetics and detergent production plants';

  @override
  String get spActFoodBeverageProductionHighVolume =>
      'Food and beverage production plants (high volume)';

  @override
  String get spActPaperProductionDryCuttingSorting =>
      'Paper production and processing plants (dry cutting/sorting)';

  @override
  String get spActPaintShopsWaterUvCuring =>
      'Paint shops using water-based or UV-curing paint';

  @override
  String get spActMetalworkingMachineryHeavySwarfOilMist =>
      'Metalworking and machinery production plants (heavy swarf, oil mist)';

  @override
  String get spActFlammableLiquidProcessFp55Plus =>
      'Flammable liquid processing/storage processes (flash point ≥ 55 °C)';

  @override
  String get spActFoamRubberFoamPlasticProduction =>
      'Foam rubber and foam plastic (PU, EPS/XPS) production plants';

  @override
  String get spActFlowCoatingMetalPlasticParts =>
      'Flow coating of metal and plastic parts';

  @override
  String get spActIndustrialPrintingFlammableInkSolvent =>
      'Industrial printing plants using flammable ink/solvent';

  @override
  String get spActAerosolSprayPackagingFilling =>
      'Aerosol and spray product packaging/filling plants';

  @override
  String get spActFlammableLiquidProcessFpBelow55Open =>
      'Flammable liquid processing (flash point < 55 °C, open vessels)';

  @override
  String get spActChemProductionContainingFp55Liquids =>
      'Chemical production (products containing flammable liquid, flash point ≥ 55 °C)';

  @override
  String get spActSolventBasedPaintVarnishProduction =>
      'Solvent-based paint and varnish production plants';

  @override
  String get spActSpraySolventPaintApplication =>
      'Spray paint shop — flammable solvent-based paint application';

  @override
  String get spActDryCleaningPerchloroethyleneSolvent =>
      'Dry cleaning facilities (perchloroethylene / solvent-based)';

  @override
  String get spActSolventExtractionFacilities =>
      'Solvent extraction facilities';

  @override
  String get spActPrintingGravureFlammableInk =>
      'Printing / gravure facilities using flammable ink';

  @override
  String get spActSprayCoatingBoothsFlammableLiquid =>
      'Spray coating / painting booths using flammable liquid';

  @override
  String get spActRubberMasticFlammableRawMaterialProcessing =>
      'Rubber mastic and flammable raw material processing plants';

  @override
  String get spActPaintInkVarnishPackagingFilling =>
      'Paint, ink or varnish packaging and filling plants';

  @override
  String get spActHighRackPalletStorageSolidAbove4m =>
      'High-rack pallet storage — solid materials, stack height > 4 m';

  @override
  String get spActTyresRubberProductsStorage =>
      'Vehicle tyres and rubber products storage';

  @override
  String get spActPaperRollsReelsStorage => 'Paper rolls and reels storage';

  @override
  String get spActSolidPlasticRawProductStoragePalletRack =>
      'Solid plastic raw material and product storage (palletised/racked)';

  @override
  String get spActBaledCottonTextileSyntheticFibreStorage =>
      'Baled cotton, textile raw material and synthetic fibre storage';

  @override
  String get spActHighRackPalletStorageFlammableLiquidAbove4m =>
      'High-rack pallet storage — products containing flammable liquid, > 4 m  ⚠ High-density water system';

  @override
  String get spActAerosolStoreFlammablePropellantHighRack =>
      'Aerosol product stores (flammable propellant, high-rack)  ⚠ Special system required';

  @override
  String get spActFlammableLiquidPackagedProductStorage =>
      'Flammable liquid packaged product storage (paint, solvent, varnish)  ⚠ Special system';

  @override
  String get spActHighDensityStorageWaterSensitiveHighCalorific =>
      'High-density storage of water-sensitive or high-calorific-value products';

  @override
  String get spActNoncombustibleStorageMetalGlassCeramicConcrete =>
      'Non-combustible product storage — metal, glass, ceramic, concrete products';

  @override
  String get spActFrozenFoodColdChainStorage =>
      'Frozen food and cold-chain product storage';

  @override
  String get spActNoncombustibleInSealedMetalCansDrums =>
      'Non-combustible products in sealed metal cans / drums';

  @override
  String get spActWetFoodFreshProduceCannedStorage =>
      'Wet food (fresh produce, canned goods) stores';

  @override
  String get spActPorcelainSanitarywareStorage =>
      'Porcelain and sanitaryware product storage';

  @override
  String get spActEmptyGlassBottlesMetalCansStorage =>
      'Empty glass bottle / empty metal can storage';

  @override
  String get spActNoncombustibleCartonPackagedStorage =>
      'Non-combustible carton-packaged product storage';

  @override
  String get spActNoncombustibleGoodsWoodenCratesStorage =>
      'Non-combustible goods storage in wooden boxes/crates';

  @override
  String get spActNoncombustibleLiquidGlassPlasticContainersStorage =>
      'Non-combustible liquid storage in glass bottles / plastic containers';

  @override
  String get spActMixedProductsLowCombustibleContentStorage =>
      'Mixed product storage with low combustible content';

  @override
  String get spActGlassCeramicWrappedStorage =>
      'Glass and ceramic products wrapped in packing material storage';

  @override
  String get spActPaperBoardCorrugatedProductStorage =>
      'Paper, board and corrugated product storage';

  @override
  String get spActTextileYarnFabricGarmentStorage =>
      'Textile, yarn, fabric and garment storage';

  @override
  String get spActWoodWoodBasedProductStorage =>
      'Wood and wood-based product storage';

  @override
  String get spActFurnitureUpholsteryMaterialsStorage =>
      'Furniture and upholstery materials storage';

  @override
  String get spActMixedPackagedGoodsPaperPlastic =>
      'Mixed packaged goods (combined paper + plastic) storage';

  @override
  String get spActDryFoodAgriculturalProductsStorage =>
      'Dry food and agricultural products (non-bulk) storage';

  @override
  String get spActLeatherProductsStorage => 'Leather and leather goods storage';

  @override
  String get spActSmallElectricalApplianceStoragePackaged =>
      'Small electrical household appliance storage (packaged)';

  @override
  String get spActExpandedPlasticProductStorageFloor =>
      'Expanded plastic (EPS, PU, XPS) product storage (floor-stacked)';

  @override
  String get spActRubberTyreProductStorageFloor =>
      'Rubber and tyre product storage (floor-stacked)';

  @override
  String get spActFlammableLiquidPlasticContainersStorageFloor =>
      'Plastic containers holding flammable liquid storage (floor-stacked)';

  @override
  String get spActAerosolProductStorageFloor35m =>
      'Aerosol product storage — floor-stacked, ≤ 3.5 m';

  @override
  String get spActPolystyreneFoamPackagedProductStorage =>
      'Polystyrene foam packaged product storage';

  @override
  String get spActHighCalorificCombustibleGoodsStorageFloor =>
      'High-calorific-value combustible goods storage (floor-stacked)';

  @override
  String get spActRackPalletCategoryIGoods =>
      'Rack/pallet system — Category I goods (metal, glass, ceramic)';

  @override
  String get spActHighRackNoncombustibleStorageAbove3m =>
      'High-rack storage — non-combustible products, stack height > 3 m';

  @override
  String get spActPalletSealedMetalGlassStorage =>
      'Palletised sealed metal / glass product storage';

  @override
  String get spActColdStoreHighRackSystem =>
      'Cold store high-rack storage system';

  @override
  String get spActRackPalletCategoryIIGoods =>
      'Rack/pallet system — Category II goods (carton-packaged)';

  @override
  String get spActHighRackCartonBoxedNoncombustibleStorage =>
      'High-rack storage — non-combustible products in carton boxes';

  @override
  String get spActPalletCartonPackagedStorageAbove3m =>
      'Palletised carton-packaged product storage, > 3 m';

  @override
  String get spActWoodenCrateStorageHighRack =>
      'Wooden crate storage, high-rack system';

  @override
  String get spActRackPalletCategoryIIIGoods =>
      'Rack/pallet system — Category III goods (paper, textile, wood)';

  @override
  String get spActHighRackFurnitureWoodProductsStorage =>
      'High-rack storage — furniture, wood products';

  @override
  String get spActBaledCottonTextileRackStorageAbove3m =>
      'Baled cotton/textile rack storage, > 3 m';

  @override
  String get spActPaperRollsRackStorageAbove3m =>
      'Paper rolls and reels rack storage, > 3 m';

  @override
  String get spActMixedPackagedHighRackStorage =>
      'Mixed packaged goods (paper + plastic) high-rack storage';

  @override
  String get spActRackPalletCategoryIVGoods =>
      'Rack/pallet system — Category IV goods (plastic, rubber, foam)';

  @override
  String get spActExpandedPlasticFoamHighRackStorage =>
      'Expanded plastic and foam product high-rack storage';

  @override
  String get spActAerosolRackStorageFlammablePropellantAbove3m =>
      'Aerosol product rack storage — flammable propellant, > 3 m';

  @override
  String get spActSolidPlasticRawProductHighRackStorage =>
      'Solid plastic raw material and product high-rack storage';

  @override
  String get spActFlammablePackagedProductHighRackStorage =>
      'Flammable packaged product high-rack storage (paint, varnish, solvent)';

  @override
  String get spActRubberTyreProductHighRackStorageAbove3m =>
      'Rubber and tyre product high-rack storage, > 3 m';
}
