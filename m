From: akpm@linux-foundation.org
Subject: [folded-merged]
 hwpoison-soft-offlining-for-non-lru-movable-page-fix-fix.patch removed from -mm tree
Date: Tue, 31 Jan 2017 14:42:09 -0800
Message-ID: <589112c1.wUVH1Tsol9pVzqax%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45532 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750805AbdAaWnG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2017 17:43:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: hwpoison-soft-offlining-for-non-lru-movable-page-fix-fix
has been removed from the -mm tree.  Its filename was
     hwpoison-soft-offlining-for-non-lru-movable-page-fix-fix.patch

This patch was dropped because it was folded into hwpoison-soft-offlining-for-non-lru-movable-page.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hwpoison-soft-offlining-for-non-lru-movable-page-fix-fix

fix unrelated comment typo while in there


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/migrate.h~hwpoison-soft-offlining-for-non-lru-movable-page-fix-fix include/linux/migrate.h
--- a/include/linux/migrate.h~hwpoison-soft-offlining-for-non-lru-movable-page-fix-fix
+++ a/include/linux/migrate.h
@@ -10,7 +10,7 @@ typedef struct page *new_page_t(struct p
 typedef void free_page_t(struct page *page, unsigned long private);
 
 /*
- * Return values from addresss_space_operations.migratepage():
+ * Return values from address_space_operations.migratepage():
  * - negative errno on page migration failure;
  * - zero on page migration success;
  */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-throttle-show_mem-from-warn_alloc-fix.patch
userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing-fix-fix.patch
lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask-checkpatch-fixes.patch
mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath-fix.patch
mm-ksm-improve-deduplication-of-zero-pages-with-colouring-fix.patch
mm-track-active-portions-of-a-section-at-boot-fix.patch
mm-memory_hotplugc-unexport-__remove_pages.patch
hwpoison-soft-offlining-for-non-lru-movable-page.patch
z3fold-add-kref-refcounting-checkpatch-fixes.patch
linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

