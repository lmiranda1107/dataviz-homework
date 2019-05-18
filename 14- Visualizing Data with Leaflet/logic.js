// Link to Geojson - Store API endpoint inside earthquakeUrl
//let earthquakeUrl = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_week.geojson"
let earthquakeUrl = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_week.geojson"

// Use D3 to grab data with 'GET' request to the earthquakeURL
d3.json(earthquakeUrl, function(data) {
  
    // After receiving a response, send the data.features object to the createFeatures function
  createFeatures(data.features);
});

function createFeatures(earthquakeData) {

  // Give each feature a popup with place + time of the earthquake
  function onEachFeature(feature, layer) {
    layer.bindPopup("<h3>" + feature.properties.place +
      "</h3><hr><p>" + new Date(feature.properties.time) + "</p>" +
      "</h3><hr><p>Magnitude: " + feature.properties.mag + "</p>");
  }

  // Create a GeoJSON layer with the features array on the earthquakeData object
  // Run onEachFeature function once for each piece of data in the array
  let earthquakes = L.geoJSON(earthquakeData, {
    onEachFeature: onEachFeature,
    pointToLayer: function (feature, latlng) {
      let color;
      let r = 255;
      let g = Math.floor(255-80*feature.properties.mag);
      let b = Math.floor(255-80*feature.properties.mag);
      color= "rgb("+r+" ,"+g+","+ b+")"
      
      let geojsonMarkerOptions = {
        radius: 4*feature.properties.mag,
        fillColor: color,
        color: "black",
        weight: 1,
        opacity: 1,
        fillOpacity: 0.8
      };
      return L.circleMarker(latlng, geojsonMarkerOptions);
    }
  });

  // Send earthquakes layer to the createMap function
  createMap(earthquakes);
}
function createMap(earthquakes) {

  // Define streetmap layers
  let streetmap = L.tileLayer("https://api.mapbox.com/styles/v1/mapbox/outdoors-v10/tiles/256/{z}/{x}/{y}?" +
    "access_token=pk.eyJ1IjoibG1pcmFuZGExMTA3IiwiYSI6ImNqdmVkbDg2bTJpbDEzeXMxYnR4NTR6eW8ifQ.m4xlXCH4nVtvVxcUY3VRpQ");

  // Define baseMaps object to hold our base layers
  let baseMaps = {
    "Street Map": streetmap
  };

  // Create overlay object to hold our overlay layer
  let overlayMaps = {
    Earthquakes: earthquakes
  };

  // Create our map, giving it the streetmap and earthquakes layers to display once it loads
  let myMap = L.map("map", {
    center: [
      37.09, -95.71
    ],
    zoom: 5,
    layers: [streetmap, earthquakes]
  });


  function getColor(d) {
      return d < 1 ? 'rgb(255,255,255)' :
            d < 2  ? 'rgb(255,225,225)' :
            d < 3  ? 'rgb(255,195,195)' :
            d < 4  ? 'rgb(255,165,165)' :
            d < 5  ? 'rgb(255,135,135)' :
            d < 6  ? 'rgb(255,105,105)' :
            d < 7  ? 'rgb(255,75,75)' :
            d < 8  ? 'rgb(255,45,45)' :
            d < 9  ? 'rgb(255,15,15)' :
                        'rgb(255,0,0)';
  }

  // Create a legend
  let legend = L.control({position: 'bottomright'});

  legend.onAdd = function (map) {
  
      let div = L.DomUtil.create('div', 'info legend'),
      grades = [0, 1, 2, 3, 4, 5, 6, 7, 8],
      labels = [];

      div.innerHTML+='Magnitude<br><hr>'
  
      // loop through density intervals and generate a label with a colored square for each interval
      for (let i = 0; i < grades.length; i++) {
          div.innerHTML +=
              '<i style="background:' + getColor(grades[i] + 1) + '">&nbsp&nbsp&nbsp&nbsp</i> ' +
              grades[i] + (grades[i + 1] ? '&ndash;' + grades[i + 1] + '<br>' : '+');
  }
  
  return div;
  };
  
  legend.addTo(myMap);

}