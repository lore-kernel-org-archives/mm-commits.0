From: akpm@linux-foundation.org
Subject: - regulator-include-suspendh-in-machineh-for-suspend_state_t.patch removed from -mm tree
Date: Mon, 14 Jul 2008 12:35:54 -0700
Message-ID: <200807141935.m6EJZsNl023968@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60779 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756892AbYGNTf7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jul 2008 15:35:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: philipp.zabel@gmail.com, lg@opensource.wolfsonmicro.com, mm-commits@vger.kernel.org


The patch titled
     regulator: include suspend.h in machine.h for suspend_state_t
has been removed from the -mm tree.  Its filename was
     regulator-include-suspendh-in-machineh-for-suspend_state_t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

