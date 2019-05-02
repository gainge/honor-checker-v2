<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Honor Checker</title>

    <link rel="apple-touch-icon" sizes="180x180" href="res/apple-touch-icon.png">
    <link rel="icon" type="image/png" sizes="32x32" href="res/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="res/favicon-16x16.png">
    <link rel="manifest" href="res/site.webmanifest">
    <link rel="mask-icon" href="res/safari-pinned-tab.svg" color="#5bbad5">
    <link rel="shortcut icon" href="res/favicon.ico">
    <meta name="msapplication-TileColor" content="#ffffff">
    <meta name="msapplication-config" content="res/browserconfig.xml">
    <meta name="theme-color" content="#ffffff">

    <link rel="stylesheet" href="static/css/style.css">
    <link rel="stylesheet" href="static/css/spectre.min.css">


</head>
<body>

    <h1 id="page-title">Honor Checker</h1>

    <hr>

    <h1>Projects:</h1>

    <?php
    function writeProjectEntry($project) {
        $entry = "<a href='results.php?project=" . $project . "'>" . $project . "</a>";
        return $entry;
    }

    $currentDir = ".";
    $ignored =  array("res", "static", "Testing");

    if ($handle = opendir($currentDir)) {
        echo "<ul>";
        while (($entry = readdir($handle)) !== false) {
            if (is_dir($entry) && 
                strpos($entry, ".") !== 0 &&
                !in_array($entry, $ignored)) {
                    echo "<li>" . writeProjectEntry($entry) . "</li>";
            }
        }
        echo "</ul>";
    }

    ?>

</body>
</html>