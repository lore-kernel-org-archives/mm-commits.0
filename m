From: akpm@linux-foundation.org
Subject: - drivers-video-kconfig-fix-fb_pmagb_b-dependencies.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:44:33 -0700
Message-ID: <200710162044.l9GKiXeM016156@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45373 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754062AbXJPVHe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     drivers/video/Kconfig: Fix FB_PMAGB_B dependencies
has been removed from the -mm tree.  Its filename was
     drivers-video-kconfig-fix-fb_pmagb_b-dependencies.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/video/Kconfig: Fix FB_PMAGB_B dependencies
From: "Maciej W. Rozycki" <macro@linux-mips.org>

Add a missing FB dependency to FB_PMAGB_B.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/Kconfig~drivers-video-kconfig-fix-fb_pmagb_b-dependencies drivers/video/Kconfig
--- a/drivers/video/Kconfig~drivers-video-kconfig-fix-fb_pmagb_b-dependencies
+++ a/drivers/video/Kconfig
@@ -1652,7 +1652,7 @@ config FB_PMAG_BA
 
 config FB_PMAGB_B
 	tristate "PMAGB-B TURBOchannel framebuffer support"
-	depends on TC
+	depends on FB && TC
  	select FB_CFB_FILLRECT
  	select FB_CFB_COPYAREA
  	select FB_CFB_IMAGEBLIT
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
include-linux-typesh-in-if_fddih.patch
avoid-negative-and-full-width-shifts-in-radix-treec.patch
lk201-remove-obsolete-driver.patch
kernel-printkc-concerns-about-the-console-handover.patch
