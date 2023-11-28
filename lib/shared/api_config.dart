class ApiConfig {
  static String _baseUrl = "https://api.dazadev.online/api/"; // Producción
  // static const String _baseUrl = "http://192.168.0.189:3000/api";
  static String authUrl = "$_baseUrl/auth";

  Uri getResourceUri(String resource) => Uri.parse("$_baseUrl/$resource");
  Uri getAuthActionUri(String action) => Uri.parse("$authUrl/$action");
  Uri getUniqueResourceUri(String resource, String id) => Uri.parse("$_baseUrl/$resource/$id");
}