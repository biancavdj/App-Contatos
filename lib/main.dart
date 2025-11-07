import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'views/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ybblquouvjbfrzdsicna.supabase.co', 
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InliYmxxdW91dmpiZnJ6ZHNpY25hIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjAwNzU0MjMsImV4cCI6MjA3NTY1MTQyM30.o3fCe7bBjR77PtaEwIRJjuf0WCQ_2B6M6wrOYJQ1szQ',
  );

  runApp(const ContatoApp());
}