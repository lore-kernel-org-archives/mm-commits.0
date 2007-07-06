From: akpm@linux-foundation.org
Subject: + fix-x86_64-mm-xen-xen-event-channels.patch added to -mm tree
Date: Fri, 06 Jul 2007 10:44:48 -0700
Message-ID: <200707061744.l66Him5J010519@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50538 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760257AbXGFRpf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jul 2007 13:45:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, jeremy@goop.org


The patch titled
     arch/i386/xen/events.c should #include <asm/xen/hypervisor.h>
has been added to the -mm tree.  Its filename is
     fix-x86_64-mm-xen-xen-event-channels.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: arch/i386/xen/events.c should #include <asm/xen/hypervisor.h>
From: Adrian Bunk <bunk@stusta.de>

Every file should include the headers containing the prototypes for
its global functions.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/xen/events.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/i386/xen/events.c~fix-x86_64-mm-xen-xen-event-channels arch/i386/xen/events.c
--- a/arch/i386/xen/events.c~fix-x86_64-mm-xen-xen-event-channels
+++ a/arch/i386/xen/events.c
@@ -31,6 +31,7 @@
 #include <asm/irq.h>
 #include <asm/sync_bitops.h>
 #include <asm/xen/hypercall.h>
+#include <asm/xen/hypervisor.h>
 
 #include <xen/events.h>
 #include <xen/interface/xen.h>
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default-fix.patch
drivers-acpi-sbsc-remove-dead-code.patch
git-alsa.patch
make-drivers-char-hvc_consoleckhvcd-static.patch
git-dvb.patch
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
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
i386-remove-support-for-the-rise-cpu.patch
i386-make-arch-i386-mm-pgtablecpgd_cdtor-static.patch
xen-fix-x86-config-dependencies.patch
xen-suppress-abs-symbol-warnings-for-unused-reloc-pointers.patch
xen-cant-support-numa-yet.patch
mm-slabc-start_cpu_timer-should-be-__cpuinit.patch
handle-kernelcore=-generic-fix.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
mm-slubc-make-code-static.patch
swsusp-remove-code-duplication-between-diskc-and-userc-fix.patch
more-scheduled-oss-driver-removal.patch
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
immediate-value-add-kconfig-menus.patch
linux-kernel-markers-add-kconfig-menus-for-the-marker-code.patch
drivers-edac-core-make-functions-static.patch
lockstat-human-readability-tweaks-fix.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
