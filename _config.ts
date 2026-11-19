import lume from "@lumeland/lume";
import minifyHTML from "@lumeland/plugin-minify-html";
import sass from "@lumeland/plugin-sass";
import codeHighlight from "@lumeland/plugin-code-highlight";
import nunjucks from "@lumeland/plugin-nunjucks";
import jsx from "@lumeland/plugin-jsx";
import feed from "@lumeland/plugin-feed";
import esbuild from "@lumeland/plugin-esbuild";
import extractDate from "@lumeland/plugin-extract-date";

// See Supported Languages: https://github.com/highlightjs/highlight.js/blob/main/SUPPORTED_LANGUAGES.md
import lang_javascript from "highlight.js/lib/languages/javascript";
import lang_plaintext from "highlight.js/lib/languages/plaintext";
import lang_bash from "highlight.js/lib/languages/bash";

const site = lume();

// Lume 3+ ではプラグインが自動でファイルを読み込まないため明示的に追加する
site.add([".scss"]);
site.add("about/about.ts");
site.add([".png"]);

site.use(extractDate());
site.use(sass());
site.use(nunjucks());
site.use(jsx());
site.use(esbuild());
site.use(codeHighlight({
  languages: {
    javascript: lang_javascript,
    txt: lang_plaintext,
    bash: lang_bash,
  },
}));
site.use(feed({
  output: ["/blog.rss"],
  query: "blog",
  sort: "date=desc",
  limit: 10,
  info: {
    title: "=site.title",
    description: "=site.description",
    lang: "=language",
  },
}));
site.use(minifyHTML());

site.ignore("README.md");

export default site;
