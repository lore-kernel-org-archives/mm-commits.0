From: akpm@linux-foundation.org
Subject: [merged] video-framebuffer-move-the-probe-func-into-devinittext-in-blackfin-lcd-driver.patch removed from -mm tree
Date: Thu, 12 Feb 2009 12:25:28 -0800
Message-ID: <200902122025.n1CKPSVG014698@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56182 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758762AbZBLUfp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Feb 2009 15:35:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ukleinek@strlen.de, cooloney@kernel.org, vapier.adi@gmail.com, mm-commits@vger.kernel.org


The patch titled
     video/framebuffer: move the probe func into .devinit.text in Blackfin LCD driver
has been removed from the -mm tree.  Its filename was
     video-framebuffer-move-the-probe-func-into-devinittext-in-blackfin-lcd-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: video/framebuffer: move the probe func into .devinit.text in Blackfin LCD driver
From: Uwe Kleine-Koenig <ukleinek@strlen.de>

Signed-off-by: Uwe Kleine-Koenig <ukleinek@strlen.de>
Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/bfin-t350mcqb-fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/bfin-t350mcqb-fb.c~video-framebuffer-move-the-probe-func-into-devinittext-in-blackfin-lcd-driver drivers/video/bfin-t350mcqb-fb.c
--- a/drivers/video/bfin-t350mcqb-fb.c~video-framebuffer-move-the-probe-func-into-devinittext-in-blackfin-lcd-driver
+++ a/drivers/video/bfin-t350mcqb-fb.c
@@ -447,7 +447,7 @@ static irqreturn_t bfin_t350mcqb_irq_err
 	return IRQ_HANDLED;
 }
 
-static int __init bfin_t350mcqb_probe(struct platform_device *pdev)
+static int __devinit bfin_t350mcqb_probe(struct platform_device *pdev)
 {
 	struct bfin_t350mcqbfb_info *info;
 	struct fb_info *fbinfo;
_

Patches currently in -mm which might be from ukleinek@strlen.de are

origin.patch
linux-next.patch

