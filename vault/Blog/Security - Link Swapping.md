---
aliases: 
tags:
  - security
  - web
date: 2050-10-03T15:14:11+00:00
lastmod: 2024-10-07T19:15:45+00:00
title: Link Swapping
---
  
If you're on a website and you see a link, how do you figure out where that link will take you? Just hover over it right? Try to hovering this <a href = "https://wikipedia.org" onclick="this.href = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ';" target="_blank">Totally Legitimate Link</a>, then click it.

### Common security advice
If you thought that hovering links before clicking them definitively informs you where you will be taken to, you are not alone. Many security guides actually tell you that this is the way to verify link integrity, for example in [this article by KeeperSecurity](https://www.keepersecurity.com/blog/2023/02/09/how-to-check-if-a-link-is-safe/). 

They also suggest using "Copy Link Address" and verifying it using a checker - that won't protect you either, as it copies the pre-swapped non-malicious link.

### Implementation
The above link swap is trivial to implement. On click, we swap the `href` attribute that decides where you will be taken to:

```html
<a href = "https://wikipedia.org"
   onclick="this.href = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ';"
   target="_blank">
	 Totally Legitimate Link
</a>
```

Pure HTML, no javascript required. In this case, inspecting the HTML will reveal the mechanism, but using javascript can make the above more obscured, making it harder to prevent yourself from being tricked. For example, 

### Widely used
This mechanism is used in many places, including LinkedIn. LinkedIn appends original urls with additional parameters before clicking. Hovering a link (for example a clickable user name) will display a link, but when you right-click it, you can see the url changing.

### Risk
Is there a security risk here, and how 
For example, a malicious site could actually make it appear that all links point to a correct, safe location - and on clicking, bring you to a phishing site looking exactly like the original target. Consider a malicious webshop with extreme discounts, baiting you into clicking links to phishing websites looking like your bank.

### Mitigation
Checking before clicking links is decent advice, but after clicking the link, verify that you ended up where you intended to go. 