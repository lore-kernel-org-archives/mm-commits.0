From: akpm@linux-foundation.org
Subject: [merged] pm-fix-kernel-doc-notation.patch removed from -mm tree
Date: Mon, 30 Nov 2009 12:33:11 -0800
Message-ID: <200911302033.nAUKXBQV020406@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752057AbZK3UeM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Nov 2009 15:34:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaswinder@kernel.org, jaswinderrajput@gmail.com, pavel@ucw.cz, randy.dunlap@oracle.com, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     pm: fix kernel-doc notation
has been removed from the -mm tree.  Its filename was
     pm-fix-kernel-doc-notation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm: fix kernel-doc notation
From: Jaswinder Singh Rajput <jaswinder@kernel.org>

Fix the following htmldocs warnings:

  Warning(drivers/base/power/main.c:249): No description found for parameter 'master'
  Warning(drivers/base/power/main.c:249): Excess function parameter 'slave' description in 'device_pm_wait_for_slaves'
  Warning(drivers/base/power/main.c:292): No description found for parameter 'master'
  Warning(drivers/base/power/main.c:292): Excess function parameter 'slave' description in 'device_pm_check_slaves'

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/power/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/base/power/main.c~pm-fix-kernel-doc-notation drivers/base/power/main.c
--- a/drivers/base/power/main.c~pm-fix-kernel-doc-notation
+++ a/drivers/base/power/main.c
@@ -243,7 +243,7 @@ static void device_pm_wait_for_masters(s
 
 /**
  * device_pm_wait_for_slaves - Wait for all slaves of given device.
- * @slave: Device to wait for the slaves of.
+ * @master: Device to wait for the slaves of.
  */
 static void device_pm_wait_for_slaves(struct device *master)
 {
@@ -286,7 +286,7 @@ static int device_pm_check_masters(struc
 
 /**
  * device_pm_check_slaves - Check power.op_complete for slaves of a device.
- * @slave: Device to check the slaves of.
+ * @master: Device to check the slaves of.
  */
 static int device_pm_check_slaves(struct device *master)
 {
_

Patches currently in -mm which might be from jaswinder@kernel.org are

linux-next.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
xtensa-includecheck-fix-vectorss.patch
writeback-fix-missing-kernel-doc-notation.patch

