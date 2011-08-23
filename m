From: akpm@linux-foundation.org
Subject: + backlight-fix-module-alias-prefix-for-adp8870_bl.patch added to -mm tree
Date: Mon, 22 Aug 2011 22:43:18 -0700
Message-ID: <201108230540.p7N5eK5p029176@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34389 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751094Ab1HWFlD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Aug 2011 01:41:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, michael.hennerich@analog.com, rpurdie@rpsys.net


The patch titled
     backlight: fix module alias prefix for adp8870_bl
has been added to the -mm tree.  Its filename is
     backlight-fix-module-alias-prefix-for-adp8870_bl.patch

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
Subject: backlight: fix module alias prefix for adp8870_bl
From: Axel Lin <axel.lin@gmail.com>

This is a i2c driver, not a platform driver, thus use "i2c" prefix for the
module alias.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Michael Hennerich <michael.hennerich@analog.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/adp8870_bl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/adp8870_bl.c~backlight-fix-module-alias-prefix-for-adp8870_bl drivers/video/backlight/adp8870_bl.c
--- a/drivers/video/backlight/adp8870_bl.c~backlight-fix-module-alias-prefix-for-adp8870_bl
+++ a/drivers/video/backlight/adp8870_bl.c
@@ -1009,4 +1009,4 @@ module_exit(adp8870_exit);
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
 MODULE_DESCRIPTION("ADP8870 Backlight driver");
-MODULE_ALIAS("platform:adp8870-backlight");
+MODULE_ALIAS("i2c:adp8870-backlight");
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
drivers-video-backlight-ep93xx_blc-add-missing-include-of-linux-moduleh.patch
leds-add-missing-include-of-linux-moduleh.patch
backlight-fix-module-alias-prefix-for-adp8870_bl.patch
linux-next.patch
leds-renesas-tpu-led-driver-v2-fix.patch

