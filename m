From: akpm@linux-foundation.org
Subject: + kernel-sched_fairc-make-code-static.patch added to -mm tree
Date: Tue, 05 Jun 2007 23:54:54 -0700
Message-ID: <200706060654.l566ssVI011275@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35684 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964934AbXFFGzI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2007 02:55:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de


The patch titled
     kernel/sched{,_fair}.c: make code static
has been added to the -mm tree.  Its filename is
     kernel-sched_fairc-make-code-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel/sched{,_fair}.c: make code static
From: Adrian Bunk <bunk@stusta.de>

This patch makes some needlessly global code static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sched.c~kernel-sched_fairc-make-code-static kernel/sched.c
--- a/kernel/sched.c~kernel-sched_fairc-make-code-static
+++ a/kernel/sched.c
@@ -562,7 +562,7 @@ static inline void resched_task(struct t
  * if you go up 1 level, it's -10% CPU usage, if you go down 1 level
  * it's +10% CPU usage.
  */
-const int prio_to_weight[40] = {
+static const int prio_to_weight[40] = {
 /* -20 */ 88818, 71054, 56843, 45475, 36380, 29104, 23283, 18626, 14901, 11921,
 /* -10 */  9537,  7629,  6103,  4883,  3906,  3125,  2500,  2000,  1600,  1280,
 /*   0 */  NICE_0_LOAD /* 1024 */,
_

Patches currently in -mm which might be from bunk@stusta.de are

git-acpi.patch
make-drivers-char-hvc_consoleckhvcd-static.patch
fix-2-gregkh-driver-dmi-based-module-autoloading.patch
git-dvb-fix-the-tea5761-tuner-support.patch
git-input-make-xpad_play_effect-static.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
drivers-mtd-maps-nettelc-possible-cleanups.patch
git-battery.patch
unexport-pci_proc_attach_device.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-wd33c93c-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
scsi-lpfc-lpfc_initc-remove-unused-variable.patch
git-unionfs.patch
git-wireless.patch
git-ipwireless_cs.patch
fix-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
i386-remove-support-for-the-rise-cpu.patch
i386-make-arch-i386-mm-pgtablecpgd_cdtor-static.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
swsusp-remove-code-duplication-between-diskc-and-userc-fix.patch
more-scheduled-oss-driver-removal.patch
remove-sonypi_camera_command.patch
ext2-reservations.patch
revoke-core-code.patch
oss-trident-fix-locking-around-write_voice_regs.patch
pm3fb-possible-cleanups.patch
vt8623fbc-make-code-static.patch
kernel-sched_fairc-make-code-static.patch
drivers-edac-core-make-functions-static.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
