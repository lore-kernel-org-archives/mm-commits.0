From: akpm@linux-foundation.org
Subject: [folded-merged] mm-speedup-in-__early_pfn_to_nid-fix.patch removed from -mm tree
Date: Mon, 29 Apr 2013 14:49:32 -0700
Message-ID: <20130429214932.CEB8A31C1D4@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:50998 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758406Ab3D2Vte (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 17:49:34 -0400
Received: by mail-ye0-f201.google.com with SMTP id m3so132669yen.0
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 14:49:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hpa@zytor.com, kosaki.motohiro@gmail.com, linfeng@cn.fujitsu.com, mingo@elte.hu, rientjes@google.com, rja@sgi.com, tglx@linutronix.de, tony.luck@intel.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-speedup-in-__early_pfn_to_nid-fix
has been removed from the -mm tree.  Its filename was
     mm-speedup-in-__early_pfn_to_nid-fix.patch

This patch was dropped because it was folded into mm-speedup-in-__early_pfn_to_nid.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-speedup-in-__early_pfn_to_nid-fix

add missing semicolon, per Tony

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Lin Feng <linfeng@cn.fujitsu.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/numa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/ia64/mm/numa.c~mm-speedup-in-__early_pfn_to_nid-fix arch/ia64/mm/numa.c
--- a/arch/ia64/mm/numa.c~mm-speedup-in-__early_pfn_to_nid-fix
+++ a/arch/ia64/mm/numa.c
@@ -78,7 +78,7 @@ int __meminit __early_pfn_to_nid(unsigne
 		if (section >= ssec && section < esec) {
 			last_ssec = ssec;
 			last_esec = esec;
-			last_nid = node_memblk[i].nid
+			last_nid = node_memblk[i].nid;
 			return node_memblk[i].nid;
 		}
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
mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed-v9-checkpatch-fixes.patch
resource-add-release_mem_region_adjustable-fix.patch
resource-add-release_mem_region_adjustable-fix-fix.patch
resource-add-release_mem_region_adjustable-fix-fix-fix.patch
mm-madvise-complete-input-validation-before-taking-lock-fix.patch
clear_refs-sanitize-accepted-commands-declaration-fix.patch
memcg-add-memorypressure_level-events-checkpatch-fixes.patch
memcg-add-memorypressure_level-events-fix.patch
mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim-fix-fix.patch
thp-fix-huge-zero-page-logic-for-page-with-pfn-==-0-fix.patch
mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io-fix.patch
mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io-fix-fix.patch
mem-hotunplug-fix-kfree-of-bootmem-memory-fix.patch

