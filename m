From: akpm@linux-foundation.org
Subject: [merged] backlight-lp855x-add-fast-bit-description-for-lp8556.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:14:54 -0700
Message-ID: <20121005201454.AF571100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:64100 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757189Ab2JEUOz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:14:55 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so236759qcq.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:14:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Milo.Kim@ti.com, bryan.wu@canonical.com, milo.kim@ti.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: lp855x: add FAST bit description for LP8556
has been removed from the -mm tree.  Its filename was
     backlight-lp855x-add-fast-bit-description-for-lp8556.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

