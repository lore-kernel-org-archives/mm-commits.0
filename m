From: akpm@linux-foundation.org
Subject: [merged] da9030_battery-fix-spelling-in-comment.patch removed from -mm tree
Date: Wed, 03 Feb 2010 09:55:26 -0800
Message-ID: <201002031755.o13HtQsF008983@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53415 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932806Ab0BCR6n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 12:58:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weil@mail.berlios.de, cbouatmailru@gmail.com, mike@compulab.co.il, mm-commits@vger.kernel.org


The patch titled
     da9030_battery: fix spelling in comment
has been removed from the -mm tree.  Its filename was
     da9030_battery-fix-spelling-in-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

