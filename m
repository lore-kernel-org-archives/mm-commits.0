From: akpm@linux-foundation.org
Subject: [folded-dropped] backlight-add-new-lm3639-backlight-driver-fix-2.patch removed from -mm tree
Date: Thu, 04 Oct 2012 16:55:57 -0700
Message-ID: <20121004235557.E46F2100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:51980 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab2JDXz7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2012 19:55:59 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so129440qcq.1
        for <mm-commits@vger.kernel.org>; Thu, 04 Oct 2012 16:55:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gshark.jeong@gmail.com, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight-add-new-lm3639-backlight-driver-fix-2
has been removed from the -mm tree.  Its filename was
     backlight-add-new-lm3639-backlight-driver-fix-2.patch

This patch was dropped because it was folded into backlight-add-new-lm3639-backlight-driver.patch

------------------------------------------------------
From: "G.Shark Jeong" <gshark.jeong@gmail.com>
Subject: backlight-add-new-lm3639-backlight-driver-fix-2

Put NEW_LEDS and LEDS_CLASS into Kconfig file to reduce additional
configuration works in LEDs.

Signed-off-by: G.Shark Jeong <gshark.jeong@gmail.com>
Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/video/backlight/Kconfig~backlight-add-new-lm3639-backlight-driver-fix-2 drivers/video/backlight/Kconfig
--- a/drivers/video/backlight/Kconfig~backlight-add-new-lm3639-backlight-driver-fix-2
+++ a/drivers/video/backlight/Kconfig
@@ -363,6 +363,8 @@ config BACKLIGHT_LM3639
 	tristate "Backlight Driver for LM3639"
 	depends on BACKLIGHT_CLASS_DEVICE && I2C
 	select REGMAP_I2C
+	select NEW_LEDS
+	select LEDS_CLASS
 	help
 	  This supports TI LM3639 Backlight + 1.5A Flash LED Driver
 
_

Patches currently in -mm which might be from gshark.jeong@gmail.com are

backlight-add-backlight-driver-for-lm3630-chip.patch
backlight-add-new-lm3639-backlight-driver.patch

