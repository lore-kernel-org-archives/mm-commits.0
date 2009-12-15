From: akpm@linux-foundation.org
Subject: [folded] mm-hugetlb-fix-hugepage-memory-leak-in-mincore-cleanup.patch removed from -mm tree
Date: Mon, 14 Dec 2009 17:04:30 -0800
Message-ID: <200912150104.nBF14VVm004752@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45108 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758417AbZLOBEg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 20:04:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     mm-hugetlb-fix-hugepage-memory-leak-in-mincore-cleanup
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-hugepage-memory-leak-in-mincore-cleanup.patch

This patch was dropped because it was folded into mm-hugetlb-fix-hugepage-memory-leak-in-mincore.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-hugetlb-fix-hugepage-memory-leak-in-mincore-cleanup
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/mincore.c~mm-hugetlb-fix-hugepage-memory-leak-in-mincore-cleanup mm/mincore.c
--- a/mm/mincore.c~mm-hugetlb-fix-hugepage-memory-leak-in-mincore-cleanup
+++ a/mm/mincore.c
@@ -77,6 +77,7 @@ static long do_mincore(unsigned long add
 		struct hstate *h;
 		unsigned long nr_huge;
 		unsigned char present;
+
 		i = 0;
 		nr = min(pages, (vma->vm_end - addr) >> PAGE_SHIFT);
 		h = hstate_vma(vma);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
mm-mlocking-in-try_to_unmap_one.patch
mm-memory_hotplug-make-offline_pages-static.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore.patch
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

