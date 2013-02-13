From: akpm@linux-foundation.org
Subject: + maintainers-remove-mark-m-hoffman.patch added to -mm tree
Date: Tue, 12 Feb 2013 16:46:15 -0800
Message-ID: <20130213004616.4D0B731C102@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:55814 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab3BMAqR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Feb 2013 19:46:17 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so79813vcd.1
        for <mm-commits@vger.kernel.org>; Tue, 12 Feb 2013 16:46:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, linux@roeck-us.net, mhoffman@lightlink.com, w.sang@pengutronix.de


The patch titled
     Subject: MAINTAINERS: Remove Mark M. Hoffman
has been added to the -mm tree.  Its filename is
     maintainers-remove-mark-m-hoffman.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1335,12 +1335,6 @@ S:	Maintained
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
@@ -3852,7 +3846,7 @@ F:	drivers/i2c/busses/i2c-ismt.c
 F:	Documentation/i2c/busses/i2c-ismt
 
 I2C/SMBUS STUB DRIVER
-M:	"Mark M. Hoffman" <mhoffman@lightlink.com>
+M:	Jean Delvare <khali@linux-fr.org>
 L:	linux-i2c@vger.kernel.org
 S:	Maintained
 F:	drivers/i2c/i2c-stub.c
@@ -7194,13 +7188,6 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/sis/sis900.*
 
-SIS 96X I2C/SMBUS DRIVER
-M:	"Mark M. Hoffman" <mhoffman@lightlink.com>
-L:	linux-i2c@vger.kernel.org
-S:	Maintained
-F:	Documentation/i2c/busses/i2c-sis96x
-F:	drivers/i2c/busses/i2c-sis96x.c
