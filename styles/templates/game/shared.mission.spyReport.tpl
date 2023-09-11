<div class="spyRaport">
	<div id="serparate" style="    width: 100%;    height: 5px;"></div>

	<div class="spyRaportHead">
		 <div style="float: left;    padding: 3px;    background-color: #1e2439;   color:white; width: 100%;"><a href="game.php?page=galaxy&amp;galaxy={$targetPlanet.galaxy}&amp;system={$targetPlanet.system}">{$title}</a> <b style="float:right;    padding-right: 5px;">Aktywność {$online}</b></div>

	</div>
		<table style="    width: 100%;">
<th style="width:33%">	<center> Surowce: {$surowce|number_format:0:"":"."} </center></th>
<th style="width:33%">	<center> <a href="game.php?page=fleetTable&amp;galaxy={$targetPlanet.galaxy}&amp;system={$targetPlanet.system}&amp;planet={$targetPlanet.planet}&amp;planettype={$targetPlanet.planet_type}&amp;target_mission=1&ship[202]={$mt}">  Atakuj małym Transporterem({$mt|number_format:0:"":"."})</a></center></th>
<th style="width:33%">	<center> <a href="game.php?page=fleetTable&amp;galaxy={$targetPlanet.galaxy}&amp;system={$targetPlanet.system}&amp;planet={$targetPlanet.planet}&amp;planettype={$targetPlanet.planet_type}&amp;target_mission=1&ship[203]={$dt}">  Atakuj dużym Transporterem({$dt|number_format:0:"":"."})</a></center></th>
</tr>
<TR><TH colspan="3"><center>{if $def > 0 } <B style="color:red;">Na planecie wykryto systemy Obronne oraz flote w ilości {$def} szt!</b>{else}<B style="color:green;">Na planecie nie wykryto systemów obronnych oraz floty bądź są skamuflowane ! </b>{/if}</center></th></tr>
</tbody></table>
	{foreach $spyData as $Class => $elementIDs}
	<div class="spyRaportContainer"> 
	<div class="spyRaportContainerHead spyRaportContainerHeadClass{$Class}">{$LNG.tech.$Class}</div>
	<div>
</div>
	{foreach $elementIDs as $elementID => $amount}
	
	{if ($amount@iteration % 2) === 1}<div class="spyRaportContainerRow clearfix">{/if}

		<div class="spyRaportContainerCell" style="    width: 30%;"><img style="    padding: 3px;" src="./styles/theme/gow/gebaeude/{$elementID}.gif" alt="{$LNG.tech.$elementID}" width="20" height="20">{$LNG.tech.$elementID}</div>
		<div class="spyRaportContainerCell" style="    width: 18%;">{$amount|number}</div>

	{if ($amount@iteration % 2) === 0}</div>{/if}
	
	
	{/foreach}
	</div>
	{/foreach}
	<div class="spyRaportFooter">
	
	
	</div>
	
	<table style="    width: 100%;">
	<tr><th style="width:33%">	<center>	<a href="game.php?page=fleetTable&amp;galaxy={$targetPlanet.galaxy}&amp;system={$targetPlanet.system}&amp;planet={$targetPlanet.planet}&amp;planettype={$targetPlanet.planet_type}&amp;target_mission=1">{$LNG.type_mission_1}</a></th>
<th style="width:33%"><center>{if $targetChance >= $spyChance}{$LNG.sys_mess_spy_destroyed}{else}Szansa na przechwycenie: {$targetChance}%{/if}</th>
<th style="width:33%"><center>{if $isBattleSim}<a href="game.php?page=battleSimulator{foreach $spyData as $Class => $elementIDs}{foreach $elementIDs as $elementID => $amount}&amp;im[{$elementID}]={$amount}{/foreach}{/foreach}">{$LNG.fl_simulate}</a>{/if}
</th></tr>

</tbody></table>
	
	
</div>
