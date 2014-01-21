From: akpm@linux-foundation.org
Subject: [folded-merged]
 input-route-kbd-leds-through-the-generic-leds-layer-fix.patch removed from
 -mm tree
Date: Tue, 21 Jan 2014 14:35:19 -0800
Message-ID: <52def627.owkZl0qqtdQWTuhI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45148 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769AbaAUWfU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jan 2014 17:35:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, samuel.thibault@ens-lyon.org, fengguang.wu@intel.com, dmitry.torokhov@gmail.com, akpm@linux-foundation.org

Subject: [folded-merged] input-route-kbd-leds-through-the-generic-leds-layer-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,dmitry.torokhov@gmail.com,fengguang.wu@intel.com,samuel.thibault@ens-lyon.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 21 Jan 2014 14:35:19 -0800


The patch titled
     Subject: input-route-kbd-leds-through-the-generic-leds-layer-fix
has been removed from the -mm tree.  Its filename was
     input-route-kbd-leds-through-the-generic-leds-layer-fix.patch

This patch was dropped because it was folded into input-route-kbd-leds-through-the-generic-leds-layer.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: input-route-kbd-leds-through-the-generic-leds-layer-fix

remove unneeded `extern', fix comment layout

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/leds.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/input/leds.c~input-route-kbd-leds-through-the-generic-leds-layer-fix drivers/input/leds.c
--- a/drivers/input/leds.c~input-route-kbd-leds-through-the-generic-leds-layer-fix
+++ a/drivers/input/leds.c
@@ -211,9 +211,11 @@ err:
 	return error;
 }
 
-/* Disconnected input device. Clean it, and deregister now-useless VT LEDs
- * and triggers.  */
-extern void input_led_disconnect(struct input_dev *dev)
+/*
+ * Disconnected input device. Clean it, and deregister now-useless VT LEDs and
+ * triggers.
+ */
+void input_led_disconnect(struct input_dev *dev)
 {
 	int i;
 	struct led_classdev *leds = dev->leds;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch

