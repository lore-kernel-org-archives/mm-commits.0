From: akpm@linux-foundation.org
Subject: - sata_mv-test-patch-for-hightpoint-rocketraid-1740-1742.patch removed from -mm tree
Date: Mon, 06 Aug 2007 00:53:11 -0700
Message-ID: <200708060753.l767rBUW016316@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55567 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754726AbXHFHx2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 03:53:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     sata_mv: test patch for Hightpoint RocketRaid 1740/1742
has been removed from the -mm tree.  Its filename was
     sata_mv-test-patch-for-hightpoint-rocketraid-1740-1742.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sata_mv: test patch for Hightpoint RocketRaid 1740/1742
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Underneath all the HPT packaging, PCI identifiers, binary driver modules
and stuff you find that ...

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_mv.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/ata/sata_mv.c~sata_mv-test-patch-for-hightpoint-rocketraid-1740-1742 drivers/ata/sata_mv.c
--- a/drivers/ata/sata_mv.c~sata_mv-test-patch-for-hightpoint-rocketraid-1740-1742
+++ a/drivers/ata/sata_mv.c
@@ -621,6 +621,9 @@ static const struct pci_device_id mv_pci
 	{ PCI_VDEVICE(MARVELL, 0x5041), chip_504x },
 	{ PCI_VDEVICE(MARVELL, 0x5080), chip_5080 },
 	{ PCI_VDEVICE(MARVELL, 0x5081), chip_508x },
+	/* RocketRAID 1740/174x have different identifiers */
+	{ PCI_VDEVICE(TTI, 0x1740), chip_508x },
+	{ PCI_VDEVICE(TTI, 0x1742), chip_508x },
 
 	{ PCI_VDEVICE(MARVELL, 0x6040), chip_604x },
 	{ PCI_VDEVICE(MARVELL, 0x6041), chip_604x },
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

nozomi-shoot-defunct-label.patch
git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
libata-acpi-checks-for-80wire-cable-headers.patch
libata-acpi-checks-for-80wire-cable-implementation.patch
libata-acpi-checks-for-80wire-cable-use-in-pata_amd.patch
libata-acpi-checks-for-80wire-cable-use-in-pata_via.patch
libata-correct-iordy-handling.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
dtc-clean-up-indent-damage-and-add-printk-levels.patch
kl5kusb105-switch-to-new-speed-api.patch
mct_u232-convert-to-proper-speed-handling-api-fix.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
usb-serial-fix-oti6858c-segfault-in-termios-handling.patch
blackfin-enable-arbitary-speed-serial-setting.patch
char-cyclades-remove-bottom-half-processing.patch
