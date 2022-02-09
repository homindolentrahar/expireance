class SettingsModel {
  bool enableNotification;

  SettingsModel({
    required this.enableNotification,
  });

  @override
  String toString() {
    return """
    {
        "enableNotification: $enableNotification"
    }
    """;
  }
}
