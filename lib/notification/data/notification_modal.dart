class NotificationModal {
  final int id;
  final String title;
  final String body;

  NotificationModal({
    required this.id,
    required this.title,
    required this.body,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
    };
  }

  static NotificationModal fromMap(Map<String, dynamic> map) {
    return NotificationModal(
      id: map['id'],
      title: map['title'],
      body: map['body'],
    );
  }
}
