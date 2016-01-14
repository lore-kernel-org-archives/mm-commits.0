From: akpm@linux-foundation.org
Subject: + thp-reintroduce-split_huge_page-fix.patch added to -mm tree
Date: Thu, 14 Jan 2016 13:35:00 -0800
Message-ID: <56981484.UAmtm8LDH4H3hFCy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41856 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523AbcANVfB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 16:35:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp-reintroduce-split_huge_page-fix
has been added to the -mm tree.  Its filename is
     thp-reintroduce-split_huge_page-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-reintroduce-split_huge_page-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-reintroduce-split_huge_page-fix.patch

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
Subject: thp-reintroduce-split_huge_page-fix

make thp-reintroduce-split_huge_page.patch work without mm-make-optimistic-check-for-swapin-readahead.patch

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/huge_mm.h~thp-reintroduce-split_huge_page-fix include/linux/huge_mm.h
diff -puN include/linux/pagemap.h~thp-reintroduce-split_huge_page-fix include/linux/pagemap.h
diff -puN mm/huge_memory.c~thp-reintroduce-split_huge_page-fix mm/huge_memory.c
--- a/mm/huge_memory.c~thp-reintroduce-split_huge_page-fix
+++ a/mm/huge_memory.c
@@ -16,6 +16,7 @@
 #include <linux/swap.h>
 #include <linux/shrinker.h>
 #include <linux/mm_inline.h>
+#include <linux/swapops.h>
 #include <linux/dax.h>
 #include <linux/kthread.h>
 #include <linux/khugepaged.h>
diff -puN mm/internal.h~thp-reintroduce-split_huge_page-fix mm/internal.h
diff -puN mm/rmap.c~thp-reintroduce-split_huge_page-fix mm/rmap.c
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ocfs2-fix-slot-overwritten-if-storage-link-down-during-mount-checkpatch-fixes.patch
include-linux-dcacheh-remove-semicolons-from-hash_len_declare.patch
account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch
include-define-__phys_to_pfn-as-phys_pfn-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2.patch
mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes.patch
mm-zonelist-enumerate-zonelists-array-index-fix.patch
mm-get-rid-of-__alloc_pages_high_priority-checkpatch-fixes.patch
mm-vmalloc-remove-vm_vpages-fix.patch
fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch
arm64-mm-support-arch_mmap_rnd_bits-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
thp-reintroduce-split_huge_page-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
thp-add-debugfs-handle-to-split-all-huge-pages-fix.patch
mm-support-madvisemadv_free-fix-2-fix.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2-fix-3.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
sched-add-schedule_timeout_idle.patch
mm-mlockc-change-can_do_mlock-return-value-type-to-boolean-fix.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
mm-hugetlbfs-unmap-pages-if-page-fault-raced-with-hole-punch-fix.patch
mm-soft-offline-exit-with-failure-for-non-anonymous-thp-fix.patch

