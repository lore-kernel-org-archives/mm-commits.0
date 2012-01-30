From: akpm@linux-foundation.org
Subject: + maintainers-add-entry-for-exynos-display-drivers.patch added to -mm tree
Date: Mon, 30 Jan 2012 15:32:22 -0800
Message-ID: <20120130233222.A77A0A03DB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:36758 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab2A3XcX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jan 2012 18:32:23 -0500
Received: by yenr8 with SMTP id r8so456866yen.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Jan 2012 15:32:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dh09.lee@samsung.com, FlorianSchandinat@gmx.de, inki.dae@samsung.com, kyungmin.park@samsung.com, rpurdie@rpsys.net


The patch titled
     Subject: MAINTAINERS: add entry for exynos display drivers
has been added to the -mm tree.  Its filename is
     maintainers-add-entry-for-exynos-display-drivers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: MAINTAINERS: add entry for exynos display drivers

Patches currently in -mm which might be from dh09.lee@samsung.com are

maintainers-add-entry-for-exynos-display-drivers.patch
backlight-convert-backlight-spi-drivers-to-module_spi_driver.patch
video-support-mipi-dsi-controller-driver.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-fix.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-checkpatch-fixes.patch

