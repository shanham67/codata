<?php
/**
* @author Justine Leng
* @date Feb 2011
*
* Require the auto loader
*
* Use dirname(__FILE__) because “./” can be stripped by PHP’s safety
* settings and __DIR__ was introduced in PHP 5.3.
*/

require dirname(__FILE__) . "/autoload.php";

$Address = new AddressStandardizationSolution;

$result = $Address->AddressLineStandardization($argv[1]);
echo $result;

?>
