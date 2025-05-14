import 'package:flutter/material.dart';
import 'first_screen.dart';

void main() {
  runApp( LiverDiagnosisApp());
}

class LiverDiagnosisApp extends StatelessWidget {
  const LiverDiagnosisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liver Diagnosis App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Roboto',
      ),
      home: const FirstScreen(), 
    );
  }
}
