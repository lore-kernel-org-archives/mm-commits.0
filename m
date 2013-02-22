From: akpm@linux-foundation.org
Subject: [merged] drivers-video-kconfig-specify-the-socs-that-make-use-of-fb_imx.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:38:19 -0800
Message-ID: <20130222203820.066C25A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:51076 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756966Ab3BVUiV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:38:21 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so118748qaj.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:38:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabio.estevam@freescale.com, FlorianSchandinat@gmx.de, s.hauer@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/Kconfig: specify the SoCs that make use of FB_IMX
has been removed from the -mm tree.  Its filename was
     drivers-video-kconfig-specify-the-socs-that-make-use-of-fb_imx.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabio Estevam <fabio.estevam@freescale.com>
Subject: drivers/video/Kconfig: specify the SoCs that make use of FB_IMX

FB_IMX is the framebuffer driver used by MX1, MX21, MX25 and MX27 processors.

Pass this information to the Kconfig text to make it clear.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/Kconfig~drivers-video-kconfig-specify-the-socs-that-make-use-of-fb_imx drivers/video/Kconfig
--- a/drivers/video/Kconfig~drivers-video-kconfig-specify-the-socs-that-make-use-of-fb_imx
+++ a/drivers/video/Kconfig
@@ -364,7 +364,7 @@ config FB_SA1100
 	  Y here.
 
 config FB_IMX
-	tristate "Freescale i.MX LCD support"
+	tristate "Freescale i.MX1/21/25/27 LCD support"
 	depends on FB && IMX_HAVE_PLATFORM_IMX_FB
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
_

Patches currently in -mm which might be from fabio.estevam@freescale.com are

origin.patch
linux-next.patch

