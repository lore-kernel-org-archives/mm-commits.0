From: akpm@linux-foundation.org
Subject: [merged] smp-fix-documentation-in-include-linux-smph.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:05:58 -0800
Message-ID: <201003091905.o29J5waa031148@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60118 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753603Ab0CITV4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:21:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rakib.mullick@gmail.com, mm-commits@vger.kernel.org


The patch titled
     smp: fix documentation in include/linux/smp.h
has been removed from the -mm tree.  Its filename was
     smp-fix-documentation-in-include-linux-smph.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: smp: fix documentation in include/linux/smp.h
From: Rakib Mullick <rakib.mullick@gmail.com>

	smp: Fix documentation.

Fix documentation in include/linux/smp.h: smp_processor_id()

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smp.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/smp.h~smp-fix-documentation-in-include-linux-smph include/linux/smp.h
--- a/include/linux/smp.h~smp-fix-documentation-in-include-linux-smph
+++ a/include/linux/smp.h
@@ -154,7 +154,7 @@ smp_call_function_any(const struct cpuma
 /*
  * smp_processor_id(): get the current CPU ID.
  *
- * if DEBUG_PREEMPT is enabled the we check whether it is
+ * if DEBUG_PREEMPT is enabled then we check whether it is
  * used in a preemption-safe way. (smp_processor_id() is safe
  * if it's used in a preemption-off critical section, or in
  * a thread that is bound to the current CPU.)
_

Patches currently in -mm which might be from rakib.mullick@gmail.com are

linux-next.patch
acpi-put-acpi_battery_get-set_alarm-into-config_acpi_sysfs_power.patch

