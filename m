From: akpm@linux-foundation.org
Subject: + leds-gpio-leds-fix-typographics-fault.patch added to -mm tree
Date: Thu, 02 Jul 2009 15:46:42 -0700
Message-ID: <200907022246.n62MkgiF015972@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38054 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752214AbZGBWqv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jul 2009 18:46:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: monstr@monstr.eu, rpurdie@rpsys.net


The patch titled
     leds: gpio-leds: fix typographics fault
has been added to the -mm tree.  Its filename is
     leds-gpio-leds-fix-typographics-fault.patch

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
Subject: leds: gpio-leds: fix typographics fault
From: Michal Simek <monstr@monstr.eu>

Signed-off-by: Michal Simek <monstr@monstr.eu>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-gpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/leds/leds-gpio.c~leds-gpio-leds-fix-typographics-fault drivers/leds/leds-gpio.c
--- a/drivers/leds/leds-gpio.c~leds-gpio-leds-fix-typographics-fault
+++ a/drivers/leds/leds-gpio.c
@@ -80,7 +80,7 @@ static int __devinit create_gpio_led(con
 
 	/* skip leds that aren't available */
 	if (!gpio_is_valid(template->gpio)) {
-		printk(KERN_INFO "Skipping unavilable LED gpio %d (%s)\n", 
+		printk(KERN_INFO "Skipping unavailable LED gpio %d (%s)\n", 
 				template->gpio, template->name);
 		return 0;
 	}
_

Patches currently in -mm which might be from monstr@monstr.eu are

linux-next.patch
leds-gpio-leds-fix-typographics-fault.patch

