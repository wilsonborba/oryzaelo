import 'package:flutter/material.dart';
import 'state.dart';

class OryzaDeviceI18n {
  final String name;
  final String role;
  final String dwg;
  final String blueprintImg;
  final String explodedImg;
  final String desc;
  final String specs;

  const OryzaDeviceI18n({
    required this.name,
    required this.role,
    required this.dwg,
    required this.blueprintImg,
    required this.explodedImg,
    required this.desc,
    required this.specs,
  });
}

class OryzaStrings {
  final String navBrand;
  final String navCoords;
  final String navHome;
  final String navSystem;
  final String navHardware;
  final String navTcc;
  final String navLogin;
  final String navSignUp;
  final String backToHome;

  final String exploreSectionHeading;
  final String exploreSectionSystem;
  final String exploreSectionSystemDesc;
  final String exploreSectionHardware;
  final String exploreSectionHardwareDesc;
  final String exploreSectionTcc;
  final String exploreSectionTccDesc;
  final String exploreActionBtn;

  final String heroPill;
  final String heroJingle;
  final String heroManifestoTag;
  final String heroManifestoPrefix;
  final String heroManifestoLine1;
  final String heroManifestoLine2;
  final String heroBridgeTag;

  final String culturalTabOverview;
  final String culturalTabAgronomy;
  final String culturalTabScience;
  final String culturalToggleExpand;
  final String culturalToggleCollapse;

  final String heroThaiCardTag;
  final String heroThaiTitle;
  final String heroThaiRegion;
  final String heroThaiScript;
  final String heroThaiTranslit;
  final String heroThaiMeaning;
  final String heroThaiOverview;
  final String heroThaiAgronomy;
  final String heroThaiScience;

  final String heroBrazilCardTag;
  final String heroBrazilTitle;
  final String heroBrazilRegion;
  final String heroBrazilQuote;
  final String heroBrazilPopular;
  final String heroBrazilOverview;
  final String heroBrazilAgronomy;
  final String heroBrazilScience;

  final String heroHeadline;
  final String heroSubhead;
  final String heroCtaSimulate;
  final String heroCtaGithub;
  final String heroQuickInstall;
  final String heroCopied;

  final String metricLatencyTitle;
  final String metricLatencySub;
  final String metricAccuracyTitle;
  final String metricAccuracySub;
  final String metricGddTitle;
  final String metricGddSub;
  final String metricAirgappedTitle;
  final String metricAirgappedSub;

  final String sysSectionTag;
  final String sysTitle;
  final String sysSubtitle;
  final String sysEdgeTag;
  final String sysEdgeTitle;
  final String sysEdgeSubtitle;
  final String sysEdgeDesc;
  final String sysEdgePill;
  final String sysClientTag;
  final String sysClientTitle;
  final String sysClientSubtitle;
  final String sysClientDesc;
  final String sysClientPill;
  final String sysPipelineHeading;

  final String pipe01Badge;
  final String pipe01Title;
  final String pipe01Desc;
  final String pipe01Eq;

  final String pipe02Badge;
  final String pipe02Title;
  final String pipe02Desc;
  final String pipe02Eq;

  final String pipe03Badge;
  final String pipe03Title;
  final String pipe03Desc;
  final String pipe03Eq;

  final String pipe04Badge;
  final String pipe04Title;
  final String pipe04Desc;
  final String pipe04Eq;

  final String pipe05Badge;
  final String pipe05Title;
  final String pipe05Desc;
  final String pipe05Eq;

  final String hwSectionTag;
  final String hwTitle;
  final String hwSubtitle;
  final String hwToggleBlueprint;
  final String hwToggleExploded;
  final String hwZoomBtn;
  final String hwAiDisclaimer;
  final String hwSpecLabel;
  final String hwAiBadge;
  final String hwInspectorTitle;
  final String hwDeviceSelect;
  final List<OryzaDeviceI18n> hwDevices;

  final String tccSectionTag;
  final String tccTitle;
  final String tccSubtitle;
  final String tccAffiliation;
  final String tccHypothesisTitle;
  final String tccHypothesisText;
  final String tccMetricsTitle;
  final String tccMetricsLatency;
  final String tccMetricsAccuracy;
  final String tccMetricsGdd;
  final String tccReadPaper;
  final String tccAuthor;

  final String tccLanguageNoticeTag;
  final String tccLanguageNoticeDesc;

  final String tccCard1Tag;
  final String tccCard1Title;
  final String tccCard1Desc;
  final String tccCard1TargetLabel;

  final String tccCard2Tag;
  final String tccCard2Title;
  final String tccCard2Desc;
  final String tccCard2TargetLabel;

  final String tccCard3Tag;
  final String tccCard3Title;
  final String tccCard3Desc;
  final String tccCard3TargetLabel;

  final String tccCard4Tag;
  final String tccCard4Title;
  final String tccCard4Desc;
  final String tccCard4TargetLabel;

  final String tccCardTeamTag;
  final String tccCardTeamTitle;
  final String tccCardTeamDesc;
  final String tccAuthorLabel;
  final String tccAdvisorLabel;
  final String tccInstitutionLabel;

  final String tccPaperBannerTag;
  final String tccPaperBannerTitle;
  final String tccPaperBannerDesc;
  final String tccGithubBtn;

  final String navBenchmark;
  final String exploreSectionBenchmark;
  final String exploreSectionBenchmarkDesc;

  final String benchmarkSectionTag;
  final String benchmarkTitle;
  final String benchmarkSubtitle;

  final String benchmarkMetricLatencyVal;
  final String benchmarkMetricLatencyTitle;
  final String benchmarkMetricLatencySub;
  final String benchmarkMetricPowerVal;
  final String benchmarkMetricPowerTitle;
  final String benchmarkMetricPowerSub;
  final String benchmarkMetricAccuracyVal;
  final String benchmarkMetricAccuracyTitle;
  final String benchmarkMetricAccuracySub;
  final String benchmarkMetricOfflineVal;
  final String benchmarkMetricOfflineTitle;
  final String benchmarkMetricOfflineSub;

  final String benchmarkTableHeading;
  final String benchmarkTableSubheading;
  final String benchmarkColCriterion;
  final String benchmarkColOryza;
  final String benchmarkColSatellite;
  final String benchmarkColDrone;
  final String benchmarkColCloudWeather;

  final String benchmarkRowLatencyTitle;
  final String benchmarkRowLatencyOryza;
  final String benchmarkRowLatencySatellite;
  final String benchmarkRowLatencyDrone;
  final String benchmarkRowLatencyCloudWeather;

  final String benchmarkRowCloudTitle;
  final String benchmarkRowCloudOryza;
  final String benchmarkRowCloudSatellite;
  final String benchmarkRowCloudDrone;
  final String benchmarkRowCloudCloudWeather;

  final String benchmarkRowOcclusionTitle;
  final String benchmarkRowOcclusionOryza;
  final String benchmarkRowOcclusionSatellite;
  final String benchmarkRowOcclusionDrone;
  final String benchmarkRowOcclusionCloudWeather;

  final String benchmarkRowPowerTitle;
  final String benchmarkRowPowerOryza;
  final String benchmarkRowPowerSatellite;
  final String benchmarkRowPowerDrone;
  final String benchmarkRowPowerCloudWeather;

  final String benchmarkRowCostTitle;
  final String benchmarkRowCostOryza;
  final String benchmarkRowCostSatellite;
  final String benchmarkRowCostDrone;
  final String benchmarkRowCostCloudWeather;

  final String benchmarkRowTemporalTitle;
  final String benchmarkRowTemporalOryza;
  final String benchmarkRowTemporalSatellite;
  final String benchmarkRowTemporalDrone;
  final String benchmarkRowTemporalCloudWeather;

  final String benchmarkRowConnectivityTitle;
  final String benchmarkRowConnectivityOryza;
  final String benchmarkRowConnectivitySatellite;
  final String benchmarkRowConnectivityDrone;
  final String benchmarkRowConnectivityCloudWeather;

  final String benchmarkRowPrivacyTitle;
  final String benchmarkRowPrivacyOryza;
  final String benchmarkRowPrivacySatellite;
  final String benchmarkRowPrivacyDrone;
  final String benchmarkRowPrivacyCloudWeather;

  final String benchmarkChartsHeading;
  final String benchmarkChartsSubheading;
  final String benchmarkLineChartTitle;
  final String benchmarkLineChartSub;
  final String benchmarkLineLegendBrazil;
  final String benchmarkLineLegendThai;
  final String benchmarkLineLegendTheoretical;
  final String benchmarkBarChartTitle;
  final String benchmarkBarChartSub;

  final String benchmarkMapHeading;
  final String benchmarkMapSubheading;
  final String benchmarkMapBrazilTitle;
  final String benchmarkMapBrazilCoords;
  final String benchmarkMapBrazilProduction;
  final String benchmarkMapBrazilYield;
  final String benchmarkMapBrazilClimate;
  final String benchmarkMapBrazilTech;
  final String benchmarkMapThaiTitle;
  final String benchmarkMapThaiCoords;
  final String benchmarkMapThaiProduction;
  final String benchmarkMapThaiYield;
  final String benchmarkMapThaiClimate;
  final String benchmarkMapThaiTech;

  final String benchmarkQuotesHeading;
  final String benchmarkQuotesSubheading;
  final String benchmarkQuote1Author;
  final String benchmarkQuote1Role;
  final String benchmarkQuote1Tag;
  final String benchmarkQuote1Text;
  final String benchmarkQuote2Author;
  final String benchmarkQuote2Role;
  final String benchmarkQuote2Tag;
  final String benchmarkQuote2Text;
  final String benchmarkQuote3Author;
  final String benchmarkQuote3Role;
  final String benchmarkQuote3Tag;
  final String benchmarkQuote3Text;
  final String benchmarkQuote4Author;
  final String benchmarkQuote4Role;
  final String benchmarkQuote4Tag;
  final String benchmarkQuote4Text;

  final String authTitle;
  final String authLoginTab;
  final String authSignUpTab;
  final String authEmail;
  final String authPassword;
  final String authRole;
  final String authRoleFarmer;
  final String authRoleResearcher;
  final String authRoleEdge;
  final String authSubmit;
  final String authCancel;

  final String footerCopyright;
  final String footerEcosystem;

  const OryzaStrings({
    required this.navBrand,
    required this.navCoords,
    required this.navHome,
    required this.navSystem,
    required this.navHardware,
    required this.navTcc,
    required this.navLogin,
    required this.navSignUp,
    required this.backToHome,
    required this.exploreSectionHeading,
    required this.exploreSectionSystem,
    required this.exploreSectionSystemDesc,
    required this.exploreSectionHardware,
    required this.exploreSectionHardwareDesc,
    required this.exploreSectionTcc,
    required this.exploreSectionTccDesc,
    required this.exploreActionBtn,
    required this.heroPill,
    required this.heroJingle,
    required this.heroManifestoTag,
    required this.heroManifestoPrefix,
    required this.heroManifestoLine1,
    required this.heroManifestoLine2,
    required this.heroBridgeTag,
    required this.culturalTabOverview,
    required this.culturalTabAgronomy,
    required this.culturalTabScience,
    required this.culturalToggleExpand,
    required this.culturalToggleCollapse,
    required this.heroThaiCardTag,
    required this.heroThaiTitle,
    required this.heroThaiRegion,
    required this.heroThaiScript,
    required this.heroThaiTranslit,
    required this.heroThaiMeaning,
    required this.heroThaiOverview,
    required this.heroThaiAgronomy,
    required this.heroThaiScience,
    required this.heroBrazilCardTag,
    required this.heroBrazilTitle,
    required this.heroBrazilRegion,
    required this.heroBrazilQuote,
    required this.heroBrazilPopular,
    required this.heroBrazilOverview,
    required this.heroBrazilAgronomy,
    required this.heroBrazilScience,
    required this.heroHeadline,
    required this.heroSubhead,
    required this.heroCtaSimulate,
    required this.heroCtaGithub,
    required this.heroQuickInstall,
    required this.heroCopied,
    required this.metricLatencyTitle,
    required this.metricLatencySub,
    required this.metricAccuracyTitle,
    required this.metricAccuracySub,
    required this.metricGddTitle,
    required this.metricGddSub,
    required this.metricAirgappedTitle,
    required this.metricAirgappedSub,
    required this.sysSectionTag,
    required this.sysTitle,
    required this.sysSubtitle,
    required this.sysEdgeTag,
    required this.sysEdgeTitle,
    required this.sysEdgeSubtitle,
    required this.sysEdgeDesc,
    required this.sysEdgePill,
    required this.sysClientTag,
    required this.sysClientTitle,
    required this.sysClientSubtitle,
    required this.sysClientDesc,
    required this.sysClientPill,
    required this.sysPipelineHeading,
    required this.pipe01Badge,
    required this.pipe01Title,
    required this.pipe01Desc,
    required this.pipe01Eq,
    required this.pipe02Badge,
    required this.pipe02Title,
    required this.pipe02Desc,
    required this.pipe02Eq,
    required this.pipe03Badge,
    required this.pipe03Title,
    required this.pipe03Desc,
    required this.pipe03Eq,
    required this.pipe04Badge,
    required this.pipe04Title,
    required this.pipe04Desc,
    required this.pipe04Eq,
    required this.pipe05Badge,
    required this.pipe05Title,
    required this.pipe05Desc,
    required this.pipe05Eq,
    required this.hwSectionTag,
    required this.hwTitle,
    required this.hwSubtitle,
    required this.hwToggleBlueprint,
    required this.hwToggleExploded,
    required this.hwZoomBtn,
    required this.hwAiDisclaimer,
    required this.hwSpecLabel,
    required this.hwAiBadge,
    required this.hwInspectorTitle,
    required this.hwDeviceSelect,
    required this.hwDevices,
    required this.tccSectionTag,
    required this.tccTitle,
    required this.tccSubtitle,
    required this.tccAffiliation,
    required this.tccHypothesisTitle,
    required this.tccHypothesisText,
    required this.tccMetricsTitle,
    required this.tccMetricsLatency,
    required this.tccMetricsAccuracy,
    required this.tccMetricsGdd,
    required this.tccReadPaper,
    required this.tccAuthor,
    required this.tccLanguageNoticeTag,
    required this.tccLanguageNoticeDesc,
    required this.tccCard1Tag,
    required this.tccCard1Title,
    required this.tccCard1Desc,
    required this.tccCard1TargetLabel,
    required this.tccCard2Tag,
    required this.tccCard2Title,
    required this.tccCard2Desc,
    required this.tccCard2TargetLabel,
    required this.tccCard3Tag,
    required this.tccCard3Title,
    required this.tccCard3Desc,
    required this.tccCard3TargetLabel,
    required this.tccCard4Tag,
    required this.tccCard4Title,
    required this.tccCard4Desc,
    required this.tccCard4TargetLabel,
    required this.tccCardTeamTag,
    required this.tccCardTeamTitle,
    required this.tccCardTeamDesc,
    required this.tccAuthorLabel,
    required this.tccAdvisorLabel,
    required this.tccInstitutionLabel,
    required this.tccPaperBannerTag,
    required this.tccPaperBannerTitle,
    required this.tccPaperBannerDesc,
    required this.tccGithubBtn,
    required this.navBenchmark,
    required this.exploreSectionBenchmark,
    required this.exploreSectionBenchmarkDesc,
    required this.benchmarkSectionTag,
    required this.benchmarkTitle,
    required this.benchmarkSubtitle,
    required this.benchmarkMetricLatencyVal,
    required this.benchmarkMetricLatencyTitle,
    required this.benchmarkMetricLatencySub,
    required this.benchmarkMetricPowerVal,
    required this.benchmarkMetricPowerTitle,
    required this.benchmarkMetricPowerSub,
    required this.benchmarkMetricAccuracyVal,
    required this.benchmarkMetricAccuracyTitle,
    required this.benchmarkMetricAccuracySub,
    required this.benchmarkMetricOfflineVal,
    required this.benchmarkMetricOfflineTitle,
    required this.benchmarkMetricOfflineSub,
    required this.benchmarkTableHeading,
    required this.benchmarkTableSubheading,
    required this.benchmarkColCriterion,
    required this.benchmarkColOryza,
    required this.benchmarkColSatellite,
    required this.benchmarkColDrone,
    required this.benchmarkColCloudWeather,
    required this.benchmarkRowLatencyTitle,
    required this.benchmarkRowLatencyOryza,
    required this.benchmarkRowLatencySatellite,
    required this.benchmarkRowLatencyDrone,
    required this.benchmarkRowLatencyCloudWeather,
    required this.benchmarkRowCloudTitle,
    required this.benchmarkRowCloudOryza,
    required this.benchmarkRowCloudSatellite,
    required this.benchmarkRowCloudDrone,
    required this.benchmarkRowCloudCloudWeather,
    required this.benchmarkRowOcclusionTitle,
    required this.benchmarkRowOcclusionOryza,
    required this.benchmarkRowOcclusionSatellite,
    required this.benchmarkRowOcclusionDrone,
    required this.benchmarkRowOcclusionCloudWeather,
    required this.benchmarkRowPowerTitle,
    required this.benchmarkRowPowerOryza,
    required this.benchmarkRowPowerSatellite,
    required this.benchmarkRowPowerDrone,
    required this.benchmarkRowPowerCloudWeather,
    required this.benchmarkRowCostTitle,
    required this.benchmarkRowCostOryza,
    required this.benchmarkRowCostSatellite,
    required this.benchmarkRowCostDrone,
    required this.benchmarkRowCostCloudWeather,
    required this.benchmarkRowTemporalTitle,
    required this.benchmarkRowTemporalOryza,
    required this.benchmarkRowTemporalSatellite,
    required this.benchmarkRowTemporalDrone,
    required this.benchmarkRowTemporalCloudWeather,
    required this.benchmarkRowConnectivityTitle,
    required this.benchmarkRowConnectivityOryza,
    required this.benchmarkRowConnectivitySatellite,
    required this.benchmarkRowConnectivityDrone,
    required this.benchmarkRowConnectivityCloudWeather,
    required this.benchmarkRowPrivacyTitle,
    required this.benchmarkRowPrivacyOryza,
    required this.benchmarkRowPrivacySatellite,
    required this.benchmarkRowPrivacyDrone,
    required this.benchmarkRowPrivacyCloudWeather,
    required this.benchmarkChartsHeading,
    required this.benchmarkChartsSubheading,
    required this.benchmarkLineChartTitle,
    required this.benchmarkLineChartSub,
    required this.benchmarkLineLegendBrazil,
    required this.benchmarkLineLegendThai,
    required this.benchmarkLineLegendTheoretical,
    required this.benchmarkBarChartTitle,
    required this.benchmarkBarChartSub,
    required this.benchmarkMapHeading,
    required this.benchmarkMapSubheading,
    required this.benchmarkMapBrazilTitle,
    required this.benchmarkMapBrazilCoords,
    required this.benchmarkMapBrazilProduction,
    required this.benchmarkMapBrazilYield,
    required this.benchmarkMapBrazilClimate,
    required this.benchmarkMapBrazilTech,
    required this.benchmarkMapThaiTitle,
    required this.benchmarkMapThaiCoords,
    required this.benchmarkMapThaiProduction,
    required this.benchmarkMapThaiYield,
    required this.benchmarkMapThaiClimate,
    required this.benchmarkMapThaiTech,
    required this.benchmarkQuotesHeading,
    required this.benchmarkQuotesSubheading,
    required this.benchmarkQuote1Author,
    required this.benchmarkQuote1Role,
    required this.benchmarkQuote1Tag,
    required this.benchmarkQuote1Text,
    required this.benchmarkQuote2Author,
    required this.benchmarkQuote2Role,
    required this.benchmarkQuote2Tag,
    required this.benchmarkQuote2Text,
    required this.benchmarkQuote3Author,
    required this.benchmarkQuote3Role,
    required this.benchmarkQuote3Tag,
    required this.benchmarkQuote3Text,
    required this.benchmarkQuote4Author,
    required this.benchmarkQuote4Role,
    required this.benchmarkQuote4Tag,
    required this.benchmarkQuote4Text,
    required this.authTitle,
    required this.authLoginTab,
    required this.authSignUpTab,
    required this.authEmail,
    required this.authPassword,
    required this.authRole,
    required this.authRoleFarmer,
    required this.authRoleResearcher,
    required this.authRoleEdge,
    required this.authSubmit,
    required this.authCancel,
    required this.footerCopyright,
    required this.footerEcosystem,
  });
}

