From: akpm@linux-foundation.org
Subject: [merged] vlynq-fix-typo-in-kconfig-to-enable-debugging.patch removed from -mm tree
Date: Tue, 14 Jul 2009 13:32:34 -0700
Message-ID: <200907142032.n6EKWYMt012106@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756409AbZGNUct (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Jul 2009 16:32:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: florian@openwrt.org, mm-commits@vger.kernel.org


The patch titled
     vlynq: fix typo in Kconfig to enable debugging
has been removed from the -mm tree.  Its filename was
     vlynq-fix-typo-in-kconfig-to-enable-debugging.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vlynq: fix typo in Kconfig to enable debugging
From: Florian Fainelli <florian@openwrt.org>

Fix a typo in the VLYNQ bus driver Kconfig which prevented to turn on
VLYNQ bus debugging.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/vlynq/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/vlynq/Kconfig~vlynq-fix-typo-in-kconfig-to-enable-debugging drivers/vlynq/Kconfig
--- a/drivers/vlynq/Kconfig~vlynq-fix-typo-in-kconfig-to-enable-debugging
+++ a/drivers/vlynq/Kconfig
@@ -13,7 +13,7 @@ config VLYNQ
 
 config VLYNQ_DEBUG
 	bool "VLYNQ bus debug"
-	depends on VLYNQ && KERNEL_DEBUG
+	depends on VLYNQ && DEBUG_KERNEL
 	help
 	  Turn on VLYNQ bus debugging.
 
_

Patches currently in -mm which might be from florian@openwrt.org are

linux-next.patch
sound-core-pcm_timerc-use-lib-gcdc.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch

