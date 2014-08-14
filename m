From: akpm@linux-foundation.org
Subject: +
 remove-non-existent-files-from-maintainerspatch-added-to-mm-tree.patch
 added to -mm tree
Date: Thu, 14 Aug 2014 13:15:01 -0700
Message-ID: <53ed18c5.UsuuCnh0d1Egzzlh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f74.google.com ([209.85.192.74]:33774 "EHLO
	mail-qg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbaHNUPC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Aug 2014 16:15:02 -0400
Received: by mail-qg0-f74.google.com with SMTP id z60so195343qgd.3
        for <mm-commits@vger.kernel.org>; Thu, 14 Aug 2014 13:15:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lists@nerdbynature.de, cesarb@cesarb.eti.br, kyungmin.park@samsung.com, sbkim73@samsung.com, t.figa@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove non existent files
has been added to the -mm tree.  Its filename is
     remove-non-existent-files-from-maintainerspatch-added-to-mm-tree.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/remove-non-existent-files-from-maintainerspatch-added-to-mm-tree.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/remove-non-existent-files-from-maintainerspatch-added-to-mm-tree.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christian Kujau <lists@nerdbynature.de>
Subject: MAINTAINERS: remove non existent files

Inspired by some recent cleanups in MAINTAINERS the following files (F:)
cannot be found any more in the tree:

* arch/arm/mach-s5pv210/mach-aquila.c
* arch/arm/mach-s5pv210/mach-goni.c

Those two got removed in 28c8331 ("ARM: S5PV210: Remove support for board files").
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
* drivers/rtc/rtc-sec.c

A MAINTAINERS fix was attempted in November 2012, but dismissed as rtc-sec.c
was still being worked on. Alas, it's still not there.

"MAINTAINERS: fix drivers/rtc/rtc-sec.c"
http://lkml.iu.edu/hypermail/linux/kernel/1211.2/04820.html
Cc: Sangbeom Kim <sbkim73@samsung.com>
Cc: Cesar Eduardo Barros <cesarb@cesarb.eti.br>

Signed-off-by: Christian Kujau <lists@nerdbynature.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN MAINTAINERS~remove-non-existent-files-from-maintainerspatch-added-to-mm-tree MAINTAINERS
--- a/MAINTAINERS~remove-non-existent-files-from-maintainerspatch-added-to-mm-tree
+++ a/MAINTAINERS
@@ -1311,8 +1311,7 @@ ARM/SAMSUNG MOBILE MACHINE SUPPORT
 M:	Kyungmin Park <kyungmin.park@samsung.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
-F:	arch/arm/mach-s5pv210/mach-aquila.c
-F:	arch/arm/mach-s5pv210/mach-goni.c
+F:	arch/arm/mach-s5pv210/
 
 ARM/SAMSUNG S5P SERIES 2D GRAPHICS ACCELERATION (G2D) SUPPORT
 M:	Kyungmin Park <kyungmin.park@samsung.com>
@@ -7817,7 +7816,6 @@ S:	Supported
 F:	drivers/mfd/sec*.c
 F:	drivers/regulator/s2m*.c
 F:	drivers/regulator/s5m*.c
-F:	drivers/rtc/rtc-sec.c
 F:	include/linux/mfd/samsung/
 
 SAMSUNG S5P/EXYNOS4 SOC SERIES CAMERA SUBSYSTEM DRIVERS
_

Patches currently in -mm which might be from lists@nerdbynature.de are

remove-non-existent-files-from-maintainerspatch-added-to-mm-tree.patch

