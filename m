From: akpm@linux-foundation.org
Subject: + drivers-leds-leds-lp5521c-fix-typo.patch added to -mm tree
Date: Thu, 26 Jan 2012 15:48:03 -0800
Message-ID: <20120126234803.8D0D5A01C7@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:64836 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759Ab2AZXsF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2012 18:48:05 -0500
Received: by ggnk1 with SMTP id k1so134443ggn.1
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2012 15:48:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: standby24x7@gmail.com, rpurdie@rpsys.net


The patch titled
     Subject: drivers/leds/leds-lp5521.c: fix typo
has been added to the -mm tree.  Its filename is
     drivers-leds-leds-lp5521c-fix-typo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: drivers/leds/leds-lp5521.c: fix typo

Patches currently in -mm which might be from standby24x7@gmail.com are

linux-next.patch
drivers-leds-leds-lp5521c-fix-typo.patch

