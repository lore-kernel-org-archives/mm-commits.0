From: akpm@linux-foundation.org
Subject: [merged] rtc-max77686-fix-indentation-of-bit-definitions.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:54:18 -0700
Message-ID: <20130430185418.6FFCE5A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:34816 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933177Ab3D3SyT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:54:19 -0400
Received: by mail-vb0-f73.google.com with SMTP id p12so86583vbe.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:54:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-max77686.c: fix indentation of bit definitions
has been removed from the -mm tree.  Its filename was
     rtc-max77686-fix-indentation-of-bit-definitions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/rtc/rtc-max77686.c: fix indentation of bit definitions

Fix indentation of bit definitions to enhance the readability.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max77686.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-max77686.c~rtc-max77686-fix-indentation-of-bit-definitions drivers/rtc/rtc-max77686.c
--- a/drivers/rtc/rtc-max77686.c~rtc-max77686-fix-indentation-of-bit-definitions
+++ a/drivers/rtc/rtc-max77686.c
@@ -24,7 +24,7 @@
 
 /* RTC Control Register */
 #define BCD_EN_SHIFT			0
-#define BCD_EN_MASK				(1 << BCD_EN_SHIFT)
+#define BCD_EN_MASK			(1 << BCD_EN_SHIFT)
 #define MODEL24_SHIFT			1
 #define MODEL24_MASK			(1 << MODEL24_SHIFT)
 /* RTC Update Register1 */
@@ -33,12 +33,12 @@
 #define RTC_RBUDR_SHIFT			4
 #define RTC_RBUDR_MASK			(1 << RTC_RBUDR_SHIFT)
 /* WTSR and SMPL Register */
-#define WTSRT_SHIFT				0
-#define SMPLT_SHIFT				2
+#define WTSRT_SHIFT			0
+#define SMPLT_SHIFT			2
 #define WTSR_EN_SHIFT			6
 #define SMPL_EN_SHIFT			7
-#define WTSRT_MASK				(3 << WTSRT_SHIFT)
-#define SMPLT_MASK				(3 << SMPLT_SHIFT)
+#define WTSRT_MASK			(3 << WTSRT_SHIFT)
+#define SMPLT_MASK			(3 << SMPLT_SHIFT)
 #define WTSR_EN_MASK			(1 << WTSR_EN_SHIFT)
 #define SMPL_EN_MASK			(1 << SMPL_EN_SHIFT)
 /* RTC Hour register */
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

