From: akpm@linux-foundation.org
Subject: - rtc-class-driver-for-ppc_md-rtc-functions-fix.patch removed from -mm tree
Date: Thu, 05 Jun 2008 21:00:57 -0700
Message-ID: <200806060400.m5640v1S012241@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750716AbYFFEBS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jun 2008 00:01:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, benh@kernel.crashing.org, david-b@pacbell.net, dwmw2@infradead.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     rtc-class-driver-for-ppc_md-rtc-functions-fix
has been removed from the -mm tree.  Its filename was
     rtc-class-driver-for-ppc_md-rtc-functions-fix.patch

This patch was dropped because it was folded into rtc-class-driver-for-ppc_md-rtc-functions.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-class-driver-for-ppc_md-rtc-functions-fix
From: Andrew Morton <akpm@linux-foundation.org>

Fix Kconfig indenting

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Brownell <david-b@pacbell.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/Kconfig~rtc-class-driver-for-ppc_md-rtc-functions-fix drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-class-driver-for-ppc_md-rtc-functions-fix
+++ a/drivers/rtc/Kconfig
@@ -549,7 +549,7 @@ config RTC_DRV_PPC
        tristate "PowerPC machine dependent RTC support"
        depends on PPC_MERGE
        help
-         The PowerPC kernel has machine-specific functions for accessing
+	 The PowerPC kernel has machine-specific functions for accessing
 	 the RTC. This exposes that functionality through the generic RTC
 	 class.
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

pagemap-fix-bug-in-add_to_pagemap-require-aligned-length-reads-of-proc-pid-pagemap-v2-of-series-checkpatch-fixes.patch
rtc-class-driver-for-ppc_md-rtc-functions.patch
rtc-class-driver-for-ppc_md-rtc-functions-fix.patch
proc-calculate-the-correct-proc-pid-link-count-cleanup.patch

