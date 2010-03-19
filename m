From: akpm@linux-foundation.org
Subject: + drivers-gpio-max730xc-add-license-macro-fix.patch added to -mm tree
Date: Thu, 18 Mar 2010 22:55:42 -0400
Message-ID: <201003190556.o2J5uOaB005212@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750865Ab0CSF5H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 01:57:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: w.sang@pengutronix.de, richard.rojfors@pelagicore.com


The patch titled
     drivers-gpio-max730xc-add-license-macro-fix
has been added to the -mm tree.  Its filename is
     drivers-gpio-max730xc-add-license-macro-fix.patch

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
Subject: drivers-gpio-max730xc-add-license-macro-fix
=46rom: Wolfram Sang <w.sang@pengutronix.de>

Cc: Richard R=F6jfors <richard.rojfors@pelagicore.com>
Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/max730x.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/gpio/max730x.c~drivers-gpio-max730xc-add-license-macr=
o-fix drivers/gpio/max730x.c
--- a/drivers/gpio/max730x.c~drivers-gpio-max730xc-add-license-macro-fi=
x
+++ a/drivers/gpio/max730x.c
@@ -243,4 +243,6 @@ int __devexit __max730x_remove(struct de
 }
 EXPORT_SYMBOL_GPL(__max730x_remove);
=20
+MODULE_AUTHOR("Juergen Beisert, Wolfram Sang");
 MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("MAX730x GPIO-Expanders, generic parts");
_

Patches currently in -mm which might be from w.sang@pengutronix.de are

origin.patch
get_maintainer-repair-stdin-usage.patch
drivers-gpio-max730xc-add-license-macro.patch
drivers-gpio-max730xc-add-license-macro-fix.patch
linux-next.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
