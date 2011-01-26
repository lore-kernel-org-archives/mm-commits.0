From: akpm@linux-foundation.org
Subject: [merged] pps-ktimer-remove-noisy-message.patch removed from -mm tree
Date: Wed, 26 Jan 2011 12:32:30 -0800
Message-ID: <201101262032.p0QKWULA003188@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47192 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754052Ab1AZUct (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Jan 2011 15:32:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: giometti@linux.it, lasaine@lvk.cs.msu.su, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     pps ktimer: remove noisy message
has been removed from the -mm tree.  Its filename was
     pps-ktimer-remove-noisy-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pps ktimer: remove noisy message
From: Rodolfo Giometti <giometti@linux.it>

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/clients/pps-ktimer.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/pps/clients/pps-ktimer.c~pps-ktimer-remove-noisy-message drivers/pps/clients/pps-ktimer.c
--- a/drivers/pps/clients/pps-ktimer.c~pps-ktimer-remove-noisy-message
+++ a/drivers/pps/clients/pps-ktimer.c
@@ -46,8 +46,6 @@ static void pps_ktimer_event(unsigned lo
 	/* First of all we get the time stamp... */
 	pps_get_ts(&ts);
 
-	dev_info(pps->dev, "PPS event at %lu\n", jiffies);
