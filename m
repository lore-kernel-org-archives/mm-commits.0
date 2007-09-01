From: akpm@linux-foundation.org
Subject: + 8250_pci-autodetect-mainpine-cards-fix.patch added to -mm tree
Date: Fri, 31 Aug 2007 17:37:32 -0700
Message-ID: <200709010037.l810bWdH001524@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38582 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751228AbXIAAhr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 20:37:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     pci.h: Add PCI identifiers for mainpine cards
has been added to the -mm tree.  Its filename is
     8250_pci-autodetect-mainpine-cards-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pci.h: Add PCI identifiers for mainpine cards
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pci_ids.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/pci_ids.h~8250_pci-autodetect-mainpine-cards-fix include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~8250_pci-autodetect-mainpine-cards-fix
+++ a/include/linux/pci_ids.h
@@ -1975,6 +1975,8 @@
 #define PCI_VENDOR_ID_TOPIC		0x151f
 #define PCI_DEVICE_ID_TOPIC_TP560	0x0000
 
+#define PCI_VENDOR_ID_MAINPINE		0x1522
+#define PCI_DEVICE_ID_MAINPINE_PBRIDGE	0x0100
 #define PCI_VENDOR_ID_ENE		0x1524
 #define PCI_DEVICE_ID_ENE_CB712_SD	0x0550
 #define PCI_DEVICE_ID_ENE_CB712_SD_2	0x0551
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

drivers-edac-fix-printk-level-down-to-debug-from-emerg.patch
drivers-edac-fix-e752x-correct-return-code.patch
git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-correct-handling-of-srst-reset-sequences.patch
libata-add-a-drivers-ide-style-dma-disable.patch
ata-pata_marvell-use-ioread-for-iomap-ped-memory.patch
st340823a-hpa-and-libata.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
serial_txx9-cleanup-includes.patch
serial-keep-the-dtr-setting-for-serial-console.patch
8250_pci-autodetect-mainpine-cards.patch
8250_pci-autodetect-mainpine-cards-fix.patch
fix-ide-legacy-mode-resources.patch
fix-ide-legacy-mode-resources-fix.patch
git-scsi-misc.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
git-xtensa.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
blackfin-enable-arbitary-speed-serial-setting.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
ttyh-remove-dead-define.patch
codingstyle-relax-the-80-cole-rule.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
