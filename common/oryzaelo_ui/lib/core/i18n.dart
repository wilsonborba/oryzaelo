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
  final String navSystem;
  final String navHardware;
  final String navTcc;
  final String navLogin;
  final String navSignUp;

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

  final String tccCard1Tag;
  final String tccCard1Title;
  final String tccCard2Tag;
  final String tccCard2Title;
  final String tccCard2Desc;
  final String tccCard3Tag;
  final String tccCard3Title;
  final String tccCard3Desc;
  final String tccCard4Tag;
  final String tccCard4Title;

  final String tccPaperBannerTag;
  final String tccPaperBannerTitle;
  final String tccPaperBannerDesc;

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
    required this.navSystem,
    required this.navHardware,
    required this.navTcc,
    required this.navLogin,
    required this.navSignUp,
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
    required this.tccCard1Tag,
    required this.tccCard1Title,
    required this.tccCard2Tag,
    required this.tccCard2Title,
    required this.tccCard2Desc,
    required this.tccCard3Tag,
    required this.tccCard3Title,
    required this.tccCard3Desc,
    required this.tccCard4Tag,
    required this.tccCard4Title,
    required this.tccPaperBannerTag,
    required this.tccPaperBannerTitle,
    required this.tccPaperBannerDesc,
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
    navSystem: "Sistema & Pipeline",
    navHardware: "Bancada IoT CAD",
    navTcc: "Pesquisa TCC",
    navLogin: "Entrar",
    navSignUp: "Criar Conta",

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
    heroBrazilTitle: "Brasil • América Latina",
    heroBrazilRegion: "Piracicaba, Mata Atlântica e Várzeas do Rio Piracicaba",
    heroBrazilQuote: "Águas são muitas; infindas... dar-se-á nela tudo, por bem das águas que tem.",
    heroBrazilPopular: "« Nesta terra, em se plantando, tudo dá »",
    heroBrazilOverview: "Na certidão de nascimento do Brasil em 1500, Pero Vaz de Caminha registrou a fertilidade espontânea das águas e do solo tropical. Essa riqueza natural hoje é potencializada pela agrometeorologia e pelo rigor acadêmico da ESALQ, Universidade de São Paulo.",
    heroBrazilAgronomy: "Solos hidromórficos de várzea ricos em matéria orgânica, fotoperíodo subtropical e manejo milimétrico da lâmina de irrigação entre 5 e 10 cm, ideal para cultivares de alta produtividade como BRS Querência e Epagri.",
    heroBrazilScience: "Modelagem matemática de graus-dia acumulados (GDD base 10.0°C) e amplitude térmica diurna (DTR) calibrada com 2.398 safras, automatizando as janelas ótimas para adubação nitrogenada e colheita sem necessidade de internet.",

    heroThaiCardTag: "ESTELA DE SUKHOTHAI, 1292",
    heroThaiTitle: "Tailândia • Sudeste Asiático",
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
    tccTitle: "Pesquisa Científica & TCC — USP, ESALQ",
    tccSubtitle: "Trabalho de Conclusão de Curso desenvolvido na Escola Superior de Agricultura Luiz de Queiroz da Universidade de São Paulo em Piracicaba.",
    tccAffiliation: "Universidade de São Paulo • ESALQ Piracicaba",
    tccHypothesisTitle: "Hipótese Acadêmica Central",
    tccHypothesisText: "A inferência de aprendizado de máquina na borda a partir de telemetria microclimática in situ supera modelos de visão computacional em dosséis fechados de arroz irrigado, viabilizando o monitoramento autônomo em regiões rurais desprovidas de conectividade em nuvem.",
    tccMetricsTitle: "Métricas de Validação Científica",
    tccMetricsLatency: "22.4 µs de tempo médio de inferência",
    tccMetricsAccuracy: "87.2% de acurácia na classificação de estádios BBCH",
    tccMetricsGdd: "10.0°C temperatura base fisiológica calibrada",
    tccReadPaper: "LER ARTIGO & MONOGRAFIA TCC (PDF)",
    tccAuthor: "Autor: Wilson Borba • Orientador: Prof. Alexandre Duarte • ESALQ, USP",

    tccCard1Tag: "PERGUNTA DE PESQUISA",
    tccCard1Title: "Hipótese Central da Tese",
    tccCard2Tag: "METODOLOGIA BIOFÍSICA",
    tccCard2Title: "Modelagem Agrometeorológica",
    tccCard2Desc: "Integração de variáveis microclimáticas in situ com tempo térmico cumulativo (GDD base 10°C) e modelo agrometeorológico calibrado contra 2.398 observações de arroz irrigado.",
    tccCard3Tag: "APLICAÇÃO DE BORDA",
    tccCard3Title: "Validação no Campo com Produtores",
    tccCard3Desc: "Avaliação da interface offline (apps local) em condições reais de lavoura no sul do Brasil e Tailândia, garantindo usabilidade intuitiva sem sinal de celular.",
    tccCard4Tag: "CRÉDITOS ESALQ, USP",
    tccCard4Title: "Autoria e Orientação Acadêmica",

    tccPaperBannerTag: "DOCUMENTO ACADÊMICO",
    tccPaperBannerTitle: "Monografia & Artigo Científico Completo do TCC",
    tccPaperBannerDesc: "Acesse a formulação agrometeorológica detalhada, a matriz de confusão dos estádios BBCH e o código fonte auditado do motor de processamento em borda.",

    authTitle: "Acesso à Plataforma Oryza-Elo",
    authLoginTab: "Entrar",
    authSignUpTab: "Criar Conta",
    authEmail: "E-mail ou ID da Estação",
    authPassword: "Chave de Acesso ou Senha",
    authRole: "Tipo de Credencial",
    authRoleFarmer: "Produtor Rural (Lavouras de Arroz)",
    authRoleResearcher: "Pesquisador ou Agrônomo (USP, ESALQ)",
    authRoleEdge: "Estação IoT de Borda (API Token)",
    authSubmit: "Confirmar Acesso",
    authCancel: "Cancelar",

    footerCopyright: "© 2026 Oryza-Elo • Ecossistema Asodya. Todos os direitos reservados.",
    footerEcosystem: "ASODYA ECOSYSTEM • PRECISION AGRI-TECH",
  );

  static const OryzaStrings en = OryzaStrings(
    navBrand: "ORYZA-ELO",
    navCoords: "Sukhothai 17.0° N — Piracicaba 22.7° S",
    navSystem: "System & Pipeline",
    navHardware: "IoT CAD Workbench",
    navTcc: "TCC Research",
    navLogin: "Sign In",
    navSignUp: "Create Account",

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
    heroBrazilTitle: "Brazil • Latin America",
    heroBrazilRegion: "Piracicaba, Atlantic Forest & Piracicaba River Basin",
    heroBrazilQuote: "The waters are endless... by planting, all will yield in this land.",
    heroBrazilPopular: "« In this land, whatever is planted will grow »",
    heroBrazilOverview: "In Brazil's founding 1500 document, Pero Vaz de Caminha marveled at the boundless fertility of the tropical soil and waters. Today, that natural bounty is paired with modern agrometeorology and the academic rigor of ESALQ, University of São Paulo.",
    heroBrazilAgronomy: "Hydromorphic lowland soils rich in organic matter, subtropical photoperiod, and millimeter-level water depth maintenance between 5 and 10 cm, ideal for productive cultivars like BRS Querencia and Epagri.",
    heroBrazilScience: "Mathematical growing degree day modeling (GDD base 10.0°C) and diurnal temperature range (DTR) calibrated against 2,398 crop cycles, calculating optimal nitrogen top-dressing and harvest schedules with zero cloud dependence.",

    heroThaiCardTag: "SUKHOTHAI STELE, 1292",
    heroThaiTitle: "Thailand • Southeast Asia",
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
    tccTitle: "Scientific Research & Thesis — USP, ESALQ",
    tccSubtitle: "Undergraduate thesis research conducted at Luiz de Queiroz College of Agriculture, University of São Paulo in Piracicaba.",
    tccAffiliation: "University of São Paulo • ESALQ Piracicaba",
    tccHypothesisTitle: "Core Academic Hypothesis",
    tccHypothesisText: "Edge machine learning inference from in-situ microclimatic telemetry outperforms computer vision in dense flooded rice canopies under disconnected rural environments.",
    tccMetricsTitle: "Empirical Validation Metrics",
    tccMetricsLatency: "22.4 µs average inference latency",
    tccMetricsAccuracy: "87.2% BBCH phenological stage accuracy",
    tccMetricsGdd: "10.0°C calibrated base physiological threshold",
    tccReadPaper: "READ THESIS & MONOGRAPH (PDF)",
    tccAuthor: "Author: Wilson Borba • Advisor: Prof. Alexandre Duarte • ESALQ, USP",

    tccCard1Tag: "RESEARCH QUESTION",
    tccCard1Title: "Core Thesis Hypothesis",
    tccCard2Tag: "BIOPHYSICAL METHODOLOGY",
    tccCard2Title: "Agrometeorological Modeling",
    tccCard2Desc: "Integration of in-situ microclimatic telemetry with cumulative thermal time (GDD base 10°C) calibrated against 2,398 flooded rice crop observations.",
    tccCard3Tag: "EDGE APPLICATION",
    tccCard3Title: "Field Validation with Rice Farmers",
    tccCard3Desc: "Evaluation of the offline interface (apps local) in real paddy conditions across Southern Brazil and Thailand, ensuring intuitive usability without cellular reception.",
    tccCard4Tag: "CREDITS ESALQ, USP",
    tccCard4Title: "Authorship & Academic Advising",

    tccPaperBannerTag: "ACADEMIC DOCUMENT",
    tccPaperBannerTitle: "Complete TCC Thesis Monograph & Paper",
    tccPaperBannerDesc: "Access the detailed agrometeorological formulation, BBCH confusion matrix, and audited edge engine source code.",

    authTitle: "Access Oryza-Elo Platform",
    authLoginTab: "Sign In",
    authSignUpTab: "Create Account",
    authEmail: "Email or Station ID",
    authPassword: "Access Key or Password",
    authRole: "Credential Type",
    authRoleFarmer: "Rice Grower (Paddy Operations)",
    authRoleResearcher: "Academic Researcher (USP, ESALQ)",
    authRoleEdge: "Edge IoT Station (API Token)",
    authSubmit: "Confirm Access",
    authCancel: "Cancel",

    footerCopyright: "© 2026 Oryza-Elo • Asodya Ecosystem. All rights reserved.",
    footerEcosystem: "ASODYA ECOSYSTEM • PRECISION AGRI-TECH",
  );

  static const OryzaStrings th = OryzaStrings(
    navBrand: "ORYZA-ELO",
    navCoords: "Sukhothai 17.0° N — Piracicaba 22.7° S",
    navSystem: "ระบบและขั้นตอน",
    navHardware: "โต๊ะปฏิบัติการ IoT CAD",
    navTcc: "งานวิจัย TCC",
    navLogin: "เข้าสู่ระบบ",
    navSignUp: "สร้างบัญชี",

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
    heroBrazilTitle: "บราซิล • ละตินอเมริกา",
    heroBrazilRegion: "ปีราซีคาบา ป่าแอตแลนติก และที่ราบลุ่มแม่น้ำปีราซีคาบา",
    heroBrazilQuote: "Águas são muitas; infindas... dar-se-á nela tudo, por bem das águas que tem.",
    heroBrazilPopular: "« ในผืนแผ่นดินนี้ เมื่อเพาะปลูกสิ่งใดย่อมงอกงาม »",
    heroBrazilOverview: "บันทึกประวัติศาสตร์ปี 1500 ของเปรู วาซ ดึ กามินญา ถึงความอุดมสมบูรณ์อันไร้ขีดจำกัดของสายน้ำและดินเขตร้อน วันนี้ศักยภาพทางธรรมชาตินี้ถูกต่อยอดด้วยวิทยาการเกษตรแม่นยำของ ESALQ มหาวิทยาลัยเซาเปาโล",
    heroBrazilAgronomy: "ดินที่ราบลุ่มน้ำขังอุดมด้วยอินทรียวัตถุ ช่วงแสงกึ่งเขตร้อน และการควบคุมระดับน้ำชลประทาน 5 ถึง 10 ซม. อย่างแม่นยำ เหมาะสำหรับข้าวสายพันธุ์ผลผลิตสูง เช่น BRS Querencia และ Epagri",
    heroBrazilScience: "การคำนวณหน่วยความร้อนสะสม (GDD ฐาน 10.0°C) และช่วงอุณหภูมิรายวัน (DTR) ที่สอบเทียบกับข้อมูลแปลงทดลอง 2,398 แปลง ช่วยกำหนดเวลาใส่ปุ๋ยไนโตรเจนและวันเก็บเกี่ยวได้แม่นยำโดยไม่ต้องใช้อินเทอร์เน็ต",

    heroThaiCardTag: "ศิลาจารึกสุโขทัย, พ.ศ. 1835",
    heroThaiTitle: "ไทย • เอเชียตะวันออกเฉียงใต้",
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
    tccTitle: "งานวิจัยทางวิทยาศาสตร์และปริญญานิพนธ์ — USP, ESALQ",
    tccSubtitle: "งานวิจัยปริญญานิพนธ์ ณ วิทยาลัยเกษตรศาสตร์ Luiz de Queiroz มหาวิทยาลัยเซาเปาโล ณ เมืองปีราซีคาบา",
    tccAffiliation: "มหาวิทยาลัยเซาเปาโล • ESALQ Piracicaba",
    tccHypothesisTitle: "สมมติฐานหลักทางวิชาการ",
    tccHypothesisText: "การอนุมานการเรียนรู้ของเครื่องระดับขอบข่ายจากข้อมูลโทรมาตรในพื้นที่ มีประสิทธิภาพเหนือกว่าคอมพิวเตอร์วิทัศน์ในแปลงนาข้าวที่มีเรือนยอดหนาแน่น ภายใต้สภาพแวดล้อมชนบทที่ไม่มีสัญญาณอินเทอร์เน็ต",
    tccMetricsTitle: "เกณฑ์การตรวจสอบทางวิทยาศาสตร์",
    tccMetricsLatency: "22.4 µs เวลาอนุมานเฉลี่ย",
    tccMetricsAccuracy: "87.2% ความแม่นยำในการจำแนกระยะ BBCH",
    tccMetricsGdd: "10.0°C อุณหภูมิฐานทางสรีรวิทยาที่สอบเทียบ",
    tccReadPaper: "อ่านบทความวิจัยและปริญญานิพนธ์ (PDF)",
    tccAuthor: "ผู้วิจัย: Wilson Borba • อาจารย์ที่ปรึกษา: Prof. Alexandre Duarte • ESALQ, USP",

    tccCard1Tag: "คำถามการวิจัย",
    tccCard1Title: "สมมติฐานหลักของปริญญานิพนธ์",
    tccCard2Tag: "ระเบียบวิธีทางชีวฟิสิกส์",
    tccCard2Title: "แบบจำลองอุตุนิยมวิทยาการเกษตร",
    tccCard2Desc: "การรวมข้อมูลโทรมาตรจุลภูมิอากาศกับหน่วยความร้อนสะสม (GDD ฐาน 10°C) สอบเทียบกับข้อมูลแปลงนาข้าวชลประทาน 2,398 ตัวอย่าง",
    tccCard3Tag: "การประยุกต์ใช้งานจริง",
    tccCard3Title: "การตรวจสอบภาคสนามร่วมกับเกษตรกร",
    tccCard3Desc: "การประเมินการใช้งานจริงในแปลงนาทางตอนใต้ของบราซิลและไทย ใช้งานง่ายโดยไม่ต้องพึ่งพาสัญญาณโทรศัพท์มือถือ",
    tccCard4Tag: "ข้อมูลวิชาการ ESALQ, USP",
    tccCard4Title: "ผู้วิจัยและอาจารย์ที่ปรึกษา",

    tccPaperBannerTag: "เอกสารทางวิชาการ",
    tccPaperBannerTitle: "เอกสารปริญญานิพนธ์และบทความวิจัยฉบับสมบูรณ์",
    tccPaperBannerDesc: "เข้าถึงสูตรทางอุตุนิยมวิทยาการเกษตรอย่างละเอียด เมทริกซ์ความสับสนของระยะ BBCH และซอร์สโค้ดที่ผ่านการตรวจสอบของเครื่องยนต์ขอบข่าย",

    authTitle: "เข้าสู่ระบบแพลตฟอร์ม Oryza-Elo",
    authLoginTab: "เข้าสู่ระบบ",
    authSignUpTab: "สร้างบัญชี",
    authEmail: "อีเมล หรือ รหัสสถานี",
    authPassword: "รหัสผ่าน หรือ คีย์เข้าถึง",
    authRole: "ประเภทบัญชี",
    authRoleFarmer: "เกษตรกรชาวนา (แปลงนาข้าว)",
    authRoleResearcher: "นักวิจัย หรือ นักปฐพีวิทยา (USP, ESALQ)",
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
