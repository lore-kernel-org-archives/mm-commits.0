From: akpm@linux-foundation.org
Subject: [merged] n411-add-missing-makefile-entry.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:43:59 -0700
Message-ID: <200904011844.n31Ihxie010233@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934040AbZDATWu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:22:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: herton@mandriva.com.br, jayakumar.lkml@gmail.com, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     n411: add missing Makefile entry
has been removed from the -mm tree.  Its filename was
     n411-add-missing-makefile-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: n411: add missing Makefile entry
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>

There is no entry for n411.c to be built, include one in Makefile.

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Makefile |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/Makefile~n411-add-missing-makefile-entry drivers/video/Makefile
--- a/drivers/video/Makefile~n411-add-missing-makefile-entry
+++ a/drivers/video/Makefile
@@ -76,6 +76,7 @@ obj-$(CONFIG_FB_ATARI)            += ata
                                      atafb_iplan2p2.o atafb_iplan2p4.o atafb_iplan2p8.o
 obj-$(CONFIG_FB_MAC)              += macfb.o
 obj-$(CONFIG_FB_HECUBA)           += hecubafb.o
+obj-$(CONFIG_FB_N411)             += n411.o
 obj-$(CONFIG_FB_HGA)              += hgafb.o
 obj-$(CONFIG_FB_XVR500)           += sunxvr500.o
 obj-$(CONFIG_FB_XVR2500)          += sunxvr2500.o
_

Patches currently in -mm which might be from herton@mandriva.com.br are

origin.patch
linux-next.patch

