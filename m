From: akpm@linux-foundation.org
Subject: + pm-fix-kernel-doc-notation.patch added to -mm tree
Date: Tue, 24 Nov 2009 12:34:32 -0800
Message-ID: <200911242034.nAOKYWGC009004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932833AbZKXUfv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Nov 2009 15:35:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaswinder@kernel.org, jaswinderrajput@gmail.com, pavel@ucw.cz, randy.dunlap@oracle.com, rjw@sisk.pl


The patch titled
     pm: fix kernel-doc notation
has been added to the -mm tree.  Its filename is
     pm-fix-kernel-doc-notation.patch

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
kernel-core-add-smp_call_function_any.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
xtensa-includecheck-fix-vectorss.patch
mm-includecheck-fix-slqb.patch
pm-fix-kernel-doc-notation.patch

