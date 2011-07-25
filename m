From: akpm@linux-foundation.org
Subject: [folded] pagewalk-add-locking-rule-comments-fix.patch removed from -mm tree
Date: Mon, 25 Jul 2011 16:57:28 -0700
Message-ID: <201107252357.p6PNvTMe006300@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51967 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752118Ab1GYX5n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jul 2011 19:57:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, kamezawa.hiroyuki@gmail.com, kosaki.motohiro@jp.fujitsu.com, mpm@selenic.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     pagewalk-add-locking-rule-comments-fix
has been removed from the -mm tree.  Its filename was
     pagewalk-add-locking-rule-comments-fix.patch

This patch was dropped because it was folded into pagewalk-add-locking-rule-comments.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pagewalk-add-locking-rule-comments-fix
From: Andrew Morton <akpm@linux-foundation.org>

clarify comment

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/mm.h~pagewalk-add-locking-rule-comments-fix include/linux/mm.h
--- a/include/linux/mm.h~pagewalk-add-locking-rule-comments-fix
+++ a/include/linux/mm.h
@@ -910,7 +910,8 @@ unsigned long unmap_vmas(struct mmu_gath
  * @pte_entry: if set, called for each non-empty PTE (4th-level) entry
  * @pte_hole: if set, called for each hole at all levels
  * @hugetlb_entry: if set, called for each hugetlb entry
- *                 *Caution*: The caller must hold mmap_sem() if it's used.
+ *		   *Caution*: The caller must hold mmap_sem() if @hugetlb_entry
+ * 			      is used.
  *
  * (see walk_page_range for more details)
  */
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
mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-checkpatch-fixes.patch
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

