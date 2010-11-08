From: akpm@linux-foundation.org
Subject: + drivers-block-aoe-makefile-replace-the-use-of-module-objs-with-module-y.patch added to -mm tree
Date: Mon, 08 Nov 2010 14:40:55 -0800
Message-ID: <201011082240.oA8MetFt014019@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49635 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753310Ab0KHWlD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Nov 2010 17:41:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tdent48227@gmail.com, axboe@kernel.dk, ecashin@coraid.com


The patch titled
     drivers/block/aoe/Makefile: replace the use of <module>-objs with <module>-y
has been added to the -mm tree.  Its filename is
     drivers-block-aoe-makefile-replace-the-use-of-module-objs-with-module-y.patch

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
Subject: drivers/block/aoe/Makefile: replace the use of <module>-objs with <module>-y
From: Tracey Dent <tdent48227@gmail.com>

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
Cc: "Ed L. Cashin" <ecashin@coraid.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/aoe/Makefile~drivers-block-aoe-makefile-replace-the-use-of-module-objs-with-module-y drivers/block/aoe/Makefile
--- a/drivers/block/aoe/Makefile~drivers-block-aoe-makefile-replace-the-use-of-module-objs-with-module-y
+++ a/drivers/block/aoe/Makefile
@@ -3,4 +3,4 @@
 #
 
 obj-$(CONFIG_ATA_OVER_ETH)	+= aoe.o
-aoe-objs := aoeblk.o aoechr.o aoecmd.o aoedev.o aoemain.o aoenet.o
+aoe-y := aoeblk.o aoechr.o aoecmd.o aoedev.o aoemain.o aoenet.o
_

Patches currently in -mm which might be from tdent48227@gmail.com are

drivers-dma-use-the-ccflag-y-instead-of-extra_cflags.patch
drivers-dma-ioat-use-the-ccflag-y-instead-of-extra_cflags.patch
drivers-block-makefile-replace-the-use-of-module-objs-with-module-y.patch
drivers-block-aoe-makefile-replace-the-use-of-module-objs-with-module-y.patch

