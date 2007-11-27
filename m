From: akpm@linux-foundation.org
Subject: - radeonfb-add-chip-definition-for-rv370-5b63.patch removed from -mm tree
Date: Tue, 27 Nov 2007 12:33:10 -0800
Message-ID: <200711272033.lARKXA04028961@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50002 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755637AbXK0Udm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 15:33:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aherrman@arcor.de, adaplas@pol.net, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     radeonfb: add chip definition for RV370 5b63
has been removed from the -mm tree.  Its filename was
     radeonfb-add-chip-definition-for-rv370-5b63.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: radeonfb: add chip definition for RV370 5b63
From: Andreas Herrmann <aherrman@arcor.de>

Enable radeonfb for another Radeon card which I've found on a Sapphire X550
(Silent).  It was acked by Benjamin, see
http://marc.info/?l=linux-fbdev-devel&m=119516950701198&w=2

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andreas Herrmann <aherrman@arcor.de>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/radeon_base.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/aty/radeon_base.c~radeonfb-add-chip-definition-for-rv370-5b63 drivers/video/aty/radeon_base.c
--- a/drivers/video/aty/radeon_base.c~radeonfb-add-chip-definition-for-rv370-5b63
+++ a/drivers/video/aty/radeon_base.c
@@ -202,6 +202,7 @@ static struct pci_device_id radeonfb_pci
 	CHIP_DEF(PCI_CHIP_RV380_3154,	RV380,	CHIP_HAS_CRTC2 | CHIP_IS_MOBILITY),
 	CHIP_DEF(PCI_CHIP_RV370_5B60,	RV380,	CHIP_HAS_CRTC2),
 	CHIP_DEF(PCI_CHIP_RV370_5B62,	RV380,	CHIP_HAS_CRTC2),
+	CHIP_DEF(PCI_CHIP_RV370_5B63,	RV380,	CHIP_HAS_CRTC2),
 	CHIP_DEF(PCI_CHIP_RV370_5B64,	RV380,	CHIP_HAS_CRTC2),
 	CHIP_DEF(PCI_CHIP_RV370_5B65,	RV380,	CHIP_HAS_CRTC2),
 	CHIP_DEF(PCI_CHIP_RV370_5460,	RV380,	CHIP_HAS_CRTC2 | CHIP_IS_MOBILITY),
_

Patches currently in -mm which might be from aherrman@arcor.de are

origin.patch
