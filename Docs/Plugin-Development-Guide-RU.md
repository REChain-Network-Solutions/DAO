# Руководство по разработке плагинов

## Обзор

Это руководство предоставляет комплексные инструкции по разработке плагинов и расширений для платформы REChain DAO, включая API плагинов, настройку среды разработки и лучшие практики.

## Содержание

1. [Архитектура плагинов](#архитектура-плагинов)
2. [Среда разработки](#среда-разработки)
3. [Справочник API плагинов](#справочник-api-плагинов)
4. [Создание вашего первого плагина](#создание-вашего-первого-плагина)
5. [Жизненный цикл плагина](#жизненный-цикл-плагина)
6. [Хуки и фильтры](#хуки-и-фильтры)
7. [Интеграция с базой данных](#интеграция-с-базой-данных)
8. [Интеграция с фронтендом](#интеграция-с-фронтендом)
9. [Тестирование плагинов](#тестирование-плагинов)
10. [Публикация плагинов](#публикация-плагинов)

## Архитектура плагинов

### Структура плагина
```
plugins/
├── your-plugin/
│   ├── plugin.json          # Метаданные плагина
│   ├── index.php            # Основной файл плагина
│   ├── includes/            # PHP классы и функции
│   ├── assets/              # CSS, JS, изображения
│   ├── templates/           # Файлы шаблонов
│   ├── languages/           # Файлы переводов
│   ├── admin/               # Административный интерфейс
│   ├── public/              # Публичный код
│   └── tests/               # Модульные тесты
```

### Метаданные плагина
```json
{
  "name": "Название вашего плагина",
  "version": "1.0.0",
  "description": "Описание плагина",
  "author": "Ваше имя",
  "author_url": "https://yourwebsite.com",
  "plugin_url": "https://github.com/yourusername/your-plugin",
  "requires": "1.0.0",
  "tested_up_to": "1.5.0",
  "requires_php": "7.4",
  "license": "GPL-2.0",
  "text_domain": "your-plugin",
  "domain_path": "/languages",
  "network": false,
  "hooks": {
    "init": "init_plugin",
    "wp_enqueue_scripts": "enqueue_scripts",
    "admin_menu": "add_admin_menu"
  }
}
```

## Среда разработки

### Предварительные требования
- PHP 7.4 или выше
- Composer
- Node.js и npm
- Git
- Платформа REChain DAO

### Настройка локальной разработки
```bash
# Клонирование платформы
git clone https://github.com/rechain-dao/platform.git
cd platform

# Установка зависимостей
composer install
npm install

# Настройка окружения
cp .env.example .env
# Настройте переменные окружения

# Запуск сервера разработки
php artisan serve
```

### Инструменты разработки плагинов
```json
{
  "name": "rechain-plugin-dev",
  "version": "1.0.0",
  "scripts": {
    "build": "webpack --mode=production",
    "dev": "webpack --mode=development --watch",
    "test": "phpunit",
    "lint": "phpcs --standard=PSR12 src/",
    "format": "phpcbf --standard=PSR12 src/"
  },
  "devDependencies": {
    "webpack": "^5.0.0",
    "webpack-cli": "^4.0.0",
    "sass-loader": "^10.0.0",
    "css-loader": "^5.0.0",
    "style-loader": "^2.0.0"
  }
}
```

## Справочник API плагинов

### Основной класс плагина
```php
<?php
namespace REChain\Plugins;

class Plugin {
    protected $plugin_file;
    protected $plugin_data;
    protected $hooks = [];
    
    public function __construct($plugin_file) {
        $this->plugin_file = $plugin_file;
        $this->plugin_data = $this->get_plugin_data();
        $this->init();
    }
    
    protected function init() {
        // Инициализация плагина
        add_action('init', [$this, 'load_textdomain']);
        add_action('wp_enqueue_scripts', [$this, 'enqueue_assets']);
    }
    
    public function load_textdomain() {
        load_plugin_textdomain(
            $this->plugin_data['text_domain'],
            false,
            dirname(plugin_basename($this->plugin_file)) . '/languages'
        );
    }
    
    public function enqueue_assets() {
        wp_enqueue_script(
            'your-plugin-script',
            plugin_dir_url($this->plugin_file) . 'assets/js/script.js',
            ['jquery'],
            $this->plugin_data['version'],
            true
        );
        
        wp_enqueue_style(
            'your-plugin-style',
            plugin_dir_url($this->plugin_file) . 'assets/css/style.css',
            [],
            $this->plugin_data['version']
        );
    }
}
```

### Менеджер плагинов
```php
<?php
namespace REChain\Plugins;

class PluginManager {
    protected $plugins = [];
    protected $hooks = [];
    
    public function register_plugin($plugin_file) {
        $plugin_data = $this->get_plugin_data($plugin_file);
        
        if ($this->validate_plugin($plugin_data)) {
            $this->plugins[$plugin_data['name']] = new Plugin($plugin_file);
            $this->load_plugin_hooks($plugin_data);
        }
    }
    
    protected function validate_plugin($plugin_data) {
        // Проверка соответствия требованиям
        if (version_compare(PHP_VERSION, $plugin_data['requires_php'], '<')) {
            return false;
        }
        
        if (version_compare(REChain_VERSION, $plugin_data['requires'], '<')) {
            return false;
        }
        
        return true;
    }
    
    public function add_hook($hook, $callback, $priority = 10) {
        $this->hooks[$hook][] = [
            'callback' => $callback,
            'priority' => $priority
        ];
        
        add_action($hook, $callback, $priority);
    }
    
    public function remove_hook($hook, $callback) {
        remove_action($hook, $callback);
    }
}
```

## Создание вашего первого плагина

### Шаг 1: Структура плагина
```php
<?php
/**
 * Plugin Name: Пример плагина
 * Description: Пример плагина для REChain DAO
 * Version: 1.0.0
 * Author: Ваше имя
 * Text Domain: sample-plugin
 */

// Предотвращение прямого доступа
if (!defined('ABSPATH')) {
    exit;
}

// Определение констант плагина
define('SAMPLE_PLUGIN_VERSION', '1.0.0');
define('SAMPLE_PLUGIN_URL', plugin_dir_url(__FILE__));
define('SAMPLE_PLUGIN_PATH', plugin_dir_path(__FILE__));

// Автозагрузчик
require_once SAMPLE_PLUGIN_PATH . 'includes/class-autoloader.php';

// Инициализация плагина
new SamplePlugin();
```

### Шаг 2: Основной класс плагина
```php
<?php
namespace SamplePlugin;

class SamplePlugin {
    public function __construct() {
        $this->init_hooks();
    }
    
    private function init_hooks() {
        add_action('init', [$this, 'init']);
        add_action('wp_enqueue_scripts', [$this, 'enqueue_scripts']);
        add_action('admin_menu', [$this, 'add_admin_menu']);
        add_shortcode('sample_shortcode', [$this, 'shortcode_handler']);
    }
    
    public function init() {
        // Инициализация функциональности плагина
        $this->create_custom_post_type();
        $this->add_custom_fields();
    }
    
    public function enqueue_scripts() {
        wp_enqueue_script(
            'sample-plugin-js',
            SAMPLE_PLUGIN_URL . 'assets/js/script.js',
            ['jquery'],
            SAMPLE_PLUGIN_VERSION,
            true
        );
    }
    
    public function add_admin_menu() {
        add_options_page(
            'Настройки примера плагина',
            'Пример плагина',
            'manage_options',
            'sample-plugin',
            [$this, 'admin_page']
        );
    }
    
    public function shortcode_handler($atts) {
        $atts = shortcode_atts([
            'title' => 'Пример заголовка',
            'content' => 'Пример контента'
        ], $atts);
        
        return $this->render_template('shortcode', $atts);
    }
    
    private function render_template($template, $data = []) {
        $template_path = SAMPLE_PLUGIN_PATH . "templates/{$template}.php";
        
        if (file_exists($template_path)) {
            extract($data);
            ob_start();
            include $template_path;
            return ob_get_clean();
        }
        
        return '';
    }
}
```

## Жизненный цикл плагина

### Хук активации
```php
<?php
register_activation_hook(__FILE__, 'sample_plugin_activate');

function sample_plugin_activate() {
    // Создание таблиц базы данных
    create_sample_plugin_tables();
    
    // Установка опций по умолчанию
    add_option('sample_plugin_version', SAMPLE_PLUGIN_VERSION);
    add_option('sample_plugin_settings', [
        'default_value' => 'default',
        'enable_feature' => true
    ]);
    
    // Очистка правил перезаписи
    flush_rewrite_rules();
}

function create_sample_plugin_tables() {
    global $wpdb;
    
    $table_name = $wpdb->prefix . 'sample_plugin_data';
    
    $charset_collate = $wpdb->get_charset_collate();
    
    $sql = "CREATE TABLE $table_name (
        id mediumint(9) NOT NULL AUTO_INCREMENT,
        name varchar(100) NOT NULL,
        value text NOT NULL,
        created_at datetime DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (id)
    ) $charset_collate;";
    
    require_once(ABSPATH . 'wp-admin/includes/upgrade.php');
    dbDelta($sql);
}
```

### Хук деактивации
```php
<?php
register_deactivation_hook(__FILE__, 'sample_plugin_deactivate');

function sample_plugin_deactivate() {
    // Очистка запланированных событий
    wp_clear_scheduled_hook('sample_plugin_cron');
    
    // Очистка правил перезаписи
    flush_rewrite_rules();
}
```

## Хуки и фильтры

### Хуки действий
```php
<?php
// Добавление контента после поста
add_action('the_content', 'add_sample_content_after_post');

function add_sample_content_after_post($content) {
    if (is_single() && is_main_query()) {
        $content .= '<div class="sample-plugin-content">';
        $content .= '<p>Этот контент был добавлен примером плагина!</p>';
        $content .= '</div>';
    }
    
    return $content;
}

// Добавление административного уведомления
add_action('admin_notices', 'sample_plugin_admin_notice');

function sample_plugin_admin_notice() {
    if (get_option('sample_plugin_show_notice')) {
        echo '<div class="notice notice-success is-dismissible">';
        echo '<p>Пример плагина работает корректно!</p>';
        echo '</div>';
        
        delete_option('sample_plugin_show_notice');
    }
}
```

### Хуки фильтров
```php
<?php
// Модификация заголовка поста
add_filter('the_title', 'modify_sample_post_title', 10, 2);

function modify_sample_post_title($title, $id) {
    if (get_post_type($id) === 'sample_item') {
        $value = get_post_meta($id, '_sample_item_value', true);
        if ($value) {
            $title .= ' - ' . esc_html($value);
        }
    }
    
    return $title;
}

// Модификация запроса
add_filter('pre_get_posts', 'modify_sample_query');

function modify_sample_query($query) {
    if (!is_admin() && $query->is_main_query()) {
        if (is_home()) {
            $query->set('post_type', ['post', 'sample_item']);
        }
    }
}
```

## Интеграция с базой данных

### Пользовательские таблицы базы данных
```php
<?php
class SamplePluginDatabase {
    private $table_name;
    
    public function __construct() {
        global $wpdb;
        $this->table_name = $wpdb->prefix . 'sample_plugin_data';
    }
    
    public function create_table() {
        global $wpdb;
        
        $charset_collate = $wpdb->get_charset_collate();
        
        $sql = "CREATE TABLE {$this->table_name} (
            id bigint(20) NOT NULL AUTO_INCREMENT,
            user_id bigint(20) NOT NULL,
            data_key varchar(255) NOT NULL,
            data_value longtext NOT NULL,
            created_at datetime DEFAULT CURRENT_TIMESTAMP,
            updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY user_id (user_id),
            KEY data_key (data_key)
        ) $charset_collate;";
        
        require_once(ABSPATH . 'wp-admin/includes/upgrade.php');
        dbDelta($sql);
    }
    
    public function insert_data($user_id, $key, $value) {
        global $wpdb;
        
        return $wpdb->insert(
            $this->table_name,
            [
                'user_id' => $user_id,
                'data_key' => $key,
                'data_value' => maybe_serialize($value)
            ],
            ['%d', '%s', '%s']
        );
    }
    
    public function get_data($user_id, $key = null) {
        global $wpdb;
        
        $where = ['user_id' => $user_id];
        $where_format = ['%d'];
        
        if ($key) {
            $where['data_key'] = $key;
            $where_format[] = '%s';
        }
        
        $results = $wpdb->get_results(
            $wpdb->prepare(
                "SELECT * FROM {$this->table_name} WHERE " . 
                implode(' AND ', array_map(function($k) { return "$k = %s"; }, array_keys($where))),
                array_values($where)
            )
        );
        
        return array_map(function($row) {
            $row->data_value = maybe_unserialize($row->data_value);
            return $row;
        }, $results);
    }
}
```

## Тестирование плагинов

### Настройка модульного тестирования
```php
<?php
// tests/TestSamplePlugin.php
use PHPUnit\Framework\TestCase;

class TestSamplePlugin extends TestCase {
    protected $plugin;
    
    protected function setUp(): void {
        parent::setUp();
        $this->plugin = new SamplePlugin();
    }
    
    public function testPluginInitialization() {
        $this->assertInstanceOf('SamplePlugin', $this->plugin);
    }
    
    public function testCustomPostTypeRegistration() {
        $post_types = get_post_types();
        $this->assertArrayHasKey('sample_item', $post_types);
    }
    
    public function testShortcodeRegistration() {
        global $shortcode_tags;
        $this->assertArrayHasKey('sample_shortcode', $shortcode_tags);
    }
    
    public function testDatabaseTableCreation() {
        global $wpdb;
        $table_name = $wpdb->prefix . 'sample_plugin_data';
        
        $this->assertTrue($wpdb->get_var("SHOW TABLES LIKE '$table_name'") === $table_name);
    }
}
```

## Публикация плагинов

### Структура каталога плагинов
```
sample-plugin/
├── sample-plugin.php          # Основной файл плагина
├── readme.txt                 # README каталога плагинов
├── screenshot-1.png           # Скриншоты плагина
├── screenshot-2.png
├── assets/                    # Ресурсы плагина
├── includes/                  # PHP классы
├── languages/                 # Файлы переводов
└── tests/                     # Файлы тестов
```

### README каталога плагинов
```txt
=== Пример плагина ===
Contributors: yourusername
Tags: пример, плагин, rechain
Requires at least: 1.0.0
Tested up to: 1.5.0
Requires PHP: 7.4
Stable tag: 1.0.0
License: GPLv2 or later
License URI: https://www.gnu.org/licenses/gpl-2.0.html

Пример плагина для платформы REChain DAO.

== Описание ==

Это пример плагина, который демонстрирует, как создавать плагины для платформы REChain DAO. Он включает:

* Пользовательские типы постов
* Пользовательские поля
* Шорткоды
* Административный интерфейс
* Интеграцию с базой данных
* Интеграцию с фронтендом

== Установка ==

1. Загрузите файлы плагина в каталог `/wp-content/plugins/sample-plugin` или установите плагин через экран плагинов WordPress.
2. Активируйте плагин через экран 'Плагины' в WordPress
3. Используйте экран Настройки->Пример плагина для настройки плагина

== Часто задаваемые вопросы ==

= Как использовать этот плагин? =

После активации вы можете использовать шорткод [sample_shortcode] в своих постах и страницах.

= Можно ли настроить внешний вид? =

Да, вы можете настроить внешний вид, изменив CSS файлы в каталоге assets.

== Скриншоты ==

1. Страница настроек плагина
2. Вывод примера шорткода
3. Интерфейс пользовательского типа поста

== Журнал изменений ==

= 1.0.0 =
* Первый релиз
* Функциональность пользовательского типа поста
* Поддержка шорткодов
* Административный интерфейс
* Интеграция с базой данных

== Уведомление об обновлении ==

= 1.0.0 =
Первый релиз примера плагина.
```

## Заключение

Это руководство по разработке плагинов обеспечивает комплексные инструкции для создания плагинов для платформы REChain DAO. Следуя этим рекомендациям и лучшим практикам, вы можете создавать надежные, безопасные и поддерживаемые плагины, которые расширяют функциональность платформы.

Помните: всегда тщательно тестируйте свои плагины и следуйте лучшим практикам безопасности, чтобы обеспечить безопасность и надежность вашего кода.
