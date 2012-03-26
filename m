From: akpm@linux-foundation.org
Subject: [merged] drivers-leds-leds-lp5521c-fix-typo.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:29:24 -0700
Message-ID: <20120326192924.408E9A0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:62277 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab2CZT3Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:29:25 -0400
Received: by vbnl22 with SMTP id l22so508090vbn.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:29:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: standby24x7@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/leds/leds-lp5521.c: fix typo
has been removed from the -mm tree.  Its filename was
     drivers-leds-leds-lp5521c-fix-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Masanari Iida <standby24x7@gmail.com>
Subject: drivers/leds/leds-lp5521.c: fix typo

"reseting" -> "resetting"

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lp5521.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/leds/leds-lp5521.c~drivers-leds-leds-lp5521c-fix-typo drivers/leds/leds-lp5521.c
--- a/drivers/leds/leds-lp5521.c~drivers-leds-leds-lp5521c-fix-typo
+++ a/drivers/leds/leds-lp5521.c
@@ -694,7 +694,7 @@ static int __devinit lp5521_probe(struct
 	 */
 	lp5521_read(client, LP5521_REG_R_CURRENT, &buf);
 	if (buf != LP5521_REG_R_CURR_DEFAULT) {
-		dev_err(&client->dev, "error in reseting chip\n");
+		dev_err(&client->dev, "error in resetting chip\n");
 		goto fail2;
 	}
 	usleep_range(10000, 20000);
_

Patches currently in -mm which might be from standby24x7@gmail.com are

origin.patch
linux-next.patch

