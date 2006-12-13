From: akpm@osdl.org
Subject: - high-res-timers-utilize-tsc-clocksource-again-fix.patch removed from -mm tree
Date: Wed, 13 Dec 2006 14:49:47 -0800
Message-ID: <200612132249.kBDMnldK023177@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53036 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662AbWLMWt6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 17:49:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulmck@linux.vnet.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     high-res-timers-utilize-tsc-clocksource-again fix
has been removed from the -mm tree.  Its filename was
     high-res-timers-utilize-tsc-clocksource-again-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: high-res-timers-utilize-tsc-clocksource-again fix
From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

build fix for NUMAQ.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/acpi_pmtmr.h |    2 ++
 1 files changed, 2 insertions(+)

diff -puN include/linux/acpi_pmtmr.h~high-res-timers-utilize-tsc-clocksource-again-fix include/linux/acpi_pmtmr.h
--- a/include/linux/acpi_pmtmr.h~high-res-timers-utilize-tsc-clocksource-again-fix
+++ a/include/linux/acpi_pmtmr.h
@@ -27,6 +27,8 @@ static inline u32 acpi_pm_read_early(voi
 
 #else
 
+#define pmtmr_ioport 0
+
 static inline u32 acpi_pm_read_early(void)
 {
 	return 0;
_

Patches currently in -mm which might be from paulmck@linux.vnet.ibm.com are

origin.patch

