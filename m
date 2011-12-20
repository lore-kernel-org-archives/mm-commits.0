From: akpm@linux-foundation.org
Subject: + leds-tca6507-allow-driver-to-compile-when-gpiolib-is-not-available-fix.patch added to -mm tree
Date: Tue, 20 Dec 2011 14:21:19 -0800
Message-ID: <20111220222120.1C6EB10004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:63665 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab1LTWVU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Dec 2011 17:21:20 -0500
Received: by yhjj51 with SMTP id j51so1086070yhj.1
        for <mm-commits@vger.kernel.org>; Tue, 20 Dec 2011 14:21:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de, rdunlap@xenotime.net


The patch titled
     Subject: leds-tca6507-allow-driver-to-compile-when-gpiolib-is-not-available-fix
has been added to the -mm tree.  Its filename is
     leds-tca6507-allow-driver-to-compile-when-gpiolib-is-not-available-fix.patch

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
From: NeilBrown <neilb@suse.de>
Subject: leds-tca6507-allow-driver-to-compile-when-gpiolib-is-not-available-fix

Argh..

Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-tca6507.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/leds/leds-tca6507.c~leds-tca6507-allow-driver-to-compile-when-gpiolib-is-not-available-fix drivers/leds/leds-tca6507.c
--- a/drivers/leds/leds-tca6507.c~leds-tca6507-allow-driver-to-compile-when-gpiolib-is-not-available-fix
+++ a/drivers/leds/leds-tca6507.c
@@ -352,7 +352,7 @@ static int led_prepare(struct tca6507_le
 			return 0;
 		}
 
-		for (i = MASTER; i >= BANK0; i++) {
+		for (i = MASTER; i >= BANK0; i--) {
 			int d;
 			if (tca->bank[i].level == level ||
 			    tca->bank[i].level_use == 0) {
_
Subject: Subject: leds-tca6507-allow-driver-to-compile-when-gpiolib-is-not-available-fix

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
linux-next.patch
leds-add-driver-for-tca6507-led-controller.patch
leds-add-driver-for-tca6507-led-controller-fix.patch
leds-add-driver-for-tca6507-led-controller-checkpatch-fixes.patch
leds-tca6507-allow-driver-to-compile-when-gpiolib-is-not-available.patch
leds-tca6507-allow-driver-to-compile-when-gpiolib-is-not-available-fix.patch
leds-tca6507-fix-off-by-one-error.patch
ipc-provide-generic-compat-versions-of-ipc-syscalls.patch

