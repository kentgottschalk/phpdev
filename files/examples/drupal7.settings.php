<?php

$databases = array(
  'default' => array(
    'default' => array(
      'driver' => 'mysql',
      'database' => 'db',
      'username' => 'db',
      'password' => 'db',
      'host' => 'db',
      'prefix' => '',
    ),
  ),
);

error_reporting(E_ALL);
ini_set('display_errors', TRUE);
ini_set('display_startup_errors', TRUE);
$conf['error_level'] = 2;

// Ensures that form data is not moved out of the database. It's important to
// keep this in non-volatile memory (e.g. the database).
$conf['cache_class_cache_form'] = 'DrupalDatabaseCache';

// Ensure fast tracks for files not found.
$conf['404_fast_paths_exclude'] = '/\/(?:styles)|(?:system\/files)\//';
$conf['404_fast_paths'] = '/\.(?:txt|png|gif|jpe?g|css|js|ico|swf|flv|cgi|bat|pl|dll|exe|asp)$/i';
$conf['404_fast_html'] = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML+RDFa 1.0//EN" "http://www.w3.org/MarkUp/DTD/xhtml-rdfa-1.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><title>404 Not Found</title></head><body><h1>Not Found</h1><p>The requested URL "@path" was not found on this server.</p></body></html>';
drupal_fast_404();

/**
 * Environment indicator.
 *
 * See: https://www.drupal.org/node/1992866
 */
$conf['environment_indicator_overwrite'] = TRUE;
$conf['environment_indicator_overwritten_color'] = '#913f92';
$conf['environment_indicator_overwritten_text_color'] = '#ffffff';
$conf['environment_indicator_overwritten_position'] = 'top';
$conf['environment_indicator_overwritten_fixed'] = FALSE;

// This config can be used for stage file proxy module.
# $conf['stage_file_proxy_origin'] = 'https://example.com';

/**
 * Memcached.
 */
// Uncomment these when eneabling memcache module.
# $conf['cache_backends'][] = 'profiles/ding2/modules/contrib/memcache/memcache.inc';
# $conf['cache_default_class'] = 'MemCacheDrupal';
# $conf['lock_inc'] = 'profiles/ding2/modules/contrib/memcache/memcache-lock.inc';

$conf += array(
  'memcache_extension' => 'Memcache',
  'show_memcache_statistics' => 0,
  'memcache_persistent' => TRUE,
  'memcache_stampede_protection' => TRUE,
  'memcache_stampede_semaphore' => 15,
  'memcache_stampede_wait_time' => 5,
  'memcache_stampede_wait_limit' => 3,
  'memcache_key_prefix' => 'vejlebib',
);

// Ignore som critical bins which can cause performance degradation if used with
// stampede protection.
// https://www.drupal.org/node/2419757
$conf['memcache_stampede_protection_ignore'] = array(
  // Ignore some cids in 'cache_bootstrap'.
  'cache_bootstrap' => array(
    'module_implements',
    'variables',
    'lookup_cache',
    'schema:runtime:*',
    'theme_registry:runtime:*',
    '_drupal_file_scan_cache',
  ),
  // Ignore all cids in the 'cache' bin starting with 'i18n:string:'
  'cache' => array(
    'i18n:string:*',
  ),
  // Disable stampede protection for the entire 'cache_path' and 'cache_rules'
  // bins.
  'cache_path',
  'cache_rules',
);

$conf['memcache_pagecache_header'] = TRUE;

// Configure cache servers.
$conf['memcache_servers'] = array(
  'memcached:11211' => 'default',
);
$conf['memcache_bins'] = array(
  'cache' => 'default',
);

/**
 * Varnish.
 *
 * Uncomment and add key.
 */
// Tell Drupal it's behind a proxy.
# $conf['reverse_proxy'] = TRUE;

// Tell Drupal what addresses the proxy server(s) use.
# $conf['reverse_proxy_addresses'] = [@$_SERVER['REMOTE_ADDR']];

// Bypass Drupal bootstrap for anonymous users so that Drupal sets max-age < 0.
# $conf['page_cache_invoke_hooks'] = FALSE;

// Set varnish configuration.
# $conf['varnish_control_key'] = '';
# $conf['varnish_socket_timeout'] = 500;

// Set varnish server IP's sperated by spaces
# $conf['varnish_control_terminal'] = 'varnish:6082';
