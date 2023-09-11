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

class DailyCronJob implements CronjobTask
{
	function run()
	{
		$this->removeVacation();
		$this->optimizeTables();
		$this->clearCache();
		$this->reCalculateCronjobs();
		$this->clearEcoCache();
	}
	
	function removeVacation()
	{
		$sql	= "SELECT * FROM %%USERS%% WHERE `onlinetime` < :time AND `bana` = 0 AND `urlaubs_modus` = 1;";
		
		$usersResult = Database::get()->select($sql, array(
			':time'	=> TIMESTAMP-(60*60*24*30)
		));
		
		foreach($usersResult as $user){

			$planetsql = "UPDATE %%PLANETS%% SET
						last_update = :timestamp,
						energy_used = '10',
						energy = '10',
						metal_mine_porcent = '10',
						crystal_mine_porcent = '10',
						deuterium_sintetizer_porcent = '10',
						solar_plant_porcent = '10',
						fusion_plant_porcent = '10',
						solar_satelit_porcent = '10'
						WHERE id_owner = :userID;";
						
			Database::get()->update($planetsql, array(
				':userID'		=> $user['id'],
				':timestamp'	=> TIMESTAMP
			));
			
			$usersql	= "UPDATE %%USERS%% SET 
				urlaubs_modus = '0',
				urlaubs_until = '0' 
				
				WHERE `id` = :id;";
				
			Database::get()->update($usersql, array(
				':id'	=> $user['id']
			));
		}
	}
	
	function optimizeTables()
	{
		$sql			= "SHOW TABLE STATUS FROM `".DB_NAME."`;";
		$sqlTableRaw	= Database::get()->nativeQuery($sql);

		$prefixCounts	= strlen(DB_PREFIX);
		$dbTables		= array();

		foreach($sqlTableRaw as $table)
		{
			if (DB_PREFIX == substr($table['Name'], 0, $prefixCounts)) {
				$dbTables[] = $table['Name'];
			}
		}

		if(!empty($dbTables))
		{
			Database::get()->nativeQuery("OPTIMIZE TABLE ".implode(', ', $dbTables).";");
		}
	}

	function clearCache()
	{
		ClearCache();
	}
	
	function reCalculateCronjobs()
	{
		Cronjob::reCalculateCronjobs();
	}
	
	function clearEcoCache()
	{
		$sql	= "UPDATE %%PLANETS%% SET eco_hash = '';";
		Database::get()->update($sql);
	}
}
