From: akpm@linux-foundation.org
Subject: [obsolete]
 mm-remove-duplicated-include-from-madvisec.patch removed from -mm tree
Date: Thu, 11 Jun 2020 09:14:44 -0700
Message-ID: <20200611161444.cWW_ZbZmC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725824AbgFKQOp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Jun 2020 12:14:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jrdr.linux@gmail.com, mm-commits@vger.kernel.org, yuehaibing@huawei.com


The patch titled
     Subject: mm/madvise.c: remove duplicated include
has been removed from the -mm tree.  Its filename was
     mm-remove-duplicated-include-from-madvisec.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: YueHaibing <yuehaibing@huawei.com>
Subject: mm/madvise.c: remove duplicated include

Remove duplicated include.

Link: http://lkml.kernel.org/r/20200505100049.191351-1-yuehaibing@huawei.com
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Souptick Joarder <jrdr.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/madvise.c~mm-remove-duplicated-include-from-madvisec
+++ a/mm/madvise.c
@@ -29,7 +29,6 @@
 #include <linux/swapops.h>
 #include <linux/shmem_fs.h>
 #include <linux/mmu_notifier.h>
-#include <linux/sched/mm.h>
 #include <linux/uio.h>
 
 #include <asm/tlb.h>
_

Patches currently in -mm which might be from yuehaibing@huawei.com are
