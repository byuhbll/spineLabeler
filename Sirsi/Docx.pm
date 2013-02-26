#!/usr/bin/perl

##################################################################################
##      Docx Creation Library							##
##	FILE:	docx.pm								##	
##										##
##      PURPOSE:								##
##	This perl package comprises a Docx class.				##
##      The functions contained in this class will allow for the creation and   ##
##      basic manipulation of .docx files using the Office Open XML format.	##
##      									##
##	As a .docx file is merely a renamed .zip file containing prescribed 	##
##	XML files, this class works by allowing the user to tweak certain	##
##	parts of the XML before writing the XML files to a disk and 		##
##	compressing them into the .zip format as a .docx file.			##
##										##
##	DEPENDENCIES: [none]							##
##										##
##	NOTES:									##
##	- Write() and compress() require write-access to the filesystem in 	##
##	  the location denoted by their arguments.				## 
##										##
##      AUTHOR:   Scott Bertagnole                                        	##
##      HISTORY:  21 Feb 2012: Created                              		##
##                                                                              ##
##################################################################################

use strict;
package Docx;
our $VERSION = '1.00';

## new
#	This function constructs a new instance of the Docx class,
#	and returns a reference to itself.
#
#	@param	[none]
#	@return	Docx: An instance of this class
##
sub new
{
	my $class = shift;
	my $self = {@_};
	bless($self,$class);
	$self->_init;
	return $self;
}

## _init
#	This function acts in concert with the new() function to construct
#	the class.  While the new() function handles the blessing of the class,
#	this function handles the initialization of class variables.
#
#	@param	[none]
#	@return [none]
##
sub _init
{
	my $self = shift;

	$self->{text} = "";
	$self->{textLineHeader} = '<w:p><w:pPr><w:pStyle w:val="SpineLabel"/></w:pPr><w:r><w:rPr></w:rPr><w:t xml:space="preserve">';
	$self->{textLineFooter} = '</w:t></w:r></w:p>';
	
	$self->{pageWidth} = '11906';
	$self->{pageHeight} = '16838';
	$self->{pageMargins} = {
		top	=> 1440,
		right	=> 1440,
		left	=> 1440,
		bottom	=> 1440
	};
	$self->{orientation} = 'portrait';
}

## _init
#	This function acts in concert with the new() function to construct
#	the class.  While the new() function handles the blessing of the class,
#	this function handles the initialization of class variables.
#
#	@param	[none]
#	@return [none]
##
sub setPageSize
{
	my $self = shift;
	my $width = shift;
	my $height = shift;
	
	$self->{pageWidth} = $width if defined $width;
	$self->{pageHeight} = $height if defined $height;
}

## setPageMargins($top, $right, $bottom, $left)
#	This function sets the class variables that define page margins.
#	The margins should be passed to the function in CSS order (clockwise
#	from the top).
#
#	@param[0] int: The top margin
#	@param[1] int: The right margin
#	@param[2] int: The bottom margin
#	@param[3] int: The left margin
#	@return	  [none]
##
sub setPageMargins
{
	my $self = shift;
	my $top = shift;
	my $right = shift;
	my $bottom = shift;
	my $left = shift;
	
	$self->{pageMargins}->{top} = $top if defined $top;
	$self->{pageMargins}->{right} = $right if defined $right;
	$self->{pageMargins}->{bottom} = $bottom if defined $bottom;
	$self->{pageMargins}->{left} = $left if defined $left;
}

## addText($textToBeAdded)
#	This function accepts a string and appends it to $self->{text},
#	effectively adding it to the document to be written
#
#	@param	String: The text to be added
#	@return [none]
##
sub addText
{
	my $self = shift;
	my $data = shift;

	$self->{text} .= $self->{textLineHeader};
	$self->{text} .= $data if defined $data;	
	$self->{text} .= $self->{textLineFooter};
}

