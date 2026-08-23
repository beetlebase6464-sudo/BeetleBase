// ────────────────────────────────────────────────────────────
// BeetleBase Supabase 型定義
// Supabase CLI の `supabase gen types typescript` で自動生成されるものと
// 同じ形式。初期はこの手書き版を使い、DB が安定したら CLI生成に切り替える。
// ────────────────────────────────────────────────────────────

export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[];

export interface RegulationSource {
  name: string;
  url: string;
}

export interface Database {
  public: {
    Tables: {
      // ────── 種コードマスター ──────────────────────────────
      species_master: {
        Row: {
          code: string;               // PRIMARY KEY, VARCHAR(8)
          name_ja: string;            // 和名（カタカナ）
          name_scientific: string;    // 学名
          category: 'クワガタ' | 'カブト';
          origin: '国産' | '外国産';
          regulation_note: string | null;
          regulation_sources: RegulationSource[] | null; // JSONB
          active: boolean;
          created_at: string;
        };
        Insert: Omit<Database['public']['Tables']['species_master']['Row'], 'created_at'>;
        Update: Partial<Database['public']['Tables']['species_master']['Insert']>;
      };

      // ────── ブリーダープロフィール ────────────────────────
      // auth.users と 1:1 対応
      breeder_profiles: {
        Row: {
          id: string;                 // auth.users.id と一致（UUID）
          breeder_code: string;       // 例: YAMADA042（IDに埋め込まれる）
          display_name: string;
          bio: string | null;
          prefecture: string | null;
          created_at: string;
          updated_at: string;
        };
        Insert: Omit<Database['public']['Tables']['breeder_profiles']['Row'], 'created_at' | 'updated_at'>;
        Update: Partial<Database['public']['Tables']['breeder_profiles']['Insert']>;
      };

      // ────── 個体レコード ──────────────────────────────────
      individuals: {
        Row: {
          id: string;                 // UUID（内部PK）
          individual_id: string;      // 例: HOPEY-YAMADA042-001（表示用・ユニーク）
          species_code: string;       // → species_master.code
          breeder_id: string;         // → breeder_profiles.id
          owner_id: string;           // 現在のオーナー（転売後は変わる）
          sex: 'オス' | 'メス' | '不明';
          generation: string | null;  // 例: F2, WD, WF1
          locality: string | null;    // 産地
          bloodline_name: string | null;
          father_id: string | null;   // → individuals.id
          mother_id: string | null;   // → individuals.id
          hatched_at: string | null;  // 羽化日
          weight_g: number | null;    // 体重（g）
          size_mm: number | null;     // サイズ（mm）
          notes: string | null;
          is_public: boolean;         // 公開/非公開
          created_at: string;
          updated_at: string;
        };
        Insert: Omit<Database['public']['Tables']['individuals']['Row'], 'id' | 'created_at' | 'updated_at'>;
        Update: Partial<Database['public']['Tables']['individuals']['Insert']>;
      };

      // ────── 個体写真 ──────────────────────────────────────
      individual_photos: {
        Row: {
          id: string;
          individual_id: string;      // → individuals.id
          storage_path: string;       // Cloudflare R2 or Supabase Storage のパス
          caption: string | null;
          taken_at: string | null;
          is_primary: boolean;
          created_at: string;
        };
        Insert: Omit<Database['public']['Tables']['individual_photos']['Row'], 'id' | 'created_at'>;
        Update: Partial<Database['public']['Tables']['individual_photos']['Insert']>;
      };

      // ────── 所有権移転履歴 ───────────────────────────────
      ownership_transfers: {
        Row: {
          id: string;
          individual_id: string;      // → individuals.id
          from_breeder_id: string;
          to_breeder_id: string;
          transferred_at: string;
          from_confirmed_at: string | null;
          to_confirmed_at: string | null;
          notes: string | null;
        };
        Insert: Omit<Database['public']['Tables']['ownership_transfers']['Row'], 'id'>;
        Update: Partial<Database['public']['Tables']['ownership_transfers']['Insert']>;
      };
    };
    Views: {};
    Functions: {};
    Enums: {};
  };
}

// ────────────────────────────────────────────────────────────
// 便利な型エイリアス
// ────────────────────────────────────────────────────────────
export type SpeciesMaster = Database['public']['Tables']['species_master']['Row'];
export type BreederProfile = Database['public']['Tables']['breeder_profiles']['Row'];
export type Individual = Database['public']['Tables']['individuals']['Row'];
export type IndividualPhoto = Database['public']['Tables']['individual_photos']['Row'];
export type OwnershipTransfer = Database['public']['Tables']['ownership_transfers']['Row'];
