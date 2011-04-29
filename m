From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-exynos-arm-architectures.patch removed from -mm tree
Date: Fri, 29 Apr 2011 12:46:50 -0700
Message-ID: <201104291941.p3TJfLb0011444@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57261 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754397Ab1D2Tmd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Apr 2011 15:42:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kgene.kim@samsung.com, ben-linux@fluff.org, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: add EXYNOS ARM architectures
has been removed from the -mm tree.  Its filename was
     maintainers-add-exynos-arm-architectures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: add EXYNOS ARM architectures
From: Kukjin Kim <kgene.kim@samsung.com>

Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-add-exynos-arm-architectures MAINTAINERS
--- a/MAINTAINERS~maintainers-add-exynos-arm-architectures
+++ a/MAINTAINERS
@@ -1032,12 +1032,13 @@ W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c64xx/
 
-ARM/S5P ARM ARCHITECTURES
+ARM/S5P EXYNOS ARM ARCHITECTURES
 M:	Kukjin Kim <kgene.kim@samsung.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 L:	linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-s5p*/
+F:	arch/arm/mach-exynos*/
 
 ARM/SAMSUNG MOBILE MACHINE SUPPORT
 M:	Kyungmin Park <kyungmin.park@samsung.com>
_

Patches currently in -mm which might be from kgene.kim@samsung.com are

origin.patch
linux-next.patch

