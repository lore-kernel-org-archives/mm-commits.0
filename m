From: akpm@linux-foundation.org
Subject: - pnp-increase-the-number-of-memory-resources-from-12-to-24.patch removed from -mm tree
Date: Mon, 24 Mar 2008 12:24:40 -0700
Message-ID: <200803241924.m2OJOe4S021442@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759614AbYCXTZH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 15:25:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@youmustbejoking.demon.co.uk, ambx1@neo.rr.com, bjorn.helgaas@hp.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     pnp: increase the number of memory resources from 12 to 24
has been removed from the -mm tree.  Its filename was
     pnp-increase-the-number-of-memory-resources-from-12-to-24.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnp: increase the number of memory resources from 12 to 24
From: Darren Salt <linux@youmustbejoking.demon.co.uk>

Increase the number of PnP memory resources from 12 to 24.

This removes an "exceeded the max num of mem resources" warning on boot.  I
also noticed the reservation of two more iomem ranges on the computer on which
this was tested.

Signed-off-by: Darren Salt <linux@youmustbejoking.demon.co.uk>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Adam Belay <ambx1@neo.rr.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pnp.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/pnp.h~pnp-increase-the-number-of-memory-resources-from-12-to-24 include/linux/pnp.h
--- a/include/linux/pnp.h~pnp-increase-the-number-of-memory-resources-from-12-to-24
+++ a/include/linux/pnp.h
@@ -14,7 +14,7 @@
 #include <linux/mod_devicetable.h>
 
 #define PNP_MAX_PORT		40
-#define PNP_MAX_MEM		12
+#define PNP_MAX_MEM		24
 #define PNP_MAX_IRQ		2
 #define PNP_MAX_DMA		2
 #define PNP_NAME_LEN		50
_

Patches currently in -mm which might be from linux@youmustbejoking.demon.co.uk are

origin.patch

