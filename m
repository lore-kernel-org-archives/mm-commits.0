From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-rtc-ds1742c-remove-redundant-of_match_ptr-helper.patch added to -mm tree
Date: Fri, 03 Jan 2014 16:02:43 -0800
Message-ID: <52c74fa3.8A1vFrmw13A5Rm0y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51798 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191AbaADACo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jan 2014 19:02:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sachin.kamat@linaro.org

Subject: + drivers-rtc-rtc-ds1742c-remove-redundant-of_match_ptr-helper.patch added to -mm tree
To: sachin.kamat@linaro.org
From: akpm@linux-foundation.org
Date: Fri, 03 Jan 2014 16:02:43 -0800


The patch titled
     Subject: drivers/rtc/rtc-ds1742.c: remove redundant of_match_ptr() helper
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-ds1742c-remove-redundant-of_match_ptr-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-ds1742c-remove-redundant-of_match_ptr-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-ds1742c-remove-redundant-of_match_ptr-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-ds1742.c: remove redundant of_match_ptr() helper

'ds1742_rtc_of_match' is always compiled in.  Hence the helper macro is
not needed.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1742.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-ds1742.c~drivers-rtc-rtc-ds1742c-remove-redundant-of_match_ptr-helper drivers/rtc/rtc-ds1742.c
--- a/drivers/rtc/rtc-ds1742.c~drivers-rtc-rtc-ds1742c-remove-redundant-of_match_ptr-helper
+++ a/drivers/rtc/rtc-ds1742.c
@@ -228,7 +228,7 @@ static struct platform_driver ds1742_rtc
 	.driver		= {
 		.name	= "rtc-ds1742",
 		.owner	= THIS_MODULE,
-		.of_match_table = of_match_ptr(ds1742_rtc_of_match),
+		.of_match_table = ds1742_rtc_of_match,
 	},
 };
 
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

drivers-rtc-rtc-ds1742c-remove-redundant-of_match_ptr-helper.patch
drivers-rtc-rtc-hym8563c-remove-redundant-of_match_ptr-helper.patch
drivers-rtc-rtc-hym8563c-staticize-local-symbol.patch
linux-next.patch

