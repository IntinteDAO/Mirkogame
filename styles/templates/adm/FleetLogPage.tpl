{include file="overall_header.tpl"}
<form action="admin.php?page=fleetslog" method="post" id="form">
<input type="hidden" name="side" value="{$page}" id="side">
<table width="90%">   
	<tr>
		<th colspan="5">{$LNG.ml_message_list}</th>
	</tr>
	<tr>
		<td style="width:15%">{$LNG.mission}</td>
		<td style="width:35%">{html_options options=$missions selected=$mission name="mission"}</td>
		<td style="width:15%">{$LNG.ml_date_range}</td>
		<td style="width:17.5%"><input value="{$dateStart.day|default:''}" type="text" id="dateStartDay" name="dateStart[day]" style="width:25px" maxlength="2" placeholder="dd">.<input value="{$dateStart.month|default:''}" type="text" id="dateStartMonth" name="dateStart[month]" style="width:25px" maxlength="2" placeholder="mm">.<input value="{$dateStart.year|default:''}" type="text" id="dateStartYear" name="dateStart[year]" style="width:35px" maxlength="4" placeholder="yyyy"></td>
		<td style="width:17.5%"><input value="{$dateEnd.day|default:''}" type="text" id="dateEndDay" name="dateEnd[day]" style="width:25px" maxlength="2" placeholder="dd">.<input value="{$dateEnd.month|default:''}" type="text" id="dateEndMonth" name="dateEnd[month]" style="width:25px" maxlength="2" placeholder="mm">.<input value="{$dateEnd.year|default:''}" type="text" id="dateEndYear" name="dateEnd[year]" style="width:35px" maxlength="4" placeholder="yyyy"></td>
	</tr>
	<tr>
		<td style="width:15%"><label for="owner">{$LNG.owner} ID</label></td>
		<td style="width:35%"><input type="text" id="owner" name="owner" value="{$owner}" length="11"></td>
		<td style="width:15%"><label for="target">{$LNG.target} ID</label></td>
		<td style="width:35%" colspan="2"><input type="text" id="target" name="target" value="{$target}" length="11"></td>
	</tr>
	<tr>
		<td style="width:15%"><label for="ownername">{$LNG.owner} name</label></td>
		<td style="width:35%"><input type="text" id="ownername" name="ownername" value="{$ownername}" length="11"></td>
		<td style="width:15%"><label for="targetname">{$LNG.target} name</label></td>
		<td style="width:35%" colspan="2"><input type="text" id="targetname" name="targetname" value="{$targetname}" length="11"></td>
	</tr>
	<tr>
		<th colspan="5" class="center">
			<input type="submit" value="{$LNG.ml_type_submit}">
		</th>
	</tr>
</table>
<table width="90%">
<tr style="height: 20px;">
		<td class="right" colspan="11">{$LNG.mg_page}: {if $page != 1}<a href="#" onclick="gotoPage({$page - 1});return false;">&laquo;</a> {/if}{for $site=1 to $maxPage}<a href="#" onclick="gotoPage({$site});return false;">{if $site == $page}<span style="color:orange"><b>[{$site}]</b></span>{else}[{$site}]{/if}</a>{if $site != $maxPage} {/if}{/for}{if $page != $maxPage} <a href="#" onclick="gotoPage({$page + 1});return false;">&raquo;</a>{/if}</td>
	</tr>
<tr>
	<th>{$LNG.ff_fleetid}</th>
	<th>{$LNG.ff_mission}</th>
	<th>{$LNG.ff_starttime}</th>
	<th>{$LNG.ff_ships}</th>
	<th>{$LNG.ff_startuser}</th>
	<th>{$LNG.ff_startplanet}</th>
	<th>{$LNG.ff_arrivaltime}</th>
	<th>{$LNG.ff_targetuser}</th>
	<th>{$LNG.ff_targetplanet}</th>
    <th>{$LNG.ff_endtime}</th>
    <th>{$LNG.ff_holdtime}</th>
</tr>
{foreach $FleetList as $FleetRow}
<tr>
	<td>{$FleetRow.fleetID}</td>
	<td><a href="#" data-tooltip-content="<table style='width:200px'>{foreach $FleetRow.resource as $resourceID => $resourceCount}<tr><td style='width:50%'>{$LNG.tech.$resourceID}</td><td style='width:50%'>{$resourceCount|number}</td></tr>{/foreach}</table>" class="tooltip">{$LNG["type_mission_{$FleetRow.missionID}"]}{if $FleetRow.acsID != 0}<br>{$FleetRow.acsID}<br>{$FleetRow.acsName}{/if}&nbsp;(R)</a></td>
	<td>{$FleetRow.starttime}</td>
	<td><a href="#" data-tooltip-content="<table style='width:200px'>{foreach $FleetRow.ships as $shipID => $shipCount}<tr><td style='width:50%'>{$LNG.tech.$shipID}</td><td style='width:50%'>{$shipCount|number}</td></tr>{/foreach}</table>" class="tooltip">{$FleetRow.count|number}&nbsp;(D)</a></td>
	<td>{$FleetRow.startUserName} (ID:&nbsp;{$FleetRow.startUserID})</td>
	<td>{$FleetRow.startPlanetName}&nbsp;[{$FleetRow.startPlanetGalaxy}:{$FleetRow.startPlanetSystem}:{$FleetRow.startPlanetPlanet}] (ID:&nbsp;{$FleetRow.startPlanetID})</td>
	<td>{if $FleetRow.state == 0}<span style="color:lime;">{/if}{$FleetRow.arrivaltime}{if $FleetRow.state == 0}</span>{/if}</td>
	<td>{if $FleetRow.targetUserID != 0}{$FleetRow.targetUserName} (ID:&nbsp;{$FleetRow.targetUserID}){/if}</td>
	<td>{$FleetRow.targetPlanetName}&nbsp;[{$FleetRow.targetPlanetGalaxy}:{$FleetRow.targetPlanetSystem}:{$FleetRow.targetPlanetPlanet}]{if $FleetRow.targetPlanetID != 0} (ID:&nbsp;{$FleetRow.targetPlanetID}){/if}</td>
	<td>{if $FleetRow.state == 1}<span style="color:lime;">{/if}{$FleetRow.endtime}{if $FleetRow.state == 0}</span>{/if}</td>
	<td>{if $FleetRow.stayhour != 0}{if $FleetRow.state == 2}<span style="color:lime;">{/if}{$FleetRow.staytime} ({$FleetRow.stayhour}&nbsp;h){if $FleetRow.state == 0}</span>{/if}{else}-{/if}</td>
</tr>
{foreachelse}
<tr>
	<td colspan="12">{$LNG.ff_no_fleets}</td>
</tr>
{/foreach}
</table>
</form>
<script src="scripts/admin/fleetlog.js"></script>
</body>

{include file="overall_footer.tpl"}