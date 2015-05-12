From: akpm@linux-foundation.org
Subject: +
 mm-clarify-that-the-function-operateds-on-hugepage-pte-fix.patch added to
 -mm tree
Date: Tue, 12 May 2015 15:54:18 -0700
Message-ID: <5552849a.ac6X/FF1nk86d1D0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33898 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934003AbbELWyT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 May 2015 18:54:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-clarify-that-the-function-operateds-on-hugepage-pte-fix
has been added to the -mm tree.  Its filename is
     mm-clarify-that-the-function-operateds-on-hugepage-pte-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-clarify-that-the-function-operateds-on-hugepage-pte-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-clarify-that-the-function-operateds-on-hugepage-pte-fix.patch

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
Subject: mm-clarify-that-the-function-operateds-on-hugepage-pte-fix

fix comment

Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-generic/pgtable.h~mm-clarify-that-the-function-operateds-on-hugepage-pte-fix include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-clarify-that-the-function-operateds-on-hugepage-pte-fix
+++ a/include/asm-generic/pgtable.h
@@ -196,7 +196,7 @@ static inline pmd_t pmdp_collapse_flush(
 					pmd_t *pmdp)
 {
 	/*
-	 * pmd and hugepage pte format are same. So we could
+	 * pmd and hugepage pte format are the same.  So we could
 	 * use the same function.
 	 */
 	return pmdp_huge_clear_flush(vma, address, pmdp);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-rtc-rtc-armada38xc-remove-unused-local-flags.patch
gfp-add-__gfp_noaccount-v2-fix.patch
cma-page_isolation-check-buddy-before-access-it-fix.patch
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
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix.patch
mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions-fix.patch
mm-clarify-that-the-function-operateds-on-hugepage-pte-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
proc-fix-page_size-limit-of-proc-pid-cmdline-fix.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
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

