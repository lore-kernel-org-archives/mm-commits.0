From: akpm@linux-foundation.org
Subject: +
 mm-compaction-always-update-cached-scanner-positions-fix-checkpatch-fixes.patch added to -mm tree
Date: Tue, 18 Nov 2014 14:30:28 -0800
Message-ID: <546bc884.ovcsAz1Vf32V/S6k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37452 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243AbaKRWa3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Nov 2014 17:30:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-always-update-cached-scanner-positions-fix-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-compaction-always-update-cached-scanner-positions-fix-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-always-update-cached-scanner-positions-fix-checkpatch-fixes.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-always-update-cached-scanner-positions-fix-checkpatch-fixes.patch

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
Subject: mm-compaction-always-update-cached-scanner-positions-fix-checkpatch-fixes

WARNING: Missing a blank line after declarations
#65: FILE: mm/compaction.c:1243:
+		unsigned long free_pfn = release_freepages(&cc->freepages);
+		cc->nr_freepages = 0;

total: 0 errors, 1 warnings, 47 lines checked

./patches/mm-compaction-always-update-cached-scanner-positions-fix.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-compaction-always-update-cached-scanner-positions-fix-checkpatch-fixes mm/compaction.c
--- a/mm/compaction.c~mm-compaction-always-update-cached-scanner-positions-fix-checkpatch-fixes
+++ a/mm/compaction.c
@@ -1240,8 +1240,8 @@ out:
 	 */
 	if (cc->nr_freepages > 0) {
 		unsigned long free_pfn = release_freepages(&cc->freepages);
-		cc->nr_freepages = 0;
 
+		cc->nr_freepages = 0;
 		VM_BUG_ON(free_pfn == 0);
 		/* The cached pfn is always the first in a pageblock */
 		free_pfn &= ~(pageblock_nr_pages-1);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix.patch
mm.patch
slab-improve-checking-for-invalid-gfp_flags.patch
mm-memcontrol-lockless-page-counters-fix.patch
mm-memcontrol-lockless-page-counters-fix-fix.patch
kernel-res_counter-remove-the-unused-api-fix.patch
mm-compaction-simplify-deferred-compaction-fix.patch
mm-compaction-always-update-cached-scanner-positions-fix-checkpatch-fixes.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-mincore-add-hwpoison-page-handle-checkpatch-fixes.patch
mm-page_alloc-store-updated-page-migratetype-to-avoid-misusing-stale-value-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
fs-proc-use-a-rb-tree-for-the-directory-entries-fix.patch
fs-binfmt_miscc-use-gfp_kernel-instead-of-gfp_user.patch
init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails-checkpatch-fixes.patch
rtc-omap-add-support-for-pmic_power_en-v3-fix.patch
drivers-rtc-rtc-sirfsocc-add-alarm_irq_enable-support-fix.patch
sysctl-terminate-strings-also-on-r-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation-fix.patch
tools-testing-selftests-makefile-alphasort-the-targets-list.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

