From: akpm@linux-foundation.org
Subject: + mm-pass-task-and-mm-to-do_madvise-fix-fix-fix-fix.patch
 added to -mm tree
Date: Mon, 27 Apr 2020 13:45:35 -0700
Message-ID: <20200427204535.wvSf6m8o4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726420AbgD0Upg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Apr 2020 16:45:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, mm-commits@vger.kernel.org, rdunlap@infradead.org


The patch titled
     Subject: mm-pass-task-and-mm-to-do_madvise-fix-fix-fix-fix
has been added to the -mm tree.  Its filename is
     mm-pass-task-and-mm-to-do_madvise-fix-fix-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-pass-task-and-mm-to-do_madvise-fix-fix-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-pass-task-and-mm-to-do_madvise-fix-fix-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-pass-task-and-mm-to-do_madvise-fix-fix-fix-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix.patch
