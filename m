From: akpm@linux-foundation.org
Subject: + leds-set-leds_triggers-as-tristate.patch added to -mm tree
Date: Fri, 09 Sep 2011 16:52:09 -0700
Message-ID: <201109092352.p89Nq97d013790@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752647Ab1IIXwL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2011 19:52:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@canonical.com, richard.purdie@linuxfoundation.org


The patch titled
     leds: set LEDS_TRIGGERS as tristate
has been added to the -mm tree.  Its filename is
     leds-set-leds_triggers-as-tristate.patch

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
Subject: leds: set LEDS_TRIGGERS as tristate
From: Bryan Wu <bryan.wu@canonical.com>

LEDS_TRIGGERS depends on LEDS_CLASSS, which should be tristate.  So set it
as tristate too.

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
Cc: Richard Purdie <richard.purdie@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/leds/Kconfig~leds-set-leds_triggers-as-tristate drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~leds-set-leds_triggers-as-tristate
+++ a/drivers/leds/Kconfig
@@ -391,7 +391,7 @@ config LEDS_RENESAS_TPU
 	  Brightness control is supported but hardware blinking is not.
 
 config LEDS_TRIGGERS
-	bool "LED Trigger support"
+	tristate "LED Trigger support"
 	depends on LEDS_CLASS
 	help
 	  This option enables trigger support for the leds class.
_

Patches currently in -mm which might be from bryan.wu@canonical.com are

origin.patch
leds-class-change-back-leds_class-to-tristate-instead-of-bool.patch
documentation-leds-class-fix-a-typo.patch
leds-set-leds_triggers-as-tristate.patch

