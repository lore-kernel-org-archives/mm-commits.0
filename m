From: akpm@osdl.org
Subject: - another-build-fix-header-rearrangements-osk.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:01:01 -0800
Message-ID: <200612140601.kBE611OV001686@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51502 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831AbWLNGCK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:02:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, rmk@arm.linux.org.uk, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     another build fix, header rearrangements (OSK)
has been removed from the -mm tree.  Its filename was
     another-build-fix-header-rearrangements-osk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


