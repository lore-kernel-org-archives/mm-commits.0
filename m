From: akpm@linux-foundation.org
Subject: + documentation-leds-class-fix-a-typo.patch added to -mm tree
Date: Tue, 06 Sep 2011 15:49:54 -0700
Message-ID: <201109062249.p86MnsDd008885@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36622 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755200Ab1IFWuF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2011 18:50:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@canonical.com, linus.walleij@linaro.org, rpurdie@rpsys.net


The patch titled
     Documentation/leds/leds-class.txt: fix a typo
has been added to the -mm tree.  Its filename is
     documentation-leds-class-fix-a-typo.patch

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
Subject: Documentation/leds/leds-class.txt: fix a typo
From: Bryan Wu <bryan.wu@canonical.com>

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
Acked-by: Richard Purdie <rpurdie@rpsys.net>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/leds/leds-class.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/leds/leds-class.txt~documentation-leds-class-fix-a-typo Documentation/leds/leds-class.txt
--- a/Documentation/leds/leds-class.txt~documentation-leds-class-fix-a-typo
+++ a/Documentation/leds/leds-class.txt
@@ -61,8 +61,8 @@ Hardware accelerated blink of LEDs
 Some LEDs can be programmed to blink without any CPU interaction. To
 support this feature, a LED driver can optionally implement the
 blink_set() function (see <linux/leds.h>). To set an LED to blinking,
-however, it is better to use use the API function led_blink_set(),
-as it will check and implement software fallback if necessary.
+however, it is better to use the API function led_blink_set(), as it
+will check and implement software fallback if necessary.
 
 To turn off blinking again, use the API function led_brightness_set()
 as that will not just set the LED brightness but also stop any software
_

Patches currently in -mm which might be from bryan.wu@canonical.com are

origin.patch
leds-class-change-back-leds_class-to-tristate-instead-of-bool.patch
documentation-leds-class-fix-a-typo.patch

