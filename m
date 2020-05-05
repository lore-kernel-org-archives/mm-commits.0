From: akpm@linux-foundation.org
Subject: + mm-remove-duplicated-include-from-madvisec.patch added
 to -mm tree
Date: Tue, 05 May 2020 12:46:45 -0700
Message-ID: <20200505194645.XTeTteSBu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728233AbgEETqq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 May 2020 15:46:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, yuehaibing@huawei.com


The patch titled
     Subject: mm/madvise.c: remove duplicated include
has been added to the -mm tree.  Its filename is
     mm-remove-duplicated-include-from-madvisec.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-duplicated-include-from-madvisec.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-duplicated-include-from-madvisec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: YueHaibing <yuehaibing@huawei.com>
Subject: mm/madvise.c: remove duplicated include

Remove duplicated include.

Link: http://lkml.kernel.org/r/20200505100049.191351-1-yuehaibing@huawei.com
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
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

mm-remove-duplicated-include-from-madvisec.patch
