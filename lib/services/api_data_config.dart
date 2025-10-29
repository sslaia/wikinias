// ApiService will call this class
class ApiDataConfig {
  final String remoteUrl;
  final String cacheKey;
  final String bundleAssetPath;

  const ApiDataConfig({
    required this.remoteUrl,
    required this.cacheKey,
    required this.bundleAssetPath,
  });
}
