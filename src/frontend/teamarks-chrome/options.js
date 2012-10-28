function load() {
	if (window.localStorage == null) {
		alert("LocalStorage must be enabled.");
		document.getElementById('save').disabled = true;
		return;
	}

	console.log('loading options.');
	var endpoint = window.localStorage.endpoint;
	document.getElementById('endpoint').value = endpoint == 'undefined' ? "http://api.teamarks.com/v1/url" : endpoint;
	var userid = window.localStorage.userid;
	document.getElementById('userid').value = userid == 'undefined' ? "" : userid;
	var apikey =  window.localStorage.apikey;
	document.getElementById('apikey').value = apikey == 'undefined' ? "" : apikey;
}

function save() {
	if (window.localStorage == null) {
		alert("LocalStorage must be enabled.");
		return;
	}
	console.log('saving options.');
	window.localStorage.endpoint = document.getElementById('endpoint').value;
	window.localStorage.userid = document.getElementById('userid').value;
	window.localStorage.apikey = document.getElementById('apikey').value;
	document.getElementById('status').innerHTML = "Saved";
	setTimeout(function() {document.getElementById('status').innerHTML = "";}, 1000);
}

load();
document.querySelector('#saveme').addEventListener('click', save);
