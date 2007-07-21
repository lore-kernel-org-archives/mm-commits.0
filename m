From: akpm@linux-foundation.org
Subject: - rtc-add-support-for-stk17ta8-chip-fix.patch removed from -mm tree
Date: Sat, 21 Jul 2007 04:35:36 -0700
Message-ID: <200707211135.l6LBZarp014267@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40378 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761853AbXGULfz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 21 Jul 2007 07:35:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, david-b@pacbell.net, thomas.hommel@gefanuc.com, mm-commits@vger.kernel.org


The patch titled
     rtc-add-support-for-stk17ta8-chip-fix
has been removed from the -mm tree.  Its filename was
     rtc-add-support-for-stk17ta8-chip-fix.patch

This patch was dropped because it was folded into rtc-add-support-for-stk17ta8-chip.patch

------------------------------------------------------
Subject: rtc-add-support-for-stk17ta8-chip-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Cc: Thomas Hommel <thomas.hommel@gefanuc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-stk17ta8.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-stk17ta8.c~rtc-add-support-for-stk17ta8-chip-fix drivers/rtc/rtc-stk17ta8.c
--- a/drivers/rtc/rtc-stk17ta8.c~rtc-add-support-for-stk17ta8-chip-fix
+++ a/drivers/rtc/rtc-stk17ta8.c
@@ -303,7 +303,7 @@ static int __init stk17ta8_rtc_probe(str
 	struct resource *res;
 	unsigned int cal;
 	unsigned int flags;
-	struct rtc_plat_data *pdata = NULL;
+	struct rtc_plat_data *pdata;
 	void __iomem *ioaddr = NULL;
 	int ret = 0;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-pie-randomization.patch
clockevents-fix-resume-logic.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
rtc-add-support-for-stk17ta8-chip.patch
rtc-add-support-for-stk17ta8-chip-fix.patch
