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

require_once('AbstractGamePage.class.php');

class ShowResearchPage extends AbstractGamePage
{
	public static $requireModule = MODULE_RESEARCH;

	function __construct()
	{
		parent::__construct();
	}
	
	
	
	private function CheckLabSettingsInQueue()
	{
			global $USER;
		$db = Database::get();
		$sql	= "SELECT * FROM %%PLANETS%% WHERE id_owner = :owner;";
		$planets	= $db->select($sql, array(
			':owner'	=> $USER['id'],
		));
		foreach ($planets as $planet)
		{
			if ($planet['b_building'] == 0)
				continue;
			$CurrentQueue		= unserialize($planet['b_building_id']);
			foreach($CurrentQueue as $ListIDArray) {
				if($ListIDArray[0] == 6 || $ListIDArray[0] == 31)
					return false;
			}
		}

		return true;
	}

	private function CancelBuildingFromQueue()
	{
		global $PLANET, $USER, $resource;
		$CurrentQueue  = unserialize($USER['b_tech_queue']);
		if (empty($CurrentQueue) || empty($USER['b_tech']))
		{
			$USER['b_tech_queue']	= '';
			$USER['b_tech_planet']	= 0;
			$USER['b_tech_id']		= 0;
			$USER['b_tech']			= 0;

			return false;
		}

		$db = Database::get();

		$elementId		= $USER['b_tech_id'];
		$costResources	= BuildFunctions::getElementPrice($USER, $PLANET, $elementId, false, $USER[$resource[$elementId]] + 1);

		if($PLANET['id'] == $USER['b_tech_planet'])
		{
			if(isset($costResources[901])) { $PLANET[$resource[901]]	+= $costResources[901]; }
			if(isset($costResources[902])) { $PLANET[$resource[902]]	+= $costResources[902]; }
			if(isset($costResources[903])) { $PLANET[$resource[903]]	+= $costResources[903]; }
		}
		else
		{
			$params = array('techPlanet' => $USER['b_tech_planet']);
			$sql = "UPDATE %%PLANETS%% SET ";
			if(isset($costResources[901])) {
				$sql	.= $resource[901]." = ".$resource[901]." + :".$resource[901].", ";
				$params[':'.$resource[901]] = $costResources[901];
			}
			if(isset($costResources[902])) {
				$sql	.= $resource[902]." = ".$resource[902]." + :".$resource[902].", ";
				$params[':'.$resource[902]] = $costResources[902];
			}
			if(isset($costResources[903])) {
				$sql	.= $resource[903]." = ".$resource[903]." + :".$resource[903].", ";
				$params[':'.$resource[903]] = $costResources[903];
			}

			$sql = substr($sql, 0, -2);
			$sql .= " WHERE id = :techPlanet;";

			$db->update($sql, $params);
		}

		if(isset($costResources[921])) { $USER[$resource[921]]		+= $costResources[921]; }

		$USER['b_tech_id']			= 0;
		$USER['b_tech']      		= 0;
		$USER['b_tech_planet']		= 0;

		array_shift($CurrentQueue);

		if (count($CurrentQueue) == 0) {
			$USER['b_tech_queue']	= '';
			$USER['b_tech_planet']	= 0;
			$USER['b_tech_id']		= 0;
			$USER['b_tech']			= 0;
		} else {
			$BuildEndTime		= TIMESTAMP;
			$NewCurrentQueue	= array();
			foreach($CurrentQueue as $ListIDArray)
			{
				if($elementId == $ListIDArray[0] || empty($ListIDArray[0]))
					continue;

				if($ListIDArray[4] != $PLANET['id']) {
					$sql = "SELECT :resource6, :resource31, id FROM %%PLANETS%% WHERE id = :id;";
					$CPLANET = $db->selectSingle($sql, array(
						':resource6'	=> $resource[6],
						':resource31'	=> $resource[31],
						':id'			=> $ListIDArray[4]
					));
				} else
					$CPLANET		= $PLANET;

				$CPLANET[$resource[31].'_inter']	= $this->ecoObj->getNetworkLevel($USER, $CPLANET);
				$BuildEndTime       				+= BuildFunctions::getBuildingTime($USER, $CPLANET, $ListIDArray[0], NULL, false, $ListIDArray[1]);
				$ListIDArray[3]						= $BuildEndTime;
				$NewCurrentQueue[]					= $ListIDArray;
			}

			if(!empty($NewCurrentQueue)) {
				$USER['b_tech']    			= TIMESTAMP;
				$USER['b_tech_queue'] 		= serialize($NewCurrentQueue);
				$this->ecoObj->setData($USER, $PLANET);
				$this->ecoObj->SetNextQueueTechOnTop();
				list($USER, $PLANET)		= $this->ecoObj->getData();
			} else {
				$USER['b_tech']    			= 0;
				$USER['b_tech_queue'] 		= '';
			}
		}

		return true;
	}

