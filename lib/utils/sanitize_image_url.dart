String sanitizeImageUrl(String url) {
  if (url.startsWith('file://')) {
    return url.replaceFirst('file://', 'https://');
  }
  if (url.startsWith('//')) {
    return 'https:$url';
  }
  if (!url.startsWith('http://') && !url.startsWith('https://')) {
    return 'https://$url';
  }
  return url;
}
