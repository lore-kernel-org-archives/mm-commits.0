From: akpm@linux-foundation.org
Subject: [merged] ahci-add-the-ahci-controller-linux-device-id-for-nvidia-chipsets.patch removed from -mm tree
Date: Fri, 16 Oct 2009 13:48:50 -0700
Message-ID: <200910162048.n9GKmoRp030742@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46124 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751286AbZJPUtw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Oct 2009 16:49:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peerchen@gmail.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     ahci: add the AHCI controller Linux Device ID for NVIDIA  chipsets.
has been removed from the -mm tree.  Its filename was
     ahci-add-the-ahci-controller-linux-device-id-for-nvidia-chipsets.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ahci: add the AHCI controller Linux Device ID for NVIDIA  chipsets.
From: peer chen <peerchen@gmail.com>

Add the generic device ID for NVIDIA AHCI controller.

Signed-off-by: Peer Chen<peerchen@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/ata/ahci.c~ahci-add-the-ahci-controller-linux-device-id-for-nvidia-chipsets drivers/ata/ahci.c
--- a/drivers/ata/ahci.c~ahci-add-the-ahci-controller-linux-device-id-for-nvidia-chipsets
+++ a/drivers/ata/ahci.c
@@ -605,6 +605,7 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(NVIDIA, 0x0559), board_ahci_yesncq },	/* MCP67 */
 	{ PCI_VDEVICE(NVIDIA, 0x055a), board_ahci_yesncq },	/* MCP67 */
 	{ PCI_VDEVICE(NVIDIA, 0x055b), board_ahci_yesncq },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x0580), board_ahci_yesncq },	/* Linux ID */
 	{ PCI_VDEVICE(NVIDIA, 0x07f0), board_ahci_yesncq },	/* MCP73 */
 	{ PCI_VDEVICE(NVIDIA, 0x07f1), board_ahci_yesncq },	/* MCP73 */
 	{ PCI_VDEVICE(NVIDIA, 0x07f2), board_ahci_yesncq },	/* MCP73 */
_

Patches currently in -mm which might be from peerchen@gmail.com are

origin.patch

