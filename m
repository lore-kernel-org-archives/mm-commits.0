From: akpm@linux-foundation.org
Subject: - isdn-fix-typo-config_hisax_quadro-config_hisax_sct_quadro.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:46:11 -0800
Message-ID: <200702122246.l1CMkBxl013779@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45206 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030315AbXBLWqQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:46:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     ISDN: Fix typo "CONFIG_HISAX_QUADRO" -> "CONFIG_HISAX_SCT_QUADRO".
has been removed from the -mm tree.  Its filename was
     isdn-fix-typo-config_hisax_quadro-config_hisax_sct_quadro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ISDN: Fix typo "CONFIG_HISAX_QUADRO" -> "CONFIG_HISAX_SCT_QUADRO".
From: "Robert P. J. Day" <rpjday@mindspring.com>

Replace misspelled CONFIG_HISAX_QUADRO with CONFIG_HISAX_SCT_QUADRO.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Acked-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hisax/config.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/isdn/hisax/config.c~isdn-fix-typo-config_hisax_quadro-config_hisax_sct_quadro drivers/isdn/hisax/config.c
--- a/drivers/isdn/hisax/config.c~isdn-fix-typo-config_hisax_quadro-config_hisax_sct_quadro
+++ a/drivers/isdn/hisax/config.c
@@ -1881,7 +1881,7 @@ static struct pci_device_id hisax_pci_tb
 	{PCI_VENDOR_ID_PLX,      PCI_DEVICE_ID_PLX_DJINN_ITOO,   PCI_ANY_ID, PCI_ANY_ID},
 	{PCI_VENDOR_ID_PLX,      PCI_DEVICE_ID_PLX_OLITEC,       PCI_ANY_ID, PCI_ANY_ID},
 #endif
-#ifdef CONFIG_HISAX_QUADRO
+#ifdef CONFIG_HISAX_SCT_QUADRO
 	{PCI_VENDOR_ID_PLX,      PCI_DEVICE_ID_PLX_9050,         PCI_ANY_ID, PCI_ANY_ID},
 #endif
 #ifdef CONFIG_HISAX_NICCY
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-avr32.patch
git-dvb.patch
kbuild-remove-references-to-deprecated-prepare-all-target.patch
git-mips.patch
git-netdev-all.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
fix-misspelled-usbnet_mii-kernel-config-option.patch
fix-apparent-typo-config_usb_cdcether.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
