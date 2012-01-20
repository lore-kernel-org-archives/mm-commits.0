From: akpm@linux-foundation.org
Subject: + maintainers-remove-imx5-section.patch added to -mm tree
Date: Fri, 20 Jan 2012 14:40:56 -0800
Message-ID: <20120120224057.9CCC420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:33977 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756297Ab2ATWlA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2012 17:41:00 -0500
Received: by eekb15 with SMTP id b15so40121eek.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2012 14:40:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, amit.kucheria@canonical.com, s.hauer@pengutronix.de


The patch titled
     Subject: MAINTAINERS: remove iMX5 section
has been added to the -mm tree.  Its filename is
     maintainers-remove-imx5-section.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: remove iMX5 section

commit 784a90c0a7d8f5 ("ARM i.MX: Merge i.MX5 support into mach-imx")
merged the files, remove the iMX5 section.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Amit Kucheria <amit.kucheria@canonical.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ------
 1 file changed, 6 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-imx5-section MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-imx5-section
+++ a/MAINTAINERS
@@ -789,12 +789,6 @@ F:	arch/arm/mach-mx*/
 F:	arch/arm/mach-imx/
 F:	arch/arm/plat-mxc/
 
-ARM/FREESCALE IMX51
-M:	Amit Kucheria <amit.kucheria@canonical.com>
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-S:	Maintained
-F:	arch/arm/mach-mx5/
