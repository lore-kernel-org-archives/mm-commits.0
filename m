From: akpm@linux-foundation.org
Subject: [merged] maintainers-remove-imx5-section.patch removed from -mm tree
Date: Mon, 06 Feb 2012 12:31:11 -0800
Message-ID: <20120206203111.6F684A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:62011 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401Ab2BFUbM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2012 15:31:12 -0500
Received: by yenm1 with SMTP id m1so20453yen.1
        for <mm-commits@vger.kernel.org>; Mon, 06 Feb 2012 12:31:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, amit.kucheria@canonical.com, s.hauer@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove iMX5 section
has been removed from the -mm tree.  Its filename was
     maintainers-remove-imx5-section.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
