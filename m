From: akpm@linux-foundation.org
Subject: + leds-change-the-license-information.patch added to -mm tree
Date: Tue, 14 Apr 2009 15:59:31 -0700
Message-ID: <200904142259.n3EMxV9I011470@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55145 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751446AbZDNXCW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 19:02:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chammoru@gmail.com, q1.kim@samsung.com, rpurdie@rpsys.net


The patch titled
     leds: change the license information
has been added to the -mm tree.  Its filename is
     leds-change-the-license-information.patch

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
Subject: leds: change the license information
From: Kim Kyuwon <chammoru@gmail.com>

Change the license to 'GPL v2'

Signed-off-by: Kim Kyuwon <q1.kim@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-bd2802.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/leds/leds-bd2802.c~leds-change-the-license-information drivers/leds/leds-bd2802.c
--- a/drivers/leds/leds-bd2802.c~leds-change-the-license-information
+++ a/drivers/leds/leds-bd2802.c
@@ -756,4 +756,4 @@ module_exit(bd2802_exit);
 
 MODULE_AUTHOR("Kim Kyuwon <q1.kim@samsung.com>");
 MODULE_DESCRIPTION("BD2802 LED driver");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
_

Patches currently in -mm which might be from chammoru@gmail.com are

leds-fix-led-bd2802-errors-while-resuming.patch
leds-change-the-license-information.patch
leds-add-the-sysfs-interface-into-the-leds-bd2802-driver-for-changing-wave-pattern-and-led-current.patch

