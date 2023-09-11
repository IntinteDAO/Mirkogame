<?php

setlocale(LC_ALL, 'zh_CN', 'chs'); // http://msdn.microsoft.com/en-us/library/39cwe7zf%28vs.71%29.aspx
setlocale(LC_NUMERIC, 'C');

//SERVER GENERALS
$LNG['dir']         	= 'ltr';
$LNG['week_day']		= array('星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'); # Start with Sun!
$LNG['months']			= array('1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月');
$LNG['js_tdformat']		= '[Y]年[M][d]日 [H]:[i]:[s]';//[D] 
$LNG['php_timeformat']	= 'H:i:s';
$LNG['php_dateformat']	= 'Y年Md日';
$LNG['php_tdformat']	= 'Y年Md日 H:i:s';
$LNG['short_day']		= 'd';
$LNG['short_hour']		= 'h';
$LNG['short_minute']	= 'm';
$LNG['short_second']	= 's';

//Note for the translators, use the phpBB Translation file (LANG/common.php) instead of your own translations

$LNG['timezones'] = array(
	'-12'	=> '[UTC - 12] 贝克岛时间',
	'-11'	=> '[UTC - 11] 纽埃岛[南太平洋中部]时间, 萨摩亚群岛[南太平洋]标准时间',
	'-10'	=> '[UTC - 10] 夏威夷-阿留申标准时, 库克岛的时间',
	'-9.5'	=> '[UTC - 9:30] 马克萨斯群岛[南太平洋]时间',
	'-9'	=> '[UTC - 9] 阿拉斯加时间, 甘岛时间',
	'-8'	=> '[UTC - 8] 太平洋标准时间',
	'-7'	=> '[UTC - 7] 山区标准时间',
	'-6'	=> '[UTC - 6] 美国中部标准时间',
	'-5'	=> '[UTC - 5] 美国东部标准时间',
	'-4.5'	=> '[UTC - 4:30] 委内瑞拉标准时间',
	'-4'	=> '[UTC - 4] 大西洋标准时间',
	'-3.5'	=> '[UTC - 3:30] 纽芬兰标准时间',
	'-3'	=> '[UTC - 3] 亚马逊标准时间, 中部格陵兰时间',
	'-2'	=> '[UTC - 2] 费尔南多迪诺罗尼亚时间, 南乔治亚岛和南桑威奇岛的时间',
	'-1'	=> '[UTC - 1] 亚述尔群岛标准时间, 佛得角时间, 格陵兰东部时间',
	'0'	    => '[UTC] 欧洲西部时间, 格林威治标准时间',
	'1'	    => '[UTC + 1] 欧洲中部时间, 非洲西部时间',
	'2'	    => '[UTC + 2] 欧洲东部时间, 非洲中部时间',
	'3'	    => '[UTC + 3] 莫斯科标准时间, 非洲东部时间',
	'3.5'	=> '[UTC + 3:30] 伊朗标准时间',
	'4'	    => '[UTC + 4] 海湾标准时间, 波斯湾标准时间, 萨马拉标准时间',
	'4.5'	=> '[UTC + 4:30] 阿富汗时间',
	'5'	    => '[UTC + 5] 巴基斯坦标准时间, 叶卡捷琳堡标准时间',
	'5.5'	=> '[UTC + 5:30] 印度标准时间, 斯里兰卡时间',
	'5.75'  => '[UTC + 5:45] 尼泊尔时间',
	'6'	    => '[UTC + 6] 孟加拉时间, 不丹时间, 新西伯利亚(诺沃西比尔斯克)标准时间',
	'6.5'	=> '[UTC + 6:30] 可可斯群岛时间, 缅甸时间',
	'7'	    => '[UTC + 7] 印度支那时间, 克拉斯诺亚尔斯克标准时间',
	'8'	    => '[UTC + 8] 中国标准时间, 澳洲西部标准时间, 伊尔库次克标准时间',
	'8.75'  => '[UTC + 8:45] 澳洲西部东南标准时间',
	'9'	    => '[UTC + 9] 日本标准时间, 韩国标准时间, 赤塔[俄罗斯西伯利亚南部城市]标准时间',
	'9.5'	=> '[UTC + 9:30] 澳洲中部标准时间',
	'10'	=> '[UTC + 10] 澳洲东部标准时间, 海参崴标准时间',
	'10.5'  => '[UTC + 10:30] 贺维标准时间',
	'11'	=> '[UTC + 11] 所罗门群岛时间, 马加丹标准时间',
	'11.5'  => '[UTC + 11:30] 诺福克群岛时间',
	'12'	=> '[UTC + 12] 新西兰时间, 斐济时间, 堪察加半岛[俄罗斯东北部]标准时间',
	'12.75' => '[UTC + 12:45] 查塔姆群岛[新西兰东部]时间',
	'13'	=> '[UTC + 13] 汤加时间, 菲尼克斯群岛时间',
	'14'	=> '[UTC + 14] 路线岛时间',
);