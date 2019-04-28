
function getURLParam(paramName) {
  // Get the yung URL
  var URL = window.location.href;

  // Focus on params
  URL = URL.split("?")[1];

  if (URL) {
    // Split into a list of parameters
    parameters = URL.split("&");

    // Check each of the arguments for our passed query string
    for (var i = 0; i < parameters.length; i++) {
      query = parameters[i];
      queryParts = query.split("=");

      if (paramName == queryParts[0]) {
        return decodeURIComponent(queryParts[1]);
      }
    }
  }

  return "Unable to parse Param: " + paramName; 
}


$(document).ready(function() {

  // Read the files from the url and load the data
  var file1 = getURLParam("file1");
  var file2 = getURLParam("file2");

  alert(file1 + " " + file2);

});