From: akpm@linux-foundation.org
Subject: [folded] mm-add-comments-to-explain-mm_struct-fields-fix.patch removed from -mm tree
Date: Mon, 31 Oct 2011 16:41:36 -0700
Message-ID: <201110312341.p9VNfaxa030919@wpaz21.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:42049 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008Ab1JaXlt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 31 Oct 2011 19:41:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-add-comments-to-explain-mm_struct-fields-fix
has been removed from the -mm tree.  Its filename was
     mm-add-comments-to-explain-mm_struct-fields-fix.patch

This patch was dropped because it was folded into mm-add-comments-to-explain-mm_struct-fields.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-comments-to-explain-mm_struct-fields-fix

add missing ;

Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mm_types.h~mm-add-comments-to-explain-mm_struct-fields-fix include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-add-comments-to-explain-mm_struct-fields-fix
+++ a/include/linux/mm_types.h
@@ -294,7 +294,7 @@ struct mm_struct {
 	unsigned long hiwater_vm;	/* High-water virtual memory usage */
 
 	unsigned long total_vm;		/* Total pages mapped */
-	unsigned long locked_vm		/* Pages that have PG_mlocked set */
+	unsigned long locked_vm;	/* Pages that have PG_mlocked set */
 	unsigned long pinned_vm;	/* Refcount permanently increased */
 	unsigned long shared_vm;	/* Shared pages (files) */
 	unsigned long exec_vm;		/* VM_EXEC & ~VM_WRITE */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
dma-mapping-fix-sync_single_range_-dma-debugging.patch
include-linux-dmarh-forward-declare-struct-acpi_dmar_header.patch
proc-self-numa_maps-restore-huge-tag-for-hugetlb-vmas.patch
mm-add-comments-to-explain-mm_struct-fields.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
mm-neaten-warn_alloc_failed-fix.patch
debug-pagealloc-add-support-for-highmem-pages-fix.patch
mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread-fix.patch
mm-mmapc-eliminate-the-ret-variable-from-mm_take_all_locks-fix.patch
mm-munlock-use-mapcount-to-avoid-terrible-overhead-fix.patch
kernel-sysctlc-add-cap_last_cap-to-proc-sys-kernel-fix.patch
drivers-leds-leds-lp5521c-check-if-reset-is-successful-fix.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch
llist-return-whether-list-is-empty-before-adding-in-llist_add-fix.patch
checkpatch-add-a-strict-check-for-utf-8-in-commit-logs.patch

