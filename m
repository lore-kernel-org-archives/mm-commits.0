From: akpm@linux-foundation.org
Subject: [folded] drivers-gpio-max730xc-add-license-macro-fix.patch removed from -mm tree
Date: Tue, 23 Mar 2010 13:30:00 -0700
Message-ID: <201003232030.o2NKU15e024164@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43527 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752933Ab0CWUaw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Mar 2010 16:30:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: w.sang@pengutronix.de, richard.rojfors@pelagicore.com, mm-commits@vger.kernel.org


The patch titled
     drivers-gpio-max730xc-add-license-macro-fix
has been removed from the -mm tree.  Its filename was
     drivers-gpio-max730xc-add-license-macro-fix.patch

This patch was dropped because it was folded into drivers-gpio-max730xc=
-add-license-macro.patch

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

get_maintainer-repair-stdin-usage.patch
drivers-gpio-max730xc-add-license-macro.patch
drivers-gpio-max730xc-add-license-macro-fix.patch
linux-next.patch
firmware-loader-use-statically-initialized-data-attribute.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
