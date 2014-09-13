From: akpm@linux-foundation.org
Subject: [obsolete]
 mm-balloon_compaction-general-cleanup-checkpatch-fixes.patch removed from
 -mm tree
Date: Fri, 12 Sep 2014 17:07:38 -0700
Message-ID: <54138aca.kY8c8fcliIbLh9SK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57561 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbaIMAHj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 12 Sep 2014 20:07:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aquini@redhat.com, k.khlebnikov@samsung.com, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-balloon_compaction-general-cleanup-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-balloon_compaction-general-cleanup-checkpatch-fixes.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-balloon_compaction-general-cleanup-checkpatch-fixes

WARNING: Unnecessary space before function pointer name
#216: FILE: include/linux/balloon_compaction.h:60:
+	int (* migrate_page)(struct balloon_dev_info *, struct page *newpage,

ERROR: space prohibited after that '*' (ctx:BxW)
#216: FILE: include/linux/balloon_compaction.h:60:
+	int (* migrate_page)(struct balloon_dev_info *, struct page *newpage,
 	     ^

total: 1 errors, 1 warnings, 715 lines checked

./patches/mm-balloon_compaction-general-cleanup.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/balloon_compaction.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/balloon_compaction.h~mm-balloon_compaction-general-cleanup-checkpatch-fixes include/linux/balloon_compaction.h
--- a/include/linux/balloon_compaction.h~mm-balloon_compaction-general-cleanup-checkpatch-fixes
+++ a/include/linux/balloon_compaction.h
@@ -57,8 +57,9 @@ struct balloon_dev_info {
 	unsigned long isolated_pages;	/* # of isolated pages for migration */
 	spinlock_t pages_lock;		/* Protection to pages list */
 	struct list_head pages;		/* Pages enqueued & handled to Host */
-	int (* migrate_page)(struct balloon_dev_info *, struct page *newpage,
-			struct page *page, enum migrate_mode mode);
+	int (*migrate_page)(struct balloon_dev_info *b_dev_info,
+			    struct page *newpage, struct page *page,
+			    enum migrate_mode mode);
 };
 
 static inline void balloon_devinfo_init(struct balloon_dev_info *b_dev_info)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable-checkpatch-fixes.patch
fs-notify-groupc-make-fsnotify_final_destroy_group-static.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
fs-ocfs2-stack_userc-fix-typo-in-ocfs2_control_release.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
mm.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes.patch
fs-proc-task_nommuc-change-maps_open-to-use-__seq_open_private-fix.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range-checkpatch-fixes.patch
mm-slab_commonc-suppress-warning.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header-fix.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-2.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-3-fix.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone-fix.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3-fix.patch
include-linux-migrateh-remove-migratepage-define.patch
mm-balloon_compaction-keep-ballooned-pages-away-from-normal-migration-path-fix.patch
mm-introduce-common-page-state-for-ballooned-memory-fix.patch
mm-balloon_compaction-use-common-page-ballooning-fix.patch
introduce-dump_vma-fix.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma-checkpatch-fixes.patch
mm-mmapc-clean-up-config_debug_vm_rb-checks.patch
mm-introduce-vm_bug_on_mm-checkpatch-fixes.patch
mm-debugc-use-pr_emerg.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
zram-zram-memory-size-limitation-fix.patch
zram-zram-memory-size-limitation-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
acct-eliminate-compile-warning-fix.patch
checkpatch-fix-spello.patch
rtc-rk808-add-rtc-driver-for-rk808-fix.patch
rtc-bq32000-add-trickle-charger-option-with-device-tree-binding-checkpatch-fixes.patch
x86-optimize-resource-lookups-for-ioremap-fix.patch
init-resolve-shadow-warnings-checkpatch-fixes.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
lib-string_helpers-introduce-string_escape_mem-fix.patch
lib-vsprintf-add-%pe-format-specifier-fix.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix.patch
watchdog-control-hard-lockup-detection-default-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

