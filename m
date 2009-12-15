From: akpm@linux-foundation.org
Subject: [folded] mm-mlocking-in-try_to_unmap_one-fix-fix.patch removed from -mm tree
Date: Mon, 14 Dec 2009 17:01:09 -0800
Message-ID: <200912150101.nBF119vM028548@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48267 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757449AbZLOBBi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 20:01:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Lee.Schermerhorn@hp.com, aarcange@redhat.com, andi@firstfloor.org, fengguang.wu@intel.com, hugh.dickins@tiscali.co.uk, ieidus@redhat.com, kamezawa.hiroyu@jp


The patch titled
     mm-mlocking-in-try_to_unmap_one-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-mlocking-in-try_to_unmap_one-fix-fix.patch

This patch was dropped because it was folded into mm-mlocking-in-try_to_unmap_one.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-mlocking-in-try_to_unmap_one-fix-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Andi Kleen <andi@firstfloor.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/rmap.c~mm-mlocking-in-try_to_unmap_one-fix-fix mm/rmap.c
--- a/mm/rmap.c~mm-mlocking-in-try_to_unmap_one-fix-fix
+++ a/mm/rmap.c
@@ -1070,7 +1070,7 @@ static int try_to_unmap_file(struct page
 	 * It's costly. Instead, later, page reclaim logic may call
 	 * try_to_unmap(TTU_MUNLOCK) and recover PG_mlocked lazily.
 	 */
-	if (MLOCK_PAGES && TTU_ACTION(flags) == TTU_MUNLOCK)
+	if (TTU_ACTION(flags) == TTU_MUNLOCK)
 		goto out;
 
 	list_for_each_entry(vma, &mapping->i_mmap_nonlinear,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
mm-mlocking-in-try_to_unmap_one.patch
mm-mlocking-in-try_to_unmap_one-fix-fix.patch
mm-memory_hotplug-make-offline_pages-static.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore-cleanup.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore-build-fix.patch
mm-hugetlb-add-hugepage-support-to-pagemap-build-fix.patch
procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm-cleanup.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch
rwsem-fix-rwsem_is_locked-bugs-fix.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-checkpatch-fixes.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-rename.patch
errh-add-helper-function-to-simplify-pointer-error-checking-fix.patch
cs5535-add-a-generic-mfgpt-driver-fix.patch
cs5535-add-a-generic-clock-event-mfgpt-driver-fix.patch
drivers-scsi-sym53c8xx_2-sym_gluec-rename-skip_spaces-to-sym_skip_spaces.patch
lib-introduce-strim-checkpatch-fixes.patch
blackfin-sd-host-controller-driver-fix.patch
blackfin-sd-host-controller-driver-fix-fix.patch
blackfin-sd-host-controller-driver-fix-fix-fix.patch
crc32-minor-optimizations-and-cleanup-checkpatch-fixes.patch
hwmon-w83627ehf-updates-checkpatch-fixes.patch
lis3-update-documentation-to-match-latest-changes-fix.patch