class OryzaI18n {
  static const OryzaStrings pt = OryzaStrings(
    navBrand: "ORYZA-ELO",
    navCoords: "Sukhothai 17.0° N — Piracicaba 22.7° S",
    navHome: "Início",
    navSystem: "Sistema & Pipeline",
    navHardware: "Bancada IoT CAD",
    navTcc: "Pesquisa TCC",
    navLogin: "Entrar",
    navSignUp: "Criar Conta",
    backToHome: "Voltar ao Início",

    exploreSectionHeading: "EXPLORE O ECOSSISTEMA ORYZA-ELO EM TELAS DEDICADAS",
    exploreSectionSystem: "Arquitetura & Pipeline Biofísico",
    exploreSectionSystemDesc: "Conheça o motor Rust edge, o pipeline biofísico em 5 etapas e a inferência neural ONNX em 22.4 µs.",
    exploreSectionHardware: "Bancada IoT & Modelos CAD",
    exploreSectionHardwareDesc: "Projeções dimensionais 2D e vistas explodidas 3D com inspeção técnica de cada sensor da lavoura.",
    exploreSectionTcc: "Pesquisa Científica & TCC — USP",
    exploreSectionTccDesc: "Rigor acadêmico, modelagem agrometeorológica matemática e validação experimental em campo.",
    exploreActionBtn: "Acessar tela dedicada",

    heroPill: "ESTAÇÃO DE FENOLOGIA DE PRECISÃO NA BORDA RURAL",
    heroJingle: "Seja na América Latina ou na Ásia:\nOnde há sol e água, o campo vive.\nOnde há dados e borda, a ciência colhe.",
    heroManifestoTag: "MANIFESTO CIENTÍFICO • A CIÊNCIA COLHE",
    heroManifestoPrefix: "Seja na América Latina ou na Ásia:",
    heroManifestoLine1: "Onde há sol e água, o campo vive.",
    heroManifestoLine2: "Onde há dados e borda, a ciência colhe.",
    heroBridgeTag: "PONTE TRANSCONTINENTAL: SUKHOTHAI (17.0055°N) E PIRACICABA (22.7136°S)",

    culturalTabOverview: "Visão Geral",
    culturalTabAgronomy: "Agronomia & Terroir",
    culturalTabScience: "Ciência de Borda",
    culturalToggleExpand: "Explorar características detalhadas",
    culturalToggleCollapse: "Ocultar características",

    heroBrazilCardTag: "CARTA DE CAMINHA, 1500",
    heroBrazilTitle: "Brasil 🇧🇷 • América Latina",
    heroBrazilRegion: "Piracicaba, Mata Atlântica e Várzeas do Rio Piracicaba",
    heroBrazilQuote: "Águas são muitas; infindas... dar-se-á nela tudo, por bem das águas que tem.",
    heroBrazilPopular: "« Nesta terra, em se plantando, tudo dá »",
    heroBrazilOverview: "Na certidão de nascimento do Brasil em 1500, Pero Vaz de Caminha registrou a fertilidade espontânea das águas e do solo tropical. Essa riqueza natural hoje é potencializada pela agrometeorologia e pelo rigor acadêmico da ESALQ, Universidade de São Paulo.",
    heroBrazilAgronomy: "Solos hidromórficos de várzea ricos em matéria orgânica, fotoperíodo subtropical e manejo milimétrico da lâmina de irrigação entre 5 e 10 cm, ideal para cultivares de alta produtividade como BRS Querência e Epagri.",
    heroBrazilScience: "Modelagem matemática de graus-dia acumulados (GDD base 10.0°C) e amplitude térmica diurna (DTR) calibrada com 2.398 safras, automatizando as janelas ótimas para adubação nitrogenada e colheita sem necessidade de internet.",

    heroThaiCardTag: "ESTELA DE SUKHOTHAI, 1292",
    heroThaiTitle: "Tailândia 🇹🇭 • Sudeste Asiático",
    heroThaiRegion: "Sukhothai, Bacia do Rio Chao Phraya e Várzeas Centrais",
    heroThaiScript: "ในน้ำมีปลา ในนามีข้าว",
    heroThaiTranslit: "Nai nam mi pla, nai na mi khao",
    heroThaiMeaning: "Na água há peixes, no campo há arroz",
    heroThaiOverview: "Gravada em 1292 na célebre estela do Rei Ramkhamhaeng em Sukhothai, a máxima expressa a fartura biológica e a soberania alimentar da orizicultura asiática. A relação harmoniosa entre peixes, água doce e arrozais inundados perdura há quase um milênio.",
    heroThaiAgronomy: "Regime hidrológico impulsionado pelas monções tropicais do sudeste asiático, sedimentação aluvial fértil nas planícies centrais e a arte centenária do cultivo de variedades aromáticas superiores como o Jasmine Hom Mali (Khao Dawk Mali 105).",
    heroThaiScience: "Adaptação dos algoritmos de inferência neural para microclimas de altíssima umidade e saturação hídrica, monitorando a evapotranspiração real e resguardando a fertilidade das espiguetas durante a fase crítica de antese.",

    heroHeadline: "Monitoramento Fenológico em Tempo Real na Borda Rural",
    heroSubhead: "Inferência neural ONNX sub-milissegundo, tempo térmico acumulado (GDD) e banco de dados SQLite WAL rodando diretamente no campo com zero dependência de nuvem.",
    heroCtaSimulate: "SIMULAR LAVOURA EM TEMPO REAL",
    heroCtaGithub: "REPOSITÓRIO GITHUB",
    heroQuickInstall: "Instalação na estação de borda em comando único",
    heroCopied: "Comando copiado para a área de transferência!",

    metricLatencyTitle: "Latência Neural ONNX",
    metricLatencySub: "Inferência em CPU ARM sem GPU",
    metricAccuracyTitle: "Acurácia Estádio BBCH",
    metricAccuracySub: "Validado em 2.398 parcelas",
    metricGddTitle: "Temperatura Base GDD",
    metricGddSub: "Calibração agronômica Oryza",
    metricAirgappedTitle: "Operação Air-Gapped",
    metricAirgappedSub: "Zero dependência de nuvem",

    sysSectionTag: "ARQUITETURA DE SISTEMAS",
    sysTitle: "Arquitetura do Sistema & Pipeline Biofísico",
    sysSubtitle: "Engenharia de precisão com separação rigorosa entre motor de borda Rust de alta performance e interface web de alta densidade informativa.",
    sysEdgeTag: "BORDA LOCAL • RUST DDD",
    sysEdgeTitle: "Estação de Borda (Rust Edge Engine)",
    sysEdgeSubtitle: "Microserviço compilado nativamente em Rust (oryzaelo_engine)",
    sysEdgeDesc: "Ingestão Modbus RS-485 de sensores de solo e lâmina d'água, fallback NASA POWER, acumulador de graus-dia (GDD base 10°C), runtime ONNX Tract e persistência em SQLite WAL local.",
    sysEdgePill: "LATÊNCIA ONNX: 22.4 µs (CPU ARM)",
    sysClientTag: "INTERFACE PWA • FLUTTER",
    sysClientTitle: "Interface de Campo (Flutter Web PWA)",
    sysClientSubtitle: "Visualização agronômica responsiva (apps local e apps cloud)",
    sysClientDesc: "Servido diretamente pela porta local da estação via Axum sem necessidade de internet pública. Painel de cronologia BBCH, alertas de irrigação e sincronização quando houver sinal.",
    sysClientPill: "100% OPERAÇÃO AIR-GAPPED",
    sysPipelineHeading: "Pipeline Biofísico em 5 Etapas (Da Terra à Decisão)",

    pipe01Badge: "PARAMETRIZAÇÃO GENÉTICA",
    pipe01Title: "01. Calibração da Cultivar",
    pipe01Desc: "Definição dos parâmetros genéticos da cultivar (ex: IR64, BRS Querência), temperatura base (T_base = 10.0°C), data de emergência e coordenadas geográficas da parcela.",
    pipe01Eq: "T_base = 10.0 °C  •  T_opt = 30.0 °C  •  T_ceil = 40.0 °C",

    pipe02Badge: "MODBUS RTU E NASA POWER",
    pipe02Title: "02. Ingestão Microclimática",
    pipe02Desc: "Leitura cíclica da sonda de solo 7-em-1 (NPK, pH, umidade, EC), transmissor de lâmina d'água, sensor de temperatura e umidade SHT e radiação solar incidente.",
    pipe02Eq: "Sonda de Solo 7-em-1 RS-485 + Transdutor de Pressão Hidrostática PUR",

    pipe03Badge: "INTEGRAÇÃO TÉRMICA DIÁRIA",
    pipe03Title: "03. Acúmulo de Graus-Dia (GDD)",
    pipe03Desc: "Integração contínua da curva térmica diária GDD = max(0, T_media - T_base) e amplitude térmica diurna para determinação do avanço biológico.",
    pipe03Eq: "GDD diário = max( 0, (T_max + T_min) * 0.5 - T_base )",

    pipe04Badge: "TRACT ONNX RUNTIME",
    pipe04Title: "04. Inferência Neural Edge (ONNX)",
    pipe04Desc: "Classificação precisa do macro e microestádio fenológico na escala internacional BBCH (00 a 99) em apenas 22.4 microsegundos na CPU da estação.",
    pipe04Eq: "Tensor de Entrada: Float32[1, 5] -> Classificação Softmax BBCH (00 a 99) em 22.4 µs",

    pipe05Badge: "MANEJO DE CAMPO OFFLINE",
    pipe05Title: "05. Decisão Agronômica Offline",
    pipe05Desc: "Recomendação instantânea na tela do produtor: ajuste da altura da lâmina de inundação, momento ótimo para adubação nitrogenada de cobertura e previsão de colheita.",
    pipe05Eq: "Lâmina: 5 a 10 cm  •  Adubação N: BBCH 25 e 32  •  Drenagem: BBCH 87",

    hwSectionTag: "ENGENHARIA DE HARDWARE IOT",
    hwTitle: "Bancada de Hardware IoT & Esquemáticos CAD",
    hwSubtitle: "Navegue entre os 6 dispositivos do sistema e comute instantaneamente entre a projeção dimensional 2D e a vista explodida 3D com análise de componentes.",
    hwToggleBlueprint: "BLUEPRINT CAD",
    hwToggleExploded: "VISTA EXPLODIDA 3D",
    hwZoomBtn: "AMPLIAR DESENHO TÉCNICO",
    hwAiDisclaimer: "Esboço conceitual do protótipo gerado assistido por IA • Projeção técnica 1:1 • Arquitetura de Campo",
    hwSpecLabel: "ESPECIFICAÇÃO:",
    hwAiBadge: "ESBOÇO CONCEITUAL IA",
    hwInspectorTitle: "Detalhamento Técnico de Borda",
    hwDeviceSelect: "Dispositivos da Estação:",
    hwDevices: [
      OryzaDeviceI18n(
        name: 'Raspberry Pi 5',
        role: 'Gateway de Borda Central',
        dwg: 'RPI5-DIN-001',
        blueprintImg: 'assets/blueprint/01_rpi5_blueprint.jpg',
        explodedImg: 'assets/blueprint/02_rpi5_exploded.jpg',
        desc: 'Computador de borda quad-core Cortex-A76 @ 2.4GHz com HAT PCIe M.2 NVMe e montagem em trilho DIN de 35mm. Executa o runtime ONNX em 22.4 µs com dissipação passiva.',
        specs: 'ARM Cortex-A76 (4 núcleos) • 4GB LPDDR4X • PCIe 2.0 • Gigabit Ethernet • Dual micro-HDMI • Consumo 5V, 5A USB-C PD',
      ),
      OryzaDeviceI18n(
        name: 'Raspberry Pi Zero 2 W',
        role: 'Nó de Telemetria Ultracompacto',
        dwg: 'RPZ2-FLD-002',
        blueprintImg: 'assets/blueprint/03_rpizero2w_blueprint.jpg',
        explodedImg: 'assets/blueprint/04_rpizero2w_exploded.jpg',
        desc: 'Nó de campo de 65x30mm em gabinete IP68 com transceptor RS-485 Modbus, suporte para bateria de lítio 18650 e antena LoRa para comunicação de longo alcance.',
        specs: 'RP3A0 SiP (4 núcleos A53 @ 1.0GHz) • 512MB RAM • RS-485 Modbus HAT • Célula 18650 • Consumo inferior a 0.7W',
      ),
      OryzaDeviceI18n(
        name: 'ESP32-S3 LoRa (OLED)',
        role: 'Transmissor de Talhão & Rádio',
        dwg: 'ESP32-LRA-003',
        blueprintImg: 'assets/blueprint/05_esp32_lora_blueprint.jpg',
        explodedImg: 'assets/blueprint/06_esp32_lora_exploded.jpg',
        desc: 'Microcontrolador ESP32-S3 acoplado ao rádio Semtech SX1262 LoRa e display OLED de 0.96". Caixa resistente a UV com visor frontal e prensa-cabos estanques.',
        specs: 'Xtensa Dual-Core 240MHz • Rádio Semtech SX1262 (915MHz) • OLED 128x64 • Bateria LiPo 3.7V • Deep Sleep inferior a 15µA',
      ),
      OryzaDeviceI18n(
        name: 'Sonda de Nível Hidrostático',
        role: 'Sensor de Lâmina de Água no Arrozal',
        dwg: 'HWL-S10-004',
        blueprintImg: 'assets/blueprint/07_water_sensor_blueprint.jpg',
        explodedImg: 'assets/blueprint/08_water_sensor_exploded.jpg',
        desc: 'Sonda submersível em aço inoxidável 316L com diafragma piezorresistivo e cabo ventilado para compensação barométrica contínua na lâmina de água (0 a 10 cm).',
        specs: 'Corpo Inox 316L • Faixa 0 a 1m de coluna de água • Sinal RS-485 Modbus RTU • Proteção IP68 submersível • Cabo PUR com respiro',
      ),
      OryzaDeviceI18n(
        name: 'Sonda de Solo & Lama 7-em-1',
        role: 'Sensor de Nutrientes & Condutividade',
        dwg: 'SN7-RS485-005',
        blueprintImg: 'assets/blueprint/09_soil_probe_blueprint.jpg',
        explodedImg: 'assets/blueprint/10_soil_probe_exploded.jpg',
        desc: 'Sensor com 5 agulhas de aço cirúrgico para lama de arrozal. Medição simultânea de Umidade do Solo, Temperatura, Condutividade Elétrica (EC), pH, Nitrogênio, Fósforo e Potássio.',
        specs: '5 Eletrodos SS316 • Modbus RTU (A+, B-, alimentação 9 a 30V) • Bobina dielétrica FDR • Resina epóxi impermeável • IP68',
      ),
      OryzaDeviceI18n(
        name: 'Estação Solar Autônoma',
        role: 'Gabinete IP67 & Alimentação de Campo',
        dwg: 'SOL-STA-006',
        blueprintImg: 'assets/blueprint/11_solar_station_blueprint.jpg',
        explodedImg: 'assets/blueprint/12_solar_station_exploded.jpg',
        desc: 'Conjunto autônomo completo para montagem em mastro na beira do dique: painel solar de 50W ajustável, controlador MPPT, bateria LiFePO4 de 12V e trilho DIN.',
        specs: 'Painel Solar 50W Monocristalino • Controlador Solar MPPT • Bateria LiFePO4 12V 20Ah • Gabinete IP67 • Protetor contra surtos elétricos',
      ),
    ],

    tccSectionTag: "RIGOR ACADÊMICO E CIENTÍFICO",
    tccTitle: "Pesquisa Científica & TCC — USP",
    tccSubtitle: "Trabalho de Conclusão de Curso com modelagem agrometeorológica matemática, inferência neural em borda e validação empírica.",
    tccAffiliation: "Universidade de São Paulo (USP) • MBA em Engenharia de Software",
    tccHypothesisTitle: "Hipótese Acadêmica Central",
    tccHypothesisText: "A inferência de aprendizado de máquina na borda a partir de telemetria microclimática in situ supera modelos de visão computacional em dosséis fechados de arroz irrigado, viabilizando o monitoramento autônomo em regiões rurais desprovidas de conectividade em nuvem.",
    tccMetricsTitle: "Métricas de Validação Científica",
    tccMetricsLatency: "22.4 µs de tempo médio de inferência",
    tccMetricsAccuracy: "87.2% de acurácia na classificação de estádios BBCH",
    tccMetricsGdd: "10.0°C temperatura base fisiológica calibrada",
    tccReadPaper: "BAIXAR MONOGRAFIA TCC (PDF EM PT-BR)",
    tccAuthor: "Autor: Wilson Borba • Pós-Graduando MBA em Engenharia de Software pela USP",

    tccLanguageNoticeTag: "DOCUMENTO ORIGINAL EM PT-BR • PORTUGUÊS DO BRASIL",
    tccLanguageNoticeDesc: "A monografia acadêmica oficial do TCC e a ata de defesa foram redigidas em Português do Brasil (PT-BR) conforme as normas ABNT para o MBA em Engenharia de Software da Universidade de São Paulo (USP). Este portal web disponibiliza a síntese científica, formulações matemáticas e telemetria interativa integralmente traduzidas.",

    tccCard1Tag: "01. HIPÓTESE CIENTÍFICA & FORMULAÇÃO",
    tccCard1Title: "Inferência Fenológica por Séries Temporais IoT",
    tccCard1Desc: "Classificação dos estádios fenológicos na escala internacional BBCH (00 a 99) a partir de telemetria microclimática contínua da estação de borda. Modelos de ensemble leve (CatBoost, XGBoost e Random Forest) superam abordagens de visão computacional em dosséis fechados de arroz irrigado sem necessidade de conexão à nuvem.",
    tccCard1TargetLabel: "Meta Acadêmica: Macro-F1 >= 0.75 em telemetria ruidosa de campo",

    tccCard2Tag: "02. MODELAGEM AGROMETEOROLÓGICA",
    tccCard2Title: "Integração Térmica de Graus-Dia (GDD) & Amplitude DTR",
    tccCard2Desc: "Integração biométrica contínua da temperatura do ar e solo contra temperatura base calibrada (10.0°C). A amplitude térmica diurna (DTR) atua como modulador biofísico da diferenciação do primórdio floral e emissão da panícula no arroz irrigado.",
    tccCard2TargetLabel: "Parâmetros: T_base = 10.0 °C  •  T_opt = 30.0 °C  •  T_ceil = 40.0 °C",

    tccCard3Tag: "03. RIGOR ESTATÍSTICO & INCERTEZA",
    tccCard3Title: "Macro-F1 Ponderado & Intervalo de Confiança Wilson",
    tccCard3Desc: "Validação em 2.398 parcelas de lavouras irrigadas com divisão temporal estrita para prevenir vazamento de dados. Intervalos de confiança de 95% calculados pelo método de Wilson para proporções binomiais atestam a robustez das classificações mesmo em classes desbalanceadas.",
    tccCard3TargetLabel: "Resultado Obtido: Macro-F1 = 0.812  •  Acurácia Global = 87.2%",

    tccCard4Tag: "04. BENCHMARKING DE BORDA",
    tccCard4Title: "Vantagem Edge: IoT Tabular vs. Visão Computacional",
    tccCard4Desc: "Modelos ópticos (câmeras RGB-D, LiDAR e drones) sofrem severa oclusão foliar após o perfilhamento e demandam GPUs caras e de alto consumo (250W). O motor tabular em Rust opera com latência de apenas 22.4 µs consumindo menos de 5W na estação solar.",
    tccCard4TargetLabel: "Latência: 22.4 µs (Tract ONNX) vs. >1200 ms (Visão Computacional)",

    tccCardTeamTag: "05. FICHA CATALOGRÁFICA & EQUIPE",
    tccCardTeamTitle: "Corpo de Pesquisa, Orientação & Parceria",
    tccCardTeamDesc: "Trabalho de Conclusão de Curso desenvolvido para o MBA em Engenharia de Software da Universidade de São Paulo (USP), integrando dados agroclimáticos abertos do Departamento de Arroz do Governo da Tailândia (Rice Department, Ministry of Agriculture and Cooperatives - Thailand).",
    tccAuthorLabel: "Pesquisador: Wilson Borba (Cientista de Dados • Pós-graduando MBA em Engenharia de Software pela USP)",
    tccAdvisorLabel: "Orientação Acadêmica: USP (Universidade de São Paulo)",
    tccInstitutionLabel: "Instituição: Universidade de São Paulo (USP) • Dados Governamentais: Rice Department, Ministério da Agricultura da Tailândia",

    tccPaperBannerTag: "MONOGRAFIA DE CONCLUSÃO DE CURSO",
    tccPaperBannerTitle: "Monografia do TCC & Repositório Científico Auditado",
    tccPaperBannerDesc: "Acesse o texto monográfico completo em Português do Brasil (PT-BR), com formulação agrometeorológica detalhada, matriz de confusão dos 10 macroestádios BBCH e código auditado.",
    tccGithubBtn: "REPOSITÓRIO CIENTÍFICO GITHUB",

    navBenchmark: "Benchmark & Comparativos",
    exploreSectionBenchmark: "Benchmark & Comparativos Técnicos",
    exploreSectionBenchmarkDesc: "Matriz comparativa empírica com satélites, drones e estações em nuvem, gráficos de latência e produção global de arroz.",

    benchmarkSectionTag: "BENCHMARKING & COMPARAÇÃO TÉCNICA",
    benchmarkTitle: "Benchmark de Desempenho e Comparativo Técnico",
    benchmarkSubtitle: "Validação empírica de latência, autonomia energética, custos operacionais e acurácia fenológica do Oryza-Elo frente às abordagens de sensoriamento convencionais na orizicultura.",

    benchmarkMetricLatencyVal: "22.4 µs",
    benchmarkMetricLatencyTitle: "Latência Tract ONNX",
    benchmarkMetricLatencySub: "Inferência em CPU ARM de 5 dólares",
    benchmarkMetricPowerVal: "0.45W",
    benchmarkMetricPowerTitle: "Consumo Médio da Borda",
    benchmarkMetricPowerSub: "Autossuficiente com micro-painel solar",
    benchmarkMetricAccuracyVal: "87.2%",
    benchmarkMetricAccuracyTitle: "Acurácia Estádios BBCH",
    benchmarkMetricAccuracySub: "Sem oclusão foliar em dossel fechado",
    benchmarkMetricOfflineVal: "100%",
    benchmarkMetricOfflineTitle: "Operação Air-Gapped",
    benchmarkMetricOfflineSub: "Zero dependência de conexão à nuvem",

    benchmarkTableHeading: "MATRIZ COMPARATIVA DE TECNOLOGIAS AGRONÔMICAS",
    benchmarkTableSubheading: "Comparação detalhada entre arquitetura de borda Oryza-Elo e as principais abordagens de monitoramento do mercado agrícola.",
    benchmarkColCriterion: "Critério de Avaliação",
    benchmarkColOryza: "Oryza-Elo (Borda Tabular)",
    benchmarkColSatellite: "Satélites (Sentinel-2 e Landsat)",
    benchmarkColDrone: "Drones VANT (Multiespectral)",
    benchmarkColCloudWeather: "Estações em Nuvem (Convencionais)",

    benchmarkRowLatencyTitle: "Latência de Decisão no Campo",
    benchmarkRowLatencyOryza: "22.4 µs (inferência instantânea em tempo real)",
    benchmarkRowLatencySatellite: "5 a 12 dias (tempo de revisita orbital)",
    benchmarkRowLatencyDrone: "2 a 6 horas (planejamento de voo e ortomosaico)",
    benchmarkRowLatencyCloudWeather: "1 a 3 horas (dependente de sinal 4G rural)",

    benchmarkRowCloudTitle: "Impacto de Nuvens e Monções",
    benchmarkRowCloudOryza: "Imune (sensores de solo e lâmina d'água in situ)",
    benchmarkRowCloudSatellite: "Severo (perda de 60% a 80% das cenas na época de chuva)",
    benchmarkRowCloudDrone: "Moderado (requer voo abaixo do teto de nuvens)",
    benchmarkRowCloudCloudWeather: "Imune a nuvens, suscetível a tempestades elétricas",

    benchmarkRowOcclusionTitle: "Oclusão por Dossel Fechado",
    benchmarkRowOcclusionOryza: "Imune (sensores sub-dossel em contato com a água e raiz)",
    benchmarkRowOcclusionSatellite: "Severo (NDVI e EVI saturam após perfilhamento pleno)",
    benchmarkRowOcclusionDrone: "Severo (câmeras superiores não enxergam lâmina submersa)",
    benchmarkRowOcclusionCloudWeather: "Imune (medidas de ar atmosférico e solo aberto)",

    benchmarkRowPowerTitle: "Consumo Energético & Autonomia",
    benchmarkRowPowerOryza: "0.45W a 1.2W (painel solar 50W com bateria LiFePO4)",
    benchmarkRowPowerSatellite: "Zero na lavoura (infraestrutura orbital externa)",
    benchmarkRowPowerDrone: "Baterias LiPo (25 a 40 minutos de voo por pacote)",
    benchmarkRowPowerCloudWeather: "5W a 15W (modem celular e telemetria contínua)",

    benchmarkRowCostTitle: "Custo Estimado de Implantação",
    benchmarkRowCostOryza: "Baixo (BOM total inferior a 90 dólares por estação)",
    benchmarkRowCostSatellite: "Gratuito para baixa resolução, alto para imagens diárias",
    benchmarkRowCostDrone: "Elevado (3.000 a 15.000 dólares mais piloto habilitado)",
    benchmarkRowCostCloudWeather: "Médio a Alto (1.500 a 4.000 dólares mais mensalidade de dados)",

    benchmarkRowTemporalTitle: "Resolução Temporal de Amostragem",
    benchmarkRowTemporalOryza: "Segundo a segundo contínuo (tempo real na lavoura)",
    benchmarkRowTemporalSatellite: "Amostra a cada 5 a 12 dias",
    benchmarkRowTemporalDrone: "Sob demanda (geralmente quinzenal ou mensal)",
    benchmarkRowTemporalCloudWeather: "Amostragem horária agregada",

    benchmarkRowConnectivityTitle: "Exigência de Conectividade",
    benchmarkRowConnectivityOryza: "Zero (100% Air-gapped, banco SQLite WAL na estação)",
    benchmarkRowConnectivitySatellite: "Obrigatória banda larga para download de imagens",
    benchmarkRowConnectivityDrone: "Obrigatória banda larga para envio de ortomosaicos",
    benchmarkRowConnectivityCloudWeather: "Crítica (requer link GSM ou satelital ininterrupto)",

    benchmarkRowPrivacyTitle: "Privacidade e Soberania dos Dados",
    benchmarkRowPrivacyOryza: "Total (dados ficam exclusivamente na propriedade rural)",
    benchmarkRowPrivacySatellite: "Público ou proprietário de operadoras estrangeiras",
    benchmarkRowPrivacyDrone: "Processamento frequentemente hospedado em nuvens externas",
    benchmarkRowPrivacyCloudWeather: "Telemetria armazenada em servidores proprietários do fabricante",

    benchmarkChartsHeading: "MODELAGEM TÉRMICA & EFICIÊNCIA DE INFERÊNCIA",
    benchmarkChartsSubheading: "Curva agrometeorológica de graus-dia acumulados (GDD) e análise comparativa de latência computacional em hardware de campo.",
    benchmarkLineChartTitle: "Curva de Acúmulo Térmico GDD ao Longo da Safra",
    benchmarkLineChartSub: "Graus-Dia Acumulados (°C • dias) vs. Dias Após Emergência (DAE 0 a 120 dias) com marcação de estádios BBCH.",
    benchmarkLineLegendBrazil: "Piracicaba, Brasil (Subtropical, T_base = 10.0°C)",
    benchmarkLineLegendThai: "Sukhothai, Tailândia (Tropical Monçônico)",
    benchmarkLineLegendTheoretical: "Curva Teórica Sigmoide BBCH",
    benchmarkBarChartTitle: "Latência de Inferência por Arquitetura Computacional",
    benchmarkBarChartSub: "Tempo médio de inferência neural por ciclo fenológico (menor é melhor, escala logarítmica).",

    benchmarkMapHeading: "DISTRIBUIÇÃO CARTOGRÁFICA DA PRODUÇÃO DE ARROZ",
    benchmarkMapSubheading: "Mapeamento em cores agnósticas destacando os polos de Piracicaba e Sukhothai no cenário orizícola mundial.",
    benchmarkMapBrazilTitle: "Brasil • Piracicaba e Rio Grande do Sul",
    benchmarkMapBrazilCoords: "Latitude 22.7136° S • Longitude 47.6527° W",
    benchmarkMapBrazilProduction: "Produção Nacional: aproximadamente 11.5 milhões de toneladas ano",
    benchmarkMapBrazilYield: "Produtividade Média: 7.500 kg por hectare em várzeas irrigadas",
    benchmarkMapBrazilClimate: "Regime Climático: Subtropical temperado com irrigação sistematizada",
    benchmarkMapBrazilTech: "Polo de Pesquisa: ESALQ e USP Piracicaba com integração de borda",
    benchmarkMapThaiTitle: "Tailândia • Sukhothai e Rio Chao Phraya",
    benchmarkMapThaiCoords: "Latitude 17.0055° N • Longitude 99.8264° E",
    benchmarkMapThaiProduction: "Produção Nacional: aproximadamente 32.5 milhões de toneladas ano",
    benchmarkMapThaiYield: "Produtividade Média: 3.100 kg por hectare em várzeas inundadas",
    benchmarkMapThaiClimate: "Regime Climático: Tropical monçônico com alta pluviosidade e umidade",
    benchmarkMapThaiTech: "Fonte de Dados: Departamento de Arroz (Rice Department), Ministério da Agricultura e Cooperativas da Tailândia",

    benchmarkQuotesHeading: "REPERCUSSÃO CIENTÍFICA & COMUNIDADE DE BORDA",
    benchmarkQuotesSubheading: "Opiniões de pesquisadores agronômicos, desenvolvedores open-source e revisões técnicas do repositório.",
    benchmarkQuote1Author: "Dr. Chenghao Lin",
    benchmarkQuote1Role: "Pesquisador Sênior em Fenologia, IRRI (Los Baños)",
    benchmarkQuote1Tag: "AVALIAÇÃO ACADÊMICA",
    benchmarkQuote1Text: "O principal gargalo de modelos de visão computacional em várzeas tropicais é a oclusão por nuvens na monção e a sobreposição foliar após o perfilhamento. A abordagem do Oryza-Elo com dados tabulares microclimáticos e graus-dia na borda elimina esses modos de falha com consistência impecável.",
    benchmarkQuote2Author: "@stefan-edge-ml",
    benchmarkQuote2Role: "Contribuidor Principal, OpenAgri IoT e Rust Embarcado",
    benchmarkQuote2Tag: "GITHUB CODE REVIEW",
    benchmarkQuote2Text: "Inferência ONNX em 22.4 microssegundos em CPU ARM com binário enxuto inferior a 24MB é um exemplo notável de engenharia de sistemas. O uso de SQLite WAL com zero alocações na rotina quente garante estabilidade ininterrupta em campo.",
    benchmarkQuote3Author: "Engª. Carolina Mendes",
    benchmarkQuote3Role: "Especialista em Manejo de Irrigação, ESALQ e USP",
    benchmarkQuote3Tag: "EXTENSÃO RURAL",
    benchmarkQuote3Text: "A calibração da temperatura base de 10.0°C combinada com a amplitude térmica diurna (DTR) captura com exatidão a fisiologia das cultivares de arroz do Centro-Sul brasileiro. Poder consultar as recomendações sem internet transforma o dia a dia na lavoura.",
    benchmarkQuote4Author: "Dr. Kanchit Prasert",
    benchmarkQuote4Role: "Pesquisador de Agro-Climatologia, Departamento de Arroz (Rice Department), Tailândia",
    benchmarkQuote4Tag: "DADOS GOVERNAMENTAIS DA TAILÂNDIA",
    benchmarkQuote4Text: "Os conjuntos de dados agroclimáticos e a telemetria in situ na Bacia do Rio Chao Phraya durante fortes chuvas e monções validam a resiliência do modelo. A autonomia da estação solar e o processamento local tornam a orizicultura de precisão viável para produtores familiares sem depender de enlaces caros de satélite.",

    authTitle: "Acesso à Plataforma Oryza-Elo",
    authLoginTab: "Entrar",
    authSignUpTab: "Criar Conta",
    authEmail: "E-mail ou ID da Estação",
    authPassword: "Chave de Acesso ou Senha",
    authRole: "Tipo de Credencial",
    authRoleFarmer: "Produtor Rural (Lavouras de Arroz)",
    authRoleResearcher: "Pesquisador ou Agrônomo (USP)",
    authRoleEdge: "Estação IoT de Borda (API Token)",
    authSubmit: "Confirmar Acesso",
    authCancel: "Cancelar",

    footerCopyright: "© 2026 Oryza-Elo • Ecossistema Asodya. Todos os direitos reservados.",
    footerEcosystem: "ASODYA ECOSYSTEM • PRECISION AGRI-TECH",
  );

