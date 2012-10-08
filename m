From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Mon, 08 Oct 2012 11:52:23 -0700
Message-ID: <20121008185235.B08451E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:46671 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab2JHSwi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Oct 2012 14:52:38 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so356498qae.1
        for <mm-commits@vger.kernel.org>; Mon, 08 Oct 2012 11:52:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mfd/88pm860x.h |    3 ---
 init/Kconfig                 |    4 +---
 2 files changed, 1 insertion(+), 6 deletions(-)

diff -puN include/linux/mfd/88pm860x.h~linux-next-git-rejects include/linux/mfd/88pm860x.h
--- a/include/linux/mfd/88pm860x.h~linux-next-git-rejects
+++ a/include/linux/mfd/88pm860x.h
@@ -440,10 +440,7 @@ struct pm860x_platform_data {
 	struct pm860x_rtc_pdata		*rtc;
 	struct pm860x_touch_pdata	*touch;
 	struct pm860x_power_pdata	*power;
-<<<<<<< HEAD
-=======
 	struct charger_desc		*chg_desc;
->>>>>>> linux-next/akpm-base
 	struct regulator_init_data	*buck1;
 	struct regulator_init_data	*buck2;
 	struct regulator_init_data	*buck3;
diff -puN init/Kconfig~linux-next-git-rejects init/Kconfig
--- a/init/Kconfig~linux-next-git-rejects
+++ a/init/Kconfig
@@ -1653,13 +1653,12 @@ config PADATA
 	depends on SMP
 	bool
 
-<<<<<<< HEAD
 # Can be selected by architectures with broken toolchains
 # that get confused by correct const<->read_only section
 # mappings
 config BROKEN_RODATA
 	bool
-=======
+
 config ASN1
 	tristate
 	help
@@ -1667,6 +1666,5 @@ config ASN1
 	  that can be interpreted by the ASN.1 stream decoder and used to
 	  inform it as to what tags are to be expected in a stream and what
 	  functions to call on what tags.
->>>>>>> linux-next/akpm-base
 
 source "kernel/Kconfig.locks"
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
mm.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
rbtree-performance-and-correctness-test-fix.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix-fix.patch
mm-fix-tracing-in-free_pcppages_bulk-fix.patch
cma-count-free-cma-pages-fix.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch
atomic-implement-generic-atomic_dec_if_positive-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix-2.patch
mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible-fix-fix.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes.patch
mm-fix-invalidate_complete_page2-lock-ordering.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock.patch
cma-migrate-mlocked-pages-fix.patch
fs-block_devc-set_blocksize-use-mapping_mapped.patch
mm-avoid-section-mismatch-warning-for-memblock_type_name-fix.patch
mm-document-pagehuge-somewhat.patch
mm-memcg-clean-up-mm_match_cgroup-signature-fix.patch
memory-hotplug-suppress-trying-to-free-nonexistent-resource-xxxxxxxxxxxxxxxx-yyyyyyyyyyyyyyyy-warning.patch
mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code-fix.patch
idr-rename-max_level-to-max_idr_level-fix-3.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

