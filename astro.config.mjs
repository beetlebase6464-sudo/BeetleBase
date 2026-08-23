import { defineConfig } from 'astro/config';
import cloudflare from '@astrojs/cloudflare';
import sitemap from '@astrojs/sitemap';

export default defineConfig({
  site: 'https://beetlebase.jp', // 本番ドメインに変更する
  output: 'static',              // 静的優先 + 必要なルートだけSSR
  adapter: cloudflare({
    platformProxy: { enabled: true }, // ローカルdev時にCloudflare環境をエミュレート
  }),
  integrations: [sitemap()],
  vite: {
    define: {
      // ビルド時定数（将来的にFeature Flagなどに使う）
    },
  },
});
