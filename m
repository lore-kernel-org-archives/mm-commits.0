From: akpm@linux-foundation.org
Subject: + ahci-add-the-ahci-controller-linux-device-id-for-nvidia-chipsets.patch added to -mm tree
Date: Thu, 15 Oct 2009 12:31:20 -0700
Message-ID: <200910151931.n9FJVKBY027404@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60935 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933195AbZJOTd2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Oct 2009 15:33:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peerchen@gmail.com, tj@kernel.org


The patch titled
     ahci: add the AHCI controller Linux Device ID for NVIDIA  chipsets.
has been added to the -mm tree.  Its filename is
     ahci-add-the-ahci-controller-linux-device-id-for-nvidia-chipsets.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

ahci-add-the-ahci-controller-linux-device-id-for-nvidia-chipsets.patch

