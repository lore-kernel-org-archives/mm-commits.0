From: akpm@osdl.org
Subject: + another-build-fix-header-rearrangements-osk.patch added to -mm tree
Date: Sun, 10 Dec 2006 11:31:06 -0800
Message-ID: <200612101931.kBAJV6QT000929@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53432 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762426AbWLJTbl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 14:31:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net, rmk@arm.linux.org.uk, tony@atomide.com


The patch titled
     another build fix, header rearrangements (OSK)
has been added to the -mm tree.  Its filename is
     another-build-fix-header-rearrangements-osk.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: another build fix, header rearrangements (OSK)
From: David Brownell <david-b@pacbell.net>

Some of the header file rearrangements broke the build for board-osk.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: <tony@atomide.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/arm/mach-omap1/board-osk.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/arm/mach-omap1/board-osk.c~another-build-fix-header-rearrangements-osk arch/arm/mach-omap1/board-osk.c
--- a/arch/arm/mach-omap1/board-osk.c~another-build-fix-header-rearrangements-osk
+++ a/arch/arm/mach-omap1/board-osk.c
@@ -30,6 +30,7 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/irq.h>
+#include <linux/interrupt.h>
 
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
rtcs-dont-use-i2c_adapterdev.patch
fix-more-workqueue-build-breakage-tps65010.patch
another-build-fix-header-rearrangements-osk.patch
watchdog-omap_wdt-build-fix.patch

