From: akpm@linux-foundation.org
Subject: - acpi-driver-support-for-pata-fix.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:29:06 -0800
Message-ID: <200702282329.l1SNT6fD030379@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47499 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246AbXB1Xah (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:30:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alan@redhat.com, htejun@gmail.com, jeff@garzik.org, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi-driver-support-for-pata-fix
has been removed from the -mm tree.  Its filename was
     acpi-driver-support-for-pata-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: acpi-driver-support-for-pata-fix
From: Andrew Morton <akpm@linux-foundation.org>

They've been renaming stuff again.

Cc: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-acpi.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/ata/libata-acpi.c~acpi-driver-support-for-pata-fix drivers/ata/libata-acpi.c
--- a/drivers/ata/libata-acpi.c~acpi-driver-support-for-pata-fix
+++ a/drivers/ata/libata-acpi.c
@@ -295,8 +295,8 @@ static int do_drive_get_GTF(struct ata_p
 
 	if (ata_msg_probe(ap))
 		ata_dev_printk(atadev, KERN_DEBUG,
-			"%s: ENTER: ap->id: %d, port#: %d\n",
-			__FUNCTION__, ap->id, ap->port_no);
+			"%s: ENTER: ap->print_id: %d, port#: %d\n",
+			__FUNCTION__, ap->print_id, ap->port_no);
 
 	if (!ata_dev_enabled(atadev) || (ap->flags & ATA_FLAG_DISABLED)) {
 		if (ata_msg_probe(ap))
@@ -522,8 +522,8 @@ static int do_drive_set_taskfiles(struct
 
 	if (ata_msg_probe(ap))
 		ata_dev_printk(atadev, KERN_DEBUG,
-			"%s: ENTER: ap->id: %d, port#: %d\n",
-			__FUNCTION__, ap->id, ap->port_no);
+			"%s: ENTER: ap->print_id: %d, port#: %d\n",
+			__FUNCTION__, ap->print_id, ap->port_no);
 
 	if (noacpi || !(ap->cbl == ATA_CBL_SATA))
 		return 0;
@@ -628,8 +628,8 @@ int ata_acpi_push_id(struct ata_port *ap
 
 	if (ata_msg_probe(ap))
 		ata_dev_printk(atadev, KERN_DEBUG,
-			"%s: ap->id: %d, ix = %d, port#: %d\n",
-			__FUNCTION__, ap->id, ix, ap->port_no);
+			"%s: ap->print_id: %d, ix = %d, port#: %d\n",
+			__FUNCTION__, ap->print_id, ix, ap->port_no);
 
 	/* Don't continue if not a SATA device. */
 	if (!(ap->cbl == ATA_CBL_SATA)) {
@@ -686,7 +686,7 @@ int ata_acpi_push_id(struct ata_port *ap
 		if (ata_msg_probe(ap))
 			ata_dev_printk(atadev, KERN_DEBUG,
 				"ata%u(%u): %s _SDD error: status = 0x%x\n",
-				ap->id, ap->device->devno,
+				ap->print_id, ap->device->devno,
 				__FUNCTION__, status);
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-drm.patch
git-dvb.patch
pvrusb-warning-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-leds-fixup.patch
acpi-driver-support-for-pata-fix.patch
git-md-accel-vs-md.patch
dmaengine-uninline-large-functions.patch
git-mips-fixup.patch
nommu-present-backing-device-capabilities-for-mtd-fix.patch
git-ubi.patch
git-netdev-all.patch
Fabric7-VIOC-driver-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
git-parisc-fixup.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-block-another-md-fix.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch
after-before-x86_64-mm-mmconfig-share.patch
throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations.patch
ext-ea-block-reference-count-racing-fix-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
kvm-add-internal-filesystem-for-generating-inodes-tweak.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy.patch
utrace-prep.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
