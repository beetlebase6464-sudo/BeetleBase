-- BeetleBase: コアテーブル（ブリーダー・個体・写真・移転履歴）
-- supabase/migrations/20260823_002_core_tables.sql

-- ────────────────────────────────────────────────────────────
-- ブリーダープロフィール
-- auth.users と 1:1 対応
-- ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS breeder_profiles (
  id              UUID         PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  breeder_code    VARCHAR(16)  NOT NULL UNIQUE,   -- IDに埋め込む（例: YAMADA042）
  display_name    VARCHAR(64)  NOT NULL,
  bio             TEXT,
  prefecture      VARCHAR(8),                      -- 都道府県
  created_at      TIMESTAMPTZ  NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- breeder_code: 半角英数・4〜16文字・重複不可
ALTER TABLE breeder_profiles
  ADD CONSTRAINT breeder_code_format CHECK (breeder_code ~ '^[A-Z0-9]{4,16}$');

-- ────────────────────────────────────────────────────────────
-- 個体レコード
-- ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS individuals (
  id             UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
  individual_id  VARCHAR(32)  NOT NULL UNIQUE,  -- 例: HOPEY-YAMADA042-001
  species_code   VARCHAR(8)   NOT NULL REFERENCES species_master(code),
  breeder_id     UUID         NOT NULL REFERENCES breeder_profiles(id),
  owner_id       UUID         NOT NULL REFERENCES breeder_profiles(id),
  sex            VARCHAR(4)   NOT NULL CHECK (sex IN ('オス', 'メス', '不明')),
  generation     VARCHAR(8),                    -- WD / WF1 / F2 など
  locality       TEXT,                          -- 産地（自由記述）
  bloodline_name TEXT,                          -- 血統名（自由記述）
  father_id      UUID         REFERENCES individuals(id),
  mother_id      UUID         REFERENCES individuals(id),
  hatched_at     DATE,                          -- 羽化日
  weight_g       NUMERIC(6,2),                  -- 体重（g）
  size_mm        NUMERIC(5,1),                  -- サイズ（mm）
  notes          TEXT,
  is_public      BOOLEAN      NOT NULL DEFAULT true,
  created_at     TIMESTAMPTZ  NOT NULL DEFAULT now(),
  updated_at     TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- individual_id 自動生成用シーケンス（種コード×ブリーダーごとの連番）
-- ※ アプリ側で LPAD(nextval(seq), 3, '0') を使って生成する

-- ────────────────────────────────────────────────────────────
-- 個体写真
-- ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS individual_photos (
  id             UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
  individual_id  UUID         NOT NULL REFERENCES individuals(id) ON DELETE CASCADE,
  storage_path   TEXT         NOT NULL,          -- Supabase Storage or R2 のパス
  caption        TEXT,
  taken_at       DATE,
  is_primary     BOOLEAN      NOT NULL DEFAULT false,
  created_at     TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- 1個体につき is_primary = true は1枚のみ（アプリ側で制御、DBはINDEX）
CREATE INDEX IF NOT EXISTS idx_photos_individual ON individual_photos(individual_id);

-- ────────────────────────────────────────────────────────────
-- 所有権移転履歴（改ざん防止: 削除・更新禁止前提）
-- ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS ownership_transfers (
  id               UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  individual_id    UUID        NOT NULL REFERENCES individuals(id),
  from_breeder_id  UUID        NOT NULL REFERENCES breeder_profiles(id),
  to_breeder_id    UUID        NOT NULL REFERENCES breeder_profiles(id),
  transferred_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  from_confirmed_at TIMESTAMPTZ,                  -- 譲渡側が承認した日時
  to_confirmed_at   TIMESTAMPTZ,                  -- 受領側が承認した日時
  notes            TEXT
);

-- 確認用
SELECT table_name FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;
