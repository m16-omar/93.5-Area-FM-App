import 'package:flutter/material.dart';
import '../../../../common/widgets/app_text_field.dart';
import '../../../../common/widgets/app_button.dart';
import '../../../../common/helpers/snackbar_helper.dart';

class PromotionFormWidget extends StatefulWidget {
  const PromotionFormWidget({super.key});

  @override
  State<PromotionFormWidget> createState() => _PromotionFormWidgetState();
}

class _PromotionFormWidgetState extends State<PromotionFormWidget> {
  final _brandController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleSubmit() async {
    if (_brandController.text.isEmpty || _phoneController.text.isEmpty) {
      SnackbarHelper.showError(context, 'Please enter your brand name and phone');
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isLoading = false);
      SnackbarHelper.showSuccess(context, 'Advert inquiry submitted successfully!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Custom Advert Inquiry',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _brandController,
          labelText: 'Brand / Business Name',
          hintText: 'e.g. Acme Corporation',
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
          controller: _notesController,
          labelText: 'Advert Brief / Requirements',
          hintText: 'Describe your campaign goals...',
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        AppButton(
          title: 'Submit Inquiry',
          isLoading: _isLoading,
          onPressed: _handleSubmit,
        ),
      ],
    );
  }
}
