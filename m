From: akpm@linux-foundation.org
Subject: - ahci-raid-mode-sata-patch-for-intel-ibex-peak-deviceids.patch removed from -mm tree
Date: Fri, 22 Aug 2008 15:56:04 -0700
Message-ID: <200808222256.m7MMu4vk020885@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43189 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753763AbYHVW5j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Aug 2008 18:57:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: seth.heasley@intel.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     ahci: RAID mode SATA patch for Intel Ibex Peak DeviceIDs
has been removed from the -mm tree.  Its filename was
     ahci-raid-mode-sata-patch-for-intel-ibex-peak-deviceids.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ahci: RAID mode SATA patch for Intel Ibex Peak DeviceIDs
From: Seth Heasley <seth.heasley@intel.com>

Add the Intel Ibex Peak (PCH) SATA RAID Controllers DeviceIDs.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ahci.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/ata/ahci.c~ahci-raid-mode-sata-patch-for-intel-ibex-peak-deviceids drivers/ata/ahci.c
--- a/drivers/ata/ahci.c~ahci-raid-mode-sata-patch-for-intel-ibex-peak-deviceids
+++ a/drivers/ata/ahci.c
@@ -486,6 +486,8 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(INTEL, 0x502b), board_ahci }, /* Tolapai */
 	{ PCI_VDEVICE(INTEL, 0x3a05), board_ahci }, /* ICH10 */
 	{ PCI_VDEVICE(INTEL, 0x3a25), board_ahci }, /* ICH10 */
+	{ PCI_VDEVICE(INTEL, 0x3b24), board_ahci }, /* PCH RAID */
+	{ PCI_VDEVICE(INTEL, 0x3b2b), board_ahci }, /* PCH RAID */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
_

Patches currently in -mm which might be from seth.heasley@intel.com are

origin.patch
linux-next.patch

