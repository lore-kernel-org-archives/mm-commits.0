From: akpm@linux-foundation.org
Subject: [merged] drivers-block-floppyc-indent-a-comment.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:53:31 -0400
Message-ID: <201003150654.o2F6s41o016042@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54376 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934447Ab0COGyK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:54:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/floppy.c: indent a comment
has been removed from the -mm tree.  Its filename was
     drivers-block-floppyc-indent-a-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block/floppy.c: indent a comment
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-indent-a-comment drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-indent-a-comment
+++ a/drivers/block/floppy.c
@@ -4262,7 +4262,7 @@ static int __init floppy_init(void)
 		FDCS->dtr = -1;
 		FDCS->dor = 0x4;
 #if defined(__sparc__) || defined(__mc68000__)
-		/*sparcs/sun3x don't have a DOR reset which we can fall back on to */
+	/*sparcs/sun3x don't have a DOR reset which we can fall back on to */
 #ifdef __mc68000__
 		if (MACH_IS_SUN3X)
 #endif
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-scsi-chc-dont-use-vprintk-as-macro.patch
vsprintfc-use-noinline_for_stack.patch

