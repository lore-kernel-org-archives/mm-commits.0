From: akpm@linux-foundation.org
Subject: [merged] sysfs-deprecated-features-are-to-help-old-tools-not-to-confuse-them.patch removed from -mm tree
Date: Wed, 09 Dec 2009 11:50:01 -0800
Message-ID: <200912091950.nB9Jo1pv029213@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57491 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757392AbZLITuk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Dec 2009 14:50:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, gregkh@suse.de, kay.sievers@vrfy.org, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     sysfs: deprecated features are to help old tools not to confuse th=
em
has been removed from the -mm tree.  Its filename was
     sysfs-deprecated-features-are-to-help-old-tools-not-to-confuse-the=
m.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: sysfs: deprecated features are to help old tools not to confus=
e them
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: Greg KH <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/Kconfig~sysfs-deprecated-features-are-to-help-old-tools-=
not-to-confuse-them init/Kconfig
--- a/init/Kconfig~sysfs-deprecated-features-are-to-help-old-tools-not-=
to-confuse-them
+++ a/init/Kconfig
@@ -619,7 +619,7 @@ config SYSFS_DEPRECATED
 	bool
=20
 config SYSFS_DEPRECATED_V2
-	bool "enable deprecated sysfs features which may confuse old userspac=
e tools"
+	bool "enable deprecated sysfs features to support old userspace tools=
"
 	depends on SYSFS
 	default n
 	select SYSFS_DEPRECATED
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

origin.patch
linux-next.patch
hrtimer-correct-a-few-numbers-in-comments.patch
clockevents-ensure-taht-min_delta_ns-is-increased-in-error-path.patch
mxcmmc-fix-error-path-in-mxcmci_probe.patch
spi-imx-use-platform_driver_probe-as-probe-lives-in-inittext.patch
spi-imx-correct-check-for-platform_get_irq-failing.patch
spi-imx-use-positive-logic-to-distinguish-cpu-variants.patch
spi-imx-add-mx25-support.patch
spi-imx-dont-access-struct-device-directly-but-use-dev_get_platdata.pat=
ch
rtc-add-freescale-mc13783-rtc-driver.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
