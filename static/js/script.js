// results-table

var STUDENT_CODE = "student-code-directories";
var ALLJAVA = "alljava.txt";
var CLEANED = "cleaned.txt";

$(document).ready(function() {
  $("#results-table").tablesorter();

  $(".modal-overlay").click(function() {
    $(".modal").removeClass("active");
  })

  // Try to print our headers
  console.log(headers);

  // Wire up some dope functionality
  $("#results-table th").click(function() {
    $("#results-table th").removeClass("selected");
    $(this).addClass("selected");
  });

  $("#results-table td").click(function() {   
    var column = parseInt( $(this).index() ) + 1;
    var netID = $(this).closest('tr').children('td:first').text();

    if (column == 1) {
      alert("NetID: " + netID);
      return;
    }

    var repo = headers[column - 1];

    // Get the modal's elements ready
    var sourceDir = PARENT_DIR + "/" + STUDENT_CODE + "/" + netID + "/";
    var compareDir;

    // Route to the correct directory, depending on if it's a student or repo
    if (repo.indexOf("/") == -1) {
      // Comparing against another student
      compareDir = PARENT_DIR + "/" + STUDENT_CODE + "/" + repo + "/";
    } else {
      // Comparing against a repo, so we just append
      compareDir = PARENT_DIR + "/" + repo + "/";
    }

    // Show modal with just the spinner for the time being
    $("#match-content").html('<div class="lds-dual-ring"></div>');
    $("#inspect-button").hide();
    $("#matches-modal").addClass("active");

    // Get the matches from the comparison script
    $.ajax({
      url: "compare.php",
      type: 'get',
      data: {
        "sourceFile": sourceDir + CLEANED,
        "compareFile": compareDir + CLEANED
      },
      success: function(matches) { loadMatchesModal(matches, sourceDir, compareDir); }
    })
  });



  function loadMatchesModal(matches, sourceDir, compareDir) {
    // Wire up the inspection button
    $("#inspect-form").attr("action", "source.php?" +
    "file1=" + sourceDir + ALLJAVA + "&" + 
    "file2=" + compareDir + ALLJAVA + "");

    $("#inspect-button").show();

    // Clear the spinner and load the matches
    $("#match-content").html('<textarea name="matches" id="matches-body" spellcheck="false"></textarea>')
    $("#matches-body").val(matches);
    console.log(matches);
  }

});

function showCode(file1, file2) {
  alert(file1 + " " + file2);
}