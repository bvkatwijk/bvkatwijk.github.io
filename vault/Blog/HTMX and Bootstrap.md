---
aliases: 
tags:
  - htmx
  - bootstrap
  - javascript
  - html
  - ui
  - ssr
  - web
date: 2025-02-14T10:28:07+00:00
lastmod: 2025-02-14T11:26:14+00:00
title: Combining htmx with Bootstrap
featured_image: /images/htmx-bs-tooltip.png
GHissueID: "16"
---
Using [htmx](http://htmx.org/) with [Bootstrap](https://getbootstrap.com/) is mostly a seamless experience, but I've encountered a few places where a bit of extra effort is needed to smooth everything out. Since I could not find a concise description of the required fix, I've created this quick post to outline the issue and the remedy.
### Bootstrap
Since I work mostly on business-to-business administrative web applications, I need to build many interfaces, yet a slick or custom styling is usually not the highest priority. We need a well rounded set of standard component that enables data presentation with clarity.
So let's just pretend we still live in the '10s and use [Bootstrap](https://getbootstrap.com/). A benefit is that all the scraping-trained AI's are now all Bootstrap experts, meaning that stamping out entire dashboards is trivial.
### Javascript behaviour
Some elements in Bootstrap require javascript to function properly. To help performance, it is up to the developer to trigger this when appropriate. Bootstrap uses [Floating UI](https://floating-ui.com/) (Previously called popper.js)

An example of this is when using tooltips, which need to be registered:

```javascript
document.addEventListener("DOMContentLoaded", function() {
	var tooltipTriggerList = [].slice
		.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
	tooltipTriggerList.map(function (tooltipTriggerEl) {
		return new bootstrap.Tooltip(tooltipTriggerEl, {
			boundary: "window"
		});
	});
});
```

### HTMX
[htmx](http://htmx.org/) is a tiny frontend framework, which may allow you to remove or omit the client-side stack entirely (I can now use [[j2html]] instead). One of the main features of htmx is that it allows any element to issue [AJAX](https://en.wikipedia.org/wiki/Ajax_(programming)) requests, and expects hypermedia back which it will swap in-place.

This means that HTMX will cause UI elements to be added to the page dynamically, and in newer versions of Bootstrap, they will not be registered. This causes issues when javascript behaviour needs to be added using a listener. 

### Register Dynamic htmx Elements

So in addtion to triggering this logic at `DOMContentLoaded` , we also trigger it on `htmx:afterRequest`:

```javascript
function registerElements() {
	var tooltipTriggerList = [].slice
		.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
	tooltipTriggerList.map(function (tooltipTriggerEl) {
		return new bootstrap.Tooltip(tooltipTriggerEl, {
			boundary: "window"
		});
	});
}

document.addEventListener("DOMContentLoaded", registerElements);
document.addEventListener("htmx:afterRequest", registerElements);
```

You can add more initialisation to `registerElements` as needed when using more javascript-based elements from Bootstrap, for example Popovers.