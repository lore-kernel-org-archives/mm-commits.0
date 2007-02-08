From: akpm@linux-foundation.org
Subject: - scsi-sic7xxx-stray-bracket-fix.patch removed from -mm tree
Date: Thu, 08 Feb 2007 01:48:21 -0800
Message-ID: <200702080948.l189mL6h011032@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35751 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423200AbXBHJs0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 04:48:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, mm-commits@vger.kernel.org


The patch titled
     scsi: sic7xxx stray bracket fix
has been removed from the -mm tree.  Its filename was
     scsi-sic7xxx-stray-bracket-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: scsi: sic7xxx stray bracket fix
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Fix broken-but-unused macro.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aic7xxx/aic79xx_pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/aic7xxx/aic79xx_pci.c~scsi-sic7xxx-stray-bracket-fix drivers/scsi/aic7xxx/aic79xx_pci.c
--- a/drivers/scsi/aic7xxx/aic79xx_pci.c~scsi-sic7xxx-stray-bracket-fix
+++ a/drivers/scsi/aic7xxx/aic79xx_pci.c
@@ -88,7 +88,7 @@ ahd_compose_id(u_int device, u_int vendo
 
 #define SUBID_9005_LEGACYCONN_FUNC(id) ((id) & 0x20)
 
-#define SUBID_9005_SEEPTYPE(id) ((id) & 0x0C0) >> 6)
+#define SUBID_9005_SEEPTYPE(id) (((id) & 0x0C0) >> 6)
 #define		SUBID_9005_SEEPTYPE_NONE	0x0
 #define		SUBID_9005_SEEPTYPE_4K		0x1
 
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
git-alsa.patch
git-powerpc.patch
git-dvb.patch
git-scsi-misc.patch
