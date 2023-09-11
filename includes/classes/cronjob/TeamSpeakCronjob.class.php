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

require_once 'includes/classes/cronjob/CronjobTask.interface.php';

class TeamSpeakCronjob implements CronjobTask
{
	function run()
	{
	
			$db	= Database::get();

	
		$db->query("UPDATE uni1_fleets SET `fleet_busy` = '0' WHERE fleet_end_time <= ".time()." AND `fleet_universe` = '1';");
		

		
		$db->query("UPDATE uni1_fleet_event SET `lock` = NULL WHERE `lock` <> '' and time <= ".time());
		
		return ' Unlock all fleet CronJobGoodWork';
	
	}
}