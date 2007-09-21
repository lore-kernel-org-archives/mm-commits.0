From: akpm@linux-foundation.org
Subject: - ahci-raid-mode-sata-patch-for-intel-tolapai.patch removed from -mm tree
Date: Fri, 21 Sep 2007 14:08:14 -0700
Message-ID: <200709212108.l8LL8EUS023555@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45214 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762131AbXIUVJJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 17:09:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jason.d.gaston@intel.com, mm-commits@vger.kernel.org


The patch titled
     ahci: RAID mode SATA patch for Intel Tolapai
has been removed from the -mm tree.  Its filename was
     ahci-raid-mode-sata-patch-for-intel-tolapai.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ahci: RAID mode SATA patch for Intel Tolapai
From: Jason Gaston <jason.d.gaston@intel.com>

This patch adds the Intel Tolapai RAID controller DID's for SATA support.

Signed-off-by: Jason Gaston <jason.d.gaston@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ahci.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN drivers/ata/ahci.c~ahci-raid-mode-sata-patch-for-intel-tolapai drivers/ata/ahci.c
--- a/drivers/ata/ahci.c~ahci-raid-mode-sata-patch-for-intel-tolapai
+++ a/drivers/ata/ahci.c
@@ -409,6 +409,8 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(INTEL, 0x292f), board_ahci_pi }, /* ICH9M */
 	{ PCI_VDEVICE(INTEL, 0x294d), board_ahci_pi }, /* ICH9 */
 	{ PCI_VDEVICE(INTEL, 0x294e), board_ahci_pi }, /* ICH9M */
+	{ PCI_VDEVICE(INTEL, 0x502a), board_ahci }, /* Tolapai */
+	{ PCI_VDEVICE(INTEL, 0x502b), board_ahci }, /* Tolapai */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
_

Patches currently in -mm which might be from jason.d.gaston@intel.com are

git-libata-all.patch
