From: akpm@linux-foundation.org
Subject: + backlight-lp855x-add-fast-bit-description-for-lp8556.patch added to -mm tree
Date: Thu, 16 Aug 2012 12:13:04 -0700
Message-ID: <20120816191305.17F7F5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:36562 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756582Ab2HPTNH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Aug 2012 15:13:07 -0400
Received: by wgbdt11 with SMTP id dt11so148705wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 16 Aug 2012 12:13:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Milo.Kim@ti.com, bryan.wu@canonical.com, milo.kim@ti.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: lp855x: add FAST bit description for LP8556
has been added to the -mm tree.  Its filename is
     backlight-lp855x-add-fast-bit-description-for-lp8556.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kim, Milo" <Milo.Kim@ti.com>
Subject: backlight: lp855x: add FAST bit description for LP8556

LP8556 backlight driver supports fast refresh mode when exiting the low
power mode.  This bit can be configurable in the platform side.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Bryan Wu <bryan.wu@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/platform_data/lp855x.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/platform_data/lp855x.h~backlight-lp855x-add-fast-bit-description-for-lp8556 include/linux/platform_data/lp855x.h
--- a/include/linux/platform_data/lp855x.h~backlight-lp855x-add-fast-bit-description-for-lp8556
+++ a/include/linux/platform_data/lp855x.h
@@ -46,6 +46,8 @@
 #define LP8556_I2C_CONFIG	((ENABLE_BL << BL_CTL_SHFT) | \
 				(LP8556_I2C_ONLY << BRT_MODE_SHFT))
 #define LP8556_COMB2_CONFIG	(LP8556_COMBINED2 << BRT_MODE_SHFT)
+#define LP8556_FAST_CONFIG	BIT(7) /* use it if EPROMs should be maintained
+					  when exiting the low power mode */
 
 enum lp855x_chip_id {
 	LP8550,
_

Patches currently in -mm which might be from Milo.Kim@ti.com are

backlight-lp855x-add-fast-bit-description-for-lp8556.patch
rtc-proc-permit-the-proc-driver-rtc-device-to-use-other-devices.patch

