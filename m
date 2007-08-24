From: akpm@linux-foundation.org
Subject: - pata_sis-add-the-fsc-amilo-and-friends.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:57:35 -0700
Message-ID: <200708242057.l7OKvZLJ014232@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34724 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760064AbXHXVIg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:08:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pata_sis: add the FSC Amilo and friends
has been removed from the -mm tree.  Its filename was
     pata_sis-add-the-fsc-amilo-and-friends.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pata_sis: add the FSC Amilo and friends
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

More short cables

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_sis.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/ata/pata_sis.c~pata_sis-add-the-fsc-amilo-and-friends drivers/ata/pata_sis.c
--- a/drivers/ata/pata_sis.c~pata_sis-add-the-fsc-amilo-and-friends
+++ a/drivers/ata/pata_sis.c
@@ -54,6 +54,7 @@ struct sis_laptop {
 static const struct sis_laptop sis_laptop[] = {
 	/* devid, subvendor, subdev */
 	{ 0x5513, 0x1043, 0x1107 },	/* ASUS A6K */
+	{ 0x5513, 0x1734, 0x105F },	/* FSC Amilo A1630 */
 	/* end marker */
 	{ 0, }
 };
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-switch-most-of-the-remaining-sff-drivers-to.patch
pata_marvell-add-more-identifiers.patch
libata-portmap-remove-unused-definitions.patch
libata-correct-handling-of-srst-reset-sequences.patch
libata-spot-bridge-chips.patch
libata-allow-for-original-ide-drives-that-dont-support-geometry-setting.patch
libata-strict-checking-for-identify-reporting.patch
libata-add-a-drivers-ide-style-dma-disable.patch
st340823a-hpa-and-libata.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
serial_txx9-cleanup-includes.patch
serial-keep-the-dtr-setting-for-serial-console.patch
8250_pci-autodetect-mainpine-cards.patch
git-scsi-misc.patch
fix-gregkh-usb-usb-serial-fix-oti6858c-segfault-in-termios-handling.patch
kobil_sct-rework-driver.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
pci-align-bar-settings-for-legacy-mode-ide.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
blackfin-enable-arbitary-speed-serial-setting.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
ttyh-remove-dead-define.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
