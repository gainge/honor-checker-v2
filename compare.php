<?php

// Check parameters
if (!isset($_GET['sourceFile']) || !isset($_GET['compareFile'])) {
    echo "Invalid Parameters, source file and comparison file necessary";
} else {
    // Grab the files, and return the results of our script!
    $sourceFile = $_GET['sourceFile'];
    $compareFile = $_GET['compareFile'];

    $matches = shell_exec("./compare_java.sh " . $sourceFile . " " . $compareFile );

    echo $matches;
}

?>