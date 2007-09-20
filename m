From: akpm@linux-foundation.org
Subject: - net_sb1250_mac-rename-to-sb1250_mac.patch removed from -mm tree
Date: Thu, 20 Sep 2007 13:56:39 -0700
Message-ID: <200709202056.l8KKudWI002117@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58219 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751000AbXITU5W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 16:57:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, jeff@garzik.org, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     NET_SB1250_MAC: Rename to SB1250_MAC
has been removed from the -mm tree.  Its filename was
     net_sb1250_mac-rename-to-sb1250_mac.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: NET_SB1250_MAC: Rename to SB1250_MAC
From: "Maciej W. Rozycki" <macro@linux-mips.org>

Rename NET_SB1250_MAC to SB1250_MAC to follow the convention.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/configs/bigsur_defconfig       |    2 +-
 arch/mips/configs/sb1250-swarm_defconfig |    2 +-
 drivers/net/Kconfig                      |    2 +-
 drivers/net/Makefile                     |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/mips/configs/bigsur_defconfig~net_sb1250_mac-rename-to-sb1250_mac arch/mips/configs/bigsur_defconfig
--- a/arch/mips/configs/bigsur_defconfig~net_sb1250_mac-rename-to-sb1250_mac
+++ a/arch/mips/configs/bigsur_defconfig
@@ -574,7 +574,7 @@ CONFIG_MII=y
 # CONFIG_HAMACHI is not set
 # CONFIG_YELLOWFIN is not set
 # CONFIG_R8169 is not set
-CONFIG_NET_SB1250_MAC=y
+CONFIG_SB1250_MAC=y
 # CONFIG_SIS190 is not set
 # CONFIG_SKGE is not set
 # CONFIG_SKY2 is not set
diff -puN arch/mips/configs/sb1250-swarm_defconfig~net_sb1250_mac-rename-to-sb1250_mac arch/mips/configs/sb1250-swarm_defconfig
--- a/arch/mips/configs/sb1250-swarm_defconfig~net_sb1250_mac-rename-to-sb1250_mac
+++ a/arch/mips/configs/sb1250-swarm_defconfig
@@ -566,7 +566,7 @@ CONFIG_MII=y
 # CONFIG_HAMACHI is not set
 # CONFIG_YELLOWFIN is not set
 # CONFIG_R8169 is not set
-CONFIG_NET_SB1250_MAC=y
+CONFIG_SB1250_MAC=y
 # CONFIG_SIS190 is not set
 # CONFIG_SKGE is not set
 # CONFIG_SKY2 is not set
diff -puN drivers/net/Kconfig~net_sb1250_mac-rename-to-sb1250_mac drivers/net/Kconfig
--- a/drivers/net/Kconfig~net_sb1250_mac-rename-to-sb1250_mac
+++ a/drivers/net/Kconfig
@@ -2160,7 +2160,7 @@ config R8169_VLAN
 	  
 	  If in doubt, say Y.
 
-config NET_SB1250_MAC
+config SB1250_MAC
 	tristate "SB1250 Gigabit Ethernet support"
 	depends on SIBYTE_SB1xxx_SOC
 	---help---
diff -puN drivers/net/Makefile~net_sb1250_mac-rename-to-sb1250_mac drivers/net/Makefile
--- a/drivers/net/Makefile~net_sb1250_mac-rename-to-sb1250_mac
+++ a/drivers/net/Makefile
@@ -108,7 +108,7 @@ obj-$(CONFIG_E2100) += e2100.o 8390.o
 obj-$(CONFIG_ES3210) += es3210.o 8390.o
 obj-$(CONFIG_LNE390) += lne390.o 8390.o
 obj-$(CONFIG_NE3210) += ne3210.o 8390.o
-obj-$(CONFIG_NET_SB1250_MAC) += sb1250-mac.o
+obj-$(CONFIG_SB1250_MAC) += sb1250-mac.o
 obj-$(CONFIG_B44) += b44.o
 obj-$(CONFIG_FORCEDETH) += forcedeth.o
 obj-$(CONFIG_NE_H8300) += ne-h8300.o
_

Patches currently in -mm which might be from macro@linux-mips.org are

git-mips.patch
git-net.patch
net_sb1250_mac-rename-to-sb1250_mac.patch
phylib-spinlock-fixes-for-softirqs.patch
include-linux-typesh-in-if_fddih.patch
avoid-negative-and-full-width-shifts-in-radix-treec.patch
lk201-remove-obsolete-driver.patch
drivers-video-kconfig-fix-fb_pmagb_b-dependencies.patch
drivers-video-pmag-ba-fbc-improve-diagnostics.patch
drivers-video-pmag-ba-fbc-improve-diagnostics-fix.patch
