From: akpm@linux-foundation.org
Subject: + mm-change-vunmap-to-tear-down-huge-kva-mappings-fix.patch added to -mm tree
Date: Wed, 11 Mar 2015 13:05:24 -0700
Message-ID: <5500a004.d24SgbrLeAnICeQm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48639 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbbCKUFZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Mar 2015 16:05:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, toshi.kani@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-change-vunmap-to-tear-down-huge-kva-mappings-fix
has been added to the -mm tree.  Its filename is
     mm-change-vunmap-to-tear-down-huge-kva-mappings-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-change-vunmap-to-tear-down-huge-kva-mappings-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-change-vunmap-to-tear-down-huge-kva-mappings-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-change-vunmap-to-tear-down-huge-kva-mappings-fix

use consistent code layout

Cc: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgtable.h |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN include/asm-generic/pgtable.h~mm-change-vunmap-to-tear-down-huge-kva-mappings-fix include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-change-vunmap-to-tear-down-huge-kva-mappings-fix
+++ a/include/asm-generic/pgtable.h
@@ -711,8 +711,14 @@ static inline int pmd_set_huge(pmd_t *pm
 {
 	return 0;
 }
-static inline int pud_clear_huge(pud_t *pud) { return 0; }
-static inline int pmd_clear_huge(pmd_t *pmd) { return 0; }
+static inline int pud_clear_huge(pud_t *pud)
+{
+	return 0;
+}
+static inline int pmd_clear_huge(pmd_t *pmd)
+{
+	return 0;
+}
 #endif	/* CONFIG_HAVE_ARCH_HUGE_VMAP */
 
 #endif /* !__ASSEMBLY__ */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention.patch
mm.patch
mm-cma-release-trigger-checkpatch-fixes.patch
mm-cma-allocation-trigger-fix.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes.patch
mm-hide-per-cpu-lists-in-output-of-show_mem-fix.patch
mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes.patch
mm-change-vunmap-to-tear-down-huge-kva-mappings-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-introduce-automatic-device_id-generation-fix.patch
kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch
lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch
lib-find__bit-reimplementation-fix.patch
binfmt_misc-simplify-entry_status-fix.patch
rtc-add-abracon-abx80x-driver-fix.patch
fs-fat-remove-unnecessary-includes-fix.patch
kconfig-use-macros-which-are-already-defined-fix.patch
linux-next.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix.patch
tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

