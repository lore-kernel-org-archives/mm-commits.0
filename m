From: akpm@linux-foundation.org
Subject: [obsolete]
 drivers-dma-contiguous-add-initialization-from-device-tree-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 03 Oct 2014 12:38:10 -0700
Message-ID: <542efb22.EQX7OnfvwDMUofcT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42424 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171AbaJCTiK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Oct 2014 15:38:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, grant.likely@linaro.org, iamjoonsoo.kim@lge.com, joshc@codeaurora.org, kyungmin.park@samsung.com, lauraa@codeaurora.org, m.szyprowski@samsung.com, mina86@mina86.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers-dma-contiguous-add-initialization-from-device-tree-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     drivers-dma-contiguous-add-initialization-from-device-tree-checkpatch-fixes.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers-dma-contiguous-add-initialization-from-device-tree-checkpatch-fixes

WARNING: Missing a blank line after declarations
#140: FILE: drivers/base/dma-contiguous.c:229:
+	struct cma *cma = rmem->priv;
+	if (!cma)

total: 0 errors, 1 warnings, 163 lines checked

./patches/drivers-dma-contiguous-add-initialization-from-device-tree.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Josh Cartwright <joshc@codeaurora.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/dma-contiguous.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/base/dma-contiguous.c~drivers-dma-contiguous-add-initialization-from-device-tree-checkpatch-fixes drivers/base/dma-contiguous.c
--- a/drivers/base/dma-contiguous.c~drivers-dma-contiguous-add-initialization-from-device-tree-checkpatch-fixes
+++ a/drivers/base/dma-contiguous.c
@@ -226,6 +226,7 @@ bool dma_release_from_contiguous(struct
 static int rmem_cma_device_init(struct reserved_mem *rmem, struct device *dev)
 {
 	struct cma *cma = rmem->priv;
+
 	if (!cma)
 		return -ENODEV;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fs-notify-groupc-make-fsnotify_final_destroy_group-static.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
kernel-add-support-for-gcc-5-checkpatch-fixes.patch
fs-ocfs2-stack_userc-fix-typo-in-ocfs2_control_release.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
ocfs2-add-orphan-recovery-types-in-ocfs2_recover_orphans-fix.patch
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
introduce-dump_vma-fix.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma-checkpatch-fixes.patch
mm-mmapc-clean-up-config_debug_vm_rb-checks.patch
mm-introduce-vm_bug_on_mm-checkpatch-fixes.patch
mm-debug-mm-introduce-vm_bug_on_mm-fix-fixpatch-fix.patch
mm-debugc-use-pr_emerg.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-checkpatch-fixes.patch
drivers-dma-contiguous-add-initialization-from-device-tree-fix-fix.patch
mm-ksm-use-pr_err-instead-of-printk-fix.patch
mm-introduce-a-general-rcu-get_user_pages_fast-fix.patch
arm64-mm-enable-rcu-fast_gup-checkpatch-fixes.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
zram-zram-memory-size-limitation-fix.patch
zram-zram-memory-size-limitation-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
acct-eliminate-compile-warning-fix.patch
checkpatch-fix-spello.patch
checkpatch-warn-on-logging-functions-with-kern_level.patch
rtc-rk808-add-rtc-driver-for-rk808-fix.patch
rtc-bq32000-add-trickle-charger-option-with-device-tree-binding-checkpatch-fixes.patch
rtc-max77686-use-ffs-to-calculate-tm_wday-fix.patch
rtc-add-driver-for-maxim-77802-pmic-real-time-clock-v10-fix.patch
rtc-pm8xxx-rework-to-support-pm8941-rtc-checkpatch-fixes.patch
x86-optimize-resource-lookups-for-ioremap-fix.patch
init-resolve-shadow-warnings-checkpatch-fixes.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
arch-x86-kernel-cpu-commonc-fix-unused-symbol-warning.patch
sched-fix-typo.patch
mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable-checkpatch-fixes.patch
lib-string_helpers-introduce-string_escape_mem-fix.patch
lib-vsprintf-add-%pe-format-specifier-fix.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix-2.patch
watchdog-control-hard-lockup-detection-default-fix.patch
driver-base-node-remove-unnecessary-kfree-of-node-struct-from-unregister_one_node.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

