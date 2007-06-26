From: akpm@linux-foundation.org
Subject: + fs-namespacec-should-include-internalh.patch added to -mm tree
Date: Tue, 26 Jun 2007 12:35:15 -0700
Message-ID: <200706261935.l5QJZF9C000666@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45548 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758029AbXFZTfa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 15:35:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de


The patch titled
     fs/namespace.c should #include "internal.h"
has been added to the -mm tree.  Its filename is
     fs-namespacec-should-include-internalh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fs/namespace.c should #include "internal.h"
From: Adrian Bunk <bunk@stusta.de>

Every file should include the headers containing the prototypes for
its global functions.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN fs/namespace.c~fs-namespacec-should-include-internalh fs/namespace.c
--- a/fs/namespace.c~fs-namespacec-should-include-internalh
+++ a/fs/namespace.c
@@ -28,6 +28,7 @@
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 #include "pnode.h"
+#include "internal.h"
 
 /* spinlock for vfsmount related operations, inplace of dcache_lock */
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(vfsmount_lock);
_

Patches currently in -mm which might be from bunk@stusta.de are

git-acpi.patch
make-drivers-acpi-oslcosi_linux-static.patch
drivers-acpi-processor_throttlingc-make-2-functions.patch
drivers-cpuidle-governors-menuc-make-a-struct-static.patch
make-drivers-char-hvc_consoleckhvcd-static.patch
git-dvb.patch
git-input.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
mark-calibrate_xor_blocks-__init.patch
git-mmc.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
drivers-mtd-maps-nettelc-possible-cleanups.patch
cafe_nandc-the-olpc-laptop-is-not-available-for-100.patch
git-battery.patch
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
mm-slabc-start_cpu_timer-should-be-__cpuinit.patch
handle-kernelcore=-generic-fix.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
swsusp-remove-code-duplication-between-diskc-and-userc-fix.patch
more-scheduled-oss-driver-removal.patch
kernel-utf-8-handling-fix.patch
remove-sonypi_camera_command.patch
kernel-sys_nic-should-include-linux-syscallsh.patch
fs-namespacec-should-include-internalh.patch
ext2-reservations.patch
revoke-core-code.patch
oss-trident-fix-locking-around-write_voice_regs.patch
remove-options-depending-on-oss_obsolete.patch
pm3fb-possible-cleanups.patch
vt8623fbc-make-code-static.patch
kernel-sched_fairc-make-code-static.patch
fs-proc-basec-make-a-struct-static.patch
mm-implement-swap-prefetching-make-mm-swap_prefetchcremove_from_swapped_list.patch
drivers-edac-core-make-functions-static.patch
lockstat-human-readability-tweaks-fix.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
