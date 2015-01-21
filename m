From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-memcontrol-default-hierarchy-interface-for-memory-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 20 Jan 2015 16:21:44 -0800
Message-ID: <54bef118.BSuMA2PrwWLlbkau%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48593 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbbAUAVp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Jan 2015 19:21:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-default-hierarchy-interface-for-memory-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-default-hierarchy-interface-for-memory-checkpatch-fixes.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcontrol-default-hierarchy-interface-for-memory-checkpatch-fixes

WARNING: Prefer seq_puts to seq_printf
#315: FILE: mm/memcontrol.c:5340:
+		seq_printf(m, "none\n");

WARNING: Prefer seq_puts to seq_printf
#349: FILE: mm/memcontrol.c:5374:
+		seq_printf(m, "none\n");

WARNING: Prefer seq_puts to seq_printf
#383: FILE: mm/memcontrol.c:5408:
+		seq_printf(m, "none\n");

total: 0 errors, 3 warnings, 431 lines checked

./patches/mm-memcontrol-default-hierarchy-interface-for-memory.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-default-hierarchy-interface-for-memory-checkpatch-fixes mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-default-hierarchy-interface-for-memory-checkpatch-fixes
+++ a/mm/memcontrol.c
@@ -5337,7 +5337,7 @@ static int memory_low_show(struct seq_fi
 	unsigned long low = ACCESS_ONCE(memcg->low);
 
 	if (low == 0)
-		seq_printf(m, "none\n");
+		seq_puts(m, "none\n");
 	else
 		seq_printf(m, "%llu\n", (u64)low * PAGE_SIZE);
 
@@ -5371,7 +5371,7 @@ static int memory_high_show(struct seq_f
 	unsigned long high = ACCESS_ONCE(memcg->high);
 
 	if (high == PAGE_COUNTER_MAX)
-		seq_printf(m, "none\n");
+		seq_puts(m, "none\n");
 	else
 		seq_printf(m, "%llu\n", (u64)high * PAGE_SIZE);
 
@@ -5405,7 +5405,7 @@ static int memory_max_show(struct seq_fi
 	unsigned long max = ACCESS_ONCE(memcg->memory.limit);
 
 	if (max == PAGE_COUNTER_MAX)
-		seq_printf(m, "none\n");
+		seq_puts(m, "none\n");
 	else
 		seq_printf(m, "%llu\n", (u64)max * PAGE_SIZE);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
mm.patch
mm-vmstatc-fix-cleanup-ifdefs.patch
mm-vmstatc-fix-cleanup-ifdefs-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
vmscan-force-scan-offline-memory-cgroups-fix.patch
mm-memcontrol-fold-move_anon-and-move_file-fix.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix.patch
rtc-rk808-fix-the-rtc-time-reading-issue-fix.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
linux-next.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-fix-xip-fault-vs-truncate-race-fix-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix-3.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-3.patch
dax-add-dax_zero_page_range-fix.patch
ext4-add-dax-functionality-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

