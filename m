From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:40:30 -0700
Message-ID: <200904141940.n3EJeVLt015403@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47706 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752028AbZDNTlY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:41:24 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n3EJeVIm021221
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 14 Apr 2009 12:41:07 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/ide-disk.c |   13 -------------
 firmware/WHENCE        |    4 ----
 2 files changed, 17 deletions(-)

diff -puN drivers/ide/ide-disk.c~linux-next-git-rejects drivers/ide/ide-disk.c
--- a/drivers/ide/ide-disk.c~linux-next-git-rejects
+++ a/drivers/ide/ide-disk.c
@@ -110,18 +110,6 @@ static ide_startstop_t __ide_do_rw_disk(
 			tf->lbam   = (u8)(block >>  8);
 			tf->lbah   = (u8)(block >> 16);
 			tf->device = ATA_LBA;
-<<<<<<< HEAD:drivers/ide/ide-disk.c
-
-			tf = &cmd.hob;
-			tf->nsect = (nsectors >> 8) & 0xff;
-			tf->lbal  = (u8)(block >> 24);
-			if (sizeof(block) != 4) {
-				tf->lbam = (u8)((u64)block >> 32);
-				tf->lbah = (u8)((u64)block >> 40);
-			}
-
-=======
-
 			tf = &cmd.hob;
 			tf->nsect = (nsectors >> 8) & 0xff;
 			tf->lbal  = (u8)(block >> 24);
@@ -130,7 +118,6 @@ static ide_startstop_t __ide_do_rw_disk(
 				tf->lbah = (u8)((u64)block >> 40);
 			}
 
->>>>>>> FETCH_HEAD:drivers/ide/ide-disk.c
 			cmd.valid.out.hob = IDE_VALID_OUT_HOB;
 			cmd.valid.in.hob  = IDE_VALID_IN_HOB;
 			cmd.tf_flags |= IDE_TFLAG_LBA48;
diff -puN firmware/WHENCE~linux-next-git-rejects firmware/WHENCE
--- a/firmware/WHENCE~linux-next-git-rejects
+++ a/firmware/WHENCE
@@ -646,9 +646,5 @@ Licence: Allegedly GPLv2+, but no source
 
 Found in hex form in kernel source, with the following comment:
    Copyright (c) 1998-2002 by Paul Davis <pbd@op.net>
-<<<<<<< HEAD:firmware/WHENCE
-=======
-
->>>>>>> FETCH_HEAD:firmware/WHENCE
 
 --------------------------------------------------------------------------
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
toshiba_acpi-add-full-hotkey-support.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-using-work_on_cpu.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-fix.patch
arch-x86-kernel-acpi-cstatec-avoid-using-work_on_cpu.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-dont-open-code-smp_call_function_many.patch
early-platform-driver-v3.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
mips-cacheflush-system-call-not-returning-einval-checkpatch-fixes.patch
mtd-flex-onenand-support.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
vfs-kill-vfs_stat_fd-vfs_lstat_fd-fix.patch
xtensa-add-flat-support-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
squashfs-fix-breakage-when-pagesize-blocksize-checkpatch-fixes.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
readahead-introduce-context-readahead-algorithm-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
flat-fix-data-sections-alignment.patch
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

