From: akpm@linux-foundation.org
Subject: - rtc-ds1511-fix-sparse-warning.patch removed from -mm tree
Date: Mon, 01 Dec 2008 11:49:36 -0800
Message-ID: <200812011949.mB1JnarA025346@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37577 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753163AbYLATxR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Dec 2008 14:53:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@hanneseder.net, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     rtc-ds1511: fix sparse warning
has been removed from the -mm tree.  Its filename was
     rtc-ds1511-fix-sparse-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-ds1511: fix sparse warning
From: Hannes Eder <hannes@hanneseder.net>

Fix this sparse warning:

  drivers/rtc/rtc-ds1511.c:634:2: warning: returning void-valued expression

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1511.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-ds1511.c~rtc-ds1511-fix-sparse-warning drivers/rtc/rtc-ds1511.c
--- a/drivers/rtc/rtc-ds1511.c~rtc-ds1511-fix-sparse-warning
+++ a/drivers/rtc/rtc-ds1511.c
@@ -630,7 +630,7 @@ ds1511_rtc_init(void)
  static void __exit
 ds1511_rtc_exit(void)
 {
-	return platform_driver_unregister(&ds1511_rtc_driver);
+	platform_driver_unregister(&ds1511_rtc_driver);
 }
 
 module_init(ds1511_rtc_init);
_

Patches currently in -mm which might be from hannes@hanneseder.net are

origin.patch
linux-next.patch
hugetlb-fix-sparse-warnings.patch
nvidia-fix-sparse-warnings.patch
viafb-fix-sparse-warnings.patch
pm3fb-fix-sparse-warning.patch
neofb-fix-sparse-warnings.patch
i810-fix-sparse-warnings.patch
intelfb-fix-sparse-warnings.patch

