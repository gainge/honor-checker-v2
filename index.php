<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Honor Checker Results</title>

    <link rel="apple-touch-icon" sizes="180x180" href="res/apple-touch-icon.png">
    <link rel="icon" type="image/png" sizes="32x32" href="res/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="res/favicon-16x16.png">
    <link rel="manifest" href="res/site.webmanifest">
    <link rel="mask-icon" href="res/safari-pinned-tab.svg" color="#5bbad5">
    <link rel="shortcut icon" href="res/favicon.ico">
    <meta name="msapplication-TileColor" content="#ffffff">
    <meta name="msapplication-config" content="res/browserconfig.xml">
    <meta name="theme-color" content="#ffffff">
    
    <script src="./static/js/jquery-3.3.1.min.js"></script>
    <script src="./static/js/jquery.tablesorter.min.js"></script>
    <script src="./static/js/script.js"></script>

    <link rel="stylesheet" href="static/css/style.css">
    <link rel="stylesheet" href="static/css/spectre.min.css">

</head>
<body>
    <?php
    echo "<table id='results-table'>\n\n";
    $f = fopen("./Client/results/results.csv", "r");
    $headersRead = false;
    $headers = array();

    while (($line = fgetcsv($f)) !== false) {
        if (!$headersRead) {
            echo "<thead>";
        }

        echo "<tr>";

        foreach ($line as $col=>$cell) {
            $description = htmlspecialchars($cell);
            
            if (!$headersRead) {
                // Strip leading directory
                if (strpos($description, "/") > 0 && $col != 0) {
                    $description = substr($description, strpos($description, "/") + 1);
                }
                array_push($headers, $description);

                echo "<th>" . $description . "</th>";
            } else {
                echo "<td>" . $description . "</td>";
            }
        }

        if (!$headersRead) {
            // Transition from Head to body
            echo "</thead>";
            echo "<tbody>";
        }

        $headersRead = true; // Set header flag for the rest of the iteration
        echo "</tr>\n";
    }
    fclose($f);
    echo "\n</tbody></table>";
    ?>

    <div class="modal" id="matches-modal">
        <a class="modal-overlay" aria-label="Close"></a>
        <div class="modal-container" id="matches-container">
            <div id="header-container">
                <h3>Matches</h3>
            </div>

            <div id="content">
                <textarea name="matches" id="matches-body"></textarea>
            </div>

            <div id="inspect-container">
                <button class="btn btn-primary" id="inspect-button">View Code</button>
            </div>
        </div>
    </div>

    <!-- Save the headers to a js variable -->
    <script>
        var headers = <?php echo json_encode($headers) ?>;
    </script>
</body>
</html>