	private function RemoveBuildingFromQueue($QueueID)
	{
		global $USER, $PLANET, $resource;

		$CurrentQueue  = unserialize($USER['b_tech_queue']);
		if ($QueueID <= 1 || empty($CurrentQueue))
		{
			return false;
		}

		$ActualCount   = count($CurrentQueue);
		if ($ActualCount <= 1)
		{
			return $this->CancelBuildingFromQueue();
		}

		if(!isset($CurrentQueue[$QueueID - 2]))
		{
			return false;
		}

		$elementId 		= $CurrentQueue[$QueueID - 2][0];
		$BuildEndTime	= $CurrentQueue[$QueueID - 2][3];
		unset($CurrentQueue[$QueueID - 1]);
		$NewCurrentQueue	= array();
		foreach($CurrentQueue as $ID => $ListIDArray)
		{				
			if ($ID < $QueueID - 1) {
				$NewCurrentQueue[]	= $ListIDArray;
			} else {
				if($elementId == $ListIDArray[0])
					continue;

				if($ListIDArray[4] != $PLANET['id']) {
					$db = Database::get();

					$sql = "SELECT :resource6, :resource31, id FROM %%PLANETS%% WHERE id = :id;";
					$CPLANET = $db->selectSingle($sql, array(
						':resource6'	=> $resource[6],
						':resource31'	=> $resource[31],
						':id'			=> $ListIDArray[4]
					));
				} else
					$CPLANET				= $PLANET;
				
				$CPLANET[$resource[31].'_inter']	= $this->ecoObj->getNetworkLevel($USER, $CPLANET);
				
				$BuildEndTime       += BuildFunctions::getBuildingTime($USER, $CPLANET, NULL, $ListIDArray[0]);
				$ListIDArray[3]		= $BuildEndTime;
				$NewCurrentQueue[]	= $ListIDArray;				
			}
		}
		
		if(!empty($NewCurrentQueue))
			$USER['b_tech_queue'] = serialize($NewCurrentQueue);
		else
			$USER['b_tech_queue'] = "";

		return true;
	}

	private function AddBuildingToQueue($elementId, $AddMode = true)
	{
		global $PLANET, $USER, $resource, $reslist, $pricelist;

		if(!in_array($elementId, $reslist['tech'])
			|| !BuildFunctions::isTechnologieAccessible($USER, $PLANET, $elementId)
			|| !$this->CheckLabSettingsInQueue($PLANET)
		)
		{
			return false;
		}

		$CurrentQueue  		= unserialize($USER['b_tech_queue']);
		
		if (!empty($CurrentQueue)) {
			$ActualCount   	= count($CurrentQueue);
		} else {
			$CurrentQueue  	= array();
			$ActualCount   	= 0;
		}
				
		if(Config::get()->max_elements_tech != 0 && Config::get()->max_elements_tech <= $ActualCount)
		{
			return false;
		}

		$BuildLevel					= $USER[$resource[$elementId]] + 1;
		if($ActualCount == 0)
		{
			if($pricelist[$elementId]['max'] < $BuildLevel)
			{
				return false;
			}

			$costResources		= BuildFunctions::getElementPrice($USER, $PLANET, $elementId, !$AddMode, $BuildLevel);
			
			if(!BuildFunctions::isElementBuyable($USER, $PLANET, $elementId, $costResources))
			{
				return false;
			}
			
			if(isset($costResources[901])) { $PLANET[$resource[901]]	-= $costResources[901]; }
			if(isset($costResources[902])) { $PLANET[$resource[902]]	-= $costResources[902]; }
			if(isset($costResources[903])) { $PLANET[$resource[903]]	-= $costResources[903]; }
			if(isset($costResources[921])) { $USER[$resource[921]]		-= $costResources[921]; }
			
			$elementTime    			= BuildFunctions::getBuildingTime($USER, $PLANET, $elementId, $costResources);
			$BuildEndTime				= TIMESTAMP + $elementTime;
			
			$USER['b_tech_queue']		= serialize(array(array($elementId, $BuildLevel, $elementTime, $BuildEndTime, $PLANET['id'])));
			$USER['b_tech']				= $BuildEndTime;
			$USER['b_tech_id']			= $elementId;
			$USER['b_tech_planet']		= $PLANET['id'];
		} else {
			$addLevel = 0;
			foreach($CurrentQueue as $QueueSubArray)
			{
				if($QueueSubArray[0] != $elementId)
					continue;
					
				$addLevel++;
			}
				
			$BuildLevel					+= $addLevel;
				
			if($pricelist[$elementId]['max'] < $BuildLevel)
			{
				return false;
			}
				
			$elementTime    			= BuildFunctions::getBuildingTime($USER, $PLANET, $elementId, NULL, !$AddMode, $BuildLevel);
			
			$BuildEndTime				= $CurrentQueue[$ActualCount - 1][3] + $elementTime;
			$CurrentQueue[]				= array($elementId, $BuildLevel, $elementTime, $BuildEndTime, $PLANET['id']);
			$USER['b_tech_queue']		= serialize($CurrentQueue);
		}
		return true;
	}

