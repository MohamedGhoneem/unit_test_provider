import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:unit_test_provider/article.dart';
import 'package:unit_test_provider/article_page.dart';
import 'package:unit_test_provider/news_change_notifire.dart';
import 'package:unit_test_provider/news_page.dart';
import 'package:unit_test_provider/news_service.dart';

class MockNewsService extends Mock implements NewsService {}

void main() {
  late MockNewsService mockNewsService;

  setUp(() {
    mockNewsService = MockNewsService();
  });

  final articlesFromService = [
    Article(title: 'Test 1', content: 'Test 1 content'),
    Article(title: 'Test 2', content: 'Test 2 content'),
    Article(title: 'Test 3', content: 'Test 3 content'),
  ];
  void arrangeNewsServiceReturns3Article() {
    when(() => mockNewsService.getArticles()).thenAnswer(
      (_) async => articlesFromService,
    );
  }

  Widget createWidgetUnderTest() {
    return MaterialApp(
      title: 'Flutter Demo',
      home: ChangeNotifierProvider(
        create: (_) => NewsChangeNotifier(mockNewsService),
        child: const NewsPage(),
      ),
    );
  }

  testWidgets("""Tapping on the first article excerpt open the article 
  page where the full article content is displayed""",
      (WidgetTester tester) async {
    arrangeNewsServiceReturns3Article();

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.pump();
    await tester.tap(find.text('Test 1 content'));

    await tester .pumpAndSettle();
    expect(find.byType(NewsPage), findsOneWidget);
    expect(find.byType(ArticlePage), findsOneWidget);

    expect(find.text('Test 1'), findsOneWidget);
    expect(find.text('Test 1 content'), findsOneWidget);

  });
}
