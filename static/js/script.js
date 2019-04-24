// results-table

$(document).ready(function() {
  $("#results-table").tablesorter();

  // Try to print our headers
  console.log(headers);

  $("#results-table th").click(function() {
    console.log("Cool?");
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

    var row = parseInt( $(this).parent().index() )+1;

    

    alert("Row: " + row + " Col: " + column + " (" + netID + ", " + headers[column - 1] + ")");   
  });

});