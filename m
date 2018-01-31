From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix.patch
 removed from -mm tree
Date: Wed, 31 Jan 2018 15:49:10 -0800
Message-ID: <5a7255f6.+75mUpbz5WvsBhVA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56034 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754094AbeAaXtL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 18:49:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, pasha.tatashin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix
has been removed from the -mm tree.  Its filename was
     mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix.patch

This patch was dropped because it was folded into mm-split-deferred_init_range-into-initializing-and-freeing-parts.patch

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

include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-split-deferred_init_range-into-initializing-and-freeing-parts.patch
mm-do-not-stall-register_shrinker-fix.patch
sparc64-update-pmdp_invalidate-to-return-old-pmd-value-fix.patch
x86-mm-provide-pmdp_establish-helper-fix.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix-checkpatch-fixes.patch
mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix.patch
mm-zsmalloc-simplify-shrinker-init-destroy-fix.patch
mm-fadvise-discard-partial-page-if-endbyte-is-also-eof-fix.patch
mm-page_owner-clean-up-init_pages_in_zone-v3-fix.patch
tools-vm-new-option-to-specify-kpageflags-file-fix.patch

