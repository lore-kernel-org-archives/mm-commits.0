From: akpm@linux-foundation.org
Subject: [merged] xtensa-enable-s6gmac-in-s6105_defconfig.patch removed from -mm tree
Date: Tue, 23 Jun 2009 11:05:43 -0700
Message-ID: <200906231805.n5NI5hMA009803@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753507AbZFWSGE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jun 2009 14:06:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dg@emlix.com, chris@zankel.net, davem@davemloft.net, jw@emlix.com, os@emlix.com, mm-commits@vger.kernel.org


The patch titled
     xtensa: enable s6gmac in s6105_defconfig
has been removed from the -mm tree.  Its filename was
     xtensa-enable-s6gmac-in-s6105_defconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xtensa: enable s6gmac in s6105_defconfig
From: Daniel Glockner <dg@emlix.com>

Signed-off-by: Daniel Glockner <dg@emlix.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Johannes Weiner <jw@emlix.com>
Cc: Oskar Schirmer <os@emlix.com>
Cc: Christian Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/configs/s6105_defconfig |   49 +++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

diff -puN arch/xtensa/configs/s6105_defconfig~xtensa-enable-s6gmac-in-s6105_defconfig arch/xtensa/configs/s6105_defconfig
--- a/arch/xtensa/configs/s6105_defconfig~xtensa-enable-s6gmac-in-s6105_defconfig
+++ a/arch/xtensa/configs/s6105_defconfig
@@ -263,7 +263,54 @@ CONFIG_HAVE_IDE=y
 # CONFIG_SCSI_NETLINK is not set
 # CONFIG_ATA is not set
 # CONFIG_MD is not set
-# CONFIG_NETDEVICES is not set
+CONFIG_NETDEVICES=y
+# CONFIG_DUMMY is not set
+# CONFIG_BONDING is not set
+# CONFIG_MACVLAN is not set
+# CONFIG_EQUALIZER is not set
+# CONFIG_TUN is not set
+# CONFIG_VETH is not set
+CONFIG_PHYLIB=y
+
+#
+# MII PHY device drivers
+#
+# CONFIG_MARVELL_PHY is not set
+# CONFIG_DAVICOM_PHY is not set
+# CONFIG_QSEMI_PHY is not set
+# CONFIG_LXT_PHY is not set
+# CONFIG_CICADA_PHY is not set
+# CONFIG_VITESSE_PHY is not set
+CONFIG_SMSC_PHY=y
+# CONFIG_BROADCOM_PHY is not set
+# CONFIG_ICPLUS_PHY is not set
+# CONFIG_REALTEK_PHY is not set
+# CONFIG_NATIONAL_PHY is not set
+# CONFIG_STE10XP is not set
+# CONFIG_LSI_ET1011C_PHY is not set
+# CONFIG_FIXED_PHY is not set
+# CONFIG_MDIO_BITBANG is not set
+# CONFIG_NET_ETHERNET is not set
+CONFIG_NETDEV_1000=y
+CONFIG_S6GMAC=y
+# CONFIG_NETDEV_10000 is not set
+
+#
+# Wireless LAN
+#
+# CONFIG_WLAN_PRE80211 is not set
+# CONFIG_WLAN_80211 is not set
+# CONFIG_IWLWIFI_LEDS is not set
+
+#
+# Enable WiMAX (Networking options) to see the WiMAX drivers
+#
+# CONFIG_WAN is not set
+# CONFIG_PPP is not set
+# CONFIG_SLIP is not set
+# CONFIG_NETCONSOLE is not set
+# CONFIG_NETPOLL is not set
+# CONFIG_NET_POLL_CONTROLLER is not set
 # CONFIG_ISDN is not set
 # CONFIG_PHONE is not set
 
_

Patches currently in -mm which might be from dg@emlix.com are

origin.patch
xtensa-variant-specific-code.patch

