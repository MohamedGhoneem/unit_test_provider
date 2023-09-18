import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unit_test_provider/news_service.dart';

import 'news_change_notifire.dart';
import 'news_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home:  ChangeNotifierProvider(
        create: (_)=>NewsChangeNotifier(NewsService()),
        child: const NewsPage(),
      ),
    );
  }
}
