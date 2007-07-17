From: akpm@linux-foundation.org
Subject: - radeonfb-add-support-for-radeon-xpress-200m-rs485.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:06:55 -0700
Message-ID: <200707172306.l6HN6tr2012062@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33540 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765483AbXGQXPh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: WolfSt.External@qimonda.com, adaplas@gmail.com, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     radeonfb: Add support for Radeon Xpress 200M (RS485)
has been removed from the -mm tree.  Its filename was
     radeonfb-add-support-for-radeon-xpress-200m-rs485.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: radeonfb: Add support for Radeon Xpress 200M (RS485)
From: Stephan Wolf <WolfSt.External@qimonda.com>

Add PCI ids for the Radeon Xpress 200M (RS485).

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/ati_ids.h     |    1 +
 drivers/video/aty/radeon_base.c |    2 ++
 2 files changed, 3 insertions(+)

diff -puN drivers/video/aty/ati_ids.h~radeonfb-add-support-for-radeon-xpress-200m-rs485 drivers/video/aty/ati_ids.h
--- a/drivers/video/aty/ati_ids.h~radeonfb-add-support-for-radeon-xpress-200m-rs485
+++ a/drivers/video/aty/ati_ids.h
@@ -204,6 +204,7 @@
 #define PCI_CHIP_RV280_5961		0x5961
 #define PCI_CHIP_RV280_5962		0x5962
 #define PCI_CHIP_RV280_5964		0x5964
+#define PCI_CHIP_RS485_5975		0x5975
 #define PCI_CHIP_RV280_5C61		0x5C61
 #define PCI_CHIP_RV280_5C63		0x5C63
 #define PCI_CHIP_R423_5D57              0x5D57
diff -puN drivers/video/aty/radeon_base.c~radeonfb-add-support-for-radeon-xpress-200m-rs485 drivers/video/aty/radeon_base.c
--- a/drivers/video/aty/radeon_base.c~radeonfb-add-support-for-radeon-xpress-200m-rs485
+++ a/drivers/video/aty/radeon_base.c
@@ -153,6 +153,8 @@ static struct pci_device_id radeonfb_pci
 	/* Mobility 9200 (M9+) */
 	CHIP_DEF(PCI_CHIP_RV280_5C61,	RV280,	CHIP_HAS_CRTC2 | CHIP_IS_MOBILITY),
 	CHIP_DEF(PCI_CHIP_RV280_5C63,	RV280,	CHIP_HAS_CRTC2 | CHIP_IS_MOBILITY),
+	/*Mobility Xpress 200 */
+	CHIP_DEF(PCI_CHIP_RS485_5975,	R300,	CHIP_HAS_CRTC2 | CHIP_IS_IGP | CHIP_IS_MOBILITY),
 	/* 9200 */
 	CHIP_DEF(PCI_CHIP_RV280_5960,	RV280,	CHIP_HAS_CRTC2),
 	CHIP_DEF(PCI_CHIP_RV280_5961,	RV280,	CHIP_HAS_CRTC2),
_

Patches currently in -mm which might be from WolfSt.External@qimonda.com are

origin.patch
