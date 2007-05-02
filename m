From: akpm@linux-foundation.org
Subject: + add-the-ati-sb700-sata-controller-device-id-to-ahci-pci-table.patch added to -mm tree
Date: Tue, 01 May 2007 17:16:15 -0700
Message-ID: <200705020016.l420GFKf009916@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48290 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946146AbXEBAQV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 May 2007 20:16:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: henry.su@amd.com, htejun@gmail.com, jeff@garzik.org


The patch titled
     add the ATI  SB700 SATA controller device id  to AHCI pci table
has been added to the -mm tree.  Its filename is
     add-the-ati-sb700-sata-controller-device-id-to-ahci-pci-table.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: add the ATI  SB700 SATA controller device id  to AHCI pci table
From: "Henry Su" <henry.su@amd.com>

Add the device ID to AHCI pci table for ATI SB700 SATA controller, the
subsequent chipset of SB600.

Signed-off-by: henry su<henry.su@amd.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ahci.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/ata/ahci.c~add-the-ati-sb700-sata-controller-device-id-to-ahci-pci-table drivers/ata/ahci.c
--- a/drivers/ata/ahci.c~add-the-ati-sb700-sata-controller-device-id-to-ahci-pci-table
+++ a/drivers/ata/ahci.c
@@ -400,6 +400,7 @@ static const struct pci_device_id ahci_p
 
 	/* ATI */
 	{ PCI_VDEVICE(ATI, 0x4380), board_ahci_sb600 }, /* ATI SB600 */
+	{ PCI_VDEVICE(ATI, 0x4390), board_ahci_sb600 }, /* ATI SB700 */
 
 	/* VIA */
 	{ PCI_VDEVICE(VIA, 0x3349), board_ahci_vt8251 }, /* VIA VT8251 */
_

Patches currently in -mm which might be from henry.su@amd.com are

add-the-combined-mode-for-ati-sb700.patch
add-the-ati-sb700-sata-controller-device-id-to-ahci-pci-table.patch
