From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-clkdev-location.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:39:49 -0700
Message-ID: <201103232043.p2NKhPRc028862@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55901 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933456Ab1CWUoG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:44:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, plagnioj@jcrosoft.com, rmk+kernel@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: update clkdev location
has been removed from the -mm tree.  Its filename was
     maintainers-update-clkdev-location.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: update clkdev location
From: Joe Perches <joe@perches.com>

Commit 6d803ba736a ("ARM: 6483/1: arm & sh: factorised duplicated
clkdev.c") moved it to a separate directory.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-clkdev-location MAINTAINERS
--- a/MAINTAINERS~maintainers-update-clkdev-location
+++ a/MAINTAINERS
@@ -695,8 +695,8 @@ S:	Maintained
 ARM/CLKDEV SUPPORT
 M:	Russell King <linux@arm.linux.org.uk>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-F:	arch/arm/common/clkdev.c
 F:	arch/arm/include/asm/clkdev.h
+F:	drivers/clk/clkdev.c
 
 ARM/COMPULAB CM-X270/EM-X270 and CM-X300 MACHINE SUPPORT
 M:	Mike Rapoport <mike@compulab.co.il>
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch

