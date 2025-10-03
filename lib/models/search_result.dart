import 'dart:convert';

/// Decodes a JSON string into a WikiResponse object.
WikiResponse wikiResponseFromJson(String str) =>
    WikiResponse.fromJson(json.decode(str));

/// The root object of the Wikipedia API response.
class WikiResponse {
  final Query? query;

  WikiResponse({
    this.query,
  });

  factory WikiResponse.fromJson(Map<String, dynamic> json) => WikiResponse(
    query: json["query"] == null ? null : Query.fromJson(json["query"]),
  );
}

/// Contains the list of search results.
class Query {
  final List<SearchResult> search;

  Query({
    required this.search,
  });

  factory Query.fromJson(Map<String, dynamic> json) => Query(
    search: json["search"] == null
        ? []
        : List<SearchResult>.from(
        json["search"].map((x) => SearchResult.fromJson(x))),
  );
}

/// Represents a single search result item.
class SearchResult {
  final int ns;
  final String title;
  final int pageid;
  final int size;
  final int wordcount;
  final String snippet;
  final DateTime timestamp;

  SearchResult({
    required this.ns,
    required this.title,
    required this.pageid,
    required this.size,
    required this.wordcount,
    required this.snippet,
    required this.timestamp,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) => SearchResult(
    ns: json["ns"],
    title: json["title"],
    pageid: json["pageid"],
    size: json["size"],
    wordcount: json["wordcount"],
    snippet: json["snippet"],
    timestamp: DateTime.parse(json["timestamp"]),
  );

  @override
  String toString() {
    return 'SearchResult(title: $title, pageid: $pageid, snippet: "$snippet")';
  }
}