/**
 * species_master に関するデータ取得関数
 *
 * ページやコンポーネントからは必ずここ経由でアクセスする。
 * Supabase を別DBに差し替えたい場合もここだけ修正すればいい。
 */

import { supabase } from '@/lib/supabase';
import type { SpeciesMaster } from '@/types/database';

// ────────────────────────────────────────────────────────────
// フィルター型（URLパラメータと対応）
// ────────────────────────────────────────────────────────────
export interface SpeciesFilter {
  category?: 'クワガタ' | 'カブト';
  origin?:   '国産' | '外国産';
  query?:    string; // 和名・学名のフリーワード検索
}

// ────────────────────────────────────────────────────────────
// 全種取得（activeのみ）
// ────────────────────────────────────────────────────────────
export async function fetchAllSpecies(): Promise<SpeciesMaster[]> {
  const { data, error } = await supabase
    .from('species_master')
    .select('*')
    .eq('active', true)
    .order('category')
    .order('origin')
    .order('name_ja');

  if (error) throw new Error(`fetchAllSpecies: ${error.message}`);
  return data ?? [];
}

// ────────────────────────────────────────────────────────────
// フィルター付き取得
// ────────────────────────────────────────────────────────────
export async function fetchSpecies(filter: SpeciesFilter = {}): Promise<SpeciesMaster[]> {
  let query = supabase
    .from('species_master')
    .select('*')
    .eq('active', true);

  if (filter.category) query = query.eq('category', filter.category);
  if (filter.origin)   query = query.eq('origin',   filter.origin);
  if (filter.query) {
    // 和名 OR 学名でilike検索
    query = query.or(
      `name_ja.ilike.%${filter.query}%,name_scientific.ilike.%${filter.query}%`
    );
  }

  const { data, error } = await query
    .order('category')
    .order('origin')
    .order('name_ja');

  if (error) throw new Error(`fetchSpecies: ${error.message}`);
  return data ?? [];
}

// ────────────────────────────────────────────────────────────
// 1種取得（コードで引く）
// ────────────────────────────────────────────────────────────
export async function fetchSpeciesByCode(code: string): Promise<SpeciesMaster | null> {
  const { data, error } = await supabase
    .from('species_master')
    .select('*')
    .eq('code', code)
    .single();

  if (error) return null;
  return data;
}

// ────────────────────────────────────────────────────────────
// URLパラメータ → SpeciesFilter に変換するヘルパー
// ────────────────────────────────────────────────────────────
export function parseFilterFromParams(params: URLSearchParams): SpeciesFilter {
  const filter: SpeciesFilter = {};

  const category = params.get('category');
  if (category === 'クワガタ' || category === 'カブト') {
    filter.category = category;
  }

  const origin = params.get('origin');
  if (origin === '国産' || origin === '外国産') {
    filter.origin = origin;
  }

  const query = params.get('q');
  if (query?.trim()) filter.query = query.trim();

  return filter;
}
