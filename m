From: akpm@linux-foundation.org
Subject: + mm-fix-kernel-crash-in-khugepaged-thread-fix.patch added to -mm tree
Date: Wed, 20 Jan 2016 16:01:44 -0800
Message-ID: <56a01fe8.FfMOqrk+uvvIjqTm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47921 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbcAUABp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jan 2016 19:01:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gorcunov@gmail.com, kirill.shutemov@linux.intel.com, rientjes@google.com, vbabka@suse.cz, yalin.wang2010@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-kernel-crash-in-khugepaged-thread-fix
has been added to the -mm tree.  Its filename is
     mm-fix-kernel-crash-in-khugepaged-thread-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-kernel-crash-in-khugepaged-thread-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-kernel-crash-in-khugepaged-thread-fix.patch

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

fs-overlayfs-superc-needs-pagemaph.patch
fs-adfs-adfsh-tidy-up-comments.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm-fix-kernel-crash-in-khugepaged-thread-fix.patch
numa-fix-proc-pid-numa_maps-on-s390-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
mm.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
sched-add-schedule_timeout_idle.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-huge_mmh-pmd_trans_huge_lock-returns-a-spinlock_t.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

