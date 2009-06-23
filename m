From: akpm@linux-foundation.org
Subject: [merged] xtensa-add-m41t62-rtc-to-s6105-platform.patch removed from -mm tree
Date: Tue, 23 Jun 2009 11:05:45 -0700
Message-ID: <200906231805.n5NI5jdd009806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750800AbZFWSGQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jun 2009 14:06:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dg@emlix.com, a.zummo@towertech.it, chris@zankel.net, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     xtensa: add m41t62 rtc to s6105 platform
has been removed from the -mm tree.  Its filename was
     xtensa-add-m41t62-rtc-to-s6105-platform.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
xtensa-variant-specific-code.patch

