
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(EasyLogApp());
}

class EasyLogApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EasyLog',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void handleLogin(BuildContext context) {
    final email = emailController.text;
    final password = passwordController.text;
    if (email == 'admin@easylog.ch' && password == 'admin123') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => DashboardScreen(role: 'admin')));
    } else if (email == 'staff@easylog.ch' && password == 'staff123') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => DashboardScreen(role: 'staff')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login fehlgeschlagen')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('EasyLog Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'E-Mail')),
            TextField(controller: passwordController, obscureText: true, decoration: InputDecoration(labelText: 'Passwort')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () => handleLogin(context), child: Text('Login'))
          ],
        ),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  final String role;
  DashboardScreen({required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard ($role)')),
      body: ListView(
        children: [
          ListTile(
            title: Text('📋 ChangeBoard'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChangeBoardScreen())),
          ),
          ListTile(
            title: Text('📝 Journal'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => JournalScreen())),
          )
        ],
      ),
    );
  }
}

class ChangeBoardScreen extends StatefulWidget {
  @override
  _ChangeBoardScreenState createState() => _ChangeBoardScreenState();
}

class _ChangeBoardScreenState extends State<ChangeBoardScreen> {
  final postController = TextEditingController();
  late stt.SpeechToText _speech;
  bool isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => isListening = true);
      _speech.listen(onResult: (result) {
        setState(() {
          postController.text += " " + result.recognizedWords;
        });
      });
    }
  }

  void stopListening() {
    _speech.stop();
    setState(() => isListening = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ChangeBoard')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: postController, decoration: InputDecoration(hintText: 'Änderung eingeben...')),
            Row(
              children: [
                ElevatedButton(onPressed: startListening, child: Text('🎤 Sprich')),
                SizedBox(width: 10),
                ElevatedButton(onPressed: stopListening, child: Text('🛑 Stop')),
              ],
            ),
            SizedBox(height: 12),
            ElevatedButton(onPressed: () {}, child: Text('Eintrag speichern'))
          ],
        ),
      ),
    );
  }
}

class JournalScreen extends StatefulWidget {
  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final journalController = TextEditingController();
  late stt.SpeechToText _speech;
  bool isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => isListening = true);
      _speech.listen(onResult: (result) {
        setState(() {
          journalController.text += " " + result.recognizedWords;
        });
      });
    }
  }

  void stopListening() {
    _speech.stop();
    setState(() => isListening = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Journal')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: journalController, decoration: InputDecoration(hintText: 'Was ist passiert?')),
            Row(
              children: [
                ElevatedButton(onPressed: startListening, child: Text('🎤 Sprich')),
                SizedBox(width: 10),
                ElevatedButton(onPressed: stopListening, child: Text('🛑 Stop')),
              ],
            ),
            SizedBox(height: 12),
            ElevatedButton(onPressed: () {}, child: Text('Mit GPT umformulieren'))
          ],
        ),
      ),
    );
  }
}
