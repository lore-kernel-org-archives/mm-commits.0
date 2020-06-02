From: akpm@linux-foundation.org
Subject: [merged]
 mm-slub-add-panic_on_error-to-the-debug-facilities-fix.patch removed from
 -mm tree
Date: Tue, 02 Jun 2020 14:38:00 -0700
Message-ID: <20200602213800.gBOLytjqO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbgFBViB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:38:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aquini@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com


The patch titled
     Subject: Documentation/vm/slub.rst: s/Toggle/Enable/
has been removed from the -mm tree.  Its filename was
     mm-slub-add-panic_on_error-to-the-debug-facilities-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Documentation/vm/slub.rst: s/Toggle/Enable/

"toggle" means to change a boolean thing's state.  This operation doesn't
do that - it sets it to "true".

Acked-by: Rafael Aquini <aquini@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/slub.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/vm/slub.rst~mm-slub-add-panic_on_error-to-the-debug-facilities-fix
+++ a/Documentation/vm/slub.rst
@@ -49,7 +49,7 @@ Possible debug options are::
 	P		Poisoning (object and padding)
 	U		User tracking (free and alloc)
 	T		Trace (please only use on single slabs)
-	A		Toggle failslab filter mark for the cache
+	A		Enable failslab filter mark for the cache
 	O		Switch debugging off for caches that would have
 			caused higher minimum slab orders
 	-		Switch all debugging off (useful if the kernel is
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order-fix-2-fix.patch
mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations-fix.patch
arch-kunmap-remove-duplicate-kunmap-implementations-fix.patch
arch-kmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
arch-kunmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
kmap-consolidate-kmap_prot-definitions-checkpatch-fixes.patch
mm-add-debug_wx-support-fix.patch
riscv-support-debug_wx-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
lib-make-a-test-module-with-get_count_order-long-fix.patch
seq_file-introduce-define_seq_attribute-helper-macro-checkpatch-fixes.patch
ipc-convert-ipcs_idr-to-xarray-update-fix.patch
linux-next-pre.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
linux-next-post.patch
kernel-add-panic_on_taint-fix.patch
mm-consolidate-pgd_index-and-pgd_offset_k-definitions-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix-fix.patch
mmap-locking-api-rename-mmap_sem-to-mmap_lock-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix-fix.patch
mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api-fix-2-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix-fix.patch
maccess-unify-the-probe-kernel-arch-hooks-fix.patch
bpf-bpf_seq_printf-handle-potentially-unsafe-format-string-better.patch
maccess-always-use-strict-semantics-for-probe_kernel_read-fix.patch
x86-use-non-set_fs-based-maccess-routines-checkpatch-fixes.patch
doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix.patch
sh-convert-ins-outs-macros-to-inline-functions-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
