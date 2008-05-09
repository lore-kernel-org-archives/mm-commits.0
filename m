From: akpm@linux-foundation.org
Subject: - orion-pass-proper-t_clk-into-mv643xx_eth.patch removed from -mm tree
Date: Fri, 09 May 2008 12:59:58 -0700
Message-ID: <200805091959.m49JxwIO023159@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52059 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751934AbYEIUAA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 16:00:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: buytenh@wantstofly.org, buytenh@marvell.com, nico@marvell.com, mm-commits@vger.kernel.org


The patch titled
     arm: orion: pass proper t_clk into mv643xx_eth
has been removed from the -mm tree.  Its filename was
     orion-pass-proper-t_clk-into-mv643xx_eth.patch

This patch was dropped because it's already in git-orion

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arm: orion: pass proper t_clk into mv643xx_eth
From: Lennert Buytenhek <buytenh@wantstofly.org>

Pass the Orion TCLK tick rate into the ethernet driver.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
Signed-off-by: Nicolas Pitre <nico@marvell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-orion5x/common.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/arm/mach-orion5x/common.c~orion-pass-proper-t_clk-into-mv643xx_eth arch/arm/mach-orion5x/common.c
--- a/arch/arm/mach-orion5x/common.c~orion-pass-proper-t_clk-into-mv643xx_eth
+++ a/arch/arm/mach-orion5x/common.c
@@ -192,6 +192,7 @@ static struct platform_device orion5x_eh
 
 struct mv643xx_eth_shared_platform_data orion5x_eth_shared_data = {
 	.dram		= &orion5x_mbus_dram_info,
+	.t_clk		= ORION5X_TCLK,
 };
 
 static struct resource orion5x_eth_shared_resources[] = {
_

Patches currently in -mm which might be from buytenh@wantstofly.org are

orion-pass-proper-t_clk-into-mv643xx_eth.patch
orion-clean-up-addr-mapc-after-window-setting-code-purge.patch
leds-add-pca9532-platform-data-for-thecus-n2100.patch
git-orion.patch

