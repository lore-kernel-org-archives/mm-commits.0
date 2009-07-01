From: akpm@linux-foundation.org
Subject: + vlynq-fix-typo-in-kconfig-to-enable-debugging.patch added to -mm tree
Date: Wed, 01 Jul 2009 10:56:21 -0700
Message-ID: <200907011756.n61HuLEP001819@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55801 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752549AbZGAR4d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jul 2009 13:56:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: florian@openwrt.org


The patch titled
     vlynq: fix typo in Kconfig to enable debugging
has been added to the -mm tree.  Its filename is
     vlynq-fix-typo-in-kconfig-to-enable-debugging.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
vlynq-correct-typo-of-missing-config_-prefix-in-ifdef.patch
vlynq-fix-typo-in-kconfig-to-enable-debugging.patch
linux-next.patch
sound-core-pcm_timerc-use-lib-gcdc.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch

