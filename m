From: akpm@linux-foundation.org
Subject: - block2mtd_paramline-mustnt-be-__initdata.patch removed from -mm tree
Date: Thu, 03 May 2007 12:31:19 -0700
Message-ID: <200705031931.l43JVJUP018259@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46832 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1162237AbXECTfn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 15:35:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, dwmw2@infradead.org, joern@lazybastard.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     block2mtd_paramline[] mustn't be __initdata
has been removed from the -mm tree.  Its filename was
     block2mtd_paramline-mustnt-be-__initdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: block2mtd_paramline[] mustn't be __initdata
From: Adrian Bunk <bunk@stusta.de>

block2mtd_paramline[] is used in the non-__init block2mtd_setup()

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Joern Engel <joern@lazybastard.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/devices/block2mtd.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mtd/devices/block2mtd.c~block2mtd_paramline-mustnt-be-__initdata drivers/mtd/devices/block2mtd.c
--- a/drivers/mtd/devices/block2mtd.c~block2mtd_paramline-mustnt-be-__initdata
+++ a/drivers/mtd/devices/block2mtd.c
@@ -373,7 +373,7 @@ static inline void kill_final_newline(ch
 
 #ifndef MODULE
 static int block2mtd_init_called = 0;
-static __initdata char block2mtd_paramline[80 + 12]; /* 80 for device, 12 for erase size */
+static char block2mtd_paramline[80 + 12]; /* 80 for device, 12 for erase size */
 #endif
 
 
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
git-acpi.patch
git-alsa.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mmc.patch
git-mtd.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
ibmtr_cs-fix-hang-on-eject.patch
git-ocfs2.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
scsi-lpfc-lpfc_initc-remove-unused-variable.patch
git-unionfs.patch
git-watchdog.patch
git-wireless.patch
git-ipwireless_cs.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
the-scheduled-removal-of-obsolete_oss-options.patch
add-file-position-info-to-proc.patch
more-scheduled-oss-driver-removal.patch
schedule-obsolete-oss-drivers-for-removal-4th-round.patch
make-remove_inode_dquot_ref-static.patch
unexport-pci_proc_attach_device.patch
fix-race-between-rmmod-and-cat-proc-kallsyms.patch
the-scheduled-einval-for-invalid-timevals-in-setitimer.patch
ext2-reservations.patch
make-drivers-isdn-capi-capiutilccdebbuf_alloc-static.patch
remove-nfs4_acl_add_ace.patch
rtc-remove-sys-class-rtc-dev-fix.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
no-longer-include-asm-kdebugh.patch
revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
readahead-events-accounting.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
fbdev-display-class-fix.patch
fbdev-mm-deferred-io-support-fix.patch
fbdev-hecuba-framebuffer-driver-fix.patch
slim-main-patch.patch
slim-debug-output.patch
mutex-subsystem-synchro-test-module.patch
