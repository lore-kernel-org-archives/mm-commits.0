From: akpm@linux-foundation.org
Subject: [to-be-updated] maintainers-add-entry-for-exynos-display-drivers.patch removed from -mm tree
Date: Mon, 06 Feb 2012 15:09:55 -0800
Message-ID: <20120206230955.EFDA6A01D6@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:50146 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029Ab2BFXJ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2012 18:09:56 -0500
Received: by yenm1 with SMTP id m1so39698yen.1
        for <mm-commits@vger.kernel.org>; Mon, 06 Feb 2012 15:09:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dh09.lee@samsung.com, FlorianSchandinat@gmx.de, inki.dae@samsung.com, kyungmin.park@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add entry for exynos display drivers
has been removed from the -mm tree.  Its filename was
     maintainers-add-entry-for-exynos-display-drivers.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Donghwa Lee <dh09.lee@samsung.com>
Subject: MAINTAINERS: add entry for exynos display drivers

Add Inki Dae, Donghwa Lee and Kyungmin Park as maintainers who developer
for the exynos display drivers in drivers/video/exynos/

Signed-off-by: Donghwa Lee <dh09.lee@samsung.com>
Cc: Inki Dae <inki.dae@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN MAINTAINERS~maintainers-add-entry-for-exynos-display-drivers MAINTAINERS
--- a/MAINTAINERS~maintainers-add-entry-for-exynos-display-drivers
+++ a/MAINTAINERS
@@ -2352,6 +2352,15 @@ S:	Supported
 F:	drivers/gpu/drm/exynos
 F:	include/drm/exynos*
 
+EXYNOS DISPLAY DRIVERS
+M:	Inki Dae <inki.dae@samsung.com>
+M:	Donghwa Lee <dh09.lee@samsung.com>
+M:	Kyungmin Park <kyungmin.park@samsung.com>
+L:	linux-fbdev@vger.kernel.org
+S:	Maintained
+F:	drivers/video/exynos/*
+F:	include/video/exynos*
+
 DSCC4 DRIVER
 M:	Francois Romieu <romieu@fr.zoreil.com>
 L:	netdev@vger.kernel.org
_

Patches currently in -mm which might be from dh09.lee@samsung.com are

video-support-mipi-dsi-controller-driver.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-fix.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-checkpatch-fixes.patch
backlight-convert-backlight-spi-drivers-to-module_spi_driver.patch

