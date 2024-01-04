export const title = "Categories";

export default function ({ search }) {
  const aricles = search.pages("blog");
  const categoryMap = new Map();
  for (const article of aricles) {
    for (const category of article.data.categories) {
      categoryMap.set(category, undefined);
    }
  }

  const categories = [];
  for (const category of categoryMap.keys()) {
    categories.push(category);
  }
  return `<ul>${categories.sort().map((c) => `<li>${c}</li>`).join("")}</ul>`;
}
