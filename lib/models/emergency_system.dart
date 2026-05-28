class EmergencySystemStatus {
  final String systemStatus;
  final String communication;
  final String weather;
  final String network;
  final String lastUpdated;

  const EmergencySystemStatus({
    required this.systemStatus,
    required this.communication,
    required this.weather,
    required this.network,
    required this.lastUpdated,
  });

  factory EmergencySystemStatus.fromJson(Map<String, dynamic> json) {
    return EmergencySystemStatus(
      systemStatus: json['systemStatus']?.toString() ?? 'Unknown',
      communication: json['communication']?.toString() ?? 'Unknown',
      weather: json['weather']?.toString() ?? 'Unknown',
      network: json['network']?.toString() ?? 'Unknown',
      lastUpdated: json['lastUpdated']?.toString() ?? '--:--:--',
    );
  }
}
