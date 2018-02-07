From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-various-palm-patterns.patch
 removed from -mm tree
Date: Wed, 07 Feb 2018 12:00:52 -0800
Message-ID: <20180207200052.JFlZsm_j9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60810 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753721AbeBGUAy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 15:00:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, joe@perches.com, marek.vasut@gmail.com, mm-commits@vger.kernel.org, sleep_walker@suse.com


The patch titled
     Subject: MAINTAINERS: update various PALM patterns
has been removed from the -mm tree.  Its filename was
     maintainers-update-various-palm-patterns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: update various PALM patterns

4c25c5d2985c ("ARM: pxa: make more mach/*.h files local") moved the files
around, update the patterns.

Link: http://lkml.kernel.org/r/a291f6f61e378a1f35e266fe4c5f646b9feeaa6a.1517147485.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Marek Vasut <marek.vasut@gmail.com>
Cc: Tomas Cech <sleep_walker@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN MAINTAINERS~maintainers-update-various-palm-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-various-palm-patterns
+++ a/MAINTAINERS
@@ -1743,8 +1743,7 @@ M:	Tomas Cech <sleep_walker@suse.com>
 L:	linux-arm-kernel@lists.infradead.org
 W:	http://hackndev.com
 S:	Maintained
-F:	arch/arm/mach-pxa/include/mach/palmtreo.h
-F:	arch/arm/mach-pxa/palmtreo.c
+F:	arch/arm/mach-pxa/palmtreo.*
 
 ARM/PALMTX,PALMT5,PALMLD,PALMTE2,PALMTC SUPPORT
 M:	Marek Vasut <marek.vasut@gmail.com>
@@ -1753,12 +1752,10 @@ W:	http://hackndev.com
 S:	Maintained
 F:	arch/arm/mach-pxa/include/mach/palmtx.h
 F:	arch/arm/mach-pxa/palmtx.c
-F:	arch/arm/mach-pxa/include/mach/palmt5.h
-F:	arch/arm/mach-pxa/palmt5.c
+F:	arch/arm/mach-pxa/palmt5.*
 F:	arch/arm/mach-pxa/include/mach/palmld.h
 F:	arch/arm/mach-pxa/palmld.c
-F:	arch/arm/mach-pxa/include/mach/palmte2.h
-F:	arch/arm/mach-pxa/palmte2.c
+F:	arch/arm/mach-pxa/palmte2.*
 F:	arch/arm/mach-pxa/include/mach/palmtc.h
 F:	arch/arm/mach-pxa/palmtc.c
 
@@ -1767,8 +1764,7 @@ M:	Sergey Lapin <slapin@ossfans.org>
 L:	linux-arm-kernel@lists.infradead.org
 W:	http://hackndev.com
 S:	Maintained
-F:	arch/arm/mach-pxa/include/mach/palmz72.h
-F:	arch/arm/mach-pxa/palmz72.c
+F:	arch/arm/mach-pxa/palmz72.*
 
 ARM/PLEB SUPPORT
 M:	Peter Chubb <pleb@gelato.unsw.edu.au>
_

Patches currently in -mm which might be from joe@perches.com are


