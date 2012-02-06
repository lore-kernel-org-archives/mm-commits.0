From: akpm@linux-foundation.org
Subject: + maintainers-add-maintainer-entry-for-exynos-dp-driver.patch added to -mm tree
Date: Mon, 06 Feb 2012 15:10:51 -0800
Message-ID: <20120206231051.78486A01D6@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:53562 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064Ab2BFXKx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2012 18:10:53 -0500
Received: by faaa19 with SMTP id a19so212910faa.1
        for <mm-commits@vger.kernel.org>; Mon, 06 Feb 2012 15:10:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, FlorianSchandinat@gmx.de, dh09.lee@samsung.com, inki.dae@samsung.com, kyungmin.park@samsung.com, rpurdie@rpsys.net


The patch titled
     Subject: MAINTAINERS: add maintainer entry for Exynos DP driver
has been added to the -mm tree.  Its filename is
     maintainers-add-maintainer-entry-for-exynos-dp-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: MAINTAINERS: add maintainer entry for Exynos DP driver

Patches currently in -mm which might be from jg1.han@samsung.com are

maintainers-add-maintainer-entry-for-exynos-dp-driver.patch
linux-next.patch
video-support-mipi-dsi-controller-driver.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-fix.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-checkpatch-fixes.patch
video-support-dp-controller-driver.patch
backlight-convert-backlight-spi-drivers-to-module_spi_driver.patch

