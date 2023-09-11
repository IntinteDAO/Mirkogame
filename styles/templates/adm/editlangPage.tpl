{if $pfad === ''}{include file="overall_header.tpl"}

<style>
	.jut {
		position: absolute;
		border-radius: 6px;
		max-width: 30%;
		border: 1px solid #000;
		z-index: 5;
		top: 47px;
		left: 10%;
		color: #000;
		background: lightgreen;
	}
	.jut div {
		position: absolute;
		top: -5px;
		right: -5px;
		cursor: pointer;
		color: #fff;
		font-weigh: bold;
		width: 20px;
		height: 20px;
		border: 1px solid #000;
		background: red;
	}
	.nichjut {
		position: absolute;
		border-radius: 6px;
		border: 1px solid #000;
		z-index: 5;
		top: 47px;
		left: 10%;
		color: #000;
		background: #f66;
		max-width: 30%;
	}
	.nichjut div {
		position: absolute;
		top: -5px;
		right: -5px;
		cursor: pointer;
		color: #fff;
		font-weigh: bold;
		width: 20px;
		height: 20px;
		border: 1px solid #000;
		background: red;
	}
	div table {
		margin: 0 auto;
	}
	.tooltip:hover .tooltiptext {
		visibility: visible;
		opacity: 1;
	}
	td {
		vertical-align: top;
		background: none;
		border: 0;
	}
	#tabse div {
		margin-right: 3px;
		font-size: 14px;
		padding: 0 2px;
		display: inline;
		background: rgb(209, 59, 46);
		cursor: pointer;
	}
	#tabse div:hover {
		background: rgb(43, 161, 67);
	}
	#tabse {
		width: 100%;
		text-align: center;
	}
	.active {
		background: rgb(43, 161, 67) !important;
	}
a:hover{
	background: rgb(43, 161, 67);
	color:white;
}
	body {
		background: rgba(23, 26, 30, 0.95);
		color: #aaa;
		font-family: verdana;
		width: 100%;
		{
			if $pfad === ''
		}
		overflow: hidden;
		{
			else
		}
		overflow-y: scroll;
		{
			/if
		}
	}




	table td {
		background: rgba(23, 26, 30, 0.95);
		border: 1px solid #000;
		color: #aaa;
		font-weight: bold;
	}
	textarea {
		width: 100%;
		background: #66aa66;
		border: 0;
		text-align: left;
		color: #aaa;
		font-weight: bold;
		font-family: verdana;
	}
	select {
		width: 85px;
		font-family: verdana;
		background: rgba(23, 26, 30, 0.95);
		color: #aaa;
		font-weight: bold;
		border: 0;
	}
	input:read-only,
	textarea:read-only {
		background: rgba(23, 26, 30, 0.95);
		border: 0;
		color: #aaa;
		font-weight: bold;
		cursor: default;
		height: 14px;
		font-family: verdana;
	}
	input:-moz-read-only,
	textarea:-moz-read-only {
		/* For Firefox */
		background: rgba(23, 26, 30, 0.95);
		border: 0;
		color: #aaa;
		font-weight: bold;
		cursor: default;
		height: 14px;
		font-family: verdana;
		height: 21px;
	}
	.langtext {
		width: 100%;
		color: #fff;
		font-family: verdana;
	}
	div {
		text-align: center;
	}

	th {
    font-size: 16px;
}
	.plus {
		background: lightrgb(43, 161, 67);
		cursor: pointer;
		font-weight: bold;
		padding: 0 2px;
		border: 6px outset #141;
	}
	button[type=submit] {
		position: fixed;
		right: 50px;
		top: 125px;
	}
	textarea:hover {
		background: rgb(43, 161, 67);
	}
	.plus:hover {
		border: 6px inset #363;
		background: rgb(43, 161, 67);
		border: 6px inset #363;
		background: rgb(43, 161, 67);
	}
	#alles {
		display: none;
		overflow: hidden;
		width: 100%;
		position: relative;
	}
	#varstext td {
		text-align: right;
	}
	.t {
		width: 60%;
	}
