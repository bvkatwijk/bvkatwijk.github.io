---
aliases: 
tags:
  - security
  - web
  - html
date: 2024-13-03T09:14:11+00:00
lastmod: 2024-10-13T09:52:41+00:00
title: Link Swapping
---
  
If you're on a website and you see a link, how do you figure out where that link will take you? Just hover over it right? Try to hovering this <a href = "https://wikipedia.org" onclick="this.href = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ';" target="_blank">Totally Legitimate Link</a>. If you dare, click it.

If you've clicked the link, welcome back! Refresh the page to have the link in it's initial state again. Not everything is what it seems, and this is also very true when browsing the web. 

### Common security advice
If you thought that hovering links before clicking them definitively informs you where you will be taken to, you are not alone. Many security guides tell you that this is the way to verify link integrity, for example in [this article by KeeperSecurity](https://www.keepersecurity.com/blog/2023/02/09/how-to-check-if-a-link-is-safe/). 

They also suggest using "Copy Link Address" and verifying it using a checker - that won't protect you either, as it copies the pre-swapped non-malicious link.

### Implementation
How does this work? The tactic used in my link swap is trivial to implement. On click, we swap the `href` attribute that decides where you will be taken to:

```html
<a href = "https://wikipedia.org"
   onclick="this.href = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ';"
   target="_blank">
	 Totally Legitimate Link
</a>
```

This is pure HTML, there is no javascript required. In this case, inspecting the HTML will reveal the mechanism. Also, if you hover the link after you have clicked it, the new malicious url will be displayed. 
There are many ways to adapt this mechanism to make it more hidden, for example by using javascript.

### Widely used
This mechanism of link swapping is used in many places, including on LinkedIn. LinkedIn appends original urls with additional parameters before clicking. Hovering a link (for example a clickable user name) will display a link, but when you right-click it, you can see the url changing. LinkedIn appends extra data to the url which could be a way to implement more detailed user tracking.

### Risk
This technique can be used in phishing attacks. For example, a malicious site could actually make it appear that all links point to a correct, safe location - and on clicking, bring you to a phishing site looking exactly like the original target. For example, a phishing site looking exactly like the homepage of your bank. All links on the page can be made to appear valid, but they will keep you on the malicious site 

### Advice
Checking before clicking links is good advice, but after clicking the link, verify that you ended up where you intended to go. Be especially vigilant when receiving html content that you did not ask for (such as emails).