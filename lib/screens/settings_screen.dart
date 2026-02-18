import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_lg_starter_kit/providers/lg_provider.dart';
import 'package:flutter_lg_starter_kit/models/lg_config.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _ipController;
  late TextEditingController _userController;
  late TextEditingController _passController;
  late TextEditingController _portController;

  @override
  void initState() {
    super.initState();
    final lg = Provider.of<LGProvider>(context, listen: false);
    _ipController = TextEditingController(text: lg.config?.ip ?? '');
    _userController = TextEditingController(text: lg.config?.username ?? 'lg');
    _passController = TextEditingController(text: lg.config?.password ?? 'lg');
    _portController = TextEditingController(
      text: lg.config?.port.toString() ?? '22',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LG Configuration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _ipController,
                decoration: const InputDecoration(labelText: 'IP Address'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _portController,
                decoration: const InputDecoration(labelText: 'SSH Port'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _userController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextFormField(
                controller: _passController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final config = LGConfig(
                      ip: _ipController.text,
                      port: int.parse(_portController.text),
                      username: _userController.text,
                      password: _passController.text,
                      screens: 3,
                    );
                    final success = await Provider.of<LGProvider>(
                      context,
                      listen: false,
                    ).connect(config);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          success ? 'Connected!' : 'Connection Failed',
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Save and Connect'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
