export default function* ({ search, paginate }) {
  const articles = search.pages("blog", "date=desc");
  const options = {
    url: (n: number) => {
      if (n == 1) return "/blog/";
      return `/blog/page/${n}/`;
    },
    size: 10,
  };

  for (const page of paginate(articles, options)) {
    page.layout = "layouts/paginate.njk";
    page.title =
      `Blog (${page.pagination.page} of ${page.pagination.totalPages})`;
    yield page;
  }
}
