<?php

/**
 *  2Moons 
 *   by Jan-Otto Kropke 2009-2016
 *
 * For the full copyright and license information, please view the LICENSE
 *
 * @package 2Moons
 * @author Jan-Otto Kropke <slaver7@gmail.com>
 * @copyright 2009 Lucky
 * @copyright 2016 Jan-Otto Kropke <slaver7@gmail.com>
 * @licence MIT
 * @version 1.8.0
 * @link https://github.com/jkroepke/2Moons
 */

if (!allowedTo(str_replace(array(dirname(__FILE__), '\\', '/', '.php'), '', __FILE__))) throw new Exception("Permission error!");

require 'includes/classes/class.FlyingFleetsTable.php';

function ShowFleetLogPage()
{
	global $LNG;
	
	$owner	= HTTP::_GP('owner', 0);
	$target = HTTP::_GP('target', 0);
	
	$ownername	= HTTP::_GP('ownername', '');
	$targetname = HTTP::_GP('targetname', '');
	
	$mission	= HTTP::_GP('mission', 0);
	$page		= HTTP::_GP('side', 1);
	
	$dateStart	= HTTP::_GP('dateStart', array());
	$dateEnd	= HTTP::_GP('dateEnd', array());
	
	$dateStart	= array_filter($dateStart, 'is_numeric');
	$dateEnd	= array_filter($dateEnd, 'is_numeric');
	
	$useDateStart	= count($dateStart) == 3;
	$useDateEnd		= count($dateEnd) == 3;
	
	$where	= "";
	
	$perSide	= 50;
	
	if(!empty($owner)){
		$where .= " AND fleet_owner = ".$owner." ";
	} 
	
	if(!empty($ownername)){
		$where .= " AND ustart.username = '".$ownername."' ";
	} 
	
	if(!empty($targetname)){
		$where .= " AND utarget.username = '".$targetname."' ";
	} 
	
	if(!empty($mission)){
		$where .= " AND fleet_mission = ".$mission." ";
	} 
	
	if(!empty($target)){
		$where .= " AND fleet_target_owner = ".$target." ";
	} 
	
	
	$dateWhereSQL	= '';
	
	if($useDateStart && $useDateEnd)
	{
		$dateWhereSQL	= ' AND start_time BETWEEN '.mktime(0, 0, 0, (int) $dateStart['month'], (int) $dateStart['day'], (int) $dateStart['year']).' AND '.mktime(23, 59, 59, (int) $dateEnd['month'], (int) $dateEnd['day'], (int) $dateEnd['year']);
	}
	elseif($useDateStart)
	{
		$dateWhereSQL	= ' AND start_time > '.mktime(0, 0, 0, (int) $dateStart['month'], (int) $dateStart['day'], (int) $dateStart['year']);
	}
	elseif($useDateStart)
	{
		$dateWhereSQL	= ' AND start_time < '.mktime(23, 59, 59, (int) $dateEnd['month'], (int) $dateEnd['day'], (int) $dateEnd['year']);
	}
	
	$LogCount	= $GLOBALS['DATABASE']->getFirstCell("SELECT COUNT(*) FROM ".LOG_FLEETS."

			LEFT JOIN ".PLANETS." pstart ON pstart.id = fleet_start_id
			LEFT JOIN ".PLANETS." ptarget ON ptarget.id = fleet_end_id
			LEFT JOIN ".USERS." ustart ON ustart.id = fleet_owner
			LEFT JOIN ".USERS." utarget ON utarget.id = fleet_target_owner
			LEFT JOIN ".AKS." acs ON acs.id = fleet_group
			WHERE fleet_universe = ".Universe::getEmulated()."
			".$where." ".$dateWhereSQL.";");
	
	$maxPage	= max(1, ceil($LogCount / $perSide));
	$page		= max(1, min($page, $maxPage));
	
	$sqlLimit	= (($page - 1) * $perSide).", ".($perSide - 1);
	
	
	$orderBy		= "fleet_id";

	$fleetResult	= $GLOBALS['DATABASE']->query("SELECT 
	fleet.*,
	pstart.name as startPlanetName,
	ptarget.name as targetPlanetName,
	ustart.username as startUserName,
	utarget.username as targetUserName,
	acs.name as acsName
	FROM ".LOG_FLEETS." fleet

	LEFT JOIN ".PLANETS." pstart ON pstart.id = fleet_start_id
	LEFT JOIN ".PLANETS." ptarget ON ptarget.id = fleet_end_id
	LEFT JOIN ".USERS." ustart ON ustart.id = fleet_owner
	LEFT JOIN ".USERS." utarget ON utarget.id = fleet_target_owner
	LEFT JOIN ".AKS." acs ON acs.id = fleet_group
	WHERE fleet_universe = ".Universe::getEmulated()."
	".$where." ".$dateWhereSQL."
	ORDER BY ".$orderBy." DESC LIMIT ".$sqlLimit.";");
	
	$FleetList	= array();
	
	while($fleetRow = $GLOBALS['DATABASE']->fetch_array($fleetResult)) {
		$shipList		= array();
		$shipArray		= array_filter(explode(';', $fleetRow['fleet_array']));
		foreach($shipArray as $ship) {
			$shipDetail		= explode(',', $ship);
			$shipList[$shipDetail[0]]	= $shipDetail[1];
		}
		
		$FleetList[]	= array(
			'fleetID'				=> $fleetRow['fleet_id'],
			'lock'					=> !empty($fleetRow['lock']),
			'count'					=> $fleetRow['fleet_amount'],
			'error'					=> !$fleetRow['error'],
			'ships'					=> $shipList,
			'state'					=> $fleetRow['fleet_mess'],
			'starttime'				=> _date($LNG['php_tdformat'], $fleetRow['start_time'], $USER['timezone']),
			'arrivaltime'			=> _date($LNG['php_tdformat'], $fleetRow['fleet_start_time'], $USER['timezone']),
			'stayhour'				=> round(($fleetRow['fleet_end_stay'] - $fleetRow['fleet_start_time']) / 3600),
			'staytime'				=> $fleetRow['fleet_start_time'] !== $fleetRow['fleet_end_stay'] ? _date($LNG['php_tdformat'], $fleetRow['fleet_end_stay'], $USER['timezone']) : 0,
			'endtime'				=> _date($LNG['php_tdformat'], $fleetRow['fleet_end_time'], $USER['timezone']),
			'missionID'				=> $fleetRow['fleet_mission'],
			'acsID'					=> $fleetRow['fleet_group'],
			'acsName'				=> $fleetRow['acsName'],
			'startUserID'			=> $fleetRow['fleet_owner'],
			'startUserName'			=> $fleetRow['startUserName'],
			'startPlanetID'			=> $fleetRow['fleet_start_id'],
			'startPlanetName'		=> $fleetRow['startPlanetName'],
			'startPlanetGalaxy'		=> $fleetRow['fleet_start_galaxy'],
			'startPlanetSystem'		=> $fleetRow['fleet_start_system'],
			'startPlanetPlanet'		=> $fleetRow['fleet_start_planet'],
			'startPlanetType'		=> $fleetRow['fleet_start_type'],
			'targetUserID'			=> $fleetRow['fleet_target_owner'],
			'targetUserName'		=> $fleetRow['targetUserName'],
			'targetPlanetID'		=> $fleetRow['fleet_end_id'],
			'targetPlanetName'		=> $fleetRow['targetPlanetName'],
			'targetPlanetGalaxy'	=> $fleetRow['fleet_end_galaxy'],
			'targetPlanetSystem'	=> $fleetRow['fleet_end_system'],
			'targetPlanetPlanet'	=> $fleetRow['fleet_end_planet'],
			'targetPlanetType'		=> $fleetRow['fleet_end_type'],
			'resource'				=> array(
				901	=> $fleetRow['fleet_resource_metal'],
				902	=> $fleetRow['fleet_resource_crystal'],
				903	=> $fleetRow['fleet_resource_deuterium'],
				921	=> $fleetRow['fleet_resource_darkmatter'],
			),
		);
	}
	
	
	$GLOBALS['DATABASE']->free_result($fleetResult);
	
		$AvailableMissions	= array();
		
		if(isModuleAvailable(MODULE_MISSION_EXPEDITION))
			$AvailableMissions[]	= 15;	
		if(isModuleAvailable(MODULE_MISSION_RECYCLE))
			$AvailableMissions[]	= 8;	
		if(isModuleAvailable(MODULE_MISSION_COLONY))
			$AvailableMissions[]	= 7;
		if(isModuleAvailable(MODULE_MISSION_TRANSPORT))
			$AvailableMissions[]	= 3;
		if(isModuleAvailable(MODULE_MISSION_SPY))
			$AvailableMissions[]	= 6;
		if(isModuleAvailable(MODULE_MISSION_ATTACK))
			$AvailableMissions[]	= 1;
		if(isModuleAvailable(MODULE_MISSION_HOLD))
			$AvailableMissions[]	= 5;
		if(isModuleAvailable(MODULE_MISSION_STATION))
			$AvailableMissions[]	= 4;
		if(isModuleAvailable(MODULE_MISSION_ACS))
			$AvailableMissions[]	= 2;
		if(isModuleAvailable(MODULE_MISSION_DESTROY))
			$AvailableMissions[]	= 9;
		if(isModuleAvailable(MODULE_MISSION_DARKMATTER))
			$AvailableMissions[]	= 11;
	
	$missions = array();
	foreach($AvailableMissions as $miss){
		$missions[$miss]	= $LNG['type_mission_'.$miss];
	}
	
	$missions[0]	= $LNG['ma_all'];
	
	
	$template			= new template();
	$template->assign_vars(array(
		'FleetList'			=> $FleetList,
		'missions'	=> $missions,
		'mission'	=> $mission,
		'owner'	=> $owner,
		'target' => $target,
		'maxPage'		=> $maxPage,
		'page'			=> $page,
		'dateStart'		=> $dateStart,
		'dateEnd'		=> $dateEnd,
		'ownername'		=>	$ownername,
		'targetname'	=>	$targetname,
	));
	$template->show('FleetLogPage.tpl');
}