From: akpm@linux-foundation.org
Subject: + net_sb1250_mac-rename-to-sb1250_mac.patch added to -mm tree
Date: Fri, 14 Sep 2007 19:10:01 -0700
Message-ID: <200709150210.l8F2A1Jm002475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58917 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756971AbXIOCKS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 22:10:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macro@linux-mips.org, jeff@garzik.org, ralf@linux-mips.org


The patch titled
     NET_SB1250_MAC: Rename to SB1250_MAC
has been added to the -mm tree.  Its filename is
     net_sb1250_mac-rename-to-sb1250_mac.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -2153,7 +2153,7 @@ config R8169_VLAN
 	  
 	  If in doubt, say Y.
 
-config NET_SB1250_MAC
+config SB1250_MAC
 	tristate "SB1250 Gigabit Ethernet support"
 	depends on SIBYTE_SB1xxx_SOC
 	---help---
diff -puN drivers/net/Makefile~net_sb1250_mac-rename-to-sb1250_mac drivers/net/Makefile
--- a/drivers/net/Makefile~net_sb1250_mac-rename-to-sb1250_mac
+++ a/drivers/net/Makefile
@@ -106,7 +106,7 @@ obj-$(CONFIG_E2100) += e2100.o 8390.o
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
sb1250-macc-de-typedef-de-volatile-de-etc.patch
sb1250-macc-de-typedef-de-volatile-de-etc-update.patch
net_sb1250_mac-update-kconfig-entry.patch
net_sb1250_mac-rename-to-sb1250_mac.patch
include-linux-typesh-in-if_fddih.patch
avoid-negative-and-full-width-shifts-in-radix-treec.patch
