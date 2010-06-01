From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-pcf8563c-remove-unused-struct.patch added to -mm tree
Date: Tue, 01 Jun 2010 16:47:48 -0700
Message-ID: <201006012347.o51NlmxB025917@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57064 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754605Ab0FAXs4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jun 2010 19:48:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: graham.gower@gmail.com, a.zummo@towertech.it, mcuos.com@gmail.com


The patch titled
     drivers/rtc/rtc-pcf8563.c: remove unused struct
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-pcf8563c-remove-unused-struct.patch

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
Subject: drivers/rtc/rtc-pcf8563.c: remove unused struct
From: Graham Gower <graham.gower@gmail.com>

Signed-off-by: Graham Gower <graham.gower@gmail.com>
Acked-by: Wan ZongShun <mcuos.com@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8563.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN drivers/rtc/rtc-pcf8563.c~drivers-rtc-rtc-pcf8563c-remove-unused-struct drivers/rtc/rtc-pcf8563.c
--- a/drivers/rtc/rtc-pcf8563.c~drivers-rtc-rtc-pcf8563c-remove-unused-struct
+++ a/drivers/rtc/rtc-pcf8563.c
@@ -172,14 +172,6 @@ static int pcf8563_set_datetime(struct i
 	return 0;
 }
 
-struct pcf8563_limit
-{
-	unsigned char reg;
-	unsigned char mask;
-	unsigned char min;
-	unsigned char max;
-};
