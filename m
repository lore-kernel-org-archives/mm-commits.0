From: akpm@linux-foundation.org
Subject: [merged] drivers-dma-ioat-use-the-ccflag-y-instead-of-extra_cflags.patch removed from -mm tree
Date: Thu, 09 Dec 2010 11:38:52 -0800
Message-ID: <201012091940.oB9Jeh4f002894@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50587 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754325Ab0LITku (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Dec 2010 14:40:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tdent48227@gmail.com, dan.j.williams@intel.com, linus.walleij@stericsson.com, mm-commits@vger.kernel.org


The patch titled
     drivers/dma/ioat: use the ccflag-y instead of EXTRA_CFLAGS
has been removed from the -mm tree.  Its filename was
     drivers-dma-ioat-use-the-ccflag-y-instead-of-extra_cflags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/dma/ioat: use the ccflag-y instead of EXTRA_CFLAGS
From: Tracey Dent <tdent48227@gmail.com>

Change Makefile to use <modules>-y instead of <modules>-objs.  Following
(documentation/kbuild/makefiles.txt).

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/ioat/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/dma/ioat/Makefile~drivers-dma-ioat-use-the-ccflag-y-instead-of-extra_cflags drivers/dma/ioat/Makefile
--- a/drivers/dma/ioat/Makefile~drivers-dma-ioat-use-the-ccflag-y-instead-of-extra_cflags
+++ a/drivers/dma/ioat/Makefile
@@ -1,2 +1,2 @@
 obj-$(CONFIG_INTEL_IOATDMA) += ioatdma.o
-ioatdma-objs := pci.o dma.o dma_v2.o dma_v3.o dca.o
+ioatdma-y := pci.o dma.o dma_v2.o dma_v3.o dca.o
_

Patches currently in -mm which might be from tdent48227@gmail.com are

linux-next.patch
drivers-block-makefile-replace-the-use-of-module-objs-with-module-y.patch
drivers-block-aoe-makefile-replace-the-use-of-module-objs-with-module-y.patch

