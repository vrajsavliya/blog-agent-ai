class JsonHelper {
  static String safeString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is List) return value.map((e) => e.toString()).join('\n');
    return value.toString();
  }

  static List<String> safeList(dynamic value) {
    if (value == null) return [];
    if (value is List) return value.map((e) => safeString(e)).toList();
    if (value is String) return [value];
    return [value.toString()];
  }
}
