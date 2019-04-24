// results-table

$(document).ready(function() {
  $("#results-table").tablesorter();

  $("#results-table td").click(function() {     
 
    var column_num = parseInt( $(this).index() ) + 1;
    var row_num = parseInt( $(this).parent().index() )+1;    

    


    alert("Row: " + row_num + " Col: " + column_num + "(" + header + ")");   
  });

});