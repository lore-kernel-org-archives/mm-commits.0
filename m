From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 =?US-ASCII?Q?mm-free=5Farea=5Finit-allow-defining-max=5Fzone=5Fpfn-in-?=
 =?US-ASCII?Q?descending-order-fix-2-fix.patch?= added to -mm tree
Date: Tue, 19 May 2020 17:08:03 -0700
Message-ID: <20200520000803.nAiIuQa1X%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728145AbgETAIE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 May 2020 20:08:04 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, rppt@linux.ibm.com, Vineet.Gupta1@synopsys.com


The patch titled
     Subject: mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order-fix-2-fix
has been added to the -mm tree.  Its filename is
     mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order-fix-2-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order-fix-2-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order-fix-2-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order-fix-2-fix

declare arch_has_descending_max_zone_pfns().

Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/mm.h~mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order-fix-2-fix
+++ a/include/linux/mm.h
@@ -2464,6 +2464,7 @@ extern void setup_per_cpu_pageset(void);
 extern int min_free_kbytes;
 extern int watermark_boost_factor;
 extern int watermark_scale_factor;
+extern bool arch_has_descending_max_zone_pfns(void);
 
 /* nommu.c */
 extern atomic_long_t mmap_pages_allocated;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch
mm-slub-add-panic_on_error-to-the-debug-facilities-fix.patch
mm-gupc-updating-the-documentation-fix.patch
mm-swapfilec-classify-swap_map_xxx-to-make-it-more-readable-fix.patch
mm-remove-__vmalloc_node_flags_caller-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix-fix.patch
mm-remove-vmalloc_user_node_flags-fix.patch
mm-vmalloc-track-which-page-table-levels-were-modified-fix.patch
mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order-fix-2-fix.patch
arch-kunmap-remove-duplicate-kunmap-implementations-fix.patch
arch-kmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
arch-kunmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
kmap-consolidate-kmap_prot-definitions-checkpatch-fixes.patch
mm-add-debug_wx-support-fix.patch
riscv-support-debug_wx-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
seq_file-introduce-define_seq_attribute-helper-macro-checkpatch-fixes.patch
ipc-convert-ipcs_idr-to-xarray-update-fix.patch
linux-next-rejects.patch
kernel-add-panic_on_taint-fix.patch
mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api-fix-2-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix-fix.patch
doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
