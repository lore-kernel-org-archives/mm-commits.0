From: akpm@linux-foundation.org
Subject: [merged]
 maintainers-remove-arm-clkdev-support-file-pattern.patch removed from -mm
 tree
Date: Wed, 07 Feb 2018 12:00:43 -0800
Message-ID: <20180207200043.s-8fPMOXo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60758 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753721AbeBGUAo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 15:00:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, linux@armlinux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove ARM/CLKDEV SUPPORT file pattern
has been removed from the -mm tree.  Its filename was
     maintainers-remove-arm-clkdev-support-file-pattern.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: remove ARM/CLKDEV SUPPORT file pattern

34d2f4d3a4d6 ("ARM: Use generic clkdev.h header") removed the file, remove
the pattern.

Link: http://lkml.kernel.org/r/41bfff9449a5894b94f583983b6c6cb46f4cd821.1517147485.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-remove-arm-clkdev-support-file-pattern MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-arm-clkdev-support-file-pattern
+++ a/MAINTAINERS
@@ -1307,7 +1307,6 @@ M:	Russell King <linux@armlinux.org.uk>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 T:	git git://git.armlinux.org.uk/~rmk/linux-arm.git clkdev
-F:	arch/arm/include/asm/clkdev.h
 F:	drivers/clk/clkdev.c
 
 ARM/COMPULAB CM-X270/EM-X270 and CM-X300 MACHINE SUPPORT
_

Patches currently in -mm which might be from joe@perches.com are


