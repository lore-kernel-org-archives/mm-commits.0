From: akpm@linux-foundation.org
Subject: [merged] leds-change-the-license-information.patch removed from -mm tree
Date: Thu, 18 Jun 2009 11:20:35 -0700
Message-ID: <200906181820.n5IIKZwl018193@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41100 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751161AbZFRSar (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 14:30:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chammoru@gmail.com, q1.kim@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     leds: change the license information
has been removed from the -mm tree.  Its filename was
     leds-change-the-license-information.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

