From: akpm@linux-foundation.org
Subject: + drivers-block-makefile-replace-the-use-of-module-objs-with-module-y.patch added to -mm tree
Date: Mon, 08 Nov 2010 13:05:52 -0800
Message-ID: <201011082105.oA8L5qOX009533@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754307Ab0KHVF7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Nov 2010 16:05:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tdent48227@gmail.com, axboe@kernel.dk


The patch titled
     drivers/block/Makefile: replace the use of <module>-objs with <module>-y
has been added to the -mm tree.  Its filename is
     drivers-block-makefile-replace-the-use-of-module-objs-with-module-y.patch

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
Subject: drivers/block/Makefile: replace the use of <module>-objs with <module>-y
From: Tracey Dent <tdent48227@gmail.com>

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/Makefile~drivers-block-makefile-replace-the-use-of-module-objs-with-module-y drivers/block/Makefile
--- a/drivers/block/Makefile~drivers-block-makefile-replace-the-use-of-module-objs-with-module-y
+++ a/drivers/block/Makefile
@@ -39,4 +39,4 @@ obj-$(CONFIG_XEN_BLKDEV_FRONTEND)	+= xen
 obj-$(CONFIG_BLK_DEV_DRBD)     += drbd/
 obj-$(CONFIG_BLK_DEV_RBD)     += rbd.o
 
-swim_mod-objs	:= swim.o swim_asm.o
+swim_mod-y	:= swim.o swim_asm.o
_

Patches currently in -mm which might be from tdent48227@gmail.com are

drivers-block-makefile-replace-the-use-of-module-objs-with-module-y.patch
drivers-block-aoe-makefile-replace-the-use-of-module-objs-with-module-y.patch

