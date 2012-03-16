From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-entry-for-exynos-mipi-display-drivers.patch removed from -mm tree
Date: Fri, 16 Mar 2012 13:58:05 -0700
Message-ID: <20120316205805.5BC7CA0128@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:35079 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031888Ab2CPU6G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Mar 2012 16:58:06 -0400
Received: by ghbz15 with SMTP id z15so742796ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Mar 2012 13:58:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dh09.lee@samsung.com, FlorianSchandinat@gmx.de, inki.dae@samsung.com, jg1.han@samsung.com, kgene.kim@samsung.com, kyungmin.park@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add entry for exynos mipi display drivers
has been removed from the -mm tree.  Its filename was
     maintainers-add-entry-for-exynos-mipi-display-drivers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Donghwa Lee <dh09.lee@samsung.com>
Subject: MAINTAINERS: add entry for exynos mipi display drivers

Hi, I'd like to add Inki Dae, Donghwa Lee and Kyungmin Park as maintainers
who developers for exynos mipi display drivers for
video/driver/exynos/exynos_mipi* and include/video/exynos_mipi*.

Signed-off-by: Donghwa Lee <dh09.lee@samsung.com>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN MAINTAINERS~maintainers-add-entry-for-exynos-mipi-display-drivers MAINTAINERS
--- a/MAINTAINERS~maintainers-add-entry-for-exynos-mipi-display-drivers
+++ a/MAINTAINERS
@@ -2355,6 +2355,15 @@ S:	Supported
 F:	drivers/gpu/drm/exynos
 F:	include/drm/exynos*
 
+EXYNOS MIPI DISPLAY DRIVERS
+M:	Inki Dae <inki.dae@samsung.com>
+M:	Donghwa Lee <dh09.lee@samsung.com>
+M:	Kyungmin Park <kyungmin.park@samsung.com>
+L:	linux-fbdev@vger.kernel.org
+S:	Maintained
+F:	drivers/video/exynos/exynos_mipi*
+F:	include/video/exynos_mipi*
+
 DSCC4 DRIVER
 M:	Francois Romieu <romieu@fr.zoreil.com>
 L:	netdev@vger.kernel.org
_

Patches currently in -mm which might be from dh09.lee@samsung.com are

origin.patch
linux-next.patch
backlight-convert-backlight-spi-drivers-to-module_spi_driver.patch

