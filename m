From: akpm@linux-foundation.org
Subject: [merged] cs5535-clockevt-typo-its-mfgpt-not-mfpgt.patch removed from -mm tree
Date: Fri, 24 Aug 2012 11:41:03 -0700
Message-ID: <20120824184103.B7996100049@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:65465 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760009Ab2HXSlE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Aug 2012 14:41:04 -0400
Received: by mail-vc0-f202.google.com with SMTP id p1so311760vcq.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Aug 2012 11:41:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: JRottmann@LiPPERTEmbedded.de, john.stultz@linaro.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: cs5535-clockevt: typo, it's MFGPT, not MFPGT
has been removed from the -mm tree.  Its filename was
     cs5535-clockevt-typo-its-mfgpt-not-mfpgt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
Subject: cs5535-clockevt: typo, it's MFGPT, not MFPGT

Signed-off-by: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clocksource/cs5535-clockevt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/clocksource/cs5535-clockevt.c~cs5535-clockevt-typo-its-mfgpt-not-mfpgt drivers/clocksource/cs5535-clockevt.c
--- a/drivers/clocksource/cs5535-clockevt.c~cs5535-clockevt-typo-its-mfgpt-not-mfpgt
+++ a/drivers/clocksource/cs5535-clockevt.c
@@ -53,7 +53,7 @@ static struct cs5535_mfgpt_timer *cs5535
 #define MFGPT_PERIODIC (MFGPT_HZ / HZ)
 
 /*
- * The MFPGT timers on the CS5536 provide us with suitable timers to use
+ * The MFGPT timers on the CS5536 provide us with suitable timers to use
  * as clock event sources - not as good as a HPET or APIC, but certainly
  * better than the PIT.  This isn't a general purpose MFGPT driver, but
  * a simplified one designed specifically to act as a clock event source.
@@ -144,7 +144,7 @@ static int __init cs5535_mfgpt_init(void
 
 	timer = cs5535_mfgpt_alloc_timer(MFGPT_TIMER_ANY, MFGPT_DOMAIN_WORKING);
 	if (!timer) {
-		printk(KERN_ERR DRV_NAME ": Could not allocate MFPGT timer\n");
+		printk(KERN_ERR DRV_NAME ": Could not allocate MFGPT timer\n");
 		return -ENODEV;
 	}
 	cs5535_event_clock = timer;
_

Patches currently in -mm which might be from JRottmann@LiPPERTEmbedded.de are

origin.patch

