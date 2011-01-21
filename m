From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-atmel-at91-entry.patch removed from -mm tree
Date: Fri, 21 Jan 2011 12:31:50 -0800
Message-ID: <201101212031.p0LKVog7031656@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751577Ab1AUUl7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Jan 2011 15:41:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.ferre@atmel.com, linux@maxim.org.za, plagnioj@jcrosoft.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: update Atmel AT91 entry
has been removed from the -mm tree.  Its filename was
     maintainers-update-atmel-at91-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: update Atmel AT91 entry
From: Nicolas Ferre <nicolas.ferre@atmel.com>

Add two co-maintainers and update the entry with new information.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Andrew Victor <linux@maxim.org.za>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-update-atmel-at91-entry MAINTAINERS
--- a/MAINTAINERS~maintainers-update-atmel-at91-entry
+++ a/MAINTAINERS
@@ -624,11 +624,15 @@ M:	Lennert Buytenhek <kernel@wantstofly.
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
-ARM/ATMEL AT91RM9200 ARM ARCHITECTURE
+ARM/ATMEL AT91RM9200 AND AT91SAM ARM ARCHITECTURES
 M:	Andrew Victor <linux@maxim.org.za>
+M:	Nicolas Ferre <nicolas.ferre@atmel.com>
+M:	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://maxim.org.za/at91_26.html
-S:	Maintained
+W:	http://www.linux4sam.org
+S:	Supported
+F:	arch/arm/mach-at91/
 
 ARM/BCMRING ARM ARCHITECTURE
 M:	Jiandong Zheng <jdzheng@broadcom.com>
_

Patches currently in -mm which might be from nicolas.ferre@atmel.com are

origin.patch

