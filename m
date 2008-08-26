From: akpm@linux-foundation.org
Subject: + rtc-use-config_ppc-instead-of-config_ppc_merge.patch added to -mm tree
Date: Tue, 26 Aug 2008 14:16:41 -0700
Message-ID: <200808262116.m7QLGfNn028097@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751652AbYHZVRe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 17:17:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: galak@kernel.crashing.org, a.zummo@towertech.it, benh@kernel.crashing.org, david-b@pacbell.net, paulus@samba.org


The patch titled
     rtc: use CONFIG_PPC instead of CONFIG_PPC_MERGE
has been added to the -mm tree.  Its filename is
     rtc-use-config_ppc-instead-of-config_ppc_merge.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -589,7 +589,7 @@ config RTC_DRV_RS5C313
 
 config RTC_DRV_PPC
        tristate "PowerPC machine dependent RTC support"
-       depends on PPC_MERGE
+       depends on PPC
        help
 	 The PowerPC kernel has machine-specific functions for accessing
 	 the RTC. This exposes that functionality through the generic RTC
_

Patches currently in -mm which might be from galak@kernel.crashing.org are

linux-next.patch
usb-remove-code-associated-with-config_ppc_merge.patch
fs-enet-remove-code-associated-with-config_ppc_merge.patch
netdev-drop-config_ppc_merge-from-kconfig.patch
rtc-use-config_ppc-instead-of-config_ppc_merge.patch
serial-mpc52xx_uart-remove-code-associated-with-config_ppc_merge.patch
mpc52xx_psc_spi-remove-code-associated-with-config_ppc_merge.patch
powerpc-convert-config_ppc_merge-to-config_ppc-for-legacy-io-checks.patch
pata_sil680-convert-config_ppc_merge-to-config_ppc.patch

