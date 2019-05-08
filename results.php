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

    // Aight, so let's try to read from the headers or something
    $project = isset($_GET['project']) ? $_GET['project'] : null;
    $resultsFile = $project . "/results/results.csv";
    $headers = array();

    if (is_file($resultsFile)) {
        echo "<h1><u>Honor Checker Results</u></h1>";
        echo "<p style='margin-top: -1.1rem;'>(Select repositories to sort for top matches)</p>";

        // Display the results
        echo "<table id='results-table'>\n\n";
        $f = fopen($resultsFile, "r");
        $headersRead = false;

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

                    echo "<th title='sort'>" . $description . "</th>";
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
            echo "</tr>";
        }
        fclose($f);
        echo "</tbody></table>";
    } else {
        echo "<h3>>>Unable to read results from Directory [" . $project . "]</h3>";
    }
    ?>

    <div class="modal" id="matches-modal">
        <a class="modal-overlay" aria-label="Close"></a>
        <div class="modal-container" id="matches-container">
            <div id="header-container">
                <h3>Matches</h3>
            </div>

            <div id="match-content">
            </div>

            <div id="inspect-container">
                <form id="inspect-form" target="_blank" method="post">
                    <button class="btn btn-primary" id="inspect-button">View Code</button>
                </form>
            </div>
        </div>
    </div>

    <!-- Save the headers and parent dir to js variables -->
    <script>
        var headers = <?php echo json_encode($headers) ?>;
        var PARENT_DIR = <?php echo json_encode($project) ?>;
    </script>
</body>
</html>