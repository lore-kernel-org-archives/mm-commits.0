From: akpm@linux-foundation.org
Subject: + email-address-change.patch added to -mm tree
Date: Mon, 12 Jul 2010 16:25:12 -0700
Message-ID: <201007122325.o6CNPCAG003109@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42949 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754082Ab0GLXZm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jul 2010 19:25:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net


The patch titled
     Andres has moved
has been added to the -mm tree.  Its filename is
     email-address-change.patch

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
Subject: Andres has moved
From: Andres Salomon <dilinger@queued.net>

My Collabora address is no longer enabled - update the MODULE_AUTHOR
fields of drivers to my current email address.

Signed-off-by: Andres Salomon <dilinger@queued.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clocksource/cs5535-clockevt.c |    2 +-
 drivers/gpio/cs5535-gpio.c            |    2 +-
 drivers/misc/cs5535-mfgpt.c           |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/clocksource/cs5535-clockevt.c~email-address-change drivers/clocksource/cs5535-clockevt.c
--- a/drivers/clocksource/cs5535-clockevt.c~email-address-change
+++ a/drivers/clocksource/cs5535-clockevt.c
@@ -194,6 +194,6 @@ err_timer:
 
 module_init(cs5535_mfgpt_init);
 
-MODULE_AUTHOR("Andres Salomon <dilinger@collabora.co.uk>");
+MODULE_AUTHOR("Andres Salomon <dilinger@queued.net>");
 MODULE_DESCRIPTION("CS5535/CS5536 MFGPT clock event driver");
 MODULE_LICENSE("GPL");
diff -puN drivers/gpio/cs5535-gpio.c~email-address-change drivers/gpio/cs5535-gpio.c
--- a/drivers/gpio/cs5535-gpio.c~email-address-change
+++ a/drivers/gpio/cs5535-gpio.c
@@ -352,6 +352,6 @@ static void __exit cs5535_gpio_exit(void
 module_init(cs5535_gpio_init);
 module_exit(cs5535_gpio_exit);
 
-MODULE_AUTHOR("Andres Salomon <dilinger@collabora.co.uk>");
+MODULE_AUTHOR("Andres Salomon <dilinger@queued.net>");
 MODULE_DESCRIPTION("AMD CS5535/CS5536 GPIO driver");
 MODULE_LICENSE("GPL");
diff -puN drivers/misc/cs5535-mfgpt.c~email-address-change drivers/misc/cs5535-mfgpt.c
--- a/drivers/misc/cs5535-mfgpt.c~email-address-change
+++ a/drivers/misc/cs5535-mfgpt.c
@@ -366,6 +366,6 @@ static int __init cs5535_mfgpt_init(void
 
 module_init(cs5535_mfgpt_init);
 
-MODULE_AUTHOR("Andres Salomon <dilinger@collabora.co.uk>");
+MODULE_AUTHOR("Andres Salomon <dilinger@queued.net>");
 MODULE_DESCRIPTION("CS5535/CS5536 MFGPT timer driver");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from dilinger@queued.net are

email-address-change.patch
linux-next.patch
x86-mm-create-symbolic-index-into-address_markers-array.patch

