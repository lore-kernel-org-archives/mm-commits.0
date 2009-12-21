From: akpm@linux-foundation.org
Subject: [folded] cmpc_acpi-add-support-for-classmate-pc-acpi-devices-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 21 Dec 2009 15:53:28 -0800
Message-ID: <200912212353.nBLNrS0q003551@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57804 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751295AbZLUXye (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Dec 2009 18:54:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cascardo@holoscopio.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     cmpc_acpi-add-support-for-classmate-pc-acpi-devices-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     cmpc_acpi-add-support-for-classmate-pc-acpi-devices-checkpatch-fixes.patch

This patch was dropped because it was folded into cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cmpc_acpi-add-support-for-classmate-pc-acpi-devices-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: open brace '{' following struct go on the same line
#99: FILE: drivers/platform/x86/classmate-laptop.c:31:
+struct cmpc_accel
+{

total: 1 errors, 0 warnings, 642 lines checked

./patches/cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Len Brown <lenb@kernel.org>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/classmate-laptop.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/platform/x86/classmate-laptop.c~cmpc_acpi-add-support-for-classmate-pc-acpi-devices-checkpatch-fixes drivers/platform/x86/classmate-laptop.c
--- a/drivers/platform/x86/classmate-laptop.c~cmpc_acpi-add-support-for-classmate-pc-acpi-devices-checkpatch-fixes
+++ a/drivers/platform/x86/classmate-laptop.c
@@ -27,8 +27,7 @@
 MODULE_LICENSE("GPL");
 
 
-struct cmpc_accel
-{
+struct cmpc_accel {
 	int sensitivity;
 };
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kfifo-move-struct-kfifo-in-place.patch
linux-next.patch
linux-next-fixup.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-checkpatch-fixes.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
net-sctp-socketc-squish-warning.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix2.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
fs-ext4-superc-fix-printk-warning.patch
atmel_serial-add-poll_get_char-and-poll_put_char-uart_ops.patch
scsi-aacraid-fix-memory-leak-checkpatch-fixes.patch
aoe-switch-to-the-new-bio_flush_dcache_pages-interface.patch
fs-improve-remountro-vs-buffercache-coherency.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
char-cyclades-fix-compiler-warning.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch
lib-add-support-for-lzo-compressed-kernels.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

