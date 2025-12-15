class SupportTicket {
  String id;
  String title;
  String desc;
  String status;
  DateTime createdAt;
  String? attachment;
  SupportTicket({
    required this.id,
    required this.title,
    required this.desc,
    required this.status,
    required this.createdAt,
    this.attachment,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'desc': desc,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'attachment': attachment,
    };
  }

  factory SupportTicket.fromMap(Map<String, dynamic> map) {
    return SupportTicket(
      id: map['_id'] as String,
      title: map['title'] as String,
      desc: map['desc'] as String,
      status: map['status'] as String,
      createdAt: DateTime.parse(map['createdAt'].toString()).toLocal(),
      attachment:
          map['attachment'] != null ? map['attachment'] as String : null,
    );
  }
}
