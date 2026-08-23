-- BeetleBase: species_master シードデータ
-- Supabase SQL Editor で実行する

CREATE TABLE IF NOT EXISTS species_master (
  code                VARCHAR(8)   PRIMARY KEY,
  name_ja             VARCHAR(64)  NOT NULL,
  name_scientific     VARCHAR(128) NOT NULL,
  category            VARCHAR(8)   NOT NULL CHECK (category IN ('クワガタ', 'カブト')),
  origin              VARCHAR(8)   NOT NULL CHECK (origin IN ('国産', '外国産')),
  regulation_note     TEXT,
  regulation_sources  JSONB,       -- [{name: "ソース名", url: "https://..."}]
  active              BOOLEAN      NOT NULL DEFAULT true,
  created_at          TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- コードは変更不可（RLSとトリガーで保護する想定）
-- ソースJSON（共通）
-- 植物防疫法のみ
-- '[{"name":"農林水産省植物防疫所","url":"https://www.maff.go.jp/pps/"},{"name":"農林水産省 植物防疫法の概要","url":"https://www.maff.go.jp/j/syouan/syokubo/boujyosyo/"}]'
-- ニジイロ用（採集禁止＋植物防疫法）
-- '[{"name":"農林水産省植物防疫所","url":"https://www.maff.go.jp/pps/"},{"name":"環境省 外来生物法","url":"https://www.env.go.jp/nature/intro/"}]'

-- ─────────────────────────────────────────────────────────────────
-- 国産クワガタ
-- ─────────────────────────────────────────────────────────────────
INSERT INTO species_master (code, name_ja, name_scientific, category, origin, regulation_note, regulation_sources) VALUES
  ('OOKUWA', 'オオクワガタ',           'Dorcus hopei binodulosus',       'クワガタ', '国産',   NULL, NULL),
  ('MIYAMA', 'ミヤマクワガタ',         'Lucanus maculifemoratus',         'クワガタ', '国産',   NULL, NULL),
  ('HIRATA', 'ヒラタクワガタ',         'Dorcus titanus pilifer',          'クワガタ', '国産',   NULL, NULL),
  ('NOKOGI', 'ノコギリクワガタ',       'Prosopocoilus inclinatus',        'クワガタ', '国産',   NULL, NULL),
  ('KOKUWA', 'コクワガタ',             'Dorcus rectus',                   'クワガタ', '国産',   NULL, NULL),
  ('AKAASI', 'アカアシクワガタ',       'Dorcus rubrofemoratus',           'クワガタ', '国産',   NULL, NULL),
  ('NEBUTO', 'ネブトクワガタ',         'Aegus laevicollis',               'クワガタ', '国産',   NULL, NULL),
  ('SUJI',   'スジクワガタ',           'Dorcus striatipennis',            'クワガタ', '国産',   NULL, NULL),
  ('ONIKU',  'オニクワガタ',           'Dorcus japonicus',                'クワガタ', '国産',   NULL, NULL);

-- ─────────────────────────────────────────────────────────────────
-- 外国産クワガタ
-- ─────────────────────────────────────────────────────────────────
INSERT INTO species_master (code, name_ja, name_scientific, category, origin, regulation_note, regulation_sources) VALUES
  ('HOPEY',
   'ホペイオオクワガタ', 'Dorcus hopei hopei', 'クワガタ', '外国産',
   '輸入には植物防疫法に基づく検疫手続きが必要',
   '[{"name":"農林水産省植物防疫所","url":"https://www.maff.go.jp/pps/"},{"name":"農林水産省 植物防疫法の概要","url":"https://www.maff.go.jp/j/syouan/syokubo/boujyosyo/"}]'),

  ('NIJIRO',
   'ニジイロクワガタ', 'Phalacrognathus muelleri', 'クワガタ', '外国産',
   '原産国（オーストラリア・PNG）での採集・輸出は現地法で禁止。日本国内のブリード品の飼育・流通は合法。輸入には植物防疫法に基づく検疫手続きが必要',
   '[{"name":"農林水産省植物防疫所","url":"https://www.maff.go.jp/pps/"},{"name":"環境省 外来生物法","url":"https://www.env.go.jp/nature/intro/"}]'),

  ('ANTAE',
   'アンタエウスオオクワガタ', 'Dorcus antaeus', 'クワガタ', '外国産',
   '輸入には植物防疫法に基づく検疫手続きが必要',
   '[{"name":"農林水産省植物防疫所","url":"https://www.maff.go.jp/pps/"},{"name":"農林水産省 植物防疫法の概要","url":"https://www.maff.go.jp/j/syouan/syokubo/boujyosyo/"}]'),

  ('GIRAF',
   'ギラファノコギリクワガタ', 'Prosopocoilus giraffa', 'クワガタ', '外国産',
   '輸入には植物防疫法に基づく検疫手続きが必要',
   '[{"name":"農林水産省植物防疫所","url":"https://www.maff.go.jp/pps/"},{"name":"農林水産省 植物防疫法の概要","url":"https://www.maff.go.jp/j/syouan/syokubo/boujyosyo/"}]'),

  ('PALAWN',
   'パラワンオオヒラタクワガタ', 'Dorcus titanus palawanicus', 'クワガタ', '外国産',
   '輸入には植物防疫法に基づく検疫手続きが必要',
   '[{"name":"農林水産省植物防疫所","url":"https://www.maff.go.jp/pps/"},{"name":"農林水産省 植物防疫法の概要","url":"https://www.maff.go.jp/j/syouan/syokubo/boujyosyo/"}]'),

  ('SMATRA',
   'スマトラオオヒラタクワガタ', 'Dorcus titanus titanus', 'クワガタ', '外国産',
   '輸入には植物防疫法に基づく検疫手続きが必要',
   '[{"name":"農林水産省植物防疫所","url":"https://www.maff.go.jp/pps/"},{"name":"農林水産省 植物防疫法の概要","url":"https://www.maff.go.jp/j/syouan/syokubo/boujyosyo/"}]'),

  ('METALI',
   'メタリフェルホソアカクワガタ', 'Cyclommatus metallifer', 'クワガタ', '外国産',
   '輸入には植物防疫法に基づく検疫手続きが必要',
   '[{"name":"農林水産省植物防疫所","url":"https://www.maff.go.jp/pps/"},{"name":"農林水産省 植物防疫法の概要","url":"https://www.maff.go.jp/j/syouan/syokubo/boujyosyo/"}]'),

  ('TARAND',
   'タランドゥスオオツヤクワガタ', 'Mesotopus tarandus', 'クワガタ', '外国産',
   '輸入には植物防疫法に基づく検疫手続きが必要',
   '[{"name":"農林水産省植物防疫所","url":"https://www.maff.go.jp/pps/"},{"name":"農林水産省 植物防疫法の概要","url":"https://www.maff.go.jp/j/syouan/syokubo/boujyosyo/"}]'),

  ('REGIUS',
   'レギウスオオツヤクワガタ', 'Mesotopus regius', 'クワガタ', '外国産',
   '輸入には植物防疫法に基づく検疫手続きが必要',
   '[{"name":"農林水産省植物防疫所","url":"https://www.maff.go.jp/pps/"},{"name":"農林水産省 植物防疫法の概要","url":"https://www.maff.go.jp/j/syouan/syokubo/boujyosyo/"}]'),

  ('OUGON',
   'オウゴンオニクワガタ', 'Allotopus rosenbergi', 'クワガタ', '外国産',
   '輸入には植物防疫法に基づく検疫手続きが必要',
   '[{"name":"農林水産省植物防疫所","url":"https://www.maff.go.jp/pps/"},{"name":"農林水産省 植物防疫法の概要","url":"https://www.maff.go.jp/j/syouan/syokubo/boujyosyo/"}]'),

  ('MANDRA',
   'マンディブラリスフタマタクワガタ', 'Hexarthrius mandibularis', 'クワガタ', '外国産',
   '輸入には植物防疫法に基づく検疫手続きが必要',
   '[{"name":"農林水産省植物防疫所","url":"https://www.maff.go.jp/pps/"},{"name":"農林水産省 植物防疫法の概要","url":"https://www.maff.go.jp/j/syouan/syokubo/boujyosyo/"}]'),

  ('LACORD',
   'ラコダールツヤクワガタ', 'Odontolabis lacordairei', 'クワガタ', '外国産',
   '輸入には植物防疫法に基づく検疫手続きが必要',
   '[{"name":"農林水産省植物防疫所","url":"https://www.maff.go.jp/pps/"},{"name":"農林水産省 植物防疫法の概要","url":"https://www.maff.go.jp/j/syouan/syokubo/boujyosyo/"}]');

-- ─────────────────────────────────────────────────────────────────
-- 国産カブト
-- ─────────────────────────────────────────────────────────────────
INSERT INTO species_master (code, name_ja, name_scientific, category, origin, regulation_note, regulation_sources) VALUES
  ('KABUTO', 'カブトムシ', 'Trypoxylus dichotomus', 'カブト', '国産', NULL, NULL);

-- ─────────────────────────────────────────────────────────────────
-- 外国産カブト
-- ─────────────────────────────────────────────────────────────────
INSERT INTO species_master (code, name_ja, name_scientific, category, origin, regulation_note, regulation_sources) VALUES
  ('HERC',
   'ヘラクレスオオカブト', 'Dynastes hercules', 'カブト', '外国産',
   '輸入には植物防疫法に基づく検疫手続きが必要。亜種により産地証明が求められる場合あり',
   '[{"name":"農林水産省植物防疫所","url":"https://www.maff.go.jp/pps/"},{"name":"農林水産省 植物防疫法の概要","url":"https://www.maff.go.jp/j/syouan/syokubo/boujyosyo/"}]'),

  ('CAUCAS',
   'コーカサスオオカブト', 'Chalcosoma caucasus', 'カブト', '外国産',
   '輸入には植物防疫法に基づく検疫手続きが必要',
   '[{"name":"農林水産省植物防疫所","url":"https://www.maff.go.jp/pps/"},{"name":"農林水産省 植物防疫法の概要","url":"https://www.maff.go.jp/j/syouan/syokubo/boujyosyo/"}]'),

  ('ATLAS',
   'アトラスオオカブト', 'Chalcosoma atlas', 'カブト', '外国産',
   '輸入には植物防疫法に基づく検疫手続きが必要',
   '[{"name":"農林水産省植物防疫所","url":"https://www.maff.go.jp/pps/"},{"name":"農林水産省 植物防疫法の概要","url":"https://www.maff.go.jp/j/syouan/syokubo/boujyosyo/"}]'),

  ('ELEPH',
   'ゾウカブト', 'Megasoma elephas', 'カブト', '外国産',
   '輸入には植物防疫法に基づく検疫手続きが必要',
   '[{"name":"農林水産省植物防疫所","url":"https://www.maff.go.jp/pps/"},{"name":"農林水産省 植物防疫法の概要","url":"https://www.maff.go.jp/j/syouan/syokubo/boujyosyo/"}]'),

  ('MARS',
   'マルスゾウカブト', 'Megasoma mars', 'カブト', '外国産',
   '輸入には植物防疫法に基づく検疫手続きが必要',
   '[{"name":"農林水産省植物防疫所","url":"https://www.maff.go.jp/pps/"},{"name":"農林水産省 植物防疫法の概要","url":"https://www.maff.go.jp/j/syouan/syokubo/boujyosyo/"}]'),

  ('ACTAE',
   'アクタエオンゾウカブト', 'Megasoma actaeon', 'カブト', '外国産',
   '輸入には植物防疫法に基づく検疫手続きが必要',
   '[{"name":"農林水産省植物防疫所","url":"https://www.maff.go.jp/pps/"},{"name":"農林水産省 植物防疫法の概要","url":"https://www.maff.go.jp/j/syouan/syokubo/boujyosyo/"}]'),

  ('NEPTUN',
   'ネプチューンオオカブト', 'Dynastes neptunus', 'カブト', '外国産',
   '輸入には植物防疫法に基づく検疫手続きが必要',
   '[{"name":"農林水産省植物防疫所","url":"https://www.maff.go.jp/pps/"},{"name":"農林水産省 植物防疫法の概要","url":"https://www.maff.go.jp/j/syouan/syokubo/boujyosyo/"}]'),

  ('GRANTI',
   'グランティスシロカブト', 'Dynastes granti', 'カブト', '外国産',
   '輸入には植物防疫法に基づく検疫手続きが必要',
   '[{"name":"農林水産省植物防疫所","url":"https://www.maff.go.jp/pps/"},{"name":"農林水産省 植物防疫法の概要","url":"https://www.maff.go.jp/j/syouan/syokubo/boujyosyo/"}]');

-- 確認用
SELECT category, origin, COUNT(*) AS count
FROM species_master
GROUP BY category, origin
ORDER BY category, origin;
