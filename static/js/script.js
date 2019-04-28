// results-table

var PARENT_DIR = "Client";
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
    $("#results-table th").css("background-color", "azure");
    $(this).css("background-color", "#00bbcc");
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

    // Wire up the inspection button
    $("#inspect-button").attr("onclick", "showCode(" + 
    "'"+ sourceDir + ALLJAVA + "', " + 
    "'" + compareDir + ALLJAVA + "')");


    // Show modal
    $("#matches-modal").addClass("active");

    // alert("Row: " + row + " Col: " + column + " (" + netID + ", " + headers[column - 1] + ")");   
  });

});

function showCode(file1, file2) {
  alert(file1 + " " + file2);
}