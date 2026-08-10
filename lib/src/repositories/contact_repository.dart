import '../models/contact_model.dart';

class ContactRepository {
  Future<bool> sendMessage(ContactModel contact) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
