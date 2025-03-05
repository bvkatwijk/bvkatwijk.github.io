---
aliases: 
tags:
  - html
  - hugo
  - monetization
  - advertisement
date: 2025-03-05T09:34:32+00:00
lastmod: 2025-03-05T11:03:16+00:00
title: Ads on your Blog site
featured_image: /images/ads.jpg
---
For a side project I had to add some advertisements, and while I was at it, I also added Google Ads onto my blog. Not so much as to make money (I don't expect a lot of traffic here) but to learn how to do it in various environments. It can be a very useful skill if you are running a free website to cover hosting or if you want to provide this as a service to others.

The process was quite easy. The work can be done within an hour, but there may be some waiting time until everything is verified on their end.
### Signing up for AdSense
First step is to [log into AdSense](https://www.google.com/adsense/login) and register your website. 

### Add account data to your site
After you have done this, you need to place a bit of data on your site. Two values inside the `<head>` section of each page, and an `ads.txt` file hosted on your domain.

A lot of documentation on the Google Adsense pages mentions `Ads.txt` instead of `ads.txt`. Using a capital letter `A` does not work! I have reported this and hope they will fix this confusing aspect of the documentation soon.

Using a Hugo blog this is very easy to do, as each page is generated from a template. Since I am using the Ananke theme on my [[Hugo]] blog, I can just edit `head-additions.html` to add the required html. The `ads.txt` file can be created inside the `static` directory.

### Add Display Ad Units
Next step is to create Ad Units, which are the actual ads you want to host on your site. I chose an ad at the end of each article (to minimize reading disruption) and an ad in the sidebar which you automatically scroll past. I doubt that this is a very profitable strategy, but that is not really my goal.

The html snippets for these Display Ad Units should be added to your html. In the case of Hugo, placing it inside the template of a page means that it is inserted into each of your pages.

### Dynamic Ads
You can also let google decide where to best place ads. Personally I found that the placements were too intrusive and I did not use this feature.

### Wait for review
A background process will review your website. It's likely that you'll see `Getting ready` on the Approval Status tab. I'm waiting too, so I'll wrap up this article once it is done, be right back!

### Approved
After a day the status changed to `Approved`. I had some delay, probably due to the incorrect file name of the `ads.txt` file mentioned earlier.

On navigating to the site, I noticed two ads where added on the indicated places. Success!

### Cookie Consent Pop-Up
In the section `Privacy and Messaging`, you can set up GDPR compliancy to show user targeted ads. This could increase accuracy and revenue, but it also means that a cookie consent modal will pop up. Because I personally found this too intrusive for the user experience I disabled this option.

