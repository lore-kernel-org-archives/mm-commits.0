From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-defconfig-file-to-imx-section.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:14:29 -0700
Message-ID: <20121005201429.928AE100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:34492 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820Ab2JEUOa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:14:30 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so235045ggm.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:14:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add defconfig file to IMX section
has been removed from the -mm tree.  Its filename was
     maintainers-add-defconfig-file-to-imx-section.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Subject: MAINTAINERS: add defconfig file to IMX section

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-add-defconfig-file-to-imx-section MAI=
NTAINERS
--- a/MAINTAINERS~maintainers-add-defconfig-file-to-imx-section
+++ a/MAINTAINERS
@@ -760,6 +760,7 @@ S:	Maintained
 T:	git git://git.pengutronix.de/git/imx/linux-2.6.git
 F:	arch/arm/mach-imx/
 F:	arch/arm/plat-mxc/
+F:	arch/arm/configs/imx*_defconfig
=20
 ARM/FREESCALE IMX6
 M:	Shawn Guo <shawn.guo@linaro.org>
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
