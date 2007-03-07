From: akpm@linux-foundation.org
Subject: - support-for-marvell-7042-chip.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:22:38 -0800
Message-ID: <200703070422.l274Mcn1019006@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47153 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572AbXCGEWp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:22:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tmorrison@empirix.com, mm-commits@vger.kernel.org


The patch titled
     Support for Marvell 7042 Chip
has been removed from the -mm tree.  Its filename was
     support-for-marvell-7042-chip.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Support for Marvell 7042 Chip
From: "Morrison, Tom" <tmorrison@empirix.com>

Added Support for Marvell 7042 Chip - 7042 has same capabilities & behavior
as 6042.

Signed-off-by: Thomas A. Morrison <tmorrison@empirix.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_mv.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/ata/sata_mv.c~support-for-marvell-7042-chip drivers/ata/sata_mv.c
--- a/drivers/ata/sata_mv.c~support-for-marvell-7042-chip
+++ a/drivers/ata/sata_mv.c
@@ -548,6 +548,9 @@ static const struct pci_device_id mv_pci
 
 	{ PCI_VDEVICE(TTI, 0x2310), chip_7042 },
 
+	/* add Marvell 7042 support */
+	{ PCI_VDEVICE(MARVELL, 0x7042), chip_7042 },
+
 	{ }			/* terminate list */
 };
 
_

Patches currently in -mm which might be from tmorrison@empirix.com are

git-libata-all.patch
