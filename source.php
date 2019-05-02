<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>View Source Code</title>

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
    <link rel="stylesheet" href="static/css/prism.css">

    <style>
        .file-compare-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            grid-column-gap: .1rem;
        }


        .file-container {
            max-width: 48vw;
        }


        .code-container {
            max-height: 85vh;
            overflow-x: scroll;
            overflow-y: scroll;
            border: 1px solid #343434;
        }

        pre[class*="language-"] {
            margin: 0 !important;
        }

        h3 {
            height: 2rem;
            text-align: center;
        }
    </style>
</head>
<body>
    <?php
        // Read the passed args
        $file1 = isset($_GET['file1']) ? $_GET['file1'] : "File Not Set!";
        $file2 = isset($_GET['file2']) ? $_GET['file2'] : "File Not Set!";
    ?>

    <div class="file-compare-container">

        <div class="file-container">
            <div>
                <h3 id="file1-name"><u><?php echo $file1 ?></u></h3>
            </div>
            <div class="code-container">
                <pre><code id="file1" class="line-numbers language-java"><?php echo file_get_contents($file1); ?></code></pre>
            </div>
        </div>
        
        <div class="file-container">
            <div>
                <h3 id="file1-name"><u><?php echo $file2 ?></u></h3>
            </div>
            <div class="code-container">
                <pre><code id="file2" class="line-numbers language-java"><?php echo file_get_contents($file2); ?></code></pre>
            </div>
        </div>
    </div>

    <script src="./static/js/prism.js"></script>

</body>
</html>