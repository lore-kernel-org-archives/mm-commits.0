From: akpm@linux-foundation.org
Subject: - maple-remove-unused-variable.patch removed from -mm tree
Date: Wed, 27 Feb 2008 14:16:54 -0800
Message-ID: <200802272216.m1RMGsVo000756@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36870 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757976AbYB0WR1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 17:17:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adrian@newgolddream.dyndns.info, adrian@mcmen.demon.co.uk, dtor@mail.ru, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     maple: remove unused variable
has been removed from the -mm tree.  Its filename was
     maple-remove-unused-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

maple-allow-removal-and-reinsertion-of-keyboard-driver-module.patch
maple-add-driver-for-sega-dreamcast-controller.patch
git-sh.patch
