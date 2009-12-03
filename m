From: akpm@linux-foundation.org
Subject: + sysfs-deprecated-features-are-to-help-old-tools-not-to-confuse-them.patch added to -mm tree
Date: Thu, 03 Dec 2009 15:02:46 -0800
Message-ID: <200912032302.nB3N2ksX016163@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750765AbZLCXDx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Dec 2009 18:03:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de, gregkh@suse.de, kay.sievers@vrfy.org, randy.dunlap@oracle.com


The patch titled
     sysfs: deprecated features are to help old tools not to confuse th=
em
has been added to the -mm tree.  Its filename is
     sysfs-deprecated-features-are-to-help-old-tools-not-to-confuse-the=
m.patch

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

linux-next.patch
sysfs-deprecated-features-are-to-help-old-tools-not-to-confuse-them.pat=
ch
hrtimer-correct-a-few-numbers-in-comments.patch
clockevents-ensure-taht-min_delta_ns-is-increased-in-error-path.patch
mxcmmc-fix-error-path-in-mxcmci_probe.patch
spi-drain-mxc-spi-transfer-buffer-when-probing-device.patch
rtc-add-freescale-mc13783-rtc-driver.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
