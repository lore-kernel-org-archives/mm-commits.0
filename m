From: akpm@linux-foundation.org
Subject: +
 mm-zpool-zpool_evictable-fix-mismatch-in-parameter-name-and-kernel-doc-fix.patch added to -mm tree
Date: Thu, 08 Feb 2018 11:53:12 -0800
Message-ID: <5a7caaa8.P3bzMrz4kdT0nfLx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53328 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752054AbeBHTxO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Feb 2018 14:53:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, rdunlap@infradead.org, rppt@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-zpool-zpool_evictable-fix-mismatch-in-parameter-name-and-kernel-doc-fix
has been added to the -mm tree.  Its filename is
     mm-zpool-zpool_evictable-fix-mismatch-in-parameter-name-and-kernel-doc-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zpool-zpool_evictable-fix-mismatch-in-parameter-name-and-kernel-doc-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zpool-zpool_evictable-fix-mismatch-in-parameter-name-and-kernel-doc-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-zpool-zpool_evictable-fix-mismatch-in-parameter-name-and-kernel-doc-fix

add colon, per Randy

Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zpool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/zpool.c~mm-zpool-zpool_evictable-fix-mismatch-in-parameter-name-and-kernel-doc-fix mm/zpool.c
--- a/mm/zpool.c~mm-zpool-zpool_evictable-fix-mismatch-in-parameter-name-and-kernel-doc-fix
+++ a/mm/zpool.c
@@ -360,7 +360,7 @@ u64 zpool_get_total_size(struct zpool *z
 
 /**
  * zpool_evictable() - Test if zpool is potentially evictable
- * @zpool	The zpool to test
+ * @zpool:	The zpool to test
  *
  * Zpool is only potentially evictable when it's created with struct
  * zpool_ops.evict and its driver implements struct zpool_driver.shrink.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
include-linux-sched-mmh-re-inline-mmdrop.patch
mm-zpool-zpool_evictable-fix-mismatch-in-parameter-name-and-kernel-doc-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2-fix.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

