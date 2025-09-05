# Third-party Integrations Guide

## Overview

This guide provides comprehensive information about integrating third-party services with the REChain DAO platform to extend functionality and improve user experience.

## Table of Contents

1. [OAuth Providers](#oauth-providers)
2. [Payment Systems](#payment-systems)
3. [Analytics Services](#analytics-services)
4. [Email Services](#email-services)
5. [Storage Services](#storage-services)
6. [Social Media APIs](#social-media-apis)
7. [Push Notifications](#push-notifications)
8. [CDN Services](#cdn-services)
9. [Monitoring Services](#monitoring-services)
10. [Security Services](#security-services)
11. [Best Practices](#best-practices)

## OAuth Providers

### Google OAuth Integration

#### Google OAuth Setup
```php
// Google OAuth configuration
class GoogleOAuthProvider {
    private $client_id;
    private $client_secret;
    private $redirect_uri;
    private $scopes;
    
    public function __construct() {
        $this->client_id = config('oauth.google.client_id');
        $this->client_secret = config('oauth.google.client_secret');
        $this->redirect_uri = config('oauth.google.redirect_uri');
        $this->scopes = [
            'openid',
            'email',
            'profile'
        ];
    }
    
    public function getAuthUrl() {
        $params = [
            'client_id' => $this->client_id,
            'redirect_uri' => $this->redirect_uri,
            'scope' => implode(' ', $this->scopes),
            'response_type' => 'code',
            'access_type' => 'offline',
            'prompt' => 'consent',
            'state' => $this->generateState()
        ];
        
        return 'https://accounts.google.com/o/oauth2/v2/auth?' . http_build_query($params);
    }
    
    public function exchangeCodeForToken($code) {
        $data = [
            'client_id' => $this->client_id,
            'client_secret' => $this->client_secret,
            'code' => $code,
            'grant_type' => 'authorization_code',
            'redirect_uri' => $this->redirect_uri
        ];
        
        $response = $this->makeRequest('https://oauth2.googleapis.com/token', $data);
        
        if ($response['success']) {
            return $response['data'];
        }
        
        throw new OAuthException('Failed to exchange code for token');
    }
    
    public function getUserInfo($access_token) {
        $headers = [
            'Authorization: Bearer ' . $access_token
        ];
        
        $response = $this->makeRequest('https://www.googleapis.com/oauth2/v2/userinfo', [], $headers);
        
        if ($response['success']) {
            return $response['data'];
        }
        
        throw new OAuthException('Failed to get user info');
    }
}
```

#### Google OAuth Controller
```php
// Google OAuth controller
class GoogleOAuthController {
    private $oauth_provider;
    private $user_service;
    
    public function __construct() {
        $this->oauth_provider = new GoogleOAuthProvider();
        $this->user_service = new UserService();
    }
    
    public function redirect() {
        $auth_url = $this->oauth_provider->getAuthUrl();
        return redirect($auth_url);
    }
    
    public function callback(Request $request) {
        $code = $request->get('code');
        $state = $request->get('state');
        
        // Validate state parameter
        if (!$this->validateState($state)) {
            throw new OAuthException('Invalid state parameter');
        }
        
        try {
            // Exchange code for token
            $token_data = $this->oauth_provider->exchangeCodeForToken($code);
            
            // Get user info
            $user_info = $this->oauth_provider->getUserInfo($token_data['access_token']);
            
            // Find or create user
            $user = $this->user_service->findOrCreateFromOAuth('google', $user_info);
            
            // Create session
            $this->createUserSession($user);
            
            return redirect('/dashboard');
            
        } catch (OAuthException $e) {
            return redirect('/login')->with('error', 'OAuth authentication failed');
        }
    }
}
```

### Facebook OAuth Integration

#### Facebook OAuth Setup
```php
// Facebook OAuth configuration
class FacebookOAuthProvider {
    private $app_id;
    private $app_secret;
    private $redirect_uri;
    private $scopes;
    
    public function __construct() {
        $this->app_id = config('oauth.facebook.app_id');
        $this->app_secret = config('oauth.facebook.app_secret');
        $this->redirect_uri = config('oauth.facebook.redirect_uri');
        $this->scopes = [
            'email',
            'public_profile'
        ];
    }
    
    public function getAuthUrl() {
        $params = [
            'client_id' => $this->app_id,
            'redirect_uri' => $this->redirect_uri,
            'scope' => implode(',', $this->scopes),
            'response_type' => 'code',
            'state' => $this->generateState()
        ];
        
        return 'https://www.facebook.com/v18.0/dialog/oauth?' . http_build_query($params);
    }
    
    public function exchangeCodeForToken($code) {
        $data = [
            'client_id' => $this->app_id,
            'client_secret' => $this->app_secret,
            'code' => $code,
            'redirect_uri' => $this->redirect_uri
        ];
        
        $response = $this->makeRequest('https://graph.facebook.com/v18.0/oauth/access_token', $data);
        
        if ($response['success']) {
            return $response['data'];
        }
        
        throw new OAuthException('Failed to exchange code for token');
    }
    
    public function getUserInfo($access_token) {
        $params = [
            'fields' => 'id,name,email,picture',
            'access_token' => $access_token
        ];
        
        $response = $this->makeRequest('https://graph.facebook.com/v18.0/me?' . http_build_query($params));
        
        if ($response['success']) {
            return $response['data'];
        }
        
        throw new OAuthException('Failed to get user info');
    }
}
```

## Payment Systems

### Stripe Integration

#### Stripe Payment Setup
```php
// Stripe payment integration
class StripePaymentService {
    private $stripe;
    private $public_key;
    private $secret_key;
    
    public function __construct() {
        $this->public_key = config('payments.stripe.public_key');
        $this->secret_key = config('payments.stripe.secret_key');
        \Stripe\Stripe::setApiKey($this->secret_key);
    }
    
    public function createPaymentIntent($amount, $currency = 'usd', $metadata = []) {
        try {
            $intent = \Stripe\PaymentIntent::create([
                'amount' => $amount * 100, // Convert to cents
                'currency' => $currency,
                'metadata' => $metadata,
                'automatic_payment_methods' => [
                    'enabled' => true,
                ],
            ]);
            
            return [
                'client_secret' => $intent->client_secret,
                'payment_intent_id' => $intent->id
            ];
            
        } catch (\Stripe\Exception\CardException $e) {
            throw new PaymentException('Card error: ' . $e->getMessage());
        } catch (\Stripe\Exception\RateLimitException $e) {
            throw new PaymentException('Rate limit error: ' . $e->getMessage());
        } catch (\Stripe\Exception\InvalidRequestException $e) {
            throw new PaymentException('Invalid request: ' . $e->getMessage());
        } catch (\Stripe\Exception\AuthenticationException $e) {
            throw new PaymentException('Authentication error: ' . $e->getMessage());
        } catch (\Stripe\Exception\ApiConnectionException $e) {
            throw new PaymentException('Connection error: ' . $e->getMessage());
        } catch (\Stripe\Exception\ApiErrorException $e) {
            throw new PaymentException('API error: ' . $e->getMessage());
        }
    }
    
    public function confirmPayment($payment_intent_id) {
        try {
            $intent = \Stripe\PaymentIntent::retrieve($payment_intent_id);
            
            if ($intent->status === 'succeeded') {
                return [
                    'success' => true,
                    'payment_intent' => $intent
                ];
            }
            
            return [
                'success' => false,
                'status' => $intent->status
            ];
            
        } catch (\Stripe\Exception\ApiErrorException $e) {
            throw new PaymentException('Payment confirmation failed: ' . $e->getMessage());
        }
    }
    
    public function createSubscription($customer_id, $price_id) {
        try {
            $subscription = \Stripe\Subscription::create([
                'customer' => $customer_id,
                'items' => [
                    ['price' => $price_id],
                ],
                'payment_behavior' => 'default_incomplete',
                'payment_settings' => ['save_default_payment_method' => 'on_subscription'],
                'expand' => ['latest_invoice.payment_intent'],
            ]);
            
            return $subscription;
            
        } catch (\Stripe\Exception\ApiErrorException $e) {
            throw new PaymentException('Subscription creation failed: ' . $e->getMessage());
        }
    }
}
```

#### Stripe Webhook Handler
```php
// Stripe webhook handler
class StripeWebhookHandler {
    private $endpoint_secret;
    
    public function __construct() {
        $this->endpoint_secret = config('payments.stripe.webhook_secret');
    }
    
    public function handleWebhook($payload, $signature) {
        $event = null;
        
        try {
            $event = \Stripe\Webhook::constructEvent(
                $payload,
                $signature,
                $this->endpoint_secret
            );
        } catch (\UnexpectedValueException $e) {
            throw new WebhookException('Invalid payload');
        } catch (\Stripe\Exception\SignatureVerificationException $e) {
            throw new WebhookException('Invalid signature');
        }
        
        // Handle the event
        switch ($event->type) {
            case 'payment_intent.succeeded':
                $this->handlePaymentSucceeded($event->data->object);
                break;
                
            case 'payment_intent.payment_failed':
                $this->handlePaymentFailed($event->data->object);
                break;
                
            case 'customer.subscription.created':
                $this->handleSubscriptionCreated($event->data->object);
                break;
                
            case 'customer.subscription.updated':
                $this->handleSubscriptionUpdated($event->data->object);
                break;
                
            case 'customer.subscription.deleted':
                $this->handleSubscriptionDeleted($event->data->object);
                break;
                
            default:
                error_log('Unhandled event type: ' . $event->type);
        }
        
        return ['status' => 'success'];
    }
    
    private function handlePaymentSucceeded($payment_intent) {
        // Update payment status in database
        $this->updatePaymentStatus($payment_intent->id, 'succeeded');
        
        // Send confirmation email
        $this->sendPaymentConfirmation($payment_intent);
    }
    
    private function handlePaymentFailed($payment_intent) {
        // Update payment status in database
        $this->updatePaymentStatus($payment_intent->id, 'failed');
        
        // Send failure notification
        $this->sendPaymentFailureNotification($payment_intent);
    }
}
```

### PayPal Integration

#### PayPal Payment Setup
```php
// PayPal payment integration
class PayPalPaymentService {
    private $client_id;
    private $client_secret;
    private $environment;
    private $base_url;
    
    public function __construct() {
        $this->client_id = config('payments.paypal.client_id');
        $this->client_secret = config('payments.paypal.client_secret');
        $this->environment = config('payments.paypal.environment');
        
        $this->base_url = $this->environment === 'sandbox' 
            ? 'https://api.sandbox.paypal.com'
            : 'https://api.paypal.com';
    }
    
    public function createOrder($amount, $currency = 'USD', $return_url, $cancel_url) {
        $access_token = $this->getAccessToken();
        
        $order_data = [
            'intent' => 'CAPTURE',
            'purchase_units' => [
                [
                    'amount' => [
                        'currency_code' => $currency,
                        'value' => number_format($amount, 2, '.', '')
                    ]
                ]
            ],
            'application_context' => [
                'return_url' => $return_url,
                'cancel_url' => $cancel_url
            ]
        ];
        
        $response = $this->makeRequest(
            $this->base_url . '/v2/checkout/orders',
            $order_data,
            ['Authorization: Bearer ' . $access_token]
        );
        
        if ($response['success']) {
            return $response['data'];
        }
        
        throw new PaymentException('Failed to create PayPal order');
    }
    
    public function captureOrder($order_id) {
        $access_token = $this->getAccessToken();
        
        $response = $this->makeRequest(
            $this->base_url . '/v2/checkout/orders/' . $order_id . '/capture',
            [],
            ['Authorization: Bearer ' . $access_token],
            'POST'
        );
        
        if ($response['success']) {
            return $response['data'];
        }
        
        throw new PaymentException('Failed to capture PayPal order');
    }
    
    private function getAccessToken() {
        $auth = base64_encode($this->client_id . ':' . $this->client_secret);
        
        $data = 'grant_type=client_credentials';
        
        $response = $this->makeRequest(
            $this->base_url . '/v1/oauth2/token',
            $data,
            [
                'Authorization: Basic ' . $auth,
                'Content-Type: application/x-www-form-urlencoded'
            ],
            'POST'
        );
        
        if ($response['success']) {
            return $response['data']['access_token'];
        }
        
        throw new PaymentException('Failed to get PayPal access token');
    }
}
```

## Analytics Services

### Google Analytics Integration

#### Google Analytics Setup
```php
// Google Analytics integration
class GoogleAnalyticsService {
    private $measurement_id;
    private $api_secret;
    private $base_url;
    
    public function __construct() {
        $this->measurement_id = config('analytics.google.measurement_id');
        $this->api_secret = config('analytics.google.api_secret');
        $this->base_url = 'https://www.google-analytics.com/mp/collect';
    }
    
    public function trackEvent($client_id, $event_name, $parameters = []) {
        $data = [
            'client_id' => $client_id,
            'events' => [
                [
                    'name' => $event_name,
                    'params' => $parameters
                ]
            ]
        ];
        
        $response = $this->makeRequest(
            $this->base_url . '?measurement_id=' . $this->measurement_id . '&api_secret=' . $this->api_secret,
            $data
        );
        
        return $response['success'];
    }
    
    public function trackPageView($client_id, $page_title, $page_location) {
        return $this->trackEvent($client_id, 'page_view', [
            'page_title' => $page_title,
            'page_location' => $page_location
        ]);
    }
    
    public function trackUserRegistration($client_id, $user_id) {
        return $this->trackEvent($client_id, 'user_registration', [
            'user_id' => $user_id,
            'event_category' => 'user',
            'event_label' => 'registration'
        ]);
    }
    
    public function trackPostCreation($client_id, $post_id, $post_type) {
        return $this->trackEvent($client_id, 'post_creation', [
            'post_id' => $post_id,
            'post_type' => $post_type,
            'event_category' => 'content',
            'event_label' => 'post_created'
        ]);
    }
}
```

#### Frontend Analytics Integration
```javascript
// Frontend Google Analytics integration
class GoogleAnalytics {
    constructor(measurementId) {
        this.measurementId = measurementId;
        this.clientId = this.getOrCreateClientId();
        this.init();
    }
    
    init() {
        // Load Google Analytics script
        const script = document.createElement('script');
        script.async = true;
        script.src = `https://www.googletagmanager.com/gtag/js?id=${this.measurementId}`;
        document.head.appendChild(script);
        
        // Initialize gtag
        window.dataLayer = window.dataLayer || [];
        function gtag(){dataLayer.push(arguments);}
        window.gtag = gtag;
        gtag('js', new Date());
        gtag('config', this.measurementId, {
            'client_id': this.clientId
        });
    }
    
    trackEvent(eventName, parameters = {}) {
        if (window.gtag) {
            gtag('event', eventName, parameters);
        }
    }
    
    trackPageView(pageTitle, pageLocation) {
        this.trackEvent('page_view', {
            'page_title': pageTitle,
            'page_location': pageLocation
        });
    }
    
    trackUserRegistration(userId) {
        this.trackEvent('user_registration', {
            'user_id': userId,
            'event_category': 'user',
            'event_label': 'registration'
        });
    }
    
    trackPostCreation(postId, postType) {
        this.trackEvent('post_creation', {
            'post_id': postId,
            'post_type': postType,
            'event_category': 'content',
            'event_label': 'post_created'
        });
    }
    
    getOrCreateClientId() {
        let clientId = localStorage.getItem('ga_client_id');
        if (!clientId) {
            clientId = this.generateClientId();
            localStorage.setItem('ga_client_id', clientId);
        }
        return clientId;
    }
    
    generateClientId() {
        return Math.random().toString(36).substring(2, 15) + 
               Math.random().toString(36).substring(2, 15);
    }
}

// Initialize Google Analytics
const ga = new GoogleAnalytics('G-XXXXXXXXXX');
```

## Email Services

### SendGrid Integration

#### SendGrid Email Service
```php
// SendGrid email integration
class SendGridEmailService {
    private $api_key;
    private $from_email;
    private $from_name;
    
    public function __construct() {
        $this->api_key = config('mail.sendgrid.api_key');
        $this->from_email = config('mail.from.address');
        $this->from_name = config('mail.from.name');
    }
    
    public function sendEmail($to, $subject, $content, $template_id = null) {
        $data = [
            'personalizations' => [
                [
                    'to' => [
                        ['email' => $to]
                    ],
                    'subject' => $subject
                ]
            ],
            'from' => [
                'email' => $this->from_email,
                'name' => $this->from_name
            ],
            'content' => [
                [
                    'type' => 'text/html',
                    'value' => $content
                ]
            ]
        ];
        
        if ($template_id) {
            $data['template_id'] = $template_id;
            unset($data['content']);
        }
        
        $response = $this->makeRequest(
            'https://api.sendgrid.com/v3/mail/send',
            $data,
            ['Authorization: Bearer ' . $this->api_key]
        );
        
        return $response['success'];
    }
    
    public function sendWelcomeEmail($user_email, $user_name) {
        $template_id = config('mail.templates.welcome');
        
        return $this->sendEmail(
            $user_email,
            'Welcome to REChain DAO!',
            '',
            $template_id
        );
    }
    
    public function sendPasswordResetEmail($user_email, $reset_token) {
        $reset_url = config('app.url') . '/reset-password?token=' . $reset_token;
        
        $content = "
            <h2>Password Reset Request</h2>
            <p>You requested a password reset. Click the link below to reset your password:</p>
            <p><a href='{$reset_url}'>Reset Password</a></p>
            <p>This link will expire in 1 hour.</p>
        ";
        
        return $this->sendEmail(
            $user_email,
            'Password Reset Request',
            $content
        );
    }
    
    public function sendNotificationEmail($user_email, $subject, $message) {
        $content = "
            <h2>{$subject}</h2>
            <p>{$message}</p>
        ";
        
        return $this->sendEmail(
            $user_email,
            $subject,
            $content
        );
    }
}
```

### Mailgun Integration

#### Mailgun Email Service
```php
// Mailgun email integration
class MailgunEmailService {
    private $api_key;
    private $domain;
    private $from_email;
    
    public function __construct() {
        $this->api_key = config('mail.mailgun.api_key');
        $this->domain = config('mail.mailgun.domain');
        $this->from_email = config('mail.from.address');
    }
    
    public function sendEmail($to, $subject, $content, $html_content = null) {
        $data = [
            'from' => $this->from_email,
            'to' => $to,
            'subject' => $subject,
            'text' => $content
        ];
        
        if ($html_content) {
            $data['html'] = $html_content;
        }
        
        $response = $this->makeRequest(
            "https://api.mailgun.net/v3/{$this->domain}/messages",
            $data,
            ['Authorization: Basic ' . base64_encode('api:' . $this->api_key)]
        );
        
        return $response['success'];
    }
    
    public function sendBulkEmail($recipients, $subject, $content) {
        $data = [
            'from' => $this->from_email,
            'to' => $recipients,
            'subject' => $subject,
            'text' => $content
        ];
        
        $response = $this->makeRequest(
            "https://api.mailgun.net/v3/{$this->domain}/messages",
            $data,
            ['Authorization: Basic ' . base64_encode('api:' . $this->api_key)]
        );
        
        return $response['success'];
    }
}
```

## Storage Services

### AWS S3 Integration

#### AWS S3 Storage Service
```php
// AWS S3 storage integration
class S3StorageService {
    private $s3_client;
    private $bucket;
    private $region;
    
    public function __construct() {
        $this->s3_client = new \Aws\S3\S3Client([
            'version' => 'latest',
            'region' => config('storage.s3.region'),
            'credentials' => [
                'key' => config('storage.s3.key'),
                'secret' => config('storage.s3.secret')
            ]
        ]);
        
        $this->bucket = config('storage.s3.bucket');
        $this->region = config('storage.s3.region');
    }
    
    public function uploadFile($file_path, $s3_key, $content_type = null) {
        try {
            $result = $this->s3_client->putObject([
                'Bucket' => $this->bucket,
                'Key' => $s3_key,
                'SourceFile' => $file_path,
                'ContentType' => $content_type,
                'ACL' => 'public-read'
            ]);
            
            return [
                'success' => true,
                'url' => $result['ObjectURL'],
                'key' => $s3_key
            ];
            
        } catch (\Aws\Exception\AwsException $e) {
            return [
                'success' => false,
                'error' => $e->getMessage()
            ];
        }
    }
    
    public function uploadFromString($content, $s3_key, $content_type = 'text/plain') {
        try {
            $result = $this->s3_client->putObject([
                'Bucket' => $this->bucket,
                'Key' => $s3_key,
                'Body' => $content,
                'ContentType' => $content_type,
                'ACL' => 'public-read'
            ]);
            
            return [
                'success' => true,
                'url' => $result['ObjectURL'],
                'key' => $s3_key
            ];
            
        } catch (\Aws\Exception\AwsException $e) {
            return [
                'success' => false,
                'error' => $e->getMessage()
            ];
        }
    }
    
    public function deleteFile($s3_key) {
        try {
            $this->s3_client->deleteObject([
                'Bucket' => $this->bucket,
                'Key' => $s3_key
            ]);
            
            return ['success' => true];
            
        } catch (\Aws\Exception\AwsException $e) {
            return [
                'success' => false,
                'error' => $e->getMessage()
            ];
        }
    }
    
    public function generatePresignedUrl($s3_key, $expiration = '+1 hour') {
        try {
            $cmd = $this->s3_client->getCommand('GetObject', [
                'Bucket' => $this->bucket,
                'Key' => $s3_key
            ]);
            
            $request = $this->s3_client->createPresignedRequest($cmd, $expiration);
            
            return (string) $request->getUri();
            
        } catch (\Aws\Exception\AwsException $e) {
            throw new StorageException('Failed to generate presigned URL: ' . $e->getMessage());
        }
    }
}
```

### CloudFlare R2 Integration

#### CloudFlare R2 Storage Service
```php
// CloudFlare R2 storage integration
class R2StorageService {
    private $s3_client;
    private $bucket;
    private $account_id;
    
    public function __construct() {
        $this->s3_client = new \Aws\S3\S3Client([
            'version' => 'latest',
            'region' => 'auto',
            'endpoint' => 'https://' . config('storage.r2.account_id') . '.r2.cloudflarestorage.com',
            'credentials' => [
                'key' => config('storage.r2.access_key'),
                'secret' => config('storage.r2.secret_key')
            ]
        ]);
        
        $this->bucket = config('storage.r2.bucket');
        $this->account_id = config('storage.r2.account_id');
    }
    
    public function uploadFile($file_path, $r2_key, $content_type = null) {
        try {
            $result = $this->s3_client->putObject([
                'Bucket' => $this->bucket,
                'Key' => $r2_key,
                'SourceFile' => $file_path,
                'ContentType' => $content_type,
                'ACL' => 'public-read'
            ]);
            
            return [
                'success' => true,
                'url' => $result['ObjectURL'],
                'key' => $r2_key
            ];
            
        } catch (\Aws\Exception\AwsException $e) {
            return [
                'success' => false,
                'error' => $e->getMessage()
            ];
        }
    }
    
    public function getPublicUrl($r2_key) {
        return "https://pub-{$this->account_id}.r2.dev/{$r2_key}";
    }
}
```

## Social Media APIs

### Twitter API Integration

#### Twitter API Service
```php
// Twitter API integration
class TwitterAPIService {
    private $bearer_token;
    private $api_key;
    private $api_secret;
    private $access_token;
    private $access_token_secret;
    
    public function __construct() {
        $this->bearer_token = config('social.twitter.bearer_token');
        $this->api_key = config('social.twitter.api_key');
        $this->api_secret = config('social.twitter.api_secret');
        $this->access_token = config('social.twitter.access_token');
        $this->access_token_secret = config('social.twitter.access_token_secret');
    }
    
    public function postTweet($text, $media_ids = []) {
        $data = [
            'text' => $text
        ];
        
        if (!empty($media_ids)) {
            $data['media'] = [
                'media_ids' => $media_ids
            ];
        }
        
        $response = $this->makeRequest(
            'https://api.twitter.com/2/tweets',
            $data,
            ['Authorization: Bearer ' . $this->bearer_token]
        );
        
        return $response['success'] ? $response['data'] : null;
    }
    
    public function uploadMedia($file_path) {
        $data = [
            'media' => base64_encode(file_get_contents($file_path))
        ];
        
        $response = $this->makeRequest(
            'https://upload.twitter.com/1.1/media/upload.json',
            $data,
            ['Authorization: Bearer ' . $this->bearer_token]
        );
        
        return $response['success'] ? $response['data']['media_id_string'] : null;
    }
    
    public function getUserTimeline($user_id, $count = 10) {
        $params = [
            'user_id' => $user_id,
            'count' => $count,
            'tweet.fields' => 'created_at,public_metrics'
        ];
        
        $response = $this->makeRequest(
            'https://api.twitter.com/2/users/' . $user_id . '/tweets?' . http_build_query($params),
            [],
            ['Authorization: Bearer ' . $this->bearer_token]
        );
        
        return $response['success'] ? $response['data'] : null;
    }
}
```

## Push Notifications

### OneSignal Integration

#### OneSignal Push Service
```php
// OneSignal push notification integration
class OneSignalPushService {
    private $app_id;
    private $api_key;
    private $base_url;
    
    public function __construct() {
        $this->app_id = config('notifications.onesignal.app_id');
        $this->api_key = config('notifications.onesignal.api_key');
        $this->base_url = 'https://onesignal.com/api/v1';
    }
    
    public function sendNotification($user_ids, $title, $message, $data = []) {
        $notification_data = [
            'app_id' => $this->app_id,
            'include_player_ids' => $user_ids,
            'headings' => ['en' => $title],
            'contents' => ['en' => $message],
            'data' => $data
        ];
        
        $response = $this->makeRequest(
            $this->base_url . '/notifications',
            $notification_data,
            ['Authorization: Basic ' . $this->api_key]
        );
        
        return $response['success'] ? $response['data'] : null;
    }
    
    public function sendToAllUsers($title, $message, $data = []) {
        $notification_data = [
            'app_id' => $this->app_id,
            'included_segments' => ['All'],
            'headings' => ['en' => $title],
            'contents' => ['en' => $message],
            'data' => $data
        ];
        
        $response = $this->makeRequest(
            $this->base_url . '/notifications',
            $notification_data,
            ['Authorization: Basic ' . $this->api_key]
        );
        
        return $response['success'] ? $response['data'] : null;
    }
    
    public function createUser($user_id, $device_token) {
        $user_data = [
            'app_id' => $this->app_id,
            'device_type' => 0, // 0 = iOS, 1 = Android
            'identifier' => $device_token,
            'external_user_id' => $user_id
        ];
        
        $response = $this->makeRequest(
            $this->base_url . '/players',
            $user_data,
            ['Authorization: Basic ' . $this->api_key]
        );
        
        return $response['success'] ? $response['data'] : null;
    }
}
```

## CDN Services

### CloudFlare CDN Integration

#### CloudFlare CDN Service
```php
// CloudFlare CDN integration
class CloudFlareCDNService {
    private $api_token;
    private $zone_id;
    private $base_url;
    
    public function __construct() {
        $this->api_token = config('cdn.cloudflare.api_token');
        $this->zone_id = config('cdn.cloudflare.zone_id');
        $this->base_url = 'https://api.cloudflare.com/client/v4';
    }
    
    public function purgeCache($urls = []) {
        $data = [
            'purge_everything' => empty($urls),
            'files' => $urls
        ];
        
        $response = $this->makeRequest(
            $this->base_url . '/zones/' . $this->zone_id . '/purge_cache',
            $data,
            ['Authorization: Bearer ' . $this->api_token]
        );
        
        return $response['success'];
    }
    
    public function purgeAllCache() {
        return $this->purgeCache();
    }
    
    public function getCacheSettings() {
        $response = $this->makeRequest(
            $this->base_url . '/zones/' . $this->zone_id . '/settings/cache_level',
            [],
            ['Authorization: Bearer ' . $this->api_token]
        );
        
        return $response['success'] ? $response['data'] : null;
    }
    
    public function updateCacheSettings($cache_level = 'aggressive') {
        $data = [
            'value' => $cache_level
        ];
        
        $response = $this->makeRequest(
            $this->base_url . '/zones/' . $this->zone_id . '/settings/cache_level',
            $data,
            ['Authorization: Bearer ' . $this->api_token],
            'PATCH'
        );
        
        return $response['success'];
    }
}
```

## Monitoring Services

### Sentry Integration

#### Sentry Error Monitoring
```php
// Sentry error monitoring integration
class SentryService {
    private $dsn;
    private $environment;
    
    public function __construct() {
        $this->dsn = config('monitoring.sentry.dsn');
        $this->environment = config('app.env');
        
        \Sentry\init([
            'dsn' => $this->dsn,
            'environment' => $this->environment,
            'traces_sample_rate' => 1.0,
        ]);
    }
    
    public function captureException(\Throwable $exception, $context = []) {
        \Sentry\withScope(function (\Sentry\State\Scope $scope) use ($exception, $context) {
            foreach ($context as $key => $value) {
                $scope->setContext($key, $value);
            }
            \Sentry\captureException($exception);
        });
    }
    
    public function captureMessage($message, $level = 'info', $context = []) {
        \Sentry\withScope(function (\Sentry\State\Scope $scope) use ($message, $level, $context) {
            foreach ($context as $key => $value) {
                $scope->setContext($key, $value);
            }
            \Sentry\captureMessage($message, $level);
        });
    }
    
    public function setUserContext($user_id, $user_data = []) {
        \Sentry\configureScope(function (\Sentry\State\Scope $scope) use ($user_id, $user_data) {
            $scope->setUser([
                'id' => $user_id,
                ...$user_data
            ]);
        });
    }
}
```

## Security Services

### reCAPTCHA Integration

#### reCAPTCHA Service
```php
// reCAPTCHA integration
class ReCAPTCHAService {
    private $secret_key;
    private $site_key;
    private $verify_url;
    
    public function __construct() {
        $this->secret_key = config('security.recaptcha.secret_key');
        $this->site_key = config('security.recaptcha.site_key');
        $this->verify_url = 'https://www.google.com/recaptcha/api/siteverify';
    }
    
    public function verifyResponse($response, $remote_ip = null) {
        $data = [
            'secret' => $this->secret_key,
            'response' => $response,
            'remoteip' => $remote_ip
        ];
        
        $response = $this->makeRequest($this->verify_url, $data);
        
        if ($response['success']) {
            $result = $response['data'];
            return [
                'success' => $result['success'],
                'score' => $result['score'] ?? null,
                'action' => $result['action'] ?? null,
                'challenge_ts' => $result['challenge_ts'] ?? null,
                'hostname' => $result['hostname'] ?? null,
                'error_codes' => $result['error-codes'] ?? []
            ];
        }
        
        return ['success' => false];
    }
    
    public function getSiteKey() {
        return $this->site_key;
    }
}
```

#### Frontend reCAPTCHA Integration
```javascript
// Frontend reCAPTCHA integration
class ReCAPTCHA {
    constructor(siteKey) {
        this.siteKey = siteKey;
        this.loadScript();
    }
    
    loadScript() {
        if (!document.querySelector('script[src*="recaptcha"]')) {
            const script = document.createElement('script');
            script.src = `https://www.google.com/recaptcha/api.js?render=${this.siteKey}`;
            script.async = true;
            document.head.appendChild(script);
        }
    }
    
    async execute(action = 'submit') {
        return new Promise((resolve, reject) => {
            grecaptcha.ready(() => {
                grecaptcha.execute(this.siteKey, { action })
                    .then(token => resolve(token))
                    .catch(error => reject(error));
            });
        });
    }
}

// Initialize reCAPTCHA
const recaptcha = new ReCAPTCHA('YOUR_SITE_KEY');
```

## Best Practices

### Integration Best Practices

#### Error Handling
1. **Graceful Degradation**: Services should fail gracefully without breaking the application
2. **Retry Logic**: Implement retry logic for transient failures
3. **Circuit Breaker**: Use circuit breaker pattern for external services
4. **Logging**: Log all integration failures for debugging

#### Security
1. **API Keys**: Store API keys securely in environment variables
2. **HTTPS**: Always use HTTPS for API communications
3. **Validation**: Validate all data from external services
4. **Rate Limiting**: Implement rate limiting for external API calls

#### Performance
1. **Caching**: Cache responses from external services when appropriate
2. **Async Processing**: Use async processing for non-critical integrations
3. **Connection Pooling**: Reuse connections for external services
4. **Monitoring**: Monitor performance of external integrations

#### Maintenance
1. **Versioning**: Keep track of API versions and plan for updates
2. **Documentation**: Document all integrations and their configurations
3. **Testing**: Test integrations regularly to ensure they work
4. **Backup Plans**: Have backup plans for critical integrations

### Configuration Management

#### Environment Configuration
```php
// Integration configuration
return [
    'oauth' => [
        'google' => [
            'client_id' => env('GOOGLE_CLIENT_ID'),
            'client_secret' => env('GOOGLE_CLIENT_SECRET'),
            'redirect_uri' => env('GOOGLE_REDIRECT_URI')
        ],
        'facebook' => [
            'app_id' => env('FACEBOOK_APP_ID'),
            'app_secret' => env('FACEBOOK_APP_SECRET'),
            'redirect_uri' => env('FACEBOOK_REDIRECT_URI')
        ]
    ],
    
    'payments' => [
        'stripe' => [
            'public_key' => env('STRIPE_PUBLIC_KEY'),
            'secret_key' => env('STRIPE_SECRET_KEY'),
            'webhook_secret' => env('STRIPE_WEBHOOK_SECRET')
        ],
        'paypal' => [
            'client_id' => env('PAYPAL_CLIENT_ID'),
            'client_secret' => env('PAYPAL_CLIENT_SECRET'),
            'environment' => env('PAYPAL_ENVIRONMENT', 'sandbox')
        ]
    ],
    
    'analytics' => [
        'google' => [
            'measurement_id' => env('GOOGLE_ANALYTICS_MEASUREMENT_ID'),
            'api_secret' => env('GOOGLE_ANALYTICS_API_SECRET')
        ]
    ],
    
    'mail' => [
        'sendgrid' => [
            'api_key' => env('SENDGRID_API_KEY')
        ],
        'mailgun' => [
            'api_key' => env('MAILGUN_API_KEY'),
            'domain' => env('MAILGUN_DOMAIN')
        ]
    ],
    
    'storage' => [
        's3' => [
            'key' => env('AWS_ACCESS_KEY_ID'),
            'secret' => env('AWS_SECRET_ACCESS_KEY'),
            'region' => env('AWS_DEFAULT_REGION'),
            'bucket' => env('AWS_BUCKET')
        ],
        'r2' => [
            'account_id' => env('R2_ACCOUNT_ID'),
            'access_key' => env('R2_ACCESS_KEY_ID'),
            'secret_key' => env('R2_SECRET_ACCESS_KEY'),
            'bucket' => env('R2_BUCKET')
        ]
    ]
];
```

## Conclusion

This third-party integrations guide provides comprehensive information about integrating various external services with the REChain DAO platform. Proper integration of these services can significantly enhance the platform's functionality and user experience.

Remember: Always test integrations thoroughly, monitor their performance, and have backup plans for critical services. Keep your integrations secure and up-to-date to maintain a reliable platform.
