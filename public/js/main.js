function ZipCode (zip, count, lat, lng) {
	this.zip = zip;
	this.count = count;
	this.lat = lat;
	this.lng = lng;
	
	this.getInfo = function() {
		alert('Zip: ' + this.zip + ' Count: ' +  this.count + ' Lat: ' +  this.lat + ' Lng: ' +  this.lng);
	};
}

function placeMarker(zipCode) {

	var markerPosition = new google.maps.LatLng(zipCode.lat, zipCode.lng);

	var marker = new google.maps.Marker({
		position: markerPosition,
		map: document.map,
		id: zipCode.zip
	});
	document.markers.push(marker);
	
	google.maps.event.addListener(marker, 'click', function() {
		pullZipCode(zipCode, marker)
	});

}

function pullZipCode(zip, marker) {

	var marker = getMarkerById(zip.zip);
	var html = createHtml(zip);
	var info = createInfoWindow(html);
	info.open(document.map, marker);
	
	url = "/ajax/histogram/" + zip.zip;
	$.getJSON( url, [], zipSuccess );
	
}

function createHtml(zip) {
	
	var enclosure = document.createElement('div');
	var div = document.createElement('div');
	var hist = document.createElement('div');
	var load = document.createElement('div');
	
	$(div).attr("id", zip.zip);
	$(div).addClass("marker");
	$(div).append("<strong>Zipcode: "+ zip.zip +"</strong> ("+ zip.count +" listings)")
	
	$(load).attr("id", "load" + zip.zip);
	$(load).append("<img src='/images/loading.gif'>");
	
	$(hist).attr("id", "norm" + zip.zip);
	$(hist).addClass("histogram");
	
	$(div).append($(load));
	$(div).append($(hist));
	$(enclosure).append($(div));
	
	return $(enclosure).html();
	
}

function zipSuccess(data, status) {
	createHistogram(data["data"], data["zip"]);
	$("#load" + data["zip"]).hide();
}

function createInfoWindow(contentString) {
	var infowindow = new google.maps.InfoWindow({
		content: contentString,
		maxWidth: 400
	});
	
	return infowindow;
}

function createHistogram(data, zip) {
	
	var options = {
	    series: {
	      bars: { show: true },
	    }
	  };
	
	$.plot( $("#norm"+ zip), [data], options );
}

function getMarkerById(id) {	
	for (var i = 0; i < document.markers.length ; i++) {
		if (id == document.markers[i].id) {
			return document.markers[i];
		}
	}
}

function getZipCodeByZip(zip) {
	for (var i = 0; i < document.zipcodes.length ; i++) {
		if (zip == document.zipcodes[i].zip) {
			return document.zipcodes[i];
		}
	}
}

