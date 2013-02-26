#!/usr/bin/perl

##################################################################################
##										##
##      AUTHOR:         Scott Bertagnole                                        ##
##      CREATED:        6 Feb 2012                                              ##
##      THIS VERSION:   1.0.0 | 14 Feb 2012                                     ##
##										##
##      This perl package contains a set of Perl subs (functions).		##
##	The functions contained by this package deal with editing and		##
##	manipulating text.							##
##										##
##################################################################################

use strict;
package Sirsi::Text;

## trim
#	Removes both leading and trailing whitespace from a given string
#
#	@params:	- A string
#	@returns: 	A string which is identical to that passed in as an
#			argument, save that it will have whitespace stripped
#			from both the start and end of the string.
#	@filechanges:	[none]
##
sub trim($)
{
        my $string = shift;
        $string =~ s/^\s+//;
        $string =~ s/\s+$//;
        return $string;
}
## ltrim
#	Removes leading whitespace from a given string
#
#	@params:	- A string
#	@returns: 	A string which is identical to that passed in as an
#			argument, save that it will have whitespace stripped
#			from ONLY the start of the string.
#	@filechanges:	[none]
##
sub ltrim($)
{
        my $string = shift;
        $string =~ s/^\s+//;
        return $string;
}
## rtrim
#	Removes trailing whitespace from a given string
#
#	@params:	- A string
#	@returns: 	A string which is identical to that passed in as an
#			argument, save that it will have whitespace stripped
#			from ONLY the end of the string.
#	@filechanges:	[none]
##
sub rtrim($)
{
        my $string = shift;
        $string =~ s/\s+$//;
        return $string;
}

1; #END PACKAGE
