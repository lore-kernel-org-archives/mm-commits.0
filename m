From: akpm@linux-foundation.org
Subject: + maintainers-update-various-palm-patterns.patch added to -mm
 tree
Date: Mon, 29 Jan 2018 15:40:41 -0800
Message-ID: <5a6fb0f9.wiaJFq6QrFGuxR+R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50966 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751547AbeA2Xkm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jan 2018 18:40:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, akpm@linux-foundation.org, arnd@arndb.de, marek.vasut@gmail.com, sleep_walker@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update various PALM patterns
has been added to the -mm tree.  Its filename is
     maintainers-update-various-palm-patterns.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-update-various-palm-patterns.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-update-various-palm-patterns.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

checkpatch-ignore-some-octal-permissions-of-0.patch
checkpatch-improve-quoted-string-and-line-continuation-test.patch
checkpatch-add-a-few-device_attr-style-tests.patch
checkpatch-improve-the-tabstop-test-to-include-declarations.patch
checkpatch-exclude-drivers-staging-from-if-with-unnecessary-parentheses-test.patch
checkpatch-avoid-some-false-positives-for-tabstop-declaration-test.patch
maintainers-remove-android-ion-pattern.patch
maintainers-remove-arm-clkdev-support-file-pattern.patch
maintainers-update-cortina-gemini-patterns.patch
maintainers-update-arm-oxnas-platform-support-patterns.patch
maintainers-update-various-palm-patterns.patch
maintainers-update-arm-qualcomm-support-patterns.patch

