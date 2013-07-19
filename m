From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-pcf2127c-remove-empty-function.patch added to
 -mm tree
Date: Fri, 19 Jul 2013 15:35:14 -0700
Message-ID: <51e9bf22.8zKsLKn0egPO6vbb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52601 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab3GSWfP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Jul 2013 18:35:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sachin.kamat@linaro.org

Subject: + drivers-rtc-rtc-pcf2127c-remove-empty-function.patch added to -mm tree
To: sachin.kamat@linaro.org
From: akpm@linux-foundation.org
Date: Fri, 19 Jul 2013 15:35:14 -0700


The patch titled
     Subject: drivers/rtc/rtc-pcf2127.c: remove empty function
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-pcf2127c-remove-empty-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-pcf2127c-remove-empty-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-pcf2127c-remove-empty-function.patch

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
Subject: drivers/rtc/rtc-pcf2127.c: remove empty function

The 'remove' function is empty and does not do anything.  Delete it.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf2127.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN drivers/rtc/rtc-pcf2127.c~drivers-rtc-rtc-pcf2127c-remove-empty-function drivers/rtc/rtc-pcf2127.c
--- a/drivers/rtc/rtc-pcf2127.c~drivers-rtc-rtc-pcf2127c-remove-empty-function
+++ a/drivers/rtc/rtc-pcf2127.c
@@ -203,11 +203,6 @@ static int pcf2127_probe(struct i2c_clie
 	return 0;
 }
 
-static int pcf2127_remove(struct i2c_client *client)
-{
-	return 0;
-}
