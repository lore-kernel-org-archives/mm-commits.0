From: akpm@linux-foundation.org
Subject: + fbdev-remove-makefile-reference-to-removed-driver.patch added to -mm tree
Date: Tue, 05 May 2009 12:51:04 -0700
Message-ID: <200905051951.n45Jp4ww022187@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42884 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752216AbZEETwO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2009 15:52:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     fbdev: remove makefile reference to removed driver
has been added to the -mm tree.  Its filename is
     fbdev-remove-makefile-reference-to-removed-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
fbdev-fix-fillrect-for-24bpp-modes.patch
fbdev-remove-makefile-reference-to-removed-driver.patch
chipsfb-remove-redundant-assigment.patch

