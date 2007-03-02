From: akpm@linux-foundation.org
Subject: + support-for-marvell-7042-chip.patch added to -mm tree
Date: Thu, 01 Mar 2007 18:47:05 -0800
Message-ID: <200703020247.l222l5wc030421@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36463 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965347AbXCBCrK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 21:47:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tmorrison@empirix.com


The patch titled
     Support for Marvell 7042 Chip
has been added to the -mm tree.  Its filename is
     support-for-marvell-7042-chip.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Support for Marvell 7042 Chip
From: "Morrison, Tom" <tmorrison@empirix.com>

Added Support for Marvell 7042 Chip - 7042 has same capabilities & behavior
as 6042.

Signed-off-by: Thomas A. Morrison <tmorrison@empirix.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_mv.c |    3 +++
 1 files changed, 3 insertions(+)

diff -puN drivers/ata/sata_mv.c~support-for-marvell-7042-chip drivers/ata/sata_mv.c
--- a/drivers/ata/sata_mv.c~support-for-marvell-7042-chip
+++ a/drivers/ata/sata_mv.c
@@ -570,6 +570,9 @@ static const struct pci_device_id mv_pci
 
 	{ PCI_VDEVICE(TTI, 0x2310), chip_7042 },
 
+	/* add Marvell 7042 support */
+	{ PCI_VDEVICE(MARVELL, 0x7042), chip_7042 },
+
 	{ }			/* terminate list */
 };
 
_

Patches currently in -mm which might be from tmorrison@empirix.com are

support-for-marvell-7042-chip.patch