	private function getQueueData()
	{
		global $LNG, $PLANET, $USER;

		$scriptData		= array();
		$quickinfo		= array();
		
		if ($USER['b_tech'] == 0)
		return array('queue' => $scriptData, 'quickinfo' => $quickinfo);
		
		$CurrentQueue   = unserialize($USER['b_tech_queue']);
		
		foreach($CurrentQueue as $BuildArray) {
			if ($BuildArray[3] < TIMESTAMP)
				continue;
			
			$PlanetName	= '';
		
			$quickinfo[$BuildArray[0]]	= $BuildArray[1];
			
			if($BuildArray[4] != $PLANET['id'])
				$PlanetName		= $USER['PLANETS'][$BuildArray[4]]['name'];
				
			$scriptData[] = array(
				'element'	=> $BuildArray[0], 
				'level' 	=> $BuildArray[1], 
				'time' 		=> $BuildArray[2], 
				'resttime' 	=> ($BuildArray[3] - TIMESTAMP), 
				'destroy' 	=> ($BuildArray[4] == 'destroy'), 
				'endtime' 	=> _date('U', $BuildArray[3], $USER['timezone']),
				'display' 	=> _date($LNG['php_tdformat'], $BuildArray[3], $USER['timezone']),
				'planet'	=> $PlanetName,
			);
		}
		
		return array('queue' => $scriptData, 'quickinfo' => $quickinfo);
	}

