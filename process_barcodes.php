<?php

main();

function main()
{
	$barcodes = getBarcodes();
	$results = processBarcodes($barcodes);
	serveResults($results);
}

function getBarcodes(){
	$barcodes = explode("\n", $_POST['barcodes']);
	foreach ($barcodes as $key => $value)
	{	
		$barcodes[$key] = trim($value);
		if(!is_numeric($barcodes[$key]) || sizeof($barcodes[$key]) == 0)
		{
			unset($barcodes[$key]);
		}
	}	
	return $barcodes;
}

function processBarcodes($barcodes){
	$result = "No Barcodes";
	if(sizeof($barcodes) > 0)
	{
		$barcodeString = implode("|", $barcodes);
		$cmd = "echo '" . $barcodeString . "' | perl generateLabelsFromBarcodes.pl 2>&1";
		$result = shell_exec($cmd);
	}

	return $result;
}

function printResults($results)
{
//var_dump($results);
	header("Content-type: application/vnd.ms-word");
	header("Content-type: application/octet-stream"); 
	header("Content-Disposition: attachment;Filename=spinelabels_".date("YmdHis").".doc");
	header("Cache-Control: must-revalidate, post-check=0, pre-check=0"); 
	header("Pragma: no-cache"); 
	header("Expires: 0"); 
	echo "<html>";
	echo "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=Windows-1252\">";
	echo "<body style='width:1728px; height:2592px;'>";
	echo $results;
	echo "</body>";
	echo "</html>";
}

function serveResults($pathAndFile)
{
	if(file_exists($pathAndFile))
	{
		header("Location:$pathAndFile");
	}
	else
	{
		echo "ERROR:<br />".$pathAndFile;
	}
}
?>
