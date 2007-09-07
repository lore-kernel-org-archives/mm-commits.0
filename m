From: akpm@linux-foundation.org
Subject: - hptiop-use-pci-vendor-symbol.patch removed from -mm tree
Date: Thu, 06 Sep 2007 17:11:36 -0700
Message-ID: <200709070011.l870BaOj015029@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46629 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932693AbXIGAMA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Sep 2007 20:12:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, James.Bottomley@SteelEye.com, linux@highpoint-tech.com, mm-commits@vger.kernel.org


The patch titled
     hptiop: Use PCI vendor symbol
has been removed from the -mm tree.  Its filename was
     hptiop-use-pci-vendor-symbol.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: hptiop: Use PCI vendor symbol
From: Jean Delvare <khali@linux-fr.org>

Use the PCI vendor symbol instead of a numeric value in the
scsi/hptiop driver.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: HighPoint Linux Team <linux@highpoint-tech.com>
Cc: "James E.J. Bottomley" <James.Bottomley@SteelEye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hptiop.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/hptiop.c~hptiop-use-pci-vendor-symbol drivers/scsi/hptiop.c
--- a/drivers/scsi/hptiop.c~hptiop-use-pci-vendor-symbol
+++ a/drivers/scsi/hptiop.c
@@ -879,8 +879,8 @@ static void hptiop_remove(struct pci_dev
 }
 
 static struct pci_device_id hptiop_id_table[] = {
-	{ PCI_DEVICE(0x1103, 0x3220) },
-	{ PCI_DEVICE(0x1103, 0x3320) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_TTI, 0x3220) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_TTI, 0x3320) },
 	{},
 };
 
_

Patches currently in -mm which might be from khali@linux-fr.org are

git-dvb.patch
git-hwmon.patch
hdaps-switch-to-using-input-polldev.patch
applesmc-switch-to-using-input-polldev.patch
ams-switch-to-using-input-polldev.patch
hptiop-use-pci-vendor-symbol.patch
i2c-pxa-rename-bit-macro-to-pxa_bit.patch
