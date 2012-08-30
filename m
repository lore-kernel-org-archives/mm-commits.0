From: akpm@linux-foundation.org
Subject: + maintainers-add-defconfig-file-to-tegra-section.patch added to -mm tree
Date: Thu, 30 Aug 2012 15:12:02 -0700
Message-ID: <20120830221203.0B13B1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:49824 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab2H3WME (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Aug 2012 18:12:04 -0400
Received: by qafl39 with SMTP id l39so95297qaf.1
        for <mm-commits@vger.kernel.org>; Thu, 30 Aug 2012 15:12:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de


The patch titled
     Subject: MAINTAINERS: add defconfig file to TEGRA section
has been added to the -mm tree.  Its filename is
     maintainers-add-defconfig-file-to-tegra-section.patch

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

origin.patch
linux-next.patch
maintainers-add-defconfig-file-to-tegra-section.patch
maintainers-add-defconfig-file-to-imx-section.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
