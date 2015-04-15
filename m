From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-uninline-and-cleanup-page-mapping-related-helpers-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 15 Apr 2015 15:42:01 -0700
Message-ID: <552ee939.w4vqydFnUzUUSF22%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51927 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756727AbbDOWmC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 18:42:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-uninline-and-cleanup-page-mapping-related-helpers-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-uninline-and-cleanup-page-mapping-related-helpers-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-uninline-and-cleanup-page-mapping-related-helpers.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-uninline-and-cleanup-page-mapping-related-helpers-checkpatch-fixes

ERROR: "foo * bar" should be "foo *bar"
#73: FILE: mm/util.c:328:
+static inline void * __page_rmapping(struct page *page)

total: 1 errors, 0 warnings, 90 lines checked

./patches/mm-uninline-and-cleanup-page-mapping-related-helpers.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/util.c~mm-uninline-and-cleanup-page-mapping-related-helpers-checkpatch-fixes mm/util.c
--- a/mm/util.c~mm-uninline-and-cleanup-page-mapping-related-helpers-checkpatch-fixes
+++ a/mm/util.c
@@ -325,7 +325,7 @@ void kvfree(const void *addr)
 }
 EXPORT_SYMBOL(kvfree);
 
-static inline void * __page_rmapping(struct page *page)
+static inline void *__page_rmapping(struct page *page)
 {
 	unsigned long mapping;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
document-interaction-between-compaction-and-the-unevictable-lru.patch
mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp.patch
mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation.patch
mm-mmapc-use-while-instead-of-ifgoto.patch
mm-hugetlb-introduce-pagehugeactive-flag.patch
mm-hugetlb-cleanup-using-pagehugeactive-flag.patch
mm-memblock-add-debug-output-for-the-memblock_add.patch
mm-uninline-and-cleanup-page-mapping-related-helpers.patch
mm-cma-add-functions-to-get-region-pages-counters-fix.patch
mm-cma_debugc-remove-blank-lines-before-define_simple_attribute.patch
mm-memory-print-also-a_ops-readpage-in-print_bad_pte-fix.patch
mm-compactionc-fix-suitable_migration_target-unused-warning.patch
zsmalloc-support-compaction-fix.patch
proc-pid-status-show-all-sets-of-pid-according-to-ns-fix.patch
kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch
lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch

