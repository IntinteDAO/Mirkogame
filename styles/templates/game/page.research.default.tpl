{block name="title" prepend}{$LNG.lm_research}{/block}
{block name="content"}

<table style="    background: rgba(30, 35, 55, 0.95);
    color: #FFF;
    font-weight: 700;
	width:760px;
    text-align: left;">
	<tbody><tr>
		<th colspan="3">
			<b> Badania</B> <div onclick="location.href = 'game.php?lista_b=1&page=research'" style="cursor: pointer;float: right;
    padding: 8px;
    background: #0e8a2" >{if {$szablon}==1}Lista{else}Etykiety{/if}</div></th>
	</tr>
	</table>



{if !empty($Queue)}
<div id="buildlist" class="buildlist">
	<table style="width:760px">
		{foreach $Queue as $List}
		{$ID = $List.element}
		<tr>
			<td style="width:70%;vertical-align:top;" class="left">
				{if isset($ResearchList[$List.element])}
				{$CQueue = $ResearchList[$List.element]}
				{/if}
				{$List@iteration}.: 
				{if isset($CQueue) && $CQueue.maxLevel != $CQueue.level && !$IsFullQueue && $CQueue.buyable}
				{$LNG.tech.{$ID}} {$List.level}{if !empty($List.planet)} @ {$List.planet}{/if}
				{else}
				{$LNG.tech.{$ID}} {$List.level}{if !empty($List.planet)} @ {$List.planet}{/if}
				{/if}
				{if $List@first}
				<br><br><div id="progressbar" data-time="{$List.resttime}"></div>
			</td>
			<td>
				<div id="time" data-time="{$List.time}"><br></div>
				<form action="game.php?page=research" method="post" class="build_form">
					<input type="hidden" name="cmd" value="cancel">
					<button type="submit" class="build_submit onlist">{$LNG.bd_cancel}</button>
				</form>
				{else}
			</td>
			<td>
				<form action="game.php?page=research" method="post" class="build_form">
					<input type="hidden" name="cmd" value="remove">
					<input type="hidden" name="listid" value="{$List@iteration}">
					<button type="submit" class="build_submit onlist">{$LNG.bd_cancel}</button>
				</form>
				{/if}
				<br><span style="color:lime" data-time="{$List.endtime}" class="timer">{$List.display}</span>
			</td>
		</tr>
	{/foreach}
	</table>
</div>
{/if}
{if $IsLabinBuild}<table width="70%" id="infobox" style="border: 2px solid red; text-align:center;background:transparent"><tr><td>{$LNG.bd_building_lab}</td></tr></table><br><br>{/if}

{if {$szablon} == 1}

{foreach $ResearchList as $ID => $Element}
	<div class="floatbox">
		<div class="floatboxpic" onclick="return Dialog.info({$ID})" style="background:url('{$dpath}gebaeude/{$ID}.gif'); background-size:100% 100%;"><div class="fbtext" ><a class="tooltip" data-tooltip-content="<div style='max-width:200px;'>{$LNG.shortDescription.{$ID}|replace:'"':'\''}<br><br>						{$LNG.bd_remaining|replace:'"':'\''}<br>
						{foreach $Element.costOverflow as $ResType => $ResCount}
						{$LNG.tech.{$ResType}|replace:'"':'\''}: <span style='font-weight:700'>{$ResCount|number}</span><br>
						{/foreach} <br>{$Element.start}</div>" style="font-weight:bold; font-size:1.1em;" href="#" onclick="return Dialog.info({$ID})">
		{$LNG.tech.{$ID}}</a>{if $Element.level != 0} ({$LNG.bd_lvl} {$Element.level}{if $Element.maxLevel != 255}/{$Element.maxLevel}{/if}){/if}</a></div></div>

		<div>{$LNG.fgf_time}:<span style="float:right;">{$Element.elementTime|time}</span></div>
			<div class="costoverflow" >
					<span>{foreach $Element.costResources as $RessID => $RessAmount}
					<b><span style="color:{if $Element.costOverflow[$RessID] == 0}lime{else}red{/if}">{$RessAmount|number}</span></b> <img src="{$dpath}images/{$RessID}.gif" alt="{$LNG.tech.{$RessID}}" width="20" height="20"><br>
					{/foreach}</span>
					</div>

					
	<div class="submitdiv" style="
					{if $Element.maxLevel == $Element.levelToBuild}
						 background:red;"><span class="wi">{$LNG.bd_maxlevel}</span>
						 {elseif $IsLabinBuild || $IsFullQueue || !$Element.buyable}
						background:red;"><span class="wi">{if $Element.level == 0}{$LNG.bd_tech}{else}{$LNG.bd_tech_next_level}{$Element.levelToBuild + 1}{/if}</span>
					{else}
						background:green;">						<form action="game.php?page=research" method="post" class="build_form">
							<input type="hidden" name="cmd" value="insert">
							<input type="hidden" name="tech" value="{$ID}">
								<button type="submit" class="build_submit_green">{if $Element.level == 0}{$LNG.bd_tech}{else}{$LNG.bd_tech_next_level}{$Element.levelToBuild + 1}{/if}</button>
							</form>
							
					{/if}
										
</div>
	</div>
					
					
			
	
					
					
			
	
	{/foreach}



{else}




<table style="width:760px">
	{foreach $ResearchList as $ID => $Element}
	<tr>
		<td rowspan="2" style="width:120px;">
			<a href="#" onclick="return Dialog.info({$ID})">
				<img src="{$dpath}gebaeude/{$ID}.gif" alt="" class="top" width="120" height="120">
			</a>
		</td>
		<th>
			<a href="#" onclick="return Dialog.info({$ID})">{$LNG.tech.{$ID}}</a>{if $Element.level != 0} ({$LNG.bd_lvl} {$Element.level}{if $Element.maxLevel != 255}/{$Element.maxLevel}{/if}){/if}
		</th>
	</tr>
	<tr>
		<td>
			<table style="width:100%">
				<tr>
					<td class="transparent left" style=";padding:10px;"><p>{$LNG.shortDescription.{$ID}}</p>
					<p>{foreach $Element.costResources as $RessID => $RessAmount}
					{$LNG.tech.{$RessID}}: <b><span style="color:{if $Element.costOverflow[$RessID] == 0}lime{else}red{/if}">{$RessAmount|number}</span></b>
					{/foreach}<br>Czas badania:{$Element.elementTime|time}</p></td>
					<td class="transparent" style="vertical-align:middle;width:100px">
					{if $Element.maxLevel == $Element.levelToBuild}
						<span style="color:red">{$LNG.bd_maxlevel}</span>
					{elseif $IsLabinBuild || $IsFullQueue || !$Element.buyable}
						<span style="color:red">{$Element.start}</span>
					{else}
						<form action="game.php?page=research" method="post" class="build_form">
							<input type="hidden" name="cmd" value="insert">
							<input type="hidden" name="tech" value="{$ID}">
							<button type="submit" class="build_submit">{$Element.start}</button>
						</form>
					{/if}
					</td>
				</tr>
			</table>
		</td>
	</tr>

	{/foreach}
</table>
{/if}
{/block}
{block name="script" append}
    {if !empty($Queue)}
        <script src="scripts/game/research.js"></script>
    {/if}
{/block}
