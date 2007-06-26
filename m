From: akpm@linux-foundation.org
Subject: + clockevents-fix-typo-in-acpi_pmc.patch added to -mm tree
Date: Mon, 25 Jun 2007 17:07:24 -0700
Message-ID: <200706260007.l5Q07Osg014403@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41641 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752357AbXFZAHh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 20:07:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: abogani@texware.it, johnstul@us.ibm.com


The patch titled
     clockevents: fix typo in acpi_pm.c
has been added to the -mm tree.  Its filename is
     clockevents-fix-typo-in-acpi_pmc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
+	.mult		= 0, /*to be calculated*/
 	.shift		= 22,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 
_

Patches currently in -mm which might be from abogani@texware.it are

clockevents-fix-typo-in-acpi_pmc.patch
