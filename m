From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-pass-task-and-mm-to-do_madvise-fix-fix-fix-fix.patch removed from -mm
 tree
Date: Wed, 29 Apr 2020 18:04:03 -0700
Message-ID: <20200430010403.RPy39JT6Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726279AbgD3BEE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 29 Apr 2020 21:04:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, mm-commits@vger.kernel.org, rdunlap@infradead.org


The patch titled
     Subject: mm-pass-task-and-mm-to-do_madvise-fix-fix-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-pass-task-and-mm-to-do_madvise-fix-fix-fix-fix.patch

This patch was dropped because it was folded into mm-pass-task-and-mm-to-do_madvise.patch

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm-pass-task-and-mm-to-do_madvise-fix-fix-fix-fix

add missing includes

Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/madvise.c~mm-pass-task-and-mm-to-do_madvise-fix-fix-fix-fix
+++ a/mm/madvise.c
@@ -22,12 +22,14 @@
 #include <linux/file.h>
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
+#include <linux/compat.h>
 #include <linux/pagewalk.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
 #include <linux/shmem_fs.h>
 #include <linux/mmu_notifier.h>
 #include <linux/sched/mm.h>
+#include <linux/uio.h>
 
 #include <asm/tlb.h>
 
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-pass-task-and-mm-to-do_madvise.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix.patch
