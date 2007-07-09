From: akpm@linux-foundation.org
Subject: - kernel-utf-8-handling-fix.patch removed from -mm tree
Date: Mon, 09 Jul 2007 14:56:11 -0700
Message-ID: <200707092156.l69LuBEw014586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47097 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755852AbXGIV5S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 17:57:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, adaplas@pol.net, dtor@mail.ru, jengelh@gmx.de, patrakov@ums.usu.ru, mm-commits@vger.kernel.org


The patch titled
     make drivers/char/selection.c:store_utf8() static
has been removed from the -mm tree.  Its filename was
     kernel-utf-8-handling-fix.patch

This patch was dropped because it was folded into kernel-utf-8-handling.patch

------------------------------------------------------
Subject: make drivers/char/selection.c:store_utf8() static
From: Adrian Bunk <bunk@stusta.de>

This patch makes the needlessly global store_utf8() static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Jan Engelhardt <jengelh@gmx.de>
Cc: Alexander E. Patrakov <patrakov@ums.usu.ru>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/selection.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/selection.c~kernel-utf-8-handling-fix drivers/char/selection.c
--- a/drivers/char/selection.c~kernel-utf-8-handling-fix
+++ a/drivers/char/selection.c
@@ -112,7 +112,7 @@ static inline unsigned short limit(const
 }
 
 /* stores the char in UTF8 and returns the number of bytes used (1-3) */
-int store_utf8(u16 c, char *p)
+static int store_utf8(u16 c, char *p)
 {
 	if (c < 0x80) {
 		/*  0******* */
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
kernel-utf-8-handling.patch
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
