From: akpm@linux-foundation.org
Subject: - fb-s3c2410-update-debugging-in-s3c2410-framebuffer-driver.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:29:25 -0800
Message-ID: <200802070029.m170T6PG007244@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55489 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935050AbYBGAon (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, adaplas@pol.net, vince@simtec.co.uk, mm-commits@vger.kernel.org


The patch titled
     FB/S3C2410: update debugging in S3C2410 framebuffer driver
has been removed from the -mm tree.  Its filename was
     fb-s3c2410-update-debugging-in-s3c2410-framebuffer-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: FB/S3C2410: update debugging in S3C2410 framebuffer driver
From: Ben Dooks <ben-linux@fluff.org>

Update the debugging in the s3c2410 framebuffer driver.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Vincent Sanders <vince@simtec.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3c2410fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/s3c2410fb.c~fb-s3c2410-update-debugging-in-s3c2410-framebuffer-driver drivers/video/s3c2410fb.c
--- a/drivers/video/s3c2410fb.c~fb-s3c2410-update-debugging-in-s3c2410-framebuffer-driver
+++ a/drivers/video/s3c2410fb.c
@@ -670,7 +670,7 @@ static int __init s3c2410fb_map_video_me
 	dma_addr_t map_dma;
 	unsigned map_size = PAGE_ALIGN(info->fix.smem_len);
 
-	dprintk("map_video_memory(fbi=%p)\n", fbi);
+	dprintk("map_video_memory(fbi=%p) map_size %u\n", fbi, map_size);
 
 	info->screen_base = dma_alloc_writecombine(fbi->dev, map_size,
 						   &map_dma, GFP_KERNEL);
_

Patches currently in -mm which might be from ben-linux@fluff.org are

origin.patch
git-mtd.patch
