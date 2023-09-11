{block name="content"}
	<div class="container">
		<div class="row justify-content-center">
			<div class="col-12 col-md-5">
				<div class="card mt-3 p-4">
					<div class="card-body">
						<img class="img-fluid mb-3" src="styles/resources/img/logo-lg.png"/>
						<p class="text-muted">Wypełnij wszystkie pola</p>
						<form id="registerForm" method="post" action="index.php?page=register" data-action="index.php?page=register" novalidate>
							<input type="hidden" value="send" name="mode">
							<input type="hidden" value="{$externalAuth.account}" name="externalAuth[account]">
							<input type="hidden" value="{$externalAuth.method}" name="externalAuth[method]">
							<input type="hidden" value="{$referralData.id}" name="referralID">
							<div class="input-group mb-3{if count($universeSelect) == 1} d-none{/if}">
								<div class="input-group-prepend">
									<span class="input-group-text"><i class="fa fa-globe"></i></span>
								</div>
								<select name="uni" id="universe" class="changeAction form-control custom-select">{html_options options=$universeSelect selected=$UNI}</select>
							</div>
							{if !empty($externalAuth.account)}
								{if $facebookEnable}
									<div class="rowForm">
										<label>{$LNG.registerFacebookAccount}</label>
										<span class="text fbname">{$accountName}</span>
									</div>
								{/if}
							{elseif empty($referralData.id)}
								{if $facebookEnable}
									<div class="rowForm">
										<label>{$LNG.registerFacebookAccount}</label>
										<a href="#" data-href="index.php?page=externalAuth&method=facebook" class="fb_login"><img src="styles/resource/images/facebook/fb-connect-large.png" alt=""></a>
									</div>
								{/if}
							{/if}
							<div class="input-group mb-3">
								<div class="input-group-prepend">
									<span class="input-group-text"><i class="fa fa-user"></i></span>
								</div>
								<input name="username" id="username" aria-describedby="usernameHelp" type="text" class="form-control" placeholder="{$LNG.registerUsername}" required>
								<break></break>
								<small id="usernameHelp" class="form-text text-muted">{$LNG.registerUsernameDesc}</small>
							</div>
							<div class="input-group mb-3">
								<div class="input-group-prepend">
									<span class="input-group-text"><i class="fa fa-lock"></i></span>
								</div>
								<input name="password" id="password" aria-describedby="passwordHelp" type="password" class="form-control" placeholder="{$LNG.registerPassword}" required>
								<break></break>
								<div class="input-group mb-3">
								<div class="input-group-prepend">
									<span class="input-group-text"><i class="fa fa-lock"></i></span>
								</div><input name="passwordReplay" id="passwordReplay" aria-describedby="passwordHelp" type="password" class="form-control" placeholder="{$LNG.registerPasswordReplay}" required>

								<break></break>
								<small id="passwordHelp" class="d-flex form-text text-muted">{$LNG.registerPasswordDesc}</small>
							</div>
							<div class="input-group mb-3">
								<div class="input-group-prepend">
									<span class="input-group-text"><i class="fa fa-envelope"></i></span>
								</div>
								<input name="email" id="email" type="email" class="form-control" placeholder="{$LNG.registerEmail}" required>
							</div>
							<div class="input-group mb-3">
								<div class="input-group-prepend">
									<span class="input-group-text"><i class="fa fa-envelope"></i></span>
								</div>
								<input name="emailReplay" id="emailReplay" type="email" class="form-control" placeholder="{$LNG.registerEmailReplay}" required>
							</div>
							{if count($languages) > 1}
								<div class="input-group mb-3 d-none">
									<div class="input-group-prepend">
										<span class="input-group-text"><i class="fa fa-language"></i></span>
									</div>
									<select name="lang" id="language" class="form-control">{html_options options=$languages selected=$lang}</select>
								</div>
							{/if}
							{if !empty($referralData.name)}
								<div class="input-group mb-3">
									<span class="align-middle">{$LNG.registerReferral}{$referralData.name}</span>
								</div>
							{/if}
							{if $recaptchaEnable}
								<div class="rowForm" id="captchaRow">
									<div>
										<label>{$LNG.registerCaptcha}</label>
										<!--<span class="form-text text-muted">{$LNG.registerCaptchaDesc}</span>-->
										<div class="g-recaptcha" data-sitekey="{$recaptchaPublicKey}"></div>
									</div>
								</div>
							{/if}
							<div class="input-group mb-3">
								<input type="checkbox" name="rules" id="rules" class="mr-1" value="1" required>
								<span>{$registerRulesDesc} <a href='#' onclick='rules()' data-toggle='modal' data-target='#rulesModal'>{$LNG['menu_rules']}</a></span>
							</div>
							<div class="row">
								<div class="col-6">
								<button id="btnRegister" type="submit" class="btn btn-block btn-primary px-4">{$LNG.buttonRegister}</button>
								</div>
								<div class="col-6">
									<a href="javascript:window.history.back()" class="btn btn-block btn-primary px-4">{$LNG.registerBack}</a>
								</div>
							</div>
						</form>
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

