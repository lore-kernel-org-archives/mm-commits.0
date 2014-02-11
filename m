From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Tue, 11 Feb 2014 11:22:54 -0800
Message-ID: <52fa788e.NzuXzjD1utq1LcBw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40825 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbaBKTWz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Feb 2014 14:22:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: + linux-next-git-rejects.patch added to -mm tree
To: akpm@linux-foundation.org
From: akpm@linux-foundation.org
Date: Tue, 11 Feb 2014 11:22:54 -0800


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |    4 ----
 mm/slub.c                      |   10 ++--------
 2 files changed, 2 insertions(+), 12 deletions(-)

diff -puN arch/x86/include/asm/pgtable.h~linux-next-git-rejects arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~linux-next-git-rejects
+++ a/arch/x86/include/asm/pgtable.h
@@ -449,11 +449,7 @@ static inline int pteval_present(pteval_
 {
 	/*
 	 * Yes Linus, _PAGE_PROTNONE == _PAGE_NUMA. Expressing it this
-<<<<<<< HEAD
-	 * way clearly states that the intent is that protnone and numa
-=======
 	 * way clearly states that the intent is that a protnone and numa
->>>>>>> linux-next/akpm-base
 	 * hinting ptes are considered present for the purposes of
 	 * pagetable operations like zapping, protection changes, gup etc.
 	 */
diff -puN mm/slub.c~linux-next-git-rejects mm/slub.c
--- a/mm/slub.c~linux-next-git-rejects
+++ a/mm/slub.c
@@ -1004,16 +1004,10 @@ static inline void slab_free_hook(struct
 static void add_full(struct kmem_cache *s,
 	struct kmem_cache_node *n, struct page *page)
 {
-<<<<<<< HEAD
-=======
-	if (kmem_cache_debug(s))
-		lockdep_assert_held(&n->list_lock);
-
->>>>>>> linux-next/akpm-base
 	if (!(s->flags & SLAB_STORE_USER))
 		return;
-
-	lockdep_assert_held(&n->list_lock);
+	if (kmem_cache_debug(s))
+		lockdep_assert_held(&n->list_lock);
 	list_add(&page->lru, &n->full);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
linux-next-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

