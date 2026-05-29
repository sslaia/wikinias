abstract class WikiLinkIntent {}

class NavigateToArticleIntent extends WikiLinkIntent {
  final String title;
  final bool isRedLink;
  NavigateToArticleIntent(this.title, {this.isRedLink = false});
}

class PlayAudioIntent extends WikiLinkIntent {
  final String audioUrl;
  PlayAudioIntent(this.audioUrl);
}

class OpenExternalUrlIntent extends WikiLinkIntent {
  final String url;
  OpenExternalUrlIntent(this.url);
}

class ShowReferenceIntent extends WikiLinkIntent {
  final String referenceId;
  ShowReferenceIntent(this.referenceId);
}

class IgnoreLinkIntent extends WikiLinkIntent {}
