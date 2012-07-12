From: akpm@linux-foundation.org
Subject: + maintainers-update-exynos-dp-driver-f-patterns.patch added to -mm tree
Date: Thu, 12 Jul 2012 14:48:57 -0700
Message-ID: <20120712214857.90CC510005D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:34747 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933045Ab2GLVs6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 17:48:58 -0400
Received: by yhl10 with SMTP id 10so284088yhl.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 14:48:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: MAINTAINERS: update EXYNOS DP DRIVER F: patterns
has been added to the -mm tree.  Its filename is
     maintainers-update-exynos-dp-driver-f-patterns.patch

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
Subject: MAINTAINERS: update EXYNOS DP DRIVER F: patterns

Add patterns for Exynos DP header to MAINTAINERS file.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-update-exynos-dp-driver-f-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-exynos-dp-driver-f-patterns
+++ a/MAINTAINERS
@@ -2724,6 +2724,7 @@ M:	Jingoo Han <jg1.han@samsung.com>
 L:	linux-fbdev@vger.kernel.org
 S:	Maintained
 F:	drivers/video/exynos/exynos_dp*
+F:	include/video/exynos_dp*
 
 EXYNOS MIPI DISPLAY DRIVERS
 M:	Inki Dae <inki.dae@samsung.com>
_
Subject: Subject: MAINTAINERS: update EXYNOS DP DRIVER F: patterns

Patches currently in -mm which might be from jg1.han@samsung.com are

linux-next.patch
maintainers-update-exynos-dp-driver-f-patterns.patch
drivers-video-backlight-atmel-pwm-blc-use-devm_-functions.patch
drivers-video-backlight-ot200_blc-use-devm_-functions.patch
drivers-video-backlight-lm3533_blc-use-devm_-functions.patch
backlight-atmel-pwm-bl-use-devm_gpio_request.patch
backlight-ot200_bl-use-devm_gpio_request.patch
backlight-tosa_lcd-use-devm_gpio_request.patch
backlight-tosa_bl-use-devm_gpio_request.patch
backlight-lms283gf05-use-devm_gpio_request.patch
backlight-corgi_lcd-use-devm_gpio_request.patch
backlight-l4f00242t03-use-devm_gpio_request_one.patch

