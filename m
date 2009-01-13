From: akpm@linux-foundation.org
Subject: + arm-at91-fix-nr_aic_irqs-undeclared.patch added to -mm tree
Date: Mon, 12 Jan 2009 19:48:46 -0800
Message-ID: <200901130348.n0D3mkfm011425@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39084 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752949AbZAMDtQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 22:49:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stf_xl@wp.pl


The patch titled
     ARM/AT91: fix NR_AIC_IRQS undeclared
has been added to the -mm tree.  Its filename is
     arm-at91-fix-nr_aic_irqs-undeclared.patch

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
Subject: ARM/AT91: fix NR_AIC_IRQS undeclared
From: Stanislaw Gruszka <stf_xl@wp.pl>

arch/arm/mach-at91/at91sam9263.c:312: error: 'NR_AIC_IRQS' undeclared here (not in a function)

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-at91/at91sam9263.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/arm/mach-at91/at91sam9263.c~arm-at91-fix-nr_aic_irqs-undeclared arch/arm/mach-at91/at91sam9263.c
--- a/arch/arm/mach-at91/at91sam9263.c~arm-at91-fix-nr_aic_irqs-undeclared
+++ a/arch/arm/mach-at91/at91sam9263.c
@@ -20,6 +20,7 @@
 #include <mach/at91_pmc.h>
 #include <mach/at91_rstc.h>
 #include <mach/at91_shdwc.h>
+#include <mach/irqs.h>
 
 #include "generic.h"
 #include "clock.h"
_

Patches currently in -mm which might be from stf_xl@wp.pl are

atmel_spi-allow-transfer-when-max_speed_hz-=-0.patch
arm-at91-fix-nr_aic_irqs-undeclared.patch

