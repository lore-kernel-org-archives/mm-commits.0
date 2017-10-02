From: akpm@linux-foundation.org
Subject: +
 mm-mmu_notifier-avoid-double-notification-when-it-is-useless-checkpatch-fixes.patch added to -mm tree
Date: Mon, 02 Oct 2017 16:33:20 -0700
Message-ID: <59d2ccc0.2xD9WZmCoSpH6qmj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47722 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750770AbdJBXdV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 2 Oct 2017 19:33:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jglisse@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mmu_notifier-avoid-double-notification-when-it-is-useless-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-mmu_notifier-avoid-double-notification-when-it-is-useless-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmu_notifier-avoid-double-notification-when-it-is-useless-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmu_notifier-avoid-double-notification-when-it-is-useless-checkpatch-fixes.patch

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
Subject: mm-mmu_notifier-avoid-double-notification-when-it-is-useless-checkpatch-fixes

WARNING: Possible unwrapped commit description (prefer a maximum 75 chars per line)
#21: 
  A) page backing address is free before mmu_notifier_invalidate_range_end()

ERROR: code indent should use tabs where possible
#322: FILE: mm/hugetlb.c:3263:
+^I ^I^I^I *$

WARNING: please, no space before tabs
#322: FILE: mm/hugetlb.c:3263:
+^I ^I^I^I *$

total: 1 errors, 2 warnings, 283 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/mm-mmu_notifier-avoid-double-notification-when-it-is-useless.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/vm/mmu_notifier.txt~mm-mmu_notifier-avoid-double-notification-when-it-is-useless-checkpatch-fixes Documentation/vm/mmu_notifier.txt
diff -puN fs/dax.c~mm-mmu_notifier-avoid-double-notification-when-it-is-useless-checkpatch-fixes fs/dax.c
diff -puN include/linux/mmu_notifier.h~mm-mmu_notifier-avoid-double-notification-when-it-is-useless-checkpatch-fixes include/linux/mmu_notifier.h
diff -puN mm/huge_memory.c~mm-mmu_notifier-avoid-double-notification-when-it-is-useless-checkpatch-fixes mm/huge_memory.c
diff -puN mm/hugetlb.c~mm-mmu_notifier-avoid-double-notification-when-it-is-useless-checkpatch-fixes mm/hugetlb.c
--- a/mm/hugetlb.c~mm-mmu_notifier-avoid-double-notification-when-it-is-useless-checkpatch-fixes
+++ a/mm/hugetlb.c
@@ -3260,7 +3260,7 @@ int copy_hugetlb_page_range(struct mm_st
 				 * No need to notify as we downgrading page
 				 * table protection not changing it to point
 				 * to a new page.
-	 			 *
+				 *
 				 * See Documentation/vm/mmu_notifier.txt
 				 */
 				huge_ptep_set_wrprotect(src, addr, src_pte);
diff -puN mm/ksm.c~mm-mmu_notifier-avoid-double-notification-when-it-is-useless-checkpatch-fixes mm/ksm.c
diff -puN mm/rmap.c~mm-mmu_notifier-avoid-double-notification-when-it-is-useless-checkpatch-fixes mm/rmap.c
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
scripts-spellingtxt-add-more-spelling-mistakes-to-spellingtxt-fix.patch
mm-oom_reaper-skip-mm-structs-with-mmu-notifiers-checkpatch-fixes.patch
of-provide-of_n_addrsize_cells-wrappers-for-config_of-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-sysctl-make-numa-stats-configurable-fix.patch
mm-sysctl-make-numa-stats-configurable-fix-fix.patch
mm-mmu_notifier-avoid-double-notification-when-it-is-useless-checkpatch-fixes.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

