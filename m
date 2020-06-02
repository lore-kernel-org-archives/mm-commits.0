From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-ptdump-expand-type-of-val-in-note_page-fix.patch removed from -mm tree
Date: Mon, 01 Jun 2020 21:19:31 -0700
Message-ID: <20200602041931.AJOwwYI37%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725616AbgFBETd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 00:19:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com, jbeulich@suse.com, lkp@intel.com, luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org, peterz@infradead.org, steven.price@arm.com, tglx@linutronix.de


The patch titled
     Subject: mm-ptdump-expand-type-of-val-in-note_page-fix
has been removed from the -mm tree.  Its filename was
     mm-ptdump-expand-type-of-val-in-note_page-fix.patch

This patch was dropped because it was folded into mm-ptdump-expand-type-of-val-in-note_page.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-ptdump-expand-type-of-val-in-note_page-fix

fix riscv

Reported-by: kbuild test robot <lkp@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jan Beulich <jbeulich@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Price <steven.price@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/mm/ptdump.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/mm/ptdump.c~mm-ptdump-expand-type-of-val-in-note_page-fix
+++ a/arch/riscv/mm/ptdump.c
@@ -204,7 +204,7 @@ static void note_prot_wx(struct pg_state
 }
 
 static void note_page(struct ptdump_state *pt_st, unsigned long addr,
-		      int level, unsigned long val)
+		      int level, u64 val)
 {
 	struct pg_state *st = container_of(pt_st, struct pg_state, ptdump);
 	u64 pa = PFN_PHYS(pte_pfn(__pte(val)));
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-parisc-include-asm-pgtableh-remove-unused-old_pte.patch
mm-slub-add-panic_on_error-to-the-debug-facilities-fix.patch
mm-ptdump-expand-type-of-val-in-note_page.patch
mm-remove-__vmalloc_node_flags_caller-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix-fix.patch
mm-remove-vmalloc_user_node_flags-fix.patch
mm-vmalloc-track-which-page-table-levels-were-modified-fix.patch
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
bpf-bpf_seq_printf-handle-potentially-unsafe-format-string-better-fix.patch
maccess-always-use-strict-semantics-for-probe_kernel_read-fix.patch
x86-use-non-set_fs-based-maccess-routines-checkpatch-fixes.patch
doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix.patch
sh-convert-ins-outs-macros-to-inline-functions-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
