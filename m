From: akpm@linux-foundation.org
Subject: - clean-up-redundant-phy-write-line-for-uli526x-ethernet.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:57:45 -0700
Message-ID: <200710051957.l95Jvj1Q022499@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49126 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763528AbXJEUB2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 16:01:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tie-fei.zang@freescale.com, grundler@parisc-linux.org, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     Clean up redundant PHY write line for ULi526x Ethernet driver
has been removed from the -mm tree.  Its filename was
     clean-up-redundant-phy-write-line-for-uli526x-ethernet.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Clean up redundant PHY write line for ULi526x Ethernet driver
From: Roy Zang <tie-fei.zang@freescale.com>

Clean up redundant PHY write line for ULi526x Ethernet Driver.

Signed-off-by: Roy Zang <tie-fei.zang@freescale.com>
Cc: Jeff Garzik <jeff@garzik.org>
Acked-by: Grant Grundler <grundler@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tulip/uli526x.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/net/tulip/uli526x.c~clean-up-redundant-phy-write-line-for-uli526x-ethernet drivers/net/tulip/uli526x.c
--- a/drivers/net/tulip/uli526x.c~clean-up-redundant-phy-write-line-for-uli526x-ethernet
+++ a/drivers/net/tulip/uli526x.c
@@ -1599,7 +1599,6 @@ static void uli526x_process_mode(struct 
 			case ULI526X_100MFD: phy_reg = 0x2100; break;
 			}
 			phy_write(db->ioaddr, db->phy_addr, 0, phy_reg, db->chip_id);
-       			phy_write(db->ioaddr, db->phy_addr, 0, phy_reg, db->chip_id);
 		}
 	}
 }
_

Patches currently in -mm which might be from tie-fei.zang@freescale.com are

git-net.patch