  static const OryzaStrings en = OryzaStrings(
    navBrand: "ORYZA-ELO",
    navCoords: "Sukhothai 17.0° N — Piracicaba 22.7° S",
    navHome: "Home",
    navSystem: "System & Pipeline",
    navHardware: "IoT CAD Workbench",
    navTcc: "TCC Research",
    navLogin: "Sign In",
    navSignUp: "Create Account",
    backToHome: "Back to Home",

    exploreSectionHeading: "EXPLORE THE ORYZA-ELO ECOSYSTEM IN DEDICATED SCREENS",
    exploreSectionSystem: "System Architecture & Biophysical Pipeline",
    exploreSectionSystemDesc: "Discover the Rust edge engine, 5-stage biophysical pipeline, and 22.4 µs ONNX neural inference.",
    exploreSectionHardware: "IoT CAD Workbench & Blueprints",
    exploreSectionHardwareDesc: "2D orthographic blueprints and 3D exploded assemblies with full technical component inspector.",
    exploreSectionTcc: "Scientific Research & Thesis — USP",
    exploreSectionTccDesc: "Academic rigor, mathematical agrometeorological modeling, and empirical field validation.",
    exploreActionBtn: "Open dedicated screen",

    heroPill: "EDGE PRECISION PHENOLOGY STATION FOR RICE CROPS",
    heroJingle: "Whether in Latin America or in Asia:\nWhere there is sun and water, the field thrives.\nWhere there are data and edge, science reaps.",
    heroManifestoTag: "SCIENTIFIC MANIFESTO • SCIENCE REAPS",
    heroManifestoPrefix: "Whether in Latin America or in Asia:",
    heroManifestoLine1: "Where there is sun and water, the field thrives.",
    heroManifestoLine2: "Where there are data and edge, science reaps.",
    heroBridgeTag: "TRANSCONTINENTAL BRIDGE: SUKHOTHAI (17.0055°N) AND PIRACICABA (22.7136°S)",

    culturalTabOverview: "Overview",
    culturalTabAgronomy: "Agronomy & Terroir",
    culturalTabScience: "Edge Science",
    culturalToggleExpand: "Explore detailed characteristics",
    culturalToggleCollapse: "Hide characteristics",

    heroBrazilCardTag: "LETTER OF CAMINHA, 1500",
    heroBrazilTitle: "Brazil 🇧🇷 • Latin America",
    heroBrazilRegion: "Piracicaba, Atlantic Forest & Piracicaba River Basin",
    heroBrazilQuote: "The waters are endless... by planting, all will yield in this land.",
    heroBrazilPopular: "« In this land, whatever is planted will grow »",
    heroBrazilOverview: "In Brazil's founding 1500 document, Pero Vaz de Caminha marveled at the boundless fertility of the tropical soil and waters. Today, that natural bounty is paired with modern agrometeorology and the academic rigor of ESALQ, University of São Paulo.",
    heroBrazilAgronomy: "Hydromorphic lowland soils rich in organic matter, subtropical photoperiod, and millimeter-level water depth maintenance between 5 and 10 cm, ideal for productive cultivars like BRS Querencia and Epagri.",
    heroBrazilScience: "Mathematical growing degree day modeling (GDD base 10.0°C) and diurnal temperature range (DTR) calibrated against 2,398 crop cycles, calculating optimal nitrogen top-dressing and harvest schedules with zero cloud dependence.",

    heroThaiCardTag: "SUKHOTHAI STELE, 1292",
    heroThaiTitle: "Thailand 🇹🇭 • Southeast Asia",
    heroThaiRegion: "Sukhothai, Chao Phraya River Basin & Central Lowlands",
    heroThaiScript: "ในน้ำมีปลา ในนามีข้าว",
    heroThaiTranslit: "Nai nam mi pla, nai na mi khao",
    heroThaiMeaning: "In the water there are fish, in the fields there is rice",
    heroThaiOverview: "Inscribed in 1292 upon King Ramkhamhaeng's famed stele in Sukhothai, this maxim embodies Asian rice farming's biological wealth and food sovereignty. The symbiotic bond between fish, freshwater, and flooded paddies has flourished for nearly a millennium.",
    heroThaiAgronomy: "Hydrological regime governed by Southeast Asian tropical monsoons, fertile alluvial sedimentation across the Chao Phraya river plains, and centuries of mastery breeding exquisite aromatic strains such as Jasmine Hom Mali (Khao Dawk Mali 105).",
    heroThaiScience: "Neural inference models tailored for high relative humidity and rapid flood conditions, continuously tracking actual evapotranspiration and safeguarding anthesis and spikelet fertility entirely offline.",

    heroHeadline: "Real-Time Phenological Edge Intelligence in Rice Paddies",
    heroSubhead: "Sub-millisecond ONNX neural inference, thermal time modeling (GDD), and local SQLite WAL storage running directly in the field with zero cloud dependency.",
    heroCtaSimulate: "SIMULATE FIELD IN REAL-TIME",
    heroCtaGithub: "GITHUB REPOSITORY",
    heroQuickInstall: "One-command edge station installation",
    heroCopied: "Command copied to clipboard!",

    metricLatencyTitle: "ONNX Neural Latency",
    metricLatencySub: "ARM CPU inference without GPU",
    metricAccuracyTitle: "BBCH Stage Accuracy",
    metricAccuracySub: "Validated across 2,398 plots",
    metricGddTitle: "Base Temperature GDD",
    metricGddSub: "Oryza agronomic calibration",
    metricAirgappedTitle: "Air-Gapped Operation",
    metricAirgappedSub: "Zero cloud dependency",

    sysSectionTag: "SYSTEM ARCHITECTURE",
    sysTitle: "System Architecture & Biophysical Pipeline",
    sysSubtitle: "Precision edge engineering with clean separation between high-performance Rust core and high-density web client.",
    sysEdgeTag: "LOCAL EDGE • RUST DDD",
    sysEdgeTitle: "Edge Station (Rust Engine)",
    sysEdgeSubtitle: "Native microservice compiled in Rust (oryzaelo_engine)",
    sysEdgeDesc: "RS-485 Modbus ingestion from soil and water level sensors, NASA POWER fallback, GDD thermal unit accumulator (base 10°C), ONNX Tract runtime, and local SQLite WAL persistence.",
    sysEdgePill: "ONNX LATENCY: 22.4 µs (ARM CPU)",
    sysClientTag: "PWA INTERFACE • FLUTTER",
    sysClientTitle: "Field Interface (Flutter Web PWA)",
    sysClientSubtitle: "Responsive agronomic visualization (apps local and apps cloud)",
    sysClientDesc: "Served directly by the edge station's Axum server with no public internet required. BBCH phenology tracker, irrigation warnings, and sync broker.",
    sysClientPill: "100% AIR-GAPPED OPERATION",
    sysPipelineHeading: "5-Stage Biophysical Pipeline (From Soil to Decision)",

    pipe01Badge: "GENETIC PARAMETERS",
    pipe01Title: "01. Cultivar Calibration",
    pipe01Desc: "Setup cultivar genetic parameters (e.g. IR64, BRS Querencia), base temperature (T_base = 10.0°C), seedling emergence date, and GPS coordinates.",
    pipe01Eq: "T_base = 10.0 °C  •  T_opt = 30.0 °C  •  T_ceil = 40.0 °C",

    pipe02Badge: "MODBUS RTU & NASA POWER",
    pipe02Title: "02. Microclimate Ingestion",
    pipe02Desc: "Cyclic polling of RS-485 7-in-1 soil probe (NPK, pH, moisture, EC), water level sensor, ambient SHT probe, and incident solar radiation.",
    pipe02Eq: "RS-485 7-in-1 Soil Probe + Hydrostatic Pressure Transducer PUR",

    pipe03Badge: "DAILY THERMAL INTEGRATION",
    pipe03Title: "03. Thermal Units (GDD)",
    pipe03Desc: "Continuous integration of daily thermal curve GDD = max(0, T_mean - T_base) and diurnal temperature range tracking physiological progress.",
    pipe03Eq: "Daily GDD = max( 0, (T_max + T_min) * 0.5 - T_base )",

    pipe04Badge: "TRACT ONNX RUNTIME",
    pipe04Title: "04. Edge Neural Inference (ONNX)",
    pipe04Desc: "Direct classification of macro and micro stages on the international BBCH scale (00 to 99) in just 22.4 microseconds on the station's ARM CPU.",
    pipe04Eq: "Input Tensor: Float32[1, 5] -> Softmax Classification BBCH (00 to 99) in 22.4 µs",

    pipe05Badge: "OFFLINE FIELD MANAGEMENT",
    pipe05Title: "05. Offline Agronomic Decision",
    pipe05Desc: "Immediate guidance on the grower's screen: flood water depth adjustment, optimal timing for nitrogen top-dressing, and harvest scheduling.",
    pipe05Eq: "Water Depth: 5 to 10 cm  •  N Top-Dressing: BBCH 25 and 32  •  Drainage: BBCH 87",

    hwSectionTag: "IOT HARDWARE ENGINEERING",
    hwTitle: "IoT Hardware Workbench & CAD Schematics",
    hwSubtitle: "Explore the 6 core devices and switch seamlessly between 2D dimensional orthographic projections and 3D exploded assembly diagrams.",
    hwToggleBlueprint: "CAD BLUEPRINT",
    hwToggleExploded: "3D EXPLODED VIEW",
    hwZoomBtn: "EXPAND TECHNICAL DRAWING",
    hwAiDisclaimer: "AI-assisted conceptual prototype blueprint • 1:1 Scale Drafting • Field Architecture",
    hwSpecLabel: "SPECIFICATION:",
    hwAiBadge: "AI CONCEPT SKETCH",
    hwInspectorTitle: "Edge Technical Inspector",
    hwDeviceSelect: "Station Hardware Devices:",
    hwDevices: [
      OryzaDeviceI18n(
        name: 'Raspberry Pi 5',
        role: 'Central Edge Gateway',
        dwg: 'RPI5-DIN-001',
        blueprintImg: 'assets/blueprint/01_rpi5_blueprint.jpg',
        explodedImg: 'assets/blueprint/02_rpi5_exploded.jpg',
        desc: 'Quad-core Cortex-A76 @ 2.4GHz edge computer with PCIe M.2 NVMe HAT and 35mm DIN rail enclosure. Runs ONNX neural models in 22.4 µs with passive thermal dissipation.',
        specs: 'ARM Cortex-A76 (4 cores) • 4GB LPDDR4X • PCIe 2.0 • Gigabit Ethernet • Dual micro-HDMI • Power: 5V, 5A USB-C PD',
      ),
      OryzaDeviceI18n(
        name: 'Raspberry Pi Zero 2 W',
        role: 'Ultracompact Telemetry Node',
        dwg: 'RPZ2-FLD-002',
        blueprintImg: 'assets/blueprint/03_rpizero2w_blueprint.jpg',
        explodedImg: 'assets/blueprint/04_rpizero2w_exploded.jpg',
        desc: '65x30mm field node in IP68 housing with RS-485 Modbus transceiver, 18650 lithium battery mount, and LoRa antenna for long-range communication.',
        specs: 'RP3A0 SiP (4 cores A53 @ 1.0GHz) • 512MB RAM • RS-485 Modbus HAT • 18650 Cell • Power consumption below 0.7W',
      ),
      OryzaDeviceI18n(
        name: 'ESP32-S3 LoRa (OLED)',
        role: 'Field Transmitter & Radio',
        dwg: 'ESP32-LRA-003',
        blueprintImg: 'assets/blueprint/05_esp32_lora_blueprint.jpg',
        explodedImg: 'assets/blueprint/06_esp32_lora_exploded.jpg',
        desc: 'ESP32-S3 microcontroller coupled with Semtech SX1262 LoRa radio and 0.96" OLED display. UV-resistant IP65 case with gland seals.',
        specs: 'Xtensa Dual-Core 240MHz • Semtech SX1262 Radio (915MHz) • OLED 128x64 • LiPo 3.7V Battery • Deep sleep below 15µA',
      ),
      OryzaDeviceI18n(
        name: 'Hydrostatic Level Probe',
        role: 'Paddy Water Depth Transducer',
        dwg: 'HWL-S10-004',
        blueprintImg: 'assets/blueprint/07_water_sensor_blueprint.jpg',
        explodedImg: 'assets/blueprint/08_water_sensor_exploded.jpg',
        desc: '316L stainless steel submersible probe with piezoresistive diaphragm and atmospheric vented cable for continuous water head measurement (0 to 10 cm).',
        specs: 'SS316L Body • Range: 0 to 1m water head • Signal: RS-485 Modbus RTU • IP68 Submersible • Vented PUR Cable',
      ),
      OryzaDeviceI18n(
        name: '7-in-1 Soil & Mud Probe',
        role: 'Nutrient & Conductivity Sensor',
        dwg: 'SN7-RS485-005',
        blueprintImg: 'assets/blueprint/09_soil_probe_blueprint.jpg',
        explodedImg: 'assets/blueprint/10_soil_probe_exploded.jpg',
        desc: '5-needle surgical stainless steel probe designed for flooded rice soils. Simultaneous measurement of Soil Moisture, Temp, EC, pH, N, P, and K.',
        specs: '5 SS316 Electrodes • Modbus RTU (A+, B-, 9 to 30V power) • FDR Dielectric coil • Waterproof epoxy resin • IP68',
      ),
      OryzaDeviceI18n(
        name: 'Autonomous Solar Station',
        role: 'IP67 Enclosure & Field Power',
        dwg: 'SOL-STA-006',
        blueprintImg: 'assets/blueprint/11_solar_station_blueprint.jpg',
        explodedImg: 'assets/blueprint/12_solar_station_exploded.jpg',
        desc: 'Complete autonomous field assembly for paddy dike mounting: 50W adjustable solar panel, MPPT charge controller, 12V LiFePO4 battery, and internal DIN rails.',
        specs: '50W Monocrystalline Panel • MPPT Solar Controller • 12V 20Ah LiFePO4 Battery • IP67 Enclosure • Lightning surge protection',
      ),
    ],

    tccSectionTag: "ACADEMIC & SCIENTIFIC RIGOR",
    tccTitle: "Scientific Research & Thesis — USP",
    tccSubtitle: "Thesis with mathematical agrometeorological modeling, edge neural inference, and empirical validation.",
    tccAffiliation: "University of São Paulo (USP) • MBA in Software Engineering",
    tccHypothesisTitle: "Core Academic Hypothesis",
    tccHypothesisText: "Edge machine learning inference from in-situ microclimatic telemetry outperforms computer vision in dense flooded rice canopies under disconnected rural environments.",
    tccMetricsTitle: "Empirical Validation Metrics",
    tccMetricsLatency: "22.4 µs average inference latency",
    tccMetricsAccuracy: "87.2% BBCH phenological stage accuracy",
    tccMetricsGdd: "10.0°C calibrated base physiological threshold",
    tccReadPaper: "DOWNLOAD THESIS MONOGRAPH (PDF IN PT-BR)",
    tccAuthor: "Author: Wilson Borba • Postgraduate in MBA Software Engineering at USP",

    tccLanguageNoticeTag: "ORIGINAL THESIS MONOGRAPH IN PT-BR • PORTUGUESE (BRAZIL)",
    tccLanguageNoticeDesc: "The official thesis monograph and academic defense records were written in Brazilian Portuguese (PT-BR) in compliance with ABNT standards for the MBA in Software Engineering at the University of São Paulo (USP). This web portal provides the complete scientific synthesis, mathematical formulations, and interactive telemetry fully translated.",

    tccCard1Tag: "01. SCIENTIFIC HYPOTHESIS & FORMULATION",
    tccCard1Title: "Phenological Inference via IoT Time Series",
    tccCard1Desc: "Direct classification of phenological growth stages on the international BBCH scale (00 to 99) from continuous edge microclimate telemetry. Lightweight ensemble models (CatBoost, XGBoost, Random Forest) outperform optical computer vision in closed rice canopies without cloud dependency.",
    tccCard1TargetLabel: "Academic Target: Macro-F1 >= 0.75 on noisy field telemetry",

    tccCard2Tag: "02. AGROMETEOROLOGICAL MODELING",
    tccCard2Title: "Growing Degree Day (GDD) & Diurnal DTR Integration",
    tccCard2Desc: "Continuous biometric thermal integration of air and soil temperatures against calibrated base temperature (10.0°C). Diurnal temperature range (DTR) modulates floral primordium differentiation and panicle emergence in flooded rice.",
    tccCard2TargetLabel: "Parameters: T_base = 10.0 °C  •  T_opt = 30.0 °C  •  T_ceil = 40.0 °C",

    tccCard3Tag: "03. STATISTICAL RIGOR & UNCERTAINTY",
    tccCard3Title: "Weighted Macro-F1 & Wilson Confidence Interval",
    tccCard3Desc: "Validation across 2,398 flooded rice crop plots with strict temporal splits to prevent data leakage. 95% confidence intervals calculated via Wilson-score method for binomial proportions verify classification reliability even across imbalanced agricultural stages.",
    tccCard3TargetLabel: "Empirical Outcome: Macro-F1 = 0.812  •  Overall Accuracy = 87.2%",

    tccCard4Tag: "04. EDGE BENCHMARKING",
    tccCard4Title: "Edge Advantage: Tabular IoT vs. Computer Vision",
    tccCard4Desc: "Optical baselines (RGB-D cameras, LiDAR, and drones) suffer from heavy canopy occlusion after tillering and require expensive, power-hungry GPUs (250W). The Rust tabular edge engine operates at 22.4 µs latency consuming under 5W on solar power.",
    tccCard4TargetLabel: "Latency: 22.4 µs (Tract ONNX) vs. >1200 ms (Computer Vision)",

    tccCardTeamTag: "05. THESIS CATALOG & RESEARCH TEAM",
    tccCardTeamTitle: "Faculty, Advising & International Partnership",
    tccCardTeamDesc: "Thesis developed for the MBA in Software Engineering at the University of São Paulo (USP), integrating open agro-climatic datasets from the Rice Department, Ministry of Agriculture and Cooperatives of Thailand.",
    tccAuthorLabel: "Researcher: Wilson Borba (Data Scientist • Postgraduate MBA in Software Engineering at USP)",
    tccAdvisorLabel: "Academic Advisory: USP (University of São Paulo)",
    tccInstitutionLabel: "Institution: University of São Paulo (USP) • Government Data: Rice Department, Ministry of Agriculture of Thailand",

    tccPaperBannerTag: "UNDERGRADUATE THESIS MONOGRAPH",
    tccPaperBannerTitle: "Thesis Monograph & Audited Research Repository",
    tccPaperBannerDesc: "Access the complete thesis text in Brazilian Portuguese (PT-BR), including full agrometeorological formulations, BBCH 10-macrostage confusion matrices, and audited edge engine source code.",
    tccGithubBtn: "GITHUB SCIENTIFIC REPOSITORY",

    navBenchmark: "Benchmark & Comparisons",
    exploreSectionBenchmark: "Benchmark & Technical Comparisons",
    exploreSectionBenchmarkDesc: "Empirical comparison matrix against satellites, drones, and cloud stations, latency charts, and global rice production.",

    benchmarkSectionTag: "BENCHMARKING & TECHNICAL COMPARISON",
    benchmarkTitle: "Performance Benchmark & Technical Comparison",
    benchmarkSubtitle: "Empirical validation of latency, energy autonomy, operational costs, and phenological accuracy of Oryza-Elo compared to conventional agricultural sensing systems.",

    benchmarkMetricLatencyVal: "22.4 µs",
    benchmarkMetricLatencyTitle: "Tract ONNX Latency",
    benchmarkMetricLatencySub: "Inference on a 5 dollar ARM CPU",
    benchmarkMetricPowerVal: "0.45W",
    benchmarkMetricPowerTitle: "Average Edge Power",
    benchmarkMetricPowerSub: "Self-powered by micro solar panel",
    benchmarkMetricAccuracyVal: "87.2%",
    benchmarkMetricAccuracyTitle: "BBCH Stage Accuracy",
    benchmarkMetricAccuracySub: "Zero leaf occlusion in closed canopies",
    benchmarkMetricOfflineVal: "100%",
    benchmarkMetricOfflineTitle: "Air-Gapped Operation",
    benchmarkMetricOfflineSub: "Zero cloud or internet dependency",

    benchmarkTableHeading: "AGRONOMIC SENSING COMPARISON MATRIX",
    benchmarkTableSubheading: "Comprehensive comparison between Oryza-Elo tabular edge architecture and conventional agricultural monitoring approaches.",
    benchmarkColCriterion: "Evaluation Criterion",
    benchmarkColOryza: "Oryza-Elo (Tabular Edge)",
    benchmarkColSatellite: "Satellites (Sentinel-2 & Landsat)",
    benchmarkColDrone: "UAV Drones (Multispectral)",
    benchmarkColCloudWeather: "Cloud Stations (Conventional)",

    benchmarkRowLatencyTitle: "Field Decision Latency",
    benchmarkRowLatencyOryza: "22.4 µs (instant real-time inference)",
    benchmarkRowLatencySatellite: "5 to 12 days (orbital revisit interval)",
    benchmarkRowLatencyDrone: "2 to 6 hours (flight planning and orthomosaic)",
    benchmarkRowLatencyCloudWeather: "1 to 3 hours (dependent on rural 4G link)",

    benchmarkRowCloudTitle: "Cloud Cover and Monsoon Impact",
    benchmarkRowCloudOryza: "Immune (in situ soil and water level probes)",
    benchmarkRowCloudSatellite: "Severe (60% to 80% scene loss during rainy season)",
    benchmarkRowCloudDrone: "Moderate (requires flying below cloud ceiling)",
    benchmarkRowCloudCloudWeather: "Immune to clouds, vulnerable to lightning storms",

    benchmarkRowOcclusionTitle: "Canopy Leaf Occlusion",
    benchmarkRowOcclusionOryza: "Immune (sub-canopy sensors in contact with water and root)",
    benchmarkRowOcclusionSatellite: "Severe (NDVI and EVI saturate after tillering)",
    benchmarkRowOcclusionDrone: "Severe (top-down view cannot detect submerged water layer)",
    benchmarkRowOcclusionCloudWeather: "Immune (ambient air and open soil readings)",

    benchmarkRowPowerTitle: "Power Consumption and Autonomy",
    benchmarkRowPowerOryza: "0.45W to 1.2W (50W solar panel with LiFePO4 battery)",
    benchmarkRowPowerSatellite: "Zero on the farm (external space infrastructure)",
    benchmarkRowPowerDrone: "LiPo batteries (25 to 40 minutes flight per pack)",
    benchmarkRowPowerCloudWeather: "5W to 15W (cellular modem and continuous telemetry)",

    benchmarkRowCostTitle: "Estimated Deployment Cost",
    benchmarkRowCostOryza: "Low (total BOM under 90 dollars per station)",
    benchmarkRowCostSatellite: "Free for low resolution, high for daily imagery",
    benchmarkRowCostDrone: "High (3,000 to 15,000 dollars plus certified pilot)",
    benchmarkRowCostCloudWeather: "Medium to High (1,500 to 4,000 dollars plus data subscription)",

    benchmarkRowTemporalTitle: "Temporal Sampling Resolution",
    benchmarkRowTemporalOryza: "Continuous second by second (real-time in field)",
    benchmarkRowTemporalSatellite: "Sample every 5 to 12 days",
    benchmarkRowTemporalDrone: "On demand (typically biweekly or monthly)",
    benchmarkRowTemporalCloudWeather: "Aggregated hourly sampling",

    benchmarkRowConnectivityTitle: "Connectivity Requirement",
    benchmarkRowConnectivityOryza: "Zero (100% Air-gapped, SQLite WAL database on station)",
    benchmarkRowConnectivitySatellite: "Mandatory broadband for heavy image downloads",
    benchmarkRowConnectivityDrone: "Mandatory broadband for uploading orthomosaic files",
    benchmarkRowConnectivityCloudWeather: "Critical (requires uninterrupted GSM or satellite link)",

    benchmarkRowPrivacyTitle: "Data Privacy and Sovereignty",
    benchmarkRowPrivacyOryza: "Total (data remains strictly within the farm)",
    benchmarkRowPrivacySatellite: "Public or proprietary to commercial satellite operators",
    benchmarkRowPrivacyDrone: "Processing often hosted on third-party cloud servers",
    benchmarkRowPrivacyCloudWeather: "Telemetry stored on vendor proprietary cloud servers",

    benchmarkChartsHeading: "THERMAL MODELING & INFERENCE EFFICIENCY",
    benchmarkChartsSubheading: "Agrometeorological growing degree day accumulation curve and comparative analysis of computational latency on field hardware.",
    benchmarkLineChartTitle: "GDD Thermal Accumulation Curve Across the Season",
    benchmarkLineChartSub: "Growing Degree Days (°C • days) vs Days After Emergence (DAE 0 to 120 days) with BBCH stage landmarks.",
    benchmarkLineLegendBrazil: "Piracicaba, Brazil (Subtropical, T_base = 10.0°C)",
    benchmarkLineLegendThai: "Sukhothai, Thailand (Tropical Monsoon)",
    benchmarkLineLegendTheoretical: "Theoretical BBCH Sigmoid Curve",
    benchmarkBarChartTitle: "Inference Latency by Computing Architecture",
    benchmarkBarChartSub: "Mean neural inference time per phenology cycle (lower is better, logarithmic scale).",

    benchmarkMapHeading: "CARTOGRAPHIC RICE PRODUCTION OVERVIEW",
    benchmarkMapSubheading: "Agnostic color cartography highlighting the Piracicaba and Sukhothai hubs in global rice cultivation.",
    benchmarkMapBrazilTitle: "Brazil • Piracicaba & Rio Grande do Sul",
    benchmarkMapBrazilCoords: "Latitude 22.7136° S • Longitude 47.6527° W",
    benchmarkMapBrazilProduction: "National Production: approximately 11.5 million metric tons per year",
    benchmarkMapBrazilYield: "Average Yield: 7,500 kg per hectare in irrigated lowlands",
    benchmarkMapBrazilClimate: "Climate Regime: Temperate subtropical with controlled flooding",
    benchmarkMapBrazilTech: "Research Center: ESALQ and USP Piracicaba with edge telemetry",
    benchmarkMapThaiTitle: "Thailand • Sukhothai & Chao Phraya River",
    benchmarkMapThaiCoords: "Latitude 17.0055° N • Longitude 99.8264° E",
    benchmarkMapThaiProduction: "National Production: approximately 32.5 million metric tons per year",
    benchmarkMapThaiYield: "Average Yield: 3,100 kg per hectare in flooded paddies",
    benchmarkMapThaiClimate: "Climate Regime: Tropical monsoon with seasonal flood peaks",
    benchmarkMapThaiTech: "Data Source: Rice Department, Ministry of Agriculture and Cooperatives of Thailand",

    benchmarkQuotesHeading: "SCIENTIFIC PERSPECTIVES & EDGE COMMUNITY",
    benchmarkQuotesSubheading: "Feedback from agronomic researchers, open-source engineers, and technical codebase reviews.",
    benchmarkQuote1Author: "Dr. Chenghao Lin",
    benchmarkQuote1Role: "Senior Phenology Researcher, IRRI (Los Baños)",
    benchmarkQuote1Tag: "ACADEMIC REVIEW",
    benchmarkQuote1Text: "The primary failure mode of computer vision models in tropical rice paddies is cloud occlusion during monsoons and leaf overlap after tillering. Oryza-Elo's approach of leveraging in situ microclimate telemetry, soil parameters, and continuous thermal time integration directly at the edge resolves these failure modes completely.",
    benchmarkQuote2Author: "@stefan-edge-ml",
    benchmarkQuote2Role: "Core Contributor, OpenAgri IoT & Embedded Rust",
    benchmarkQuote2Tag: "GITHUB CODE REVIEW",
    benchmarkQuote2Text: "Sub-25 microsecond ONNX inference on Cortex-A76 with a binary footprint under 24MB is masterclass systems engineering. Running SQLite in WAL mode with zero allocation during the hot telemetry loop ensures the field station never crashes during peak heat waves.",
    benchmarkQuote3Author: "Carolina Mendes, Eng.",
    benchmarkQuote3Role: "Irrigation Management Specialist, ESALQ & USP",
    benchmarkQuote3Tag: "RURAL EXTENSION",
    benchmarkQuote3Text: "Calibrating a 10.0°C base temperature coupled with diurnal temperature range (DTR) captures the physiology of Brazilian rice varieties with remarkable accuracy. Having autonomous offline guidance transforms field operations for growers.",
    benchmarkQuote4Author: "Dr. Kanchit Prasert",
    benchmarkQuote4Role: "Agro-Climatology Researcher, Rice Department, Thailand",
    benchmarkQuote4Tag: "THAILAND GOVERNMENT OPEN DATA",
    benchmarkQuote4Text: "Agro-climatic datasets and in situ telemetry from the Chao Phraya River Basin during heavy monsoon rains validate the resilience of this approach. Solar station autonomy and local tabular inference make precision rice monitoring accessible without depending on costly satellite links.",

    authTitle: "Access Oryza-Elo Platform",
    authLoginTab: "Sign In",
    authSignUpTab: "Create Account",
    authEmail: "Email or Station ID",
    authPassword: "Access Key or Password",
    authRole: "Credential Type",
    authRoleFarmer: "Rice Grower (Paddy Operations)",
    authRoleResearcher: "Academic Researcher (USP)",
    authRoleEdge: "Edge IoT Station (API Token)",
    authSubmit: "Confirm Access",
    authCancel: "Cancel",

    footerCopyright: "© 2026 Oryza-Elo • Asodya Ecosystem. All rights reserved.",
    footerEcosystem: "ASODYA ECOSYSTEM • PRECISION AGRI-TECH",
  );

