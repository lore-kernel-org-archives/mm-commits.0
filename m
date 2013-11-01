From: akpm@linux-foundation.org
Subject: +
 drivers-video-backlight-hx8357c-remove-redundant-of_match_ptr.patch added
 to -mm tree
Date: Fri, 01 Nov 2013 14:59:57 -0700
Message-ID: <5274245d.+luoqJkU9Ctxa1cI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54850 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab3KAV76 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Nov 2013 17:59:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, maxime.ripard@free-electrons.com, jg1.han@samsung.com, sachin.kamat@linaro.org

Subject: + drivers-video-backlight-hx8357c-remove-redundant-of_match_ptr.patch added to -mm tree
To: sachin.kamat@linaro.org,jg1.han@samsung.com,maxime.ripard@free-electrons.com
From: akpm@linux-foundation.org
Date: Fri, 01 Nov 2013 14:59:57 -0700


The patch titled
     Subject: drivers/video/backlight/hx8357.c: remove redundant of_match_ptr
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-hx8357c-remove-redundant-of_match_ptr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-video-backlight-hx8357c-remove-redundant-of_match_ptr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-video-backlight-hx8357c-remove-redundant-of_match_ptr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/video/backlight/hx8357.c: remove redundant of_match_ptr

'hx8357_dt_ids' is always compiled in.  Hence of_match_ptr is not needed.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/hx8357.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/hx8357.c~drivers-video-backlight-hx8357c-remove-redundant-of_match_ptr drivers/video/backlight/hx8357.c
--- a/drivers/video/backlight/hx8357.c~drivers-video-backlight-hx8357c-remove-redundant-of_match_ptr
+++ a/drivers/video/backlight/hx8357.c
@@ -673,7 +673,7 @@ static struct spi_driver hx8357_driver =
 	.probe  = hx8357_probe,
 	.driver = {
 		.name = "hx8357",
-		.of_match_table = of_match_ptr(hx8357_dt_ids),
+		.of_match_table = hx8357_dt_ids,
 	},
 };
 
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

drivers-video-backlight-hx8357c-remove-redundant-of_match_ptr.patch
drivers-rtc-rtc-ds1307c-release-irq-on-error.patch
drivers-rtc-rtc-isl1208c-remove-redundant-checks.patch
drivers-rtc-rtc-max6900c-remove-redundant-checks.patch
drivers-rtc-rtc-vt8500c-fix-return-value.patch
drivers-rtc-rtc-at91rm9200c-use-devm_-apis.patch
drivers-rtc-rtc-isl1208c-use-devm_-apis.patch
drivers-rtc-rtc-sirfsocc-use-devm_rtc_device_register.patch
drivers-rtc-rtc-cmosc-remove-redundant-dev_set_drvdata.patch
drivers-rtc-rtc-mrstc-remove-redundant-dev_set_drvdata.patch
drivers-rtc-rtc-vr41xxc-fix-checkpatch-warnings.patch
drivers-rtc-rtc-vt8500c-remove-redundant-of_match_ptr.patch
drivers-rtc-rtc-omapc-remove-redundant-of_match_ptr.patch
drivers-rtc-rtc-sirfsocc-remove-redundant-of_match_ptr.patch
drivers-rtc-rtc-snvsc-remove-redundant-of_match_ptr.patch
drivers-rtc-rtc-stmp3xxxc-remove-redundant-of_match_ptr.patch
rtc-s5m-rtc-add-real-time-clock-driver-for-s5m8767.patch
drivers-pps-clients-pps-gpioc-remove-redundant-of_match_ptr.patch
linux-next.patch

