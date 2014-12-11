From: akpm@linux-foundation.org
Subject: [merged] rtc-omap-remove-unused-register-base-define.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 11:06:21 -0800
Message-ID: <5489eb2d.23nV0PMepKUMiPCC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45785 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883AbaLKTGW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:06:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johan@kernel.org, a.zummo@towertech.it, balbi@ti.com, bcousson@baylibre.com, j-keerthy@ti.com, linux@roeck-us.net, lokeshvutla@ti.com, nsekhar@ti.com, t-kristo@ti.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: omap: remove unused register-base define
has been removed from the -mm tree.  Its filename was
     rtc-omap-remove-unused-register-base-define.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johan Hovold <johan@kernel.org>
Subject: rtc: omap: remove unused register-base define

Remove register-base define, which is no longer used.

Signed-off-by: Johan Hovold <johan@kernel.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Benot Cousson <bcousson@baylibre.com>
Cc: Lokesh Vutla <lokeshvutla@ti.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Tero Kristo <t-kristo@ti.com>
Cc: Keerthy J <j-keerthy@ti.com>
Tested-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-omap.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/rtc/rtc-omap.c~rtc-omap-remove-unused-register-base-define drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-omap-remove-unused-register-base-define
+++ a/drivers/rtc/rtc-omap.c
@@ -41,8 +41,6 @@
 
 #define	DRIVER_NAME			"omap_rtc"
 
-#define OMAP_RTC_BASE			0xfffb4800
