From: akpm@linux-foundation.org
Subject: + notifiers-pm-move-pm-notifiers-into-suspendh-update.patch added to -mm tree
Date: Wed, 29 Jun 2011 15:52:18 -0700
Message-ID: <201106292252.p5TMqI4u017224@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36376 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752595Ab1F2Ww1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jun 2011 18:52:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amwang@redhat.com, davem@davemloft.net, greg@kroah.com, rjw@sisk.pl


The patch titled
     notifiers-pm-move-pm-notifiers-into-suspendh-update
has been added to the -mm tree.  Its filename is
     notifiers-pm-move-pm-notifiers-into-suspendh-update.patch

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

linux-next.patch
notifiers-cpu-move-cpu-notifiers-into-cpuh.patch
notifiers-net-move-netdevice-notifiers-into-netdeviceh.patch
notifiers-sys-move-reboot-notifiers-into-rebooth.patch
notifiers-pm-move-pm-notifiers-into-suspendh.patch
notifiers-pm-move-pm-notifiers-into-suspendh-update.patch
notifiers-vt-move-vt-notifiers-into-vth.patch

