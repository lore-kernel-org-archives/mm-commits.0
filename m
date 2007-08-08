From: akpm@linux-foundation.org
Subject: - remove-get_perm_addr-from-ucc_geth_ethtoolc.patch removed from -mm tree
Date: Wed, 08 Aug 2007 12:07:52 -0700
Message-ID: <200708081907.l78J7q6a025801@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42299 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937449AbXHHTI7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Aug 2007 15:08:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.altenberg@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     remove get_perm_addr from ucc_geth_ethtool.c
has been removed from the -mm tree.  Its filename was
     remove-get_perm_addr-from-ucc_geth_ethtoolc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: remove get_perm_addr from ucc_geth_ethtool.c
From: Jan Altenberg <jan.altenberg@linutronix.de>

This is needed because commit 313674afa8fdced2fe79f50f38e1c387b63d8790
inlines the generic function to the caller.

Signed-off-by: Jan Altenberg <jan.altenberg@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ucc_geth_ethtool.c |    1 -
 1 files changed, 1 deletion(-)

diff -puN drivers/net/ucc_geth_ethtool.c~remove-get_perm_addr-from-ucc_geth_ethtoolc drivers/net/ucc_geth_ethtool.c
--- a/drivers/net/ucc_geth_ethtool.c~remove-get_perm_addr-from-ucc_geth_ethtoolc
+++ a/drivers/net/ucc_geth_ethtool.c
@@ -379,7 +379,6 @@ static const struct ethtool_ops uec_etht
 	.get_stats_count        = uec_get_stats_count,
 	.get_strings            = uec_get_strings,
 	.get_ethtool_stats      = uec_get_ethtool_stats,
-	.get_perm_addr          = ethtool_op_get_perm_addr,
 };
 
 void uec_set_ethtool_ops(struct net_device *netdev)
_

Patches currently in -mm which might be from jan.altenberg@linutronix.de are

origin.patch
at91-remove-at91_lcdch.patch
git-netdev-all.patch
