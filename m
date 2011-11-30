From: akpm@linux-foundation.org
Subject: + drivers-leds-leds-lp5523c-remove-unneeded-forward-declaration.patch added to -mm tree
Date: Wed, 30 Nov 2011 15:48:34 -0800
Message-ID: <201111302348.pAUNmYZD022610@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vw0-f74.google.com ([209.85.212.74]:37331 "EHLO
	mail-vw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab1K3Xsg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2011 18:48:36 -0500
Received: by vbbez10 with SMTP id ez10so145117vbb.1
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2011 15:48:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, rpurdie@rpsys.net, samu.p.onkalo@nokia.com


The patch titled
     Subject: drivers/leds/leds-lp5523.c: remove unneeded forward declaration
has been added to the -mm tree.  Its filename is
     drivers-leds-leds-lp5523c-remove-unneeded-forward-declaration.patch

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
From: Axel Lin <axel.lin@gmail.com>
Subject: drivers/leds/leds-lp5523.c: remove unneeded forward declaration

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lp5523.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/leds/leds-lp5523.c~drivers-leds-leds-lp5523c-remove-unneeded-forward-declaration drivers/leds/leds-lp5523.c
--- a/drivers/leds/leds-lp5523.c~drivers-leds-leds-lp5523c-remove-unneeded-forward-declaration
+++ a/drivers/leds/leds-lp5523.c
@@ -870,8 +870,6 @@ static int __devinit lp5523_init_led(str
 	return 0;
 }
 
-static struct i2c_driver lp5523_driver;
