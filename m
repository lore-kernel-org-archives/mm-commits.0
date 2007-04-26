From: akpm@linux-foundation.org
Subject: - clocksource-acpi_pm-trivial-comment-update.patch removed from -mm tree
Date: Wed, 25 Apr 2007 23:59:26 -0700
Message-ID: <200704260659.l3Q6xQD5023139@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52166 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933208AbXDZG7f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Apr 2007 02:59:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, mm-commits@vger.kernel.org


The patch titled
     clocksource: acpi_pm trivial comment update
has been removed from the -mm tree.  Its filename was
     clocksource-acpi_pm-trivial-comment-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: clocksource: acpi_pm trivial comment update
From: Daniel Walker <dwalker@mvista.com>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clocksource/acpi_pm.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/clocksource/acpi_pm.c~clocksource-acpi_pm-trivial-comment-update drivers/clocksource/acpi_pm.c
--- a/drivers/clocksource/acpi_pm.c~clocksource-acpi_pm-trivial-comment-update
+++ a/drivers/clocksource/acpi_pm.c
@@ -26,7 +26,7 @@
 /*
  * The I/O port the PMTMR resides at.
  * The location is detected during setup_arch(),
- * in arch/i386/acpi/boot.c
+ * in arch/i386/kernel/acpi/boot.c
  */
 u32 pmtmr_ioport __read_mostly;
 
_

Patches currently in -mm which might be from dwalker@mvista.com are

git-acpi.patch
i386-tsc-remove-xtime_locking-around-cpufreq-notifier.patch
sched-consolidate-sched_clock-drift-adjustments.patch
sched-consolidate-sched_clock-drift-adjustments-fix.patch
slim-make-and-config-stuff.patch
profile-likely-unlikely-macros.patch
