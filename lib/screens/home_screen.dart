import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_lg_starter_kit/providers/lg_provider.dart';
import 'package:flutter_lg_starter_kit/services/gemini_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _queryController = TextEditingController();
  bool _isLoading = false;
  String? _agentOutput;

  Future<void> _handleAgenticTask() async {
    final query = _queryController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _agentOutput = "Agent is thinking...";
    });

    final gemini = GeminiService(dotenv.get('GEMINI_API_KEY'));
    final lgProvider = Provider.of<LGProvider>(context, listen: false);

    final response = await gemini.getVisualInstruction(query);
    if (response != null) {
      try {
        final data = jsonDecode(
          response.replaceAll('```json', '').replaceAll('```', ''),
        );
        setState(() {
          _agentOutput =
              "Agent: I'm flying you to ${data['location_name']}.\nTip: ${data['fun_fact']}";
        });
        await lgProvider.flyTo(
          data['latitude'],
          data['longitude'],
          zoom: data['zoom'].toDouble(),
        );
      } catch (e) {
        setState(() {
          _agentOutput =
              "Agent: Sorry, I couldn't parse the visual instructions.";
        });
      }
    } else {
      setState(() {
        _agentOutput = "Agent: Sorry, I encountered an error.";
      });
    }

    if (!context.mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final lgProvider = Provider.of<LGProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('LG Flutter Starter Kit'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildConnectionStatus(lgProvider),
            const SizedBox(height: 20),
            _buildAgentInterface(),
            const Spacer(),
            _buildQuickActions(lgProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionStatus(LGProvider lg) {
    return Card(
      color: lg.isConnected ? Colors.green.shade50 : Colors.red.shade50,
      child: ListTile(
        leading: Icon(
          lg.isConnected ? Icons.cloud_done : Icons.cloud_off,
          color: lg.isConnected ? Colors.green : Colors.red,
        ),
        title: Text(lg.isConnected ? 'Connected to LG' : 'Disconnected'),
        subtitle: Text(lg.config?.ip ?? 'No IP configured'),
      ),
    );
  }

  Widget _buildAgentInterface() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gemini Agent',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _queryController,
          decoration: InputDecoration(
            hintText: 'Where do you want to go?',
            suffixIcon: IconButton(
              icon: _isLoading
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.send),
              onPressed: _isLoading ? null : _handleAgenticTask,
            ),
            border: const OutlineInputBorder(),
          ),
        ),
        if (_agentOutput != null) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(_agentOutput!),
          ),
        ],
      ],
    );
  }

  Widget _buildQuickActions(LGProvider lg) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () => lg.clear(),
          icon: const Icon(Icons.clear_all),
          label: const Text('Clear KML'),
        ),
        ElevatedButton.icon(
          onPressed: () => lg.flyTo(0, 0, zoom: 10000000),
          icon: const Icon(Icons.public),
          label: const Text('Orbit Earth'),
        ),
      ],
    );
  }
}
