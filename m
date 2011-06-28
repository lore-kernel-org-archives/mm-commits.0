From: akpm@linux-foundation.org
Subject: [merged] drivers-ata-pata_marvellc-add-support-for-88se91a0-88se91a4.patch removed from -mm tree
Date: Tue, 28 Jun 2011 13:43:06 -0700
Message-ID: <201106282042.p5SKgmfX003046@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35516 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750774Ab1F1UnA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Jun 2011 16:43:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: czajernia@gmail.com, jeff@garzik.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     drivers/ata/pata_marvell.c: add support for 88SE91A0, 88SE91A4
has been removed from the -mm tree.  Its filename was
     drivers-ata-pata_marvellc-add-support-for-88se91a0-88se91a4.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/ata/pata_marvell.c: add support for 88SE91A0, 88SE91A4
From: Pawel Drewniak <czajernia@gmail.com>

Enable support for Marvell IDE PATA controllers found on the Asus P8P67LE
motherboard.

I received a report from two users of this motherboard that the patch works.

Signed-off-by: Pawel Drewniak <czajernia@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_marvell.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/ata/pata_marvell.c~drivers-ata-pata_marvellc-add-support-for-88se91a0-88se91a4 drivers/ata/pata_marvell.c
--- a/drivers/ata/pata_marvell.c~drivers-ata-pata_marvellc-add-support-for-88se91a0-88se91a4
+++ a/drivers/ata/pata_marvell.c
@@ -161,6 +161,8 @@ static const struct pci_device_id marvel
 	{ PCI_DEVICE(0x11AB, 0x6121), },
 	{ PCI_DEVICE(0x11AB, 0x6123), },
 	{ PCI_DEVICE(0x11AB, 0x6145), },
+	{ PCI_DEVICE(0x1B4B, 0x91A0), },
+	{ PCI_DEVICE(0x1B4B, 0x91A4), },
 	{ }	/* terminate list */
 };
 
_

Patches currently in -mm which might be from czajernia@gmail.com are


