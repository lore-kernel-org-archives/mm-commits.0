From: akpm@linux-foundation.org
Subject: + hwpoison-soft-offlining-for-non-lru-movable-page-fix-fix.patch
 added to -mm tree
Date: Wed, 25 Jan 2017 15:28:11 -0800
Message-ID: <5889348b.dKrR5XzIDs4m8Hnc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50752 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751203AbdAYX2M (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2017 18:28:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: hwpoison-soft-offlining-for-non-lru-movable-page-fix-fix
has been added to the -mm tree.  Its filename is
     hwpoison-soft-offlining-for-non-lru-movable-page-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hwpoison-soft-offlining-for-non-lru-movable-page-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hwpoison-soft-offlining-for-non-lru-movable-page-fix-fix.patch

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
dax-enable-iostat-for-read-write-fix.patch
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
hwpoison-soft-offlining-for-non-lru-movable-page-fix-fix.patch
linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch
linux-next-rejects.patch
reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

