From: akpm@linux-foundation.org
Subject: [merged] drivers-block-floppyc-remove-unnecessary-return-and-braces.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:54:25 -0400
Message-ID: <201003150654.o2F6sw7A016112@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38625 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759624Ab0COGzF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:55:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/floppy.c: remove unnecessary return and braces
has been removed from the -mm tree.  Its filename was
     drivers-block-floppyc-remove-unnecessary-return-and-braces.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block/floppy.c: remove unnecessary return and braces
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-remove-unnecessary-return-and-braces drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-remove-unnecessary-return-and-braces
+++ a/drivers/block/floppy.c
@@ -1796,10 +1796,8 @@ static void recalibrate_floppy(void)
 	debugt("recalibrate floppy:");
 	do_floppy = recal_interrupt;
 	output_byte(FD_RECALIBRATE);
-	if (output_byte(UNIT(current_drive)) < 0) {
+	if (output_byte(UNIT(current_drive)) < 0)
 		reset_fdc();
-		return;
-	}
 }
 
 /*
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-scsi-chc-dont-use-vprintk-as-macro.patch
vsprintfc-use-noinline_for_stack.patch

