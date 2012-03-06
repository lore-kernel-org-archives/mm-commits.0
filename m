From: akpm@linux-foundation.org
Subject: + maintainers-add-entry-for-exynos-mipi-display-drivers.patch added to -mm tree
Date: Tue, 06 Mar 2012 14:15:57 -0800
Message-ID: <20120306221557.AE027A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:44150 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030811Ab2CFWQA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Mar 2012 17:16:00 -0500
Received: by eaaq10 with SMTP id q10so209947eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Mar 2012 14:15:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dh09.lee@samsung.com, FlorianSchandinat@gmx.de, inki.dae@samsung.com, jg1.han@samsung.com, kgene.kim@samsung.com, kyungmin.park@samsung.com, rpurdie@rpsys.net


The patch titled
     Subject: MAINTAINERS: add entry for exynos mipi display drivers
has been added to the -mm tree.  Its filename is
     maintainers-add-entry-for-exynos-mipi-display-drivers.patch

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
@@ -2362,6 +2362,15 @@ S:	Supported
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
Subject: Subject: MAINTAINERS: add entry for exynos mipi display drivers

Patches currently in -mm which might be from dh09.lee@samsung.com are

linux-next.patch
backlight-convert-backlight-spi-drivers-to-module_spi_driver.patch
maintainers-add-entry-for-exynos-mipi-display-drivers.patch

