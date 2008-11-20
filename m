From: akpm@linux-foundation.org
Subject: - leds-pca9532-mark-pca9532_event-static.patch removed from -mm tree
Date: Thu, 20 Nov 2008 12:43:51 -0800
Message-ID: <200811202043.mAKKhpPe007755@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755532AbYKTUqM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Nov 2008 15:46:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sven.wegener@stealer.net, mm-commits@vger.kernel.org


The patch titled
     leds-pca9532: mark pca9532_event() static
has been removed from the -mm tree.  Its filename was
     leds-pca9532-mark-pca9532_event-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds-pca9532: mark pca9532_event() static
From: Sven Wegener <sven.wegener@stealer.net>

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-pca9532.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/leds/leds-pca9532.c~leds-pca9532-mark-pca9532_event-static drivers/leds/leds-pca9532.c
--- a/drivers/leds/leds-pca9532.c~leds-pca9532-mark-pca9532_event-static
+++ a/drivers/leds/leds-pca9532.c
@@ -151,8 +151,8 @@ static int pca9532_set_blink(struct led_
 	return pca9532_setpwm(client, 0, psc, led_cdev->brightness);
 }
 
-int pca9532_event(struct input_dev *dev, unsigned int type, unsigned int code,
-	int value)
+static int pca9532_event(struct input_dev *dev, unsigned int type,
+	unsigned int code, int value)
 {
 	struct pca9532_data *data = input_get_drvdata(dev);
 
_

Patches currently in -mm which might be from sven.wegener@stealer.net are

linux-next.patch

