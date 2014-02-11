From: akpm@linux-foundation.org
Subject: + maintainers-add-backlight-co-maintainers.patch added to -mm
 tree
Date: Mon, 10 Feb 2014 16:11:36 -0800
Message-ID: <52f96ab8.+5qs2AwoKiDpzsGm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59954 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbaBKALg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Feb 2014 19:11:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, lee.jones@linaro.org, cooloney@gmail.com, jg1.han@samsung.com

Subject: + maintainers-add-backlight-co-maintainers.patch added to -mm tree
To: jg1.han@samsung.com,cooloney@gmail.com,lee.jones@linaro.org
From: akpm@linux-foundation.org
Date: Mon, 10 Feb 2014 16:11:36 -0800


The patch titled
     Subject: MAINTAINERS: add backlight co-maintainers
has been added to the -mm tree.  Its filename is
     maintainers-add-backlight-co-maintainers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-backlight-co-maintainers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-backlight-co-maintainers.patch

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
Subject: MAINTAINERS: add backlight co-maintainers

Bryan Wu and Lee Jones volunteer to maintain backlight drivers and help to
setup git-tree for backlight subsystem.  Thus, I add them as backlight
co-maintainers.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Bryan Wu <cooloney@gmail.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

diff -puN MAINTAINERS~maintainers-add-backlight-co-maintainers MAINTAINERS
--- a/MAINTAINERS~maintainers-add-backlight-co-maintainers
+++ a/MAINTAINERS
@@ -1695,6 +1695,8 @@ F:	drivers/net/wireless/b43legacy/
 
 BACKLIGHT CLASS/SUBSYSTEM
 M:	Jingoo Han <jg1.han@samsung.com>
+M:	Bryan Wu <cooloney@gmail.com>
+M:	Lee Jones <lee.jones@linaro.org>
 S:	Maintained
 F:	drivers/video/backlight/
 F:	include/linux/backlight.h
_

Patches currently in -mm which might be from jg1.han@samsung.com are

maintainers-add-backlight-co-maintainers.patch
backlight-update-bd-state-fb_blank-properties-when-necessary.patch
backlight-update-backlight-status-when-necessary.patch
backlight-aat2870-remove-unnecessary-oom-messages.patch
backlight-adp8860-remove-unnecessary-oom-messages.patch
backlight-adp8870-remove-unnecessary-oom-messages.patch
backlight-corgi_lcd-remove-unnecessary-oom-messages.patch
backlight-hx8357-remove-unnecessary-oom-messages.patch
backlight-ili922x-remove-unnecessary-oom-messages.patch
backlight-ili9320-remove-unnecessary-oom-messages.patch
backlight-l4f00242t03-remove-unnecessary-oom-messages.patch
backlight-lm3533_bl-remove-unnecessary-oom-messages.patch
backlight-lms283gf05-remove-unnecessary-oom-messages.patch
backlight-platform_lcd-remove-unnecessary-oom-messages.patch
backlight-tps65217_bl-remove-unnecessary-oom-messages.patch
drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch
rtc-rtc-at32ap700x-remove-unnecessary-oom-messages.patch
rtc-rtc-davinci-remove-unnecessary-oom-messages.patch
rtc-rtc-ds1390-remove-unnecessary-oom-messages.patch
rtc-rtc-moxart-remove-unnecessary-oom-messages.patch
rtc-rtc-nuc900-remove-unnecessary-oom-messages.patch
rtc-rtc-pm8xxx-remove-unnecessary-oom-messages.patch
rtc-rtc-rx8025-remove-unnecessary-oom-messages.patch
rtc-rtc-sirfsoc-remove-unnecessary-oom-messages.patch
rtc-rtc-lpc32xx-remove-unnecessary-oom-messages.patch
rtc-rtc-spear-remove-unnecessary-oom-messages.patch
rtc-rtc-coh901331-use-devm_ioremap_resource.patch
rtc-rtc-davinci-use-devm_ioremap_resource.patch
rtc-rtc-vt8500-use-devm_ioremap_resource.patch
rtc-rtc-jz4740-use-devm_ioremap_resource.patch
linux-next.patch

