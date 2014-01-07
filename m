From: akpm@linux-foundation.org
Subject: [to-be-updated]
 dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors-fix.patch removed from -mm tree
Date: Tue, 07 Jan 2014 14:33:51 -0800
Message-ID: <52cc80cf.b+5IC7ZylHI6cegB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59865 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbaAGWdw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jan 2014 17:33:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, shuah.kh@samsung.com, joro@8bytes.org, dan.carpenter@oracle.com, alexander.h.duyck@intel.com, akpm@linux-foundation.org

Subject: [to-be-updated] dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,alexander.h.duyck@intel.com,dan.carpenter@oracle.com,joro@8bytes.org,shuah.kh@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 07 Jan 2014 14:33:51 -0800


The patch titled
     Subject: dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors-fix
has been removed from the -mm tree.  Its filename was
     dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors-fix

Per Shuah: "dev_warn() on line 740 should use dev not entry->dev"

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Shuah Khan <shuah.kh@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dma-debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/dma-debug.c~dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors-fix lib/dma-debug.c
--- a/lib/dma-debug.c~dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors-fix
+++ a/lib/dma-debug.c
@@ -737,7 +737,7 @@ static int device_dma_allocations(struct
 	local_irq_restore(flags);
 
 	if (map_err_cnt)
-		dev_warn(entry->dev,
+		dev_warn(dev,
 			"DMA-API: device driver failed to check map errors: "
 			"[count] = %d\n", map_err_cnt);
 	return count;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
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
numa-add-a-sysctl-for-numa_balancing-fix.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
printk-flush-conflicting-continuation-line-fix.patch
lib-percpu_counterc-disable-local-irq-when-updating-percpu-couter.patch
drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch
linux-next.patch
linux-next-git-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

