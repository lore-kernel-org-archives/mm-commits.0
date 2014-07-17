From: akpm@linux-foundation.org
Subject: [obsolete]
 mm-vmscan-clean-up-struct-scan_control-checkpatch-fixes.patch removed from
 -mm tree
Date: Thu, 17 Jul 2014 14:45:54 -0700
Message-ID: <53c84412.H1WafxBU9pQMe6dt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:52320 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834AbaGQVpz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Jul 2014 17:45:55 -0400
Received: by mail-pd0-f201.google.com with SMTP id g10so540440pdj.2
        for <mm-commits@vger.kernel.org>; Thu, 17 Jul 2014 14:45:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmscan-clean-up-struct-scan_control-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-vmscan-clean-up-struct-scan_control-checkpatch-fixes.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmscan-clean-up-struct-scan_control-checkpatch-fixes

ERROR: code indent should use tabs where possible
#268: FILE: mm/vmscan.c:2713:
+^I^I            (GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK),$

ERROR: code indent should use tabs where possible
#302: FILE: mm/vmscan.c:2754:
+^I^I            (GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK),$

ERROR: code indent should use tabs where possible
#369: FILE: mm/vmscan.c:3410:
+^I^I         MAY_SKIP_CONGESTION,$

total: 3 errors, 0 warnings, 340 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/mm-vmscan-clean-up-struct-scan_control.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-clean-up-struct-scan_control-checkpatch-fixes mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-clean-up-struct-scan_control-checkpatch-fixes
+++ a/mm/vmscan.c
@@ -2710,7 +2710,7 @@ unsigned long mem_cgroup_shrink_node_zon
 	struct scan_control sc = {
 		.nr_to_reclaim = SWAP_CLUSTER_MAX,
 		.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
-		            (GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK),
+			    (GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK),
 		.target_mem_cgroup = memcg,
 		.flags = MAY_UNMAP,
 	};
@@ -2751,7 +2751,7 @@ unsigned long try_to_free_mem_cgroup_pag
 	struct scan_control sc = {
 		.nr_to_reclaim = SWAP_CLUSTER_MAX,
 		.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
-		            (GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK),
+			    (GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK),
 		.target_mem_cgroup = memcg,
 		.priority = DEF_PRIORITY,
 		.flags = MAY_UNMAP,
@@ -3407,7 +3407,7 @@ unsigned long shrink_all_memory(unsigned
 		.gfp_mask = GFP_HIGHUSER_MOVABLE,
 		.priority = DEF_PRIORITY,
 		.flags = MAY_WRITEPAGE | MAY_UNMAP | MAY_SWAP |
-		         MAY_SKIP_CONGESTION,
+			 MAY_SKIP_CONGESTION,
 	};
 	struct zonelist *zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
 	struct task_struct *p = current;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
revert-fs-seq_file-fallback-to-vmalloc-allocation.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
kbuild-explain-stack-protector-strong-config-logic.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
mm.patch
slub-use-new-node-functions-checkpatch-fixes.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
include-linux-mmdebugh-add-vm_warn_once.patch
mm-catch-memory-commitment-underflow-fix.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
lib-list_sortc-convert-to-pr_foo.patch
lib-list_sortc-convert-to-pr_foo-fix.patch
checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch
fs-isofs-logging-clean-up-fix.patch
proc-remove-proc_tty_ldisc-variable-fix.patch
mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix-fix.patch
kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes.patch
kexec-support-kexec-kdump-on-efi-systems-fix.patch
panic-add-taint_softlockup-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

