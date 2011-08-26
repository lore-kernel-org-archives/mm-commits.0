From: akpm@linux-foundation.org
Subject: [merged] backlight-fix-module-alias-prefix-for-adp8870_bl.patch removed from -mm tree
Date: Fri, 26 Aug 2011 12:06:55 -0700
Message-ID: <201108261903.p7QJ3d8I005710@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753302Ab1HZTET (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Aug 2011 15:04:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, michael.hennerich@analog.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     backlight: fix module alias prefix for adp8870_bl
has been removed from the -mm tree.  Its filename was
     backlight-fix-module-alias-prefix-for-adp8870_bl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: backlight: fix module alias prefix for adp8870_bl
From: Axel Lin <axel.lin@gmail.com>

This is a i2c driver, not a platform driver, thus use "i2c" prefix for the
module alias.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
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
linux-next.patch
leds-renesas-tpu-led-driver-v2-fix.patch

