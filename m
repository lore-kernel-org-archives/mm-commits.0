From: akpm@linux-foundation.org
Subject: [merged] vfs-kill-vfs_stat_fd-vfs_lstat_fd-fix.patch removed from -mm tree
Date: Wed, 22 Apr 2009 11:31:16 -0700
Message-ID: <200904221831.n3MIVGAH006659@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751382AbZDVSnd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Apr 2009 14:43:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, green@linuxhacker.ru, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs-kill-vfs_stat_fd-vfs_lstat_fd-fix
has been removed from the -mm tree.  Its filename was
     vfs-kill-vfs_stat_fd-vfs_lstat_fd-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs-kill-vfs_stat_fd-vfs_lstat_fd-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Christoph Hellwig <hch@lst.de>
Cc: Oleg Drokin <green@linuxhacker.ru>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/compat.c~vfs-kill-vfs_stat_fd-vfs_lstat_fd-fix fs/compat.c
--- a/fs/compat.c~vfs-kill-vfs_stat_fd-vfs_lstat_fd-fix
+++ a/fs/compat.c
@@ -183,7 +183,7 @@ asmlinkage long compat_sys_newstat(char 
 	struct kstat stat;
 	int error;
 
-	error = = vfs_stat(filename, &stat);
+	error = vfs_stat(filename, &stat);
 	if (error)
 		return error;
 	return cp_compat_stat(&stat, statbuf);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i2c-too-much-compiler-noise.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
arch-x86-kernel-apic-io_apicc-conditionally-compile-eoi_ioapic_irq.patch
drivers-gpu-drm-i915-intel_fbc-remove-sysrq-g-handler.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
mtd-flex-onenand-support.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
drivers-platform-x86-toshiba_acpic-fix-acpi_install_notify_handler-arg.patch
squashfs-fix-breakage-when-pagesize-blocksize-checkpatch-fixes.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
flat-fix-data-sections-alignment.patch
rtc-add-stand-alone-driver-for-rx8025-chip-is-broken.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

