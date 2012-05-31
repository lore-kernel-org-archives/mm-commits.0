From: akpm@linux-foundation.org
Subject: + maintainers-add-linux-leds-mail-list-address-and-git-url.patch added to -mm tree
Date: Thu, 31 May 2012 11:43:15 -0700
Message-ID: <20120531184316.80855A03DB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:63327 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758222Ab2EaSnU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 14:43:20 -0400
Received: by wibhn6 with SMTP id hn6so75651wib.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 11:43:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@canonical.com, rpurdie@rpsys.net


The patch titled
     Subject: MAINTAINERS: add linux-leds mail list address and git URL
has been added to the -mm tree.  Its filename is
     maintainers-add-linux-leds-mail-list-address-and-git-url.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bryan Wu <bryan.wu@canonical.com>
Subject: MAINTAINERS: add linux-leds mail list address and git URL

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

diff -puN MAINTAINERS~maintainers-add-linux-leds-mail-list-address-and-git-url MAINTAINERS
--- a/MAINTAINERS~maintainers-add-linux-leds-mail-list-address-and-git-url
+++ a/MAINTAINERS
@@ -4038,6 +4038,8 @@ F:	drivers/scsi/53c700*
 LED SUBSYSTEM
 M:	Bryan Wu <bryan.wu@canonical.com>
 M:	Richard Purdie <rpurdie@rpsys.net>
+L:	linux-leds@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds.git
 S:	Maintained
 F:	drivers/leds/
 F:	include/linux/leds.h
_
Subject: Subject: MAINTAINERS: add linux-leds mail list address and git URL

Patches currently in -mm which might be from bryan.wu@canonical.com are

drivers-leds-leds-lp5521c-fix-lp5521_read-error-handling.patch
leds-led-module-for-da9052-53-pmic-v2.patch
leds-simple_strtoul-cleanup.patch
leds-use-kcalloc-instead-of-kzalloc-to-allocate-array.patch
leds-add-new-field-to-led_classdev-struct-to-save-activation-state.patch
leds-change-existing-triggers-to-use-activated-flag.patch
leds-change-ledtrig-timer-to-use-activated-flag.patch
include-linux-led-lm3530h-comment-correction-about-the-range-of-brightness.patch
leds-lm3530-simplify-als-configuration-on-initialization.patch
leds-heartbeat-stop-on-shutdown.patch
leds-add-new-transient-trigger-for-one-shot-timer-activation.patch
drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds.patch
leds-add-lm3533-led-driver.patch
maintainers-add-linux-leds-mail-list-address-and-git-url.patch

