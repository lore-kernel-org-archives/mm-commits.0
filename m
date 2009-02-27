From: akpm@linux-foundation.org
Subject: + n411-add-missing-makefile-entry.patch added to -mm tree
Date: Fri, 27 Feb 2009 13:59:24 -0800
Message-ID: <200902272159.n1RLxOJW006582@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754747AbZB0WAN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Feb 2009 17:00:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: herton@mandriva.com.br, jayakumar.lkml@gmail.com, krzysztof.h1@poczta.fm


The patch titled
     n411: add missing Makefile entry
has been added to the -mm tree.  Its filename is
     n411-add-missing-makefile-entry.patch

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

w1-add-missing-kconfig-makefile-entries-for-ds2431-slave-driver.patch
linux-next.patch
n411-add-missing-makefile-entry.patch

