From: akpm@linux-foundation.org
Subject: + fb-s3c2410-update-debugging-in-s3c2410-framebuffer-driver.patch added to -mm tree
Date: Tue, 29 Jan 2008 17:46:07 -0800
Message-ID: <200801300145.m0U1jmwk014960@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59044 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751227AbYA3Bqv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jan 2008 20:46:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org, adaplas@pol.net, vince@simtec.co.uk


The patch titled
     FB/S3C2410: update debugging in S3C2410 framebuffer driver
has been added to the -mm tree.  Its filename is
     fb-s3c2410-update-debugging-in-s3c2410-framebuffer-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-alsa.patch
git-arm.patch
git-mtd.patch
spi-s3c-drivers-shouldnt-care-about-spi_board_info.patch
sm501fb-control-panel-pin-usage-with-platform-data-flags.patch
sm501fb-clear-framebuffer-memory-and-palette.patch
fb-sm501-ensure-console-suspended-before-saving-state.patch
fb-s3c2412-add-s3c2412-support-to-s3c2410-fb-driver.patch
fb-s3c2410-update-debugging-in-s3c2410-framebuffer-driver.patch
fb-s3c2410-ensure-s3c2410-framebuffer-clears-initial-memory-to-black.patch
fb-s3c2410-check-default_display-parameter-passed-in-platform-data.patch
