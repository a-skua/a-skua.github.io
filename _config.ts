import lume from "lume/mod.ts";

const site = lume({
  // TODO
});

site.copy("index.html");
site.copy("404.html");
site.ignore("README.md");

export default site;
