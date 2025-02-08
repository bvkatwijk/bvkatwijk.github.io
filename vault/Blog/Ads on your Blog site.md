---
aliases: 
tags:
  - html
  - hugo
  - monetization
  - advertisement
date: 2025-02-08T13:34:32+00:00
lastmod: 2025-02-08T14:18:27+00:00
title: Ads on your Blog site
featured_image: /images/ads.jpg
draft: "true"
---
Recently I added Google Ads onto my blog. Not so much as to make money (I don't expect a lot of traffic here) but to learn how to do it. It can be a very useful skill if you are running a free website to cover hosting or if you want to provide this as a service to others.

Luckily the process was very easy. Which makes sense, given that it is Google's core business and they want you to host the best ads you can. The work can be done within an hour, but there may be some waiting time until everything is verified on their end.
### Signing up for AdSense
First step is to [log into AdSense](https://www.google.com/adsense/login) and register your website. 

### Add account data to your site
After you have done this, you need to place a bit of data on your site. Two values inside the `<head>` section of each page, and an `Ads.txt` file hosted on your domain.

Using a Hugo blog this is very easy to do, as each page is generated from a template. Since I am using the Ananke theme on my [[Hugo]] blog, I can just edit `head-additions.html` to add the required html. The `Ads.txt` file can be created inside the `static` directory.

### Add Display Ad Units
Next step is to create Ad Units, which are the actual ads you want to host on your site. I chose an ad at the end of each article (to minimize reading disruption) and an ad in the sidebar which you automatically scroll past. I doubt that this is a very profitable strategy, but that is not really my goal.

The html snippets for these Display Ad Units should be added to your html. In the case of Hugo, placing it inside the template of a page means that it is inserted into each of your pages.

### Wait for review
A background process will review your website. It's likely that you'll see `Getting ready` on the Approval Status tab. I'm waiting too, so I'll wrap up this article once it is done, be right back!


