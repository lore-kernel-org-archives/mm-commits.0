From: akpm@linux-foundation.org
Subject: + rtc-mc13xxx-add-support-for-the-rtc-in-the-mc34708-pmic.patch added to -mm tree
Date: Thu, 12 Jul 2012 14:50:08 -0700
Message-ID: <20120712215009.3B005100062@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:41038 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171Ab2GLVuK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 17:50:10 -0400
Received: by ghbz15 with SMTP id z15so282162ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 14:50:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de, a.zummo@towertech.it


The patch titled
     Subject: rtc/mc13xxx: add support for the rtc in the mc34708 pmic
has been added to the -mm tree.  Its filename is
     rtc-mc13xxx-add-support-for-the-rtc-in-the-mc34708-pmic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: rtc/mc13xxx: add support for the rtc in the mc34708 p=
mic

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

origin.patch
linux-next.patch
rtc-mc13xxx-use-module_device_table-instead-of-module_alias.patch
rtc-mc13xxx-add-support-for-the-rtc-in-the-mc34708-pmic.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
