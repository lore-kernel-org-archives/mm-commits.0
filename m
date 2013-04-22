From: akpm@linux-foundation.org
Subject: + backlight-lp855x-fix-initial-brightness-type.patch added to -mm tree
Date: Mon, 22 Apr 2013 15:47:18 -0700
Message-ID: <20130422224718.C3EB95A4219@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:40472 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761Ab3DVWrU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Apr 2013 18:47:20 -0400
Received: by mail-gh0-f202.google.com with SMTP id z10so644431ghb.3
        for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2013 15:47:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Milo.Kim@ti.com, milo.kim@ti.com


The patch titled
     Subject: backlight: lp855x: fix initial brightness type
has been added to the -mm tree.  Its filename is
     backlight-lp855x-fix-initial-brightness-type.patch

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

linux-next.patch
backlight-lp855x-use-page_size-for-the-sysfs-read-operation.patch
backlight-lp855x-convert-a-type-of-device-name.patch
backlight-lp855x-move-backlight-mode-platform-data.patch
backlight-lp855x-fix-initial-brightness-type.patch
backlight-lp855x-remove-duplicate-platform-data.patch
backlight-lp855x-add-a-device-tree-structure.patch

