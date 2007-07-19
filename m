From: akpm@linux-foundation.org
Subject: - clockevents-fix-typo-in-acpi_pmc.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:10:31 -0700
Message-ID: <200707192010.l6JKAVmg020680@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57174 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757833AbXGSUPW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: abogani@texware.it, johnstul@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     clockevents: fix typo in acpi_pm.c
has been removed from the -mm tree.  Its filename was
     clockevents-fix-typo-in-acpi_pmc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: clockevents: fix typo in acpi_pm.c
From: Alessio Igor Bogani <abogani@texware.it>

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clocksource/acpi_pm.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/clocksource/acpi_pm.c~clockevents-fix-typo-in-acpi_pmc drivers/clocksource/acpi_pm.c
--- a/drivers/clocksource/acpi_pm.c~clockevents-fix-typo-in-acpi_pmc
+++ a/drivers/clocksource/acpi_pm.c
@@ -71,7 +71,7 @@ static struct clocksource clocksource_ac
 	.rating		= 200,
 	.read		= acpi_pm_read,
 	.mask		= (cycle_t)ACPI_PM_MASK,
-	.mult		= 0, /*to be caluclated*/
+	.mult		= 0, /* to be calculated */
 	.shift		= 22,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 
_

Patches currently in -mm which might be from abogani@texware.it are
