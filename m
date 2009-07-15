From: akpm@linux-foundation.org
Subject: + updated-f-and-t-in-maintainers-kristoffer-ericson.patch added to -mm tree
Date: Wed, 15 Jul 2009 13:24:11 -0700
Message-ID: <200907152024.n6FKOBbf003936@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50551 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932260AbZGOUYO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Jul 2009 16:24:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kristoffer.ericson@gmail.com


The patch titled
     MAINTAINERS: update HP Jornada 700-series and Epson s1d13xxxfb support
has been added to the -mm tree.  Its filename is
     updated-f-and-t-in-maintainers-kristoffer-ericson.patch

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
Subject: MAINTAINERS: update HP Jornada 700-series and Epson s1d13xxxfb support
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>

Add the relevant git repositories and affected files to the maintainership
of HP Jornada 700-series and Epson s1d13xxxfb support.

Signed-off-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN MAINTAINERS~updated-f-and-t-in-maintainers-kristoffer-ericson MAINTAINERS
--- a/MAINTAINERS~updated-f-and-t-in-maintainers-kristoffer-ericson
+++ a/MAINTAINERS
@@ -627,6 +627,9 @@ ARM/HP JORNADA 7XX MACHINE SUPPORT
 M:	Kristoffer Ericson <kristoffer.ericson@gmail.com>
 W:	www.jlime.com
 S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kristoffer/linux-hpc.git
+F:	arch/arm/mach-sa1100/jornada720.c
+F:	arch/arm/mach-sa1100/include/mach/jornada720.h
 
 ARM/INTEL IOP32X ARM ARCHITECTURE
 M:	Lennert Buytenhek <kernel@wantstofly.org>
@@ -1897,6 +1900,7 @@ F:	drivers/video/epson1355fb.c
 EPSON S1D13XXX FRAMEBUFFER DRIVER
 M:	Kristoffer Ericson <kristoffer.ericson@gmail.com>
 S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kristoffer/linux-hpc.git
 F:	drivers/video/s1d13xxxfb.c
 F:	include/video/s1d13xxxfb.h
 
_

Patches currently in -mm which might be from kristoffer.ericson@gmail.com are

updated-f-and-t-in-maintainers-kristoffer-ericson.patch

