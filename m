From: akpm@linux-foundation.org
Subject: [merged] maintainers-remove-arch-arm-plat-s5p.patch removed from -mm tree
Date: Mon, 07 Jan 2013 11:25:57 -0800
Message-ID: <20130107192558.0E70320004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f73.google.com ([74.125.83.73]:50131 "EHLO
	mail-ee0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207Ab3AGT0A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 14:26:00 -0500
Received: by mail-ee0-f73.google.com with SMTP id c50so1214159eek.4
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 11:25:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, ben-linux@fluff.org, kgene.kim@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove arch/arm/plat-s5p/
has been removed from the -mm tree.  Its filename was
     maintainers-remove-arch-arm-plat-s5p.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: MAINTAINERS: remove arch/arm/plat-s5p/

These files were merged into plat-samsung.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Ben Dooks <ben-linux@fluff.org>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-arch-arm-plat-s5p MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-arch-arm-plat-s5p
+++ a/MAINTAINERS
@@ -1092,7 +1092,6 @@ W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/plat-samsung/
 F:	arch/arm/plat-s3c24xx/
-F:	arch/arm/plat-s5p/
 F:	arch/arm/mach-s3c24*/
 F:	arch/arm/mach-s3c64xx/
 F:	drivers/*/*s3c2410*
@@ -1123,7 +1122,6 @@ M:	Sylwester Nawrocki <s.nawrocki@samsun
 L:	linux-arm-kernel@lists.infradead.org
 L:	linux-media@vger.kernel.org
 S:	Maintained
-F:	arch/arm/plat-s5p/dev-fimc*
 F:	arch/arm/plat-samsung/include/plat/*fimc*
 F:	drivers/media/platform/s5p-fimc/
 
@@ -1134,7 +1132,7 @@ M:	Jeongtae Park <jtp.park@samsung.com>
 L:	linux-arm-kernel@lists.infradead.org
 L:	linux-media@vger.kernel.org
 S:	Maintained
-F:	arch/arm/plat-s5p/dev-mfc.c
+F:	arch/arm/plat-samsung/s5p-dev-mfc.c
 F:	drivers/media/platform/s5p-mfc/
 
 ARM/SAMSUNG S5P SERIES TV SUBSYSTEM SUPPORT
_

Patches currently in -mm which might be from cesarb@cesarb.net are

origin.patch
linux-next.patch

