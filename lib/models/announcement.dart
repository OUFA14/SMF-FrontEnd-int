class AnnouncementModel {
  final String id;
  final String title;
  final String message;
  final String priority;
  final String sender;
  final DateTime timestamp;
  bool isRead;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.message,
    required this.priority,
    required this.sender,
    required this.timestamp,
    this.isRead = false,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'].toString(),
      title: json['title'].toString(),
      message: json['message'].toString(),
      priority: json['priority'].toString(),
      sender: json['sender'].toString(),
      timestamp: DateTime.parse(json['timestamp'].toString()),
      isRead: json['isRead'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'message': message,
      'priority': priority,
      'sender': sender,
    };
  }
}