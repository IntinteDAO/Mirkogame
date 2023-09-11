{block name="title" prepend}{$LNG.siteTitleIndex}{/block}
{block name="content"}
	<div class="container">
		<div class="row justify-content-center">
			<div class="col-12 col-md-10">
				<div class="card-group mt-3 mt-md-0">
					<div class="card card-main p-4 w-md-50">
						<div class="card-body">
							<img class="img-fluid mb-3" src="styles/resources/img/logo-lg.png"/>
							<p class="text-muted">{$LNG.loginHeader}</p>
							<form id="login" name="login" action="index.php?page=login" method="post">
								<div class="input-group mb-2 {if count($universeSelect) == 1} d-none{/if}">
									<div class="input-group-prepend">
										<span class="input-group-text"><i class="fa fa-globe"></i></span>
									</div>
									<select name="uni" id="universe" class="changeAction form-control">{html_options options=$universeSelect selected=$UNI}</select>
								</div>
								<div class="input-group mb-2">
									<div class="input-group-prepend">
										<span class="input-group-text"><i class="fa fa-user"></i></span>
									</div>
									<input name="username" id="username" type="text" class="form-control" placeholder="{$LNG.loginUsername}" autocomplete="username" {nocache}{if isset($smarty.get.username)}value="{$smarty.get.username}"{/if}{/nocache}>
								</div>
								<div class="input-group mb-2">
									<div class="input-group-prepend">
										<span class="input-group-text"><i class="fa fa-lock"></i></span>
									</div>
									<input name="password" id="password" type="password" class="form-control" placeholder="{$LNG.loginPassword}" autocomplete="off">
									<div class="input-group-append">
										<button type="button" onclick="togglePassword()" class="btn btn-warning"><i id="unmask" class="fa fa-eye"></i></button>
									</div>
								</div>
								<!--
								<div class="input-group mb-3 text-right">
									<div class="form-check form-check-inline">
										<input class="form-check-input" type="checkbox" id="rememberme" name="rememberme[]" value="remeberme">
										<label class="form-check-label" for="rememberme">Remember me on this computer</label>
									</div>
								</div>
								-->
								<div class="row">
									{if $mailEnable}
										<div class="col-6">
											<button id="btnlogin" type="submit" class="btn btn-primary px-4">{$LNG.loginButton}</button>
										</div>
									
									{else}
										<div class="col-12">
											<button id="btnlogin" type="submit" class="btn btn-primary px-4">{$LNG.loginButton}</button>
										</div>
									{/if}
								</div>
							</form>
							
							{$LNG['loginInfo']} <a href='#' onclick='rules()' data-toggle='modal' data-target='#rulesModal'>{$LNG['menu_rules']}</a>
							{if $facebookEnable}<a href="#" data-href="index.php?page=externalAuth&method=facebook" class="fb_login"><img src="styles/resource/images/facebook/fb-connect-large.png" alt=""></a><!-- http://b.static.ak.fbcdn.net/rsrc.php/zB6N8/hash/4li2k73z.gif -->{/if}
						</div>
					</div>
					<div class="card card-special border-0 text-white py-5 w-md-50">
						<div class="card-body text-center">
							<div>
								<h2>Szybka rejestracja</h2>
								<p class="desc">{$descText}</p>
								<p class="desc">{foreach $gameInformations as $info}<p>{$info}</p>{/foreach}</p>
								<a href="index.php?page=register" class="btn btn-primary active mt-3">{$LNG.buttonRegister}</a>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="modal fade" id="rulesModal" tabindex="-1" role="dialog" aria-labelledby="rulesModal" style="display: none;" aria-hidden="true">
		<div class="modal-dialog modal-primary modal-lg" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">{$LNG.registerRules}</h4>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">×</span>
					</button>
				</div>
				<div id="rulesModalBody" class="modal-body"><ul id="rules">
	<li>
		<h1>1. Konto</h1>
		<p>Każdy gracz może mieć tylko jedno konto. Dozwolone jest by ktoś zastąpił Cię podczas gry logując się na twoje konto. Ale podając dane dostępowe do twojego konta możesz je stracić. Podczas gdy ktoś Cię zastępuje, nie może ta osoba wysyłać ataków. Natomiast może budować jednostki, jak i nowe budynki. Może również uciekać flotą przed atakami(fleetsave).
