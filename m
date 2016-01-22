From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-fix-kernel-crash-in-khugepaged-thread-fix.patch removed from -mm tree
Date: Thu, 21 Jan 2016 16:37:14 -0800
Message-ID: <56a179ba.ON0i7L9E1jVlmgTD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40953 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbcAVAhP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 19:37:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gorcunov@gmail.com, kirill.shutemov@linux.intel.com, rientjes@google.com, vbabka@suse.cz, yalin.wang2010@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-kernel-crash-in-khugepaged-thread-fix
has been removed from the -mm tree.  Its filename was
     mm-fix-kernel-crash-in-khugepaged-thread-fix.patch

This patch was dropped because it was folded into mm-fix-kernel-crash-in-khugepaged-thread.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-fix-kernel-crash-in-khugepaged-thread-fix

fix fat-fingered merge resolution

Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: yalin wang <yalin.wang2010@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/huge_memory.c~mm-fix-kernel-crash-in-khugepaged-thread-fix mm/huge_memory.c
--- a/mm/huge_memory.c~mm-fix-kernel-crash-in-khugepaged-thread-fix
+++ a/mm/huge_memory.c
@@ -2580,7 +2580,7 @@ out_unmap:
 		collapse_huge_page(mm, address, hpage, vma, node);
 	}
 out:
-	trace_mm_khugepaged_scan_pmd(mm, page_to_pfn(page), writable, referenced,
+	trace_mm_khugepaged_scan_pmd(mm, page, writable, referenced,
 				     none_or_zero, result);
 	return ret;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-fix-kernel-crash-in-khugepaged-thread.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
numa-fix-proc-pid-numa_maps-on-s390-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
mm.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
sched-add-schedule_timeout_idle.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-huge_mmh-pmd_trans_huge_lock-returns-a-spinlock_t.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

