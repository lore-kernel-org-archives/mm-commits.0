From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-defconfig-file-to-tegra-section.patch removed from -mm tree
Date: Tue, 11 Sep 2012 12:32:23 -0700
Message-ID: <20120911193224.158AA5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:51661 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab2IKTc0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Sep 2012 15:32:26 -0400
Received: by eekd4 with SMTP id d4so66333eek.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Sep 2012 12:32:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add defconfig file to TEGRA section
has been removed from the -mm tree.  Its filename was
     maintainers-add-defconfig-file-to-tegra-section.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Subject: MAINTAINERS: add defconfig file to TEGRA section

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-add-defconfig-file-to-tegra-section M=
AINTAINERS
--- a/MAINTAINERS~maintainers-add-defconfig-file-to-tegra-section
+++ a/MAINTAINERS
@@ -6816,6 +6816,7 @@ Q:	http://patchwork.ozlabs.org/project/l
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-teg=
ra.git
 S:	Supported
 F:	arch/arm/mach-tegra
+F:	arch/arm/configs/tegra_defconfig
=20
 TEHUTI ETHERNET DRIVER
 M:	Andy Gospodarek <andy@greyhouse.net>
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

linux-next.patch
maintainers-add-defconfig-file-to-imx-section.patch
rtc_sysfs_show_hctosys-return-0-if-resume-failed.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
