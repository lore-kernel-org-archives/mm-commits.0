From: akpm@linux-foundation.org
Subject: [obsolete] arm-at91-fix-nr_aic_irqs-undeclared.patch removed from -mm tree
Date: Thu, 12 Feb 2009 00:27:22 -0800
Message-ID: <200902120827.n1C8RNPF013236@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59733 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750968AbZBLI1Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Feb 2009 03:27:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stf_xl@wp.pl, mm-commits@vger.kernel.org


The patch titled
     ARM/AT91: fix NR_AIC_IRQS undeclared
has been removed from the -mm tree.  Its filename was
     arm-at91-fix-nr_aic_irqs-undeclared.patch

This patch was dropped because it is obsolete

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

arm-at91-fix-nr_aic_irqs-undeclared.patch

