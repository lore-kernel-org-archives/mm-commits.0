From: akpm@linux-foundation.org
Subject: + pata_sis-add-the-fsc-amilo-and-friends.patch added to -mm tree
Date: Wed, 22 Aug 2007 16:14:21 -0700
Message-ID: <200708222314.l7MNELrk009861@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53467 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763246AbXHVXOk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Aug 2007 19:14:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     pata_sis: add the FSC Amilo and friends
has been added to the -mm tree.  Its filename is
     pata_sis-add-the-fsc-amilo-and-friends.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
serial-add-support-for-ite-887x-chips.patch
serial_txx9-fix-modem-control-line-handling.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
fix-null-pointer-dereference-in-__vm_enough_memory.patch
m68k-enable-arbitary-speed-tty-support.patch
introduce-config_check_signature-was-re-uninline.patch
git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-switch-most-of-the-remaining-sff-drivers-to.patch
pata_sis-add-the-fsc-amilo-and-friends.patch
pata_via-add-armia-w730-k8-and-other-rebadgings.patch
st340823a-hpa-and-libata.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
serial_txx9-cleanup-includes.patch
serial-keep-the-dtr-setting-for-serial-console.patch
git-scsi-misc.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
pci-align-bar-settings-for-legacy-mode-ide.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
blackfin-enable-arbitary-speed-serial-setting.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
char-cyclades-remove-bottom-half-processing.patch
