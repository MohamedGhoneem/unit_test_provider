import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:unit_test_provider/article.dart';
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
  void arrangeNewsServiceReturns3ArticleAfter2SecondWait() {
    when(() => mockNewsService.getArticles()).thenAnswer(
            (_) async {
              await Future.delayed(const Duration(seconds: 2));
        return  articlesFromService;
        }
    );
  }

  test('get Articles using the NewsService', () async {
    arrangeNewsServiceReturns3Article();
    await mockNewsService.getArticles();
    // Verfiy that getArticles methode has been called for 1 time not more
    verify(() => mockNewsService.getArticles()).called(1);
  });
  Widget createWidgetUnderTest() {
    return MaterialApp(
      title: 'Flutter Demo',
      home: ChangeNotifierProvider(
        create: (_) => NewsChangeNotifier(mockNewsService),
        child: const NewsPage(),
      ),
    );
  }
  testWidgets(
    'title is displayed',
        (WidgetTester tester) async {
      arrangeNewsServiceReturns3Article();
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('News'), findsOneWidget);
    },
  );
  testWidgets('loading indicator is displayed while waiting for articles', (
      WidgetTester tester) async{
    arrangeNewsServiceReturns3ArticleAfter2SecondWait();
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byKey(const Key('progress-indicator')), findsOneWidget);
    await tester.pumpAndSettle();
  } );

  testWidgets('articles are displayed', (WidgetTester tester) async{
    arrangeNewsServiceReturns3Article();
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    for(final article in articlesFromService){
      expect(find.text(article.title), findsOneWidget);
      expect(find.text(article.content), findsOneWidget);
    }
  });
}
