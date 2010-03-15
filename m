From: akpm@linux-foundation.org
Subject: [merged] drivers-block-floppyc-convert-some-include-asm-to-include-linux.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:53:03 -0400
Message-ID: <201003150653.o2F6raBt016004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38179 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756997Ab0COGxn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:53:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/floppy.c: convert some #include <asm/ to #include <linux/
has been removed from the -mm tree.  Its filename was
     drivers-block-floppyc-convert-some-include-asm-to-include-linux.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block/floppy.c: convert some #include <asm/ to #include <linux/
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-convert-some-include-asm-to-include-linux drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-convert-some-include-asm-to-include-linux
+++ a/drivers/block/floppy.c
@@ -180,6 +180,8 @@ static int print_unex = 1;
 #include <linux/mod_devicetable.h>
 #include <linux/buffer_head.h>	/* for invalidate_buffers() */
 #include <linux/mutex.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
 /*
  * PS/2 floppies have much slower step rates than regular floppies.
@@ -191,8 +193,6 @@ static int slow_floppy;
 #include <asm/dma.h>
 #include <asm/irq.h>
 #include <asm/system.h>
-#include <asm/io.h>
-#include <asm/uaccess.h>
 
 static int FLOPPY_IRQ = 6;
 static int FLOPPY_DMA = 2;
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-scsi-chc-dont-use-vprintk-as-macro.patch
vsprintfc-use-noinline_for_stack.patch

