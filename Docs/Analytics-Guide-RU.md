# Руководство по аналитике и отчетности

## Обзор

Это руководство предоставляет комплексные инструкции по внедрению и использованию аналитических функций в платформе REChain DAO, включая сбор данных, обработку, визуализацию и бизнес-аналитику.

## Содержание

1. [Архитектура аналитики](#архитектура-аналитики)
2. [Сбор данных](#сбор-данных)
3. [Обработка данных](#обработка-данных)
4. [Визуализация данных](#визуализация-данных)
5. [Бизнес-аналитика](#бизнес-аналитика)
6. [Мониторинг производительности](#мониторинг-производительности)
7. [Отчетность](#отчетность)

## Архитектура аналитики

### Обзор системы
```
┌─────────────────────────────────────────────────────────────┐
│                    Слой аналитики                          │
├─────────────────────────────────────────────────────────────┤
│  Дашборды и отчеты                                         │
│  ├── Пользовательские дашборды                             │
│  ├── Административные отчеты                               │
│  ├── Бизнес-аналитика                                      │
│  └── Мобильные приложения                                  │
├─────────────────────────────────────────────────────────────┤
│  Слой визуализации                                         │
│  ├── Grafana                                               │
│  ├── Custom dashboards                                     │
│  ├── Real-time monitoring                                  │
│  └── Alerting systems                                      │
├─────────────────────────────────────────────────────────────┤
│  Слой обработки данных                                     │
│  ├── Apache Spark                                          │
│  ├── Apache Kafka                                          │
│  ├── Data pipelines                                        │
│  └── Machine learning models                               │
├─────────────────────────────────────────────────────────────┤
│  Слой хранения данных                                      │
│  ├── Time series database (InfluxDB)                      │
│  ├── Data warehouse (ClickHouse)                          │
│  ├── Data lake (S3)                                       │
│  └── Cache layer (Redis)                                  │
├─────────────────────────────────────────────────────────────┤
│  Слой сбора данных                                         │
│  ├── Application metrics                                   │
│  ├── User behavior tracking                                │
│  ├── System metrics                                        │
│  └── External data sources                                 │
└─────────────────────────────────────────────────────────────┘
```

### Технологический стек
- **Сбор данных**: Prometheus, Grafana Agent, Custom collectors
- **Обработка**: Apache Spark, Apache Kafka, Apache Airflow
- **Хранение**: InfluxDB, ClickHouse, PostgreSQL, Redis
- **Визуализация**: Grafana, Custom dashboards, D3.js
- **Аналитика**: Python, R, Jupyter Notebooks
- **Мониторинг**: Prometheus, Grafana, AlertManager

## Сбор данных

### Метрики приложения
```python
# metrics_collector.py
import time
import psutil
from prometheus_client import Counter, Histogram, Gauge, start_http_server

class MetricsCollector:
    def __init__(self):
        # Счетчики
        self.request_count = Counter('http_requests_total', 'Total HTTP requests', ['method', 'endpoint'])
        self.error_count = Counter('http_errors_total', 'Total HTTP errors', ['status_code'])
        
        # Гистограммы
        self.request_duration = Histogram('http_request_duration_seconds', 'HTTP request duration')
        self.database_query_duration = Histogram('database_query_duration_seconds', 'Database query duration')
        
        # Датчики
        self.active_users = Gauge('active_users', 'Number of active users')
        self.memory_usage = Gauge('memory_usage_bytes', 'Memory usage in bytes')
        self.cpu_usage = Gauge('cpu_usage_percent', 'CPU usage percentage')
    
    def record_request(self, method, endpoint, duration, status_code):
        """Записать метрику HTTP запроса"""
        self.request_count.labels(method=method, endpoint=endpoint).inc()
        self.request_duration.observe(duration)
        
        if status_code >= 400:
            self.error_count.labels(status_code=str(status_code)).inc()
    
    def record_database_query(self, query_type, duration):
        """Записать метрику запроса к базе данных"""
        self.database_query_duration.observe(duration)
    
    def update_system_metrics(self):
        """Обновить системные метрики"""
        self.memory_usage.set(psutil.virtual_memory().used)
        self.cpu_usage.set(psutil.cpu_percent())
    
    def start_metrics_server(self, port=8000):
        """Запустить сервер метрик"""
        start_http_server(port)
```

### Отслеживание поведения пользователей
```python
# user_behavior_tracker.py
import json
import time
from datetime import datetime
from typing import Dict, Any

class UserBehaviorTracker:
    def __init__(self, kafka_producer):
        self.kafka_producer = kafka_producer
        self.topic = 'user_behavior'
    
    def track_page_view(self, user_id: str, page: str, session_id: str):
        """Отследить просмотр страницы"""
        event = {
            'event_type': 'page_view',
            'user_id': user_id,
            'session_id': session_id,
            'page': page,
            'timestamp': datetime.utcnow().isoformat(),
            'properties': {
                'url': page,
                'referrer': self.get_referrer(),
                'user_agent': self.get_user_agent()
            }
        }
        
        self.send_event(event)
    
    def track_user_action(self, user_id: str, action: str, properties: Dict[str, Any]):
        """Отследить действие пользователя"""
        event = {
            'event_type': 'user_action',
            'user_id': user_id,
            'action': action,
            'timestamp': datetime.utcnow().isoformat(),
            'properties': properties
        }
        
        self.send_event(event)
    
    def track_conversion(self, user_id: str, conversion_type: str, value: float):
        """Отследить конверсию"""
        event = {
            'event_type': 'conversion',
            'user_id': user_id,
            'conversion_type': conversion_type,
            'value': value,
            'timestamp': datetime.utcnow().isoformat()
        }
        
        self.send_event(event)
    
    def send_event(self, event: Dict[str, Any]):
        """Отправить событие в Kafka"""
        self.kafka_producer.send(
            self.topic,
            value=json.dumps(event).encode('utf-8')
        )
```

## Обработка данных

### Пайплайн обработки данных
```python
# data_pipeline.py
from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *
import json

class DataPipeline:
    def __init__(self):
        self.spark = SparkSession.builder \
            .appName("REChain Analytics Pipeline") \
            .config("spark.sql.adaptive.enabled", "true") \
            .config("spark.sql.adaptive.coalescePartitions.enabled", "true") \
            .getOrCreate()
    
    def process_user_events(self, input_path: str, output_path: str):
        """Обработать события пользователей"""
        # Загрузить данные
        df = self.spark.read.json(input_path)
        
        # Очистить и преобразовать данные
        processed_df = df.select(
            col("user_id"),
            col("event_type"),
            col("timestamp"),
            col("properties"),
            from_unixtime(col("timestamp")).alias("event_time")
        ).filter(
            col("user_id").isNotNull() &
            col("event_type").isNotNull()
        )
        
        # Агрегировать по пользователям
        user_metrics = processed_df.groupBy("user_id") \
            .agg(
                count("*").alias("total_events"),
                countDistinct("event_type").alias("unique_event_types"),
                min("event_time").alias("first_event"),
                max("event_time").alias("last_event")
            )
        
        # Сохранить результаты
        user_metrics.write \
            .mode("overwrite") \
            .parquet(output_path)
    
    def process_engagement_metrics(self, input_path: str, output_path: str):
        """Обработать метрики вовлеченности"""
        df = self.spark.read.json(input_path)
        
        # Вычислить метрики вовлеченности
        engagement_metrics = df.groupBy(
            date_format(col("event_time"), "yyyy-MM-dd").alias("date")
        ).agg(
            countDistinct("user_id").alias("daily_active_users"),
            count("*").alias("total_events"),
            countDistinct("session_id").alias("total_sessions"),
            avg("session_duration").alias("avg_session_duration")
        )
        
        # Сохранить результаты
        engagement_metrics.write \
            .mode("overwrite") \
            .parquet(output_path)
```

### Агрегация данных
```python
# data_aggregation.py
from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *

class DataAggregation:
    def __init__(self, spark_session):
        self.spark = spark_session
    
    def aggregate_daily_metrics(self, input_path: str, output_path: str):
        """Агрегировать ежедневные метрики"""
        df = self.spark.read.parquet(input_path)
        
        # Агрегировать по дням
        daily_metrics = df.groupBy(
            date_format(col("event_time"), "yyyy-MM-dd").alias("date")
        ).agg(
            countDistinct("user_id").alias("daily_active_users"),
            count("*").alias("total_events"),
            countDistinct("session_id").alias("total_sessions"),
            avg("session_duration").alias("avg_session_duration"),
            sum("revenue").alias("daily_revenue")
        )
        
        # Вычислить скользящие средние
        window_spec = Window.partitionBy().orderBy("date").rowsBetween(-6, 0)
        daily_metrics = daily_metrics.withColumn(
            "dau_7day_avg",
            avg("daily_active_users").over(window_spec)
        )
        
        # Сохранить результаты
        daily_metrics.write \
            .mode("overwrite") \
            .parquet(output_path)
    
    def aggregate_user_segments(self, input_path: str, output_path: str):
        """Агрегировать данные по сегментам пользователей"""
        df = self.spark.read.parquet(input_path)
        
        # Определить сегменты пользователей
        user_segments = df.withColumn(
            "user_segment",
            when(col("total_events") > 100, "high_engagement")
            .when(col("total_events") > 50, "medium_engagement")
            .otherwise("low_engagement")
        )
        
        # Агрегировать по сегментам
        segment_metrics = user_segments.groupBy("user_segment") \
            .agg(
                countDistinct("user_id").alias("user_count"),
                avg("total_events").alias("avg_events"),
                avg("session_duration").alias("avg_session_duration"),
                sum("revenue").alias("total_revenue")
            )
        
        # Сохранить результаты
        segment_metrics.write \
            .mode("overwrite") \
            .parquet(output_path)
```

## Визуализация данных

### Дашборд метрик
```python
# dashboard_generator.py
import plotly.graph_objects as go
import plotly.express as px
from plotly.subplots import make_subplots
import pandas as pd

class DashboardGenerator:
    def __init__(self):
        self.colors = {
            'primary': '#1f77b4',
            'secondary': '#ff7f0e',
            'success': '#2ca02c',
            'warning': '#d62728',
            'info': '#9467bd'
        }
    
    def create_user_engagement_dashboard(self, data: pd.DataFrame):
        """Создать дашборд вовлеченности пользователей"""
        fig = make_subplots(
            rows=2, cols=2,
            subplot_titles=('Daily Active Users', 'Session Duration', 'Event Types', 'User Segments'),
            specs=[[{"secondary_y": False}, {"secondary_y": False}],
                   [{"secondary_y": False}, {"secondary_y": False}]]
        )
        
        # График ежедневных активных пользователей
        fig.add_trace(
            go.Scatter(
                x=data['date'],
                y=data['daily_active_users'],
                mode='lines+markers',
                name='DAU',
                line=dict(color=self.colors['primary'])
            ),
            row=1, col=1
        )
        
        # График продолжительности сессий
        fig.add_trace(
            go.Bar(
                x=data['date'],
                y=data['avg_session_duration'],
                name='Avg Session Duration',
                marker_color=self.colors['secondary']
            ),
            row=1, col=2
        )
        
        # График типов событий
        event_counts = data.groupby('event_type').size()
        fig.add_trace(
            go.Pie(
                labels=event_counts.index,
                values=event_counts.values,
                name="Event Types"
            ),
            row=2, col=1
        )
        
        # График сегментов пользователей
        segment_counts = data.groupby('user_segment').size()
        fig.add_trace(
            go.Bar(
                x=segment_counts.index,
                y=segment_counts.values,
                name='User Segments',
                marker_color=self.colors['success']
            ),
            row=2, col=2
        )
        
        fig.update_layout(
            title="User Engagement Dashboard",
            showlegend=True,
            height=800
        )
        
        return fig
    
    def create_revenue_dashboard(self, data: pd.DataFrame):
        """Создать дашборд доходов"""
        fig = make_subplots(
            rows=2, cols=2,
            subplot_titles=('Daily Revenue', 'Revenue by Source', 'Monthly Revenue', 'Revenue Growth'),
            specs=[[{"secondary_y": False}, {"secondary_y": False}],
                   [{"secondary_y": False}, {"secondary_y": False}]]
        )
        
        # График ежедневных доходов
        fig.add_trace(
            go.Scatter(
                x=data['date'],
                y=data['daily_revenue'],
                mode='lines+markers',
                name='Daily Revenue',
                line=dict(color=self.colors['primary'])
            ),
            row=1, col=1
        )
        
        # График доходов по источникам
        revenue_by_source = data.groupby('revenue_source')['revenue'].sum()
        fig.add_trace(
            go.Bar(
                x=revenue_by_source.index,
                y=revenue_by_source.values,
                name='Revenue by Source',
                marker_color=self.colors['secondary']
            ),
            row=1, col=2
        )
        
        # График месячных доходов
        monthly_revenue = data.groupby(data['date'].dt.to_period('M'))['revenue'].sum()
        fig.add_trace(
            go.Bar(
                x=monthly_revenue.index.astype(str),
                y=monthly_revenue.values,
                name='Monthly Revenue',
                marker_color=self.colors['success']
            ),
            row=2, col=1
        )
        
        # График роста доходов
        revenue_growth = data['daily_revenue'].pct_change() * 100
        fig.add_trace(
            go.Scatter(
                x=data['date'],
                y=revenue_growth,
                mode='lines+markers',
                name='Revenue Growth %',
                line=dict(color=self.colors['warning'])
            ),
            row=2, col=2
        )
        
        fig.update_layout(
            title="Revenue Dashboard",
            showlegend=True,
            height=800
        )
        
        return fig
```

## Бизнес-аналитика

### Анализ когорт
```python
# cohort_analysis.py
import pandas as pd
import numpy as np
from datetime import datetime, timedelta

class CohortAnalysis:
    def __init__(self):
        self.cohort_data = None
    
    def create_cohort_analysis(self, user_data: pd.DataFrame):
        """Создать анализ когорт"""
        # Определить когорты по дате регистрации
        user_data['cohort_month'] = user_data['registration_date'].dt.to_period('M')
        
        # Создать таблицу когорт
        cohort_table = user_data.groupby(['cohort_month', 'user_id']) \
            .agg({
                'event_date': 'min',
                'revenue': 'sum'
            }).reset_index()
        
        # Вычислить метрики когорт
        cohort_metrics = cohort_table.groupby('cohort_month') \
            .agg({
                'user_id': 'count',
                'revenue': 'sum'
            }).reset_index()
        
        cohort_metrics.columns = ['cohort_month', 'user_count', 'total_revenue']
        
        return cohort_metrics
    
    def calculate_retention_rate(self, user_data: pd.DataFrame):
        """Вычислить коэффициент удержания"""
        # Определить когорты
        user_data['cohort_month'] = user_data['registration_date'].dt.to_period('M')
        
        # Создать таблицу удержания
        retention_table = user_data.groupby(['cohort_month', 'user_id']) \
            .agg({
                'event_date': 'min'
            }).reset_index()
        
        # Вычислить коэффициент удержания
        retention_rates = retention_table.groupby('cohort_month') \
            .agg({
                'user_id': 'count'
            }).reset_index()
        
        return retention_rates
```

### Прогнозирование
```python
# forecasting.py
import pandas as pd
import numpy as np
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error, r2_score
from datetime import datetime, timedelta

class Forecasting:
    def __init__(self):
        self.model = LinearRegression()
        self.features = []
    
    def prepare_features(self, data: pd.DataFrame):
        """Подготовить признаки для прогнозирования"""
        # Временные признаки
        data['year'] = data['date'].dt.year
        data['month'] = data['date'].dt.month
        data['day'] = data['date'].dt.day
        data['day_of_week'] = data['date'].dt.dayofweek
        
        # Лаговые признаки
        data['revenue_lag_1'] = data['revenue'].shift(1)
        data['revenue_lag_7'] = data['revenue'].shift(7)
        data['revenue_lag_30'] = data['revenue'].shift(30)
        
        # Скользящие средние
        data['revenue_ma_7'] = data['revenue'].rolling(window=7).mean()
        data['revenue_ma_30'] = data['revenue'].rolling(window=30).mean()
        
        # Тренд
        data['trend'] = np.arange(len(data))
        
        self.features = ['year', 'month', 'day', 'day_of_week', 
                        'revenue_lag_1', 'revenue_lag_7', 'revenue_lag_30',
                        'revenue_ma_7', 'revenue_ma_30', 'trend']
        
        return data
    
    def train_model(self, data: pd.DataFrame):
        """Обучить модель прогнозирования"""
        # Подготовить данные
        data = self.prepare_features(data)
        
        # Удалить строки с NaN
        data = data.dropna()
        
        # Разделить на признаки и целевую переменную
        X = data[self.features]
        y = data['revenue']
        
        # Обучить модель
        self.model.fit(X, y)
        
        # Оценить модель
        y_pred = self.model.predict(X)
        mse = mean_squared_error(y, y_pred)
        r2 = r2_score(y, y_pred)
        
        print(f"Mean Squared Error: {mse:.2f}")
        print(f"R² Score: {r2:.2f}")
        
        return self.model
    
    def predict(self, data: pd.DataFrame, days_ahead: int = 30):
        """Сделать прогноз на будущие дни"""
        # Подготовить данные
        data = self.prepare_features(data)
        
        # Создать будущие даты
        last_date = data['date'].max()
        future_dates = pd.date_range(
            start=last_date + timedelta(days=1),
            periods=days_ahead,
            freq='D'
        )
        
        # Создать DataFrame для прогноза
        future_data = pd.DataFrame({'date': future_dates})
        future_data = self.prepare_features(future_data)
        
        # Сделать прогноз
        X_future = future_data[self.features]
        predictions = self.model.predict(X_future)
        
        # Создать результат
        result = pd.DataFrame({
            'date': future_dates,
            'predicted_revenue': predictions
        })
        
        return result
```

## Мониторинг производительности

### Система мониторинга
```python
# performance_monitor.py
import psutil
import time
from prometheus_client import Gauge, Counter, Histogram, start_http_server

class PerformanceMonitor:
    def __init__(self):
        # Системные метрики
        self.cpu_usage = Gauge('system_cpu_usage_percent', 'CPU usage percentage')
        self.memory_usage = Gauge('system_memory_usage_bytes', 'Memory usage in bytes')
        self.disk_usage = Gauge('system_disk_usage_bytes', 'Disk usage in bytes')
        self.network_io = Gauge('system_network_io_bytes', 'Network I/O in bytes')
        
        # Метрики приложения
        self.request_count = Counter('app_requests_total', 'Total application requests')
        self.error_count = Counter('app_errors_total', 'Total application errors')
        self.response_time = Histogram('app_response_time_seconds', 'Application response time')
        
        # Метрики базы данных
        self.db_connections = Gauge('db_connections_active', 'Active database connections')
        self.db_query_time = Histogram('db_query_time_seconds', 'Database query time')
        
    def collect_system_metrics(self):
        """Собрать системные метрики"""
        # CPU
        cpu_percent = psutil.cpu_percent(interval=1)
        self.cpu_usage.set(cpu_percent)
        
        # Память
        memory = psutil.virtual_memory()
        self.memory_usage.set(memory.used)
        
        # Диск
        disk = psutil.disk_usage('/')
        self.disk_usage.set(disk.used)
        
        # Сеть
        network = psutil.net_io_counters()
        self.network_io.set(network.bytes_sent + network.bytes_recv)
    
    def start_monitoring(self, port=8000):
        """Запустить мониторинг"""
        start_http_server(port)
        
        while True:
            self.collect_system_metrics()
            time.sleep(10)
```

## Отчетность

### Генератор отчетов
```python
# report_generator.py
import pandas as pd
from datetime import datetime, timedelta
import json

class ReportGenerator:
    def __init__(self):
        self.report_templates = {
            'daily_summary': self.generate_daily_summary,
            'weekly_analysis': self.generate_weekly_analysis,
            'monthly_report': self.generate_monthly_report,
            'user_engagement': self.generate_user_engagement_report
        }
    
    def generate_daily_summary(self, data: pd.DataFrame):
        """Сгенерировать ежедневный отчет"""
        today = datetime.now().date()
        today_data = data[data['date'].dt.date == today]
        
        summary = {
            'date': today.isoformat(),
            'total_users': today_data['user_id'].nunique(),
            'total_events': len(today_data),
            'total_revenue': today_data['revenue'].sum(),
            'avg_session_duration': today_data['session_duration'].mean(),
            'top_events': today_data['event_type'].value_counts().head(5).to_dict()
        }
        
        return summary
    
    def generate_weekly_analysis(self, data: pd.DataFrame):
        """Сгенерировать еженедельный анализ"""
        week_ago = datetime.now() - timedelta(days=7)
        week_data = data[data['date'] >= week_ago]
        
        analysis = {
            'period': f"{week_ago.date()} - {datetime.now().date()}",
            'weekly_active_users': week_data['user_id'].nunique(),
            'total_events': len(week_data),
            'total_revenue': week_data['revenue'].sum(),
            'avg_daily_revenue': week_data.groupby(week_data['date'].dt.date)['revenue'].sum().mean(),
            'user_growth': self.calculate_user_growth(week_data),
            'revenue_growth': self.calculate_revenue_growth(week_data)
        }
        
        return analysis
    
    def generate_monthly_report(self, data: pd.DataFrame):
        """Сгенерировать месячный отчет"""
        month_ago = datetime.now() - timedelta(days=30)
        month_data = data[data['date'] >= month_ago]
        
        report = {
            'period': f"{month_ago.date()} - {datetime.now().date()}",
            'monthly_active_users': month_data['user_id'].nunique(),
            'total_events': len(month_data),
            'total_revenue': month_data['revenue'].sum(),
            'avg_daily_revenue': month_data.groupby(month_data['date'].dt.date)['revenue'].sum().mean(),
            'user_retention': self.calculate_user_retention(month_data),
            'revenue_retention': self.calculate_revenue_retention(month_data),
            'top_performing_features': self.get_top_features(month_data)
        }
        
        return report
    
    def calculate_user_growth(self, data: pd.DataFrame):
        """Вычислить рост пользователей"""
        daily_users = data.groupby(data['date'].dt.date)['user_id'].nunique()
        growth_rate = daily_users.pct_change().mean() * 100
        return round(growth_rate, 2)
    
    def calculate_revenue_growth(self, data: pd.DataFrame):
        """Вычислить рост доходов"""
        daily_revenue = data.groupby(data['date'].dt.date)['revenue'].sum()
        growth_rate = daily_revenue.pct_change().mean() * 100
        return round(growth_rate, 2)
    
    def calculate_user_retention(self, data: pd.DataFrame):
        """Вычислить удержание пользователей"""
        # Простая метрика удержания
        total_users = data['user_id'].nunique()
        active_users = data[data['date'] >= datetime.now() - timedelta(days=7)]['user_id'].nunique()
        retention_rate = (active_users / total_users) * 100
        return round(retention_rate, 2)
    
    def calculate_revenue_retention(self, data: pd.DataFrame):
        """Вычислить удержание доходов"""
        # Простая метрика удержания доходов
        total_revenue = data['revenue'].sum()
        recent_revenue = data[data['date'] >= datetime.now() - timedelta(days=7)]['revenue'].sum()
        retention_rate = (recent_revenue / total_revenue) * 100
        return round(retention_rate, 2)
    
    def get_top_features(self, data: pd.DataFrame):
        """Получить топ-функции"""
        feature_usage = data.groupby('feature')['user_id'].nunique().sort_values(ascending=False)
        return feature_usage.head(10).to_dict()
    
    def generate_report(self, report_type: str, data: pd.DataFrame):
        """Сгенерировать отчет"""
        if report_type not in self.report_templates:
            raise ValueError(f"Unknown report type: {report_type}")
        
        return self.report_templates[report_type](data)
```

## Заключение

Это руководство по аналитике и отчетности обеспечивает комплексные инструкции для внедрения и использования аналитических функций в платформе REChain DAO. Следуя этим рекомендациям и используя рекомендуемые инструменты и практики, вы можете создать мощную систему аналитики, которая поможет принимать обоснованные решения и улучшать платформу.

Помните: Аналитика - это непрерывный процесс, который требует постоянного мониторинга, анализа и улучшения. Регулярно пересматривайте свои метрики и отчеты, чтобы убедиться, что они остаются актуальными и полезными.
