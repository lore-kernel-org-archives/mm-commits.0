From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-mpc5121c-remove-space-before-tab.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:30:58 -0700
Message-ID: <51db1372.H1d0E7U4vKUzSVJD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51154 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab3GHTbL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:31:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com, sachin.kamat@linaro.org

Subject: [merged] drivers-rtc-rtc-mpc5121c-remove-space-before-tab.patch removed from -mm tree
To: sachin.kamat@linaro.org,jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:30:58 -0700


The patch titled
     Subject: drivers/rtc/rtc-mpc5121.c: remove space before tab
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-mpc5121c-remove-space-before-tab.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-mpc5121.c: remove space before tab

WARNING: please, no space before tabs

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mpc5121.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-mpc5121.c~drivers-rtc-rtc-mpc5121c-remove-space-before-tab drivers/rtc/rtc-mpc5121.c
--- a/drivers/rtc/rtc-mpc5121.c~drivers-rtc-rtc-mpc5121c-remove-space-before-tab
+++ a/drivers/rtc/rtc-mpc5121.c
@@ -68,7 +68,7 @@ struct mpc5121_rtc_regs {
 	u32 target_time;	/* RTC + 0x20 */
 	/*
 	 * actual_time:
-	 * 	readonly time since VBAT_RTC was last connected
+	 *	readonly time since VBAT_RTC was last connected
 	 */
 	u32 actual_time;	/* RTC + 0x24 */
 	u32 keep_alive;		/* RTC + 0x28 */
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
linux-next.patch

