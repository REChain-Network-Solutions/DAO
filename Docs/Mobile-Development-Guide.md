# Mobile Development Guide

## Overview

This guide provides comprehensive instructions for developing mobile applications for the REChain DAO platform, including React Native, Flutter, and native development approaches.

## Table of Contents

1. [Mobile Architecture](#mobile-architecture)
2. [Development Environment Setup](#development-environment-setup)
3. [React Native Development](#react-native-development)
4. [Flutter Development](#flutter-development)
5. [Native Development](#native-development)
6. [API Integration](#api-integration)
7. [Blockchain Integration](#blockchain-integration)
8. [Push Notifications](#push-notifications)
9. [Testing Mobile Apps](#testing-mobile-apps)
10. [Deployment and Distribution](#deployment-and-distribution)

## Mobile Architecture

### Architecture Overview
```
┌─────────────────────────────────────────────────────────────┐
│                    Mobile Application                       │
├─────────────────────────────────────────────────────────────┤
│  Presentation Layer (UI/UX)                                │
│  ├── Screens/Views                                          │
│  ├── Components                                             │
│  └── Navigation                                             │
├─────────────────────────────────────────────────────────────┤
│  Business Logic Layer                                       │
│  ├── State Management                                       │
│  ├── Business Rules                                         │
│  └── Data Processing                                        │
├─────────────────────────────────────────────────────────────┤
│  Data Layer                                                 │
│  ├── API Services                                           │
│  ├── Local Storage                                          │
│  ├── Caching                                                │
│  └── Blockchain Integration                                 │
├─────────────────────────────────────────────────────────────┤
│  Platform Layer                                             │
│  ├── Device APIs                                            │
│  ├── Push Notifications                                     │
│  ├── Camera/Gallery                                         │
│  └── Biometric Authentication                              │
└─────────────────────────────────────────────────────────────┘
```

### Technology Stack
- **Cross-Platform**: React Native, Flutter
- **Native**: Swift (iOS), Kotlin (Android)
- **State Management**: Redux, MobX, Provider
- **Navigation**: React Navigation, Flutter Navigation
- **HTTP Client**: Axios, Dio, Fetch
- **Database**: SQLite, Realm, Firebase
- **Blockchain**: Web3.js, ethers.js, WalletConnect

## Development Environment Setup

### Prerequisites
```bash
# Node.js and npm
node --version  # v16.0.0 or higher
npm --version   # v8.0.0 or higher

# React Native CLI
npm install -g @react-native-community/cli

# Flutter SDK
flutter --version  # 3.0.0 or higher

# Android Studio
# Xcode (for iOS development)
```

### Environment Configuration
```bash
# .env file
API_BASE_URL=https://api.rechain-dao.com
WS_BASE_URL=wss://ws.rechain-dao.com
BLOCKCHAIN_NETWORK=mainnet
INFURA_PROJECT_ID=your_infura_project_id
WALLET_CONNECT_PROJECT_ID=your_wallet_connect_project_id
PUSH_NOTIFICATION_KEY=your_push_notification_key
```

### Project Structure
```
mobile-app/
├── src/
│   ├── components/           # Reusable components
│   ├── screens/             # Screen components
│   ├── navigation/          # Navigation configuration
│   ├── services/            # API and external services
│   ├── store/               # State management
│   ├── utils/               # Utility functions
│   ├── constants/           # App constants
│   └── assets/              # Images, fonts, etc.
├── android/                 # Android-specific code
├── ios/                     # iOS-specific code
├── tests/                   # Test files
└── docs/                    # Documentation
```

## React Native Development

### Project Setup
```bash
# Create new React Native project
npx react-native init REChainMobile --template react-native-template-typescript

# Install dependencies
cd REChainMobile
npm install @react-navigation/native @react-navigation/stack
npm install react-native-screens react-native-safe-area-context
npm install @reduxjs/toolkit react-redux
npm install axios
npm install react-native-web3
npm install @walletconnect/react-native-dapp
```

### Navigation Setup
```typescript
// src/navigation/AppNavigator.tsx
import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createStackNavigator } from '@react-navigation/stack';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';

import HomeScreen from '../screens/HomeScreen';
import ProfileScreen from '../screens/ProfileScreen';
import WalletScreen from '../screens/WalletScreen';
import SettingsScreen from '../screens/SettingsScreen';

const Stack = createStackNavigator();
const Tab = createBottomTabNavigator();

const TabNavigator = () => {
  return (
    <Tab.Navigator
      screenOptions={{
        tabBarStyle: {
          backgroundColor: '#1a1a1a',
          borderTopColor: '#333',
        },
        tabBarActiveTintColor: '#007AFF',
        tabBarInactiveTintColor: '#666',
      }}
    >
      <Tab.Screen 
        name="Home" 
        component={HomeScreen}
        options={{ title: 'Home' }}
      />
      <Tab.Screen 
        name="Profile" 
        component={ProfileScreen}
        options={{ title: 'Profile' }}
      />
      <Tab.Screen 
        name="Wallet" 
        component={WalletScreen}
        options={{ title: 'Wallet' }}
      />
      <Tab.Screen 
        name="Settings" 
        component={SettingsScreen}
        options={{ title: 'Settings' }}
      />
    </Tab.Navigator>
  );
};

const AppNavigator = () => {
  return (
    <NavigationContainer>
      <Stack.Navigator
        screenOptions={{
          headerStyle: {
            backgroundColor: '#1a1a1a',
          },
          headerTintColor: '#fff',
          headerTitleStyle: {
            fontWeight: 'bold',
          },
        }}
      >
        <Stack.Screen 
          name="Main" 
          component={TabNavigator}
          options={{ headerShown: false }}
        />
      </Stack.Navigator>
    </NavigationContainer>
  );
};

export default AppNavigator;
```

### State Management with Redux
```typescript
// src/store/slices/authSlice.ts
import { createSlice, createAsyncThunk, PayloadAction } from '@reduxjs/toolkit';
import { AuthService } from '../services/AuthService';

interface AuthState {
  user: User | null;
  token: string | null;
  isLoading: boolean;
  error: string | null;
}

const initialState: AuthState = {
  user: null,
  token: null,
  isLoading: false,
  error: null,
};

export const login = createAsyncThunk(
  'auth/login',
  async (credentials: { email: string; password: string }) => {
    const response = await AuthService.login(credentials);
    return response.data;
  }
);

export const logout = createAsyncThunk(
  'auth/logout',
  async () => {
    await AuthService.logout();
  }
);

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
        state.isLoading = true;
        state.error = null;
      })
      .addCase(login.fulfilled, (state, action) => {
        state.isLoading = false;
        state.user = action.payload.user;
        state.token = action.payload.token;
      })
      .addCase(login.rejected, (state, action) => {
        state.isLoading = false;
        state.error = action.error.message || 'Login failed';
      })
      .addCase(logout.fulfilled, (state) => {
        state.user = null;
        state.token = null;
      });
  },
});

export const { clearError } = authSlice.actions;
export default authSlice.reducer;
```

### API Service
```typescript
// src/services/ApiService.ts
import axios, { AxiosInstance, AxiosRequestConfig } from 'axios';
import { store } from '../store';
import { logout } from '../store/slices/authSlice';

class ApiService {
  private api: AxiosInstance;

  constructor() {
    this.api = axios.create({
      baseURL: process.env.API_BASE_URL,
      timeout: 10000,
      headers: {
        'Content-Type': 'application/json',
      },
    });

    this.setupInterceptors();
  }

  private setupInterceptors() {
    // Request interceptor
    this.api.interceptors.request.use(
      (config) => {
        const state = store.getState();
        const token = state.auth.token;
        
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
    this.api.interceptors.response.use(
      (response) => response,
      (error) => {
        if (error.response?.status === 401) {
          store.dispatch(logout());
        }
        return Promise.reject(error);
      }
    );
  }

  async get<T>(url: string, config?: AxiosRequestConfig): Promise<T> {
    const response = await this.api.get(url, config);
    return response.data;
  }

  async post<T>(url: string, data?: any, config?: AxiosRequestConfig): Promise<T> {
    const response = await this.api.post(url, data, config);
    return response.data;
  }

  async put<T>(url: string, data?: any, config?: AxiosRequestConfig): Promise<T> {
    const response = await this.api.put(url, data, config);
    return response.data;
  }

  async delete<T>(url: string, config?: AxiosRequestConfig): Promise<T> {
    const response = await this.api.delete(url, config);
    return response.data;
  }
}

export const apiService = new ApiService();
```

### Screen Component
```typescript
// src/screens/HomeScreen.tsx
import React, { useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  FlatList,
  RefreshControl,
  TouchableOpacity,
} from 'react-native';
import { useDispatch, useSelector } from 'react-redux';
import { RootState } from '../store';
import { fetchPosts } from '../store/slices/postsSlice';

interface Post {
  id: string;
  title: string;
  content: string;
  author: string;
  createdAt: string;
}

const HomeScreen: React.FC = () => {
  const dispatch = useDispatch();
  const { posts, isLoading, error } = useSelector((state: RootState) => state.posts);

  useEffect(() => {
    dispatch(fetchPosts());
  }, [dispatch]);

  const handleRefresh = () => {
    dispatch(fetchPosts());
  };

  const renderPost = ({ item }: { item: Post }) => (
    <TouchableOpacity style={styles.postCard}>
      <Text style={styles.postTitle}>{item.title}</Text>
      <Text style={styles.postContent}>{item.content}</Text>
      <Text style={styles.postAuthor}>By {item.author}</Text>
      <Text style={styles.postDate}>{item.createdAt}</Text>
    </TouchableOpacity>
  );

  return (
    <View style={styles.container}>
      <FlatList
        data={posts}
        renderItem={renderPost}
        keyExtractor={(item) => item.id}
        refreshControl={
          <RefreshControl refreshing={isLoading} onRefresh={handleRefresh} />
        }
        contentContainerStyle={styles.listContainer}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#1a1a1a',
  },
  listContainer: {
    padding: 16,
  },
  postCard: {
    backgroundColor: '#2a2a2a',
    padding: 16,
    marginBottom: 12,
    borderRadius: 8,
  },
  postTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#fff',
    marginBottom: 8,
  },
  postContent: {
    fontSize: 14,
    color: '#ccc',
    marginBottom: 8,
  },
  postAuthor: {
    fontSize: 12,
    color: '#007AFF',
    marginBottom: 4,
  },
  postDate: {
    fontSize: 12,
    color: '#666',
  },
});

export default HomeScreen;
```

## Flutter Development

### Project Setup
```bash
# Create new Flutter project
flutter create rechain_mobile

# Add dependencies to pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^0.13.5
  provider: ^6.0.5
  shared_preferences: ^2.0.15
  web3dart: ^2.7.3
  walletconnect_dart: ^1.0.0
  push_notifications: ^1.0.0
```

### State Management with Provider
```dart
// lib/providers/auth_provider.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  User? _user;
  bool _isLoading = false;
  String? _error;

  String? get token => _token;
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await AuthService.login(email, password);
      _token = response.token;
      _user = response.user;
      
      // Save token to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);
      
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    
    // Remove token from local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    
    notifyListeners();
  }

  Future<void> loadStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('token');
    
    if (storedToken != null) {
      _token = storedToken;
      // Load user data
      try {
        _user = await AuthService.getCurrentUser();
        notifyListeners();
      } catch (e) {
        // Token is invalid, remove it
        await logout();
      }
    }
  }
}
```

### Screen Widget
```dart
// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/posts_provider.dart';
import '../widgets/post_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostsProvider>().fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
      appBar: AppBar(
        title: Text('REChain DAO'),
        backgroundColor: Color(0xFF1A1A1A),
        elevation: 0,
      ),
      body: Consumer<PostsProvider>(
        builder: (context, postsProvider, child) {
          if (postsProvider.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF007AFF)),
              ),
            );
          }

          if (postsProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${postsProvider.error}',
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => postsProvider.fetchPosts(),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => postsProvider.fetchPosts(),
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: postsProvider.posts.length,
              itemBuilder: (context, index) {
                final post = postsProvider.posts[index];
                return PostCard(post: post);
              },
            ),
          );
        },
      ),
    );
  }
}
```

### Custom Widget
```dart
// lib/widgets/post_card.dart
import 'package:flutter/material.dart';
import '../models/post.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            post.content,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFCCCCCC),
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'By ${post.author}',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF007AFF),
                ),
              ),
              Text(
                post.createdAt,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF666666),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

## Native Development

### iOS (Swift)
```swift
// ViewController.swift
import UIKit
import WebKit

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshControl: UIRefreshControl!
    
    private var posts: [Post] = []
    private let apiService = ApiService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadPosts()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PostCell.self, forCellReuseIdentifier: "PostCell")
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func loadPosts() {
        apiService.fetchPosts { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let posts):
                    self?.posts = posts
                    self?.tableView.reloadData()
                case .failure(let error):
                    self?.showError(error.localizedDescription)
                }
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    @objc private func refreshData() {
        loadPosts()
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        cell.configure(with: posts[indexPath.row])
        return cell
    }
}
```

### Android (Kotlin)
```kotlin
// MainActivity.kt
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class MainActivity : AppCompatActivity() {
    private lateinit var recyclerView: RecyclerView
    private lateinit var swipeRefreshLayout: SwipeRefreshLayout
    private lateinit var adapter: PostAdapter
    private lateinit var apiService: ApiService
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        
        setupViews()
        setupRecyclerView()
        loadPosts()
    }
    
    private fun setupViews() {
        recyclerView = findViewById(R.id.recyclerView)
        swipeRefreshLayout = findViewById(R.id.swipeRefreshLayout)
        
        swipeRefreshLayout.setOnRefreshListener {
            loadPosts()
        }
    }
    
    private fun setupRecyclerView() {
        adapter = PostAdapter()
        recyclerView.layoutManager = LinearLayoutManager(this)
        recyclerView.adapter = adapter
    }
    
    private fun loadPosts() {
        apiService.fetchPosts().enqueue(object : Callback<List<Post>> {
            override fun onResponse(call: Call<List<Post>>, response: Response<List<Post>>) {
                if (response.isSuccessful) {
                    response.body()?.let { posts ->
                        adapter.updatePosts(posts)
                    }
                } else {
                    showError("Failed to load posts")
                }
                swipeRefreshLayout.isRefreshing = false
            }
            
            override fun onFailure(call: Call<List<Post>>, t: Throwable) {
                showError(t.message ?: "Unknown error")
                swipeRefreshLayout.isRefreshing = false
            }
        })
    }
    
    private fun showError(message: String) {
        // Show error message
    }
}
```

## API Integration

### HTTP Client Setup
```typescript
// src/services/HttpClient.ts
import axios, { AxiosInstance, AxiosRequestConfig } from 'axios';

class HttpClient {
  private client: AxiosInstance;

  constructor() {
    this.client = axios.create({
      baseURL: process.env.API_BASE_URL,
      timeout: 10000,
      headers: {
        'Content-Type': 'application/json',
      },
    });

    this.setupInterceptors();
  }

  private setupInterceptors() {
    this.client.interceptors.request.use(
      (config) => {
        // Add authentication token
        const token = this.getStoredToken();
        if (token) {
          config.headers.Authorization = `Bearer ${token}`;
        }
        return config;
      },
      (error) => Promise.reject(error)
    );

    this.client.interceptors.response.use(
      (response) => response,
      (error) => {
        if (error.response?.status === 401) {
          this.handleUnauthorized();
        }
        return Promise.reject(error);
      }
    );
  }

  private getStoredToken(): string | null {
    // Get token from secure storage
    return null;
  }

  private handleUnauthorized() {
    // Clear stored token and redirect to login
  }

  async get<T>(url: string, config?: AxiosRequestConfig): Promise<T> {
    const response = await this.client.get(url, config);
    return response.data;
  }

  async post<T>(url: string, data?: any, config?: AxiosRequestConfig): Promise<T> {
    const response = await this.client.post(url, data, config);
    return response.data;
  }
}

export const httpClient = new HttpClient();
```

### WebSocket Integration
```typescript
// src/services/WebSocketService.ts
class WebSocketService {
  private ws: WebSocket | null = null;
  private reconnectAttempts = 0;
  private maxReconnectAttempts = 5;
  private reconnectInterval = 1000;

  connect() {
    const wsUrl = process.env.WS_BASE_URL;
    this.ws = new WebSocket(wsUrl);

    this.ws.onopen = () => {
      console.log('WebSocket connected');
      this.reconnectAttempts = 0;
    };

    this.ws.onmessage = (event) => {
      const data = JSON.parse(event.data);
      this.handleMessage(data);
    };

    this.ws.onclose = () => {
      console.log('WebSocket disconnected');
      this.attemptReconnect();
    };

    this.ws.onerror = (error) => {
      console.error('WebSocket error:', error);
    };
  }

  private attemptReconnect() {
    if (this.reconnectAttempts < this.maxReconnectAttempts) {
      this.reconnectAttempts++;
      setTimeout(() => {
        this.connect();
      }, this.reconnectInterval * this.reconnectAttempts);
    }
  }

  private handleMessage(data: any) {
    // Handle different message types
    switch (data.type) {
      case 'notification':
        this.handleNotification(data.payload);
        break;
      case 'post_update':
        this.handlePostUpdate(data.payload);
        break;
      default:
        console.log('Unknown message type:', data.type);
    }
  }

  send(message: any) {
    if (this.ws && this.ws.readyState === WebSocket.OPEN) {
      this.ws.send(JSON.stringify(message));
    }
  }

  disconnect() {
    if (this.ws) {
      this.ws.close();
      this.ws = null;
    }
  }
}

export const webSocketService = new WebSocketService();
```

## Blockchain Integration

### Web3 Integration
```typescript
// src/services/BlockchainService.ts
import Web3 from 'web3';
import { Contract } from 'web3-eth-contract';

class BlockchainService {
  private web3: Web3;
  private contract: Contract;

  constructor() {
    this.web3 = new Web3(process.env.BLOCKCHAIN_RPC_URL);
    this.contract = new this.web3.eth.Contract(ABI, CONTRACT_ADDRESS);
  }

  async connectWallet(): Promise<string> {
    if (typeof window.ethereum !== 'undefined') {
      const accounts = await window.ethereum.request({
        method: 'eth_requestAccounts',
      });
      return accounts[0];
    } else {
      throw new Error('MetaMask not found');
    }
  }

  async getBalance(address: string): Promise<string> {
    const balance = await this.web3.eth.getBalance(address);
    return this.web3.utils.fromWei(balance, 'ether');
  }

  async sendTransaction(to: string, value: string): Promise<string> {
    const accounts = await this.web3.eth.getAccounts();
    const transaction = {
      from: accounts[0],
      to: to,
      value: this.web3.utils.toWei(value, 'ether'),
    };

    const receipt = await this.web3.eth.sendTransaction(transaction);
    return receipt.transactionHash;
  }

  async callContractMethod(method: string, ...args: any[]): Promise<any> {
    return await this.contract.methods[method](...args).call();
  }

  async sendContractMethod(method: string, ...args: any[]): Promise<string> {
    const accounts = await this.web3.eth.getAccounts();
    const transaction = this.contract.methods[method](...args).send({
      from: accounts[0],
    });

    return transaction.transactionHash;
  }
}

export const blockchainService = new BlockchainService();
```

### WalletConnect Integration
```typescript
// src/services/WalletConnectService.ts
import WalletConnect from '@walletconnect/client';
import QRCodeModal from '@walletconnect/qrcode-modal';

class WalletConnectService {
  private connector: WalletConnect | null = null;

  async connect(): Promise<void> {
    this.connector = new WalletConnect({
      bridge: 'https://bridge.walletconnect.org',
      qrcodeModal: QRCodeModal,
    });

    if (!this.connector.connected) {
      await this.connector.createSession();
    }

    this.connector.on('connect', (error, payload) => {
      if (error) {
        throw error;
      }
      console.log('Wallet connected');
    });

    this.connector.on('session_update', (error, payload) => {
      if (error) {
        throw error;
      }
      console.log('Session updated');
    });

    this.connector.on('disconnect', (error, payload) => {
      if (error) {
        throw error;
      }
      console.log('Wallet disconnected');
    });
  }

  async sendTransaction(transaction: any): Promise<string> {
    if (!this.connector) {
      throw new Error('Wallet not connected');
    }

    const result = await this.connector.sendTransaction(transaction);
    return result;
  }

  async signMessage(message: string): Promise<string> {
    if (!this.connector) {
      throw new Error('Wallet not connected');
    }

    const result = await this.connector.signMessage([message]);
    return result;
  }

  disconnect(): void {
    if (this.connector) {
      this.connector.killSession();
      this.connector = null;
    }
  }
}

export const walletConnectService = new WalletConnectService();
```

## Push Notifications

### React Native Push Notifications
```typescript
// src/services/PushNotificationService.ts
import PushNotification from 'react-native-push-notification';

class PushNotificationService {
  constructor() {
    this.configure();
  }

  private configure() {
    PushNotification.configure({
      onRegister: (token) => {
        console.log('FCM Token:', token);
        this.sendTokenToServer(token.token);
      },
      onNotification: (notification) => {
        console.log('Notification received:', notification);
        this.handleNotification(notification);
      },
      onAction: (notification) => {
        console.log('Notification action:', notification);
      },
      onRegistrationError: (err) => {
        console.error('Registration error:', err);
      },
      permissions: {
        alert: true,
        badge: true,
        sound: true,
      },
      popInitialNotification: true,
      requestPermissions: true,
    });
  }

  private async sendTokenToServer(token: string) {
    try {
      await apiService.post('/notifications/register', { token });
    } catch (error) {
      console.error('Failed to send token to server:', error);
    }
  }

  private handleNotification(notification: any) {
    // Handle notification based on type
    if (notification.userInfo?.type === 'post_like') {
      // Navigate to post
    } else if (notification.userInfo?.type === 'message') {
      // Navigate to messages
    }
  }

  async scheduleLocalNotification(title: string, message: string, date: Date) {
    PushNotification.localNotificationSchedule({
      title: title,
      message: message,
      date: date,
    });
  }
}

export const pushNotificationService = new PushNotificationService();
```

### Flutter Push Notifications
```dart
// lib/services/push_notification_service.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

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
    
    if (token != null) {
      await sendTokenToServer(token);
    }

    // Listen to messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
  }

  static Future<void> sendTokenToServer(String token) async {
    try {
      await ApiService.post('/notifications/register', {'token': token});
    } catch (e) {
      print('Failed to send token to server: $e');
    }
  }

  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('Received foreground message: ${message.messageId}');
    
    // Show local notification
    await _localNotifications.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'default_channel',
          'Default Channel',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  static Future<void> _handleMessageOpenedApp(RemoteMessage message) async {
    print('Message opened app: ${message.messageId}');
    // Handle navigation based on message data
  }
}
```

## Testing Mobile Apps

### React Native Testing
```typescript
// __tests__/HomeScreen.test.tsx
import React from 'react';
import { render, fireEvent, waitFor } from '@testing-library/react-native';
import { Provider } from 'react-redux';
import { configureStore } from '@reduxjs/toolkit';
import HomeScreen from '../src/screens/HomeScreen';
import postsReducer from '../src/store/slices/postsSlice';

const createTestStore = () => {
  return configureStore({
    reducer: {
      posts: postsReducer,
    },
  });
};

describe('HomeScreen', () => {
  it('renders posts correctly', async () => {
    const store = createTestStore();
    const { getByText } = render(
      <Provider store={store}>
        <HomeScreen />
      </Provider>
    );

    await waitFor(() => {
      expect(getByText('Sample Post Title')).toBeTruthy();
    });
  });

  it('handles refresh correctly', async () => {
    const store = createTestStore();
    const { getByTestId } = render(
      <Provider store={store}>
        <HomeScreen />
      </Provider>
    );

    const refreshControl = getByTestId('refresh-control');
    fireEvent(refreshControl, 'onRefresh');

    await waitFor(() => {
      // Verify refresh was triggered
    });
  });
});
```

### Flutter Testing
```dart
// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:rechain_mobile/providers/posts_provider.dart';
import 'package:rechain_mobile/screens/home_screen.dart';

void main() {
  group('HomeScreen Widget Tests', () {
    testWidgets('displays posts correctly', (WidgetTester tester) async {
      // Create a mock posts provider
      final postsProvider = PostsProvider();
      
      // Add some test posts
      postsProvider.addPost(Post(
        id: '1',
        title: 'Test Post',
        content: 'Test Content',
        author: 'Test Author',
        createdAt: '2023-01-01',
      ));

      // Build the widget
      await tester.pumpWidget(
        ChangeNotifierProvider<PostsProvider>.value(
          value: postsProvider,
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Verify the post is displayed
      expect(find.text('Test Post'), findsOneWidget);
      expect(find.text('Test Content'), findsOneWidget);
      expect(find.text('By Test Author'), findsOneWidget);
    });

    testWidgets('handles refresh correctly', (WidgetTester tester) async {
      final postsProvider = PostsProvider();
      
      await tester.pumpWidget(
        ChangeNotifierProvider<PostsProvider>.value(
          value: postsProvider,
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Trigger refresh
      await tester.fling(find.byType(RefreshIndicator), const Offset(0, 300), 1000);
      await tester.pumpAndSettle();

      // Verify refresh was triggered
      // Add assertions based on your implementation
    });
  });
}
```

## Deployment and Distribution

### React Native Deployment
```bash
# Android
cd android
./gradlew assembleRelease
# APK will be in android/app/build/outputs/apk/release/

# iOS
cd ios
xcodebuild -workspace REChainMobile.xcworkspace -scheme REChainMobile -configuration Release -destination generic/platform=iOS -archivePath REChainMobile.xcarchive archive
```

### Flutter Deployment
```bash
# Android
flutter build apk --release
# APK will be in build/app/outputs/flutter-apk/

# iOS
flutter build ios --release
# Then use Xcode to archive and upload
```

### App Store Configuration
```json
// app.json for React Native
{
  "expo": {
    "name": "REChain DAO",
    "slug": "rechain-dao",
    "version": "1.0.0",
    "orientation": "portrait",
    "icon": "./assets/icon.png",
    "splash": {
      "image": "./assets/splash.png",
      "resizeMode": "contain",
      "backgroundColor": "#1a1a1a"
    },
    "platforms": ["ios", "android"],
    "ios": {
      "bundleIdentifier": "com.rechain.dao",
      "buildNumber": "1"
    },
    "android": {
      "package": "com.rechain.dao",
      "versionCode": 1
    }
  }
}
```

## Conclusion

This Mobile Development Guide provides comprehensive instructions for creating mobile applications for the REChain DAO platform. By following these guidelines and using the recommended tools and practices, you can create robust, user-friendly mobile apps that integrate seamlessly with the platform.

Remember: Always test your mobile apps thoroughly on different devices and platforms to ensure compatibility and performance.
