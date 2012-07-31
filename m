From: akpm@linux-foundation.org
Subject: [merged] rtc-mc13xxx-add-support-for-the-rtc-in-the-mc34708-pmic.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:52:41 -0700
Message-ID: <20120731185242.107275C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:37887 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756340Ab2GaSwn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:52:43 -0400
Received: by mail-ee0-f74.google.com with SMTP id d4so295599eek.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:52:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc/mc13xxx: add support for the rtc in the mc34708 pmic
has been removed from the -mm tree.  Its filename was
     rtc-mc13xxx-add-support-for-the-rtc-in-the-mc34708-pmic.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Subject: rtc/mc13xxx: add support for the rtc in the mc34708 pmic

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mc13xxx.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/rtc/rtc-mc13xxx.c~rtc-mc13xxx-add-support-for-the-rtc=
-in-the-mc34708-pmic drivers/rtc/rtc-mc13xxx.c
--- a/drivers/rtc/rtc-mc13xxx.c~rtc-mc13xxx-add-support-for-the-rtc-in-=
the-mc34708-pmic
+++ a/drivers/rtc/rtc-mc13xxx.c
@@ -404,6 +404,8 @@ static const struct platform_device_id m
 		.name =3D "mc13783-rtc",
 	}, {
 		.name =3D "mc13892-rtc",
+	}, {
+		.name =3D "mc34708-rtc",
 	},
 	{ /* sentinel */ }
 };
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

origin.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
