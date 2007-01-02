From: akpm@osdl.org
Subject: - arm-omap-fix-missing-header-on-apollon-board.patch removed from -mm tree
Date: Mon, 01 Jan 2007 23:24:47 -0800
Message-ID: <200701020724.l027OlBm012980@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37412 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932907AbXABHZP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 02:25:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kyungmin.park@samsung.com, rmk@arm.linux.org.uk, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     ARM: OMAP: fix missing header on apollon board
has been removed from the -mm tree.  Its filename was
     arm-omap-fix-missing-header-on-apollon-board.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-mtd.patch
