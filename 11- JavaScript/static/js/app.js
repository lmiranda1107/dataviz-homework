// Use data for table from data.js 
// use 'let' instead of 'var'
let filtered_data = data;

// D3 to select the table body
let tbody = d3.select("tbody");
let table = d3.select("table");

// D3 to set the table class to `table table-striped`
table.attr("class", "table table-striped");

// Build table with data given
function buildTable(filtered_data) {
    //Clear data from UFO table
    tbody.html("");
    filtered_data.forEach((UFOrecord) => {
    let row = tbody.append("tr");
    // Populate rows of UFO table
    Object.entries(UFOrecord).forEach(([key, value]) => {
    // Populate column for current row
      let cell = row.append("td");      
      cell.text(value);
    }); 
})};

// Build the UFO sighting table with data from data.js
buildTable(filtered_data);

// Filter UFO table user entries by date
// Select the submit button
let submit = d3.select("#filter-btn"); 

// Select the input element and get the raw HTML node.
let inputDate = d3.select("#datetime");
let inputCity = d3.select("#city");
let inputState = d3.select("#state");
let inputCountry = d3.select("#country");
let inputShape = d3.select("#shape");

// Filter data with button
submit.on("click", function() {
  // Prevent page from refreshing
  d3.event.preventDefault();
  let inputValue = inputDate.property("value");   // Get the value property of the input element
  console.log(inputValue);

  // Create Filtered dataset based on InputValue entered by user
  let filtered_dataFiltered = filtered_data.filter(ufoRecord => ufoRecord.datetime === inputValue);
  console.log(filtered_dataFiltered);
 
  // Build new UFO Table with the filtered subset of UFO Sighting data
  buildTable(filtered_dataFiltered);

});