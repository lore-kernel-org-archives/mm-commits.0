From: akpm@linux-foundation.org
Subject: [merged] fbdev-remove-makefile-reference-to-removed-driver.patch removed from -mm tree
Date: Thu, 07 May 2009 12:16:14 -0700
Message-ID: <200905071916.n47JGESg020165@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42134 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751251AbZEGTSQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 May 2009 15:18:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     fbdev: remove makefile reference to removed driver
has been removed from the -mm tree.  Its filename was
     fbdev-remove-makefile-reference-to-removed-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: remove makefile reference to removed driver
From: Krzysztof Helt <krzysztof.h1@wp.pl>

The cyblafb driver is removed so remove its last trace in the makefile.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Makefile |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/video/Makefile~fbdev-remove-makefile-reference-to-removed-driver drivers/video/Makefile
--- a/drivers/video/Makefile~fbdev-remove-makefile-reference-to-removed-driver
+++ a/drivers/video/Makefile
@@ -56,7 +56,6 @@ obj-$(CONFIG_FB_CT65550)          += chi
 obj-$(CONFIG_FB_IMSTT)            += imsttfb.o
 obj-$(CONFIG_FB_FM2)              += fm2fb.o
 obj-$(CONFIG_FB_VT8623)           += vt8623fb.o
-obj-$(CONFIG_FB_CYBLA)            += cyblafb.o
 obj-$(CONFIG_FB_TRIDENT)          += tridentfb.o
 obj-$(CONFIG_FB_LE80578)          += vermilion/
 obj-$(CONFIG_FB_S3)               += s3fb.o
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
linux-next.patch
chipsfb-remove-redundant-assignment.patch
igafb-use-framebuffer_alloc-to-allocate-fb_info-struct.patch
offb-use-framebuffer_alloc-to-allocate-fb_info-struct.patch

