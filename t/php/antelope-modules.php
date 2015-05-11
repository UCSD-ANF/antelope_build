#!/usr/bin/env php
<?php
$extensions = array('Datascope','Orb','sysinfo');
foreach($extensions as $extension) {
	if( !extension_loaded( $extension ) ) {
		print ("Antelope $extension extension is not loaded.");
		exit (1);
	}
	$functions = get_extension_funcs($extension);
	echo "Functions available in the $extension extension:<br>\n";
	foreach($functions as $func) {
		echo $func."<br>\n";}
}
echo "Antelope extensions are loaded properly.<br>\n";
?>
