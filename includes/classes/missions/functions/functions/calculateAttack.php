<?php

define('PATH', ROOT_PATH . 'includes/libs/opbe-master/');
include (PATH . 'utils/includer.php');

define('ID_MIN_SHIPS', 200);
define('ID_MAX_SHIPS', 400);
define('HOME_FLEET', 0);
define('DEFENDERS_WON', 'r');
define('ATTACKERS_WON', 'a');
define('DRAW', 'w');
define('METAL_ID', 901);
define('CRYSTAL_ID', 902);

define('DEBUG', true);

function calculateAttack(&$attackers, &$defenders, $FleetTF, $DefTF)
{
	global $pricelist, $CombatCaps, $resource;
	
	$attackerGroupObj = new PlayerGroup();
    foreach ($attackers as $fleetID => $attacker)
    {
        $player = $attacker['player'];
		
		$attTech = (($player['military_tech']) + $player['factor']['Attack']*10);
		$defTech = (($player['defence_tech']) + $player['factor']['Defensive']*10);
		$shieldTech = (($player['shield_tech']) + $player['factor']['Shield']*10);
		
        $attackerPlayerObj = $attackerGroupObj->createPlayerIfNotExist($player['id'], array(), $attTech, $defTech, $shieldTech);
        $attackerFleetObj = new Fleet($fleetID);
        foreach ($attacker['unit'] as $element => $amount)
        {
            if (empty($amount)) continue;
            $fighters = getFighters($element, $amount, $attacker);
            $attackerFleetObj->addShipType($fighters);
        }
        $attackerPlayerObj->addFleet($attackerFleetObj);
    }
    
    $defenderGroupObj = new PlayerGroup();
    foreach ($defenders as $fleetID => $defender)
    {
        $player = $defender['player'];
		
		$attTech = (($player['military_tech']) + $player['factor']['Attack']*10);
		$defTech = (($player['defence_tech']) + $player['factor']['Defensive']*10);
		$shieldTech = (($player['shield_tech']) + $player['factor']['Shield']*10);
		
        $defenderPlayerObj = $defenderGroupObj->createPlayerIfNotExist($player['id'], array(), $attTech, $defTech, $shieldTech);
        $defenderFleetObj = getFleet($fleetID);
        foreach ($defender['unit'] as $element => $amount)
        {
            if (empty($amount)) continue;
            $fighters = getFighters($element, $amount, $defender);
            $defenderFleetObj->addShipType($fighters);
        }
        $defenderPlayerObj->addFleet($defenderFleetObj);
    }

    /********** BATTLE ELABORATION **********/
    $opbe = new Battle($attackerGroupObj, $defenderGroupObj);
    $opbe->startBattle();
    $report = $opbe->getReport();
	
	/********** WHO WON **********/
    if ($report->defenderHasWin())
    {
        $won = DEFENDERS_WON;
    }
    elseif ($report->attackerHasWin())
    {
        $won = ATTACKERS_WON;
    }
    elseif ($report->isAdraw())
    {
        $won = DRAW;
    }
    else
    {
        throw new Exception('problem');
    }
	
	/********** ROUNDS INFOS **********/

    $ROUND = array();
    $i = 0;
    $lastRound = $report->getLastRoundNumber();
    for (; $i <= $lastRound; $i++)
    {
        // in case of last round, ask for rebuilt defenses. to change rebuils prob see constants/battle_constants.php
        $attackerGroupObj = ($lastRound == $i) ? $report->getAfterBattleAttackers() : $report->getResultAttackersFleetOnRound($i);
        $defenderGroupObj = ($lastRound == $i) ? $report->getAfterBattleDefenders() : $report->getResultDefendersFleetOnRound($i);
        $attackAmount = $attackerGroupObj->getTotalCount();
        $defenseAmount = $defenderGroupObj->getTotalCount();
        $attInfo = updatePlayers($attackerGroupObj, $attackers, "unit");
        $defInfo = updatePlayers($defenderGroupObj, $defenders, "unit");
        $ROUND[$i] = roundInfo($report, $attackers, $defenders, $attackerGroupObj, $defenderGroupObj, $i + 1, $attInfo, $defInfo);
    }

    /********** DEBRIS **********/
    //attackers
    $debAtt = $report->getAttackerDebris();
    $debAttMet = $debAtt[0];
    $debAttCry = $debAtt[1];
    //defenders
    $debDef = $report->getDefenderDebris();
    $debDefMet = $debDef[0];
    $debDefCry = $debDef[1];
    //total
    $debris = array('attacker' => array(901 => $debAttMet, 902 => $debAttCry), 'defender' =>  array(901 => $debDefMet, 902 => $debDefCry));

    /********** LOST UNITS **********/
	$totalLost = array('attacker' => $report->getTotalAttackersLostUnits(), 'defender' => $report->getTotalDefendersLostUnits());

    /********** RETURNS **********/
    return array(
        'won' => $won,
        'debris' => $debris,
        'rw' => $ROUND,
        'unitLost' => $totalLost);
}

