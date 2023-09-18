import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_test_provider/article.dart';
import 'package:unit_test_provider/news_change_notifire.dart';
import 'package:unit_test_provider/news_service.dart';

///================================== UNIT TEST ==================================

/// Create Mock class without using mocktail plugin
// class BadMockNewService implements NewsService {
//   bool getArticlesCalled = false;
//
//   @override
//   Future<List<Article>> getArticles() async {
//     getArticlesCalled = true;
//     return [
//       Article(title: 'test 1', content: 'test 1 content'),
//       Article(title: 'test 2', content: 'test 2 content'),
//       Article(title: 'test 3', content: 'test 3 content'),
//     ];
//   }
// }

/// Create Mock class using mocktail plugin
class MockNewsService extends Mock implements NewsService {}

void main() {
  late NewsChangeNotifier sut;

  /// sut means system under test
  late MockNewsService mockNewsService;

  setUp(() {
    mockNewsService = MockNewsService();
    sut = NewsChangeNotifier(mockNewsService);
  });

  test(
    'initial values are correct',
    () {
      expect(sut.articles, []);
      expect(sut.isLoading, false);
    },
  );

  group('getArticles', () {
    final articlesFromService=[
      Article(title: 'Test 1', content: 'Test 1 content'),
      Article(title: 'Test 2', content: 'Test 2 content'),
      Article(title: 'Test 3', content: 'Test 3 content'),
    ];
    void arrangeNewsServiceReturns3Article() {
      when(() => mockNewsService.getArticles()).thenAnswer(
        (_) async => articlesFromService,
      );
    }

    test('get Articles using the NewsService', () async {
      arrangeNewsServiceReturns3Article();
      await sut.getArticles();
      // Verfiy that getArticles methode has been called for 1 time not more
      verify(() => mockNewsService.getArticles()).called(1);
    });

    test("""indicates loading of data,
    sets articles to the once from the service,
    indicates that data is not being loaded anymore""", () async {
      arrangeNewsServiceReturns3Article();
      final future = sut.getArticles();
      expect(sut.isLoading, true);
      await future;
      expect(
        sut.articles,
        articlesFromService,
      );
      expect(sut.isLoading, false);

    });
  });
}

/// code snippet to create test class