	public function show()
	{
		global $PLANET, $USER, $LNG, $resource, $reslist, $pricelist;
		
		if ($PLANET[$resource[31]] == 0)
		{
			$this->printMessage($LNG['bd_lab_required']);
		}
			
		$TheCommand		= HTTP::_GP('cmd','');
		$elementId     	= HTTP::_GP('tech', 0);
		$ListID     	= HTTP::_GP('listid', 0);
		
		$PLANET[$resource[31].'_inter']	= ResourceUpdate::getNetworkLevel($USER, $PLANET);	

		if(!empty($TheCommand) && $_SERVER['REQUEST_METHOD'] === 'POST' && $USER['urlaubs_modus'] == 0)
		{
			switch($TheCommand)
			{
				case 'cancel':
					$this->CancelBuildingFromQueue();
				break;
				case 'remove':
					$this->RemoveBuildingFromQueue($ListID);
				break;
				case 'insert':
					$this->AddBuildingToQueue($elementId, true);
				break;
				case 'destroy':
					$this->AddBuildingToQueue($elementId, false);
				break;
			}
			
			$this->redirectTo('game.php?page=research');
		}
		
		$bContinue		= $this->CheckLabSettingsInQueue($PLANET);
		
		$queueData		= $this->getQueueData();
		$TechQueue		= $queueData['queue'];
		$QueueCount		= count($TechQueue);
		$ResearchList	= array();

		foreach($reslist['tech'] as $elementId)
		{
			if (!BuildFunctions::isTechnologieAccessible($USER, $PLANET, $elementId))
				continue;
				
			if(isset($queueData['quickinfo'][$elementId]))
			{
				$levelToBuild	= $queueData['quickinfo'][$elementId];
			}
			else
			{
				$levelToBuild	= $USER[$resource[$elementId]];
			}
			
			$costResources		= BuildFunctions::getElementPrice($USER, $PLANET, $elementId, false, $levelToBuild+1);
			$costOverflow		= BuildFunctions::getRestPrice($USER, $PLANET, $elementId, $costResources);
			$elementTime    	= BuildFunctions::getBuildingTime($USER, $PLANET, $elementId, $costResources);
			$buyable			= $QueueCount != 0 || BuildFunctions::isElementBuyable($USER, $PLANET, $elementId, $costResources);
					$config	= Config::get();

$wym['m'] = 0;
$basicIncome[901]	= $config->{$resource[901].'_basic_income'};
			$basicIncome[902]	= $config->{$resource[902].'_basic_income'};
			$basicIncome[903]	= $config->{$resource[903].'_basic_income'};
			$basicIncome[911]	= $config->{$resource[911].'_basic_income'};

		$basicProduction	= array(
			901 => $basicIncome[901] * $config->resource_multiplier,
			902 => $basicIncome[902] * $config->resource_multiplier,
			903	=> $basicIncome[903] * $config->resource_multiplier,
			911	=> $basicIncome[911] * $config->energySpeed,
		);
		$wym['m'] = 0;$wym['k'] = 0;$wym['d'] = 0;

if(isset($costResources[901])) { $wym['m']	= @floor($costResources[901]-$PLANET[$resource[901]])/($PLANET[$resource[901].'_perhour'] + $basicProduction[901]); }
if(isset($costResources[902])) { $wym['k']	= @floor($costResources[902]-$PLANET[$resource[902]])/($PLANET[$resource[902].'_perhour'] + $basicProduction[902]); }
if(isset($costResources[903]) and $PLANET[$resource[903].'_perhour'] > 0) { $wym['d']	= @floor($costResources[903]-$PLANET[$resource[903]])/($PLANET[$resource[903].'_perhour'] + $basicProduction[903]); }

$szer_w = 70; 
	$czas = max($wym);
if($czas <= 0) $szer_w = 90;
if($czas <= 0) $czas_t = "Zbadaj do ".($levelToBuild+1)."!"; else $czas_t = "<span style='    font-size: 11px;    color: #bbbbbb;    font-weight: 800;'>Dostępne o ".((date('d-m-y',time() + ($czas * 3600)) == date('d-m-y'))?date('G:i d-m-y ',time() + ($czas * 3600)):date('G:i d-m-y',time() + ($czas * 3600)))."</b><br></span>";
if($czas <= 0) $czas_t2 = ""; else $czas_t2 = "<span style='   font-size: 11px;    olor: #bbbbbb;    font-weight: 800;'>Dostępne o ".((date('d-m-y',time() + ($czas * 3600)) == date('d-m-y'))?date('G:i d-m-y ',time() + ($czas * 3600)):date('G:i d-m-y',time() + ($czas * 3600)))."</b></span>";



			$ResearchList[$elementId]	= array(
				'id'				=> $elementId,
				'level'				=> $USER[$resource[$elementId]],
				'maxLevel'			=> $pricelist[$elementId]['max'],
				'costResources'		=> $costResources,
				'costOverflow'		=> $costOverflow,
				'elementTime'    	=> $elementTime,
				'buyable'			=> $buyable,
				'start'	=> $czas_t,
				'start2'	=> $czas_t2,
				'szer'	=> $szer_w,
				'levelToBuild'		=> $levelToBuild,
			);
		}
		
		$this->assign(array(
			'ResearchList'	=> $ResearchList,
			'IsLabinBuild'	=> !$bContinue,
							'szablon'	=> ((isset($_SESSION["lista_b"]))?floor($_SESSION["lista_b"]):0),
			'IsFullQueue'	=> Config::get()->max_elements_tech == 0 || Config::get()->max_elements_tech == count($TechQueue),
			'Queue'			=> $TechQueue,
		));
		
		$this->display('page.research.default.tpl');
	}
}
