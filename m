From: akpm@linux-foundation.org
Subject: + maintainers-add-exynos-arm-architectures.patch added to -mm tree
Date: Wed, 20 Apr 2011 16:02:13 -0700
Message-ID: <201104202302.p3KN2D32032513@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40368 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752156Ab1DTXCl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Apr 2011 19:02:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kgene.kim@samsung.com, ben-linux@fluff.org, rmk@arm.linux.org.uk


The patch titled
     MAINTAINERS: add EXYNOS ARM architectures
has been added to the -mm tree.  Its filename is
     maintainers-add-exynos-arm-architectures.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1039,12 +1039,13 @@ W:	http://www.fluff.org/ben/linux/
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

linux-next.patch
maintainers-update-documentation-file-entry-of-gpio-subsystem.patch
maintainers-add-exynos-arm-architectures.patch

