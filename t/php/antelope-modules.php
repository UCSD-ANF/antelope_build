#!/usr/bin/env php
<?php
if( !extension_loaded( 'Datascope') ) {
  die "Antelope Datascope extension is not loaded.";
}

if( !extension_loaded( 'Orb') ) {
  die "Antelope Orb extension is not loaded.";
}
echo "Antelope extensions are loaded properly";
?>
