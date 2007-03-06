From: akpm@linux-foundation.org
Subject: - libata-kconfig-update-the-various-experimentality-levels.patch removed from -mm tree
Date: Tue, 06 Mar 2007 13:27:19 -0800
Message-ID: <200703062127.l26LRKMS009981@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58917 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965185AbXCFV1c (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 16:27:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     libata Kconfig: Update the various experimentality levels
has been removed from the -mm tree.  Its filename was
     libata-kconfig-update-the-various-experimentality-levels.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: libata Kconfig: Update the various experimentality levels
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/Kconfig |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN drivers/ata/Kconfig~libata-kconfig-update-the-various-experimentality-levels drivers/ata/Kconfig
--- a/drivers/ata/Kconfig~libata-kconfig-update-the-various-experimentality-levels
+++ a/drivers/ata/Kconfig
@@ -193,7 +193,7 @@ config PATA_ALI
 	  If unsure, say N.
 
 config PATA_AMD
-	tristate "AMD/NVidia PATA support (Experimental)"
+	tristate "AMD/NVidia PATA support"
 	depends on PCI
 	help
 	  This option enables support for the AMD and NVidia PATA
@@ -292,7 +292,7 @@ config ATA_GENERIC
 	  If unsure, say N.
 
 config PATA_HPT366
-	tristate "HPT 366/368 PATA support (Very Experimental)"
+	tristate "HPT 366/368 PATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for the HPT 366 and 368
@@ -301,7 +301,7 @@ config PATA_HPT366
 	  If unsure, say N.
 
 config PATA_HPT37X
-	tristate "HPT 370/370A/371/372/374/302 PATA support (Very Experimental)"
+	tristate "HPT 370/370A/371/372/374/302 PATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for the majority of the later HPT
@@ -328,7 +328,7 @@ config PATA_HPT3X3
 	  If unsure, say N.
 
 config PATA_ISAPNP
-	tristate "ISA Plug and Play PATA support (Very Experimental)"
+	tristate "ISA Plug and Play PATA support (Experimental)"
 	depends on EXPERIMENTAL && ISAPNP
 	help
 	  This option enables support for ISA plug & play ATA
@@ -337,8 +337,8 @@ config PATA_ISAPNP
 	  If unsure, say N.
 
 config PATA_IT821X
-	tristate "IT8211/2 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	tristate "IT8211/2 PATA support"
+	depends on PCI
 	help
 	  This option enables support for the ITE 8211 and 8212
 	  PATA controllers via the new ATA layer, including RAID
@@ -409,10 +409,10 @@ config PATA_MPIIX
 	  If unsure, say N.
 
 config PATA_OLDPIIX
-	tristate "Intel PATA old PIIX support (Experimental)"
+	tristate "Intel PATA support for the original PIIX"
 	depends on PCI && EXPERIMENTAL
 	help
-	  This option enables support for old(?) PIIX PATA support.
+	  This option enables support for early Intel PIIX PATA support.
 
 	  If unsure, say N.
 
@@ -463,7 +463,7 @@ config PATA_PCMCIA
 	  If unsure, say N.
 
 config PATA_PDC_OLD
-	tristate "Older Promise PATA controller support (Very Experimental)"
+	tristate "Older Promise PATA controller support (Experimental)"
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for the Promise 20246, 20262, 20263,
@@ -496,7 +496,7 @@ config PATA_RZ1000
 	  If unsure, say N.
 
 config PATA_SC1200
-	tristate "SC1200 PATA support (Raving Lunatic)"
+	tristate "SC1200 PATA support (Very Experimental)"
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for the NatSemi/AMD SC1200 SoC
@@ -505,8 +505,8 @@ config PATA_SC1200
 	  If unsure, say N.
 
 config PATA_SERVERWORKS
-	tristate "SERVERWORKS OSB4/CSB5/CSB6/HT1000 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	tristate "SERVERWORKS OSB4/CSB5/CSB6/HT1000 PATA support"
+	depends on PCI
 	help
 	  This option enables support for the Serverworks OSB4/CSB5/CSB6 and
 	  HT1000 PATA controllers, via the new ATA layer.
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-libata-all.patch
libata-warn-if-speed-limited-due-to-40-wire-cable-v2.patch
expose-set_mode-method-so-it-can-be-wrapped.patch
acpi-driver-support-for-pata.patch
pcmcia-spot-slave-decode-flaws-for-testing.patch
libata-cable-detection-fixes.patch
pata_platform-set-a-cable-type-which-to-set.patch
pata_qdi-set-cable-type.patch
pata_sl82c105-missing-methods-cable.patch
ata_generic-remove-lots-of-code-using-the-new-cable_detect.patch
pata_ali-remove-lots-of-code-by-using-the-cable_detect.patch
pata_cs55x0-clean-up-by-using-the-cable_detect-method.patch
pata_cypress-clean-up-by-using-cable_detect-method.patch
pata_isapnp-set-cable-type.patch
pata_ixp4xx_cf-set-cable-type.patch
pata_legacy-fix-missing-methods-and-add-cable-types.patch
pata_netcell-remove-lots-of-crud-by-using-the-cable-method.patch
pata_radisys-switch-to-cable-method-to-cleanup-code.patch
pata_sc1200-set-cable-type-add-freeze-thaw-methods.patch
pata_rz1000-remove-lots-of-crap-by-using-cable-method.patch
pata_winbond-set-cable-type.patch
pata_cmd64x-various-fixes.patch
pata_hpt3x3-clean-up-by-using-cable-method.patch
pata_cmd640-cmd640-pci-support.patch
libata-kconfig-update-the-various-experimentality-levels.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
resend-iphase-64bit-cleanup.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
tty-clarify-documentation-of-write.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
