From: akpm@linux-foundation.org
Subject: [folded-merged] thp-fix-huge-zero-page-logic-for-page-with-pfn-==-0-fix.patch removed from -mm tree
Date: Mon, 29 Apr 2013 14:55:38 -0700
Message-ID: <20130429215539.00AEE31C022@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:44645 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758542Ab3D2Vzj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 17:55:39 -0400
Received: by mail-gg0-f201.google.com with SMTP id y3so469769ggc.2
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 14:55:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@intel.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp-fix-huge-zero-page-logic-for-page-with-pfn-==-0-fix
has been removed from the -mm tree.  Its filename was
     thp-fix-huge-zero-page-logic-for-page-with-pfn-==-0-fix.patch

This patch was dropped because it was folded into thp-fix-huge-zero-page-logic-for-page-with-pfn-==-0.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: thp-fix-huge-zero-page-logic-for-page-with-pfn-==-0-fix

fix sparse warning

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/huge_memory.c~thp-fix-huge-zero-page-logic-for-page-with-pfn-==-0-fix mm/huge_memory.c
--- a/mm/huge_memory.c~thp-fix-huge-zero-page-logic-for-page-with-pfn-==-0-fix
+++ a/mm/huge_memory.c
@@ -186,7 +186,7 @@ retry:
 			HPAGE_PMD_ORDER);
 	if (!zero_page) {
 		count_vm_event(THP_ZERO_PAGE_ALLOC_FAILED);
-		return 0;
+		return NULL;
 	}
 	count_vm_event(THP_ZERO_PAGE_ALLOC);
 	preempt_disable();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
auditsc-use-kzalloc-instead-of-kmallocmemset.patch
kernel-audit_treec-tree-will-leak-memory-when-failure-occurs-in-audit_trim_trees.patch
mm-shmemc-remove-an-ifdef.patch
memcg-relax-memcg-iter-caching.patch
mm-hugetlb-add-more-arch-defined-huge_pte-functions.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation.patch
kexec-vmalloc-export-additional-vmalloc-layer-information.patch
mm-hugetlb-include-hugepages-in-meminfo.patch
mm-speedup-in-__early_pfn_to_nid.patch
include-linux-memoryh-implement-register_hotmemory_notifier.patch
ipc-utilc-use-register_hotmemory_notifier.patch
mm-slubc-use-register_hotmemory_notifier.patch
drivers-base-nodec-switch-to-register_hotmemory_notifier.patch
fs-proc-kcorec-use-register_hotmemory_notifier.patch
kernel-cpusetc-use-register_hotmemory_notifier.patch
mm-limit-growth-of-3%-hardcoded-other-user-reserve.patch
mm-replace-hardcoded-3%-with-admin_reserve_pages-knob.patch
mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed.patch
resource-add-release_mem_region_adjustable.patch
mm-madvise-complete-input-validation-before-taking-lock.patch
clear_refs-sanitize-accepted-commands-declaration.patch
memcg-add-memorypressure_level-events.patch
mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim.patch
thp-fix-huge-zero-page-logic-for-page-with-pfn-==-0.patch
mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io-fix.patch
mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io-fix-fix.patch
mem-hotunplug-fix-kfree-of-bootmem-memory-fix.patch

