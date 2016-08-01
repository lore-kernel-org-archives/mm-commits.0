From: akpm@linux-foundation.org
Subject: +
 maintainers-update-email-and-list-of-samsung-hw-driver-maintainers.patch
 added to -mm tree
Date: Mon, 01 Aug 2016 12:26:46 -0700
Message-ID: <579fa276.ndyyxnbbYwnKqB13%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37958 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032AbcHATvs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Aug 2016 15:51:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.debski@samsung.com, a.hajda@samsung.com, gregkh@linuxfoundation.org, jdelvare@suse.de, kamil@wypas.org, kishon@ti.com, l.majewski@samsung.com, linux@roeck-us.net, mchehab@kernel.org, s.nawrocki@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update email and list of Samsung HW driver maintainers
has been added to the -mm tree.  Its filename is
     maintainers-update-email-and-list-of-samsung-hw-driver-maintainers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-update-email-and-list-of-samsung-hw-driver-maintainers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-update-email-and-list-of-samsung-hw-driver-maintainers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kamil Debski <k.debski@samsung.com>
Subject: MAINTAINERS: update email and list of Samsung HW driver maintainers

Change my email address in the MAINTAINERS file.
Add new maintainers of selected Samsung HW drivers.

Link: http://lkml.kernel.org/r/1470060703-20423-1-git-send-email-k.debski@samsung.com
Signed-off-by: Kamil Debski <k.debski@samsung.com>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Andrzej Hajda <a.hajda@samsung.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Kamil Debski <kamil@wypas.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN MAINTAINERS~maintainers-update-email-and-list-of-samsung-hw-driver-maintainers MAINTAINERS
--- a/MAINTAINERS~maintainers-update-email-and-list-of-samsung-hw-driver-maintainers
+++ a/MAINTAINERS
@@ -1625,7 +1625,8 @@ F:	arch/arm/mach-s5pv210/
 
 ARM/SAMSUNG S5P SERIES 2D GRAPHICS ACCELERATION (G2D) SUPPORT
 M:	Kyungmin Park <kyungmin.park@samsung.com>
-M:	Kamil Debski <k.debski@samsung.com>
+M:	Kamil Debski <kamil@wypas.org>
+M:	Andrzej Hajda <a.hajda@samsung.com>
 L:	linux-arm-kernel@lists.infradead.org
 L:	linux-media@vger.kernel.org
 S:	Maintained
@@ -1633,8 +1634,9 @@ F:	drivers/media/platform/s5p-g2d/
 
 ARM/SAMSUNG S5P SERIES Multi Format Codec (MFC) SUPPORT
 M:	Kyungmin Park <kyungmin.park@samsung.com>
-M:	Kamil Debski <k.debski@samsung.com>
+M:	Kamil Debski <kamil@wypas.org>
 M:	Jeongtae Park <jtp.park@samsung.com>
+M:	Andrzej Hajda <a.hajda@samsung.com>
 L:	linux-arm-kernel@lists.infradead.org
 L:	linux-media@vger.kernel.org
 S:	Maintained
@@ -9383,7 +9385,8 @@ S:	Odd Fixes
 F:	drivers/media/usb/pwc/*
 
 PWM FAN DRIVER
-M:	Kamil Debski <k.debski@samsung.com>
+M:	Kamil Debski <kamil@wypas.org>
+M:	Lukasz Majewski <l.majewski@samsung.com>
 L:	linux-hwmon@vger.kernel.org
 S:	Supported
 F:	Documentation/devicetree/bindings/hwmon/pwm-fan.txt
@@ -10131,7 +10134,8 @@ T:	git https://github.com/lmajewski/linu
 F:	drivers/thermal/samsung/
 
 SAMSUNG USB2 PHY DRIVER
-M:	Kamil Debski <k.debski@samsung.com>
+M:	Kamil Debski <kamil@wypas.org>
+M:	Sylwester Nawrocki <s.nawrocki@samsung.com>
 L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	Documentation/devicetree/bindings/phy/samsung-phy.txt
_

Patches currently in -mm which might be from k.debski@samsung.com are

maintainers-update-email-and-list-of-samsung-hw-driver-maintainers.patch

