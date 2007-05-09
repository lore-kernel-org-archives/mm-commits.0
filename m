From: akpm@linux-foundation.org
Subject: - skeletonfb-documentation-error-fixes.patch removed from -mm tree
Date: Tue, 08 May 2007 20:01:12 -0700
Message-ID: <200705090301.l4931ChX010663@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59103 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1033055AbXEIDBO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:01:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     skeletonfb: documentation error fixes
has been removed from the -mm tree.  Its filename was
     skeletonfb-documentation-error-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: skeletonfb: documentation error fixes
From: "Antonino A. Daplas" <adaplas@gmail.com>

Documentation error fixes.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/skeletonfb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/skeletonfb.c~skeletonfb-documentation-error-fixes drivers/video/skeletonfb.c
--- a/drivers/video/skeletonfb.c~skeletonfb-documentation-error-fixes
+++ a/drivers/video/skeletonfb.c
@@ -959,11 +959,11 @@ static int xxxfb_suspend(struct platform
 
 /**
  *	xxxfb_resume - Optional but recommended function. Resume the device.
- *	@dev: PCI device
+ *	@dev: platform device
  *
  *      See Documentation/power/devices.txt for more information
  */
-static int xxxfb_suspend(struct platform_dev *dev)
+static int xxxfb_resume(struct platform_dev *dev)
 {
 	struct fb_info *info = platform_get_drvdata(dev);
 	struct xxxfb_par *par = info->par;
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
