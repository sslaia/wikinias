// This is used to make it possible to play audio files just by clicking it
// instead of opening a new page
String processWikiAudio(String html) {
  return html.replaceAllMapped(RegExp(r'<a href="([^"]+\.ogg)[^<]*</a>'),
      (match) => 'audio controls src="${match.group(1)}"></audio>',
  );
}