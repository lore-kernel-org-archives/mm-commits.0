From: akpm@linux-foundation.org
Subject: - ixp4xx-remove-double-include.patch removed from -mm tree
Date: Mon, 26 Nov 2007 13:48:15 -0800
Message-ID: <200711262148.lAQLmF4N024583@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39876 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754896AbXKZVsp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 16:48:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andre@bitwigglers.org, a.zummo@towertech.it, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     ixp4xx: remove double include
has been removed from the -mm tree.  Its filename was
     ixp4xx-remove-double-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ixp4xx: remove double include
From: Andre Haupt <andre@bitwigglers.org>

 Remove double include.

Signed-off-by: Andre Haupt <andre@bitwigglers.org>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-ixp4xx/nslu2-power.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/arm/mach-ixp4xx/nslu2-power.c~ixp4xx-remove-double-include arch/arm/mach-ixp4xx/nslu2-power.c
--- a/arch/arm/mach-ixp4xx/nslu2-power.c~ixp4xx-remove-double-include
+++ a/arch/arm/mach-ixp4xx/nslu2-power.c
@@ -18,7 +18,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/reboot.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/reboot.h>
_

Patches currently in -mm which might be from andre@bitwigglers.org are

git-arm.patch
