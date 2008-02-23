From: akpm@linux-foundation.org
Subject: - fix-alignment-of-ip-config-output.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:22:15 -0800
Message-ID: <200802232022.m1NKMFCK013407@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:51238 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759485AbYBWU2f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:28:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Uwe.Kleine-Koenig@digi.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     fix alignment of IP-Config output
has been removed from the -mm tree.  Its filename was
     fix-alignment-of-ip-config-output.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix alignment of IP-Config output
From: Uwe Kleine-Koenig <Uwe.Kleine-Koenig@digi.com>

Make the indented lines aligned in the output (not in the code).

Signed-off-by: Uwe Kleine-Koenig <Uwe.Kleine-Koenig@digi.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/ipconfig.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/ipv4/ipconfig.c~fix-alignment-of-ip-config-output net/ipv4/ipconfig.c
--- a/net/ipv4/ipconfig.c~fix-alignment-of-ip-config-output
+++ a/net/ipv4/ipconfig.c
@@ -1390,7 +1390,7 @@ static int __init ip_auto_config(void)
 	 * Clue in the operator.
 	 */
 	printk("IP-Config: Complete:");
-	printk("\n      device=%s", ic_dev->name);
+	printk("\n     device=%s", ic_dev->name);
 	printk(", addr=%u.%u.%u.%u", NIPQUAD(ic_myaddr));
 	printk(", mask=%u.%u.%u.%u", NIPQUAD(ic_netmask));
 	printk(", gw=%u.%u.%u.%u", NIPQUAD(ic_gateway));
_

Patches currently in -mm which might be from Uwe.Kleine-Koenig@digi.com are

origin.patch
