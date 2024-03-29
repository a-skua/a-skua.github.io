import lume from "lume/mod.ts";
import minifyHTML from "lume/plugins/minify_html.ts";
import toml from "lume/plugins/toml.ts";
import sass from "lume/plugins/sass.ts";
import codeHighlight from "lume/plugins/code_highlight.ts";
import nunjucks from "lume/plugins/nunjucks.ts";
import jsx from "lume/plugins/jsx.ts";
import feed from "lume/plugins/feed.ts";
import esbuild from "lume/plugins/esbuild.ts";

// See Supported Languages: https://github.com/highlightjs/highlight.js/blob/main/SUPPORTED_LANGUAGES.md
import lang_javascript from "npm:highlight.js/lib/languages/javascript";
import lang_plaintext from "npm:highlight.js/lib/languages/plaintext";
import lang_bash from "npm:highlight.js/lib/languages/bash";

const site = lume();

site.use(minifyHTML());
site.use(toml());
site.use(sass());
site.use(nunjucks());
site.use(jsx());
site.use(esbuild());
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
site.use(codeHighlight({
  languages: {
    javascript: lang_javascript,
    txt: lang_plaintext,
    bash: lang_bash,
  },
}));

site.copy([".png"]);

site.ignore("README.md");

export default site;
