From: akpm@linux-foundation.org
Subject: - apanel-change-name-of-led.patch removed from -mm tree
Date: Thu, 13 Dec 2007 15:59:31 -0800
Message-ID: <200712132359.lBDNxVDR025322@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52682 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934669AbXLMX7i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Dec 2007 18:59:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@linux-foundation.org, dtor@mail.ru, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     apanel: change name of LED
has been removed from the -mm tree.  Its filename was
     apanel-change-name-of-led.patch

This patch was dropped because it was folded into fujitsu-application-panel-driver.patch

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
apanel-change-name-of-led.patch
apanel-detach-on-shutdown.patch
apanel-use-generic-keycode-routines.patch
fujitsu-application-panel-led-value.patch
git-net.patch
git-netdev-all.patch
git-wireless.patch
bonding-locking-fix.patch
bridge-assign-random-address.patch
