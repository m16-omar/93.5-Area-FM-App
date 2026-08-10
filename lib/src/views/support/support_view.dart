import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../common/components/custom_app_bar.dart';
import '../../../common/helpers/url_helper.dart';
import '../../../const/app_constants.dart';
import 'widgets/support_option.dart';
import 'widgets/support_form.dart';

class SupportView extends StatelessWidget {
  const SupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AreaFMAppBar(title: 'Help & Support', showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How can we help you?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SupportOptionWidget(
              icon: Icons.contact_support_outlined,
              title: 'Contact Customer Desk',
              description: 'Send direct message to our support team',
              onTap: () => context.push('/contact'),
            ),
            SupportOptionWidget(
              icon: Icons.phone_forwarded_rounded,
              title: 'Call Support Line',
              description: AppConstants.contactPhone,
              onTap: () => UrlHelper.launchPhone(AppConstants.contactPhone),
            ),
            const Divider(height: 32),
            const SupportFormWidget(),
          ],
        ),
      ),
    );
  }
}
