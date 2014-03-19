From: akpm@linux-foundation.org
Subject: + maintainers-addition-of-dialog-semiconductor-files.patch added
 to -mm tree
Date: Wed, 19 Mar 2014 15:41:44 -0700
Message-ID: <532a1d28.mmkpjADzbfSzIYs/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49726 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261AbaCSWlp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Mar 2014 18:41:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, david.chen@diasemi.com, broonie@linaro.org, stwiss.opensource@diasemi.com

Subject: + maintainers-addition-of-dialog-semiconductor-files.patch added to -mm tree
To: stwiss.opensource@diasemi.com,broonie@linaro.org,david.chen@diasemi.com,joe@perches.com
From: akpm@linux-foundation.org
Date: Wed, 19 Mar 2014 15:41:44 -0700


The patch titled
     Subject: MAINTAINERS: addition of Dialog Semiconductor files
has been added to the -mm tree.  Its filename is
     maintainers-addition-of-dialog-semiconductor-files.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-addition-of-dialog-semiconductor-files.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-addition-of-dialog-semiconductor-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
Subject: MAINTAINERS: addition of Dialog Semiconductor files

Dialog Semiconductor Ltd would like to add a new section called DIALOG
SEMICONDUCTOR DRIVERS which contains a new e-mail address that can
cover all Dialog supported drivers: support.opensource@diasemi.com.

Signed-off-by: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
Signed-off-by: David Dajun Chen <david.chen@diasemi.com>
Cc: Mark Brown <broonie@linaro.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff -puN MAINTAINERS~maintainers-addition-of-dialog-semiconductor-files MAINTAINERS
--- a/MAINTAINERS~maintainers-addition-of-dialog-semiconductor-files
+++ a/MAINTAINERS
@@ -2709,6 +2709,31 @@ F:	include/linux/device-mapper.h
 F:	include/linux/dm-*.h
 F:	include/uapi/linux/dm-*.h
 
+DIALOG SEMICONDUCTOR DRIVERS
+M:	Support Opensource <support.opensource@diasemi.com>
+W:	http://www.dialog-semiconductor.com/products
+S:	Supported
+F:	Documentation/hwmon/da90??
+F:	drivers/gpio/gpio-da90??.c
+F:	drivers/hwmon/da90??-hwmon.c
+F:	drivers/input/misc/da90??_onkey.c
+F:	drivers/input/touchscreen/da9052_tsi.c
+F:	drivers/leds/leds-da90??.c
+F:	drivers/mfd/da903x.c
+F:	drivers/mfd/da90??-*.c
+F:	drivers/power/da9052-battery.c
+F:	drivers/regulator/da903x.c
+F:	drivers/regulator/da9???-regulator.[ch]
+F:	drivers/rtc/rtc-da90??.c
+F:	drivers/video/backlight/da90??_bl.c
+F:	drivers/watchdog/da90??_wdt.c
+F:	include/linux/mfd/da903x.h
+F:	include/linux/mfd/da9052/
+F:	include/linux/mfd/da9055/
+F:	include/linux/mfd/da9063/
+F:	include/sound/da[79]*.h
+F:	sound/soc/codecs/da[79]*.[ch]
+
 DIGI NEO AND CLASSIC PCI PRODUCTS
 M:	Lidza Louina <lidza.louina@gmail.com>
 L:	driverdev-devel@linuxdriverproject.org
_

Patches currently in -mm which might be from stwiss.opensource@diasemi.com are

maintainers-addition-of-dialog-semiconductor-files.patch
linux-next.patch

