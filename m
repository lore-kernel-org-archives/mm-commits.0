From: akpm@linux-foundation.org
Subject: [merged] drivers-block-floppyc-remove-define-device_name-floppy.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:54:16 -0400
Message-ID: <201003150654.o2F6snSf016093@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38885 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758870Ab0COGyz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:54:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/floppy.c: remove #define DEVICE_NAME "floppy"
has been removed from the -mm tree.  Its filename was
     drivers-block-floppyc-remove-define-device_name-floppy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block/floppy.c: remove #define DEVICE_NAME "floppy"
From: Joe Perches <joe@perches.com>

Use it directly in the one place it's used.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-remove-define-device_name-floppy drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-remove-define-device_name-floppy
+++ a/drivers/block/floppy.c
@@ -250,8 +250,6 @@ static int allowed_drive_mask = 0x33;
 
 static int irqdma_allocated;
 
-#define DEVICE_NAME "floppy"
