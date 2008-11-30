From: akpm@linux-foundation.org
Subject: + rtc-stk17ta8-fix-sparse-warning.patch added to -mm tree
Date: Sat, 29 Nov 2008 19:32:01 -0800
Message-ID: <200811300332.mAU3W1IM019989@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46801 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753924AbYK3DcK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 29 Nov 2008 22:32:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@hanneseder.net, a.zummo@towertech.it


The patch titled
     rtc-stk17ta8: fix sparse warning
has been added to the -mm tree.  Its filename is
     rtc-stk17ta8-fix-sparse-warning.patch

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
Subject: rtc-stk17ta8: fix sparse warning
From: Hannes Eder <hannes@hanneseder.net>

Fix this sparse warning:

  drivers/rtc/rtc-stk17ta8.c:403:2: warning: returning void-valued expression

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-stk17ta8.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-stk17ta8.c~rtc-stk17ta8-fix-sparse-warning drivers/rtc/rtc-stk17ta8.c
--- a/drivers/rtc/rtc-stk17ta8.c~rtc-stk17ta8-fix-sparse-warning
+++ a/drivers/rtc/rtc-stk17ta8.c
@@ -399,7 +399,7 @@ static __init int stk17ta8_init(void)
 
 static __exit void stk17ta8_exit(void)
 {
-	return platform_driver_unregister(&stk17ta8_rtc_driver);
+	platform_driver_unregister(&stk17ta8_rtc_driver);
 }
 
 module_init(stk17ta8_init);
_

Patches currently in -mm which might be from hannes@hanneseder.net are

linux-next.patch
hugetlb-fix-sparse-warnings.patch
rtc-ds1511-fix-sparse-warning.patch
rtc-stk17ta8-fix-sparse-warning.patch

