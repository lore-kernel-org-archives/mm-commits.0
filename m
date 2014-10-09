From: akpm@linux-foundation.org
Subject: [folded-merged] mm-introduce-vm_bug_on_mm-checkpatch-fixes.patch
 removed from -mm tree
Date: Thu, 09 Oct 2014 13:42:10 -0700
Message-ID: <5436f322.XEjSbUEvnSbwh+yQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35645 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaJIUmL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2014 16:42:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-introduce-vm_bug_on_mm-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-introduce-vm_bug_on_mm-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-introduce-vm_bug_on_mm.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-introduce-vm_bug_on_mm-checkpatch-fixes

ERROR: code indent should use tabs where possible
#37: FILE: include/linux/mmdebug.h:33:
+        do {^I^I^I^I^I^I^I^I\$

WARNING: please, no spaces at the start of a line
#37: FILE: include/linux/mmdebug.h:33:
+        do {^I^I^I^I^I^I^I^I\$

ERROR: code indent should use tabs where possible
#38: FILE: include/linux/mmdebug.h:34:
+                if (unlikely(cond)) {^I^I^I^I^I\$

WARNING: please, no spaces at the start of a line
#38: FILE: include/linux/mmdebug.h:34:
+                if (unlikely(cond)) {^I^I^I^I^I\$

ERROR: code indent should use tabs where possible
#39: FILE: include/linux/mmdebug.h:35:
+                        dump_mm(mm);^I^I^I^I^I\$

WARNING: please, no spaces at the start of a line
#39: FILE: include/linux/mmdebug.h:35:
+                        dump_mm(mm);^I^I^I^I^I\$

ERROR: code indent should use tabs where possible
#40: FILE: include/linux/mmdebug.h:36:
+                        BUG();^I^I^I^I^I^I\$

WARNING: please, no spaces at the start of a line
#40: FILE: include/linux/mmdebug.h:36:
+                        BUG();^I^I^I^I^I^I\$

ERROR: code indent should use tabs where possible
#41: FILE: include/linux/mmdebug.h:37:
+                }^I^I^I^I^I^I^I\$

WARNING: please, no spaces at the start of a line
#41: FILE: include/linux/mmdebug.h:37:
+                }^I^I^I^I^I^I^I\$

ERROR: code indent should use tabs where possible
#42: FILE: include/linux/mmdebug.h:38:
+        } while (0)$

WARNING: please, no spaces at the start of a line
#42: FILE: include/linux/mmdebug.h:38:
+        } while (0)$

WARNING: Prefer [subsystem eg: netdev]_alert([subsystem]dev, ... then dev_alert(dev, ... then pr_alert(...  to printk(KERN_ALERT ...
#74: FILE: mm/debug.c:171:
+	printk(KERN_ALERT

total: 6 errors, 7 warnings, 109 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/mm-introduce-vm_bug_on_mm.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmdebug.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN include/linux/mmdebug.h~mm-introduce-vm_bug_on_mm-checkpatch-fixes include/linux/mmdebug.h
--- a/include/linux/mmdebug.h~mm-introduce-vm_bug_on_mm-checkpatch-fixes
+++ a/include/linux/mmdebug.h
@@ -30,12 +30,12 @@ void dump_mm(const struct mm_struct *mm)
 		}							\
 	} while (0)
 #define VM_BUG_ON_MM(cond, mm)						\
-        do {								\
-                if (unlikely(cond)) {					\
-                        dump_mm(mm);					\
-                        BUG();						\
-                }							\
-        } while (0)
+	do {								\
+		if (unlikely(cond)) {					\
+			dump_mm(mm);					\
+			BUG();						\
+		}							\
+	} while (0)
 #define VM_WARN_ON(cond) WARN_ON(cond)
 #define VM_WARN_ON_ONCE(cond) WARN_ON_ONCE(cond)
 #define VM_WARN_ONCE(cond, format...) WARN_ONCE(cond, format)
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
mm-debug-mm-introduce-vm_bug_on_mm-fix-fixpatch-fix.patch
mm-debugc-use-pr_emerg.patch
mm-ksm-use-pr_err-instead-of-printk-fix.patch
mm-introduce-a-general-rcu-get_user_pages_fast-fix.patch
arm64-mm-enable-rcu-fast_gup-checkpatch-fixes.patch
zram-zram-memory-size-limitation-fix.patch
zram-zram-memory-size-limitation-fix-fix.patch
acct-eliminate-compile-warning-fix.patch

