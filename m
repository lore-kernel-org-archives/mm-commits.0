From: akpm@linux-foundation.org
Subject: [merged] updated-f-and-t-in-maintainers-kristoffer-ericson.patch removed from -mm tree
Date: Thu, 30 Jul 2009 13:38:22 -0700
Message-ID: <200907302038.n6UKcMnb013031@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752347AbZG3UiX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 16:38:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kristoffer.ericson@gmail.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: update HP Jornada 700-series and Epson s1d13xxxfb support
has been removed from the -mm tree.  Its filename was
     updated-f-and-t-in-maintainers-kristoffer-ericson.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -624,6 +624,9 @@ ARM/HP JORNADA 7XX MACHINE SUPPORT
 M:	Kristoffer Ericson <kristoffer.ericson@gmail.com>
 W:	www.jlime.com
 S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kristoffer/linux-hpc.git
+F:	arch/arm/mach-sa1100/jornada720.c
+F:	arch/arm/mach-sa1100/include/mach/jornada720.h
 
 ARM/INTEL IOP32X ARM ARCHITECTURE
 M:	Lennert Buytenhek <kernel@wantstofly.org>
@@ -1900,6 +1903,7 @@ F:	drivers/video/epson1355fb.c
 EPSON S1D13XXX FRAMEBUFFER DRIVER
 M:	Kristoffer Ericson <kristoffer.ericson@gmail.com>
 S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kristoffer/linux-hpc.git
 F:	drivers/video/s1d13xxxfb.c
 F:	include/video/s1d13xxxfb.h
 
_

Patches currently in -mm which might be from kristoffer.ericson@gmail.com are

origin.patch

