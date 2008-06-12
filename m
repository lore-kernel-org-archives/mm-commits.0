From: akpm@linux-foundation.org
Subject: - fec_mpc52xx-mpc52xx_messages_default-2nd-netif_msg_ifdown-=-ifup.patch removed from -mm tree
Date: Thu, 12 Jun 2008 13:37:05 -0700
Message-ID: <200806122037.m5CKb53B005401@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755798AbYFLUhP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 16:37:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, grant.likely@secretlab.ca, tnt@246tNt.com, mm-commits@vger.kernel.org


The patch titled
     fec_mpc52xx: MPC52xx_MESSAGES_DEFAULT: 2nd NETIF_MSG_IFDOWN => IFUP
has been removed from the -mm tree.  Its filename was
     fec_mpc52xx-mpc52xx_messages_default-2nd-netif_msg_ifdown-=-ifup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fec_mpc52xx: MPC52xx_MESSAGES_DEFAULT: 2nd NETIF_MSG_IFDOWN => IFUP
From: Roel Kluin <roel.kluin@gmail.com>

Duplicate NETIF_MSG_IFDOWN, 2nd should be NETIF_MSG_IFUP

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Sylvain Munaut <tnt@246tNt.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/fec_mpc52xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/fec_mpc52xx.c~fec_mpc52xx-mpc52xx_messages_default-2nd-netif_msg_ifdown-=-ifup drivers/net/fec_mpc52xx.c
--- a/drivers/net/fec_mpc52xx.c~fec_mpc52xx-mpc52xx_messages_default-2nd-netif_msg_ifdown-=-ifup
+++ a/drivers/net/fec_mpc52xx.c
@@ -78,7 +78,7 @@ module_param_array_named(mac, mpc52xx_fe
 MODULE_PARM_DESC(mac, "six hex digits, ie. 0x1,0x2,0xc0,0x01,0xba,0xbe");
 
 #define MPC52xx_MESSAGES_DEFAULT ( NETIF_MSG_DRV | NETIF_MSG_PROBE | \
-		NETIF_MSG_LINK | NETIF_MSG_IFDOWN | NETIF_MSG_IFDOWN )
+		NETIF_MSG_LINK | NETIF_MSG_IFDOWN | NETIF_MSG_IFUP)
 static int debug = -1;	/* the above default */
 module_param(debug, int, 0);
 MODULE_PARM_DESC(debug, "debugging messages level");
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

git-net.patch

