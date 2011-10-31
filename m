From: akpm@linux-foundation.org
Subject: [folded] mm-mmapc-eliminate-the-ret-variable-from-mm_take_all_locks-fix.patch removed from -mm tree
Date: Mon, 31 Oct 2011 16:46:17 -0700
Message-ID: <201110312346.p9VNkIA5020049@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:42781 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab1JaXqW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 31 Oct 2011 19:46:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, consul.kautuk@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mmapc-eliminate-the-ret-variable-from-mm_take_all_locks-fix
has been removed from the -mm tree.  Its filename was
     mm-mmapc-eliminate-the-ret-variable-from-mm_take_all_locks-fix.patch

This patch was dropped because it was folded into mm-mmapc-eliminate-the-ret-variable-from-mm_take_all_locks.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mmapc-eliminate-the-ret-variable-from-mm_take_all_locks-fix

Cc: Kautuk Consul <consul.kautuk@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/mmap.c~mm-mmapc-eliminate-the-ret-variable-from-mm_take_all_locks-fix mm/mmap.c
--- a/mm/mmap.c~mm-mmapc-eliminate-the-ret-variable-from-mm_take_all_locks-fix
+++ a/mm/mmap.c
@@ -2582,7 +2582,6 @@ int mm_take_all_locks(struct mm_struct *
 
 out_unlock:
 	mm_drop_all_locks(mm);
-
 	return -EINTR;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
dma-mapping-fix-sync_single_range_-dma-debugging.patch
include-linux-dmarh-forward-declare-struct-acpi_dmar_header.patch
proc-self-numa_maps-restore-huge-tag-for-hugetlb-vmas.patch
mm-add-comments-to-explain-mm_struct-fields.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
thp-mremap-support-and-tlb-optimization.patch
mm-neaten-warn_alloc_failed.patch
debug-pagealloc-add-support-for-highmem-pages.patch
mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread-fix.patch
mm-mmapc-eliminate-the-ret-variable-from-mm_take_all_locks.patch
mm-munlock-use-mapcount-to-avoid-terrible-overhead-fix.patch
kernel-sysctlc-add-cap_last_cap-to-proc-sys-kernel-fix.patch
drivers-leds-leds-lp5521c-check-if-reset-is-successful-fix.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch
llist-return-whether-list-is-empty-before-adding-in-llist_add-fix.patch
checkpatch-add-a-strict-check-for-utf-8-in-commit-logs.patch

