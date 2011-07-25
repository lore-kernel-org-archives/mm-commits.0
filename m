From: akpm@linux-foundation.org
Subject: [folded] mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 25 Jul 2011 16:58:26 -0700
Message-ID: <201107252358.p6PNwQcA006342@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53108 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752547Ab1GYX6n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jul 2011 19:58:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, David.Laight@ACULAB.COM, a.p.zijlstra@chello.nl, benh@kernel.crashing.org, darren.hart@intel.com, haishan.bai@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: email address '"David Laight" <David.Laight@ACULAB.COM>' might be better as 'David Laight <David.Laight@ACULAB.COM>'
#23: 
Cc: "David Laight" <David.Laight@ACULAB.COM>

ERROR: trailing whitespace
#105: FILE: mm/memory.c:1845:
+^I$

total: 1 errors, 1 warnings, 83 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Darren Hart <darren.hart@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Shan Hai <haishan.bai@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mm.h~mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-checkpatch-fixes include/linux/mm.h
diff -puN kernel/futex.c~mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-checkpatch-fixes kernel/futex.c
diff -puN mm/memory.c~mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-checkpatch-fixes mm/memory.c
--- a/mm/memory.c~mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-checkpatch-fixes
+++ a/mm/memory.c
@@ -1842,7 +1842,7 @@ int fixup_user_fault(struct task_struct 
 	vma = find_extend_vma(mm, address);
 	if (!vma || address < vma->vm_start)
 		return -EFAULT;
-	
+
 	ret = handle_mm_fault(mm, vma, address, fault_flags);
 	if (ret & VM_FAULT_ERROR) {
 		if (ret & VM_FAULT_OOM)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
hugetlb-add-phys-addr-to-struct-huge_bootmem_page.patch
mm-make-some-struct-pages-const.patch
mm-use-const-struct-page-for-r-o-page-flag-accessor-methods.patch
xtensa-prevent-arbitrary-read-in-ptrace.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines.patch
pagewalk-add-locking-rule-comments.patch
mm-memoryc-remove-zap_block_size.patch
mm-memblockc-avoid-abuse-of-red_inactive.patch
mm-preallocate-page-before-lock_page-at-filemap-cow.patch
mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young.patch
mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-fix.patch
drivers-misc-add-support-the-fsa9480-usb-switch-fix.patch
lib-make-_tolower-public-checkpatch-fixes.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
checkpatch-add-a-prefer-__aligned-check.patch
init-skip-calibration-delay-if-previously-done-fix.patch
init-skip-calibration-delay-if-previously-done-fix-fix.patch
init-skip-calibration-delay-if-previously-done-4.patch
drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch
drivers-connector-cn_procc-remove-unused-local.patch
drivers-staging-gma500-psb_intel_displayc-fix-bad-udelay.patch

