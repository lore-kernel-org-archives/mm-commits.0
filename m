From: akpm@osdl.org
Subject: + arm-omap-fix-missing-header-on-apollon-board.patch added to -mm tree
Date: Wed, 27 Dec 2006 01:14:01 -0800
Message-ID: <200612270914.kBR9E10I006539@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:43108 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754695AbWL0JOS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 04:14:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kyungmin.park@samsung.com, rmk@arm.linux.org.uk, tony@atomide.com


The patch titled
     ARM: OMAP: fix missing header on apollon board
has been added to the -mm tree.  Its filename is
     arm-omap-fix-missing-header-on-apollon-board.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ARM: OMAP: fix missing header on apollon board
From: Kyungmin Park <kyungmin.park@samsung.com>

Fix apollon board compiler error

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/arm/mach-omap2/board-apollon.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/arm/mach-omap2/board-apollon.c~arm-omap-fix-missing-header-on-apollon-board arch/arm/mach-omap2/board-apollon.c
--- a/arch/arm/mach-omap2/board-apollon.c~arm-omap-fix-missing-header-on-apollon-board
+++ a/arch/arm/mach-omap2/board-apollon.c
@@ -22,6 +22,7 @@
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
 #include <linux/mtd/onenand.h>
+#include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 
_

Patches currently in -mm which might be from kyungmin.park@samsung.com are

arm-omap-fix-gpmc-compiler-errors.patch
arm-omap-fix-missing-header-on-apollon-board.patch
git-mtd.patch

