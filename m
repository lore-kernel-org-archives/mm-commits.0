From: akpm@linux-foundation.org
Subject: + regulator-include-suspendh-in-machineh-for-suspend_state_t.patch added to -mm tree
Date: Sat, 12 Jul 2008 18:48:30 -0700
Message-ID: <200807130148.m6D1mUsv031292@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40553 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752653AbYGMBsh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 Jul 2008 21:48:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: philipp.zabel@gmail.com, lg@opensource.wolfsonmicro.com


The patch titled
     regulator: include suspend.h in machine.h for suspend_state_t
has been added to the -mm tree.  Its filename is
     regulator-include-suspendh-in-machineh-for-suspend_state_t.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: regulator: include suspend.h in machine.h for suspend_state_t
From: Philipp Zabel <philipp.zabel@gmail.com>

linux/regulator/machine.h shouldn't depend on files including this
header to have included linux/suspend.h before.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Cc: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/regulator/machine.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/regulator/machine.h~regulator-include-suspendh-in-machineh-for-suspend_state_t include/linux/regulator/machine.h
--- a/include/linux/regulator/machine.h~regulator-include-suspendh-in-machineh-for-suspend_state_t
+++ a/include/linux/regulator/machine.h
@@ -16,6 +16,7 @@
 #define __LINUX_REGULATOR_MACHINE_H_
 
 #include <linux/regulator/consumer.h>
+#include <linux/suspend.h>
 
 struct regulator;
 
_

Patches currently in -mm which might be from philipp.zabel@gmail.com are

origin.patch
linux-next.patch
regulator-ti-bq24022-li-ion-charger-driver.patch
regulator-ti-bq24022-li-ion-charger-driver-fix.patch
regulator-virtual-consumer-current-limit-support.patch
regulator-include-suspendh-in-machineh-for-suspend_state_t.patch

