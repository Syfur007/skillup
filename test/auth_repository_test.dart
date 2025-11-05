import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:skillup/data/repositories/auth_repository_impl.dart';

import 'auth_repository_test.mocks.dart';

// Generate mocks for FirebaseAuth, UserCredential, and User
@GenerateMocks([FirebaseAuth, UserCredential, User])
void main() {
  late AuthRepositoryImpl authRepository;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    authRepository = AuthRepositoryImpl(firebaseAuth: mockFirebaseAuth);
  });

  group('signInWithEmail', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';

    test('should sign in successfully with valid credentials', () async {
      // Arrange
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      )).thenAnswer((_) async => mockUserCredential);

      // Act
      await authRepository.signInWithEmail(testEmail, testPassword);

      // Assert
      verify(mockFirebaseAuth.signInWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      )).called(1);
    });

    test('should throw exception when user not found', () async {
      // Arrange
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      )).thenThrow(
        FirebaseAuthException(code: 'user-not-found'),
      );

      // Act & Assert
      expect(
        () => authRepository.signInWithEmail(testEmail, testPassword),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('No user found with this email'),
        )),
      );
    });

    test('should throw exception when wrong password', () async {
      // Arrange
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      )).thenThrow(
        FirebaseAuthException(code: 'wrong-password'),
      );

      // Act & Assert
      expect(
        () => authRepository.signInWithEmail(testEmail, testPassword),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Wrong password provided'),
        )),
      );
    });

    test('should throw exception when email is invalid', () async {
      // Arrange
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      )).thenThrow(
        FirebaseAuthException(code: 'invalid-email'),
      );

      // Act & Assert
      expect(
        () => authRepository.signInWithEmail(testEmail, testPassword),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('The email address is not valid'),
        )),
      );
    });

    test('should throw exception when user is disabled', () async {
      // Arrange
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      )).thenThrow(
        FirebaseAuthException(code: 'user-disabled'),
      );

      // Act & Assert
      expect(
        () => authRepository.signInWithEmail(testEmail, testPassword),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('This user account has been disabled'),
        )),
      );
    });
  });

  group('signUp', () {
    const testEmail = 'newuser@example.com';
    const testPassword = 'password123';

    test('should create user successfully with valid credentials', () async {
      // Arrange
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      )).thenAnswer((_) async => mockUserCredential);

      // Act
      await authRepository.signUp(testEmail, testPassword);

      // Assert
      verify(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      )).called(1);
    });

    test('should throw exception when email already in use', () async {
      // Arrange
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      )).thenThrow(
        FirebaseAuthException(code: 'email-already-in-use'),
      );

      // Act & Assert
      expect(
        () => authRepository.signUp(testEmail, testPassword),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('An account already exists with this email'),
        )),
      );
    });

    test('should throw exception when password is weak', () async {
      // Arrange
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      )).thenThrow(
        FirebaseAuthException(code: 'weak-password'),
      );

      // Act & Assert
      expect(
        () => authRepository.signUp(testEmail, testPassword),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('The password is too weak'),
        )),
      );
    });

    test('should throw exception when email is invalid', () async {
      // Arrange
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      )).thenThrow(
        FirebaseAuthException(code: 'invalid-email'),
      );

      // Act & Assert
      expect(
        () => authRepository.signUp(testEmail, testPassword),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('The email address is not valid'),
        )),
      );
    });

    test('should throw exception when operation not allowed', () async {
      // Arrange
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      )).thenThrow(
        FirebaseAuthException(code: 'operation-not-allowed'),
      );

      // Act & Assert
      expect(
        () => authRepository.signUp(testEmail, testPassword),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Email/password accounts are not enabled'),
        )),
      );
    });
  });

  group('signOut', () {
    test('should sign out successfully', () async {
      // Arrange
      when(mockFirebaseAuth.signOut()).thenAnswer((_) async => {});

      // Act
      await authRepository.signOut();

      // Assert
      verify(mockFirebaseAuth.signOut()).called(1);
    });
  });

  group('resetPassword', () {
    const testEmail = 'test@example.com';

    test('should send password reset email successfully', () async {
      // Arrange
      when(mockFirebaseAuth.sendPasswordResetEmail(email: testEmail))
          .thenAnswer((_) async => {});

      // Act
      await authRepository.resetPassword(testEmail);

      // Assert
      verify(mockFirebaseAuth.sendPasswordResetEmail(email: testEmail))
          .called(1);
    });

    test('should throw exception when email is invalid', () async {
      // Arrange
      when(mockFirebaseAuth.sendPasswordResetEmail(email: testEmail))
          .thenThrow(
        FirebaseAuthException(code: 'invalid-email'),
      );

      // Act & Assert
      expect(
        () => authRepository.resetPassword(testEmail),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('The email address is not valid'),
        )),
      );
    });

    test('should throw exception when user not found', () async {
      // Arrange
      when(mockFirebaseAuth.sendPasswordResetEmail(email: testEmail))
          .thenThrow(
        FirebaseAuthException(code: 'user-not-found'),
      );

      // Act & Assert
      expect(
        () => authRepository.resetPassword(testEmail),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('No user found with this email'),
        )),
      );
    });
  });

  group('isSignedIn', () {
    test('should return true when user is signed in', () async {
      // Arrange
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

      // Act
      final result = await authRepository.isSignedIn();

      // Assert
      expect(result, true);
    });

    test('should return false when user is not signed in', () async {
      // Arrange
      when(mockFirebaseAuth.currentUser).thenReturn(null);

      // Act
      final result = await authRepository.isSignedIn();

      // Assert
      expect(result, false);
    });
  });

  group('getToken', () {
    const testToken = 'test-id-token-12345';

    test('should return token when user is signed in', () async {
      // Arrange
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.getIdToken()).thenAnswer((_) async => testToken);

      // Act
      final result = await authRepository.getToken();

      // Assert
      expect(result, testToken);
      verify(mockUser.getIdToken()).called(1);
    });

    test('should return null when user is not signed in', () async {
      // Arrange
      when(mockFirebaseAuth.currentUser).thenReturn(null);

      // Act
      final result = await authRepository.getToken();

      // Assert
      expect(result, null);
    });
  });
}

