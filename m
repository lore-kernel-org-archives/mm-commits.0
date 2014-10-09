From: akpm@linux-foundation.org
Subject: [folded-merged]
 arm64-mm-enable-rcu-fast_gup-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 09 Oct 2014 14:29:13 -0700
Message-ID: <5436fe29.rgB5TjDJktRYV2y1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36099 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932588AbaJIV3O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2014 17:29:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, steve.capper@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64-mm-enable-rcu-fast_gup-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     arm64-mm-enable-rcu-fast_gup-checkpatch-fixes.patch

This patch was dropped because it was folded into arm64-mm-enable-rcu-fast_gup.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: arm64-mm-enable-rcu-fast_gup-checkpatch-fixes

WARNING: Missing a blank line after declarations
#108: FILE: arch/arm64/mm/flush.c:114:
+	pmd_t pmd = pmd_mksplitting(*pmdp);
+	VM_BUG_ON(address & ~PMD_MASK);

total: 0 errors, 1 warnings, 72 lines checked

./patches/arm64-mm-enable-rcu-fast_gup.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Steve Capper <steve.capper@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/flush.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/arm64/mm/flush.c~arm64-mm-enable-rcu-fast_gup-checkpatch-fixes arch/arm64/mm/flush.c
--- a/arch/arm64/mm/flush.c~arm64-mm-enable-rcu-fast_gup-checkpatch-fixes
+++ a/arch/arm64/mm/flush.c
@@ -111,6 +111,7 @@ void pmdp_splitting_flush(struct vm_area
 			  pmd_t *pmdp)
 {
 	pmd_t pmd = pmd_mksplitting(*pmdp);
+
 	VM_BUG_ON(address & ~PMD_MASK);
 	set_pmd_at(vma->vm_mm, address, pmdp, pmd);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fs-notify-groupc-make-fsnotify_final_destroy_group-static.patch
fs-ocfs2-stack_userc-fix-typo-in-ocfs2_control_release.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic.patch
fs-proc-task_nommuc-change-maps_open-to-use-__seq_open_private.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range.patch
mm-slab_commonc-suppress-warning.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header.patch
memory-hotplug-add-sysfs-zones_online_to-attribute.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3.patch
include-linux-migrateh-remove-migratepage-define.patch
introduce-dump_vma.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma.patch
mm-mmapc-clean-up-config_debug_vm_rb-checks.patch
mm-introduce-vm_bug_on_mm.patch
mm-debugc-use-pr_emerg.patch
mm-ksm-use-pr_err-instead-of-printk.patch
mm-introduce-a-general-rcu-get_user_pages_fast.patch
arm64-mm-enable-rcu-fast_gup.patch
zram-zram-memory-size-limitation.patch
acct-eliminate-compile-warning.patch