## write($pathToDocument)
#	This function will create a directory and populate it with the
#	necessary XML required for a docx file. It will then compress
#	the directory using the ZIP format and rename the resulting archive
#	using a .docx extension.  The document name will be the text following
#	the last '/' in the incoming argument.
#
#	@param	String: The path to where the docx should be created.  The text following the last '/' will be used as the name of the document itself.
#	@return [none]
##
sub write
{
	my $self = shift;
	my $data = shift;	#$data denotes the path to where the Docx archive should be created
	if (defined($data))
	{
		mkdir $data;
		mkdir $data . "/word";
		mkdir $data . "/word/_rels";
		mkdir $data . "/_rels";
		
		# Write the ./word/document.xml file
		# THIS FILE CONTAINS ALL THE CONTENT
		open (MYFILE, ">$data/word/document.xml");
		print MYFILE '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><w:document xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:wx="http://schemas.microsoft.com/office/word/2003/auxHint" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"><w:body>';
		print MYFILE $self->{text};
		print MYFILE '<w:sectPr><w:pgSz w:w="'.$self->{pageWidth}.'" w:h="'.$self->{pageHeight}.'" w:orient="'.$self->{orientation}.'"/><w:pgMar w:top="'.$self->{pageMargins}->{top}.'" w:left="'.$self->{pageMargins}->{left}.'" w:right="'.$self->{pageMargins}->{right}.'" w:bottom="'.$self->{pageMargins}->{bottom}.'"/><w:cols w:num="1" w:sep="off" w:equalWidth="1"/></w:sectPr></w:body></w:document>';
		close (MYFILE);

		# Write the ./[Content_Types].xml file
		open (MYFILE, ">$data/[Content_Types].xml");
		print MYFILE '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types"><Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/><Default Extension="xml" ContentType="application/xml"/><Default Extension="png" ContentType="image/png"/><Default Extension="jpg" ContentType="image/jpeg"/><Default Extension="jpeg" ContentType="image/jpeg"/><Default Extension="gif" ContentType="image/gif"/><Default Extension="tiff" ContentType="image/tiff"/><Default Extension="svg" ContentType="image/svg+xml"/><Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/><Override PartName="/word/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.styles+xml"/><Override PartName="/word/settings.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.settings+xml"/><Override PartName="/word/numbering.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.numbering+xml"/><Override PartName="/word/footnotes.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.footnotes+xml"/><Override PartName="/word/endnotes.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.endnotes+xml"/></Types>';
		close (MYFILE);

		# Write the ./_rels/.rels file
		open (MYFILE, ">$data/_rels/.rels");
		print MYFILE '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/></Relationships>';
		close (MYFILE);

		# Write the ./word/_rels/document.xml.rels file
		open (MYFILE, ">$data/word/_rels/document.xml.rels");
		print MYFILE '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/><Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/numbering" Target="numbering.xml"/><Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/settings" Target="settings.xml"/><Relationship Id="rId4" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/footnotes" Target="footnotes.xml"/><Relationship Id="rId5" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/endnotes" Target="endnotes.xml"/></Relationships>';
		close (MYFILE);

		# Write the ./word/endnotes.xml file
		open (MYFILE, ">$data/word/endnotes.xml");
		print MYFILE '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><w:endnotes xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"></w:endnotes>';
		close (MYFILE);

		# Write the ./word/footnotes.xml file
		open (MYFILE, ">$data/word/footnotes.xml");
		print MYFILE '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><w:footnotes xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"></w:footnotes>';
		close (MYFILE);

		# Write the ./word/numbering.xml file
		open (MYFILE, ">$data/word/numbering.xml");
		print MYFILE '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><w:numbering xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"></w:numbering>';
		close (MYFILE);

		# Write the ./word/settings.xml file
		open (MYFILE, ">$data/word/settings.xml");
		print MYFILE '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><w:settings xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"></w:settings>';
		close (MYFILE);
		
		# Write the ./word/styles.xml file
		open (MYFILE, ">$data/word/styles.xml");
		print MYFILE '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><w:styles xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" mc:Ignorable="w14"><w:docDefaults><w:rPrDefault><w:rPr><w:rFonts w:asciiTheme="minorHAnsi" w:eastAsiaTheme="minorHAnsi" w:hAnsiTheme="minorHAnsi" w:cstheme="minorBidi"/><w:sz w:val="22"/><w:szCs w:val="22"/><w:lang w:val="en-US" w:eastAsia="en-US" w:bidi="ar-SA"/></w:rPr></w:rPrDefault><w:pPrDefault/></w:docDefaults><w:latentStyles w:defLockedState="0" w:defUIPriority="99" w:defSemiHidden="1" w:defUnhideWhenUsed="1" w:defQFormat="0" w:count="267"><w:lsdException w:name="Strong" w:semiHidden="0" w:uiPriority="22" w:unhideWhenUsed="0" w:qFormat="1"/><w:lsdException w:name="Emphasis" w:semiHidden="0" w:uiPriority="20" w:unhideWhenUsed="0"/><w:lsdException w:name="Table Grid" w:semiHidden="0" w:uiPriority="59" w:unhideWhenUsed="0"/><w:lsdException w:name="Placeholder Text" w:unhideWhenUsed="0"/><w:lsdException w:name="No Spacing" w:semiHidden="0" w:uiPriority="1" w:unhideWhenUsed="0"/><w:lsdException w:name="Light Shading" w:semiHidden="0" w:uiPriority="60" w:unhideWhenUsed="0"/></w:latentStyles><w:style w:type="paragraph" w:default="1" w:styleId="Normal"><w:name w:val="Normal"/><w:qFormat/></w:style><w:style w:type="character" w:default="1" w:styleId="DefaultParagraphFont"><w:name w:val="Default Paragraph Font"/><w:uiPriority w:val="1"/><w:semiHidden/><w:unhideWhenUsed/></w:style><w:style w:type="table" w:default="1" w:styleId="TableNormal"><w:name w:val="Normal Table"/><w:uiPriority w:val="99"/><w:semiHidden/><w:unhideWhenUsed/><w:tblPr><w:tblInd w:w="0" w:type="dxa"/><w:tblCellMar><w:top w:w="0" w:type="dxa"/><w:left w:w="108" w:type="dxa"/><w:bottom w:w="0" w:type="dxa"/><w:right w:w="108" w:type="dxa"/></w:tblCellMar></w:tblPr></w:style><w:style w:type="numbering" w:default="1" w:styleId="NoList"><w:name w:val="No List"/><w:uiPriority w:val="99"/><w:semiHidden/><w:unhideWhenUsed/></w:style><w:style w:type="paragraph" w:styleId="NoSpacing"><w:name w:val="No Spacing"/><w:uiPriority w:val="1"/><w:rsid w:val="00035341"/></w:style><w:style w:type="paragraph" w:customStyle="1" w:styleId="SpineLabel"><w:name w:val="SpineLabel"/><w:basedOn w:val="Normal"/><w:link w:val="SpineLabelChar"/><w:qFormat/><w:rsid w:val="001B7972"/><w:rPr><w:rFonts w:ascii="Tahoma" w:hAnsi="Tahoma" w:cs="Tahoma"/><w:b/><w:sz w:val="18"/><w:szCs w:val="18"/></w:rPr></w:style><w:style w:type="character" w:styleId="Strong"><w:name w:val="Strong"/><w:basedOn w:val="DefaultParagraphFont"/><w:uiPriority w:val="22"/><w:qFormat/><w:rsid w:val="001B7972"/><w:rPr><w:b/><w:bCs/></w:rPr></w:style><w:style w:type="character" w:customStyle="1" w:styleId="SpineLabelChar"><w:name w:val="SpineLabel Char"/><w:basedOn w:val="DefaultParagraphFont"/><w:link w:val="SpineLabel"/><w:rsid w:val="001B7972"/><w:rPr><w:rFonts w:ascii="Tahoma" w:hAnsi="Tahoma" w:cs="Tahoma"/><w:b/><w:sz w:val="18"/><w:szCs w:val="18"/></w:rPr></w:style></w:styles>';
		close (MYFILE);
	}
	
	$self->_compress($data);
}

## _compress($pathToDocument)
#	This function compresses a directory using the ZIP format and 
#	renames the file to "filename".docx, where "filename" is the 
#	text following the last '/' in the incoming parameter
#
#	@param	String: The path to and name of the docx file to be created
#	@return [none]
##
sub _compress 
{
	my $self = shift;
	my $path = shift;
	
	my $filename = substr($path, rindex($path,"/")+1, length($path)-rindex($path,"/")-1);

	system("cd $path; 
		zip -r $filename.docx * >/dev/null;
		mv $filename.docx ../;
		
		rm [Content_Types].xml;
		rm _rels/.rels;
		rm word/document.xml;
		rm word/endnotes.xml;
		rm word/styles.xml;
		rm word/footnotes.xml;
		rm word/numbering.xml;
		rm word/settings.xml;
		rm word/_rels/document.xml.rels;
		
		rmdir _rels/ ;
		rmdir word/_rels/;
		rmdir word/;
		cd ../;
		rmdir $filename;
		");

}

1;  ##END PACKAGE
