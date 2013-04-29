From: akpm@linux-foundation.org
Subject: [folded-merged] mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim-fix-fix.patch removed from -mm tree
Date: Mon, 29 Apr 2013 14:55:04 -0700
Message-ID: <20130429215504.A7EC25A41E9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:61573 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759321Ab3D2VzF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 17:55:05 -0400
Received: by mail-vb0-f74.google.com with SMTP id w8so108903vbf.3
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 14:55:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, shli@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim-fix-fix.patch

This patch was dropped because it was folded into mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim-fix-fix

fix CONFIG_SWAP=n build

Cc: Shaohua Li <shli@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/swap.h~mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim-fix-fix include/linux/swap.h
--- a/include/linux/swap.h~mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim-fix-fix
+++ a/include/linux/swap.h
@@ -465,7 +465,7 @@ static inline struct page *lookup_swap_c
 	return NULL;
 }
 
-static inline int add_to_swap(struct page *page)
+static inline int add_to_swap(struct page *page, struct list_head *list)
 {
 	return 0;
 }
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
thp-fix-huge-zero-page-logic-for-page-with-pfn-==-0-fix.patch
mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io-fix.patch
mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io-fix-fix.patch
mem-hotunplug-fix-kfree-of-bootmem-memory-fix.patch

