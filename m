From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-mc13xxxc-make-mc13xxx_rtc_idtable-static.patch added to -mm tree
Date: Fri, 16 Dec 2011 16:22:25 -0800
Message-ID: <20111217002226.147965C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:55676 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab1LQAW2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2011 19:22:28 -0500
Received: by eaad1 with SMTP id d1so104697eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2011 16:22:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, a.zummo@towertech.it, u.kleine-koenig@pengutronix.de


The patch titled
     Subject: drivers/rtc/rtc-mc13xxx.c: make mc13xxx_rtc_idtable stati=
c
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-mc13xxxc-make-mc13xxx_rtc_idtable-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
=46rom: Axel Lin <axel.lin@gmail.com>
Subject: drivers/rtc/rtc-mc13xxx.c: make mc13xxx_rtc_idtable static

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mc13xxx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-mc13xxx.c~drivers-rtc-rtc-mc13xxxc-make-mc13x=
xx_rtc_idtable-static drivers/rtc/rtc-mc13xxx.c
--- a/drivers/rtc/rtc-mc13xxx.c~drivers-rtc-rtc-mc13xxxc-make-mc13xxx_r=
tc_idtable-static
+++ a/drivers/rtc/rtc-mc13xxx.c
@@ -399,7 +399,7 @@ static int __exit mc13xxx_rtc_remove(str
 	return 0;
 }
=20
-const struct platform_device_id mc13xxx_rtc_idtable[] =3D {
+static const struct platform_device_id mc13xxx_rtc_idtable[] =3D {
 	{
 		.name =3D "mc13783-rtc",
 	}, {
_
Subject: Subject: drivers/rtc/rtc-mc13xxx.c: make mc13xxx_rtc_idtable s=
tatic

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch
backlight-convert-drivers-video-backlight-to-use-module_platform_driver=
=2Epatch
leds-convert-led-platform-drivers-to-module_platform_driver.patch
leds-convert-led-i2c-drivers-to-module_i2c_driver.patch
leds-convert-leds-dac124s085-to-module_spi_driver.patch
drivers-leds-leds-lp5523c-remove-unneeded-forward-declaration.patch
leds-bd2802-use-gpio_request_one.patch
leds-netxbig-use-gpio_request_one.patch
drivers-leds-leds-mc13783c-fix-off-by-one-for-checking-num_leds.patch
rtc-convert-drivers-rtc-to-use-module_platform_driver.patch
drivers-rtc-rtc-mc13xxxc-make-mc13xxx_rtc_idtable-static.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
