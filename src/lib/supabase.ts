import { createClient } from '@supabase/supabase-js';
import type { Database } from '@/types/database';

// ────────────────────────────────────────────────────────────
// ブラウザ・SSR 両対応の共有クライアント
// ────────────────────────────────────────────────────────────

const supabaseUrl = import.meta.env.PUBLIC_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.PUBLIC_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error('Supabase の環境変数が未設定です。.env.local を確認してください。');
}

/** 公開用クライアント（RLS が適用される） */
export const supabase = createClient<Database>(supabaseUrl, supabaseAnonKey);

// ────────────────────────────────────────────────────────────
// サーバーサイド専用クライアント（RLS をバイパス）
// API Route / Middleware でのみ使用する
// ────────────────────────────────────────────────────────────

export function createServiceClient() {
  const serviceKey = import.meta.env.SUPABASE_SERVICE_ROLE_KEY;
  if (!serviceKey) {
    throw new Error('SUPABASE_SERVICE_ROLE_KEY が未設定です（サーバーサイド専用）');
  }
  return createClient<Database>(supabaseUrl, serviceKey, {
    auth: { persistSession: false },
  });
}
