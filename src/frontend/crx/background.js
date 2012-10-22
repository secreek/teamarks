//	* Some code grabbed from the official example

var req;

function shareUrl(url, title, text) {
	var endpoint = window.localStorage.endpoint;
	var userid = window.localStorage.userid;
	var apikey = window.localStorage.apikey;
	req = new XMLHttpRequest();
	req.open(
	"POST",
	endpoint + "?" +
	"userid=" + userid +
	"&apikey=" + apikey
	);
	var body = "url=" + encodeURIComponent(url) +
	"&title=" + encodeURIComponent(title) +
	"&text=" + encodeURIComponent(text);

	req.onload = showResult;
	req.send(body);
	console.log("body:\n" + body);
}

function showResult() {
	var result = req.responseXML.getElementsByTagName("Result");
	console.log("Server returned: " + result);
	
	// Feedback Method #1
	var notification = webkitNotifications.createNotification('shareicon_64x64.png', 'Teamarks', result);
	notification.show();
	
	// Feedback Method #2
	chrome.browserAction.setBadgeText ( { text: "done" } );
	setTimeout(function () {
	    chrome.browserAction.setBadgeText( { text: "" } );
	}, 1000);
	
	// And we could use both
}

function sharePage(tab_id, title, url, text) {
	shareUrl(url, title, text);
}

chrome.extension.onConnect.addListener(function(port) {
	var tab = port.sender.tab;

	// This will get called by the content script we execute in
	// the tab as a result of the user pressing the browser action.
	port.onMessage.addListener(function(info) {
		var max_length = 1024;
		if (info.selection.length > max_length)
		info.selection = info.selection.substring(0, max_length);
		sharePage(tab.id, info.title, tab.url, info.selection);
	});
});

// Called when the user clicks on the browser action icon.
chrome.browserAction.onClicked.addListener(function(tab) {
	// We can only inject scripts to find the title on pages loaded with http
	// and https so for all other pages, we don't ask for the title.
	console.log('button clicked!');
	if (tab.url.indexOf("http:") != 0 &&
	tab.url.indexOf("https:") != 0) {
		sharePage(tab.id, "", tab.url, "");
	} else {
		chrome.tabs.executeScript(null, {
			file: "content_script.js"
		});
	}
});