</style>
<div id='alles'>
<div id="dummy"></div>
		<div id="tabse">

			{foreach $LNG1 as $key => $value} {if is_array($value)}

				<div onclick="httpGet(this); tabse(this);" data-href="admin.php?page=editlang&datei={if $pfad !== ''}{$datei}&absatz={$key}&frame={$frame}{else}{$key}{/if}&langa={$langa}">{$key}({$value|@count})</div>

			{/if} {/foreach} {if count($languages) > 1}
			<select name="language" id="language" onchange="spaend(this.value);">
				{foreach $languages as $langKey => $langName}
				<option name="{$langKey}" value="{$langKey}" {if $langa==={$langKey}}selected{/if}>{$langName}</option>
				{/foreach}
			</select><img src="styles\resource\images\login\flags\{if $langa === 'en'}gb{else}{$langa}{/if}.png">
			{/if}

		</div><br>



			<div id="fensterchen" name="fensterchen" style="overflow-y:scroll; border:0px; width:100%; height:calc(100vh - 67px);">
{$outseput}
			</div>

	</div>
	<script type="text/javascript">


 function stener(){
		document.body.addEventListener('keyup', function (e) {
			if (e.target.readOnly != true && e.target.tagName !== 'BODY') {
				e.target.style.background = "rgb(43, 161, 67)";
			} else {
				if (e.target.tagName !== 'BODY') {
					if (e.target.readOnly != true) {
						e.target.style.background = '#aaffaa';
					} else {
						e.target.style.background = 'none';
					}
				}
			}
		});
}
function sendform(formu){
var evt2 = new FormData(formu);
var http = new XMLHttpRequest();
var url = formu.getAttribute("action");
var params = evt2;
http.open("POST", url + '&ajax=1', true);
http.onreadystatechange = function() {
    if(http.readyState == 4 && http.status == 200) {
        document.getElementById("fensterchen").innerHTML += http.responseText;
    }
}
http.send(params);
return false;
}

		function httpGet(das) {
			var theUrl = das.getAttribute("data-href");
			var xmlHttp = new XMLHttpRequest();
			xmlHttp.onreadystatechange = function () {
				if (xmlHttp.readyState == 4 && xmlHttp.status == 200)
					document.getElementById('fensterchen').innerHTML = xmlHttp.responseText;
					stener();
				}
			xmlHttp.open("GET", theUrl + '&ajax=1', true); // true for asynchronous
			xmlHttp.send(null);
		}
var aclass = document.getElementById("dummy");
		function tabse(geklickt) {
			aclass.className = "inactiv";
			geklickt.className = "active";
			aclass = geklickt;
		}

		function spaend(das) {
			location.href = 'admin.php?page=editlang&frame={urlencode($frame)}&datei={$datei}&pfad={urlencode($pfad)}&langa=' + das;
		}
		document.getElementById('alles').style.display = "block";
	</script>
	{include file="overall_footer.tpl"}{else}

	<form onsubmit="return sendform(this);" action="admin.php?page=editlang&frame={urlencode($frame)}&datei={$datei}&pfad={urlencode($pfad)}&langa={$langa}" method="post">
		<input type="hidden" name="action" value="editlang">
		<div id="tabse">

			{foreach $LNG1 as $key => $value} {if is_array($value)}
			<a href="#" onclick="httpGet(this);" data-href="admin.php?page=editlang&datei={if $pfad !== ''}{$datei}&absatz={$key}&frame={$frame}{else}{$key}{/if}&langa={$langa}">
				<div>{$key}({$value|@count})</div>
			</a>
			{/if} {/foreach}

		</div><br>
		<div id="0tab" class="activetab">
			<table id="varstext" style="width:80%">
				<tr>
					<th colspan="2">edit <img src="styles\resource\images\login\flags\{if $langa === 'en'}gb{else}{$langa}{/if}.png">{$languages[$langa]} ({$pfad} -> $LNG{$frame})
					</th>

				</tr>
				{foreach $LNG1 as $key => $value}
				<tr>
					<td>{if is_array($value)}
						<a href="#" onclick="httpGet(this);" data-href="admin.php?page=editlang&datei={if $pfad !== ''}{$datei}&absatz={$key}&frame={$frame}{else}{$key}{/if}&langa={$langa}">
							<div>$LNG{$frame}['{$key}'] -> ({$value|@count})</div>
						</a>
						{else}$LNG{$frame}['{$key}']{/if}</td>
					<td class="t">
						<textarea class="langtext" {if is_array($value)}readonly{/if} name="{$key}">{if !is_array($value)}{htmlentities($value)}{else}{$value}{/if}</textarea>
					</td>
				</tr>
				{/foreach}
				<tr>
					<td colspan="2"><input type="submit" value="{$LNG.du_submit}"><button class="plus" type="submit" value="{$LNG.du_submit}">{$LNG.du_submit}</button></td>
				</tr>
			</table>
		</form>
		{/if}
