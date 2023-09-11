<?php

/**
 *  2Moons
 *   by Jan-Otto Kr�pke 2009-2016
 *
 * For the full copyright and license information, please view the LICENSE
 *
 * @package 2Moons
 * @author Jan-Otto Kr�pke <slaver7@gmail.com>
 * @copyright 2009 Lucky
 * @copyright 2016 Jan-Otto Kr�pke <slaver7@gmail.com>
 * @licence MIT
 * @version 1.8.0
 * @link https://github.com/jkroepke/2Moons
 * @inheritdoc show formulars for /language/ files
 */

if ($USER['authlevel'] == AUTH_USR) {
    throw new PagePermissionException("Permission error!");
}

function ShoweditlangPage()
{
    function copyFolder($source, $dest, &$statsCopyFolder, $recursive = false)
    {
        if (!is_dir($dest)) {
            mkdir($dest);
        }

        $handle = @opendir($source);

        if (!$handle) {
            return false;
        }

        while ($file = @readdir($handle)) {
            if (eregi("^\.{1,2}$", $file)) {
                continue;
            }

            if (!$recursive && $source != $source.$file."/") {
                if (is_dir($source.$file)) {
                    continue;
                }
            }

            if (is_dir($source.$file)) {
                copyFolder($source.$file."/", $dest.$file."/", $statsCopyFolder, $recursive);
            } else {
                copy($source.$file, $dest.$file);
                $statsCopyFolder['files']++;
                $statsCopyFolder['bytes'] += filesize($source.$file);
            }
        }

        @closedir($handle);
    }




    function zugriff()
    {
        $dateiname = 'public_html/index.php';
        // einfacher Verbindungsaufbau
        $conn_id = ftp_connect($ftp_server);
        // Login mit Benutzername und Passwort
        $login_result = ftp_login($conn_id, $ftp_username, $ftp_passwort);
        // Zugriffsrechte von $dateiname auf 644 ändern
        if (ftp_chmod($conn_id, 0644, $dateiname) !== false) {
            echo "Zugriffsrechte der Datei $dateiname auf 644 geändert\n";
        } else {
            echo "Änderung der Zugriffsrechte fehlgeschlagen\n";
        }
        // Verbindung schließen
        ftp_close($conn_id);
    }


    //if rquest lang is not given, take lang used in browser
    if (isset($_GET['langa'])) {
        $lang = $_GET['langa'];
    } else {
        $lang = $GLOBALS['LNG']->getLanguage();
    }
    //set langfile path depending on lang
    $pfad = 'language/' . $lang . '/';

    //$LNG -> array deth like ['bla']['1']
    if (isset($_GET['frame'])) {
        $frame = $_GET['frame'];
    } else {
        $frame='';
    }

    //output for userfeedback message and writing to files
    $outseput = '';
    if (isset($_POST['action'])) {
        try {
            $file = $_GET['datei'];

            include $pfad . $file . '.php';
            $LNG1 = eval('return $LNG' . $frame . ';');
            $outseput = '<div class="jut"><div onclick="this.parentNode.style = \'display:none;\'; document.getElementById(\'destyle\').innerHTML =\'\';">X</div>
         SUCCESSFUL CHANGED LANGUAGE<br>in ' .  $pfad . $file . '.php' . '<br>cache has been cleard<table>';
            foreach ($LNG1 as $key => $value) {
                if (isset($_POST[$key])) {
                    if ($_POST[$key] !== $value && is_array($value) === false) {
                        $LNG1[$key] = htmlentities($_POST[$key]);
                        eval('$LNG' . $frame . '[$key] = $_POST[$key];');
                        $outseput .=  '<tr><td>$LNG' . $frame . '[\''. $key . '\']</td><td><input value="' . $_POST[$key] . '" readonly ></td></tr>';
                    }
                }
            }
            $outseput .= '</table></div>';
            $schreib = "<?php
            ";
            foreach ($LNG as $key => $value) {
                if (is_array($value) !== false) {
                    $schreib .= '$LNG[\'' . $key . '\'] = ' . var_export($LNG[$key], true) . ';
  ';
                } else {
                    $schreib .= '$LNG[\'' . $key . '\'] = \'' . $value . '\';
  ';
                }
            }
            file_put_contents($pfad . $file . '.php', $schreib . ';');
            ClearCache();
        } catch (Exception $e) {
            $outseput = '<div class="nichjut"><div onclick="this.parentNode.style = \'display:none;\'; document.getElementById(\'destyle\').innerHTML =\'\';">X</div>
         CHANGE LANGUAGE FAILD!<table><tr><td style="font-size:10px;">' . $e->getMessage() . '</td></tr><tr><td style="word-break: break-all;">' . $e->getCode() . '<br>' . $e->getFile() . '<br>' . $e->getTraceAsString() . '</td></tr></table></div>';
            //$frame = '';
        }
        unset($LNG);
        echo $outseput;
    } else {



    //default script
        $LNG1 = array();
        $LNG    = array();
        $datei = '';
        if (isset($_GET['datei']) && $_GET['datei'] !== '') {// if a file is reqested load it
            include $pfad . $_GET['datei'] . '.php';
            $pfad = $pfad . $_GET['datei'] . '.php';
            $datei = $_GET['datei'];
        } else {//if no file is requestest load all files

            if (isset($_GET['backupd']) !== false) {
                $dir = 'includes/lngbackup/';
                $it = new RecursiveDirectoryIterator($dir, RecursiveDirectoryIterator::SKIP_DOTS);
                $files = new RecursiveIteratorIterator($it, RecursiveIteratorIterator::CHILD_FIRST);
                foreach ($files as $file) {
                    if ($file->isDir()) {
                        rmdir($file->getRealPath());
                    } else {
                        unlink($file->getRealPath());
                    }
                }
                rmdir($dir);
                $outseput .= 'old backup includes/lngbackup/ deleted.<br>';
            }
            if (isset($_GET['backupr']) !== false) {
                $statsCopyFolder['bytes'] = 0;
                $statsCopyFolder['files'] = 0;
                copyFolder('includes/lngbackup/', 'language/', $statsCopyFolder, true);
                $outseput .= 'files copied to (language/)<br> from backup (includes/lngbackup/)<br>files copied:'. $statsCopyFolder['files'] .' = ' . $statsCopyFolder['bytes'] . 'bytes<br>' . date("l jS \of F Y h:i:s A") . '<br><br>';
                unlink('language/date.txt');
            }
            if (is_dir('includes/lngbackup/') !== false) {//if not file is requested and if backup exists
                include 'includes/lngbackup/date.txt';
                $outseput .=  '&nbsp;lng backup exists: includes/lngbackup/<br>' . $ddate;
            } else {//if not file is requested and if backup not exists create it
                $statsCopyFolder['bytes'] = 0;
                $statsCopyFolder['files'] = 0;
                copyFolder('language/', 'includes/lngbackup/', $statsCopyFolder, true);
                $outseput .= '&nbsp;backup to includes/lngbackup/<br>files copied:'. $statsCopyFolder['files'] .' = ' . $statsCopyFolder['bytes'] . 'bytes | ' . date("l jS \of F Y h:i:s A");
                $myfile = fopen("includes/lngbackup/date.txt", "w");
                fwrite($myfile, '<?php $ddate ="' . date("l jS \of F Y h:i:s A") . '";');
                fclose($myfile);
                $ddate = date("l jS \of F Y h:i:s A");
            }
            $outseput .= '<br><br><a onclick="return confirm(\'Are you sure?\nthis will overwrite old  language-backup!\nand create a new one\nwich contains the activ language-set.\')" href="admin.php?page=editlang&backupd=1">create new backup<br>(overwrites old  language-set!)</a><br><br><a onclick="return confirm(\'Are you sure?\n\nthis will overwrite active language-set!\n with the files stored in includes/lngbackup/\')" href="admin.php?page=editlang&backupr=1">restore backup from:<br>(' . $ddate . ')<br> !overwrites active language-set!</a><br>';

            $datsen = glob($pfad . '*.php');
            foreach ($datsen as $file) {
                include $file;
                $LNG1[str_replace($pfad, "", str_replace(".php", "", $file))] = $LNG;
                $LNG    = array();
            }
            $LNG = $LNG1;
            $pfad = "";
        }
        //set arraypath
        if (isset($_GET['absatz'])) {
            $frame .= '[\'' . $_GET['absatz'] . '\']';
        }
        //only give asked array from asked file
        $LNG = eval('return $LNG' . $frame . ';');
        $template   = new template();

        $template->assign_vars(array(
                'LNG1'  => $LNG,//$LNG of reqested array
                'pfad' => $pfad,//path of loade lng file
                'frame' => $frame,//arraypath ['xx']['xx']
                'datei' => $datei,//filename of loade lngfile
                'outseput' => $outseput,//output for userfeedback of action/change
                'languages' => Language::getAllowedLangs(false),//get allowed languages
                'langa'      => $lang//requested language shortform like "de" or "en" or "es" or "fr"
            ));
        $template->show('editlangPage.tpl');
    }
}
