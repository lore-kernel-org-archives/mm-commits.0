From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-maintainer-of-samsung-mobile-machine-support.patch removed from -mm tree
Date: Mon, 07 Mar 2011 13:31:08 -0800
Message-ID: <201103072131.p27LVpNM028066@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755568Ab1CGVcg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2011 16:32:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kyungmin.park@samsung.com, davem@davemloft.net, joe@perches.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: add maintainer of Samsung Mobile Machine support
has been removed from the -mm tree.  Its filename was
     maintainers-add-maintainer-of-samsung-mobile-machine-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: add maintainer of Samsung Mobile Machine support
From: Kyungmin Park <kyungmin.park@samsung.com>

Add maintainer of Samsung Mobile machine support.  Currently, Aquila,
Goni, Universal (C210), and Nuri board are supported.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Joe Perches <joe@perches.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN MAINTAINERS~maintainers-add-maintainer-of-samsung-mobile-machine-support MAINTAINERS
--- a/MAINTAINERS~maintainers-add-maintainer-of-samsung-mobile-machine-support
+++ a/MAINTAINERS
@@ -1010,6 +1010,15 @@ L:	linux-samsung-soc@vger.kernel.org (mo
 S:	Maintained
 F:	arch/arm/mach-s5p*/
 
+ARM/SAMSUNG MOBILE MACHINE SUPPORT
+M:	Kyungmin Park <kyungmin.park@samsung.com>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+S:	Maintained
+F:	arch/arm/mach-s5pv210/mach-aquila.c
+F:	arch/arm/mach-s5pv210/mach-goni.c
+F:	arch/arm/mach-exynos4/mach-universal_c210.c
+F:	arch/arm/mach-exynos4/mach-nuri.c
+
 ARM/SAMSUNG S5P SERIES FIMC SUPPORT
 M:	Kyungmin Park <kyungmin.park@samsung.com>
 M:	Sylwester Nawrocki <s.nawrocki@samsung.com>
_

Patches currently in -mm which might be from kyungmin.park@samsung.com are

origin.patch
linux-next.patch
drivers-vidfeo-backlight-ld9040-amoled-driver-support.patch

