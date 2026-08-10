import 'package:flutter/material.dart';
import '../../../../common/widgets/app_text_field.dart';
import '../../../../common/widgets/app_button.dart';
import '../../../../common/helpers/snackbar_helper.dart';

class SupportFormWidget extends StatefulWidget {
  const SupportFormWidget({super.key});

  @override
  State<SupportFormWidget> createState() => _SupportFormWidgetState();
}

class _SupportFormWidgetState extends State<SupportFormWidget> {
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleSubmit() async {
    if (_subjectController.text.isEmpty || _messageController.text.isEmpty) {
      SnackbarHelper.showError(context, 'Please fill in subject and message');
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isLoading = false);
      SnackbarHelper.showSuccess(context, 'Support ticket created successfully!');
      _subjectController.clear();
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Submit Support Ticket',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        AppTextField(
          controller: _subjectController,
          labelText: 'Issue Subject',
          hintText: 'e.g. Audio playback issue',
        ),
        const SizedBox(height: 12),
        AppTextField(
          controller: _messageController,
          labelText: 'Description',
          hintText: 'Describe the problem in detail...',
          maxLines: 4,
        ),
        const SizedBox(height: 16),
        AppButton(
          title: 'Send Ticket',
          isLoading: _isLoading,
          onPressed: _handleSubmit,
        ),
      ],
    );
  }
}
