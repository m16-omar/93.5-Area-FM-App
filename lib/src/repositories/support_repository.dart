class SupportRepository {
  Future<bool> submitSupportTicket(String subject, String message) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
