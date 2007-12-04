From: akpm@linux-foundation.org
Subject: - r6040-erroneous-dev-priv.patch removed from -mm tree
Date: Mon, 03 Dec 2007 23:38:36 -0800
Message-ID: <200712040738.lB47ca2j006914@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46000 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751695AbXLDHtL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 02:49:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: romieu@fr.zoreil.com, mm-commits@vger.kernel.org


The patch titled
     r6040: erroneous dev->priv
has been removed from the -mm tree.  Its filename was
     r6040-erroneous-dev-priv.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: r6040: erroneous dev->priv
From: Francois Romieu <romieu@fr.zoreil.com>

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/r6040.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/r6040.c~r6040-erroneous-dev-priv drivers/net/r6040.c
--- a/drivers/net/r6040.c~r6040-erroneous-dev-priv
+++ a/drivers/net/r6040.c
@@ -674,7 +674,7 @@ static void r6040_up(struct net_device *
 static void r6040_timer(unsigned long data)
 {
 	struct net_device *dev = (struct net_device *)data;
-	struct r6040_private *lp = netdev_priv(dev->priv);
+	struct r6040_private *lp = netdev_priv(dev);
 	void __iomem *ioaddr = lp->base;
 	u16 phy_mode;
 
_

Patches currently in -mm which might be from romieu@fr.zoreil.com are

git-netdev-all.patch
