#!/usr/bin/perl

##################################################################################
##										##
##      AUTHOR:         Scott Bertagnole                                        ##
##      CREATED:        6 Feb 2012                                              ##
##      THIS VERSION:   1.0.0 | 14 Feb 2012                                     ##
##										##
##      This perl package contains a set of Perl subs (functions).		##
##	The functions contained by this package deal with Symphony API calls,	##
##	and serve to standardize, modularize, and combine API calls needed by	##
##	custom Perl scripts.							##
##                                                                              ##
##      Be aware that any file changes, unless otherwise noted,  will take 	##
##	place in relation to the current working directory (ie: the directory 	##
##	from which you are calling the script that uses this library, not the	##
##	directory that that script resides in, nor in the directory that this	##
##	package resides in).                 					##
##                                                                              ##
##################################################################################

use strict;
package Sirsi::API;

## env
#	Sets up the environment parameters required to make API calls to Symphony
#
#	@params: 	[none]
#	@returns: 	[none]
#	@filechanges:	[none]
##
sub env
{
	$ENV{PATH} =":/opt/sirsi/Unicorn/Bincustom:/opt/sirsi/Unicorn/Bin:/opt/sirsi/Unicorn/Search/Bin:/bin:/usr/bin:/usr/local/bin/:/usr/sbin:/opt/sirsi/Unicorn/Oracle_client/10.2.0.2:/opt/sirsi/bin";
	$ENV{BRSConfig} = "/opt/sirsi/Unicorn/Config/brspath";
	$ENV{UPATH} = "/opt/sirsi/Unicorn/Config/upath";
	$ENV{LD_LIBRARY_PATH} = ":/opt/sirsi/Unicorn/Oracle_client/10.2.0.2:/opt/sirsi/Unicorn/Oracle_client/10.1.0.4";
	$ENV{TNS_ADMIN} = "/opt/sirsi/Unicorn/Config/";
	$ENV{'NLS_SORT'} = "SIRSI_M";
}

## spinelabels
#	Sends a list of barcodes (Item IDs) into selitem to retrieve the catkeys from the catalog.
#	The catkeys are then sent back through the catalog using a spinepock call to retrieve the
#	raw spine label.
#	
#	@params:	- Array containing barcodes
#	@returns:	A string containing the timestamp that this function was called.  This string can be used to reference the raw spine labels that this function creates.
#	@filechanges:	This function will create the following files:
#			- ./logs/barcodes.$timestamp.list (where $timestamp is replaced by the 14-digit timecode), containing the barcodes passed in as the argument to this function
#			- ./logs/selitem.$timestamp.log (where $timestamp is replaced by the 14-digit timecode) containing the STDERR from selitem.
#			- ./logs/spinepock.$timestamp.log (where $timestamp is replaced by the 14-digit timecode) containing the STDERR from spinepock.
#			- ./logs/labels.$timestamp.raw (where $timestamp is replaced by the 14-digit timecode) containing the STDOUT (the raw spine labels) returned from spinepock.
##
sub spinelabels
{
	my $timestamp = timestamp();
	my $path_to_cmd = "/opt/sirsi/Unicorn/Bin/";

	writeArrayToFile(\@_ , "logs/barcodes.$timestamp.list", "|\n");

	my $cmd_selitem = $path_to_cmd . "selitem -iB -oK 2>logs/selitem.$timestamp.log";
	my $cmd_spinepock = $path_to_cmd . "spinepock -f10 -l -s 2>logs/spinepock.$timestamp.log >logs/labels.$timestamp.raw";
	
	system("cat logs/barcodes.$timestamp.list | $cmd_selitem | $cmd_spinepock");

	my $return = $timestamp;
}

## timestamp
#	Retrieves the current system time in the following format: YYYYmmddHHiiss
#	e.g.: 4:00:37pm on February 1, 2012 would be displayed as: 20120201160037
#
#	@params: 	[none]
#	@returns: 	A 14-digit timestamp in descending order of magnitude
#	@filechanges:	[none]
##
sub timestamp
{
	(my $sec,my $min,my $hour,my $mday,my $mon,my $year,my $wday,my $yday,my $isdst) = localtime(time);
	my $timestamp = sprintf( "%04d%02d%02d%02d%02d%02d", $year+1900, $mon+1, $mday, $hour, $min, $sec);
}

## writeArrayToFile
#	Writes an array to a file.  The array will be flattened into a string with a
#	delimiter placed in between each element. It is recommended that the delimiter
#	include a newline character.  IF THE FILE TO BE WRITTEN ALREADY
#	EXISTS, THIS FUNCTION WILL OVERWRITE IT!
#
#	@params: 	0. Array containing the text to be written to the file
#			1. The path and name of the file to be written
#			2. The delimiter to be used to demarcate the flattened array
#	@returns: 	[none]
#	@filechanges:	This function will create the following files:
#			- The file denoted by the second argument (arg1)
##
sub writeArrayToFile
{	
	my($array, $filename, $delimiter) = @_;
	open (MYFILE, ">$filename");
	foreach my $item (@{$array})
	{
		print MYFILE $item.$delimiter;
	}
	close (MYFILE);
}

## writeStringToFile
#	Writes a string to a file.  IF THE FILE TO BE WRITTEN ALREADY
#	EXISTS, THIS FUNCTION WILL OVERWRITE IT!
#
#	@params: 	0. String containing the text to be written to the file
#			1. The path and name of the file to be written
#	@returns: 	[none]
#	@filechanges:	This function will create the following files:
#			- The file denoted by the second argument (arg1)
##
sub writeStringToFile
{	
	my($string, $filename) = @_;
	open (MYFILE, ">$filename");
	print MYFILE $string;
	close (MYFILE);
}

## readArrayFromFile
#	Reads lines from a file and returns them as an array.  Unlike the 
#	writeArrayFromFile function, this function has no flexibility regarding
#	the delimiter (at this version, at least).  The only delimiter it will
#	recognize is the newline character (\n).
#
#	@params:	- The path and name of the file to be read
#	@returns: 	An array containing the contents of the file, with each
#			element of the array containing 1 line from the file
#	@filechanges:	[none]
##
sub readArrayFromFile
{
	my $filename = $_[0];
	my @return;
	open (MYFILE, "<", $filename);
	while(<MYFILE>)
	{
		chomp;
		push(@return, $_);
	}
	close(FILE);
	@return = @return;
}

1; #END PACKAGE
