From: akpm@linux-foundation.org
Subject: [alternative-merged]
 fix-offset2lib-issue-for-x86-arm-powerpc-and-mips-fix-fix-2-fix.patch
 removed from -mm tree
Date: Mon, 02 Mar 2015 13:58:13 -0800
Message-ID: <54f4dcf5.g0sCtGTlxeJLZfOr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43974 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588AbbCBV6O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2015 16:58:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, catalin.marinas@arm.com, hecmargi@upv.es, hpa@zytor.com, iripoll@upv.es, keescook@chromium.org, mingo@kernel.org, ralf@linux-mips.org, rmk@arm.linux.org.uk, tglx@linutronix.de, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fix-offset2lib-issue-for-x86-arm-powerpc-and-mips-fix-fix-2-fix
has been removed from the -mm tree.  Its filename was
     fix-offset2lib-issue-for-x86-arm-powerpc-and-mips-fix-fix-2-fix.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fix-offset2lib-issue-for-x86-arm-powerpc-and-mips-fix-fix-2-fix

bah

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Hector Marco Gisbert <hecmargi@upv.es>
Cc: Hector Marco-Gisbert <hecmargi@upv.es>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ismael Ripoll <iripoll@upv.es>
Cc: Kees Cook <keescook@chromium.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/binfmt_elf.c~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips-fix-fix-2-fix fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips-fix-fix-2-fix
+++ a/fs/binfmt_elf.c
@@ -2301,7 +2301,7 @@ out:
 
 #endif		/* CONFIG_ELF_CORE */
 
-#ifdef ARCH_HAVE_ELF_ASLR
+#ifdef CONFIG_ARCH_HAVE_ELF_ASLR
 unsigned long randomize_et_dyn(unsigned long base)
 {
 	unsigned long ret;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm.patch
mm-cma-release-trigger-checkpatch-fixes.patch
mm-cma-allocation-trigger-fix.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes.patch
mm-hide-per-cpu-lists-in-output-of-show_mem-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch
lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch
lib-find__bit-reimplementation-fix.patch
binfmt_misc-simplify-entry_status-fix.patch
fs-fat-remove-unnecessary-includes-fix.patch
kconfig-use-macros-which-are-already-defined-fix.patch
linux-next.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

