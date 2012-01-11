From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-mc13xxxc-make-mc13xxx_rtc_idtable-static.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:32:32 -0800
Message-ID: <20120111213232.98D6D10004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:46081 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab2AKVce (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:32:34 -0500
Received: by qcsg15 with SMTP id g15so135929qcs.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:32:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, a.zummo@towertech.it, plagnioj@jcrosoft.com, u.kleine-koenig@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-mc13xxx.c: make mc13xxx_rtc_idtable stati=
c
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-mc13xxxc-make-mc13xxx_rtc_idtable-static.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
=46rom: Axel Lin <axel.lin@gmail.com>
Subject: drivers/rtc/rtc-mc13xxx.c: make mc13xxx_rtc_idtable static

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
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

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
