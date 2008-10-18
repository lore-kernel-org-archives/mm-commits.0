From: akpm@linux-foundation.org
Subject: - rtc-use-config_ppc-instead-of-config_ppc_merge.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:15:35 -0700
Message-ID: <200810182315.m9INFZlk028647@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39616 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751815AbYJRXPv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:15:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: galak@kernel.crashing.org, a.zummo@towertech.it, benh@kernel.crashing.org, david-b@pacbell.net, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     rtc: use CONFIG_PPC instead of CONFIG_PPC_MERGE
has been removed from the -mm tree.  Its filename was
     rtc-use-config_ppc-instead-of-config_ppc_merge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: use CONFIG_PPC instead of CONFIG_PPC_MERGE
From: Kumar Gala <galak@kernel.crashing.org>

Now that arch/ppc is dead CONFIG_PPC_MERGE is always defined for all
powerpc platforms and we want to get rid of it use CONFIG_PPC instead.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/Kconfig~rtc-use-config_ppc-instead-of-config_ppc_merge drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-use-config_ppc-instead-of-config_ppc_merge
+++ a/drivers/rtc/Kconfig
@@ -612,7 +612,7 @@ config RTC_DRV_RS5C313
 
 config RTC_DRV_PPC
        tristate "PowerPC machine dependent RTC support"
-       depends on PPC_MERGE
+       depends on PPC
        help
 	 The PowerPC kernel has machine-specific functions for accessing
 	 the RTC. This exposes that functionality through the generic RTC
_

Patches currently in -mm which might be from galak@kernel.crashing.org are

origin.patch

