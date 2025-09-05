# Analytics Guide

## Overview

This guide provides comprehensive instructions for implementing analytics and reporting systems in the REChain DAO platform, including data collection, analysis, visualization, and business intelligence.

## Table of Contents

1. [Analytics Architecture](#analytics-architecture)
2. [Data Collection](#data-collection)
3. [Data Processing](#data-processing)
4. [Data Visualization](#data-visualization)
5. [Business Intelligence](#business-intelligence)
6. [Real-time Analytics](#real-time-analytics)
7. [Performance Monitoring](#performance-monitoring)
8. [Privacy and Compliance](#privacy-and-compliance)

## Analytics Architecture

### System Overview
```
┌─────────────────────────────────────────────────────────────┐
│                    Analytics Platform                       │
├─────────────────────────────────────────────────────────────┤
│  Data Collection Layer                                     │
│  ├── Web Analytics (Google Analytics, Mixpanel)           │
│  ├── Application Analytics (Custom Events)                │
│  ├── User Behavior Tracking                               │
│  └── Business Metrics Collection                          │
├─────────────────────────────────────────────────────────────┤
│  Data Processing Layer                                     │
│  ├── ETL Pipelines (Apache Airflow)                      │
│  ├── Stream Processing (Apache Kafka, Apache Flink)      │
│  ├── Data Warehousing (BigQuery, Snowflake)              │
│  └── Data Lake (AWS S3, Google Cloud Storage)            │
├─────────────────────────────────────────────────────────────┤
│  Analytics Layer                                           │
│  ├── Statistical Analysis (Python, R)                    │
│  ├── Machine Learning (TensorFlow, PyTorch)              │
│  ├── A/B Testing (Optimizely, VWO)                       │
│  └── Predictive Analytics                                 │
├─────────────────────────────────────────────────────────────┤
│  Visualization Layer                                       │
│  ├── Dashboards (Grafana, Tableau, Power BI)             │
│  ├── Reports (Jupyter, R Markdown)                       │
│  ├── Real-time Monitoring (Grafana, DataDog)             │
│  └── Business Intelligence (Looker, Metabase)            │
└─────────────────────────────────────────────────────────────┘
```

### Technology Stack
- **Data Collection**: Google Analytics, Mixpanel, Amplitude
- **Data Processing**: Apache Airflow, Apache Kafka, Apache Spark
- **Data Storage**: BigQuery, Snowflake, PostgreSQL, Redis
- **Analytics**: Python, R, Jupyter, Apache Superset
- **Visualization**: Grafana, Tableau, Power BI, D3.js
- **Monitoring**: Prometheus, Grafana, DataDog, New Relic

## Data Collection

### Web Analytics Setup
```javascript
// analytics.js
class Analytics {
    constructor() {
        this.config = {
            googleAnalytics: {
                measurementId: 'G-XXXXXXXXXX',
                customDimensions: {
                    userType: 1,
                    subscriptionPlan: 2,
                    registrationSource: 3
                }
            },
            mixpanel: {
                token: 'your_mixpanel_token',
                config: {
                    track_pageview: true,
                    persistence: 'localStorage'
                }
            }
        };
        
        this.initialize();
    }
    
    initialize() {
        // Initialize Google Analytics
        this.initGoogleAnalytics();
        
        // Initialize Mixpanel
        this.initMixpanel();
        
        // Set up custom event tracking
        this.setupCustomEvents();
    }
    
    initGoogleAnalytics() {
        // Load Google Analytics
        const script = document.createElement('script');
        script.async = true;
        script.src = `https://www.googletagmanager.com/gtag/js?id=${this.config.googleAnalytics.measurementId}`;
        document.head.appendChild(script);
        
        window.dataLayer = window.dataLayer || [];
        function gtag(){dataLayer.push(arguments);}
        gtag('js', new Date());
        gtag('config', this.config.googleAnalytics.measurementId);
        
        this.gtag = gtag;
    }
    
    initMixpanel() {
        // Load Mixpanel
        (function(c,a){if(!a.__SV){var b=window;try{var c,d=b.location,f=d.hash;c=function(a,b){return a.push(b)};var g="https://cdn.mxpnl.com/libs/mixpanel-2-latest.min.js";b._mixpanel=[c,d,f];a.__SV=1.2;var e=document.createElement("script");e.type="text/javascript";e.async=!0;e.src=g;var h=document.getElementsByTagName("script")[0];h.parentNode.insertBefore(e,h)}})([],window.mixpanel||[]);
        
        mixpanel.init(this.config.mixpanel.token, this.config.mixpanel.config);
    }
    
    // Track page views
    trackPageView(page, title) {
        // Google Analytics
        this.gtag('config', this.config.googleAnalytics.measurementId, {
            page_title: title,
            page_location: page
        });
        
        // Mixpanel
        mixpanel.track('Page View', {
            page: page,
            title: title,
            timestamp: new Date().toISOString()
        });
    }
    
    // Track custom events
    trackEvent(eventName, properties = {}) {
        // Google Analytics
        this.gtag('event', eventName, properties);
        
        // Mixpanel
        mixpanel.track(eventName, {
            ...properties,
            timestamp: new Date().toISOString()
        });
    }
    
    // Track user properties
    setUserProperties(properties) {
        // Google Analytics
        this.gtag('config', this.config.googleAnalytics.measurementId, {
            custom_map: properties
        });
        
        // Mixpanel
        mixpanel.people.set(properties);
    }
    
    // Track e-commerce events
    trackPurchase(transactionId, value, currency, items) {
        this.gtag('event', 'purchase', {
            transaction_id: transactionId,
            value: value,
            currency: currency,
            items: items
        });
        
        mixpanel.track('Purchase', {
            transaction_id: transactionId,
            value: value,
            currency: currency,
            items: items
        });
    }
}

// Initialize analytics
const analytics = new Analytics();
```

### Custom Event Tracking
```javascript
// event-tracking.js
class EventTracker {
    constructor() {
        this.events = new Map();
        this.setupEventListeners();
    }
    
    setupEventListeners() {
        // Track button clicks
        document.addEventListener('click', (event) => {
            if (event.target.matches('[data-track]')) {
                const eventName = event.target.getAttribute('data-track');
                const properties = this.getEventProperties(event.target);
                this.trackEvent(eventName, properties);
            }
        });
        
        // Track form submissions
        document.addEventListener('submit', (event) => {
            if (event.target.matches('[data-track-form]')) {
                const formName = event.target.getAttribute('data-track-form');
                const formData = new FormData(event.target);
                const properties = Object.fromEntries(formData.entries());
                this.trackEvent('Form Submission', {
                    form_name: formName,
                    ...properties
                });
            }
        });
        
        // Track scroll depth
        this.trackScrollDepth();
        
        // Track time on page
        this.trackTimeOnPage();
    }
    
    trackEvent(eventName, properties = {}) {
        const event = {
            name: eventName,
            properties: {
                ...properties,
                timestamp: new Date().toISOString(),
                page: window.location.pathname,
                referrer: document.referrer
            }
        };
        
        // Store event locally
        this.events.set(eventName, event);
        
        // Send to analytics
        analytics.trackEvent(eventName, event.properties);
        
        // Send to custom endpoint
        this.sendToCustomEndpoint(event);
    }
    
    getEventProperties(element) {
        const properties = {};
        
        // Get data attributes
        Array.from(element.attributes).forEach(attr => {
            if (attr.name.startsWith('data-')) {
                const key = attr.name.replace('data-', '').replace(/-/g, '_');
                properties[key] = attr.value;
            }
        });
        
        // Get element properties
        properties.element_type = element.tagName.toLowerCase();
        properties.element_id = element.id;
        properties.element_class = element.className;
        
        return properties;
    }
    
    trackScrollDepth() {
        let maxScroll = 0;
        const scrollThresholds = [25, 50, 75, 90, 100];
        const trackedThresholds = new Set();
        
        window.addEventListener('scroll', () => {
            const scrollPercent = Math.round(
                (window.scrollY / (document.body.scrollHeight - window.innerHeight)) * 100
            );
            
            if (scrollPercent > maxScroll) {
                maxScroll = scrollPercent;
                
                scrollThresholds.forEach(threshold => {
                    if (scrollPercent >= threshold && !trackedThresholds.has(threshold)) {
                        trackedThresholds.add(threshold);
                        this.trackEvent('Scroll Depth', {
                            scroll_percent: threshold,
                            page_height: document.body.scrollHeight,
                            viewport_height: window.innerHeight
                        });
                    }
                });
            }
        });
    }
    
    trackTimeOnPage() {
        const startTime = Date.now();
        
        window.addEventListener('beforeunload', () => {
            const timeOnPage = Math.round((Date.now() - startTime) / 1000);
            this.trackEvent('Time on Page', {
                time_seconds: timeOnPage,
                page: window.location.pathname
            });
        });
    }
    
    async sendToCustomEndpoint(event) {
        try {
            await fetch('/api/analytics/events', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(event)
            });
        } catch (error) {
            console.error('Failed to send event to custom endpoint:', error);
        }
    }
}

// Initialize event tracker
const eventTracker = new EventTracker();
```

## Data Processing

### ETL Pipeline
```python
# etl_pipeline.py
import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import logging

class ETLPipeline:
    def __init__(self, source_db, target_db):
        self.source_db = source_db
        self.target_db = target_db
        self.logger = logging.getLogger(__name__)
    
    def extract_user_data(self, start_date, end_date):
        """Extract user data from source database"""
        query = """
        SELECT 
            user_id,
            username,
            email,
            created_at,
            last_login,
            subscription_plan,
            total_posts,
            total_comments,
            total_likes,
            total_shares
        FROM users 
        WHERE created_at BETWEEN %s AND %s
        """
        
        data = self.source_db.execute_query(query, (start_date, end_date))
        return pd.DataFrame(data)
    
    def extract_engagement_data(self, start_date, end_date):
        """Extract engagement data from source database"""
        query = """
        SELECT 
            user_id,
            post_id,
            action_type,
            action_timestamp,
            session_id,
            device_type,
            browser,
            country,
            city
        FROM user_actions 
        WHERE action_timestamp BETWEEN %s AND %s
        """
        
        data = self.source_db.execute_query(query, (start_date, end_date))
        return pd.DataFrame(data)
    
    def transform_user_data(self, df):
        """Transform user data"""
        # Calculate user metrics
        df['days_since_registration'] = (datetime.now() - pd.to_datetime(df['created_at'])).dt.days
        df['days_since_last_login'] = (datetime.now() - pd.to_datetime(df['last_login'])).dt.days
        df['total_engagement'] = df['total_posts'] + df['total_comments'] + df['total_likes'] + df['total_shares']
        df['engagement_rate'] = df['total_engagement'] / df['days_since_registration'].replace(0, 1)
        
        # Categorize users
        df['user_segment'] = pd.cut(
            df['engagement_rate'], 
            bins=[0, 0.1, 0.5, 1.0, float('inf')], 
            labels=['Inactive', 'Low', 'Medium', 'High']
        )
        
        # Calculate retention
        df['is_retained'] = df['days_since_last_login'] <= 30
        
        return df
    
    def transform_engagement_data(self, df):
        """Transform engagement data"""
        # Convert timestamp to datetime
        df['action_timestamp'] = pd.to_datetime(df['action_timestamp'])
        
        # Add time-based features
        df['hour'] = df['action_timestamp'].dt.hour
        df['day_of_week'] = df['action_timestamp'].dt.dayofweek
        df['is_weekend'] = df['day_of_week'].isin([5, 6])
        
        # Calculate session metrics
        session_metrics = df.groupby('session_id').agg({
            'action_timestamp': ['min', 'max', 'count'],
            'action_type': 'nunique'
        }).reset_index()
        
        session_metrics.columns = ['session_id', 'session_start', 'session_end', 'action_count', 'unique_actions']
        session_metrics['session_duration'] = (session_metrics['session_end'] - session_metrics['session_start']).dt.total_seconds()
        
        return df, session_metrics
    
    def load_to_warehouse(self, df, table_name):
        """Load data to data warehouse"""
        try:
            # Create table if not exists
            self.target_db.create_table_if_not_exists(table_name, df)
            
            # Insert data
            self.target_db.insert_dataframe(df, table_name)
            
            self.logger.info(f"Successfully loaded {len(df)} rows to {table_name}")
            
        except Exception as e:
            self.logger.error(f"Failed to load data to {table_name}: {str(e)}")
            raise
    
    def run_pipeline(self, start_date, end_date):
        """Run the complete ETL pipeline"""
        try:
            # Extract data
            self.logger.info("Extracting user data...")
            user_data = self.extract_user_data(start_date, end_date)
            
            self.logger.info("Extracting engagement data...")
            engagement_data = self.extract_engagement_data(start_date, end_date)
            
            # Transform data
            self.logger.info("Transforming user data...")
            user_data_transformed = self.transform_user_data(user_data)
            
            self.logger.info("Transforming engagement data...")
            engagement_data_transformed, session_metrics = self.transform_engagement_data(engagement_data)
            
            # Load data
            self.logger.info("Loading user data to warehouse...")
            self.load_to_warehouse(user_data_transformed, 'dim_users')
            
            self.logger.info("Loading engagement data to warehouse...")
            self.load_to_warehouse(engagement_data_transformed, 'fact_user_actions')
            self.load_to_warehouse(session_metrics, 'fact_sessions')
            
            self.logger.info("ETL pipeline completed successfully")
            
        except Exception as e:
            self.logger.error(f"ETL pipeline failed: {str(e)}")
            raise
```

### Real-time Data Processing
```python
# real_time_processing.py
import json
import time
from kafka import KafkaConsumer, KafkaProducer
from collections import defaultdict, Counter

class RealTimeProcessor:
    def __init__(self, kafka_config):
        self.consumer = KafkaConsumer(
            'user_events',
            bootstrap_servers=kafka_config['bootstrap_servers'],
            value_deserializer=lambda x: json.loads(x.decode('utf-8'))
        )
        
        self.producer = KafkaProducer(
            bootstrap_servers=kafka_config['bootstrap_servers'],
            value_serializer=lambda x: json.dumps(x).encode('utf-8')
        )
        
        self.metrics = defaultdict(Counter)
        self.window_size = 300  # 5 minutes
        self.last_window = int(time.time() // self.window_size)
    
    def process_event(self, event):
        """Process a single event"""
        event_type = event['type']
        user_id = event['user_id']
        timestamp = event['timestamp']
        
        # Update metrics
        current_window = int(timestamp // self.window_size)
        
        if current_window != self.last_window:
            # Send metrics for previous window
            self.send_window_metrics()
            self.metrics.clear()
            self.last_window = current_window
        
        # Update counters
        self.metrics[current_window][f'events_{event_type}'] += 1
        self.metrics[current_window]['unique_users'].add(user_id)
        self.metrics[current_window]['total_events'] += 1
        
        # Process specific event types
        if event_type == 'page_view':
            self.process_page_view(event)
        elif event_type == 'purchase':
            self.process_purchase(event)
        elif event_type == 'user_registration':
            self.process_user_registration(event)
    
    def process_page_view(self, event):
        """Process page view event"""
        page = event['page']
        self.metrics[self.last_window][f'page_views_{page}'] += 1
        
        # Track popular pages
        if self.metrics[self.last_window][f'page_views_{page}'] > 100:
            self.send_alert('high_traffic_page', {
                'page': page,
                'views': self.metrics[self.last_window][f'page_views_{page}']
            })
    
    def process_purchase(self, event):
        """Process purchase event"""
        amount = event['amount']
        self.metrics[self.last_window]['total_revenue'] += amount
        self.metrics[self.last_window]['purchases'] += 1
        
        # Track high-value purchases
        if amount > 1000:
            self.send_alert('high_value_purchase', {
                'user_id': event['user_id'],
                'amount': amount
            })
    
    def process_user_registration(self, event):
        """Process user registration event"""
        self.metrics[self.last_window]['new_users'] += 1
        
        # Track registration source
        source = event.get('source', 'unknown')
        self.metrics[self.last_window][f'registrations_{source}'] += 1
    
    def send_window_metrics(self):
        """Send metrics for a time window"""
        if not self.metrics:
            return
        
        window_metrics = {
            'window_start': self.last_window * self.window_size,
            'window_end': (self.last_window + 1) * self.window_size,
            'metrics': dict(self.metrics[self.last_window])
        }
        
        # Send to analytics topic
        self.producer.send('analytics_metrics', window_metrics)
        
        # Send to monitoring system
        self.send_to_monitoring(window_metrics)
    
    def send_alert(self, alert_type, data):
        """Send alert to monitoring system"""
        alert = {
            'type': alert_type,
            'timestamp': time.time(),
            'data': data
        }
        
        self.producer.send('alerts', alert)
    
    def send_to_monitoring(self, metrics):
        """Send metrics to monitoring system"""
        # Send to Prometheus
        for metric_name, value in metrics['metrics'].items():
            if isinstance(value, (int, float)):
                self.send_prometheus_metric(metric_name, value, metrics['window_start'])
    
    def send_prometheus_metric(self, name, value, timestamp):
        """Send metric to Prometheus"""
        # Implementation depends on your Prometheus setup
        pass
    
    def run(self):
        """Run the real-time processor"""
        try:
            for message in self.consumer:
                event = message.value
                self.process_event(event)
        except KeyboardInterrupt:
            self.logger.info("Stopping real-time processor...")
        finally:
            self.consumer.close()
            self.producer.close()
```

## Data Visualization

### Dashboard Creation
```python
# dashboard.py
import plotly.graph_objs as go
import plotly.express as px
from plotly.subplots import make_subplots
import pandas as pd
import dash
from dash import dcc, html, Input, Output

class AnalyticsDashboard:
    def __init__(self, data_source):
        self.data_source = data_source
        self.app = dash.Dash(__name__)
        self.setup_layout()
        self.setup_callbacks()
    
    def setup_layout(self):
        """Setup dashboard layout"""
        self.app.layout = html.Div([
            html.H1("REChain DAO Analytics Dashboard"),
            
            # Filters
            html.Div([
                html.Div([
                    html.Label("Date Range"),
                    dcc.DatePickerRange(
                        id='date-picker',
                        start_date=pd.Timestamp.now() - pd.Timedelta(days=30),
                        end_date=pd.Timestamp.now()
                    )
                ], className="filter-item"),
                
                html.Div([
                    html.Label("User Segment"),
                    dcc.Dropdown(
                        id='user-segment',
                        options=[
                            {'label': 'All', 'value': 'all'},
                            {'label': 'Inactive', 'value': 'Inactive'},
                            {'label': 'Low', 'value': 'Low'},
                            {'label': 'Medium', 'value': 'Medium'},
                            {'label': 'High', 'value': 'High'}
                        ],
                        value='all'
                    )
                ], className="filter-item")
            ], className="filters"),
            
            # KPI Cards
            html.Div([
                html.Div([
                    html.H3("Total Users"),
                    html.H2(id="total-users")
                ], className="kpi-card"),
                
                html.Div([
                    html.H3("Active Users"),
                    html.H2(id="active-users")
                ], className="kpi-card"),
                
                html.Div([
                    html.H3("Revenue"),
                    html.H2(id="revenue")
                ], className="kpi-card"),
                
                html.Div([
                    html.H3("Engagement Rate"),
                    html.H2(id="engagement-rate")
                ], className="kpi-card")
            ], className="kpi-row"),
            
            # Charts
            html.Div([
                dcc.Graph(id="user-growth-chart"),
                dcc.Graph(id="engagement-chart"),
                dcc.Graph(id="revenue-chart"),
                dcc.Graph(id="user-segment-chart")
            ], className="charts")
        ])
    
    def setup_callbacks(self):
        """Setup dashboard callbacks"""
        @self.app.callback(
            [Output("total-users", "children"),
             Output("active-users", "children"),
             Output("revenue", "children"),
             Output("engagement-rate", "children")],
            [Input("date-picker", "start_date"),
             Input("date-picker", "end_date"),
             Input("user-segment", "value")]
        )
        def update_kpis(start_date, end_date, user_segment):
            data = self.data_source.get_data(start_date, end_date, user_segment)
            
            total_users = data['total_users']
            active_users = data['active_users']
            revenue = f"${data['revenue']:,.2f}"
            engagement_rate = f"{data['engagement_rate']:.1%}"
            
            return total_users, active_users, revenue, engagement_rate
        
        @self.app.callback(
            Output("user-growth-chart", "figure"),
            [Input("date-picker", "start_date"),
             Input("date-picker", "end_date")]
        )
        def update_user_growth_chart(start_date, end_date):
            data = self.data_source.get_user_growth_data(start_date, end_date)
            
            fig = go.Figure()
            fig.add_trace(go.Scatter(
                x=data['date'],
                y=data['new_users'],
                mode='lines+markers',
                name='New Users',
                line=dict(color='#1f77b4')
            ))
            fig.add_trace(go.Scatter(
                x=data['date'],
                y=data['total_users'],
                mode='lines+markers',
                name='Total Users',
                line=dict(color='#ff7f0e')
            ))
            
            fig.update_layout(
                title="User Growth Over Time",
                xaxis_title="Date",
                yaxis_title="Number of Users",
                hovermode='x unified'
            )
            
            return fig
        
        @self.app.callback(
            Output("engagement-chart", "figure"),
            [Input("date-picker", "start_date"),
             Input("date-picker", "end_date")]
        )
        def update_engagement_chart(start_date, end_date):
            data = self.data_source.get_engagement_data(start_date, end_date)
            
            fig = make_subplots(
                rows=2, cols=2,
                subplot_titles=('Posts', 'Comments', 'Likes', 'Shares'),
                specs=[[{"secondary_y": False}, {"secondary_y": False}],
                       [{"secondary_y": False}, {"secondary_y": False}]]
            )
            
            fig.add_trace(
                go.Scatter(x=data['date'], y=data['posts'], name='Posts'),
                row=1, col=1
            )
            fig.add_trace(
                go.Scatter(x=data['date'], y=data['comments'], name='Comments'),
                row=1, col=2
            )
            fig.add_trace(
                go.Scatter(x=data['date'], y=data['likes'], name='Likes'),
                row=2, col=1
            )
            fig.add_trace(
                go.Scatter(x=data['date'], y=data['shares'], name='Shares'),
                row=2, col=2
            )
            
            fig.update_layout(
                title="Engagement Metrics Over Time",
                showlegend=False,
                height=600
            )
            
            return fig
    
    def run(self, debug=True, port=8050):
        """Run the dashboard"""
        self.app.run_server(debug=debug, port=port)
```

### Report Generation
```python
# report_generator.py
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from datetime import datetime, timedelta
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.base import MIMEBase
from email import encoders

class ReportGenerator:
    def __init__(self, data_source):
        self.data_source = data_source
        self.setup_plotting()
    
    def setup_plotting(self):
        """Setup plotting style"""
        plt.style.use('seaborn-v0_8')
        sns.set_palette("husl")
    
    def generate_daily_report(self, date):
        """Generate daily analytics report"""
        data = self.data_source.get_daily_data(date)
        
        # Create report
        report = {
            'date': date,
            'summary': self.generate_summary(data),
            'charts': self.generate_charts(data),
            'insights': self.generate_insights(data)
        }
        
        return report
    
    def generate_weekly_report(self, start_date, end_date):
        """Generate weekly analytics report"""
        data = self.data_source.get_weekly_data(start_date, end_date)
        
        # Create report
        report = {
            'period': f"{start_date} to {end_date}",
            'summary': self.generate_summary(data),
            'charts': self.generate_charts(data),
            'insights': self.generate_insights(data),
            'recommendations': self.generate_recommendations(data)
        }
        
        return report
    
    def generate_summary(self, data):
        """Generate summary statistics"""
        return {
            'total_users': data['total_users'],
            'new_users': data['new_users'],
            'active_users': data['active_users'],
            'total_revenue': data['total_revenue'],
            'engagement_rate': data['engagement_rate'],
            'top_pages': data['top_pages'][:5],
            'top_sources': data['top_sources'][:5]
        }
    
    def generate_charts(self, data):
        """Generate charts for report"""
        charts = {}
        
        # User growth chart
        fig, ax = plt.subplots(figsize=(12, 6))
        ax.plot(data['dates'], data['user_counts'], marker='o')
        ax.set_title('User Growth Over Time')
        ax.set_xlabel('Date')
        ax.set_ylabel('Number of Users')
        ax.grid(True)
        charts['user_growth'] = fig
        
        # Engagement pie chart
        fig, ax = plt.subplots(figsize=(8, 8))
        engagement_data = [data['posts'], data['comments'], data['likes'], data['shares']]
        labels = ['Posts', 'Comments', 'Likes', 'Shares']
        ax.pie(engagement_data, labels=labels, autopct='%1.1f%%')
        ax.set_title('Engagement Distribution')
        charts['engagement_pie'] = fig
        
        return charts
    
    def generate_insights(self, data):
        """Generate insights from data"""
        insights = []
        
        # User growth insight
        if data['user_growth_rate'] > 0.1:
            insights.append(f"Strong user growth: {data['user_growth_rate']:.1%} increase")
        elif data['user_growth_rate'] < -0.05:
            insights.append(f"User decline: {data['user_growth_rate']:.1%} decrease")
        
        # Engagement insight
        if data['engagement_rate'] > 0.5:
            insights.append("High engagement rate indicates strong user activity")
        elif data['engagement_rate'] < 0.2:
            insights.append("Low engagement rate suggests need for user activation")
        
        # Revenue insight
        if data['revenue_growth_rate'] > 0.2:
            insights.append(f"Strong revenue growth: {data['revenue_growth_rate']:.1%} increase")
        
        return insights
    
    def generate_recommendations(self, data):
        """Generate recommendations based on data"""
        recommendations = []
        
        # User acquisition recommendations
        if data['new_user_rate'] < 0.05:
            recommendations.append("Consider increasing marketing spend to boost user acquisition")
        
        # Engagement recommendations
        if data['engagement_rate'] < 0.3:
            recommendations.append("Implement user engagement campaigns to increase activity")
        
        # Revenue recommendations
        if data['revenue_per_user'] < 10:
            recommendations.append("Focus on increasing revenue per user through upselling")
        
        return recommendations
    
    def send_report_email(self, report, recipients):
        """Send report via email"""
        msg = MIMEMultipart()
        msg['From'] = "analytics@rechain-dao.com"
        msg['To'] = ", ".join(recipients)
        msg['Subject'] = f"Analytics Report - {report['period']}"
        
        # Create HTML content
        html_content = self.create_html_report(report)
        msg.attach(MIMEText(html_content, 'html'))
        
        # Send email
        server = smtplib.SMTP('smtp.gmail.com', 587)
        server.starttls()
        server.login("analytics@rechain-dao.com", "password")
        text = msg.as_string()
        server.sendmail("analytics@rechain-dao.com", recipients, text)
        server.quit()
    
    def create_html_report(self, report):
        """Create HTML report"""
        html = f"""
        <html>
        <head>
            <title>Analytics Report</title>
            <style>
                body {{ font-family: Arial, sans-serif; margin: 20px; }}
                .summary {{ background-color: #f5f5f5; padding: 20px; border-radius: 5px; }}
                .metric {{ display: inline-block; margin: 10px; padding: 10px; background-color: white; border-radius: 3px; }}
                .insights {{ margin-top: 20px; }}
                .recommendations {{ margin-top: 20px; }}
            </style>
        </head>
        <body>
            <h1>Analytics Report - {report['period']}</h1>
            
            <div class="summary">
                <h2>Summary</h2>
                <div class="metric">
                    <h3>Total Users</h3>
                    <p>{report['summary']['total_users']:,}</p>
                </div>
                <div class="metric">
                    <h3>New Users</h3>
                    <p>{report['summary']['new_users']:,}</p>
                </div>
                <div class="metric">
                    <h3>Active Users</h3>
                    <p>{report['summary']['active_users']:,}</p>
                </div>
                <div class="metric">
                    <h3>Revenue</h3>
                    <p>${report['summary']['total_revenue']:,.2f}</p>
                </div>
            </div>
            
            <div class="insights">
                <h2>Insights</h2>
                <ul>
                    {''.join(f'<li>{insight}</li>' for insight in report['insights'])}
                </ul>
            </div>
            
            <div class="recommendations">
                <h2>Recommendations</h2>
                <ul>
                    {''.join(f'<li>{rec}</li>' for rec in report['recommendations'])}
                </ul>
            </div>
        </body>
        </html>
        """
        
        return html
```

## Business Intelligence

### KPI Dashboard
```python
# kpi_dashboard.py
class KPIDashboard:
    def __init__(self, data_source):
        self.data_source = data_source
        self.kpis = {
            'user_acquisition': self.calculate_user_acquisition_kpi,
            'user_retention': self.calculate_user_retention_kpi,
            'engagement': self.calculate_engagement_kpi,
            'revenue': self.calculate_revenue_kpi,
            'conversion': self.calculate_conversion_kpi
        }
    
    def calculate_user_acquisition_kpi(self, start_date, end_date):
        """Calculate user acquisition KPI"""
        data = self.data_source.get_user_data(start_date, end_date)
        
        total_users = len(data)
        new_users = len(data[data['is_new_user'] == True])
        acquisition_rate = new_users / total_users if total_users > 0 else 0
        
        return {
            'metric': 'User Acquisition Rate',
            'value': acquisition_rate,
            'target': 0.15,
            'status': 'good' if acquisition_rate >= 0.15 else 'needs_improvement',
            'trend': self.calculate_trend(data, 'user_acquisition')
        }
    
    def calculate_user_retention_kpi(self, start_date, end_date):
        """Calculate user retention KPI"""
        data = self.data_source.get_user_data(start_date, end_date)
        
        # Calculate 30-day retention
        retained_users = len(data[data['days_since_last_login'] <= 30])
        total_users = len(data)
        retention_rate = retained_users / total_users if total_users > 0 else 0
        
        return {
            'metric': '30-Day Retention Rate',
            'value': retention_rate,
            'target': 0.7,
            'status': 'good' if retention_rate >= 0.7 else 'needs_improvement',
            'trend': self.calculate_trend(data, 'user_retention')
        }
    
    def calculate_engagement_kpi(self, start_date, end_date):
        """Calculate engagement KPI"""
        data = self.data_source.get_engagement_data(start_date, end_date)
        
        # Calculate daily active users
        dau = data['daily_active_users'].mean()
        mau = data['monthly_active_users'].mean()
        engagement_rate = dau / mau if mau > 0 else 0
        
        return {
            'metric': 'DAU/MAU Ratio',
            'value': engagement_rate,
            'target': 0.2,
            'status': 'good' if engagement_rate >= 0.2 else 'needs_improvement',
            'trend': self.calculate_trend(data, 'engagement')
        }
    
    def calculate_revenue_kpi(self, start_date, end_date):
        """Calculate revenue KPI"""
        data = self.data_source.get_revenue_data(start_date, end_date)
        
        total_revenue = data['revenue'].sum()
        total_users = data['user_count'].sum()
        revenue_per_user = total_revenue / total_users if total_users > 0 else 0
        
        return {
            'metric': 'Revenue Per User',
            'value': revenue_per_user,
            'target': 50,
            'status': 'good' if revenue_per_user >= 50 else 'needs_improvement',
            'trend': self.calculate_trend(data, 'revenue')
        }
    
    def calculate_conversion_kpi(self, start_date, end_date):
        """Calculate conversion KPI"""
        data = self.data_source.get_conversion_data(start_date, end_date)
        
        total_visitors = data['visitors'].sum()
        total_conversions = data['conversions'].sum()
        conversion_rate = total_conversions / total_visitors if total_visitors > 0 else 0
        
        return {
            'metric': 'Conversion Rate',
            'value': conversion_rate,
            'target': 0.03,
            'status': 'good' if conversion_rate >= 0.03 else 'needs_improvement',
            'trend': self.calculate_trend(data, 'conversion')
        }
    
    def calculate_trend(self, data, metric):
        """Calculate trend for a metric"""
        if len(data) < 2:
            return 'stable'
        
        # Calculate percentage change
        current_value = data[metric].iloc[-1]
        previous_value = data[metric].iloc[-2]
        
        if previous_value == 0:
            return 'stable'
        
        change = (current_value - previous_value) / previous_value
        
        if change > 0.05:
            return 'increasing'
        elif change < -0.05:
            return 'decreasing'
        else:
            return 'stable'
    
    def get_all_kpis(self, start_date, end_date):
        """Get all KPIs for a date range"""
        kpis = {}
        
        for kpi_name, kpi_func in self.kpis.items():
            kpis[kpi_name] = kpi_func(start_date, end_date)
        
        return kpis
```

## Conclusion

This Analytics Guide provides comprehensive instructions for implementing analytics and reporting systems in the REChain DAO platform. By following these guidelines and using the recommended tools and practices, you can create powerful analytics capabilities that provide valuable insights into user behavior, platform performance, and business metrics.

Remember: Analytics is about turning data into actionable insights. Focus on metrics that drive business decisions and continuously refine your analytics approach based on user feedback and changing business needs.
