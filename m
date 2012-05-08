From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-apple_blc-include-header-for-exported-symbol-prototypes.patch added to -mm tree
Date: Tue, 08 May 2012 12:23:20 -0700
Message-ID: <20120508192321.A93FAA024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:63652 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab2EHTXZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2012 15:23:25 -0400
Received: by wgbdt11 with SMTP id dt11so378320wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 08 May 2012 12:23:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, FlorianSchandinat@gmx.de, hsweeten@visionengravers.com, rpurdie@rpsys.net


The patch titled
     Subject: drivers/video/backlight/apple_bl.c: include header for exported symbol prototypes
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-apple_blc-include-header-for-exported-symbol-prototypes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: drivers/video/backlight/apple_bl.c: include header for exported symbol prototypes

Include the header to pickup the exported symbol prototype.

Quites the sparse warning:

warning: symbol 'apple_bl_register' was not declared. Should it be static?
warning: symbol 'apple_bl_unregister' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/apple_bl.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/backlight/apple_bl.c~drivers-video-backlight-apple_blc-include-header-for-exported-symbol-prototypes drivers/video/backlight/apple_bl.c
--- a/drivers/video/backlight/apple_bl.c~drivers-video-backlight-apple_blc-include-header-for-exported-symbol-prototypes
+++ a/drivers/video/backlight/apple_bl.c
@@ -25,6 +25,7 @@
 #include <linux/pci.h>
 #include <linux/acpi.h>
 #include <linux/atomic.h>
+#include <linux/apple_bl.h>
 
 static struct backlight_device *apple_backlight_device;
 
_
Subject: Subject: drivers/video/backlight/apple_bl.c: include header for exported symbol prototypes

Patches currently in -mm which might be from hartleys@visionengravers.com are

linux-next.patch
drivers-video-backlight-apple_blc-include-header-for-exported-symbol-prototypes.patch
init-disable-sparse-checking-of-the-mounto-source-files.patch
drivers-rtc-rtc-ep93xxc-convert-to-use-module_platform_driver.patch

