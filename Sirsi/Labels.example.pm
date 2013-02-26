#!/usr/bin/perl

################################################################################
##  This file should be renamed Labels.pm prior to use.  Additionally, the    ##
##  contents of the %location_labels hash below should be replaced with       ##
##  values appropriate for your library.  The format should be:               ##
##  	"LOCATION_CODE" => "TEXT ON LABEL",                                   ##
##  with any desired line breaks denoted by the "\n" escape sequence.         ##
################################################################################
 
use strict;
package Sirsi::Labels;

sub getLocationFromCode
{
	my $location = $_[0];
	my %location_labels = (
		"GENERAL"       => "\n",
		"MUSIC"         => "MUSIC\n",
		"SPEC-COLL"     => "SPEC\nCOLL\n",
	);

	if (exists $location_labels{$_[0]})
	{
		$location = $location_labels{$_[0]};
	}
}

1; #END PACKAGE
