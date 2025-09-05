# Руководство по мобильной разработке

## Обзор

Это руководство предоставляет комплексные инструкции по разработке мобильных приложений для платформы REChain DAO, включая React Native, Flutter, нативные приложения и интеграцию с бэкендом.

## Содержание

1. [Архитектура мобильных приложений](#архитектура-мобильных-приложений)
2. [Выбор технологий](#выбор-технологий)
3. [Настройка среды разработки](#настройка-среды-разработки)
4. [React Native разработка](#react-native-разработка)
5. [Flutter разработка](#flutter-разработка)
6. [Нативные приложения](#нативные-приложения)
7. [Интеграция с API](#интеграция-с-api)
8. [Push-уведомления](#push-уведомления)
9. [Тестирование](#тестирование)
10. [Публикация приложений](#публикация-приложений)

## Архитектура мобильных приложений

### Общая архитектура
```
┌─────────────────────────────────────────────────────────────┐
│                    Мобильное приложение                     │
├─────────────────────────────────────────────────────────────┤
│  Presentation Layer                                        │
│  ├── UI Components (React Native/Flutter/Native)          │
│  ├── Navigation (React Navigation/Flutter Router)         │
│  ├── State Management (Redux/Bloc/Provider)              │
│  └── Theming (Styled Components/Material Design)         │
├─────────────────────────────────────────────────────────────┤
│  Business Logic Layer                                      │
│  ├── Services (API, Storage, Notifications)              │
│  ├── Models (Data Models, DTOs)                          │
│  ├── Repositories (Data Access Layer)                    │
│  └── Use Cases (Business Logic)                          │
├─────────────────────────────────────────────────────────────┤
│  Data Layer                                                │
│  ├── Local Storage (SQLite, AsyncStorage)                │
│  ├── Cache (Redux Persist, Hive)                         │
│  ├── API Client (HTTP, WebSocket)                        │
│  └── Offline Support (Sync, Queue)                       │
├─────────────────────────────────────────────────────────────┤
│  Platform Layer                                            │
│  ├── Native Modules (iOS/Android)                        │
│  ├── Third-party SDKs                                    │
│  ├── Device APIs (Camera, GPS, Push)                     │
│  └── Platform-specific Code                               │
└─────────────────────────────────────────────────────────────┘
```

### Паттерны архитектуры
- **MVVM (Model-View-ViewModel)**
- **Clean Architecture**
- **Repository Pattern**
- **Dependency Injection**

## Выбор технологий

### React Native
**Преимущества:**
- Кроссплатформенная разработка
- Большое сообщество
- Горячая перезагрузка
- Нативные компоненты

**Недостатки:**
- Производительность ниже нативных
- Ограниченный доступ к нативным API
- Сложность отладки

### Flutter
**Преимущества:**
- Высокая производительность
- Единый код для всех платформ
- Красивый UI
- Быстрая разработка

**Недостатки:**
- Молодая экосистема
- Больший размер приложения
- Ограниченная поддержка плагинов

### Нативные приложения
**Преимущества:**
- Максимальная производительность
- Полный доступ к API
- Лучший UX
- Оптимизация для платформы

**Недостатки:**
- Двойная разработка
- Высокие затраты
- Сложность синхронизации

## Настройка среды разработки

### React Native
```bash
# Установка Node.js
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install node
nvm use node

# Установка React Native CLI
npm install -g @react-native-community/cli

# Установка Android Studio
# Скачайте с https://developer.android.com/studio

# Установка Xcode (только для macOS)
# Скачайте с App Store

# Создание проекта
npx react-native init REChainApp --template react-native-template-typescript

# Установка зависимостей
cd REChainApp
npm install

# Запуск на Android
npx react-native run-android

# Запуск на iOS
npx react-native run-ios
```

### Flutter
```bash
# Установка Flutter
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Установка Android Studio
# Скачайте с https://developer.android.com/studio

# Установка Xcode (только для macOS)
# Скачайте с App Store

# Создание проекта
flutter create rechain_app
cd rechain_app

# Запуск приложения
flutter run
```

## React Native разработка

### Структура проекта
```
src/
├── components/          # Переиспользуемые компоненты
│   ├── Button/
│   ├── Input/
│   └── Card/
├── screens/            # Экраны приложения
│   ├── Home/
│   ├── Profile/
│   └── Settings/
├── navigation/         # Навигация
│   ├── AppNavigator.tsx
│   └── AuthNavigator.tsx
├── services/           # Сервисы
│   ├── api.ts
│   ├── storage.ts
│   └── notifications.ts
├── store/              # Управление состоянием
│   ├── index.ts
│   ├── authSlice.ts
│   └── userSlice.ts
├── utils/              # Утилиты
│   ├── constants.ts
│   ├── helpers.ts
│   └── validation.ts
└── types/              # TypeScript типы
    ├── api.ts
    ├── user.ts
    └── navigation.ts
```

### Основной компонент
```typescript
// App.tsx
import React from 'react';
import {NavigationContainer} from '@react-navigation/native';
import {Provider} from 'react-redux';
import {store} from './src/store';
import AppNavigator from './src/navigation/AppNavigator';

const App: React.FC = () => {
  return (
    <Provider store={store}>
      <NavigationContainer>
        <AppNavigator />
      </NavigationContainer>
    </Provider>
  );
};

export default App;
```

### Навигация
```typescript
// navigation/AppNavigator.tsx
import React from 'react';
import {createStackNavigator} from '@react-navigation/stack';
import {useSelector} from 'react-redux';
import {RootState} from '../store';

// Screens
import HomeScreen from '../screens/Home/HomeScreen';
import ProfileScreen from '../screens/Profile/ProfileScreen';
import LoginScreen from '../screens/Auth/LoginScreen';

const Stack = createStackNavigator();

const AppNavigator: React.FC = () => {
  const isAuthenticated = useSelector((state: RootState) => state.auth.isAuthenticated);

  return (
    <Stack.Navigator screenOptions={{headerShown: false}}>
      {isAuthenticated ? (
        <>
          <Stack.Screen name="Home" component={HomeScreen} />
          <Stack.Screen name="Profile" component={ProfileScreen} />
        </>
      ) : (
        <Stack.Screen name="Login" component={LoginScreen} />
      )}
    </Stack.Navigator>
  );
};

export default AppNavigator;
```

### Управление состоянием (Redux Toolkit)
```typescript
// store/authSlice.ts
import {createSlice, createAsyncThunk} from '@reduxjs/toolkit';
import {authAPI} from '../services/api';

interface AuthState {
  isAuthenticated: boolean;
  user: User | null;
  loading: boolean;
  error: string | null;
}

const initialState: AuthState = {
  isAuthenticated: false,
  user: null,
  loading: false,
  error: null,
};

export const login = createAsyncThunk(
  'auth/login',
  async (credentials: {email: string; password: string}) => {
    const response = await authAPI.login(credentials);
    return response.data;
  }
);

export const logout = createAsyncThunk('auth/logout', async () => {
  await authAPI.logout();
});

const authSlice = createSlice({
  name: 'auth',
  initialState,
  reducers: {
    clearError: (state) => {
      state.error = null;
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(login.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(login.fulfilled, (state, action) => {
        state.loading = false;
        state.isAuthenticated = true;
        state.user = action.payload;
      })
      .addCase(login.rejected, (state, action) => {
        state.loading = false;
        state.error = action.error.message || 'Login failed';
      })
      .addCase(logout.fulfilled, (state) => {
        state.isAuthenticated = false;
        state.user = null;
      });
  },
});

export const {clearError} = authSlice.actions;
export default authSlice.reducer;
```

### API сервис
```typescript
// services/api.ts
import axios from 'axios';
import AsyncStorage from '@react-native-async-storage/async-storage';

const API_BASE_URL = 'https://api.rechain-dao.com';

const api = axios.create({
  baseURL: API_BASE_URL,
  timeout: 10000,
});

// Request interceptor
api.interceptors.request.use(
  async (config) => {
    const token = await AsyncStorage.getItem('auth_token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Response interceptor
api.interceptors.response.use(
  (response) => response,
  async (error) => {
    if (error.response?.status === 401) {
      await AsyncStorage.removeItem('auth_token');
      // Navigate to login screen
    }
    return Promise.reject(error);
  }
);

export const authAPI = {
  login: (credentials: {email: string; password: string}) =>
    api.post('/auth/login', credentials),
  logout: () => api.post('/auth/logout'),
  register: (userData: any) => api.post('/auth/register', userData),
};

export const userAPI = {
  getProfile: () => api.get('/user/profile'),
  updateProfile: (data: any) => api.put('/user/profile', data),
  uploadAvatar: (image: FormData) => api.post('/user/avatar', image),
};

export default api;
```

### Компонент экрана
```typescript
// screens/Home/HomeScreen.tsx
import React, {useEffect} from 'react';
import {
  View,
  Text,
  StyleSheet,
  FlatList,
  RefreshControl,
} from 'react-native';
import {useSelector, useDispatch} from 'react-redux';
import {RootState} from '../../store';
import {fetchPosts} from '../../store/postsSlice';
import PostCard from '../../components/PostCard/PostCard';

const HomeScreen: React.FC = () => {
  const dispatch = useDispatch();
  const {posts, loading, error} = useSelector((state: RootState) => state.posts);

  useEffect(() => {
    dispatch(fetchPosts());
  }, [dispatch]);

  const handleRefresh = () => {
    dispatch(fetchPosts());
  };

  const renderPost = ({item}: {item: Post}) => (
    <PostCard post={item} />
  );

  return (
    <View style={styles.container}>
      <Text style={styles.title}>REChain DAO</Text>
      <FlatList
        data={posts}
        renderItem={renderPost}
        keyExtractor={(item) => item.id.toString()}
        refreshControl={
          <RefreshControl refreshing={loading} onRefresh={handleRefresh} />
        }
        contentContainerStyle={styles.list}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f5f5f5',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    textAlign: 'center',
    marginVertical: 20,
  },
  list: {
    padding: 16,
  },
});

export default HomeScreen;
```

## Flutter разработка

### Структура проекта
```
lib/
├── main.dart
├── app/
│   ├── app.dart
│   └── routes.dart
├── core/
│   ├── constants/
│   ├── errors/
│   ├── network/
│   └── utils/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── home/
│   └── profile/
├── shared/
│   ├── widgets/
│   └── themes/
└── injection_container.dart
```

### Основной файл
```dart
// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthBloc>()),
        BlocProvider(create: (_) => di.sl<PostsBloc>()),
      ],
      child: MaterialApp(
        title: 'REChain DAO',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AppRouter(),
      ),
    );
  }
}
```

### BLoC для аутентификации
```dart
// features/auth/presentation/bloc/auth_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;
  final LogoutUsecase logoutUsecase;

  AuthBloc({
    required this.loginUsecase,
    required this.logoutUsecase,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await loginUsecase(
      LoginParams(email: event.email, password: event.password),
    );
    
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await logoutUsecase(NoParams());
    
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthInitial()),
    );
  }
}
```

### API сервис
```dart
// core/network/api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static const String baseUrl = 'https://api.rechain-dao.com';
  static const Duration timeout = Duration(seconds: 10);

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> get(String endpoint) async {
    final headers = await _getHeaders();
    return http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    ).timeout(timeout);
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    return http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: json.encode(data),
    ).timeout(timeout);
  }

  Future<http.Response> put(String endpoint, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    return http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: json.encode(data),
    ).timeout(timeout);
  }

  Future<http.Response> delete(String endpoint) async {
    final headers = await _getHeaders();
    return http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    ).timeout(timeout);
  }
}
```

## Push-уведомления

### React Native (Firebase)
```typescript
// services/notifications.ts
import messaging from '@react-native-firebase/messaging';
import {Platform} from 'react-native';

class NotificationService {
  async requestPermission(): Promise<boolean> {
    const authStatus = await messaging().requestPermission();
    const enabled =
      authStatus === messaging.AuthorizationStatus.AUTHORIZED ||
      authStatus === messaging.AuthorizationStatus.PROVISIONAL;

    if (enabled) {
      console.log('Authorization status:', authStatus);
    }

    return enabled;
  }

  async getToken(): Promise<string | null> {
    try {
      const token = await messaging().getToken();
      console.log('FCM Token:', token);
      return token;
    } catch (error) {
      console.error('Error getting FCM token:', error);
      return null;
    }
  }

  setupMessageHandlers() {
    // Handle background messages
    messaging().setBackgroundMessageHandler(async (remoteMessage) => {
      console.log('Message handled in the background!', remoteMessage);
    });

    // Handle foreground messages
    const unsubscribe = messaging().onMessage(async (remoteMessage) => {
      console.log('A new FCM message arrived!', remoteMessage);
      // Show local notification
      this.showLocalNotification(remoteMessage);
    });

    return unsubscribe;
  }

  private showLocalNotification(remoteMessage: any) {
    // Implementation for showing local notification
    // This depends on your notification library
  }
}

export default new NotificationService();
```

### Flutter (Firebase)
```dart
// services/notification_service.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Request permission
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    }

    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    
    await _localNotifications.initialize(initializationSettings);

    // Get FCM token
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');

    // Setup message handlers
    _setupMessageHandlers();
  }

  static void _setupMessageHandlers() {
    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        _showLocalNotification(message);
      }
    });
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}
```

## Тестирование

### React Native тестирование
```typescript
// __tests__/HomeScreen.test.tsx
import React from 'react';
import {render, fireEvent, waitFor} from '@testing-library/react-native';
import {Provider} from 'react-redux';
import {configureStore} from '@reduxjs/toolkit';
import HomeScreen from '../src/screens/Home/HomeScreen';
import postsSlice from '../src/store/postsSlice';

const createMockStore = (initialState = {}) => {
  return configureStore({
    reducer: {
      posts: postsSlice,
    },
    preloadedState: initialState,
  });
};

describe('HomeScreen', () => {
  it('renders correctly', () => {
    const store = createMockStore({
      posts: {
        posts: [],
        loading: false,
        error: null,
      },
    });

    const {getByText} = render(
      <Provider store={store}>
        <HomeScreen />
      </Provider>
    );

    expect(getByText('REChain DAO')).toBeTruthy();
  });

  it('shows loading indicator when loading', () => {
    const store = createMockStore({
      posts: {
        posts: [],
        loading: true,
        error: null,
      },
    });

    const {getByTestId} = render(
      <Provider store={store}>
        <HomeScreen />
      </Provider>
    );

    expect(getByTestId('loading-indicator')).toBeTruthy();
  });
});
```

### Flutter тестирование
```dart
// test/features/auth/presentation/bloc/auth_bloc_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:rechain_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:rechain_app/features/auth/presentation/bloc/auth_bloc.dart';

class MockLoginUsecase extends Mock implements LoginUsecase {}

void main() {
  late AuthBloc authBloc;
  late MockLoginUsecase mockLoginUsecase;

  setUp(() {
    mockLoginUsecase = MockLoginUsecase();
    authBloc = AuthBloc(loginUsecase: mockLoginUsecase);
  });

  group('AuthBloc', () {
    test('initial state should be AuthInitial', () {
      expect(authBloc.state, equals(AuthInitial()));
    });

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthSuccess] when login is successful',
      build: () {
        when(mockLoginUsecase(any))
            .thenAnswer((_) async => Right(User(id: '1', email: 'test@test.com')));
        return authBloc;
      },
      act: (bloc) => bloc.add(LoginRequested(email: 'test@test.com', password: 'password')),
      expect: () => [
        AuthLoading(),
        AuthSuccess(User(id: '1', email: 'test@test.com')),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when login fails',
      build: () {
        when(mockLoginUsecase(any))
            .thenAnswer((_) async => Left(ServerFailure('Server error')));
        return authBloc;
      },
      act: (bloc) => bloc.add(LoginRequested(email: 'test@test.com', password: 'password')),
      expect: () => [
        AuthLoading(),
        AuthError('Server error'),
      ],
    );
  });
}
```

## Публикация приложений

### Android (Google Play Store)
```bash
# Генерация подписанного APK
cd android
./gradlew assembleRelease

# Генерация AAB (рекомендуется)
./gradlew bundleRelease

# Загрузка в Google Play Console
# 1. Создайте аккаунт разработчика
# 2. Создайте приложение
# 3. Загрузите AAB файл
# 4. Заполните информацию о приложении
# 5. Отправьте на проверку
```

### iOS (App Store)
```bash
# Сборка для iOS
npx react-native run-ios --configuration Release

# Или для Flutter
flutter build ios --release

# Загрузка в App Store Connect
# 1. Создайте аккаунт разработчика
# 2. Создайте приложение в App Store Connect
# 3. Используйте Xcode для загрузки
# 4. Заполните информацию о приложении
# 5. Отправьте на проверку
```

## Заключение

Это руководство по мобильной разработке обеспечивает комплексные инструкции для создания мобильных приложений для платформы REChain DAO. Следуя этим рекомендациям и лучшим практикам, вы можете создавать высококачественные мобильные приложения, которые обеспечивают отличный пользовательский опыт.

Помните: всегда тестируйте приложения на реальных устройствах, следуйте рекомендациям платформ и учитывайте производительность и безопасность при разработке мобильных приложений.
