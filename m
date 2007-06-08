From: akpm@linux-foundation.org
Subject: - fix-2-gregkh-driver-dmi-based-module-autoloading.patch removed from -mm tree
Date: Fri, 08 Jun 2007 10:35:29 -0700
Message-ID: <200706081735.l58HZTcB006367@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45773 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937159AbXFHRgF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 13:36:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mzxreary@0pointer.de, mm-commits@vger.kernel.org


The patch titled
     gregkh-driver-dmi-based-module-autoloading fix 2
has been removed from the -mm tree.  Its filename was
     fix-2-gregkh-driver-dmi-based-module-autoloading.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: gregkh-driver-dmi-based-module-autoloading fix 2
From: Adrian Bunk <bunk@stusta.de>

Make the needlessly global dmi_id_init() static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Lennart Poettering <mzxreary@0pointer.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dmi-id.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/firmware/dmi-id.c~fix-2-gregkh-driver-dmi-based-module-autoloading drivers/firmware/dmi-id.c
--- a/drivers/firmware/dmi-id.c~fix-2-gregkh-driver-dmi-based-module-autoloading
+++ a/drivers/firmware/dmi-id.c
@@ -161,7 +161,7 @@ static struct device *dmi_dev;
 
 extern int dmi_available;
 
-int __init dmi_id_init(void)
+static int __init dmi_id_init(void)
 {
 	int ret, i;
 
_

Patches currently in -mm which might be from bunk@stusta.de are

git-acpi.patch
make-drivers-char-hvc_consoleckhvcd-static.patch
git-dvb.patch
git-input-make-xpad_play_effect-static.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mmc.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
drivers-mtd-maps-nettelc-possible-cleanups.patch
git-battery.patch
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
fs-proc-basec-make-a-struct-static.patch
drivers-edac-core-make-functions-static.patch
lockstat-human-readability-tweaks-fix.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
