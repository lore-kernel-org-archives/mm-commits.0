From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-for-ti-omap-hsmmc-driver.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:55:25 -0700
Message-ID: <200909231955.n8NJtPR4002813__29044.3520913415$1253735794$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49605 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753652AbZIWTz5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:55:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: madhu.cr@ti.com, khilman@deeprootsystems.com, linux-mmc@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: update for TI OMAP hsmmc driver
has been removed from the -mm tree.  Its filename was
     maintainers-update-for-ti-omap-hsmmc-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: update for TI OMAP hsmmc driver
From: "Madhusudhan Chikkature" <madhu.cr@ti.com>

Update maintainers entry for TI OMAP HS MMC support.

Signed-off-by: Madhusudhan Chikkature <madhu.cr@ti.com>
Acked-by: Kevin Hilman <khilman@deeprootsystems.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-for-ti-omap-hsmmc-driver MAINTAINERS
--- a/MAINTAINERS~maintainers-update-for-ti-omap-hsmmc-driver
+++ a/MAINTAINERS
@@ -3768,7 +3768,13 @@ OMAP MMC SUPPORT
 M:	Jarkko Lavinen <jarkko.lavinen@nokia.com>
 L:	linux-omap@vger.kernel.org
 S:	Maintained
-F:	drivers/mmc/host/*omap*
+F:	drivers/mmc/host/omap.c
+
+OMAP HS MMC SUPPORT
+M:	Madhusudhan Chikkature <madhu.cr@ti.com>
+L:	linux-omap@vger.kernel.org
+S:	Maintained
+F:	drivers/mmc/host/omap_hsmmc.c
 
 OMAP RANDOM NUMBER GENERATOR SUPPORT
 M:	Deepak Saxena <dsaxena@plexity.net>
_

Patches currently in -mm which might be from madhu.cr@ti.com are

origin.patch

