From: akpm@linux-foundation.org
Subject: + maple-remove-unused-variable.patch added to -mm tree
Date: Mon, 18 Feb 2008 01:58:24 -0800
Message-ID: <200802180959.m1I9xLaN018846@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37038 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752608AbYBRKAg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 05:00:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adrian@newgolddream.dyndns.info, adrian@mcmen.demon.co.uk, dtor@mail.ru, lethal@linux-sh.org


The patch titled
     maple: remove unused variable
has been added to the -mm tree.  Its filename is
     maple-remove-unused-variable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: maple: remove unused variable
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>

Remove an unused variable from the definition of struct maple_device

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/maple.h~maple-remove-unused-variable include/linux/maple.h
--- a/include/linux/maple.h~maple-remove-unused-variable
+++ a/include/linux/maple.h
@@ -64,7 +64,6 @@ struct maple_driver {
 	int (*connect) (struct maple_device * dev);
 	void (*disconnect) (struct maple_device * dev);
 	struct device_driver drv;
-	int registered;
 };
 
 void maple_getcond_callback(struct maple_device *dev,
_

Patches currently in -mm which might be from adrian@newgolddream.dyndns.info are

maple-remove-unused-variable.patch
maple-allow-removal-and-reinsertion-of-keyboard-driver-module.patch
maple-add-driver-for-sega-dreamcast-controller.patch
revert-sh-use-ctrl_in-out-for-on-chip-pci-access.patch
