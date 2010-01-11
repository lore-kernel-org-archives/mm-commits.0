From: akpm@linux-foundation.org
Subject: + da9030_battery-fix-spelling-in-comment.patch added to -mm tree
Date: Mon, 11 Jan 2010 14:51:58 -0800
Message-ID: <201001112251.o0BMpwZu000784@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45570 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752190Ab0AKWwH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 17:52:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: weil@mail.berlios.de, cbouatmailru@gmail.com, mike@compulab.co.il


The patch titled
     da9030_battery: fix spelling in comment
has been added to the -mm tree.  Its filename is
     da9030_battery-fix-spelling-in-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: da9030_battery: fix spelling in comment
From: Stefan Weil <weil@mail.berlios.de>

platfrom -> platform
monotor -> monitor

Signed-off-by: Stefan Weil <weil@mail.berlios.de>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Acked-by: Mike Rapoport <mike@compulab.co.il>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/da9030_battery.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/power/da9030_battery.c~da9030_battery-fix-spelling-in-comment drivers/power/da9030_battery.c
--- a/drivers/power/da9030_battery.c~da9030_battery-fix-spelling-in-comment
+++ a/drivers/power/da9030_battery.c
@@ -509,7 +509,7 @@ static int da9030_battery_probe(struct p
 
 	charger->master = pdev->dev.parent;
 
-	/* 10 seconds between monotor runs unless platfrom defines other
+	/* 10 seconds between monitor runs unless platform defines other
 	   interval */
 	charger->interval = msecs_to_jiffies(
 		(pdata->batmon_interval ? : 10) * 1000);
_

Patches currently in -mm which might be from weil@mail.berlios.de are

linux-next.patch
da9030_battery-fix-spelling-in-comment.patch

