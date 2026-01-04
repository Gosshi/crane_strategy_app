import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crane_strategy_app/data/repositories/firebase_auth_repository.dart';

@GenerateNiceMocks([
  MockSpec<FirebaseAuth>(),
  MockSpec<User>(),
  MockSpec<UserCredential>(),
])
import 'auth_repository_test.mocks.dart';

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late FirebaseAuthRepository repository;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    repository = FirebaseAuthRepository(mockFirebaseAuth);
  });

  group('FirebaseAuthRepository', () {
    test('current user returns correct user', () {
      final mockUser = MockUser();
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      expect(repository.currentUser, mockUser);
    });

    test('accessing authStateChanges returns stream', () {
      when(
        mockFirebaseAuth.authStateChanges(),
      ).thenAnswer((_) => Stream.value(null));
      expect(repository.authStateChanges, isA<Stream<User?>>());
    });

    test('signInAnonymously calls delegate', () async {
      final mockCredential = MockUserCredential();
      when(
        mockFirebaseAuth.signInAnonymously(),
      ).thenAnswer((_) async => mockCredential);

      final result = await repository.signInAnonymously();

      verify(mockFirebaseAuth.signInAnonymously()).called(1);
      expect(result, mockCredential);
    });

    test('signOut calls delegate', () async {
      await repository.signOut();
      verify(mockFirebaseAuth.signOut()).called(1);
    });
  });
}
