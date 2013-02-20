From: akpm@linux-foundation.org
Subject: [to-be-updated] maintainers-remove-mark-m-hoffman.patch removed from -mm tree
Date: Wed, 20 Feb 2013 13:11:18 -0800
Message-ID: <20130220211118.8D7425A430A@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:62494 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964950Ab3BTVLV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Feb 2013 16:11:21 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so555788ghb.5
        for <mm-commits@vger.kernel.org>; Wed, 20 Feb 2013 13:11:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, linux@roeck-us.net, mhoffman@lightlink.com, w.sang@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: Remove Mark M. Hoffman
has been removed from the -mm tree.  Its filename was
     maintainers-remove-mark-m-hoffman.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Jean Delvare <khali@linux-fr.org>
Subject: MAINTAINERS: Remove Mark M. Hoffman

Mark M.  Hoffman stopped working on the Linux kernel several years ago, so
he should no longer be listed as a driver maintainer.  I'm not even sure
if his e-mail address still works.

I can take over 3 drivers he was responsible for, the 4th one will
fall down to the subsystem maintainer.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-mark-m-hoffman MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-mark-m-hoffman
+++ a/MAINTAINERS
@@ -1344,12 +1344,6 @@ S:	Maintained
 F:	drivers/platform/x86/asus*.c
 F:	drivers/platform/x86/eeepc*.c
 
-ASUS ASB100 HARDWARE MONITOR DRIVER
-M:	"Mark M. Hoffman" <mhoffman@lightlink.com>
-L:	lm-sensors@lm-sensors.org
-S:	Maintained
-F:	drivers/hwmon/asb100.c
-
 ASYNCHRONOUS TRANSFERS/TRANSFORMS (IOAT) API
 M:	Dan Williams <djbw@fb.com>
 W:	http://sourceforge.net/projects/xscaleiop
@@ -3861,7 +3855,7 @@ F:	drivers/i2c/busses/i2c-ismt.c
 F:	Documentation/i2c/busses/i2c-ismt
 
 I2C/SMBUS STUB DRIVER
-M:	"Mark M. Hoffman" <mhoffman@lightlink.com>
+M:	Jean Delvare <khali@linux-fr.org>
 L:	linux-i2c@vger.kernel.org
 S:	Maintained
 F:	drivers/i2c/i2c-stub.c
@@ -7193,13 +7187,6 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/sis/sis900.*
 
-SIS 96X I2C/SMBUS DRIVER
-M:	"Mark M. Hoffman" <mhoffman@lightlink.com>
-L:	linux-i2c@vger.kernel.org
-S:	Maintained
-F:	Documentation/i2c/busses/i2c-sis96x
-F:	drivers/i2c/busses/i2c-sis96x.c
