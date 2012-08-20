From: akpm@linux-foundation.org
Subject: [merged] w1-omap-hdq-convert-to-module_platform_driver.patch removed from -mm tree
Date: Mon, 20 Aug 2012 12:56:58 -0700
Message-ID: <20120820195659.1891A5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:53924 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab2HTT5B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 15:57:01 -0400
Received: by wibhr14 with SMTP id hr14so217443wib.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 12:57:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balbi@ti.com, greg@kroah.com, zbr@ioremap.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/w1/masters/omap_hdq.c: convert to module_platform_driver
has been removed from the -mm tree.  Its filename was
     w1-omap-hdq-convert-to-module_platform_driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Felipe Balbi <balbi@ti.com>
Subject: drivers/w1/masters/omap_hdq.c: convert to module_platform_driver

Trivial patch, no functional changes.

Signed-off-by: Felipe Balbi <balbi@ti.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/omap_hdq.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff -puN drivers/w1/masters/omap_hdq.c~w1-omap-hdq-convert-to-module_platform_driver drivers/w1/masters/omap_hdq.c
--- a/drivers/w1/masters/omap_hdq.c~w1-omap-hdq-convert-to-module_platform_driver
+++ a/drivers/w1/masters/omap_hdq.c
@@ -652,19 +652,7 @@ static int __devexit omap_hdq_remove(str
 	return 0;
 }
 
-static int __init
-omap_hdq_init(void)
-{
-	return platform_driver_register(&omap_hdq_driver);
-}
-module_init(omap_hdq_init);
