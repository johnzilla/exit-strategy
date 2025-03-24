import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config.dart';
import '../services/subscription_service.dart';
import '../services/settings_service.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({Key? key}) : super(key: key);

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Load settings when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settingsService = Provider.of<SettingsService>(context, listen: false);
      _nameController.text = settingsService.settings.vipContactName;
      _phoneController.text = settingsService.settings.vipPhoneNumber.isEmpty
          ? "+1234567890"
          : settingsService.settings.vipPhoneNumber;
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      setState(() {
        _errorMessage = 'Could not launch $url';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionService = Provider.of<SubscriptionService>(context);
    final isPremium = subscriptionService.isPremiumUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // VIP Contact Setup
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'VIP Contact Setup',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This is the contact that will appear to be calling or texting you.',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Contact Name',
                        border: OutlineInputBorder(),
                        helperText: 'Example: Mom, Boss, etc.',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Twilio Phone Number',
                        border: OutlineInputBorder(),
                        helperText: 'The Twilio number assigned to you',
                        prefixText: '+',
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('Save Contact'),
                      onPressed: _isLoading
                          ? null
                          : () async {
                              setState(() {
                                _isLoading = true;
                                _errorMessage = null;
                              });
                              
                              try {
                                final settingsService = Provider.of<SettingsService>(context, listen: false);
                                
                                // Remove any non-digit characters from phone number
                                final phoneNumber = _phoneController.text.replaceAll(RegExp(r'[^\d+]'), '');
                                
                                // Validate inputs
                                if (_nameController.text.trim().isEmpty) {
                                  throw Exception('Contact name cannot be empty');
                                }
                                
                                if (phoneNumber.isEmpty) {
                                  throw Exception('Phone number cannot be empty');
                                }
                                
                                // Save contact information
                                await settingsService.updateVipContact(
                                  name: _nameController.text.trim(),
                                  phoneNumber: phoneNumber,
                                );
                                
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Contact saved successfully!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              } catch (e) {
                                setState(() {
                                  _errorMessage = e.toString();
                                });
                              } finally {
                                if (mounted) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              }
                            },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Subscription Management
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Subscription',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: const Text('Current Plan'),
                      subtitle: Text(
                        isPremium ? 'Premium (\$${Config.subscriptionPrice}/month)' : 'Free',
                        style: TextStyle(
                          color: isPremium ? Colors.amber[800] : null,
                          fontWeight: isPremium ? FontWeight.bold : null,
                        ),
                      ),
                      trailing: isPremium
                          ? const Icon(Icons.star, color: Colors.amber)
                          : null,
                    ),
                    const Divider(),
                    if (isPremium)
                      ListTile(
                        title: const Text('Manage Subscription'),
                        subtitle: const Text('Cancel or update payment method'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // In a real app, this would open subscription management
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Subscription management would open here'),
                            ),
                          );
                        },
                      )
                    else
                      ListTile(
                        title: const Text('Upgrade to Premium'),
                        subtitle: Text(
                          'Get custom messages and delayed rescues for \$${Config.subscriptionPrice}/month',
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          subscriptionService.startPurchase(context);
                        },
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Help & Support
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Help & Support',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.help_outline),
                      title: const Text('How to Use'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('How to Use Exit Strategy'),
                            content: const SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('1. Save the Twilio number as your VIP contact'),
                                  SizedBox(height: 8),
                                  Text('2. Select a rescue template'),
                                  SizedBox(height: 8),
                                  Text('3. Press "RESCUE ME NOW" when you need to escape'),
                                  SizedBox(height: 8),
                                  Text('4. Your phone will receive a call or text from your VIP contact'),
                                  SizedBox(height: 8),
                                  Text('5. Use this as an excuse to leave your situation'),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Got it'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.contact_support_outlined),
                      title: const Text('Contact Support'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        _launchUrl('mailto:support@exitstrategy.app');
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.privacy_tip_outlined),
                      title: const Text('Privacy Policy'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        _launchUrl('https://exitstrategy.app/privacy');
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.description_outlined),
                      title: const Text('Terms of Service'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        _launchUrl('https://exitstrategy.app/terms');
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            // Error message
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}