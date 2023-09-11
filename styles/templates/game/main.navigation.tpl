<div id="leftmenu">
	<div id="menu">
		<div class="menu-head"><a href="game.php?page=overview">{$LNG.lm_changelog}</a></div>
		<table>
		<tr><td class="transparent">
		<div></div><div onclick="menusel(this,'menut1');" id="menut1p"  class="mright"><img src="{$dpath}img/globe.svg?v=2" alt=""></div><div onclick="menusel(this,'menut2');"  id="menut2p" class="mright"><img src="{$dpath}img/com.svg" alt=""></div><div onclick="menusel(this,'menut3');"  id="menut3p" class="mright"><img src="{$dpath}img/set.svg" alt=""></div></div>
		</td></tr>
		
		<tr id="menut1" style="display:none;"><td>

		<div class="menucat1-head"><b><center>Rozwój</center></b></div>

		<div><a href="game.php?page=overview">{$LNG.lm_overview}</a></div>
		{if isModuleAvailable($smarty.const.MODULE_IMPERIUM)}<div><a href="game.php?page=imperium">{$LNG.lm_empire}</a></div>{/if}
				{if isModuleAvailable($smarty.const.MODULE_BUILDING)}<div><a href="game.php?page=buildings">{$LNG.lm_buildings}</a></div>{/if}

		{if isModuleAvailable($smarty.const.MODULE_RESEARCH)}<div><a href="game.php?page=research">{$LNG.lm_research}</a></div>{/if}
		{if isModuleAvailable($smarty.const.MODULE_SHIPYARD_FLEET)}<div><a href="game.php?page=shipyard&amp;mode=fleet">{$LNG.lm_shipshard}</a></div>{/if}
		{if isModuleAvailable($smarty.const.MODULE_SHIPYARD_DEFENSIVE)}<div><a href="game.php?page=shipyard&amp;mode=defense">{$LNG.lm_defenses}</a></div>{/if}
		{if isModuleAvailable($smarty.const.MODULE_FLEET_TRADER)}<div><a href="game.php?page=fleetDealer">{$LNG.lm_fleettrader}</a></div>{/if}
				<div><a href="game.php?page=trader"><b>Handlarz</b></a></div>

				<div><a href="game.php?page=fleetTable">Flota</a></div>

		{if isModuleAvailable($smarty.const.MODULE_TECHTREE)}<div><a href="game.php?page=techtree">{$LNG.lm_technology}</a></div>{/if}
		{if isModuleAvailable($smarty.const.MODULE_RESSOURCE_LIST)}<div><a href="game.php?page=resources">{$LNG.lm_resources}</a></div>{/if}
		{if isModuleAvailable($smarty.const.MODULE_GALAXY)}<div><a href="game.php?page=galaxy">{$LNG.lm_galaxy}</a></div>{/if}
				{if isModuleAvailable($smarty.const.MODULE_MESSAGES)}<div><a href="game.php?page=messages">{$LNG.lm_messages}{nocache}{if $new_message > 0}<span id="newmes"> (<span id="newmesnum">{$new_message}</span>)</span>{/if}{/nocache}</a></div>{/if}
		<div><a href="game.php?page=changelog"><font color=red><b>CHANGELOG</b></font></a></div>
		</td></tr>
		
		<tr style="display:none;" id="menut2"><b><center>Menu</center></b><td>
		<div class="menucat2-head"><b><center>Obserwatorium</center></b></div>
		
		{if isModuleAvailable($smarty.const.MODULE_ALLIANCE)}<div><a href="game.php?page=alliance&menu=2">{$LNG.lm_alliance}</a></div>{/if}
        {if !empty($hasBoard)}<div><a href="game.php?page=board&menu=2" target="forum">{$LNG.lm_forums}</a></div>{/if}
		{if isModuleAvailable($smarty.const.MODULE_STATISTICS)}<div><a href="game.php?page=statistics&menu=2">{$LNG.lm_statistics}</a></div>{/if}
		{if isModuleAvailable($smarty.const.MODULE_BATTLEHALL)}<div><a href="game.php?page=battleHall&menu=2">{$LNG.lm_topkb}</a></div>{/if}
		{if isModuleAvailable($smarty.const.MODULE_RECORDS)}<div><a href="game.php?page=records">Rekordy <font size=0.25 color=red>(NEW)</font></a></div>{/if}

		{if isModuleAvailable($smarty.const.MODULE_SEARCH)}<div><a href="game.php?page=search&menu=2">{$LNG.lm_search}</a></div>{/if}
		{if isModuleAvailable($smarty.const.MODULE_CHAT)}<div><a href="game.php?page=chat&menu=2">{$LNG.lm_chat}</a></div>{/if}
		{if isModuleAvailable($smarty.const.MODULE_SUPPORT)}<div><a href="game.php?page=ticket&menu=2"><b><font color=red>{$LNG.lm_support}</font></b></a></div>{/if}
		<div><a href="game.php?page=questions&menu=2">{$LNG.lm_faq}</a></div>
		{if isModuleAvailable($smarty.const.MODULE_BANLIST)}<div><a href="game.php?page=banList&menu=2">{$LNG.lm_banned}</a></div>{/if}
		<div><a href="index.php?page=rules&menu=2" target="rules">{$LNG.lm_rules}</a></div>
		{if isModuleAvailable($smarty.const.MODULE_SIMULATOR)}<div><a href="game.php?page=battleSimulator&menu=2">{$LNG.lm_battlesim}</a></div>{/if}
		</td></tr>
		
		<tr style="display:none;" id="menut3"><td>
		<div class="menucat3-head"><b><center>Nawigacja</center></b></div>
		

		{if isModuleAvailable($smarty.const.MODULE_NOTICE)}<div><a href="javascript:OpenPopup('?page=notes', 'notes', 720, 300);">{$LNG.lm_notes}</a></div>{/if}
		{if isModuleAvailable($smarty.const.MODULE_BUDDYLIST)}<div><a href="game.php?page=buddyList&menu=3">{$LNG.lm_buddylist}</a></div>{/if}
		
		<div><a href="game.php?page=settings&menu=3">{$LNG.lm_options}</a></div>
		<div><a href="game.php?page=logout&menu=3">{$LNG.lm_logout}</a></div>

		{if $authlevel > 0}<div><a href="./admin.php" style="color:lime">{$LNG.lm_administration} ({$VERSION})</a></div>{/if}
		
		<br />
		
		
		</td></tr></table>
		<div class="menu-footer"></div>
		
		<br />
		
		<form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_top">
<input type="hidden" name="cmd" value="_s-xclick" />
<input type="hidden" name="hosted_button_id" value="9AH4BLHM9S8Y8" />
<input type="image" src="https://www.paypalobjects.com/pl_PL/PL/i/btn/btn_donateCC_LG.gif" border="0" name="submit" title="PayPal - The safer, easier way to pay online!" alt="Donate with PayPal button" />
<img alt="" border="0" src="https://www.paypal.com/pl_PL/i/scr/pixel.gif" width="1" height="1" />
</form>

	</div>
	

</div>
<script>
{nocache}
{if isset($smarty.get.menu)}
var menulast = 'menut' + {$smarty.get.menu};
var obutt = document.getElementById('menut' + {$smarty.get.menu} + 'p');
{else}
var menulast = 'menut1';
var obutt = document.getElementById('menut1p');
{/if} 
{/nocache}
menusel(obutt,menulast);
attacken();
setInterval(attacken, 10000);
</script>