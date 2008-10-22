From: akpm@linux-foundation.org
Subject: - leds-pca955x-mark-pca955x_led_set-static.patch removed from -mm tree
Date: Wed, 22 Oct 2008 13:08:56 -0700
Message-ID: <200810222008.m9MK8uv0013877@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35442 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754013AbYJVUJD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Oct 2008 16:09:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sven.wegener@stealer.net, mm-commits@vger.kernel.org


The patch titled
     leds-pca955x: mark pca955x_led_set() static
has been removed from the -mm tree.  Its filename was
     leds-pca955x-mark-pca955x_led_set-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds-pca955x: mark pca955x_led_set() static
From: Sven Wegener <sven.wegener@stealer.net>

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-pca955x.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/leds/leds-pca955x.c~leds-pca955x-mark-pca955x_led_set-static drivers/leds/leds-pca955x.c
--- a/drivers/leds/leds-pca955x.c~leds-pca955x-mark-pca955x_led_set-static
+++ a/drivers/leds/leds-pca955x.c
@@ -226,7 +226,8 @@ static void pca955x_led_work(struct work
 	pca955x_write_ls(pca955x->client, chip_ls, ls);
 }
 
-void pca955x_led_set(struct led_classdev *led_cdev, enum led_brightness value)
+static void pca955x_led_set(struct led_classdev *led_cdev,
+				enum led_brightness value)
 {
 	struct pca955x_led *pca955x;
 
_

Patches currently in -mm which might be from sven.wegener@stealer.net are

origin.patch
linux-next.patch
leds-pca9532-mark-pca9532_event-static.patch

