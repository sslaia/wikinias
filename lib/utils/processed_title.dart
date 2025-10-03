String processedTitle(String title) {
  const prefixes = {
    'Help:': 5,
    'Fanolo:': 7,
    'Wikipedia:': 10,
    'Wiktionary:': 11,
    'Wikibooks:':10,
    'Special:':8,
    'Portal:':7,
  };

  for (var entry in prefixes.entries) {
    if (title.startsWith(entry.key)) {
      if (title.length > entry.value) {
        return title.substring(entry.value).trim();
      } else {
        return title;
      }
    }
  }
  return title.trim();
}