Wykrycie dwóch kont na tym samym ip będzie skutkowało banem, więc jeśli prosisz o zastępstwo innego gracza, poinformuj administrację w celu uniknięcia przykrych konsekwencji.
.
	</p>
	</li>
	<li>
		<h1>2. Konto zasępstwo</h1>
		<p>Nim ktoś Cię zastąpi podczas gry powinieneś uprzedzić o tym admina, podając czas zastępstwa, który jednak nie powinien przekraczać 24h, w innym wypadku, jeśli czas twojej nieobecności jest dłuższy, zaleca się aktywowanie trybu Urlop w panelu opcji.</p>
	</li>
	<li>
		<h1>3. Pushing</h1>
		<p>Jest w żadnym wypadku niedozwolony, do Pushingu zalicza się: - atak na gracza słabszą flotą,(powtarzany często w krótkim okresie czasu), a potem zbieranie złomu - wymiana handlowa nie trzymająca się ustalonego kursu wymiany, wszelkie próby przekazania surowców przez słabsze konto na rzecz silnego. Wykrycie takiego działania będzie skutkowało zawróceniem/zawieszeniem floty, ostrzeżeniem i/lub banem.</p>
	</li>
	<li>
		<h1>4. Bashing</h1>
		<p>Nie możesz atakować jednej planety więcej niż 6x w ciągu 24h </p>
		<p>
W przypadku wojny wymagane jest przed jej rozpoczęciem ustalenie jej warunków między administracją a liderami sojuszy.
</p>
	</li>
	<li>
		<h1>5. Atak rakietami</h1>
		<p>Na 24h jedną planetę możesz zaatakować maksymalnie 1000 rakiet </p>
	</li>
	<li>
		<h1>6. Bugusing</h1>
		<p>Używanie w jakikolwiek sposób znalezionego bugu jest absolutnie zabronione. Każdy bug należy natychmiast zgłosić! Inaczej narażasz się na bana. Za zgłoszenie poważnych błędów przewidziane są drobne upominki nie wpływające na rozgrywkę.</p>
	</li>
	<li>
		<h1>7. Język w grze</h1>
		<p>W całej grze oficjalnym językiem jest Polski. Natomiast można używać 2 dodatkowych języków czyli niemieckiego i angielskiego o ile istnieje taka potrzeba.</p>
	</li>
	<li>
		<h1>8. Boty</h1>
		<p>Korzystanie z botów, skryptów, macro, clickerów, hinduskich informatyków i innych dziwnych pomocy automatyzujących grę surowo zakazane</p>
	</li>
	<li>
		<h1>9. Poza grą</h1>
		<p>Pamiętaj to tylko gra, przenoszenie emocji do świata realnego, czy to poprzez czat, czy forum, jakiekolwiek groźby, wyzywanie itp .. itd... jest niedozwolone. Kultura przede wszystkim, nie psuj zabawy innym swoim chamskim zachowaniem !
	</p>
	</li>
	<li>
		<h1>10. Spam</h1>
		<p>Spamowanie zabronione obojętnie w jakiej formie np : - czat - forum - prywatne wiadomości Ktoś cię spamuje, daj znać adminowi lub wyślij ticket!</p>
	</li>


<li>
		<h1>11. Kontakt</h1>
		<p>Jeśli chcesz skontaktować się z administracją możesz użyć do tego celu kanałów na Discordzie lub Pomocy Technicznej w grze. </p>
	</li>



<li>
		<h1>12. Handel</h1>
		<p>Handel między graczami musi zostać rozpoczęty maksymalnie w ciągu godziny od wylotu pierwszego statku z surowcami do drugiego gracza (gdy gracz A wyśle statek z surowcami to gracz B ma godzinę aby odesłać surowce zgodnie z ogólnie przyjętym przelicznikiem 3:2:1) Każda próba zawrócenia statku, oszukania, lub robienia w chuja która zostanie wykryta w logach będzie skutkowała banem.</p>
	</li>

<li>
		<h1>13. Administracja</h1>
		<p>Administracja ma zazwyczaj rację, obrażanie administracji będzie skutkowało banem. Jeśli masz propozycje odnośnie zmian to napisz je w takiej formie która będzie przejrzysta i zrozumiała. Pamiętaj że to mały projekt i wylewanie szamba na ludzi go tworzących nic nie pomoże. 
</p>
	</li>



</ul></div>
			</div>
		</div>
	</div>
{/block}
{block name="script" append}
<script>{if $code}toastr["error"]({$code|json}, "{$LNG.toastr_error}");{/if}</script>
{/block}