From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memoryc-mark-wp_huge_pmd-inline-to-prevent-build-failure-fix.patch
 removed from -mm tree
Date: Thu, 14 Dec 2017 15:27:54 -0800
Message-ID: <5a3308fa.0RsHlUhKAW2KvLSQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53794 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754295AbdLNX1z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Dec 2017 18:27:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memoryc-mark-wp_huge_pmd-inline-to-prevent-build-failure-fix
has been removed from the -mm tree.  Its filename was
     mm-memoryc-mark-wp_huge_pmd-inline-to-prevent-build-failure-fix.patch

This patch was dropped because it was folded into mm-memoryc-mark-wp_huge_pmd-inline-to-prevent-build-failure.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memoryc-mark-wp_huge_pmd-inline-to-prevent-build-failure-fix

add comment

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/memory.c~mm-memoryc-mark-wp_huge_pmd-inline-to-prevent-build-failure-fix mm/memory.c
--- a/mm/memory.c~mm-memoryc-mark-wp_huge_pmd-inline-to-prevent-build-failure-fix
+++ a/mm/memory.c
@@ -3831,6 +3831,7 @@ static inline int create_huge_pmd(struct
 	return VM_FAULT_FALLBACK;
 }
 
+/* `inline' is required to avoid gcc 4.1.2 build error */
 static inline int wp_huge_pmd(struct vm_fault *vmf, pmd_t orig_pmd)
 {
 	if (vma_is_anonymous(vmf->vma))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-kmemleakc-make-cond_resched-rate-limiting-more-efficient.patch
mm-memoryc-mark-wp_huge_pmd-inline-to-prevent-build-failure.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-terminate-shrink_slab-loop-if-signal-is-pending-fix.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix.patch
mm-do-not-stall-register_shrinker-fix.patch
selftest-vm-move-128tb-mmap-boundary-test-to-generic-directory-fix.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
sparc64-update-pmdp_invalidate-to-return-old-pmd-value-fix.patch
x86-mm-provide-pmdp_establish-helper-fix.patch
fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix-checkpatch-fixes.patch
lib-ubsanc-s-missaligned-misaligned.patch
linux-next-rejects.patch
tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

