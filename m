From: akpm@linux-foundation.org
Subject: [to-be-updated] maintainers-add-maintainer-entry-for-exynos-dp-driver.patch removed from -mm tree
Date: Tue, 07 Feb 2012 12:45:45 -0800
Message-ID: <20120207204547.47D9CA0341@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:61342 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756533Ab2BGUpt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Feb 2012 15:45:49 -0500
Received: by ggnp1 with SMTP id p1so732976ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 07 Feb 2012 12:45:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, FlorianSchandinat@gmx.de, dh09.lee@samsung.com, inki.dae@samsung.com, kyungmin.park@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add maintainer entry for Exynos DP driver
has been removed from the -mm tree.  Its filename was
     maintainers-add-maintainer-entry-for-exynos-dp-driver.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: MAINTAINERS: add maintainer entry for Exynos DP driver

Add maintainer entry for Exynos DP driver which can be used for Samsung
Exynos SoC series.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Donghwa Lee <dh09.lee@samsung.com>
Cc: Inki Dae <inki.dae@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN MAINTAINERS~maintainers-add-maintainer-entry-for-exynos-dp-driver MAINTAINERS
--- a/MAINTAINERS~maintainers-add-maintainer-entry-for-exynos-dp-driver
+++ a/MAINTAINERS
@@ -2632,6 +2632,12 @@ M:	Mimi Zohar <zohar@us.ibm.com>
 S:	Supported
 F:	security/integrity/evm/
 
+EXYNOS DP DRIVER
+M:	Jingoo Han <jg1.han@samsung.com>
+L:	linux-fbdev@vger.kernel.org
+S:	Maintained
+F:	drivers/video/exynos/exynos_dp*
+
 F71805F HARDWARE MONITORING DRIVER
 M:	Jean Delvare <khali@linux-fr.org>
 L:	lm-sensors@lm-sensors.org
_

Patches currently in -mm which might be from jg1.han@samsung.com are

linux-next.patch
video-support-mipi-dsi-controller-driver.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-fix.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-checkpatch-fixes.patch
video-support-dp-controller-driver.patch
backlight-convert-backlight-spi-drivers-to-module_spi_driver.patch

