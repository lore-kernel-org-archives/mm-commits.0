From: akpm@linux-foundation.org
Subject: - init-wait-for-asynchronously-scanned-block-devices-fix.patch removed from -mm tree
Date: Mon, 09 Jul 2007 14:55:03 -0700
Message-ID: <200707092155.l69Lt34s014567@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47337 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753913AbXGIVzz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 17:55:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, drzeus@drzeus.cx, mm-commits@vger.kernel.org


The patch titled
     make init/do_mounts.c:root_wait static
has been removed from the -mm tree.  Its filename was
     init-wait-for-asynchronously-scanned-block-devices-fix.patch

This patch was dropped because it was folded into init-wait-for-asynchronously-scanned-block-devices.patch

------------------------------------------------------
Subject: make init/do_mounts.c:root_wait static
From: Adrian Bunk <bunk@stusta.de>

root_wait can become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN init/do_mounts.c~init-wait-for-asynchronously-scanned-block-devices-fix init/do_mounts.c
--- a/init/do_mounts.c~init-wait-for-asynchronously-scanned-block-devices-fix
+++ a/init/do_mounts.c
@@ -25,7 +25,7 @@ int __initdata rd_doload;	/* 1 = load RA
 int root_mountflags = MS_RDONLY | MS_SILENT;
 char * __initdata root_device_name;
 static char __initdata saved_root_name[64];
-int __initdata root_wait;
+static int __initdata root_wait;
 
 dev_t ROOT_DEV;
 
_

Patches currently in -mm which might be from bunk@stusta.de are

git-acpi.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default-fix.patch
drivers-acpi-sbsc-remove-dead-code.patch
git-alsa.patch
make-drivers-char-hvc_consoleckhvcd-static.patch
git-dvb.patch
git-hwmon.patch
git-input.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-md-accel.patch
git-mmc.patch
git-mtd.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
bonding-bond_mainc-make-2-functions-static.patch
net-make-struct-dccp_li_cachep-static.patch
git-battery.patch
git-selinux.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-wd33c93c-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
remove-the-dead-cyberstormiii_scsi-option.patch
scsi-lpfc-lpfc_initc-remove-unused-variable.patch
git-unionfs.patch
git-ipwireless_cs.patch
fix-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch
fix-x86_64-mm-xen-xen-event-channels.patch
arch-i386-xen-mmuc-must-include-linux-schedh.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
i386-remove-support-for-the-rise-cpu.patch
i386-make-arch-i386-mm-pgtablecpgd_cdtor-static.patch
xen-fix-x86-config-dependencies.patch
xen-suppress-abs-symbol-warnings-for-unused-reloc-pointers.patch
xen-cant-support-numa-yet.patch
mm-slabc-start_cpu_timer-should-be-__cpuinit.patch
handle-kernelcore=-generic.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
mm-slubc-make-code-static.patch
swsusp-remove-code-duplication-between-diskc-and-userc.patch
more-scheduled-oss-driver-removal.patch
init-wait-for-asynchronously-scanned-block-devices.patch
init-wait-for-asynchronously-scanned-block-devices-fix.patch
kernel-utf-8-handling-fix.patch
remove-sonypi_camera_command.patch
fs-namespacec-should-include-internalh.patch
proper-prototype-for-proc_nr_files.patch
fs-reiserfs-cleanups.patch
remove-mm-backing-devccongestion_wait_interruptible.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
revoke-core-code.patch
oss-trident-fix-locking-around-write_voice_regs.patch
remove-options-depending-on-oss_obsolete.patch
fbdev-move-arch-specific-bits-to-their-respective-fix-include-asm-m68k-fbh.patch
pm3fb-possible-cleanups.patch
vt8623fbc-make-code-static.patch
intel-iommu-intel-iommu-driver-fix-duplicate-config_dmar-makefile-line.patch
mm-variable-length-argument-support-fix-2.patch
kernel-sched_fairc-make-code-static.patch
fs-proc-basec-make-a-struct-static.patch
mm-implement-swap-prefetching-make-mm-swap_prefetchcremove_from_swapped_list.patch
kernel-relayc-make-functions-static.patch
drivers-edac-core-make-functions-static.patch
lockstat-human-readability-tweaks-fix.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
