From: akpm@linux-foundation.org
Subject: [merged] maintainers-fix-arch-arm-mach-at91-include-mach-at_hdmach.patch removed from -mm tree
Date: Mon, 07 Jan 2013 11:26:05 -0800
Message-ID: <20130107192606.13CA4200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:39137 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150Ab3AGT0I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 14:26:08 -0500
Received: by mail-fa0-f74.google.com with SMTP id t1so1261270fae.1
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 11:26:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, nicolas.ferre@atmel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: fix arch/arm/mach-at91/include/mach/at_hdmac.h
has been removed from the -mm tree.  Its filename was
     maintainers-fix-arch-arm-mach-at91-include-mach-at_hdmach.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: MAINTAINERS: fix arch/arm/mach-at91/include/mach/at_hdmac.h

This file was moved to include/linux/platform_data/dma-atmel.h by commit
7cdc39e ("ARM: at91: move platform_data definitions").

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-fix-arch-arm-mach-at91-include-mach-at_hdmach MAINTAINERS
--- a/MAINTAINERS~maintainers-fix-arch-arm-mach-at91-include-mach-at_hdmach
+++ a/MAINTAINERS
@@ -1402,7 +1402,7 @@ L:	linux-arm-kernel@lists.infradead.org 
 S:	Supported
 F:	drivers/dma/at_hdmac.c
 F:	drivers/dma/at_hdmac_regs.h
-F:	arch/arm/mach-at91/include/mach/at_hdmac.h
+F:	include/linux/platform_data/dma-atmel.h
 
 ATMEL ISI DRIVER
 M:	Josh Wu <josh.wu@atmel.com>
_

Patches currently in -mm which might be from cesarb@cesarb.net are

origin.patch
linux-next.patch

