import lume from "lume/mod.ts";
import minifyHTML from "lume/plugins/minify_html.ts";
import toml from "lume/plugins/toml.ts";
import sass from "lume/plugins/sass.ts";
import codeHighlight from "lume/plugins/code_highlight.ts";

// See Supported Languages: https://github.com/highlightjs/highlight.js/blob/main/SUPPORTED_LANGUAGES.md
import lang_javascript from "npm:highlight.js/lib/languages/javascript";
import lang_plaintext from "npm:highlight.js/lib/languages/plaintext";


const site = lume({
  // TODO
});

site.use(minifyHTML());
site.use(toml());
site.use(sass());
site.use(codeHighlight({
  js: lang_javascript,
  txt: lang_plaintext,
}));

site.ignore("README.md");

export default site;
