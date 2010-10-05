From: akpm@linux-foundation.org
Subject: + maintainers-add-samsung-s5p-series-fimc-maintainers.patch added to -mm tree
Date: Tue, 05 Oct 2010 15:07:02 -0700
Message-ID: <201010052207.o95M72Be022895@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754172Ab0JEWHp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Oct 2010 18:07:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kyungmin.park@samsung.com, rmk@arm.linux.org.uk, s.nawrocki@samsung.com


The patch titled
     MAINTAINERS: add Samsung S5P series FIMC maintainers
has been added to the -mm tree.  Its filename is
     maintainers-add-samsung-s5p-series-fimc-maintainers.patch

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
Subject: MAINTAINERS: add Samsung S5P series FIMC maintainers
From: Kyungmin Park <kyungmin.park@samsung.com>

Add Samsung S5P series FIMC(Camera Interface) maintainers.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN MAINTAINERS~maintainers-add-samsung-s5p-series-fimc-maintainers MAINTAINERS
--- a/MAINTAINERS~maintainers-add-samsung-s5p-series-fimc-maintainers
+++ a/MAINTAINERS
@@ -969,6 +969,16 @@ L:	linux-samsung-soc@vger.kernel.org (mo
 S:	Maintained
 F:	arch/arm/mach-s5p*/
 
+ARM/SAMSUNG S5P SERIES FIMC SUPPORT
+M:	Kyungmin Park <kyungmin.park@samsung.com>
+M:	Sylwester Nawrocki <s.nawrocki@samsung.com>
+L:	linux-arm-kernel@lists.infradead.org
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	arch/arm/plat-s5p/dev-fimc*
+F:	arch/arm/plat-samsung/include/plat/*fimc*
+F:	drivers/media/video/s5p-fimc/
+
 ARM/SHMOBILE ARM ARCHITECTURE
 M:	Paul Mundt <lethal@linux-sh.org>
 M:	Magnus Damm <magnus.damm@gmail.com>
_

Patches currently in -mm which might be from kyungmin.park@samsung.com are

origin.patch
maintainers-add-samsung-s5p-series-fimc-maintainers.patch
linux-next.patch
ramoops-use-the-platform-data-structure-instead-of-module-params.patch
ramoops-use-the-platform-data-structure-instead-of-module-params-fix.patch

