#!/usr/bin/env php
<?php
$antelope=getenv('ANTELOPE');
dl( $antelope . '/local/data/php/' . 'Orb.so' ) or die( 'Cannot load Orb shared object' );
dl( $antelope . '/local/data/php/' . 'Datascope.so' ) or die ( 'Cannot load Datascope shared object' );
?>
