# Plugin Development Guide

## Overview

This guide provides comprehensive instructions for developing plugins and extensions for the REChain DAO platform, including the plugin API, development environment setup, and best practices.

## Table of Contents

1. [Plugin Architecture](#plugin-architecture)
2. [Development Environment](#development-environment)
3. [Plugin API Reference](#plugin-api-reference)
4. [Creating Your First Plugin](#creating-your-first-plugin)
5. [Plugin Lifecycle](#plugin-lifecycle)
6. [Hooks and Filters](#hooks-and-filters)
7. [Database Integration](#database-integration)
8. [Frontend Integration](#frontend-integration)
9. [Testing Plugins](#testing-plugins)
10. [Publishing Plugins](#publishing-plugins)

## Plugin Architecture

### Plugin Structure
```
plugins/
├── your-plugin/
│   ├── plugin.json          # Plugin metadata
│   ├── index.php            # Main plugin file
│   ├── includes/            # PHP classes and functions
│   ├── assets/              # CSS, JS, images
│   ├── templates/           # Template files
│   ├── languages/           # Translation files
│   ├── admin/               # Admin interface
│   ├── public/              # Public-facing code
│   └── tests/               # Unit tests
```

### Plugin Metadata
```json
{
  "name": "Your Plugin Name",
  "version": "1.0.0",
  "description": "Plugin description",
  "author": "Your Name",
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

## Development Environment

### Prerequisites
- PHP 7.4 or higher
- Composer
- Node.js and npm
- Git
- REChain DAO platform

### Local Development Setup
```bash
# Clone the platform
git clone https://github.com/rechain-dao/platform.git
cd platform

# Install dependencies
composer install
npm install

# Set up environment
cp .env.example .env
# Configure your environment variables

# Start development server
php artisan serve
```

### Plugin Development Tools
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

## Plugin API Reference

### Core Plugin Class
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
        // Initialize plugin
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

### Plugin Manager
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
        // Check if plugin meets requirements
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

## Creating Your First Plugin

### Step 1: Plugin Structure
```php
<?php
/**
 * Plugin Name: Sample Plugin
 * Description: A sample plugin for REChain DAO
 * Version: 1.0.0
 * Author: Your Name
 * Text Domain: sample-plugin
 */

// Prevent direct access
if (!defined('ABSPATH')) {
    exit;
}

// Define plugin constants
define('SAMPLE_PLUGIN_VERSION', '1.0.0');
define('SAMPLE_PLUGIN_URL', plugin_dir_url(__FILE__));
define('SAMPLE_PLUGIN_PATH', plugin_dir_path(__FILE__));

// Autoloader
require_once SAMPLE_PLUGIN_PATH . 'includes/class-autoloader.php';

// Initialize plugin
new SamplePlugin();
```

### Step 2: Main Plugin Class
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
        // Initialize plugin functionality
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
            'Sample Plugin Settings',
            'Sample Plugin',
            'manage_options',
            'sample-plugin',
            [$this, 'admin_page']
        );
    }
    
    public function shortcode_handler($atts) {
        $atts = shortcode_atts([
            'title' => 'Sample Title',
            'content' => 'Sample Content'
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

### Step 3: Custom Post Type
```php
<?php
namespace SamplePlugin;

class CustomPostType {
    public function __construct() {
        add_action('init', [$this, 'register_post_type']);
        add_action('add_meta_boxes', [$this, 'add_meta_boxes']);
        add_action('save_post', [$this, 'save_meta_data']);
    }
    
    public function register_post_type() {
        $args = [
            'label' => 'Sample Items',
            'labels' => [
                'name' => 'Sample Items',
                'singular_name' => 'Sample Item',
                'add_new' => 'Add New',
                'add_new_item' => 'Add New Sample Item',
                'edit_item' => 'Edit Sample Item',
                'new_item' => 'New Sample Item',
                'view_item' => 'View Sample Item',
                'search_items' => 'Search Sample Items',
                'not_found' => 'No sample items found',
                'not_found_in_trash' => 'No sample items found in trash'
            ],
            'public' => true,
            'has_archive' => true,
            'supports' => ['title', 'editor', 'thumbnail', 'custom-fields'],
            'show_in_rest' => true,
            'menu_icon' => 'dashicons-admin-generic'
        ];
        
        register_post_type('sample_item', $args);
    }
    
    public function add_meta_boxes() {
        add_meta_box(
            'sample_item_meta',
            'Sample Item Details',
            [$this, 'meta_box_callback'],
            'sample_item',
            'normal',
            'high'
        );
    }
    
    public function meta_box_callback($post) {
        wp_nonce_field('sample_item_meta', 'sample_item_meta_nonce');
        
        $value = get_post_meta($post->ID, '_sample_item_value', true);
        
        echo '<table class="form-table">';
        echo '<tr>';
        echo '<th><label for="sample_item_value">Value</label></th>';
        echo '<td><input type="text" id="sample_item_value" name="sample_item_value" value="' . esc_attr($value) . '" /></td>';
        echo '</tr>';
        echo '</table>';
    }
    
    public function save_meta_data($post_id) {
        if (!isset($_POST['sample_item_meta_nonce']) || 
            !wp_verify_nonce($_POST['sample_item_meta_nonce'], 'sample_item_meta')) {
            return;
        }
        
        if (defined('DOING_AUTOSAVE') && DOING_AUTOSAVE) {
            return;
        }
        
        if (!current_user_can('edit_post', $post_id)) {
            return;
        }
        
        if (isset($_POST['sample_item_value'])) {
            update_post_meta($post_id, '_sample_item_value', sanitize_text_field($_POST['sample_item_value']));
        }
    }
}
```

## Plugin Lifecycle

### Activation Hook
```php
<?php
register_activation_hook(__FILE__, 'sample_plugin_activate');

function sample_plugin_activate() {
    // Create database tables
    create_sample_plugin_tables();
    
    // Set default options
    add_option('sample_plugin_version', SAMPLE_PLUGIN_VERSION);
    add_option('sample_plugin_settings', [
        'default_value' => 'default',
        'enable_feature' => true
    ]);
    
    // Flush rewrite rules
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

### Deactivation Hook
```php
<?php
register_deactivation_hook(__FILE__, 'sample_plugin_deactivate');

function sample_plugin_deactivate() {
    // Clear scheduled events
    wp_clear_scheduled_hook('sample_plugin_cron');
    
    // Flush rewrite rules
    flush_rewrite_rules();
}
```

### Uninstall Hook
```php
<?php
register_uninstall_hook(__FILE__, 'sample_plugin_uninstall');

function sample_plugin_uninstall() {
    // Remove database tables
    global $wpdb;
    
    $table_name = $wpdb->prefix . 'sample_plugin_data';
    $wpdb->query("DROP TABLE IF EXISTS $table_name");
    
    // Remove options
    delete_option('sample_plugin_version');
    delete_option('sample_plugin_settings');
    
    // Remove user meta
    $wpdb->query("DELETE FROM {$wpdb->usermeta} WHERE meta_key LIKE 'sample_plugin_%'");
}
```

## Hooks and Filters

### Action Hooks
```php
<?php
// Add content after post
add_action('the_content', 'add_sample_content_after_post');

function add_sample_content_after_post($content) {
    if (is_single() && is_main_query()) {
        $content .= '<div class="sample-plugin-content">';
        $content .= '<p>This content was added by Sample Plugin!</p>';
        $content .= '</div>';
    }
    
    return $content;
}

// Add admin notice
add_action('admin_notices', 'sample_plugin_admin_notice');

function sample_plugin_admin_notice() {
    if (get_option('sample_plugin_show_notice')) {
        echo '<div class="notice notice-success is-dismissible">';
        echo '<p>Sample Plugin is working correctly!</p>';
        echo '</div>';
        
        delete_option('sample_plugin_show_notice');
    }
}
```

### Filter Hooks
```php
<?php
// Modify post title
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

// Modify query
add_filter('pre_get_posts', 'modify_sample_query');

function modify_sample_query($query) {
    if (!is_admin() && $query->is_main_query()) {
        if (is_home()) {
            $query->set('post_type', ['post', 'sample_item']);
        }
    }
}
```

### Custom Hooks
```php
<?php
// Define custom action
do_action('sample_plugin_before_save', $data);

// Define custom filter
$filtered_data = apply_filters('sample_plugin_data', $data);

// Example usage
class DataProcessor {
    public function save_data($data) {
        // Allow other plugins to modify data before saving
        $data = apply_filters('sample_plugin_before_save', $data);
        
        // Notify other plugins that data is being saved
        do_action('sample_plugin_saving_data', $data);
        
        // Save data
        $result = $this->perform_save($data);
        
        // Notify other plugins that data was saved
        do_action('sample_plugin_saved_data', $data, $result);
        
        return $result;
    }
}
```

## Database Integration

### Custom Database Tables
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
    
    public function update_data($user_id, $key, $value) {
        global $wpdb;
        
        return $wpdb->update(
            $this->table_name,
            ['data_value' => maybe_serialize($value)],
            [
                'user_id' => $user_id,
                'data_key' => $key
            ],
            ['%s'],
            ['%d', '%s']
        );
    }
    
    public function delete_data($user_id, $key = null) {
        global $wpdb;
        
        $where = ['user_id' => $user_id];
        $where_format = ['%d'];
        
        if ($key) {
            $where['data_key'] = $key;
            $where_format[] = '%s';
        }
        
        return $wpdb->delete(
            $this->table_name,
            $where,
            $where_format
        );
    }
}
```

### Using WordPress Database API
```php
<?php
class SamplePluginData {
    public function get_user_data($user_id) {
        return get_user_meta($user_id, 'sample_plugin_data', true);
    }
    
    public function update_user_data($user_id, $data) {
        return update_user_meta($user_id, 'sample_plugin_data', $data);
    }
    
    public function get_option_data($key, $default = false) {
        return get_option("sample_plugin_{$key}", $default);
    }
    
    public function update_option_data($key, $value) {
        return update_option("sample_plugin_{$key}", $value);
    }
    
    public function get_transient_data($key) {
        return get_transient("sample_plugin_{$key}");
    }
    
    public function set_transient_data($key, $value, $expiration = 3600) {
        return set_transient("sample_plugin_{$key}", $value, $expiration);
    }
}
```

## Frontend Integration

### JavaScript Integration
```javascript
// assets/js/script.js
(function($) {
    'use strict';
    
    var SamplePlugin = {
        init: function() {
            this.bindEvents();
            this.initComponents();
        },
        
        bindEvents: function() {
            $(document).on('click', '.sample-plugin-button', this.handleButtonClick);
            $(document).on('submit', '.sample-plugin-form', this.handleFormSubmit);
        },
        
        initComponents: function() {
            this.initTooltips();
            this.initModals();
        },
        
        handleButtonClick: function(e) {
            e.preventDefault();
            
            var $button = $(this);
            var action = $button.data('action');
            
            SamplePlugin.performAction(action, $button);
        },
        
        handleFormSubmit: function(e) {
            e.preventDefault();
            
            var $form = $(this);
            var formData = $form.serialize();
            
            SamplePlugin.submitForm($form, formData);
        },
        
        performAction: function(action, $button) {
            $.ajax({
                url: samplePlugin.ajaxUrl,
                type: 'POST',
                data: {
                    action: 'sample_plugin_action',
                    plugin_action: action,
                    nonce: samplePlugin.nonce
                },
                beforeSend: function() {
                    $button.prop('disabled', true).text('Processing...');
                },
                success: function(response) {
                    if (response.success) {
                        SamplePlugin.showNotice('success', response.data.message);
                    } else {
                        SamplePlugin.showNotice('error', response.data.message);
                    }
                },
                error: function() {
                    SamplePlugin.showNotice('error', 'An error occurred. Please try again.');
                },
                complete: function() {
                    $button.prop('disabled', false).text('Submit');
                }
            });
        },
        
        submitForm: function($form, formData) {
            $.ajax({
                url: samplePlugin.ajaxUrl,
                type: 'POST',
                data: formData + '&action=sample_plugin_form_submit&nonce=' + samplePlugin.nonce,
                success: function(response) {
                    if (response.success) {
                        $form[0].reset();
                        SamplePlugin.showNotice('success', 'Form submitted successfully!');
                    } else {
                        SamplePlugin.showNotice('error', response.data.message);
                    }
                },
                error: function() {
                    SamplePlugin.showNotice('error', 'An error occurred. Please try again.');
                }
            });
        },
        
        showNotice: function(type, message) {
            var $notice = $('<div class="sample-plugin-notice notice-' + type + '">' + message + '</div>');
            
            $('body').append($notice);
            
            setTimeout(function() {
                $notice.fadeOut(function() {
                    $notice.remove();
                });
            }, 5000);
        },
        
        initTooltips: function() {
            $('[data-tooltip]').each(function() {
                var $element = $(this);
                var tooltip = $element.data('tooltip');
                
                $element.attr('title', tooltip);
            });
        },
        
        initModals: function() {
            $('.sample-plugin-modal-trigger').on('click', function(e) {
                e.preventDefault();
                
                var modalId = $(this).data('modal');
                $('#' + modalId).show();
            });
            
            $('.sample-plugin-modal-close').on('click', function() {
                $(this).closest('.sample-plugin-modal').hide();
            });
        }
    };
    
    // Initialize when document is ready
    $(document).ready(function() {
        SamplePlugin.init();
    });
    
})(jQuery);
```

### CSS Integration
```css
/* assets/css/style.css */
.sample-plugin-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
}

.sample-plugin-button {
    background-color: #0073aa;
    color: white;
    border: none;
    padding: 10px 20px;
    border-radius: 4px;
    cursor: pointer;
    transition: background-color 0.3s ease;
}

.sample-plugin-button:hover {
    background-color: #005a87;
}

.sample-plugin-button:disabled {
    background-color: #ccc;
    cursor: not-allowed;
}

.sample-plugin-form {
    background: #f9f9f9;
    padding: 20px;
    border-radius: 4px;
    margin: 20px 0;
}

.sample-plugin-form .form-group {
    margin-bottom: 15px;
}

.sample-plugin-form label {
    display: block;
    margin-bottom: 5px;
    font-weight: bold;
}

.sample-plugin-form input,
.sample-plugin-form textarea,
.sample-plugin-form select {
    width: 100%;
    padding: 8px;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 14px;
}

.sample-plugin-notice {
    position: fixed;
    top: 20px;
    right: 20px;
    padding: 15px 20px;
    border-radius: 4px;
    color: white;
    z-index: 9999;
    max-width: 300px;
}

.sample-plugin-notice.notice-success {
    background-color: #46b450;
}

.sample-plugin-notice.notice-error {
    background-color: #dc3232;
}

.sample-plugin-modal {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.5);
    z-index: 10000;
}

.sample-plugin-modal-content {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    background: white;
    padding: 20px;
    border-radius: 4px;
    max-width: 500px;
    width: 90%;
}

.sample-plugin-modal-close {
    position: absolute;
    top: 10px;
    right: 15px;
    font-size: 24px;
    cursor: pointer;
    color: #999;
}

.sample-plugin-modal-close:hover {
    color: #333;
}
```

## Testing Plugins

### Unit Testing Setup
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
    
    public function testDataInsertion() {
        $database = new SamplePluginDatabase();
        $result = $database->insert_data(1, 'test_key', 'test_value');
        
        $this->assertNotFalse($result);
        
        $data = $database->get_data(1, 'test_key');
        $this->assertCount(1, $data);
        $this->assertEquals('test_value', $data[0]->data_value);
    }
}
```

### Integration Testing
```php
<?php
// tests/IntegrationTestSamplePlugin.php
use PHPUnit\Framework\TestCase;

class IntegrationTestSamplePlugin extends TestCase {
    public function testPluginActivation() {
        // Test plugin activation
        $this->assertTrue(activate_plugin('sample-plugin/sample-plugin.php'));
        
        // Check if tables are created
        global $wpdb;
        $table_name = $wpdb->prefix . 'sample_plugin_data';
        $this->assertTrue($wpdb->get_var("SHOW TABLES LIKE '$table_name'") === $table_name);
        
        // Check if options are set
        $this->assertNotFalse(get_option('sample_plugin_version'));
        $this->assertNotFalse(get_option('sample_plugin_settings'));
    }
    
    public function testPluginDeactivation() {
        // Test plugin deactivation
        $this->assertTrue(deactivate_plugins('sample-plugin/sample-plugin.php'));
        
        // Check if scheduled events are cleared
        $this->assertFalse(wp_next_scheduled('sample_plugin_cron'));
    }
    
    public function testAjaxHandlers() {
        // Test AJAX handlers
        $_POST['action'] = 'sample_plugin_action';
        $_POST['nonce'] = wp_create_nonce('sample_plugin_nonce');
        
        ob_start();
        do_action('wp_ajax_sample_plugin_action');
        $output = ob_get_clean();
        
        $this->assertNotEmpty($output);
    }
}
```

## Publishing Plugins

### Plugin Directory Structure
```
sample-plugin/
├── sample-plugin.php          # Main plugin file
├── readme.txt                 # Plugin directory readme
├── screenshot-1.png           # Plugin screenshots
├── screenshot-2.png
├── assets/                    # Plugin assets
├── includes/                  # PHP classes
├── languages/                 # Translation files
└── tests/                     # Test files
```

### Plugin Directory Readme
```txt
=== Sample Plugin ===
Contributors: yourusername
Tags: sample, plugin, rechain
Requires at least: 1.0.0
Tested up to: 1.5.0
Requires PHP: 7.4
Stable tag: 1.0.0
License: GPLv2 or later
License URI: https://www.gnu.org/licenses/gpl-2.0.html

A sample plugin for REChain DAO platform.

== Description ==

This is a sample plugin that demonstrates how to create plugins for the REChain DAO platform. It includes:

* Custom post types
* Custom fields
* Shortcodes
* Admin interface
* Database integration
* Frontend integration

== Installation ==

1. Upload the plugin files to the `/wp-content/plugins/sample-plugin` directory, or install the plugin through the WordPress plugins screen directly.
2. Activate the plugin through the 'Plugins' screen in WordPress
3. Use the Settings->Sample Plugin screen to configure the plugin

== Frequently Asked Questions ==

= How do I use this plugin? =

After activation, you can use the [sample_shortcode] shortcode in your posts and pages.

= Can I customize the appearance? =

Yes, you can customize the appearance by modifying the CSS files in the assets directory.

== Screenshots ==

1. Plugin settings page
2. Sample shortcode output
3. Custom post type interface

== Changelog ==

= 1.0.0 =
* Initial release
* Custom post type functionality
* Shortcode support
* Admin interface
* Database integration

== Upgrade Notice ==

= 1.0.0 =
Initial release of Sample Plugin.
```

### Plugin Submission Process
1. **Code Review**: Ensure code follows WordPress coding standards
2. **Security Check**: Verify no security vulnerabilities
3. **Documentation**: Complete all required documentation
4. **Testing**: Test on multiple environments
5. **Submission**: Submit to plugin directory
6. **Review**: Wait for review and approval
7. **Publication**: Plugin becomes available for download

## Conclusion

This Plugin Development Guide provides comprehensive instructions for creating plugins for the REChain DAO platform. By following these guidelines and best practices, you can create robust, secure, and maintainable plugins that extend the platform's functionality.

Remember: Always test your plugins thoroughly and follow security best practices to ensure the safety and reliability of your code.
