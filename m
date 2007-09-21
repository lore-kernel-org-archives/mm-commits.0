From: akpm@linux-foundation.org
Subject: - libata-update-the-blacklist-with-a-few-more-devices.patch removed from -mm tree
Date: Fri, 21 Sep 2007 13:41:14 -0700
Message-ID: <200709212041.l8LKfE9a021626@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48142 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750987AbXIUUl7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 16:41:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     libata: update the blacklist with a few more devices
has been removed from the -mm tree.  Its filename was
     libata-update-the-blacklist-with-a-few-more-devices.patch

This patch was dropped because Jeff deleted the code with it patches

------------------------------------------------------
Subject: libata: update the blacklist with a few more devices
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/ata/libata-core.c~libata-update-the-blacklist-with-a-few-more-devices drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-update-the-blacklist-with-a-few-more-devices
+++ a/drivers/ata/libata-core.c
@@ -3899,6 +3899,9 @@ static const struct ata_blacklist_entry 
 	{ "Maxtor 6L250S0",     "BANC1G10",     ATA_HORKAGE_NONCQ },
 	{ "Maxtor 6B200M0",	"BANC1BM0",	ATA_HORKAGE_NONCQ },
 	{ "Maxtor 6B200M0",	"BANC1B10",	ATA_HORKAGE_NONCQ },
+	{ "Maxtor 7B250S0",	"BANC1B70",	ATA_HORKAGE_NONCQ, },
+	{ "Maxtor 7B300S0",	"BANC1B70",	ATA_HORKAGE_NONCQ },
+	{ "Maxtor 7V300F0",	"VA111630",	ATA_HORKAGE_NONCQ },
 	{ "HITACHI HDS7250SASUN500G 0621KTAWSD", "K2AOAJ0AHITACHI",
 	 ATA_HORKAGE_NONCQ },
 	/* NCQ hard hangs device under heavier load, needs hard power cycle */
@@ -3915,6 +3918,7 @@ static const struct ata_blacklist_entry 
 	{ "WDC WD740ADFD-00NLR1", NULL,		ATA_HORKAGE_NONCQ, },
 	{ "FUJITSU MHV2080BH",	"00840028",	ATA_HORKAGE_NONCQ, },
 	{ "ST9160821AS",	"3.CLF",	ATA_HORKAGE_NONCQ, },
+	{ "ST3160812AS",	"3.AD",		ATA_HORKAGE_NONCQ, },
 	{ "SAMSUNG HD401LJ",	"ZZ100-15",	ATA_HORKAGE_NONCQ, },
 
 	/* devices which puke on READ_NATIVE_MAX */
@@ -3925,6 +3929,7 @@ static const struct ata_blacklist_entry 
 
 	/* Devices which report 1 sector over size HPA */
 	{ "ST340823A",		NULL,		ATA_HORKAGE_HPA_SIZE, },
+	{ "ST320413A",		NULL,		ATA_HORKAGE_HPA_SIZE, },
 
 	/* End Marker */
 	{ }
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
pata_acpi-use-ata_sff_port_start.patch
libata-correct-handling-of-srst-reset-sequences.patch
libata-add-a-drivers-ide-style-dma-disable.patch
ata-pata_marvell-use-ioread-for-iomap-ped-memory.patch
drivers-ata-pata_ixp4xx_cfc-ioremap-return-code-check.patch
libata-update-the-blacklist-with-a-few-more-devices.patch
libata-add-a-horkage-entry-for-drq-mishandling-atapi.patch
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
dtc-fix-typo.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
blackfin-enable-arbitary-speed-serial-setting.patch
tty-bring-the-old-cris-driver-back-somewhere-into-the.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
ttyh-remove-dead-define.patch
codingstyle-relax-the-80-cole-rule.patch
add-config_vt_unicode.patch
keys-missing-word-in-documentation.patch
ide-cd-is-unmaintained.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios-fix.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
