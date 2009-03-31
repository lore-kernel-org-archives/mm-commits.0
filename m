From: akpm@linux-foundation.org
Subject: + xtensa-add-m41t62-rtc-to-s6105-platform.patch added to -mm tree
Date: Tue, 31 Mar 2009 16:53:54 -0700
Message-ID: <200903312353.n2VNrsXC015644@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55890 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754513AbZCaX6c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Mar 2009 19:58:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dg@emlix.com, a.zummo@towertech.it, chris@zankel.net, david-b@pacbell.net


The patch titled
     xtensa: add m41t62 rtc to s6105 platform
has been added to the -mm tree.  Its filename is
     xtensa-add-m41t62-rtc-to-s6105-platform.patch

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
Subject: xtensa: add m41t62 rtc to s6105 platform
From: Daniel Glockner <dg@emlix.com>

Signed-off-by: Daniel Glockner <dg@emlix.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/platforms/s6105/device.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/xtensa/platforms/s6105/device.c~xtensa-add-m41t62-rtc-to-s6105-platform arch/xtensa/platforms/s6105/device.c
--- a/arch/xtensa/platforms/s6105/device.c~xtensa-add-m41t62-rtc-to-s6105-platform
+++ a/arch/xtensa/platforms/s6105/device.c
@@ -143,6 +143,9 @@ static struct platform_device platform_d
 		.resource = s6_gmac_resource,
 		.num_resources = ARRAY_SIZE(s6_gmac_resource),
 	},
+	{
+		I2C_BOARD_INFO("m41t62", S6I2C_ADDR_M41T62),
+	},
 };
 
 static int __init device_init(void)
_

Patches currently in -mm which might be from dg@emlix.com are

origin.patch
linux-next.patch
xtensa-make-startup-code-discardable.patch
xtensa-nommu-support.patch
xtensa-variant-specific-code.patch
xtensa-variant-irq-set-callbacks.patch
xtensa-s6000-variant-core-definitions.patch
xtensa-s6000-variant.patch
xtensa-s6000-gpio-driver.patch
xtensa-let-platform-override-kerneloffset.patch
xtensa-platform-stretch-s6105-eval-board.patch
xtensa-cache-inquiry-and-unaligned-cache-handling-functions.patch
xtensa-s6000-dma-engine-support.patch
xtensa-allow-platform-and-variant-to-initialize-own-irq-chips.patch
xtensa-support-s6000-gpio-irqs-and-alternate-function-selection.patch
s6gmac-xtensa-s6000-on-chip-ethernet-driver.patch
xtensa-s6105-specific-configuration-for-s6gmac.patch
xtensa-enable-s6gmac-in-s6105_defconfig.patch
rtc-add-m41t62-support-to-rtc-m41t80-driver.patch
xtensa-add-m41t62-rtc-to-s6105-platform.patch
xtensa-enable-m41t80-driver-in-s6105_defconfig.patch

