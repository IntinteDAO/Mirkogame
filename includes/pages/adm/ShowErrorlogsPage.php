<?php
if (!allowedTo(str_replace(array(dirname(__FILE__), '\\', '/', '.php'), '', __FILE__))) throw new Exception("Permission error!");
function ShowErrorlogsPage()
{
  echo '<style>
td{
   border:.2vw solid #666;
   color: #f90;
font-family: Verdana;
background:black;
}
body{
  background:rgb(33, 37, 43);
}
div{
  color:#f90;
cursor:pointer;
max-width: 97vw;
}
  </style><table style="word-wrap: break-word;"><tr><td>errorlogs</td></tr><tr><td>';
  $file = file('./includes/error.log');
$file = $file;
$output = array();
$count = 0;
foreach($file as $f){
  if(strpos($f,'{main}') !== false){
	$output[$count] =  $output[$count] . $f .  "</div></td></tr><tr><td>";
	$count++;
	$output[$count] = '<div onclick="document.getElementById(\'f' . $count. '\').style.display = \'block\';">';
  }else{
	if($output[$count] === '<div onclick="document.getElementById(\'f' . $count. '\').style.display = \'block\';">'){
	$output[$count] .= $count . ".".$f."</div><div id='f" . $count . "' style='display:none; color:#fff'; onclick=\"this.style.display = 'none';\"><hr>";
	}else{
	$output[$count] .= $f."<br />";
	}
}
}
$output = array_reverse($output);
echo implode($output);
echo '</td></tr></table>';
}