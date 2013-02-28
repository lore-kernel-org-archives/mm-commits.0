From: akpm@linux-foundation.org
Subject: + rtc-max77686-fix-indentation-of-bit-definitions.patch added to -mm tree
Date: Thu, 28 Feb 2013 14:27:03 -0800
Message-ID: <20130228222704.2BC4831C1F0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:56302 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951Ab3B1W1F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 17:27:05 -0500
Received: by mail-ye0-f201.google.com with SMTP id m12so262874yen.2
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 14:27:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: drivers/rtc/rtc-max77686.c: fix indentation of bit definitions
has been added to the -mm tree.  Its filename is
     rtc-max77686-fix-indentation-of-bit-definitions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_ops.patch
drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_ops-fix.patch
backlight-platform_lcd-remove-unnecessary-ifdefs.patch
rtc-rtc-mv-add-__init-annotation.patch
rtc-rtc-davinci-add-__exit-annotation.patch
rtc-rtc-ds1302-add-__exit-annotation.patch
rtc-rtc-imxdi-add-__init-__exit-annotation.patch
rtc-rtc-nuc900-add-__init-__exit-annotation.patch
rtc-rtc-pcap-add-__init-__exit-annotation.patch
rtc-rtc-tegra-add-__init-__exit-annotation.patch
rtc-max77686-use-module_platform_driver.patch
rtc-max77686-add-missing-module-author-name.patch
rtc-max77686-use-devm_kzalloc.patch
rtc-max77686-fix-indentation-of-bit-definitions.patch
rtc-max77686-use-dev_info-dev_emerg-instead-of-pr_info-pr_emerg.patch
rtc-rtc-v3020-use-gpio_request_array.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

