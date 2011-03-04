From: akpm@linux-foundation.org
Subject: + maintainers-add-maintainer-of-samsung-mobile-machine-support.patch added to -mm tree
Date: Fri, 04 Mar 2011 15:53:38 -0800
Message-ID: <201103042353.p24Nrc0A011286@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56859 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760148Ab1CDXyQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2011 18:54:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kyungmin.park@samsung.com, davem@davemloft.net, joe@perches.com, rmk@arm.linux.org.uk


The patch titled
     MAINTAINERS: add maintainer of Samsung Mobile Machine support
has been added to the -mm tree.  Its filename is
     maintainers-add-maintainer-of-samsung-mobile-machine-support.patch

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
@@ -1028,6 +1028,15 @@ L:	linux-samsung-soc@vger.kernel.org (mo
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

maintainers-add-maintainer-of-samsung-mobile-machine-support.patch
linux-next.patch
drivers-vidfeo-backlight-ld9040-amoled-driver-support.patch

