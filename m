From: akpm@linux-foundation.org
Subject: + drivers-dma-ioat-use-the-ccflag-y-instead-of-extra_cflags.patch added to -mm tree
Date: Mon, 08 Nov 2010 14:02:09 -0800
Message-ID: <201011082202.oA8M29ac012057@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40830 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755463Ab0KHWCL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Nov 2010 17:02:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tdent48227@gmail.com, dan.j.williams@intel.com


The patch titled
     drivers/dma/ioat: use the ccflag-y instead of EXTRA_CFLAGS
has been added to the -mm tree.  Its filename is
     drivers-dma-ioat-use-the-ccflag-y-instead-of-extra_cflags.patch

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
Subject: drivers/dma/ioat: use the ccflag-y instead of EXTRA_CFLAGS
From: Tracey Dent <tdent48227@gmail.com>

Change Makefile to use <modules>-y instead of <modules>-objs.  Following
(documentation/kbuild/makefiles.txt).

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
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

drivers-dma-use-the-ccflag-y-instead-of-extra_cflags.patch
drivers-dma-ioat-use-the-ccflag-y-instead-of-extra_cflags.patch
drivers-block-makefile-replace-the-use-of-module-objs-with-module-y.patch
drivers-block-aoe-makefile-replace-the-use-of-module-objs-with-module-y.patch