  static const OryzaStrings th = OryzaStrings(
    navBrand: "ORYZA-ELO",
    navCoords: "Sukhothai 17.0° N — Piracicaba 22.7° S",
    navHome: "หน้าหลัก",
    navSystem: "ระบบและขั้นตอน",
    navHardware: "โต๊ะปฏิบัติการ IoT CAD",
    navTcc: "งานวิจัย TCC",
    navLogin: "เข้าสู่ระบบ",
    navSignUp: "สร้างบัญชี",
    backToHome: "กลับสู่หน้าหลัก",

    exploreSectionHeading: "สำรวจระบบนิเวศ ORYZA-ELO ในหน้าจอเฉพาะ",
    exploreSectionSystem: "สถาปัตยกรรมระบบและกระบวนการทางชีวฟิสิกส์",
    exploreSectionSystemDesc: "เรียนรู้เกี่ยวกับเครื่องยนต์ Rust ระดับขอบข่าย กระบวนการชีวฟิสิกส์ 5 ขั้นตอน และการอนุมาน ONNX ใน 22.4 µs",
    exploreSectionHardware: "โต๊ะปฏิบัติการ IoT CAD และแบบร่าง",
    exploreSectionHardwareDesc: "ภาพร่าง 2D และชิ้นส่วนแยก 3D พร้อมการตรวจสอบทางเทคนิคของอุปกรณ์ในแปลงนา",
    exploreSectionTcc: "งานวิจัยทางวิทยาศาสตร์และปริญญานิพนธ์ — มหาวิทยาลัยเซาเปาโล (USP)",
    exploreSectionTccDesc: "มาตรฐานทางวิชาการ แบบจำลองอุตุนิยมวิทยาการเกษตร และการตรวจสอบภาคสนาม",
    exploreActionBtn: "เปิดหน้าจอเฉพาะ",

    heroPill: "สถานีฟีโนโลยีแม่นยำระดับขอบข่ายสำหรับการทำนาข้าว",
    heroJingle: "ไม่ว่าในละตินอเมริกาหรือเอเชีย:\nที่ใดมีแดดและน้ำ ท้องทุ่งย่อมงอกงาม\nที่ใดมีข้อมูลและ Edge Computing วิทยาศาสตร์ย่อมเก็บเกี่ยวผล",
    heroManifestoTag: "แถลงการณ์ทางวิทยาศาสตร์ • วิทยาศาสตร์เก็บเกี่ยวผล",
    heroManifestoPrefix: "ไม่ว่าในละตินอเมริกาหรือเอเชีย:",
    heroManifestoLine1: "ที่ใดมีแดดและน้ำ ท้องทุ่งย่อมงอกงาม",
    heroManifestoLine2: "ที่ใดมีข้อมูลและ Edge Computing วิทยาศาสตร์ย่อมเก็บเกี่ยวผล",
    heroBridgeTag: "สะพานเชื่อมข้ามทวีป: สุโขทัย (17.0055°N) และ ปีราซีคาบา (22.7136°S)",

    culturalTabOverview: "ภาพรวม",
    culturalTabAgronomy: "ปฐพีวิทยาและถิ่นกำเนิด",
    culturalTabScience: "วิทยาศาสตร์ระดับขอบข่าย",
    culturalToggleExpand: "สำรวจคุณลักษณะโดยละเอียด",
    culturalToggleCollapse: "ซ่อนคุณลักษณะ",

    heroBrazilCardTag: "จดหมายของกามินญา, ค.ศ. 1500",
    heroBrazilTitle: "บราซิล 🇧🇷 • ละตินอเมริกา",
    heroBrazilRegion: "ปีราซีคาบา ป่าแอตแลนติก และที่ราบลุ่มแม่น้ำปีราซีคาบา",
    heroBrazilQuote: "Águas são muitas; infindas... dar-se-á nela tudo, por bem das águas que tem.",
    heroBrazilPopular: "« ในผืนแผ่นดินนี้ เมื่อเพาะปลูกสิ่งใดย่อมงอกงาม »",
    heroBrazilOverview: "บันทึกประวัติศาสตร์ปี 1500 ของเปรู วาซ ดึ กามินญา ถึงความอุดมสมบูรณ์อันไร้ขีดจำกัดของสายน้ำและดินเขตร้อน วันนี้ศักยภาพทางธรรมชาตินี้ถูกต่อยอดด้วยวิทยาการเกษตรแม่นยำของ ESALQ มหาวิทยาลัยเซาเปาโล",
    heroBrazilAgronomy: "ดินที่ราบลุ่มน้ำขังอุดมด้วยอินทรียวัตถุ ช่วงแสงกึ่งเขตร้อน และการควบคุมระดับน้ำชลประทาน 5 ถึง 10 ซม. อย่างแม่นยำ เหมาะสำหรับข้าวสายพันธุ์ผลผลิตสูง เช่น BRS Querencia และ Epagri",
    heroBrazilScience: "การคำนวณหน่วยความร้อนสะสม (GDD ฐาน 10.0°C) และช่วงอุณหภูมิรายวัน (DTR) ที่สอบเทียบกับข้อมูลแปลงทดลอง 2,398 แปลง ช่วยกำหนดเวลาใส่ปุ๋ยไนโตรเจนและวันเก็บเกี่ยวได้แม่นยำโดยไม่ต้องใช้อินเทอร์เน็ต",

    heroThaiCardTag: "ศิลาจารึกสุโขทัย, พ.ศ. 1835",
    heroThaiTitle: "ไทย 🇹🇭 • เอเชียตะวันออกเฉียงใต้",
    heroThaiRegion: "สุโขทัย ลุ่มแม่น้ำเจ้าพระยา และที่ราบลุ่มภาคกลาง",
    heroThaiScript: "ในน้ำมีปลา ในนามีข้าว",
    heroThaiTranslit: "Nai nam mi pla, nai na mi khao",
    heroThaiMeaning: "ในน้ำมีปลา ในนามีข้าว",
    heroThaiOverview: "จารึกบนศิลาจารึกพ่อขุนรามคำแหงมหาราชแห่งอาณาจักรสุโขทัยเมื่อ พ.ศ. 1835 แสดงถึงความอุดมสมบูรณ์ ความมั่นคงทางอาหาร และภูมิปัญญาการทำนาข้าวอันยาวนานเกือบพันปี",
    heroThaiAgronomy: "ระบอบอุทกวิทยาจากลมมรสุมเขตร้อน การสะสมตะกอนดินดอนสามเหลี่ยมปากแม่น้ำเจ้าพระยาอันสมบูรณ์ และการสืบทอดการปลูกข้าวหอมมะลิพันธุ์ขาวดอกมะลิ 105 คุณภาพเลิศ",
    heroThaiScience: "การปรับแต่งโมเดลโครงข่ายประสาทเทียมสำหรับสภาพความชื้นสัมพัทธ์สูงและน้ำท่วมฉับพลัน ตรวจสอบการคายระเหยน้ำและปกป้องการปฏิสนธิของเกสรข้าวในระยะออกดอกโดยไม่พึ่งพาระบบคลาวด์",

    heroHeadline: "ระบบตรวจติดตามระยะการเจริญเติบโตของข้าวแบบเรียลไทม์ระดับขอบข่าย",
    heroSubhead: "การอนุมานเครือข่ายประสาทเทียม ONNX ต่ำกว่ามิลลิวินาที แบบจำลองความร้อนสะสม (GDD) และฐานข้อมูล SQLite WAL บนอุปกรณ์โดยไม่ต้องพึ่งพาระบบคลาวด์",
    heroCtaSimulate: "จำลองแปลงนาแบบเรียลไทม์",
    heroCtaGithub: "คลังโค้ด GITHUB",
    heroQuickInstall: "คำสั่งติดตั้งสถานีขอบข่ายในคำสั่งเดียว",
    heroCopied: "คัดลอกคำสั่งเรียบร้อยแล้ว!",

    metricLatencyTitle: "ความหน่วงโครงข่ายประสาทเทียม ONNX",
    metricLatencySub: "ประมวลผลบน ARM CPU โดยไม่ใช้ GPU",
    metricAccuracyTitle: "ความแม่นยำระยะ BBCH",
    metricAccuracySub: "ตรวจสอบในแปลงทดลอง 2,398 แปลง",
    metricGddTitle: "อุณหภูมิฐาน GDD",
    metricGddSub: "การสอบเทียบทางปฐพีวิทยา Oryza",
    metricAirgappedTitle: "การทำงานแบบออฟไลน์ 100%",
    metricAirgappedSub: "ไม่ต้องพึ่งพาระบบคลาวด์",

    sysSectionTag: "สถาปัตยกรรมระบบ",
    sysTitle: "สถาปัตยกรรมระบบและกระบวนการทางชีวฟิสิกส์",
    sysSubtitle: "วิศวกรรมความแม่นยำระดับสูง แยกส่วนระหว่างแกนประมวลผล Rust กับเว็บอินเทอร์เฟซความหนาแน่นสูง",
    sysEdgeTag: "ขอบข่ายท้องถิ่น • RUST DDD",
    sysEdgeTitle: "สถานีขอบข่าย (Rust Edge Engine)",
    sysEdgeSubtitle: "ไมโครเซอร์วิสภาษา Rust (oryzaelo_engine)",
    sysEdgeDesc: "รับข้อมูล Modbus RS-485 จากเซนเซอร์ดินและระดับน้ำ คำนวณความร้อนสะสม GDD (ฐาน 10°C) รันโมเดล ONNX Tract และบันทึกข้อมูล SQLite WAL ในพื้นที่",
    sysEdgePill: "ความหน่วง ONNX: 22.4 µs (CPU ARM)",
    sysClientTag: "เว็บแอปพลิเคชัน • FLUTTER",
    sysClientTitle: "ส่วนต่อประสานภาคสนาม (Flutter Web PWA)",
    sysClientSubtitle: "การแสดงผลทางการเกษตร (apps local และ apps cloud)",
    sysClientDesc: "ทำงานผ่านเว็บเซิร์ฟเวอร์ Axum ของอุปกรณ์โดยตรง ไม่จำเป็นต้องเชื่อมต่ออินเทอร์เน็ตสาธารณะ แสดงผลมาตรา BBCH และแจ้งเตือนการจัดการน้ำ",
    sysClientPill: "ทำงานแบบออฟไลน์ 100%",
    sysPipelineHeading: "กระบวนการชีวฟิสิกส์ 5 ขั้นตอน (จากผืนดินสู่การตัดสินใจ)",

    pipe01Badge: "การกำหนดค่าทางพันธุกรรม",
    pipe01Title: "01. การสอบเทียบสายพันธุ์ข้าว",
    pipe01Desc: "ตั้งค่าพารามิเตอร์ทางพันธุกรรม (เช่น IR64, BRS Querencia) อุณหภูมิฐาน (10.0°C) วันที่งอก และพิกัดแปลงนา",
    pipe01Eq: "T_base = 10.0 °C  •  T_opt = 30.0 °C  •  T_ceil = 40.0 °C",

    pipe02Badge: "MODBUS RTU และ NASA POWER",
    pipe02Title: "02. การรวบรวมข้อมูลจุลภูมิอากาศ",
    pipe02Desc: "อ่านค่าจากเซนเซอร์ดิน 7-in-1 (NPK, pH, ความชื้น, EC) เซนเซอร์ระดับน้ำ เซนเซอร์อุณหภูมิอากาศ และรังสีดวงอาทิตย์",
    pipe02Eq: "เซนเซอร์ดิน 7-in-1 RS-485 + ทรานสดิวเซอร์ความดันไฮโดรสแตติก PUR",

    pipe03Badge: "การรวมค่าความร้อนรายวัน",
    pipe03Title: "03. การสะสมหน่วยความร้อน (GDD)",
    pipe03Desc: "รวมค่าเส้นโค้งความร้อนรายวัน GDD = max(0, T_mean - T_base) และช่วงอุณหภูมิรายวัน (DTR)",
    pipe03Eq: "GDD รายวัน = max( 0, (T_max + T_min) * 0.5 - T_base )",

    pipe04Badge: "รันไทม์ TRACT ONNX",
    pipe04Title: "04. การอนุมานประสาทเทียมระดับขอบข่าย (ONNX)",
    pipe04Desc: "จำแนกระยะการเจริญเติบโตตามมาตรา BBCH (00 ถึง 99) ภายใน 22.4 ไมโครวินาทีบน CPU ของอุปกรณ์",
    pipe04Eq: "เทนเซอร์นำเข้า: Float32[1, 5] -> การจำแนก Softmax BBCH (00 ถึง 99) ใน 22.4 µs",

    pipe05Badge: "การจัดการแปลงนาออฟไลน์",
    pipe05Title: "05. การตัดสินใจทางการเกษตรแบบออฟไลน์",
    pipe05Desc: "คำแนะนำทันทีบนหน้าจอ: การปรับระดับน้ำในแปลงนา จังหวะเวลาใส่ปุ๋ยไนโตรเจน และการคาดการณ์วันเก็บเกี่ยว",
    pipe05Eq: "ระดับน้ำ: 5 ถึง 10 ซม.  •  ใส่ปุ๋ย N: BBCH 25 และ 32  •  ระบายน้ำ: BBCH 87",

    hwSectionTag: "วิศวกรรมฮาร์ดแวร์ IOT",
    hwTitle: "โต๊ะปฏิบัติการฮาร์ดแวร์ IoT และแบบร่าง CAD",
    hwSubtitle: "สำรวจอุปกรณ์หลักทั้ง 6 ชิ้น และสลับมุมมองระหว่างแบบร่างสองมิติ (Blueprint) กับภาพจำลองชิ้นส่วนสามมิติ (Exploded View)",
    hwToggleBlueprint: "แบบร่าง CAD",
    hwToggleExploded: "ภาพจำลองชิ้นส่วน 3D",
    hwZoomBtn: "ขยายแบบร่างทางเทคนิค",
    hwAiDisclaimer: "ภาพร่างแนวคิดต้นแบบสร้างด้วยความช่วยเหลือของ AI • มาตราส่วน 1:1 • สถาปัตยกรรมภาคสนาม",
    hwSpecLabel: "ข้อมูลจำเพาะ:",
    hwAiBadge: "ภาพร่างแนวคิด AI",
    hwInspectorTitle: "รายละเอียดทางเทคนิคระดับขอบข่าย",
    hwDeviceSelect: "เลือกอุปกรณ์สถานี:",
    hwDevices: [
      OryzaDeviceI18n(
        name: 'Raspberry Pi 5',
        role: 'เกตเวย์ขอบข่ายหลัก',
        dwg: 'RPI5-DIN-001',
        blueprintImg: 'assets/blueprint/01_rpi5_blueprint.jpg',
        explodedImg: 'assets/blueprint/02_rpi5_exploded.jpg',
        desc: 'คอมพิวเตอร์ขอบข่าย Quad-core Cortex-A76 @ 2.4GHz พร้อม HAT PCIe M.2 NVMe ติดตั้งบนราง DIN 35 มม. รันโมเดล ONNX ได้ใน 22.4 µs',
        specs: 'ARM Cortex-A76 (4 คอร์) • 4GB LPDDR4X • PCIe 2.0 • Gigabit Ethernet • Dual micro-HDMI • กำลังไฟ 5V, 5A USB-C PD',
      ),
      OryzaDeviceI18n(
        name: 'Raspberry Pi Zero 2 W',
        role: 'โหนดโทรมาตรขนาดกะทัดรัดพิเศษ',
        dwg: 'RPZ2-FLD-002',
        blueprintImg: 'assets/blueprint/03_rpizero2w_blueprint.jpg',
        explodedImg: 'assets/blueprint/04_rpizero2w_exploded.jpg',
        desc: 'โหนดภาคสนามขนาด 65x30 มม. ในกล่องกันน้ำ IP68 พร้อมตัวรับส่งสัญญาณ RS-485 Modbus แบตเตอรี่ลิเธียม 18650 และเสาอากาศ LoRa',
        specs: 'RP3A0 SiP (4 คอร์ A53 @ 1.0GHz) • 512MB RAM • RS-485 Modbus HAT • แบตเตอรี่ 18650 • ใช้พลังงานต่ำกว่า 0.7W',
      ),
      OryzaDeviceI18n(
        name: 'ESP32-S3 LoRa (OLED)',
        role: 'เครื่องส่งสัญญาณภาคสนามและวิทยุ',
        dwg: 'ESP32-LRA-003',
        blueprintImg: 'assets/blueprint/05_esp32_lora_blueprint.jpg',
        explodedImg: 'assets/blueprint/06_esp32_lora_exploded.jpg',
        desc: 'ไมโครคอนโทรลเลอร์ ESP32-S3 พร้อมวิทยุ Semtech SX1262 LoRa และจอแสดงผล OLED 0.96 นิ้ว กล่องทนรังสียูวีพร้อมเคเบิลแกลนด์กันน้ำ',
        specs: 'Xtensa Dual-Core 240MHz • วิทยุ Semtech SX1262 (915MHz) • OLED 128x64 • แบตเตอรี่ LiPo 3.7V • โหมดหลับลึกต่ำกว่า 15µA',
      ),
      OryzaDeviceI18n(
        name: 'หัววัดระดับน้ำไฮโดรสแตติก',
        role: 'เซนเซอร์วัดระดับน้ำในแปลงนา',
        dwg: 'HWL-S10-004',
        blueprintImg: 'assets/blueprint/07_water_sensor_blueprint.jpg',
        explodedImg: 'assets/blueprint/08_water_sensor_exploded.jpg',
        desc: 'หัววัดสแตนเลส 316L ชนิดจุ่มน้ำ พร้อมไดอะแฟรมเพียโซรีซิสทีฟและสายเคเบิลระบายอากาศเพื่อชดเชยความดันบรรยากาศ (0 ถึง 10 ซม.)',
        specs: 'ตัวเรือนสแตนเลส SS316L • ย่านวัด 0 ถึง 1 เมตรน้ำ • สัญญาณ RS-485 Modbus RTU • กันน้ำระดับ IP68 • สายเคเบิล PUR มีช่องระบายอากาศ',
      ),
      OryzaDeviceI18n(
        name: 'หัววัดดินและโคลน 7-in-1',
        role: 'เซนเซอร์วัดธาตุอาหารและความนำไฟฟ้า',
        dwg: 'SN7-RS485-005',
        blueprintImg: 'assets/blueprint/09_soil_probe_blueprint.jpg',
        explodedImg: 'assets/blueprint/10_soil_probe_exploded.jpg',
        desc: 'เซนเซอร์เข็มสแตนเลสเกรดการแพทย์ 5 เข็มสำหรับโคลนในนาข้าว วัดความชื้นในดิน อุณหภูมิ ความนำไฟฟ้า (EC) ค่า pH ไนโตรเจน ฟอสฟอรัส และโพแทสเซียม',
        specs: 'เข็มวัด SS316 5 เข็ม • Modbus RTU (A+, B-, ไฟเลี้ยง 9 ถึง 30V) • ขดลวดไดอิเล็กทริก FDR • เรซินอีพอกซีกันน้ำ • IP68',
      ),
      OryzaDeviceI18n(
        name: 'สถานีพลังงานแสงอาทิตย์อิสระ',
        role: 'กล่องกันน้ำ IP67 และระบบไฟภาคสนาม',
        dwg: 'SOL-STA-006',
        blueprintImg: 'assets/blueprint/11_solar_station_blueprint.jpg',
        explodedImg: 'assets/blueprint/12_solar_station_exploded.jpg',
        desc: 'ชุดสถานีภาคสนามอิสระสำหรับติดตั้งบนเสาคันนา: แผงโซลาร์เซลล์ 50W ปรับมุมได้ ตัวควบคุม MPPT แบตเตอรี่ LiFePO4 12V และราง DIN',
        specs: 'แผงโซลาร์โมโนคริสตัลไลน์ 50W • ตัวควบคุมการชาร์จ MPPT • แบตเตอรี่ LiFePO4 12V 20Ah • กล่องกันน้ำ IP67 • อุปกรณ์ป้องกันไฟกระชาก',
      ),
    ],

    tccSectionTag: "มาตรฐานทางวิชาการและวิทยาศาสตร์",
    tccTitle: "งานวิจัยทางวิทยาศาสตร์และปริญญานิพนธ์ — มหาวิทยาลัยเซาเปาโล (USP)",
    tccSubtitle: "งานวิจัยปริญญานิพนธ์พร้อมแบบจำลองอุตุนิยมวิทยาการเกษตรเชิงคณิตศาสตร์ การอนุมานประสาทเทียมระดับขอบข่าย และการตรวจสอบเชิงประจักษ์",
    tccAffiliation: "มหาวิทยาลัยเซาเปาโล (USP) • หลักสูตร MBA วิศวกรรมซอฟต์แวร์",
    tccHypothesisTitle: "สมมติฐานหลักทางวิชาการ",
    tccHypothesisText: "การอนุมานการเรียนรู้ของเครื่องระดับขอบข่ายจากข้อมูลโทรมาตรในพื้นที่ มีประสิทธิภาพเหนือกว่าคอมพิวเตอร์วิทัศน์ในแปลงนาข้าวที่มีเรือนยอดหนาแน่น ภายใต้สภาพแวดล้อมชนบทที่ไม่มีสัญญาณอินเทอร์เน็ต",
    tccMetricsTitle: "เกณฑ์การตรวจสอบทางวิทยาศาสตร์",
    tccMetricsLatency: "22.4 µs เวลาอนุมานเฉลี่ย",
    tccMetricsAccuracy: "87.2% ความแม่นยำในการจำแนกระยะ BBCH",
    tccMetricsGdd: "10.0°C อุณหภูมิฐานทางสรีรวิทยาที่สอบเทียบ",
    tccReadPaper: "ดาวน์โหลดปริญญานิพนธ์ (PDF ภาษาโปรตุเกส PT-BR)",
    tccAuthor: "ผู้วิจัย: Wilson Borba • นักศึกษาปริญญาโท MBA วิศวกรรมซอฟต์แวร์ มหาวิทยาลัยเซาเปาโล (USP)",

    tccLanguageNoticeTag: "เอกสารต้นฉบับเป็นภาษาโปรตุเกส (PT-BR) • โปรตุเกสบราซิล",
    tccLanguageNoticeDesc: "เอกสารปริญญานิพนธ์ฉบับทางการและบันทึกการสอบป้องกันวิชาการจัดทำขึ้นเป็นภาษาโปรตุเกสบราซิล (PT-BR) ตามมาตรฐาน ABNT สำหรับหลักสูตร MBA วิศวกรรมซอฟต์แวร์ มหาวิทยาลัยเซาเปาโล (USP) พอร์ทัลนี้ให้บริการบทสรุปทางวิทยาศาสตร์ สูตรคณิตศาสตร์ และโทรมาตรแบบโต้ตอบที่แปลครบถ้วน",

    tccCard1Tag: "01. สมมติฐานทางวิทยาศาสตร์และสูตรคณิตศาสตร์",
    tccCard1Title: "การอนุมานระยะฟีโนโลยีผ่านอนุกรมเวลา IoT",
    tccCard1Desc: "การจำแนกระยะการเจริญเติบโตตามมาตรา BBCH (00 ถึง 99) จากโทรมาตรจุลภูมิอากาศระดับขอบข่ายอย่างต่อเนื่อง โมเดล Ensemble ขนาดกะทัดรัด (CatBoost, XGBoost, Random Forest) มีประสิทธิภาพเหนือกว่าคอมพิวเตอร์วิทัศน์ในแปลงนาข้าวเรือนยอดหนาแน่นโดยไม่ต้องพึ่งพาระบบคลาวด์",
    tccCard1TargetLabel: "เป้าหมายทางวิชาการ: Macro-F1 >= 0.75 บนข้อมูลโทรมาตรภาคสนามที่มีสัญญาณรบกวน",

    tccCard2Tag: "02. แบบจำลองอุตุนิยมวิทยาการเกษตร",
    tccCard2Title: "การรวมหน่วยความร้อนสะสม (GDD) และช่วงอุณหภูมิ DTR",
    tccCard2Desc: "การรวมค่าความร้อนทางชีวภาพของอุณหภูมิอากาศและดินเทียบกับอุณหภูมิฐานที่สอบเทียบ (10.0°C) ช่วงอุณหภูมิรายวัน (DTR) ทำหน้าที่ควบคุมการสร้างจุดกำเนิดช่อดอกและการแทงรวงข้าว",
    tccCard2TargetLabel: "พารามิเตอร์: T_base = 10.0 °C  •  T_opt = 30.0 °C  •  T_ceil = 40.0 °C",

    tccCard3Tag: "03. มาตรฐานทางสถิติและความไม่แน่นอน",
    tccCard3Title: "ค่าเฉลี่ยถ่วงน้ำหนัก Macro-F1 และช่วงความเชื่อมั่น Wilson",
    tccCard3Desc: "ตรวจสอบในแปลงนาข้าวชลประทาน 2,398 แปลง โดยแบ่งข้อมูลตามช่วงเวลาอย่างเคร่งครัดเพื่อป้องกันข้อมูลรั่วไหล ช่วงความเชื่อมั่น 95% คำนวณด้วยวิธี Wilson-score สำหรับสัดส่วนทวินาม ยืนยันความน่าเชื่อถือของการจำแนกแม้ในระยะการเจริญเติบโตที่ไม่สมดุล",
    tccCard3TargetLabel: "ผลลัพธ์ที่ได้: Macro-F1 = 0.812  •  ความแม่นยำรวม = 87.2%",

    tccCard4Tag: "04. การเปรียบเทียบสมรรถนะระดับขอบข่าย",
    tccCard4Title: "ข้อได้เปรียบระดับขอบข่าย: ข้อมูลตาราง IoT เทียบกับคอมพิวเตอร์วิทัศน์",
    tccCard4Desc: "แบบจำลองเชิงแสง (กล้อง RGB-D, LiDAR และโดรน) ประสบปัญหาการบดบังของใบข้าวอย่างรุนแรงหลังการแตกกอ และต้องใช้ GPU ราคาแพงที่กินไฟสูง (250W) เครื่องยนต์ตารางภาษา Rust ทำงานด้วยความหน่วงเพียง 22.4 µs และใช้พลังงานต่ำกว่า 5W บนสถานีพลังงานแสงอาทิตย์",
    tccCard4TargetLabel: "ความหน่วง: 22.4 µs (Tract ONNX) เทียบกับ >1200 ms (คอมพิวเตอร์วิทัศน์)",

    tccCardTeamTag: "05. ข้อมูลวิชาการและทีมวิจัย",
    tccCardTeamTitle: "คณาจารย์ การให้คำปรึกษา และความร่วมมือระหว่างประเทศ",
    tccCardTeamDesc: "งานวิจัยปริญญานิพนธ์สำหรับหลักสูตร MBA วิศวกรรมซอฟต์แวร์ มหาวิทยาลัยเซาเปาโล (USP) ผสานรวมชุดข้อมูลเกษตรสภาพภูมิอากาศแบบเปิดจาก กรมการข้าว กระทรวงเกษตรและสหกรณ์ ประเทศไทย",
    tccAuthorLabel: "ผู้วิจัย: Wilson Borba (นักวิทยาศาสตร์ข้อมูล • นักศึกษาปริญญาโท MBA วิศวกรรมซอฟต์แวร์ มหาวิทยาลัยเซาเปาโล USP)",
    tccAdvisorLabel: "ที่ปรึกษาทางวิชาการ: มหาวิทยาลัยเซาเปาโล (USP)",
    tccInstitutionLabel: "สถาบัน: มหาวิทยาลัยเซาเปาโล (USP) • แหล่งข้อมูลภาครัฐ: กรมการข้าว กระทรวงเกษตรและสหกรณ์ ประเทศไทย",

    tccPaperBannerTag: "ปริญญานิพนธ์ฉบับสมบูรณ์",
    tccPaperBannerTitle: "เอกสารปริญญานิพนธ์และคลังโค้ดวิจัยที่ผ่านการตรวจสอบ",
    tccPaperBannerDesc: "เข้าถึงเนื้อหาปริญญานิพนธ์ฉบับสมบูรณ์ในภาษาโปรตุเกสบราซิล (PT-BR) พร้อมสูตรอุตุนิยมวิทยาการเกษตร เมทริกซ์ความสับสนของ 10 ระยะ BBCH หลัก และซอร์สโค้ดที่ได้รับการตรวจสอบ",
    tccGithubBtn: "คลังโค้ดวิทยาศาสตร์ GITHUB",

    navBenchmark: "การเปรียบเทียบมาตรฐาน",
    exploreSectionBenchmark: "การเปรียบเทียบมาตรฐานและประสิทธิภาพทางเทคนิค",
    exploreSectionBenchmarkDesc: "ตารางเปรียบเทียบเชิงประจักษ์กับดาวเทียม โดรน และสถานีคลาวด์ กราฟความหน่วง และข้อมูลผลผลิตข้าวระดับโลก",

    benchmarkSectionTag: "การเปรียบเทียบมาตรฐานและสมรรถนะทางเทคนิค",
    benchmarkTitle: "การเปรียบเทียบสมรรถนะและการประเมินทางเทคนิค",
    benchmarkSubtitle: "การตรวจสอบเชิงประจักษ์ด้านความหน่วง การประหยัดพลังงาน ต้นทุนการดำเนินงาน และความแม่นยำทางฟีโนโลยีของ Oryza-Elo เทียบกับระบบตรวจวัดแบบดั้งเดิมในการทำนาข้าว",

    benchmarkMetricLatencyVal: "22.4 µs",
    benchmarkMetricLatencyTitle: "ความหน่วง Tract ONNX",
    benchmarkMetricLatencySub: "ประมวลผลบน ARM CPU ราคาประหยัด",
    benchmarkMetricPowerVal: "0.45W",
    benchmarkMetricPowerTitle: "กำลังไฟฟ้าเฉลี่ยระดับขอบข่าย",
    benchmarkMetricPowerSub: "ใช้พลังงานแสงอาทิตย์อิสระ",
    benchmarkMetricAccuracyVal: "87.2%",
    benchmarkMetricAccuracyTitle: "ความแม่นยำระยะ BBCH",
    benchmarkMetricAccuracySub: "ปราศจากการบดบังของใบในแปลงนาเรือนยอดหนาแน่น",
    benchmarkMetricOfflineVal: "100%",
    benchmarkMetricOfflineTitle: "การทำงานแบบ Air-Gapped",
    benchmarkMetricOfflineSub: "ไม่ต้องพึ่งพาคลาวด์หรืออินเทอร์เน็ต",

    benchmarkTableHeading: "ตารางเปรียบเทียบเทคโนโลยีการตรวจวัดทางการเกษตร",
    benchmarkTableSubheading: "การเปรียบเทียบเชิงลึกระหว่างสถาปัตยกรรมขอบข่ายแบบตารางของ Oryza-Elo กับเทคโนโลยีตรวจวัดอื่นๆ ในภาคสนาม",
    benchmarkColCriterion: "เกณฑ์การประเมิน",
    benchmarkColOryza: "Oryza-Elo (ข้อมูลตารางระดับขอบข่าย)",
    benchmarkColSatellite: "ดาวเทียม (Sentinel-2 และ Landsat)",
    benchmarkColDrone: "โดรนการเกษตร VANT (หลายช่วงคลื่น)",
    benchmarkColCloudWeather: "สถานีตรวจอากาศระบบคลาวด์ (แบบดั้งเดิม)",

    benchmarkRowLatencyTitle: "ความหน่วงในการตัดสินใจภาคสนาม",
    benchmarkRowLatencyOryza: "22.4 µs (การอนุมานแบบเรียลไทม์ทันที)",
    benchmarkRowLatencySatellite: "5 ถึง 12 วัน (รอบการโคจรซ้ำของดาวเทียม)",
    benchmarkRowLatencyDrone: "2 ถึง 6 ชั่วโมง (การวางแผนบินและประมวลผลภาพ)",
    benchmarkRowLatencyCloudWeather: "1 ถึง 3 ชั่วโมง (ขึ้นอยู่กับสัญญาณ 4G ชนบท)",

    benchmarkRowCloudTitle: "ผลกระทบจากเมฆและฤดูมรสุม",
    benchmarkRowCloudOryza: "ไม่มีผลกระทบ (เซนเซอร์วัดดินและระดับน้ำในแปลงจริง)",
    benchmarkRowCloudSatellite: "รุนแรง (สูญเสียข้อมูลภาพ 60% ถึง 80% ในฤดูฝน)",
    benchmarkRowCloudDrone: "ปานกลาง (ต้องบินใต้เพดานเมฆ ไม่สามารถบินตอนฝนตกหนัก)",
    benchmarkRowCloudCloudWeather: "ไม่มีผลจากเมฆ แต่อ่อนไหวต่อพายุฟ้าคะนอง",

    benchmarkRowOcclusionTitle: "การบดบังของเรือนยอดใบข้าว",
    benchmarkRowOcclusionOryza: "ไม่มีผลกระทบ (เซนเซอร์สัมผัสน้ำและรากข้าวโดยตรง)",
    benchmarkRowOcclusionSatellite: "รุนแรง (ค่าดัชนี NDVI อิ่มตัวหลังการแตกกอสมบูรณ์)",
    benchmarkRowOcclusionDrone: "รุนแรง (มุมมองจากด้านบนมองไม่เห็นระดับน้ำใต้ใบข้าว)",
    benchmarkRowOcclusionCloudWeather: "ไม่มีผลกระทบ (วัดอุณหภูมิอากาศและดินเปิด)",

    benchmarkRowPowerTitle: "การใช้พลังงานและความต่อเนื่อง",
    benchmarkRowPowerOryza: "0.45W ถึง 1.2W (แผงโซลาร์ 50W พร้อมแบตเตอรี่ LiFePO4)",
    benchmarkRowPowerSatellite: "ไม่ใช้พลังงานในแปลงนา (โครงสร้างพื้นฐานในอวกาศ)",
    benchmarkRowPowerDrone: "แบตเตอรี่ LiPo (บินได้ 25 ถึง 40 นาทีต่อก้อน)",
    benchmarkRowPowerCloudWeather: "5W ถึง 15W (โมเด็มสื่อสารและโทรมาตรต่อเนื่อง)",

    benchmarkRowCostTitle: "ประมาณการต้นทุนการติดตั้ง",
    benchmarkRowCostOryza: "ประหยัด (ต้นทุนอุปกรณ์ต่ำกว่า 90 ดอลลาร์ต่อสถานี)",
    benchmarkRowCostSatellite: "ฟรีสำหรับความละเอียดต่ำ ค่าบริการสูงสำหรับภาพรายวัน",
    benchmarkRowCostDrone: "สูงมาก (3,000 ถึง 15,000 ดอลลาร์ รวมนักบินที่ผ่านการรับรอง)",
    benchmarkRowCostCloudWeather: "ปานกลางถึงสูง (1,500 ถึง 4,000 ดอลลาร์ พร้อมค่าบริการรายเดือน)",

    benchmarkRowTemporalTitle: "ความละเอียดเชิงเวลาในการเก็บข้อมูล",
    benchmarkRowTemporalOryza: "วินาทีต่อวินาทีอย่างต่อเนื่อง (เรียลไทม์ในแปลง)",
    benchmarkRowTemporalSatellite: "เก็บข้อมูลทุก 5 ถึง 12 วัน",
    benchmarkRowTemporalDrone: "ตามความต้องการ (มักเป็นรายสัปดาห์หรือรายเดือน)",
    benchmarkRowTemporalCloudWeather: "เก็บข้อมูลเฉลี่ยรายชั่วโมง",

    benchmarkRowConnectivityTitle: "ความต้องการสัญญาณเชื่อมต่อ",
    benchmarkRowConnectivityOryza: "ศูนย์ (Air-gapped 100% ฐานข้อมูล SQLite WAL บนสถานี)",
    benchmarkRowConnectivitySatellite: "จำเป็นต้องมีอินเทอร์เน็ตความเร็วสูงเพื่อดาวน์โหลดภาพ",
    benchmarkRowConnectivityDrone: "จำเป็นต้องมีอินเทอร์เน็ตเพื่อส่งภาพแผนที่ขนาดใหญ่",
    benchmarkRowConnectivityCloudWeather: "วิกฤต (ต้องมีสัญญาณโทรศัพท์เคลื่อนที่หรือดาวเทียมต่อเนื่อง)",

    benchmarkRowPrivacyTitle: "ความเป็นส่วนตัวและอธิปไตยของข้อมูล",
    benchmarkRowPrivacyOryza: "สมบูรณ์ (ข้อมูลถูกเก็บไว้ในแปลงเกษตรกรเท่านั้น)",
    benchmarkRowPrivacySatellite: "สาธารณะหรือเป็นกรรมสิทธิ์ของผู้ให้บริการดาวเทียมต่างชาติ",
    benchmarkRowPrivacyDrone: "การประมวลผลมักต้องอัปโหลดขึ้นคลาวด์ภายนอก",
    benchmarkRowPrivacyCloudWeather: "ข้อมูลโทรมาตรถูกส่งไปยังเซิร์ฟเวอร์คลาวด์ของผู้ผลิต",

    benchmarkChartsHeading: "แบบจำลองความร้อนและประสิทธิภาพการอนุมาน",
    benchmarkChartsSubheading: "กราฟอุตุนิยมวิทยาการเกษตรแสดงหน่วยความร้อนสะสม (GDD) และการวิเคราะห์เปรียบเทียบความหน่วงบนฮาร์ดแวร์ภาคสนาม",
    benchmarkLineChartTitle: "เส้นโค้งความร้อนสะสม GDD ตลอดฤดูปลูก",
    benchmarkLineChartSub: "หน่วยความร้อนสะสม (°C • วัน) เทียบกับ วันหลังงอก (DAE 0 ถึง 120 วัน) พร้อมหมุดหมายระยะ BBCH",
    benchmarkLineLegendBrazil: "ปีราซีคาบา บราซิล (กึ่งเขตร้อน อุณหภูมิฐาน 10.0°C)",
    benchmarkLineLegendThai: "สุโขทัย ไทย (เขตร้อนมรสุม)",
    benchmarkLineLegendTheoretical: "เส้นโค้งทฤษฎี BBCH แบบ Sigmoid",
    benchmarkBarChartTitle: "ความหน่วงในการอนุมานตามสถาปัตยกรรมคอมพิวเตอร์",
    benchmarkBarChartSub: "เวลาเฉลี่ยในการอนุมานโครงข่ายประสาทเทียมต่อรอบฟีโนโลยี (ค่ายิ่งน้อยยิ่งดี มาตราส่วนลอการิทึม)",

    benchmarkMapHeading: "แผนที่การกระจายผลผลิตข้าวระดับโลก",
    benchmarkMapSubheading: "แผนที่ภูมิศาสตร์สีกลางแสดงจุดศูนย์กลางปีราซีคาบาและสุโขทัยในการเพาะปลูกข้าวของโลก",
    benchmarkMapBrazilTitle: "บราซิล • ปีราซีคาบา และ รีอูกรังจีดูซูล",
    benchmarkMapBrazilCoords: "ละติจูด 22.7136° S • ลองจิจูด 47.6527° W",
    benchmarkMapBrazilProduction: "ผลผลิตข้าวระดับชาติ: ประมาณ 11.5 ล้านตันต่อปี",
    benchmarkMapBrazilYield: "ผลผลิตเฉลี่ย: 7,500 กิโลกรัมต่อเฮกตาร์ในแปลงนาชลประทาน",
    benchmarkMapBrazilClimate: "ระบอบภูมิอากาศ: กึ่งเขตร้อนอบอุ่นพร้อมระบบชลประทานควบคุม",
    benchmarkMapBrazilTech: "ศูนย์วิจัย: ESALQ และ USP ปีราซีคาบา ร่วมกับระบบขอบข่าย",
    benchmarkMapThaiTitle: "ไทย • สุโขทัย และ ลุ่มแม่น้ำเจ้าพระยา",
    benchmarkMapThaiCoords: "ละติจูด 17.0055° N • ลองจิจูด 99.8264° E",
    benchmarkMapThaiProduction: "ผลผลิตข้าวระดับชาติ: ประมาณ 32.5 ล้านตันต่อปี",
    benchmarkMapThaiYield: "ผลผลิตเฉลี่ย: 3,100 กิโลกรัมต่อเฮกตาร์ในแปลงนาน้ำขัง",
    benchmarkMapThaiClimate: "ระบอบภูมิอากาศ: เขตร้อนมรสุมพร้อมปริมาณน้ำฝนและความชื้นสูง",
    benchmarkMapThaiTech: "แหล่งข้อมูล: กรมการข้าว กระทรวงเกษตรและสหกรณ์ ประเทศไทย",

    benchmarkQuotesHeading: "มุมมองทางวิทยาศาสตร์และชุมชนนักพัฒนาขอบข่าย",
    benchmarkQuotesSubheading: "ความคิดเห็นจากนักวิจัยการเกษตร วิศวกรโอเพนซอร์ส และการตรวจสอบโค้ด",
    benchmarkQuote1Author: "Dr. Chenghao Lin",
    benchmarkQuote1Role: "นักวิจัยอาวุโสด้านฟีโนโลยีข้าว สถาบันวิจัยข้าวนานาชาติ IRRI",
    benchmarkQuote1Tag: "การประเมินทางวิชาการ",
    benchmarkQuote1Text: "ข้อจำกัดหลักของคอมพิวเตอร์วิทัศน์ในนาข้าวเขตร้อนคือการบดบังของเมฆมรสุมและการทับซ้อนของใบหลังการแตกกอ แนวทางของ Oryza-Elo ที่ใช้ข้อมูลตารางจุลภูมิอากาศและหน่วยความร้อนสะสมบนอุปกรณ์ขอบข่ายช่วยแก้ปัญหานี้ได้อย่างสมบูรณ์แบบ",
    benchmarkQuote2Author: "@stefan-edge-ml",
    benchmarkQuote2Role: "ผู้ร่วมพัฒนาหลัก โครงการ OpenAgri IoT และ Embedded Rust",
    benchmarkQuote2Tag: "การตรวจสอบโค้ด GITHUB",
    benchmarkQuote2Text: "การอนุมาน ONNX ภายใน 22.4 ไมโครวินาทีบน Cortex-A76 ด้วยขนาดโปรแกรมต่ำกว่า 24MB เป็นตัวอย่างวิศวกรรมระบบชั้นยอด การใช้ SQLite WAL โดยไม่มีการจัดสรรหน่วยความจำเกินจำเป็นทำให้สถานีทำงานได้อย่างต่อเนื่องในสภาพอากาศร้อนจัด",
    benchmarkQuote3Author: "Carolina Mendes, วิศวกรการเกษตร",
    benchmarkQuote3Role: "ผู้เชี่ยวชาญการจัดการชลประทาน ESALQ และ USP",
    benchmarkQuote3Tag: "การส่งเสริมการเกษตร",
    benchmarkQuote3Text: "การสอบเทียบอุณหภูมิฐาน 10.0°C ร่วมกับช่วงอุณหภูมิรายวัน DTR สะท้อนสรีรวิทยาของข้าวสายพันธุ์บราซิลได้อย่างแม่นยำ การได้รับคำแนะนำโดยไม่ต้องต่ออินเทอร์เน็ตช่วยเปลี่ยนการทำเกษตรในแปลงได้อย่างแท้จริง",
    benchmarkQuote4Author: "ดร. ครรชิต ประเสริฐ",
    benchmarkQuote4Role: "นักวิจัยด้านสภาพภูมิอากาศการเกษตร กรมการข้าว ประเทศไทย",
    benchmarkQuote4Tag: "ข้อมูลเปิดภาครัฐ กรมการข้าว",
    benchmarkQuote4Text: "ชุดข้อมูลเกษตรสภาพภูมิอากาศและการวัดผลทางไกลในพื้นที่ลุ่มแม่น้ำเจ้าพระยาช่วงฤดูมรสุมยืนยันความแม่นยำและความทนทานของแบบจำลอง การประมวลผลบนอุปกรณ์ปลายทางช่วยให้เกษตรกรสามารถตรวจสอบระยะการเจริญเติบโตของข้าวได้โดยไม่ต้องพึ่งพาสัญญาณดาวเทียมที่มีราคาสูง",

    authTitle: "เข้าสู่ระบบแพลตฟอร์ม Oryza-Elo",
    authLoginTab: "เข้าสู่ระบบ",
    authSignUpTab: "สร้างบัญชี",
    authEmail: "อีเมล หรือ รหัสสถานี",
    authPassword: "รหัสผ่าน หรือ คีย์เข้าถึง",
    authRole: "ประเภทบัญชี",
    authRoleFarmer: "เกษตรกรชาวนา (แปลงนาข้าว)",
    authRoleResearcher: "นักวิจัย หรือ นักปฐพีวิทยา (USP)",
    authRoleEdge: "สถานีขอบข่าย IoT (API Token)",
    authSubmit: "ยืนยันการเข้าสู่ระบบ",
    authCancel: "ยกเลิก",

    footerCopyright: "© 2026 Oryza-Elo • Asodya Ecosystem. สงวนลิขสิทธิ์ทั้งหมด",
    footerEcosystem: "ASODYA ECOSYSTEM • PRECISION AGRI-TECH",
  );

  static OryzaStrings of(BuildContext context) {
    final controller = OryzaScope.of(context);
    final langCode = controller.locale.languageCode;
    if (langCode == 'pt') return pt;
    if (langCode == 'th') return th;
    return en;
  }
}
