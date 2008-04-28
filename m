From: akpm@linux-foundation.org
Subject: - gpiochip_reserve-fix.patch removed from -mm tree
Date: Sun, 27 Apr 2008 23:59:54 -0700
Message-ID: <200804280659.m3S6xsX0012944@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56922 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756168AbYD1HAJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 03:00:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, avorontsov@ru.mvista.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     gpiochip_reserve-fix
has been removed from the -mm tree.  Its filename was
     gpiochip_reserve-fix.patch

This patch was dropped because it was folded into gpiochip_reserve.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpiochip_reserve-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpiolib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpio/gpiolib.c~gpiochip_reserve-fix drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpiochip_reserve-fix
+++ a/drivers/gpio/gpiolib.c
@@ -121,7 +121,7 @@ static int gpiochip_find_base(int ngpio)
  * to mark a range of gpios as unavailable for dynamic gpio number allocation,
  * for example because its driver support is not yet loaded.
  */
-int __init __must_check gpiochip_reserve(int start, int ngpio)
+int __init gpiochip_reserve(int start, int ngpio)
 {
 	int ret = 0;
 	unsigned long flags;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes.patch
rtc-pcf8563-new-style-conversion.patch
rtc-x1205-new-style-conversion.patch
hotplug-memory-make-online_page-common.patch
remove-sparse-warning-for-mmzoneh.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret.patch
mm-make-reserve_bootmem-can-crossed-the-nodes-checkpatch-fixes.patch
mm-make-early_pfn_to_nid-a-c-function.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo.patch
vmallocinfo-add-caller-information.patch
page_mapping-add-ifdef-around-reference-to-swapper_space.patch
smaps-account-swap-entries.patch
mm-introduce-pte_special-pte-bit.patch
hugetlb-vmstat-events-for-huge-page-allocations.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info.patch
capabilities-implement-per-process-securebits.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks-checkpatch-fixes.patch
lsm-audit-introduce-generic-audit-lsm-hooks-checkpatch-fixes.patch
selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch
audit-final-renamings-and-cleanup-checkpatch-fixes.patch
arch-alpha-kernel-trapsc-use-time_-macros.patch
alpha-teach-the-compiler-that-bug-doesnt-return.patch
uart_get_baud_rate-stop-mangling-termios.patch
drivers-acpi-thermalc-fix-build-with-config_dmi=n.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable.patch
vt-notifier-extension-for-accessibility.patch
kprobes-prevent-probing-of-preempt_schedule.patch
quota-various-style-cleanups.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount.patch
quota-convert-stub-functions-from-macros-into-inlines.patch
gpiochip_reserve.patch
gpiochip_reserve-fix.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch-fix.patch
lxfb-add-power-management-functionality-fix.patch
drivers-video-uvesafbc-fix-error-path-memory-leak.patch
fb-convert-proc-fb-to-seq_file-interface-checkpatch-fixes.patch
drivers-video-w100fbc-avoid-a-couple-of-error-path-null-derefs.patch
drivers-md-use-time_before-time_before_eq-etc-checkpatch-fixes.patch
pnp-use-dev_printk-for-quirk-messages-fix.patch
ext2-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone-comment-typo.patch
ext3-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone-comment-typo.patch
fat_valid_media-remove-pointless-test.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch

