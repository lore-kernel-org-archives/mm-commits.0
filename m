From: akpm@linux-foundation.org
Subject: - forcedeth-version-bump.patch removed from -mm tree
Date: Thu, 24 May 2007 15:05:21 -0700
Message-ID: <200705242205.l4OM5LjU004379@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:51355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752059AbXEXWF5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 May 2007 18:05:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aabdulla@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     forcedeth: version bump
has been removed from the -mm tree.  Its filename was
     forcedeth-version-bump.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: forcedeth: version bump
From: Ayaz Abdulla <aabdulla@nvidia.com>

This patch bumps up the version.

Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/forcedeth.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/net/forcedeth.c~forcedeth-version-bump drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~forcedeth-version-bump
+++ a/drivers/net/forcedeth.c
@@ -112,6 +112,7 @@
  *	0.58: 30 Oct 2006: Added support for sideband management unit.
  *	0.59: 30 Oct 2006: Added support for recoverable error.
  *	0.60: 20 Jan 2007: Code optimizations for rings, rx & tx data paths, and stats.
+ *	0.61: 21 May 2007: Fix power management code, cpu mask, and added vitesse phy.
  *
  * Known bugs:
  * We suspect that on some hardware no TX done interrupts are generated.
@@ -128,7 +129,7 @@
 #else
 #define DRIVERNAPI
 #endif
-#define FORCEDETH_VERSION		"0.60"
+#define FORCEDETH_VERSION		"0.61"
 #define DRV_NAME			"forcedeth"
 
 #include <linux/module.h>
@@ -5638,6 +5639,7 @@ MODULE_PARM_DESC(dma_64bit, "High DMA is
 MODULE_AUTHOR("Manfred Spraul <manfred@colorfullife.com>");
 MODULE_DESCRIPTION("Reverse Engineered nForce ethernet driver");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(FORCEDETH_VERSION);
 
 MODULE_DEVICE_TABLE(pci, pci_tbl);
 
_

Patches currently in -mm which might be from aabdulla@nvidia.com are

forcedeth-version-bump.patch
