{include file="overall_header.tpl"}
<table width=512>
<tr>
	<th>{$log_id}</th>
	<th>{$log_owner_user}</th>
	<th>{$log_owner_ally}</th>
	<th>{$log_target}</th>
	<th>{$log_target_ally}</th>
	<th>{$log_res}</th>
	<th>{$log_time}</th>
	<th>{$log_uni}</th>
</tr>
{foreach item=LogInfo from=$LogArray}
<tr>
	<td>{$LogInfo.id}</td>
	<td>{$LogInfo.admin}</td>
	<td>{$LogInfo.admin_ally}</td>
	<td>{$LogInfo.target}</td>
	<td>{$LogInfo.target_ally}</td>
	<td>
		<div style="width: 200px;">{$log_m}: {$LogInfo.res.metal}</div>
		<div style="width: 200px;">{$log_c}: {$LogInfo.res.crystal}</div>
		<div style="width: 200px;">{$log_d}: {$LogInfo.res.deuterium}</div>
	</td>
	<td>{$LogInfo.time}</td>
	<td>{$LogInfo.target_uni}</td>
</tr>
{/foreach}
</table>
</body>
{include file="overall_footer.tpl"}