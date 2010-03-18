From: akpm@linux-foundation.org
Subject: + drivers-gpio-max730xc-add-license-macro.patch added to -mm tree
Date: Thu, 18 Mar 2010 16:00:05 -0700
Message-ID: <201003182300.o2IN050s020720@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51872 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753015Ab0CRXA0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Mar 2010 19:00:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard.rojfors@pelagicore.com, w.sang@pengutronix.de


The patch titled
     drivers/gpio/max730x.c: add license macro
has been added to the -mm tree.  Its filename is
     drivers-gpio-max730xc-add-license-macro.patch

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
Subject: drivers/gpio/max730x.c: add license macro
=46rom: Richard R=F6jfors <richard.rojfors@pelagicore.com>

According to the header in max730x it is licensed GPLv2.

Add a MODULE_LICENSE to avoid getting the kernel tainted.

Signed-off-by: Richard R=F6jfors <richard.rojfors@pelagicore.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/max730x.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/gpio/max730x.c~drivers-gpio-max730xc-add-license-macr=
o drivers/gpio/max730x.c
--- a/drivers/gpio/max730x.c~drivers-gpio-max730xc-add-license-macro
+++ a/drivers/gpio/max730x.c
@@ -242,3 +242,5 @@ int __devexit __max730x_remove(struct de
 	return ret;
 }
 EXPORT_SYMBOL_GPL(__max730x_remove);
+
+MODULE_LICENSE("GPL v2");
_

Patches currently in -mm which might be from richard.rojfors@pelagicore=
=2Ecom are

origin.patch
drivers-gpio-max730xc-add-license-macro.patch
linux-next.patch
serial-two-branches-the-same-in-timbuart_set_mctrl.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
