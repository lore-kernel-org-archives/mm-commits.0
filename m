From: akpm@linux-foundation.org
Subject: [folded-merged] zram-zram-memory-size-limitation-fix-fix.patch
 removed from -mm tree
Date: Thu, 09 Oct 2014 13:47:04 -0700
Message-ID: <5436f448.rrh1tI7GcFfI1ap3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35712 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaJIUrE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2014 16:47:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram-zram-memory-size-limitation-fix-fix
has been removed from the -mm tree.  Its filename was
     zram-zram-memory-size-limitation-fix-fix.patch

This patch was dropped because it was folded into zram-zram-memory-size-limitation.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: zram-zram-memory-size-limitation-fix-fix

Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-block-zram |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN Documentation/ABI/testing/sysfs-block-zram~zram-zram-memory-size-limitation-fix-fix Documentation/ABI/testing/sysfs-block-zram
--- a/Documentation/ABI/testing/sysfs-block-zram~zram-zram-memory-size-limitation-fix-fix
+++ a/Documentation/ABI/testing/sysfs-block-zram
@@ -125,5 +125,6 @@ Date:		August 2014
 Contact:	Minchan Kim <minchan@kernel.org>
 Description:
 		The mem_limit file is read/write and specifies the maximum
-		amount of memory ZRAM can use to store the compressed data.  The		limit could be changed in run time and "0" means disable the
+		amount of memory ZRAM can use to store the compressed data.  The
+		limit could be changed in run time and "0" means disable the
 		limit.  No limit is the initial state.  Unit: bytes
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
arm64-mm-enable-rcu-fast_gup-checkpatch-fixes.patch
zram-zram-memory-size-limitation.patch
acct-eliminate-compile-warning-fix.patch

