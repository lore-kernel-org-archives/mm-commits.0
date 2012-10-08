From: akpm@linux-foundation.org
Subject: [folded-dropped] mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch removed from -mm tree
Date: Mon, 08 Oct 2012 15:46:34 -0700
Message-ID: <20121008224635.AAECA20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:47564 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126Ab2JHWqi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Oct 2012 18:46:38 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so239437lah.1
        for <mm-commits@vger.kernel.org>; Mon, 08 Oct 2012 15:46:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, khlebnikov@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix
has been removed from the -mm tree.  Its filename was
     mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch

This patch was dropped because it was folded into mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix

Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/vfio/pci/vfio_pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/vfio/pci/vfio_pci.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/vfio/pci/vfio_pci.c
--- a/drivers/vfio/pci/vfio_pci.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix
+++ a/drivers/vfio/pci/vfio_pci.c
@@ -461,7 +461,7 @@ static int vfio_pci_mmap(void *device_da
 	}
 
 	vma->vm_private_data = vdev;
-	vma->vm_flags |= (VM_IO | VM_RESERVED);
+	vma->vm_flags |= VM_IO;
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 
 	phys = (pci_resource_start(pdev, index) >> PAGE_SHIFT) + pgoff;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
rbtree-performance-and-correctness-test-fix.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix-fix.patch
mm-fix-tracing-in-free_pcppages_bulk-fix.patch
cma-count-free-cma-pages-fix.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch
atomic-implement-generic-atomic_dec_if_positive-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix-2.patch
mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible-fix-fix.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes.patch
mm-fix-invalidate_complete_page2-lock-ordering.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock.patch
cma-migrate-mlocked-pages-fix.patch
mm-avoid-section-mismatch-warning-for-memblock_type_name-fix.patch
mm-document-pagehuge-somewhat.patch
mm-memcg-clean-up-mm_match_cgroup-signature-fix.patch
memory-hotplug-suppress-trying-to-free-nonexistent-resource-xxxxxxxxxxxxxxxx-yyyyyyyyyyyyyyyy-warning.patch
mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code-fix.patch

