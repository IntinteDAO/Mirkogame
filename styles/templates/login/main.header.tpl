<!DOCTYPE html>
<html lang="{$lang}">

	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
		<meta name="description" content="{$gameName} - Przeglądarkowa gra Ogame bez pay2win. Witaj na MirkOgame.pl - Jest to prywatny serwer kultowej gry przeglądarkowej Ogame. Naszym celem jest utrzymanie gry bez Pay2Win oraz zachowanie stylu starego poczciwego Ogame. Wersja gry jest dostsowana do mobilnych urządzeń - bardzo dobrze wyświetla się na ekranach telefonów komórkowych. Zapraszamy do gry.

Dołącz do nas :-)">
		<meta name="keywords" content="ogame, darmowe, bez pay2win, kosmosie, multiplayer, android, wykop, mirkogame">
		<meta name="theme-color" content="#252831"/>
		<meta name="generator" content="2Moons {$VERSION}">
		<!--
			This website is powered by 2Moons {$VERSION}
			2Moons is a free Space Browsergame initially created by Jan Kröpke and licensed under GNU/GPL.
			2Moons is copyright 2009-2013 of Jan Kröpke. Extensions are copyright of their respective owners.
			Information and contribution at http://2moons.cc/
		-->
	<link rel="manifest" href="/domains/mirkogame.pl/public_html/styles/templates/login/manifest.json">

		<title>{block name="title"} - {$gameName}{/block}</title>

		<!-- Main styles for this application -->
		<link href="./styles/resources/css/style.min.css" rel="stylesheet">
		<link href="https://cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.0.6/cookieconsent.min.css" rel="stylesheet">
		<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
		<link href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/2.1.4/toastr.min.css" rel="stylesheet">
		<link href="./styles/resources/css/login.css" rel="stylesheet">
	</head>

	<body id="{$smarty.get.page|htmlspecialchars|default:'overview'}" class="{$bodyclass} app flex-row align-items-center">