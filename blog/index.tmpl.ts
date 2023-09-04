export default function* ({ search, paginate }) {
  const articles = search.pages("blog", "date=desc");
  const options = {
    url: (n: number)  => {
      if (n == 1) return "/blog/";
      return `/blog/page/${n}/`;
    },
    size: 10,
  };

  for (const page of paginate(articles, options)) {
    page.layout =  "layouts/paginate.njk";
    page.title = `Blog (${page.pagination.page} of ${page.pagination.totalPages})`;
    yield page;
  }
}

/*
---
layout: layouts/main.njk
title: Blog
---
<ul>
  {% for blog in search.pages("blog", "date=desc") %}
    <li>
    <a href="{{ blog.data.url }}">
      <h2>{{ blog.data.title }}</h2>
      <p>{{ blog.data.content.slice(0, 255) }}</p>
      <p>{{ blog.data.date.toISOString() }}</p>
      <p>{{ blog.data.categories }}</p>
    </a>
    </li>
  {% endfor %}
</ul>
*/
