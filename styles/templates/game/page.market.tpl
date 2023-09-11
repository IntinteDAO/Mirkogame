{block name="title" prepend}Market{/block}
{block name="content"}


<style>
/* TABS */
.accordion-tabs {
padding: 0px 20px; /* Убираем отступы */
    width: auto;
    border: 1px solid #0c1114;
    border-radius: 0.1875em;
    margin-bottom: 1.5em;
    margin-left:0;
    padding-left:0;

}
    .accordion-tabs:before,
    .accordion-tabs:after {
        content: " ";
        display: table;
    }
    .accordion-tabs:after {
        clear: both;
    }
        .accordion-tabs li{
            list-style:none;
        }
            .accordion-tabs li.tab-head-cont:first-child a {
                border-top-left-radius: 0.1875em;
                border-top-right-radius: 0.1875em;
                border-top: 0;
            }
            .accordion-tabs li.tab-head-cont:last-child a {
                border-bottom-left-radius: 0.1875em;
                border-bottom-right-radius: 0.1875em;
            }
            .accordion-tabs li.tab-head-cont a {
                text-decoration:none;
                border-top: 1px solid rgba(68,68,68,0.1);
                color: #ffffff;
                display: block;
                padding: 0.75em 0.809em;
            }
            .accordion-tabs li.tab-head-cont a:hover {
                color: #ffffff;
            }
            .accordion-tabs li.tab-head-cont a:focus {
                outline: none;
            }
            .accordion-tabs li.tab-head-cont a.is-active {
                background-color: #2b4053;
                border-bottom: 0;
                color:#ffffff;
            }
        .accordion-tabs li.tab-head-cont section {
            padding: 1.5em 1.618em;
            background: #2b4053;
            display: none;
            overflow: hidden;
            width: 100%;
        }
/* RESPONSIVE */
@media screen and (min-width: 40em) {
    .accordion-tabs {
        border: none;
        position: relative;
    }
        .accordion-tabs li.tab-head-cont {
            display: inline;
        }
            .accordion-tabs li.tab-head-cont:last-child a {
                border-bottom-left-radius: 0;
                border-bottom-right-radius: 0;
            }
            .accordion-tabs li.tab-head-cont a {
                display: inline-block;
                vertical-align: baseline;
                zoom: 1;
                *display: inline;
                *vertical-align: auto;
                border-top: 0;
                border-top-right-radius: 0.1875em;
                border-top-left-radius: 0.1875em;
            }
            .accordion-tabs li.tab-head-cont a.is-active {
                background-color: #2b4053;
                border: 1px solid #2b4053;
                border-bottom: 1px solid #2b4053;
                margin-bottom: -1px;
            }
            .accordion-tabs li.tab-head-cont section {
                border-bottom-left-radius: 0.1875em;
                border-bottom-right-radius: 0.1875em;
                border: 1px solid #2b4053;
                float: left;
                left: 0;
                padding: 0.75em 0.809em;
            }
                .accordion-tabs li.tab-head-cont section p {
                    -webkit-columns: 1;
                    -moz-columns: 1;
                    columns: 1;
                }

</style>


<table class="table519">
	<tbody>

	<tr>
		<td class="left">
			<ul class="accordion-tabs">
				<li class="tab-head-cont">
					<a href="#" class="is-active">Лоты на рынке</a>
					<section>
						<table style="width:100%;">
						<tbody>			
							<th>Лот:</th>
							<th>Data:</th>
							<th>Koszt:</th>
							<th></th>
						{foreach $market as $row} 				
						<tr>				
							<td>{$row.lot}</td>
							<td>{$row.time}</td>
							<td>{$row.price|number} ТМ</td>
							<td><a href="?page=market&mode=sell&id={$row.id}">Купить</a></td>
						</tr>
						{/foreach}
						</tbody>
						</table>
					</section>
				</li>
				<li class="tab-head-cont">
					<a href="#">Выставить лот</a>
					<section>
					<table style="width:100%;">
					<form action="?page=market&mode=add" method="post">
						{foreach $lot as $row} 				
						<tr>				
							<td>{$LNG.tech.{$row.id}}:</td>
							<td>{$row.count|number}</td>
							<td>
							<input name="lot{$row.id}" size="10" value="0">
							</td>
						</tr>
						{/foreach}
						<tr>				
							<td>Цена в ТМ:</td>
							<td>
							<input name="price" id="price" size="10" value="0">
							</td>
							<td></td>
						</tr>
						<tr>
						<td colspan="3"><button type="submit">Продолжить</button>	</td>
						</tr>
					</form>	
					</table>	
					</section>
				</li>
				<li class="tab-head-cont">
					<a href="#">Ваши лоты</a>
					<section>
						<table style="width:100%;">
						<tbody>			
							<th>Лот:</th>
							<th>Дата:</th>
							<th></th>
						{foreach $u_lot as $row} 				
						<tr>				
							<td>{$row.lot}</td>
							<td>{$row.time}</td>
							<td>{if $row.time_off > $timestamp}-{else}<a href="?page=market&mode=cancel_lot&id={$row.id}">Снять лот</a>{/if}</td>
						</tr>
						{/foreach}
						</tbody>
						</table>
					</section>
				</li>
			</ul>
		</td>
	</tr>
</tbody></table>





<script> 
    $(document).ready(function () {
        $('.accordion-tabs').children('li').first().children('a').addClass('is-active')
              .next().addClass('is-open').show();
        $('.accordion-tabs').on('click', 'li > a', function(event) {
            if (!$(this).hasClass('is-active')) {
                event.preventDefault();
                $('.accordion-tabs .is-open').removeClass('is-open').hide();
                $(this).next().toggleClass('is-open').toggle();
                $('.accordion-tabs').find('.is-active').removeClass('is-active');
                $(this).addClass('is-active');
            } else {
                event.preventDefault();
            }
        });
    });
</script> 

{/block}