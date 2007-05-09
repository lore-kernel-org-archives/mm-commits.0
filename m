From: akpm@linux-foundation.org
Subject: - fbdev-display-class-fix.patch removed from -mm tree
Date: Tue, 08 May 2007 19:59:13 -0700
Message-ID: <200705090259.l492xDMB010371@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970220AbXEIC71 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:59:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, adaplas@pol.net, greg@kroah.com, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     make drivers/video/display/display-sysfs.c:display_class static
has been removed from the -mm tree.  Its filename was
     fbdev-display-class-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: make drivers/video/display/display-sysfs.c:display_class static
From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: James Simmons <jsimmons@infradead.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/display/display-sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/display/display-sysfs.c~fbdev-display-class-fix drivers/video/display/display-sysfs.c
--- a/drivers/video/display/display-sysfs.c~fbdev-display-class-fix
+++ a/drivers/video/display/display-sysfs.c
@@ -127,7 +127,7 @@ static int display_resume(struct device 
 
 static struct mutex allocated_dsp_lock;
 static DEFINE_IDR(allocated_dsp);
-struct class *display_class;
+static struct class *display_class;
 
 struct display_device *display_device_register(struct display_driver *driver,
 						struct device *parent, void *devdata)
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
git-alsa.patch
git-dvb.patch
git-ieee1394.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mtd.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
drivers-mtd-maps-nettelc-possible-cleanups.patch
ibmtr_cs-fix-hang-on-eject.patch
git-battery.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-wd33c93c-cleanups.patch
make-seagate_st0x_detect-static.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
scsi-lpfc-lpfc_initc-remove-unused-variable.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
drivers-scsi-ipsc-remove-kernel-24-code.patch
drivers-scsi-nsp32c-remove-kernel-24-code.patch
git-unionfs.patch
git-watchdog.patch
git-wireless.patch
git-ipwireless_cs.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
more-scheduled-oss-driver-removal.patch
unexport-pci_proc_attach_device.patch
ext2-reservations.patch
remove-nfs4_acl_add_ace.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
compiler-introduce-__used-and-__maybe_unused.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
slim-main-patch.patch
slim-debug-output.patch
mutex-subsystem-synchro-test-module.patch
