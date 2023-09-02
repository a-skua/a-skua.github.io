import lume from "lume/mod.ts";
import minifyHTML from "lume/plugins/minify_html.ts";
import toml from "lume/plugins/toml.ts";
import sass from "lume/plugins/sass.ts";

const site = lume({
  // TODO
});

site.use(minifyHTML());
site.use(toml());
site.use(sass());

site.ignore("README.md");

export default site;
