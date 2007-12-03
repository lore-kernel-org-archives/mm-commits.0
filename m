From: akpm@linux-foundation.org
Subject: + apanel-change-name-of-led.patch added to -mm tree
Date: Mon, 03 Dec 2007 14:56:37 -0800
Message-ID: <200712032256.lB3MubnZ021815@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43605 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751103AbXLCW4u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Dec 2007 17:56:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@linux-foundation.org, dtor@mail.ru, jkosina@suse.cz


The patch titled
     apanel: change name of LED
has been added to the -mm tree.  Its filename is
     apanel-change-name-of-led.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: apanel: change name of LED
From: Stephen Hemminger <shemminger@linux-foundation.org>

Make name of LED match the current usage precedent in wistron buttons.  Note:
If the LED developers want a different convention, they can just change both
drivers.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/misc/apanel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/input/misc/apanel.c~apanel-change-name-of-led drivers/input/misc/apanel.c
--- a/drivers/input/misc/apanel.c~apanel-change-name-of-led
+++ a/drivers/input/misc/apanel.c
@@ -219,7 +219,7 @@ static struct apanel apanel = {
 
 	},
 	.mail_led = {
-		.name = APANEL ":mail",
+		.name = "mail:blue",
 		.brightness_set = mail_led_set,
 	},
 };
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

git-input.patch
fujitsu-application-panel-driver.patch
apanel-free-input-device-on-close.patch
apanel-change-name-of-led.patch
apanel-detach-on-shutdown.patch
apanel-use-generic-keycode-routines.patch
git-net.patch
git-netdev-all.patch
git-wireless.patch
