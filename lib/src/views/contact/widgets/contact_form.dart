import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/widgets/app_text_field.dart';
import '../../../../common/widgets/app_button.dart';
import '../../../../common/helpers/snackbar_helper.dart';
import '../../../models/contact_model.dart';
import '../../../providers/contact_provider.dart';

class ContactFormWidget extends ConsumerStatefulWidget {
  const ContactFormWidget({super.key});

  @override
  ConsumerState<ContactFormWidget> createState() => _ContactFormWidgetState();
}

class _ContactFormWidgetState extends ConsumerState<ContactFormWidget> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleSubmit() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _messageController.text.isEmpty) {
      SnackbarHelper.showError(context, 'Please fill in required fields');
      return;
    }

    setState(() => _isLoading = true);
    final contact = ContactModel(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      subject: _subjectController.text.trim(),
      message: _messageController.text.trim(),
    );

    try {
      await ref.read(contactRepositoryProvider).sendMessage(contact);
      if (mounted) {
        SnackbarHelper.showSuccess(context, 'Thank you! Your message has been sent.');
        _nameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _subjectController.clear();
        _messageController.clear();
      }
    } catch (e) {
      if (mounted) SnackbarHelper.showError(context, 'Failed to send message');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          controller: _nameController,
          labelText: 'Full Name *',
          hintText: 'John Doe',
        ),
        const SizedBox(height: 12),
        AppTextField(
          controller: _emailController,
          labelText: 'Email Address *',
          hintText: 'name@example.com',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 12),
        AppTextField(
          controller: _phoneController,
          labelText: 'Phone Number',
          hintText: '+234 800 000 0000',
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 12),
        AppTextField(
          controller: _subjectController,
          labelText: 'Subject',
          hintText: 'e.g. Song Request / Shoutout',
        ),
        const SizedBox(height: 12),
        AppTextField(
          controller: _messageController,
          labelText: 'Message *',
          hintText: 'Write your message here...',
          maxLines: 4,
        ),
        const SizedBox(height: 20),
        AppButton(
          title: 'Send Message',
          isLoading: _isLoading,
          onPressed: _handleSubmit,
        ),
      ],
    );
  }
}
