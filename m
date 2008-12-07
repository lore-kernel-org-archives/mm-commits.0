From: akpm@linux-foundation.org
Subject: - leds-fix-cobalt-raq-led-dependency.patch removed from -mm tree
Date: Sat, 06 Dec 2008 16:05:16 -0800
Message-ID: <200812070005.mB705Geq021284@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48475 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753523AbYLGAF1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 6 Dec 2008 19:05:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yoichi_yuasa@tripeaks.co.jp, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     leds: fix Cobalt Raq LED dependency
has been removed from the -mm tree.  Its filename was
     leds-fix-cobalt-raq-led-dependency.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds: fix Cobalt Raq LED dependency
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

Cobalt Raq LEDs require LEDS_CLASS=y.

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/leds/Kconfig~leds-fix-cobalt-raq-led-dependency drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~leds-fix-cobalt-raq-led-dependency
+++ a/drivers/leds/Kconfig
@@ -83,7 +83,7 @@ config LEDS_COBALT_QUBE
 
 config LEDS_COBALT_RAQ
 	bool "LED Support for the Cobalt Raq series"
-	depends on LEDS_CLASS && MIPS_COBALT
+	depends on LEDS_CLASS=y && MIPS_COBALT
 	select LEDS_TRIGGERS
 	help
 	  This option enables support for the Cobalt Raq series LEDs.
_

Patches currently in -mm which might be from yoichi_yuasa@tripeaks.co.jp are

linux-next.patch