function roundInfo(BattleReport $report, $attackers, $defenders, PlayerGroup $attackerGroupObj, PlayerGroup $defenderGroupObj, $i, $attInfo, $defInfo)
{
    // the last round doesn't has next round, so we not ask for fire etc
	if($i <= $report->getLastRoundNumber()){
		$_round = $report->getRound($i);
		
		$_attack = $_round->getDefendersFirePower($i);
		$_defense = $_round->getAttackersFirePower($i);
		
		$_attackAssorbed = $_round->getDefendersAssorbedDamage($i);
		$_defenseAssorbed = $_round->getAttachersAssorbedDamage($i);
	}else{
		$_attack = 0;
		$_defense = 0;
		
		$_attackAssorbed = 0;
		$_defenseAssorbed = 0;
	}
		
	
	$attack		= ($i > $report->getLastRoundNumber()) ? 0 : $_attack;
    $defense	= ($i > $report->getLastRoundNumber()) ? 0 : $_defense;
	
	
	
    return array(
        'attack' => $attack,
        'defense' => $defense,
        'defShield' => ($i > $report->getLastRoundNumber()) ? 0 : min($attack, $_attackAssorbed),
        'attackShield' => ($i > $report->getLastRoundNumber()) ? 0 :  min($defense, $_defenseAssorbed),
        'attackers' => $attackers,
        'defenders' => $defenders,
        'attackA' => $attInfo[1],
        'defenseA' => $defInfo[1],
        'infoA' => $attInfo[0],
        'infoD' => $defInfo[0]);
}

function updatePlayers(PlayerGroup $playerGroup, &$players, $index)
{
    $plyArray = array();
    $amountArray = array();
    foreach ($players as $idFleet => $info)
    {
        $shipInfo = $info[$index];
        $player = $playerGroup->getPlayer($info['player']['id']);
        $fleet = ($player !== false) ? $player->getFleet($idFleet) : false;

        foreach ($shipInfo as $idFighters => $amount)
        {
            if ($fleet !== false) //if after battle still there are some ship types in this fleet
            {
                $fighters = !($fleet->existShipType($idFighters)) ? false : $fleet->getShipType($idFighters);
                if ($fighters !== false) //if there are some ships of this type
                {
                    //used to show life,power and shield of each ships in the report
                    $plyArray[$idFleet][$idFighters] = array(
                        'def' => $fighters->getHull(),
                        'shield' => $fighters->getShield(),
                        'att' => $fighters->getPower(),
					);
                    $players[$idFleet][$index][$idFighters] = $fighters->getCount();
					$players[$idFleet][$index.'_kill'][$idFighters] = -1;
                }
                else //all ships of this type were destroyed
                {
                    $players[$idFleet][$index][$idFighters] = 0;
					$players[$idFleet][$index.'_kill'][$idFighters] = -1;
                }
            }
            else //the fleet is empty, so all ships of this type were destroyed
            {
                $players[$idFleet][$index][$idFighters] = 0;
				$players[$idFleet][$index.'_kill'][$idFighters] = -1;
            }

            //initialization
            if (!isset($amountArray[$idFleet]))
            {
                $amountArray[$idFleet] = 0;
            }
            if (!isset($amountArray['total']))
            {
                $amountArray['total'] = 0;
            }
            //increment
            $currentAmount = $players[$idFleet][$index][$idFighters];
            $amountArray[$idFleet] = $amountArray[$idFleet] + $currentAmount;
            $amountArray['total'] = $amountArray['total'] + $currentAmount;
        }
        //used to show techs in the report .Empty player not exist in OPBE's result data
         $players[$idFleet]['techs'] = array(
            ($player != false) ? $player->getWeaponsTech() : 0,
            ($player != false) ? $player->getShieldsTech() : 0,
			($player != false) ? $player->getArmourTech() : 0);
    }
    return array($plyArray, $amountArray);
}

function getFighters($id, $count, $player = NULL)
{
    global $CombatCaps, $pricelist, $reslist;	
	
    $rf = isset($CombatCaps[$id]['sd']) ? $CombatCaps[$id]['sd'] : 0;
	
	$shield = $CombatCaps[$id]['shield'];
	
    $cost = array($pricelist[$id]['cost'][METAL_ID], $pricelist[$id]['cost'][CRYSTAL_ID]);
	
	$power	= $CombatCaps[$id]['attack'];
	
    if ($id > ID_MIN_SHIPS && $id < ID_MAX_SHIPS)
    {
        return new Ship($id, $count, $rf, $shield, $cost, $power);
    }
    return new Defense($id, $count, $rf, $shield, $cost, $power);
}

function getFleet($id)
{
    if ($id == HOME_FLEET)
    {
        return new HomeFleet(HOME_FLEET);
    }
    return new Fleet($id);
}