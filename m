From: akpm@linux-foundation.org
Subject: - radeonfb-add-pci-id-for-rs482-radeon-xpress-200m.patch removed from -mm tree
Date: Thu, 13 Sep 2007 04:08:42 -0700
Message-ID: <200709131108.l8DB8gIo015640@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45262 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750826AbXIMLJF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2007 07:09:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aherrman@arcor.de, adaplas@pol.net, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     radeonfb: add PCI Id for RS482/Radeon Xpress 200M
has been removed from the -mm tree.  Its filename was
     radeonfb-add-pci-id-for-rs482-radeon-xpress-200m.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
Subject: radeonfb: add PCI Id for RS482/Radeon Xpress 200M
From: Andreas Herrmann <aherrman@arcor.de>

.. which can be found in Acer Aspire 5100.

Signed-off-by: Andreas Herrmann <aherrman@arcor.de>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/ati_ids.h     |    1 +
 drivers/video/aty/radeon_base.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN drivers/video/aty/ati_ids.h~radeonfb-add-pci-id-for-rs482-radeon-xpress-200m drivers/video/aty/ati_ids.h
--- a/drivers/video/aty/ati_ids.h~radeonfb-add-pci-id-for-rs482-radeon-xpress-200m
+++ a/drivers/video/aty/ati_ids.h
@@ -211,3 +211,4 @@
 #define PCI_CHIP_RS350_7834             0x7834
 #define PCI_CHIP_RS350_7835             0x7835
 #define PCI_CHIP_RS480_5955             0x5955
+#define PCI_CHIP_RS482_5975             0x5975
diff -puN drivers/video/aty/radeon_base.c~radeonfb-add-pci-id-for-rs482-radeon-xpress-200m drivers/video/aty/radeon_base.c
--- a/drivers/video/aty/radeon_base.c~radeonfb-add-pci-id-for-rs482-radeon-xpress-200m
+++ a/drivers/video/aty/radeon_base.c
@@ -102,6 +102,7 @@
 static struct pci_device_id radeonfb_pci_table[] = {
         /* Radeon Xpress 200m */
 	CHIP_DEF(PCI_CHIP_RS480_5955,   RS480,  CHIP_HAS_CRTC2 | CHIP_IS_IGP | CHIP_IS_MOBILITY),
+	CHIP_DEF(PCI_CHIP_RS482_5975,   RS480,  CHIP_HAS_CRTC2 | CHIP_IS_IGP | CHIP_IS_MOBILITY),
 	/* Mobility M6 */
 	CHIP_DEF(PCI_CHIP_RADEON_LY, 	RV100,	CHIP_HAS_CRTC2 | CHIP_IS_MOBILITY),
 	CHIP_DEF(PCI_CHIP_RADEON_LZ,	RV100,	CHIP_HAS_CRTC2 | CHIP_IS_MOBILITY),
_

Patches currently in -mm which might be from aherrman@arcor.de are

radeonfb-add-pci-id-for-rs482-radeon-xpress-200m.patch
radeonfb-fix-setting-of-ppll_ref_div-for-rv370-5b60.patch
radeonfb-use-pci-device-id-in-hex-for-name-string.patch
radeonfb-add-new-module-parameter-to-force-pll-calculation.patch
radeonfb-add-new-module-parameter-to-force-pll-calculation-fix.patch
