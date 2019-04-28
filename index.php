<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>CSV Test</title>
    
    <script src="./static/js/jquery-3.3.1.min.js"></script>
    <script src="./static/js/jquery.tablesorter.min.js"></script>
    <script src="./static/js/script.js"></script>

    <link rel="stylesheet" href="static/css/style.css">

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

    <!-- Save the headers to a js variable -->
    <script>
        var headers = <?php echo json_encode($headers) ?>;
    </script>
</body>
</html>