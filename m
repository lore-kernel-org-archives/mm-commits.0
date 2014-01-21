From: akpm@linux-foundation.org
Subject: + mm-improve-documentation-of-page_order-v2-fix.patch added to
 -mm tree
Date: Tue, 21 Jan 2014 11:56:29 -0800
Message-ID: <52ded0ed.S2ipBFMG3pAWFFsI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44074 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbaAUT4a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jan 2014 14:56:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mgorman@suse.de, akpm@linux-foundation.org

Subject: + mm-improve-documentation-of-page_order-v2-fix.patch added to -mm tree
To: akpm@linux-foundation.org,mgorman@suse.de
From: akpm@linux-foundation.org
Date: Tue, 21 Jan 2014 11:56:29 -0800


The patch titled
     Subject: mm-improve-documentation-of-page_order-v2-fix
has been added to the -mm tree.  Its filename is
     mm-improve-documentation-of-page_order-v2-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-improve-documentation-of-page_order-v2-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-improve-documentation-of-page_order-v2-fix.patch

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
Subject: mm-improve-documentation-of-page_order-v2-fix

tweaks

Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/internal.h~mm-improve-documentation-of-page_order-v2-fix mm/internal.h
--- a/mm/internal.h~mm-improve-documentation-of-page_order-v2-fix
+++ a/mm/internal.h
@@ -143,10 +143,10 @@ isolate_migratepages_range(struct zone *
 #endif
 
 /*
- * This functions returns the order of a free page in the buddy system. In
+ * This function returns the order of a free page in the buddy system. In
  * general, page_zone(page)->lock must be held by the caller to prevent the
- * page being allocated in parallel and returning garbage as the order. If the
- * caller does not hold page_zone(page)->lock, they must guarantee that the
+ * page from being allocated in parallel and returning garbage as the order.
+ * If a caller does not hold page_zone(page)->lock, it must guarantee that the
  * page cannot be allocated or merged in parallel.
  */
 static inline unsigned long page_order(struct page *page)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
posix_acl-uninlining.patch
mm.patch
mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path-fix-2.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix.patch
mm-show_mem-remove-show_mem_filter_page_count-fix.patch
mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes.patch
mm-add-overcommit_kbytes-sysctl-variable-fix.patch
mm-add-overcommit_kbytes-sysctl-variable-fix-2.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions-checkpatch-fixes.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock-checkpatch-fixes.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed-checkpatch-fixes.patch
mm-memblock-add-memblock-memory-allocation-apis-fix.patch
sched-add-tracepoints-related-to-numa-task-migration-fix.patch
mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch
mm-print-more-details-for-bad_page-fix.patch
mm-munlock-fix-potential-race-with-thp-page-split-fix.patch
mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix-fix.patch
memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path-fix.patch
numa-add-a-sysctl-for-numa_balancing-fix.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix.patch
mm-nobootmem-free_all_bootmem-again-fix-fix.patch
mm-improve-documentation-of-page_order-v2-fix.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
printk-flush-conflicting-continuation-line-fix.patch
drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch
ipcmsg-document-barriers-fix.patch
ipcmsg-document-barriers-fix-fix.patch
linux-next.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

