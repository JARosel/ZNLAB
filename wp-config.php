<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the website, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** Database username */
define( 'DB_USER', 'wpdbuser' );

/** Database password */
define( 'DB_PASSWORD', 'JSup3R$pzrd!' );

/** Database hostname */
define( 'DB_HOST', 'WINZNLABSQL' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         '_if=rlqd1_znK*KRq+yZCVpf]3U4O *Lh^a>fV,c$$~Z;K`?yilXJF,uf|[i,na@');
define('SECURE_AUTH_KEY',  'z+7Tuco)dY#(XLc9DP}7_{vR+ =J!e`UNM_yWCI%%sI1iDbw*#E3O7% .?_3W:6[');
define('LOGGED_IN_KEY',    'CNZ%nhYSh3oU&wTNkk?k7hH#J]-;/Q|v=nT9c.*42z{ttpl2b-;8R2|;i3*-uKFp');
define('NONCE_KEY',        'Y4|~hyY=$wODN/oy[fo*x:]o,rq-=Aza?iI4K=H:~)?E</HaTL`Iw|iZ,A2hsvVy');
define('AUTH_SALT',        '!Gj(7ps%xTrM.;$a9Ya3GpfAZg|Z,d.t>&L0L~j0jrvx@xM`5HQ!^#3$8:R-}uoJ');
define('SECURE_AUTH_SALT', '=NHna+(R.LqM[YX6x-GU,Dzbz%rymX[se>B~5U(X6q7~*|-|ZZaiXS3*x{jm#:7B');
define('LOGGED_IN_SALT',   'mLk(wxVHOMgA;<J5H-g9ST;3YDe==J3B-.YZ;EunJMSyRCLi1V^vqlri]o!ZZ=+>');
define('NONCE_SALT',       'I^H?ie3CR#-D]e7EC5R?}NU@w[^u0pMHIL/+%|.a|H>6h]`V6:+9g_s3+CoOks,=');

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 *
 * At the installation time, database tables are created with the specified prefix.
 * Changing this value after WordPress is installed will make your site think
 * it has not been installed.
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/#table-prefix
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://developer.wordpress.org/advanced-administration/debug/debug-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */



/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
add_filter('xmlrpc_enabled', '__return_true');
