class ApiConfig {
  // static String baseUrl = "https://api.dazadev.online/api/"; // Producción
  static const String _baseUrl = "http://<my_ip>/api";
  static const String authUrl = "$_baseUrl/auth";

  Uri getResourceUri(String resource) => Uri.parse("$_baseUrl/$resource");
  Uri getAuthActionUri(String action) => Uri.parse("$authUrl/$action");
  Uri getUniqueResourceUri(String resource, String id) => Uri.parse("$_baseUrl/$resource/$id");
}