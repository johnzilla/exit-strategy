import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import '../models/rescue_template.dart';
import '../services/rescue_service.dart';
import '../services/settings_service.dart';
import '../services/subscription_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedTemplate = Config.defaultTemplates[0]['title']!;
  bool _isDelayed = false;
  int _delayMinutes = 5;
  bool _isSending = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final subscriptionService = Provider.of<SubscriptionService>(context);
    final rescueService = Provider.of<RescueService>(context, listen: false);
    final isPremium = subscriptionService.isPremiumUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exit Strategy'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/setup');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Template selection
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Rescue Template',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      value: _selectedTemplate,
                      items: Config.defaultTemplates
                          .map((template) => DropdownMenuItem(
                                value: template['title'],
                                child: Text(template['title']!),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedTemplate = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Message: ${Config.defaultTemplates.firstWhere((t) => t['title'] == _selectedTemplate)['message']}',
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Delay option (Premium only)
            if (isPremium)
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Delay Rescue',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Switch(
                            value: _isDelayed,
                            onChanged: (value) {
                              setState(() {
                                _isDelayed = value;
                              });
                            },
                          ),
                        ],
                      ),
                      if (_isDelayed) ...[
                        const SizedBox(height: 16),
                        const Text('Delay time (minutes):'),
                        Slider(
                          value: _delayMinutes.toDouble(),
                          min: 1,
                          max: 30,
                          divisions: 29,
                          label: _delayMinutes.toString(),
                          onChanged: (value) {
                            setState(() {
                              _delayMinutes = value.round();
                            });
                          },
                        ),
                        Text('Rescue will arrive in $_delayMinutes minutes'),
                      ],
                    ],
                  ),
                ),
              ),
            
            if (!isPremium)
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Premium Features',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Upgrade to Premium for custom messages and delayed rescues!',
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.star),
                          label: const Text('Upgrade to Premium'),
                          onPressed: () {
                            subscriptionService.startPurchase(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            const Spacer(),
            
            // Error message
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            
            // Rescue button
            SizedBox(
              height: 80,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.emergency, size: 32),
                label: _isSending
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'RESCUE ME NOW',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                onPressed: _isSending
                    ? null
                    : () async {
                        final template = Config.defaultTemplates.firstWhere(
                          (t) => t['title'] == _selectedTemplate,
                        );
                        
                        setState(() {
                          _isSending = true;
                          _errorMessage = null;
                        });
                        
                        try {
                          await rescueService.sendRescue(
                            message: template['message']!,
                            delayMinutes: _isDelayed && isPremium ? _delayMinutes : 0,
                          );
                          
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(_isDelayed && isPremium
                                    ? 'Rescue scheduled in $_delayMinutes minutes'
                                    : 'Rescue sent! Check your phone'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        } catch (e) {
                          setState(() {
                            _errorMessage = 'Failed to send rescue: ${e.toString()}';
                          });
                        } finally {
                          if (mounted) {
                            setState(() {
                              _isSending = false;
                            });
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}