From: akpm@linux-foundation.org
Subject: [merged] backlight-lp855x-fix-initial-brightness-type.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:52:59 -0700
Message-ID: <20130430185259.72EC35A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:57774 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933099Ab3D3SxA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:53:00 -0400
Received: by mail-ve0-f202.google.com with SMTP id ox1so77048veb.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:52:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Milo.Kim@ti.com, milo.kim@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: lp855x: fix initial brightness type
has been removed from the -mm tree.  Its filename was
     backlight-lp855x-fix-initial-brightness-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kim, Milo" <Milo.Kim@ti.com>
Subject: backlight: lp855x: fix initial brightness type

Valid range of the brightness is from 0 to 255, so initial brightness
is changed from integer to u8.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/platform_data/lp855x.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/platform_data/lp855x.h~backlight-lp855x-fix-initial-brightness-type include/linux/platform_data/lp855x.h
--- a/include/linux/platform_data/lp855x.h~backlight-lp855x-fix-initial-brightness-type
+++ a/include/linux/platform_data/lp855x.h
@@ -124,7 +124,7 @@ struct lp855x_rom_data {
 struct lp855x_platform_data {
 	const char *name;
 	u8 device_control;
-	int initial_brightness;
+	u8 initial_brightness;
 	unsigned int period_ns;
 	u8 load_new_rom_data;
 	int size_program;
_

Patches currently in -mm which might be from Milo.Kim@ti.com are

origin.patch
linux-next.patch

