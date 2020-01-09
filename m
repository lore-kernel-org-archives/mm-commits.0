From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Thu, 09 Jan 2020 11:21:07 -0800
Message-ID: <20200109192107.507bFpEpi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726048AbgAITVI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Jan 2020 14:21:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi-dw.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/spi/spi-dw.c~linux-next-git-rejects
+++ a/drivers/spi/spi-dw.c
@@ -296,12 +296,9 @@ static int dw_spi_transfer_one(struct sp
 	dws->rx_end = dws->rx + transfer->len;
 	dws->len = transfer->len;
 	spin_unlock_irqrestore(&dws->buf_lock, flags);
-<<<<<<< HEAD
-=======
 
 	/* Ensure dw->rx and dw->rx_end are visible */
 	smp_mb();
->>>>>>> linux-next/akpm-base
 
 	spi_enable_chip(dws, 0);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-oom-avoid-printk-iteration-under-rcu-fix.patch
linux-next-fix.patch
drivers-block-null_blk_mainc-fix-layout.patch
drivers-block-null_blk_mainc-fix-uninitialized-var-warnings.patch
proc-convert-everything-to-struct-proc_ops-fix.patch
bitops-more-bits_to_-macros-fix.patch
bitops-more-bits_to_-macros-fix-fix.patch
drivers-tty-serial-sh-scic-suppress-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
