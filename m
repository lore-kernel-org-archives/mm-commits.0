From: akpm@linux-foundation.org
Subject: [obsolete] tmpfs-implement-numa-node-interleaving-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:40:20 -0700
Message-ID: <20120601194020.569FFA026A@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:53268 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759139Ab2FATkV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:40:21 -0400
Received: by vcbfl13 with SMTP id fl13so245941vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:40:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, nzimmer@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs-implement-numa-node-interleaving-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     tmpfs-implement-numa-node-interleaving-checkpatch-fixes.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: tmpfs-implement-numa-node-interleaving-checkpatch-fixes

ERROR: space prohibited before that close parenthesis ')'
#46: FILE: mm/shmem.c:932:
+	return alloc_page_vma(gfp, &pvma, info->node_offset << PAGE_SHIFT );

total: 1 errors, 0 warnings, 22 lines checked

./patches/tmpfs-implement-numa-node-interleaving.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Nathan T Zimmer <nzimmer@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/shmem_fs.h~tmpfs-implement-numa-node-interleaving-checkpatch-fixes include/linux/shmem_fs.h
diff -puN mm/shmem.c~tmpfs-implement-numa-node-interleaving-checkpatch-fixes mm/shmem.c
--- a/mm/shmem.c~tmpfs-implement-numa-node-interleaving-checkpatch-fixes
+++ a/mm/shmem.c
@@ -929,7 +929,7 @@ static struct page *shmem_alloc_page(gfp
 	/*
 	 * alloc_page_vma() will drop the shared policy reference
 	 */
-	return alloc_page_vma(gfp, &pvma, info->node_offset << PAGE_SHIFT );
+	return alloc_page_vma(gfp, &pvma, info->node_offset << PAGE_SHIFT);
 }
 #else /* !CONFIG_NUMA */
 #ifdef CONFIG_TMPFS
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
tmpfs-implement-numa-node-interleaving-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
mm.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-fixes.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2-fix.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

