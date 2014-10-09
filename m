From: akpm@linux-foundation.org
Subject: [folded-merged]
 memory-hotplug-add-sysfs-zones_online_to-attribute-fix-3-fix.patch removed
 from -mm tree
Date: Thu, 09 Oct 2014 13:32:42 -0700
Message-ID: <5436f0ea.BWnSb1qm8MreOq+q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35451 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaJIUcm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2014 16:32:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave.hansen@intel.com, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug-add-sysfs-zones_online_to-attribute-fix-3-fix
has been removed from the -mm tree.  Its filename was
     memory-hotplug-add-sysfs-zones_online_to-attribute-fix-3-fix.patch

This patch was dropped because it was folded into memory-hotplug-add-sysfs-zones_online_to-attribute.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memory-hotplug-add-sysfs-zones_online_to-attribute-fix-3-fix

remove unused local zone_prev

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/base/memory.c~memory-hotplug-add-sysfs-zones_online_to-attribute-fix-3-fix drivers/base/memory.c
--- a/drivers/base/memory.c~memory-hotplug-add-sysfs-zones_online_to-attribute-fix-3-fix
+++ a/drivers/base/memory.c
@@ -381,7 +381,7 @@ static ssize_t show_zones_online_to(stru
 	unsigned long start_pfn, end_pfn;
 	unsigned long nr_pages = PAGES_PER_SECTION * sections_per_block;
 	struct page *first_page;
-	struct zone *zone, *zone_prev;
+	struct zone *zone;
 
 	start_pfn = section_nr_to_pfn(mem->start_section_nr);
 	end_pfn = start_pfn + nr_pages;
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
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone-fix.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3-fix.patch
include-linux-migrateh-remove-migratepage-define.patch
introduce-dump_vma-fix.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma-checkpatch-fixes.patch
mm-mmapc-clean-up-config_debug_vm_rb-checks.patch
mm-introduce-vm_bug_on_mm-checkpatch-fixes.patch
mm-debug-mm-introduce-vm_bug_on_mm-fix-fixpatch-fix.patch
mm-debugc-use-pr_emerg.patch
mm-ksm-use-pr_err-instead-of-printk-fix.patch
mm-introduce-a-general-rcu-get_user_pages_fast-fix.patch
arm64-mm-enable-rcu-fast_gup-checkpatch-fixes.patch
zram-zram-memory-size-limitation-fix.patch
zram-zram-memory-size-limitation-fix-fix.patch
acct-eliminate-compile-warning-fix.patch

