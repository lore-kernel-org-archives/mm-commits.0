From: akpm@linux-foundation.org
Subject: [merged] drivers-leds-leds-lp5523c-remove-unneeded-forward-declaration.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:30:26 -0800
Message-ID: <20120111213026.A05DE10004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:42148 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932728Ab2AKVa1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:30:27 -0500
Received: by mail-yx0-f202.google.com with SMTP id m1so7711yen.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:30:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, rpurdie@rpsys.net, samu.p.onkalo@nokia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/leds/leds-lp5523.c: remove unneeded forward declaration
has been removed from the -mm tree.  Its filename was
     drivers-leds-leds-lp5523c-remove-unneeded-forward-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
