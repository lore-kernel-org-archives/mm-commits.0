From: akpm@linux-foundation.org
Subject: - fix-memory-hot-remove-not-configured-case-fix.patch removed from -mm tree
Date: Mon, 15 Oct 2007 21:36:37 -0700
Message-ID: <200710160436.l9G4ab8I009098@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54666 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753900AbXJPEgl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 00:36:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     fix memory hot remove not configured case (fix)
has been removed from the -mm tree.  Its filename was
     fix-memory-hot-remove-not-configured-case-fix.patch

This patch was dropped because it was folded into fix-memory-hot-remove-not-configured-case.patch

------------------------------------------------------
Subject: fix memory hot remove not configured case (fix)
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Sorry... I sent old version...it returns -ENOSYS.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~fix-memory-hot-remove-not-configured-case-fix mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~fix-memory-hot-remove-not-configured-case-fix
+++ a/mm/memory_hotplug.c
@@ -558,7 +558,7 @@ failed_removal:
 #else
 int remove_memory(u64 start, u64 size)
 {
-	return -ENOSYS;
+	return -EINVAL;
 }
 EXPORT_SYMBOL_GPL(remove_memory);
 #endif /* CONFIG_MEMORY_HOTREMOVE */
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
sparc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support.patch
memoryless-nodes-generic-management-of-nodemasks-for-various-purposes.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
memoryless-nodes-fix-interleave-behavior-for-memoryless-nodes.patch
memoryless-nodes-oom-use-n_high_memory-map-instead-of-constructing-one-on-the-fly.patch
memoryless-nodes-no-need-for-kswapd.patch
memoryless-nodes-slab-support.patch
memoryless-nodes-slub-support.patch
memoryless-nodes-uncached-allocator-updates.patch
memoryless-nodes-allow-profiling-data-to-fall-back-to-other-nodes.patch
memoryless-nodes-update-memory-policy-and-page-migration.patch
memoryless-nodes-add-n_cpu-node-state.patch
memoryless-nodes-drop-one-memoryless-node-boot-warning.patch
memoryless-nodes-fix-gfp_thisnode-behavior.patch
memoryless-nodes-use-n_high_memory-for-cpusets.patch
flush-cache-before-installing-new-page-at-migraton.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte.patch
memory-unplug-v7-memory-hotplug-cleanup.patch
memory-unplug-v7-page-isolation.patch
memory-unplug-v7-page-offline.patch
memory-unplug-v7-ia64-interface.patch
fix-memory-hot-remove-not-configured-case.patch
fix-memory-hot-remove-not-configured-case-fix.patch
hugetlb-fix-hugepage-allocation-with-memoryless-nodes.patch
memory-controller-make-charging-gfp-mask-aware-fix.patch
cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified.patch
cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified-checkpatch-fixes.patch
add-irq-protection-in-the-percpu-counters-cpu-hotplug-callback-path.patch
