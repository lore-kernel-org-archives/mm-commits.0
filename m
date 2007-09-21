From: akpm@linux-foundation.org
Subject: + libata-update-experimental-tags-to-reflect-reality-better.patch added to -mm tree
Date: Thu, 20 Sep 2007 23:46:16 -0700
Message-ID: <200709210646.l8L6kGRQ023149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42379 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753238AbXIUGqh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 02:46:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     libata: update experimental tags to reflect reality better
has been added to the -mm tree.  Its filename is
     libata-update-experimental-tags-to-reflect-reality-better.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: update experimental tags to reflect reality better
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/Kconfig |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/ata/Kconfig~libata-update-experimental-tags-to-reflect-reality-better drivers/ata/Kconfig
--- a/drivers/ata/Kconfig~libata-update-experimental-tags-to-reflect-reality-better
+++ a/drivers/ata/Kconfig
@@ -201,8 +201,8 @@ config PATA_AMD
 	  If unsure, say N.
 
 config PATA_ARTOP
-	tristate "ARTOP 6210/6260 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	tristate "ARTOP 6210/6260 PATA support"
+	depends on PCI
 	help
 	  This option enables support for ARTOP PATA controllers.
 
@@ -218,8 +218,8 @@ config PATA_AT32
 	  If unsure, say N.
 
 config PATA_ATIIXP
-	tristate "ATI PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	tristate "ATI PATA support"
+	depends on PCI
 	help
 	  This option enables support for the ATI ATA interfaces
 	  found on the many ATI chipsets.
@@ -237,8 +237,8 @@ config PATA_CMD640_PCI
 	  If unsure, say N.
 
 config PATA_CMD64X
-	tristate "CMD64x PATA support (Very Experimental)"
-	depends on PCI&& EXPERIMENTAL
+	tristate "CMD64x PATA support"
+	depends on PCI
 	help
 	  This option enables support for the CMD64x series chips
 	  except for the CMD640.
@@ -300,8 +300,8 @@ config ATA_GENERIC
 	  If unsure, say N.
 
 config PATA_HPT366
-	tristate "HPT 366/368 PATA support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	tristate "HPT 366/368 PATA support"
+	depends on PCI
 	help
 	  This option enables support for the HPT 366 and 368
 	  PATA controllers via the new ATA layer.
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
pata_acpi-use-ata_sff_port_start.patch
libata-correct-handling-of-srst-reset-sequences.patch
libata-add-a-drivers-ide-style-dma-disable.patch
ata-pata_marvell-use-ioread-for-iomap-ped-memory.patch
drivers-ata-pata_ixp4xx_cfc-ioremap-return-code-check.patch
libata-update-experimental-tags-to-reflect-reality-better.patch
libata-sff-fix-documentation.patch
st340823a-hpa-and-libata.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
introduce-dma_mask_none-as-a-signal-for-unable-to-do.patch
pcmcia-use-dma_mask_none-for-the-default-for-all.patch
serial_txx9-cleanup-includes.patch
serial-keep-the-dtr-setting-for-serial-console.patch
8250_pci-autodetect-mainpine-cards.patch
8250_pci-autodetect-mainpine-cards-fix.patch
wake-up-from-a-serial-port.patch
fix-ide-legacy-mode-resources.patch
fix-ide-legacy-mode-resources-fix.patch
git-scsi-misc.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
blackfin-enable-arbitary-speed-serial-setting.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
ttyh-remove-dead-define.patch
codingstyle-relax-the-80-cole-rule.patch
add-config_vt_unicode.patch
keys-missing-word-in-documentation.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
