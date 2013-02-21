From: akpm@linux-foundation.org
Subject: [folded-merged] backlight-add-an-as3711-pmic-backlight-driver-fix.patch removed from -mm tree
Date: Thu, 21 Feb 2013 15:24:53 -0800
Message-ID: <20130221232454.069CE31C016@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:34549 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693Ab3BUXYy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 18:24:54 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so11083yhz.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 15:24:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: g.liakhovetski@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: as3711: fix compilation breakage
has been removed from the -mm tree.  Its filename was
     backlight-add-an-as3711-pmic-backlight-driver-fix.patch

This patch was dropped because it was folded into backlight-add-an-as3711-pmic-backlight-driver.patch

------------------------------------------------------
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: backlight: as3711: fix compilation breakage

Include the missing platform_device.h header to fix errors like

error: implicit declaration of function 'platform_set_drvdata'

and similar.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/as3711_bl.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/backlight/as3711_bl.c~backlight-add-an-as3711-pmic-backlight-driver-fix drivers/video/backlight/as3711_bl.c
--- a/drivers/video/backlight/as3711_bl.c~backlight-add-an-as3711-pmic-backlight-driver-fix
+++ a/drivers/video/backlight/as3711_bl.c
@@ -17,6 +17,7 @@
 #include <linux/kernel.h>
 #include <linux/mfd/as3711.h>
 #include <linux/module.h>
+#include <linux/platform_device.h>
 #include <linux/regmap.h>
 #include <linux/slab.h>
 
_

Patches currently in -mm which might be from g.liakhovetski@gmx.de are

origin.patch
video-mx3fb-use-null-for-pointer.patch
backlight-add-an-as3711-pmic-backlight-driver.patch

