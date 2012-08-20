From: akpm@linux-foundation.org
Subject: [merged] w1-omap-hdq-remove-unnecessary-return.patch removed from -mm tree
Date: Mon, 20 Aug 2012 12:57:05 -0700
Message-ID: <20120820195706.215985C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:61914 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab2HTT5I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 15:57:08 -0400
Received: by eekd4 with SMTP id d4so298219eek.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 12:57:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balbi@ti.com, greg@kroah.com, zbr@ioremap.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/w1/masters/omap_hdq.c: remove unnecessary return
has been removed from the -mm tree.  Its filename was
     w1-omap-hdq-remove-unnecessary-return.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Felipe Balbi <balbi@ti.com>
Subject: drivers/w1/masters/omap_hdq.c: remove unnecessary return

Trivial patch, no functional changes.

Signed-off-by: Felipe Balbi <balbi@ti.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/omap_hdq.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/w1/masters/omap_hdq.c~w1-omap-hdq-remove-unnecessary-return drivers/w1/masters/omap_hdq.c
--- a/drivers/w1/masters/omap_hdq.c~w1-omap-hdq-remove-unnecessary-return
+++ a/drivers/w1/masters/omap_hdq.c
@@ -538,8 +538,6 @@ static void omap_w1_write_byte(void *_hd
 		hdq_data->init_trans = 0;
 		mutex_unlock(&hdq_data->hdq_mutex);
 	}
