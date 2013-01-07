From: akpm@linux-foundation.org
Subject: [merged] maintainers-fix-plat-mxc-include-mach-imxfbh.patch removed from -mm tree
Date: Mon, 07 Jan 2013 11:26:22 -0800
Message-ID: <20130107192623.0A250200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:46537 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150Ab3AGT00 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 14:26:26 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt14so1261027wgb.5
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 11:26:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, s.hauer@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: fix .../plat-mxc/include/mach/imxfb.h
has been removed from the -mm tree.  Its filename was
     maintainers-fix-plat-mxc-include-mach-imxfbh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: MAINTAINERS: fix .../plat-mxc/include/mach/imxfb.h

This file was moved to include/linux/platform_data/video-imxfb.h by
commit 82906b1 ("ARM: imx: move platform_data definitions").

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-fix-plat-mxc-include-mach-imxfbh MAINTAINERS
--- a/MAINTAINERS~maintainers-fix-plat-mxc-include-mach-imxfbh
+++ a/MAINTAINERS
@@ -3207,7 +3207,7 @@ M:	Sascha Hauer <kernel@pengutronix.de>
 L:	linux-fbdev@vger.kernel.org
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
-F:	arch/arm/plat-mxc/include/mach/imxfb.h
+F:	include/linux/platform_data/video-imxfb.h
 F:	drivers/video/imxfb.c
 
 FREESCALE SOC FS_ENET DRIVER
_

Patches currently in -mm which might be from cesarb@cesarb.net are

origin.patch
linux-next.patch

