From: akpm@linux-foundation.org
Subject: + fbdev-move-arch-specific-bits-to-their-respective-fix-include-asm-m68k-fbh.patch added to -mm tree
Date: Tue, 03 Jul 2007 14:55:19 -0700
Message-ID: <200707032155.l63LtJBS018182@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35161 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753907AbXGCV4D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jul 2007 17:56:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, adaplas@pol.net


The patch titled
     fix include/asm-m68k/fb.h
has been added to the -mm tree.  Its filename is
     fbdev-move-arch-specific-bits-to-their-respective-fix-include-asm-m68k-fbh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix include/asm-m68k/fb.h
From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-m68k/fb.h |    1 +
 1 files changed, 1 insertion(+)

diff -puN include/asm-m68k/fb.h~fbdev-move-arch-specific-bits-to-their-respective-fix-include-asm-m68k-fbh include/asm-m68k/fb.h
--- a/include/asm-m68k/fb.h~fbdev-move-arch-specific-bits-to-their-respective-fix-include-asm-m68k-fbh
+++ a/include/asm-m68k/fb.h
@@ -14,6 +14,7 @@ static inline void fb_pgprotect(struct f
 #else
 static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma,
 				unsigned long off)
+{
 	if (CPU_IS_020_OR_030)
 		pgprot_val(vma->vm_page_prot) |= _PAGE_NOCACHE030;
 	if (CPU_IS_040_OR_060) {
_

Patches currently in -mm which might be from bunk@stusta.de are

git-acpi.patch
make-drivers-acpi-oslcosi_linux-static.patch
drivers-acpi-processor_throttlingc-make-2-functions.patch
drivers-cpuidle-governors-menuc-make-a-struct-static.patch
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
git-netdev-all.patch
bonding-bond_mainc-make-2-functions-static.patch
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
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
i386-remove-support-for-the-rise-cpu.patch
i386-make-arch-i386-mm-pgtablecpgd_cdtor-static.patch
xen-fix-x86-config-dependencies.patch
xen-suppress-abs-symbol-warnings-for-unused-reloc-pointers.patch
mm-slabc-start_cpu_timer-should-be-__cpuinit.patch
handle-kernelcore=-generic-fix.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
swsusp-remove-code-duplication-between-diskc-and-userc-fix.patch
more-scheduled-oss-driver-removal.patch
init-wait-for-asynchronously-scanned-block-devices-fix.patch
kernel-utf-8-handling-fix.patch
remove-sonypi_camera_command.patch
fs-namespacec-should-include-internalh.patch
proper-prototype-for-proc_nr_files.patch
fs-reiserfs-cleanups.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
revoke-core-code.patch
oss-trident-fix-locking-around-write_voice_regs.patch
remove-options-depending-on-oss_obsolete.patch
fbdev-move-arch-specific-bits-to-their-respective-fix-include-asm-m68k-fbh.patch
pm3fb-possible-cleanups.patch
vt8623fbc-make-code-static.patch
kernel-sched_fairc-make-code-static.patch
fs-proc-basec-make-a-struct-static.patch
mm-implement-swap-prefetching-make-mm-swap_prefetchcremove_from_swapped_list.patch
kernel-relayc-make-functions-static.patch
drivers-edac-core-make-functions-static.patch
lockstat-human-readability-tweaks-fix.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
