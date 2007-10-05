From: akpm@linux-foundation.org
Subject: - update-documentation-scsi-00-index.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:58:52 -0700
Message-ID: <200710051958.l95Jwq5J022583@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33198 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763165AbXJEUBO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 16:01:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rob@landley.net, mm-commits@vger.kernel.org


The patch titled
     Update Documentation/scsi/00-INDEX
has been removed from the -mm tree.  Its filename was
     update-documentation-scsi-00-index.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Update Documentation/scsi/00-INDEX
From: Rob Landley <rob@landley.net>

Update Documentation/scsi/00-INDEX to match current files.

Signed-off-by: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN Documentation/scsi/00-INDEX~update-documentation-scsi-00-index Documentation/scsi/00-INDEX
--- a/Documentation/scsi/00-INDEX~update-documentation-scsi-00-index
+++ a/Documentation/scsi/00-INDEX
@@ -2,14 +2,20 @@
 	- this file
 53c700.txt
 	- info on driver for 53c700 based adapters
-AM53C974.txt
-	- info on driver for AM53c974 based adapters
 BusLogic.txt
 	- info on driver for adapters with BusLogic chips
-ChangeLog
+ChangeLog.1992-1997
 	- Changes to scsi files, if not listed elsewhere
+ChangeLog.arcmsr
+	- Changes to driver for ARECA's SATA RAID controller cards
 ChangeLog.ips
 	- IBM ServeRAID driver Changelog
+ChangeLog.lpfc
+	- Changes to lpfc driver
+ChangeLog.megaraid
+	- Changes to LSI megaraid controller.
+ChangeLog.megaraid_sas
+	- Changes to serial attached scsi version of LSI megaraid controller.
 ChangeLog.ncr53c8xx
 	- Changes to ncr53c8xx driver
 ChangeLog.sym53c8xx
@@ -20,26 +26,44 @@ FlashPoint.txt
 	- info on driver for BusLogic FlashPoint adapters
 LICENSE.FlashPoint
 	- Licence of the Flashpoint driver
+LICENSE.qla2xxx
+	- License for QLogic Linux Fibre Channel HBA Driver firmware.
 Mylex.txt
 	- info on driver for Mylex adapters
 NinjaSCSI.txt
 	- info on WorkBiT NinjaSCSI-32/32Bi driver
+aacraid.txt
+	- Driver supporting Adaptec RAID controllers
 aha152x.txt
 	- info on driver for Adaptec AHA152x based adapters
+aic79xx.txt
+	- Adaptec Ultra320 SCSI host adapters
 aic7xxx.txt
 	- info on driver for Adaptec controllers
 aic7xxx_old.txt
 	- info on driver for Adaptec controllers, old generation
+arcmsr_spec.txt
+	- ARECA FIRMWARE SPEC (for IOP331 adapter)
+dc395x.txt
+	- README file for the dc395x SCSI driver
 dpti.txt
 	- info on driver for DPT SmartRAID and Adaptec I2O RAID based adapters
 dtc3x80.txt
 	- info on driver for DTC 2x80 based adapters
 g_NCR5380.txt
 	- info on driver for NCR5380 and NCR53c400 based adapters
+hptiop.txt
+	- HIGHPOINT ROCKETRAID 3xxx RAID DRIVER
 ibmmca.txt
 	- info on driver for IBM adapters with MCA bus
 in2000.txt
 	- info on in2000 driver
+libsas.txt
+	- Serial Attached SCSI management layer.
+lpfc.txt
+	- LPFC driver release notes
+megaraid.txt
+	- Common Management Module, shared code handling ioctls for LSI drivers
 ncr53c7xx.txt
 	- info on driver for NCR53c7xx based adapters
 ncr53c8xx.txt
@@ -50,6 +74,8 @@ ppa.txt
 	- info on driver for IOmega zip drive
 qlogicfas.txt
 	- info on driver for QLogic FASxxx based adapters
+scsi-changer.txt
+	- README for the SCSI media changer driver
 scsi-generic.txt
 	- info on the sg driver for generic (non-disk/CD/tape) SCSI devices.
 scsi.txt
@@ -58,6 +84,8 @@ scsi_mid_low_api.txt
 	- info on API between SCSI layer and low level drivers
 scsi_eh.txt
 	- info on SCSI midlayer error handling infrastructure
+scsi_fc_transport.txt
+	- SCSI Fiber Channel Tansport
 st.txt
 	- info on scsi tape driver
 sym53c500_cs.txt
_

Patches currently in -mm which might be from rob@landley.net are

lockstat-documentation.patch
git-arm.patch
git-scsi-misc.patch
docs-ramdisk-initrd-initramfs-corrections.patch
documentation-make-headers_installtxt.patch
documentation-add-entries-to-filesystems-00-index-for-several-untracked-files.patch
add-a-missing-00-index-file-for-documentation-vm.patch
add-a-00-index-file-to-documentation-mips.patch
add-a-00-index-file-to-documentation-sysctl.patch
add-a-00-index-file-to-documentation-telephony.patch
tweak-documentation-sm501txt.patch
add-missing-entries-to-top-level-documentation-00-index.patch
add-documentation-w1w1-masters-00-index.patch
add-entries-to-documentation-powerpc.patch
add-documentation-power-00-index.patch
