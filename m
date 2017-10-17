From: akpm@linux-foundation.org
Subject: [obsolete]
 mm-mmu_notifier-avoid-double-notification-when-it-is-useless-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 17 Oct 2017 15:43:04 -0700
Message-ID: <59e68778.4CPqKvYlrXeckeif%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58254 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764634AbdJQWnH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Oct 2017 18:43:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jglisse@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mmu_notifier-avoid-double-notification-when-it-is-useless-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-mmu_notifier-avoid-double-notification-when-it-is-useless-checkpatch-fixes.patch

This patch was dropped because it is obsolete

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
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference-checkpatch-fixes.patch
mm-sysctl-make-numa-stats-configurable-fix.patch
mm-sysctl-make-numa-stats-configurable-fix-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch
support-resetting-warn_once-checkpatch-fixes.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
watchdog-core-make-use-of-devm_register_reboot_notifier-fix.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

