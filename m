From: akpm@linux-foundation.org
Subject: - r8169-fix-regression-on-asus-motherboards.patch removed from -mm tree
Date: Wed, 07 Nov 2007 14:11:57 -0800
Message-ID: <200711072211.lA7MBxYW030471@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50650 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753831AbXKGWM2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Nov 2007 17:12:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lkml@rtr.ca, jeff@garzik.org, mlord@pobox.com, romieu@fr.zoreil.com, mm-commits@vger.kernel.org


The patch titled
     r8169 fix regression on ASUS motherboards
has been removed from the -mm tree.  Its filename was
     r8169-fix-regression-on-asus-motherboards.patch

This patch was dropped because it was nacked

------------------------------------------------------
Subject: r8169 fix regression on ASUS motherboards
From: Mark Lord <lkml@rtr.ca>

Fix r8169 regression on ASUS motherboards.

The r8169 ethernet driver worked fine in 2.6.23, but fails in 2.6.24-rc*
for the onboard ethernet of ASUS P5B series motherboards.  This patch fixes
it again.

Signed-off-by: Mark Lord <mlord@pobox.com>
Cc: Francois Romieu <romieu@fr.zoreil.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/r8169.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/net/r8169.c~r8169-fix-regression-on-asus-motherboards drivers/net/r8169.c
--- a/drivers/net/r8169.c~r8169-fix-regression-on-asus-motherboards
+++ a/drivers/net/r8169.c
@@ -1325,6 +1325,7 @@ static void rtl_hw_phy_config(struct net
 		rtl8169sb_hw_phy_config(ioaddr);
 		break;
 	case RTL_GIGA_MAC_VER_11:
+		break;
 	case RTL_GIGA_MAC_VER_12:
 	case RTL_GIGA_MAC_VER_17:
 		rtl8168b_hw_phy_config(ioaddr);
_

Patches currently in -mm which might be from lkml@rtr.ca are

origin.patch
rtc-dont-write-rtc-century-when-setting-a-wake-alarm.patch
r8169-fix-regression-on-asus-motherboards.patch
