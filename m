From: akpm@linux-foundation.org
Subject: - neofb-fill-transp-msb_right-with-the-correct.patch removed from -mm tree
Date: Tue, 08 May 2007 19:59:26 -0700
Message-ID: <200705090259.l492xQS4010403@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970212AbXEIC73 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:59:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     neofb: fill transp->msb_right with the correct  value
has been removed from the -mm tree.  Its filename was
     neofb-fill-transp-msb_right-with-the-correct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: neofb: fill transp->msb_right with the correct  value
From: "Antonino A. Daplas" <adaplas@gmail.com>

Fill transp->msb_right with the correct value.  fbcon ignores this, but user
apps may not.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/neofb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/neofb.c~neofb-fill-transp-msb_right-with-the-correct drivers/video/neofb.c
--- a/drivers/video/neofb.c~neofb-fill-transp-msb_right-with-the-correct
+++ a/drivers/video/neofb.c
@@ -665,6 +665,7 @@ neofb_check_var(struct fb_var_screeninfo
 	var->red.msb_right = 0;
 	var->green.msb_right = 0;
 	var->blue.msb_right = 0;
+	var->transp.msb_right = 0;
 
 	switch (var->bits_per_pixel) {
 	case 8:		/* PSEUDOCOLOUR, 256 */
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
