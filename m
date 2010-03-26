From: akpm@linux-foundation.org
Subject: [merged] drivers-gpio-max730xc-add-license-macro.patch removed from -mm tree
Date: Fri, 26 Mar 2010 12:36:09 -0400
Message-ID: <201003261937.o2QJb8ln016584@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60605 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752100Ab0CZThZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 15:37:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard.rojfors@pelagicore.com, w.sang@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     drivers/gpio/max730x.c: add license macro
has been removed from the -mm tree.  Its filename was
     drivers-gpio-max730xc-add-license-macro.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: drivers/gpio/max730x.c: add license macro
=46rom: Richard R=F6jfors <richard.rojfors@pelagicore.com>

According to the header in max730x it is licensed GPLv2.

Add a MODULE_LICENSE to avoid getting the kernel tainted.

[w.sang@pengutronix.de: add MODULE_AUTHOR and MODULE_DESCRIPTION also]
Signed-off-by: Richard R=F6jfors <richard.rojfors@pelagicore.com>
Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/max730x.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/gpio/max730x.c~drivers-gpio-max730xc-add-license-macr=
o drivers/gpio/max730x.c
--- a/drivers/gpio/max730x.c~drivers-gpio-max730xc-add-license-macro
+++ a/drivers/gpio/max730x.c
@@ -242,3 +242,7 @@ int __devexit __max730x_remove(struct de
 	return ret;
 }
 EXPORT_SYMBOL_GPL(__max730x_remove);
+
+MODULE_AUTHOR("Juergen Beisert, Wolfram Sang");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("MAX730x GPIO-Expanders, generic parts");
_

Patches currently in -mm which might be from richard.rojfors@pelagicore=
=2Ecom are

origin.patch
linux-next.patch
serial-two-branches-the-same-in-timbuart_set_mctrl.patch
serial-timbuart-make-sure-last-byte-is-sent-when-port-is-closed.patch
serial-timbuart-make-sure-last-byte-is-sent-when-port-is-closed-fix.pat=
ch
sdhci-implement-cap_clock_base_broken-quirk.patch
sdhci-pltfm-implement-platform-data-passing.patch
sdhci-pltfm-do-not-print-errors-in-case-of-an-extended-iomem-size.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
