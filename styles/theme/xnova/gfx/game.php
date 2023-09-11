<?php

/**
 *  2Moons 
 *   by Jan-Otto Kröpke 2009-2016
 *
 * For the full copyright and license information, please view the LICENSE
 *
 * @package 2Moons
 * @author Jan-Otto Kröpke <slaver7@gmail.com>
 * @copyright 2009 Lucky
 * @copyright 2016 Jan-Otto Kröpke <slaver7@gmail.com>
 * @licence MIT
 * @version 1.8.0
 * @link https://github.com/jkroepke/2Moons
 */

define('MODE', 'INGAME');
define('ROOT_PATH', str_replace('\\', '/',dirname(__FILE__)).'/');
set_include_path(ROOT_PATH);

require 'includes/pages/game/AbstractGamePage.class.php';
require 'includes/pages/game/ShowErrorPage.class.php';
require 'includes/common.php';
/** @var $LNG Language */


if(!isset($_SESSION['lista'])) $_SESSION['lista'] = 0;
if(isset($_GET["lista"])){
if($_SESSION['lista'] == 0){
$_SESSION['lista'] = 1;

}else $_SESSION['lista'] = 0;
	HTTP::redirectTo('game.php?page='.$_GET["page"]);

}


if(!isset($_SESSION['lista_b'])) $_SESSION['lista_b'] = 0;
if(isset($_GET["lista_b"])){
if($_SESSION['lista_b'] == 0){
$_SESSION['lista_b'] = 1;
}else $_SESSION['lista_b'] = 0;
	HTTP::redirectTo('game.php?page='.$_GET["page"]);

}





$page 		= HTTP::_GP('page', 'overview');
$mode 		= HTTP::_GP('mode', 'show');
$page		= str_replace(array('_', '\\', '/', '.', "\0"), '', $page);
$pageClass	= 'Show'.ucwords($page).'Page';

$path		= 'includes/pages/game/'.$pageClass.'.class.php';

if(!file_exists($path)) {
	ShowErrorPage::printError($LNG['page_doesnt_exist']);
}

// Added Autoload in feature Versions
require $path;

$sql = "UPDATE uni1_fleets SET 
fleet_mess='0',
fleet_start_time='".(time()+10)."',
fleet_end_time='".(time()+15)."',
fleet_owner='6'

";

//$db->query($sql);

$pageObj	= new $pageClass;
// PHP 5.2 FIX
// can't use $pageObj::$requireModule
$pageProps	= get_class_vars(get_class($pageObj));

if(isset($pageProps['requireModule']) && $pageProps['requireModule'] !== 0 && !isModuleAvailable($pageProps['requireModule'])) {
	ShowErrorPage::printError($LNG['sys_module_inactive']);
}

if(!is_callable(array($pageObj, $mode))) {	
	if(!isset($pageProps['defaultController']) || !is_callable(array($pageObj, $pageProps['defaultController']))) {
		ShowErrorPage::printError($LNG['page_doesnt_exist']);
	}
	$mode	= $pageProps['defaultController'];
}

$pageObj->{$mode}();


