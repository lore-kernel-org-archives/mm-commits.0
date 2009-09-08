From: akpm@linux-foundation.org
Subject: [merged] leds-gpio-leds-fix-typographics-fault.patch removed from -mm tree
Date: Tue, 08 Sep 2009 14:26:16 -0700
Message-ID: <200909082126.n88LQG35006651@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47005 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751870AbZIHV0a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2009 17:26:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: monstr@monstr.eu, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     leds: gpio-leds: fix typographics fault
has been removed from the -mm tree.  Its filename was
     leds-gpio-leds-fix-typographics-fault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds: gpio-leds: fix typographics fault
From: Michal Simek <monstr@monstr.eu>

[akpm@linux-foundation.org: coding-style fixes]
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
arches-drop-superfluous-casts-in-nr_free_pages-callers.patch

