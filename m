From: akpm@linux-foundation.org
Subject: [failures]
 mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions-fix-2.patch
 removed from -mm tree
Date: Wed, 20 May 2015 12:45:00 -0700
Message-ID: <555ce43c.Sf84tuhViUbzwEtX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40426 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbbETTpB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 May 2015 15:45:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, fengguang.wu@intel.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions-fix-2
has been removed from the -mm tree.  Its filename was
     mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions-fix-2.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions-fix-2

Not all architectures implement __pmd() (eg m68k)

Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-generic/pgtable.h~mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions-fix-2 include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions-fix-2
+++ a/include/asm-generic/pgtable.h
@@ -204,7 +204,7 @@ static inline pmd_t pmdp_collapse_flush(
 					pmd_t *pmdp)
 {
 	BUILD_BUG();
-	return __pmd(0);
+	return *pmdp;
 }
 #define pmdp_collapse_flush pmdp_collapse_flush
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
fs-binfmt_elfc-load_elf_binary-return-einval-on-zero-length-mappings.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
mm.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
mm-meminit-inline-some-helper-functions-fix.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix.patch
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
proc-fix-page_size-limit-of-proc-pid-cmdline-fix.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
radix-tree-replace-preallocated-node-array-with-linked-list-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch
linux-next.patch
linux-next-rejects.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

