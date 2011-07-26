From: akpm@linux-foundation.org
Subject: [folded] notifiers-pm-move-pm-notifiers-into-suspendh-update.patch removed from -mm tree
Date: Mon, 25 Jul 2011 17:00:39 -0700
Message-ID: <201107260000.p6Q00dtO006504@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47797 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752676Ab1GZAAr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jul 2011 20:00:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amwang@redhat.com, davem@davemloft.net, greg@kroah.com, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     notifiers-pm-move-pm-notifiers-into-suspendh-update
has been removed from the -mm tree.  Its filename was
     notifiers-pm-move-pm-notifiers-into-suspendh-update.patch

This patch was dropped because it was folded into notifiers-pm-move-pm-notifiers-into-suspendh.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: notifiers-pm-move-pm-notifiers-into-suspendh-update
From: Cong Wang <amwang@redhat.com>

Cc: David Miller <davem@davemloft.net>
Acked-by: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/core.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/mmc/core/core.c~notifiers-pm-move-pm-notifiers-into-suspendh-update drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c~notifiers-pm-move-pm-notifiers-into-suspendh-update
+++ a/drivers/mmc/core/core.c
@@ -23,9 +23,7 @@
 #include <linux/log2.h>
 #include <linux/regulator/consumer.h>
 #include <linux/pm_runtime.h>
-#ifdef CONFIG_PM
 #include <linux/suspend.h>
-#endif
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
_

Patches currently in -mm which might be from amwang@redhat.com are

origin.patch
notifiers-cpu-move-cpu-notifiers-into-cpuh.patch
notifiers-net-move-netdevice-notifiers-into-netdeviceh.patch
notifiers-sys-move-reboot-notifiers-into-rebooth.patch
notifiers-pm-move-pm-notifiers-into-suspendh.patch
notifiers-vt-move-vt-notifiers-into-vth.patch

