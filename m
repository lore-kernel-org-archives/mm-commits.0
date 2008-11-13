From: akpm@linux-foundation.org
Subject: - atmel_lcdfb-change-irq_base-definition-to-allow-error-reporting.patch removed from -mm tree
Date: Thu, 13 Nov 2008 13:26:30 -0800
Message-ID: <200811132126.mADLQUfj027345@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752898AbYKMV1W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Nov 2008 16:27:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.ferre@atmel.com, hskinnemoen@atmel.com, linux@maxim.org.za, roel.kluin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     atmel_lcdfb: change irq_base definition to allow error reporting
has been removed from the -mm tree.  Its filename was
     atmel_lcdfb-change-irq_base-definition-to-allow-error-reporting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_lcdfb: change irq_base definition to allow error reporting
From: Nicolas Ferre <nicolas.ferre@atmel.com>

Changed because old the definition of unsigned long cannot be negative.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Reported-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Andrew Victor <linux@maxim.org.za>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/video/atmel_lcdc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/video/atmel_lcdc.h~atmel_lcdfb-change-irq_base-definition-to-allow-error-reporting include/video/atmel_lcdc.h
--- a/include/video/atmel_lcdc.h~atmel_lcdfb-change-irq_base-definition-to-allow-error-reporting
+++ a/include/video/atmel_lcdc.h
@@ -38,7 +38,7 @@ struct atmel_lcdfb_info {
 	spinlock_t		lock;
 	struct fb_info		*info;
 	void __iomem		*mmio;
-	unsigned long		irq_base;
+	int			irq_base;
 	struct work_struct	task;
 
 	unsigned int		guard_time;
_

Patches currently in -mm which might be from nicolas.ferre@atmel.com are

origin.patch
drivers-video-bad-error-test-before-a-dereference.patch

