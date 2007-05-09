From: akpm@linux-foundation.org
Subject: - nvidiafb-fix-return-value-of-nvidiafb_open.patch removed from -mm tree
Date: Tue, 08 May 2007 20:02:15 -0700
Message-ID: <200705090302.l4932Fk2010812@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50062 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032712AbXEIDCR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:02:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     nvidiafb: fix return value of nvidiafb_open()
has been removed from the -mm tree.  Its filename was
     nvidiafb-fix-return-value-of-nvidiafb_open.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: nvidiafb: fix return value of nvidiafb_open()
From: "Antonino A. Daplas" <adaplas@gmail.com>

Fix return value of nvidiafb_open().

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/nvidia/nvidia.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/nvidia/nvidia.c~nvidiafb-fix-return-value-of-nvidiafb_open drivers/video/nvidia/nvidia.c
--- a/drivers/video/nvidia/nvidia.c~nvidiafb-fix-return-value-of-nvidiafb_open
+++ a/drivers/video/nvidia/nvidia.c
@@ -1016,7 +1016,7 @@ static int nvidiafb_release(struct fb_in
 	par->open_count--;
 done:
 	mutex_unlock(&par->open_lock);
-	return 0;
+	return err;
 }
 
 static struct fb_ops nvidia_fb_ops = {
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
vt8623fb-new-framebuffer-driver-for-via-vt8623.patch
vt8623fb-fix-compile-warnings.patch
vt8623fb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards.patch
arkfb-fix-compiler-warnings.patch
arkfb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards-fix.patch
svgalib-move-fb_get_caps-to-svgalib.patch
