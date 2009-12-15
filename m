From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-file-patterns-for-wolfson-microelectronics-pmic-drivers.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:57:10 -0800
Message-ID: <200912152157.nBFLvAZr015697@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761312AbZLOWFg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:05:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, broonie@opensource.wolfsonmicro.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: Update file patterns for WOLFSON MICROELECTRONICS PMIC DRIVERS
has been removed from the -mm tree.  Its filename was
     maintainers-update-file-patterns-for-wolfson-microelectronics-pmic-drivers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: Update file patterns for WOLFSON MICROELECTRONICS PMIC DRIVERS
From: Joe Perches <joe@perches.com>

One of the includes pointed to a non-existent directory
Add Documentation/hwmon/wm83??
Add sound/soc/codecs/wm(8350|8400).h files

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN MAINTAINERS~maintainers-update-file-patterns-for-wolfson-microelectronics-pmic-drivers MAINTAINERS
--- a/MAINTAINERS~maintainers-update-file-patterns-for-wolfson-microelectronics-pmic-drivers
+++ a/MAINTAINERS
@@ -5975,6 +5975,7 @@ M:	Mark Brown <broonie@opensource.wolfso
 T:	git git://opensource.wolfsonmicro.com/linux-2.6-audioplus
 W:	http://opensource.wolfsonmicro.com/node/8
 S:	Supported
+F:	Documentation/hwmon/wm83??
 F:	drivers/leds/leds-wm83*.c
 F:	drivers/mfd/wm8*.c
 F:	drivers/power/wm83*.c
@@ -5984,9 +5985,9 @@ F:	drivers/video/backlight/wm83*_bl.c
 F:	drivers/watchdog/wm83*_wdt.c
 F:	include/linux/mfd/wm831x/
 F:	include/linux/mfd/wm8350/
-F:	include/linux/mfd/wm8400/
-F:	sound/soc/codecs/wm8350.c
-F:	sound/soc/codecs/wm8400.c
+F:	include/linux/mfd/wm8400*
+F:	sound/soc/codecs/wm8350.*
+F:	sound/soc/codecs/wm8400.*
 
 X.25 NETWORK LAYER
 M:	Henner Eisen <eis@baty.hanse.de>
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch
isicomc-use-pr_fmt-and-pr_level.patch
parport_pcc-use-correct-length-in-strncmp.patch

