From: akpm@linux-foundation.org
Subject: + maintainers-omap-fix-regex.patch added to -mm tree
Date: Sun, 13 Sep 2009 16:48:51 -0700
Message-ID: <200909132348.n8DNmp73001903@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59500 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754206AbZIMXsw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Sep 2009 19:48:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: felipe.contreras@gmail.com, joe@perches.com


The patch titled
     MAINTAINERS: omap: fix regex
has been added to the -mm tree.  Its filename is
     maintainers-omap-fix-regex.patch

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
@@ -3768,7 +3768,7 @@ W:	http://www.muru.com/linux/omap/
 W:	http://linux.omap.com/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git
 S:	Maintained
-F:	arch/arm/*omap*
+F:	arch/arm/*omap*/
 
 OMAP CLOCK FRAMEWORK SUPPORT
 M:	Paul Walmsley <paul@pwsan.com>
_

Patches currently in -mm which might be from felipe.contreras@gmail.com are

maintainers-acpi-add-include-acpi.patch
maintainers-omap-fix-regex.patch
omapfb-add-support-for-the-omap3-beagle-dvi-output.patch

