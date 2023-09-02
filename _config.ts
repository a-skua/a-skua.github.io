import lume from "lume/mod.ts";
import minifyHTML from "lume/plugins/minify_html.ts";

const site = lume({
  // TODO
});

site.use(minifyHTML());

site.copy("404.html");
site.ignore("README.md");

export default site;
