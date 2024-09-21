---
aliases: 
tags: 
title: TopDesk Exchange Sync
date: Wednesday, September 18th 2024, 3:36:29 pm
lastmod: 2024-09-18T11:18:48+00:00
date_mod: Saturday, September 21st 2024, 8:25:44 pm
---
At [topdesk]({{< ref "topdesk" >}}) I was part of a team working on a two-way synchronisation between [Microsoft Exchange](https://www.microsoft.com/en/microsoft-365/exchange/) and [Topdesk Reservations](https://www.topdesk.com/en/features/reservations-management/). The goal was to allow different departments of a large organisation to use the room reservation system of their preference. Most branches of this organisation used Microsoft Exchange to book meeting rooms, whereas Office Management staff used Topdesk Reservations.

### Race Conditions
When working on a two-way integration, one of the challenges can be race conditions where conflicting valid data exists in both of the systems. For example, in this case multiple people could book a room at the same time in different systems. The application logic of both systems will allow the reservation, but the synchronisation needs to be able to resolve these conflicts gracefully.

The solution we used for this was to make the customer assign one of the systems as the dominant system. In the above situation the dominant system would keep the reservation. The non-dominant system would yield, causing conflicts to be handled normally.

