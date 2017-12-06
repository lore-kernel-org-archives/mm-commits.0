From: akpm@linux-foundation.org
Subject: +
 mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix.patch
 added to -mm tree
Date: Tue, 05 Dec 2017 16:37:08 -0800
Message-ID: <5a273bb4.zmRn54JNcGAOHN17%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35566 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753125AbdLFAhJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Dec 2017 19:37:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, pasha.tatashin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix
has been added to the -mm tree.  Its filename is
     mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix.patch

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
Subject: mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix

fix spello in comment

Cc: Pavel Tatashin <pasha.tatashin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix
+++ a/mm/page_alloc.c
@@ -1457,7 +1457,7 @@ static inline void __init pgdat_init_rep
 }
 
 /*
- * Returns true if page needs to be initialized of freed to buddy allocator.
+ * Returns true if page needs to be initialized or freed to buddy allocator.
  *
  * First we check if pfn is valid on architectures where it is possible to have
  * holes within pageblock_nr_pages. On systems where it is not possible, this
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-kmemleakc-make-cond_resched-rate-limiting-more-efficient.patch
stringh-work-around-for-increased-stack-usage-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix.patch
mm-do-not-stall-register_shrinker-fix.patch
selftest-vm-move-128tb-mmap-boundary-test-to-generic-directory-fix.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

