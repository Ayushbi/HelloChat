class ContactModel {
  String id;
  String phone;

  ContactModel({required this.id, required this.phone});

  factory ContactModel.data(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'].toString(),
      phone: json['phone']?.toString() ?? '',
    );
  }
}
