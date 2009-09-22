From: akpm@linux-foundation.org
Subject: [merged] maintainers-omap-fix-regex.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:45:21 -0700
Message-ID: <200909222045.n8MKjLxG015503@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753181AbZIVUpW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:45:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: felipe.contreras@gmail.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: omap: fix regex
has been removed from the -mm tree.  Its filename was
     maintainers-omap-fix-regex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: omap: fix regex
From: Felipe Contreras <felipe.contreras@gmail.com>

Otherwise 'arch/arm/*omap*/foo.c' wouldn't match

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-omap-fix-regex MAINTAINERS
--- a/MAINTAINERS~maintainers-omap-fix-regex
+++ a/MAINTAINERS
@@ -3737,7 +3737,7 @@ W:	http://www.muru.com/linux/omap/
 W:	http://linux.omap.com/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git
 S:	Maintained
-F:	arch/arm/*omap*
+F:	arch/arm/*omap*/
 
 OMAP CLOCK FRAMEWORK SUPPORT
 M:	Paul Walmsley <paul@pwsan.com>
_

Patches currently in -mm which might be from felipe.contreras@gmail.com are

origin.patch
omapfb-add-support-for-the-omap3-beagle-dvi-output.patch

