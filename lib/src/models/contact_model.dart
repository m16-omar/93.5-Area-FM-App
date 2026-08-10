class ContactModel {
  final String name;
  final String email;
  final String phone;
  final String subject;
  final String message;

  const ContactModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.subject,
    required this.message,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      subject: json['subject'] ?? '',
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'subject': subject,
      'message': message,
    };
  }
}
