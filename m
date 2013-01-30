From: akpm@linux-foundation.org
Subject: + drivers-video-kconfig-specify-the-socs-that-make-use-of-fb_imx.patch added to -mm tree
Date: Tue, 29 Jan 2013 16:37:58 -0800
Message-ID: <20130130003758.93EF731C173@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:59044 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab3A3Ah7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Jan 2013 19:37:59 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so104360qcq.3
        for <mm-commits@vger.kernel.org>; Tue, 29 Jan 2013 16:37:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fabio.estevam@freescale.com, FlorianSchandinat@gmx.de, s.hauer@pengutronix.de


The patch titled
     Subject: drivers/video/Kconfig: specify the SoCs that make use of FB_IMX
has been added to the -mm tree.  Its filename is
     drivers-video-kconfig-specify-the-socs-that-make-use-of-fb_imx.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
drivers-video-kconfig-specify-the-socs-that-make-use-of-fb_imx.patch

