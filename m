From: akpm@linux-foundation.org
Subject: [to-be-updated]
 input-route-kbd-leds-through-the-generic-leds-layer-fix-fix-fix.patch
 removed from -mm tree
Date: Mon, 04 Nov 2013 12:20:55 -0800
Message-ID: <527801a7.h4KYgj5LoU9km6Qz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47274 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab3KDUU4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Nov 2013 15:20:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ralf@linux-mips.org, dmitry.torokhov@gmail.com, blogic@openwrt.org, samuel.thibault@ens-lyon.org

Subject: [to-be-updated] input-route-kbd-leds-through-the-generic-leds-layer-fix-fix-fix.patch removed from -mm tree
To: samuel.thibault@ens-lyon.org,blogic@openwrt.org,dmitry.torokhov@gmail.com,ralf@linux-mips.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 04 Nov 2013 12:20:55 -0800


The patch titled
     Subject: input-route-kbd-leds-through-the-generic-leds-layer-fix-fix-fix
has been removed from the -mm tree.  Its filename was
     input-route-kbd-leds-through-the-generic-leds-layer-fix-fix-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: input-route-kbd-leds-through-the-generic-leds-layer-fix-fix-fix

Export input led symbols for input core module.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: John Crispin <blogic@openwrt.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/leds.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/input/leds.c~input-route-kbd-leds-through-the-generic-leds-layer-fix-fix-fix drivers/input/leds.c
--- a/drivers/input/leds.c~input-route-kbd-leds-through-the-generic-leds-layer-fix-fix-fix
+++ a/drivers/input/leds.c
@@ -210,6 +210,7 @@ err:
 	input_led_delete(dev);
 	return error;
 }
+EXPORT_SYMBOL_GPL(input_led_connect);
 
 /* Disconnected input device. Clean it, and deregister now-useless VT LEDs
  * and triggers.  */
@@ -241,6 +242,7 @@ extern void input_led_disconnect(struct
 	}
 	mutex_unlock(&vt_led_registered_lock);
 }
+EXPORT_SYMBOL_GPL(input_led_disconnect);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("User LED support for input layer");
_

Patches currently in -mm which might be from samuel.thibault@ens-lyon.org are

input-route-kbd-leds-through-the-generic-leds-layer.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix.patch
linux-next.patch

