From: akpm@linux-foundation.org
Subject: + maintainers-update-cortina-gemini-patterns.patch added to -mm
 tree
Date: Mon, 29 Jan 2018 15:40:33 -0800
Message-ID: <5a6fb0f1.hgOVnU+nLSOH2t8X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50916 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751547AbeA2Xke (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jan 2018 18:40:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, akpm@linux-foundation.org, davem@davemloft.net, linus.walleij@linaro.org, ulli.kroll@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update Cortina/Gemini patterns
has been added to the -mm tree.  Its filename is
     maintainers-update-cortina-gemini-patterns.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-update-cortina-gemini-patterns.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-update-cortina-gemini-patterns.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: update Cortina/Gemini patterns

4d5ae32f5e1e ("net: ethernet: Add a driver for Gemini gigabit ethernet")
added invalid patterns.  Fix it.

Link: http://lkml.kernel.org/r/65b104609e0071d0fbe0dcce3a8e6138a4cf8c25.1517147485.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Hans Ulli Kroll <ulli.kroll@googlemail.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-cortina-gemini-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-cortina-gemini-patterns
+++ a/MAINTAINERS
@@ -1358,7 +1358,7 @@ F:	Documentation/devicetree/bindings/pin
 F:	Documentation/devicetree/bindings/net/cortina,gemini-ethernet.txt
 F:	Documentation/devicetree/bindings/rtc/faraday,ftrtc010.txt
 F:	arch/arm/mach-gemini/
-F:	drivers/net/ethernet/cortina/gemini/*
+F:	drivers/net/ethernet/cortina/
 F:	drivers/pinctrl/pinctrl-gemini.c
 F:	drivers/rtc/rtc-ftrtc010.c
 
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-ignore-some-octal-permissions-of-0.patch
checkpatch-improve-quoted-string-and-line-continuation-test.patch
checkpatch-add-a-few-device_attr-style-tests.patch
checkpatch-improve-the-tabstop-test-to-include-declarations.patch
checkpatch-exclude-drivers-staging-from-if-with-unnecessary-parentheses-test.patch
checkpatch-avoid-some-false-positives-for-tabstop-declaration-test.patch
maintainers-remove-android-ion-pattern.patch
maintainers-remove-arm-clkdev-support-file-pattern.patch
maintainers-update-cortina-gemini-patterns.patch
maintainers-update-arm-oxnas-platform-support-patterns.patch
maintainers-update-various-palm-patterns.patch
maintainers-update-arm-qualcomm-support-patterns.patch

