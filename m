From: akpm@linux-foundation.org
Subject: + maintainers-update-arm-qualcomm-support-patterns.patch added to -mm tree
Date: Mon, 29 Jan 2018 15:40:44 -0800
Message-ID: <5a6fb0fc.KdKgP+QawkhAf6fB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50976 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751547AbeA2Xkp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jan 2018 18:40:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, akpm@linux-foundation.org, andy.gross@linaro.org, david.brown@linaro.org, sboyd@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update ARM/QUALCOMM SUPPORT patterns
has been added to the -mm tree.  Its filename is
     maintainers-update-arm-qualcomm-support-patterns.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-update-arm-qualcomm-support-patterns.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-update-arm-qualcomm-support-patterns.patch

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
Subject: MAINTAINERS: update ARM/QUALCOMM SUPPORT patterns

321737416c72d ("tty: serial: msm: Move header file into driver") removed
the .h file, update the patterns.

Link: http://lkml.kernel.org/r/2b7478bc4c35ab3ac6b06b4edd3b645a8c34a4a2.1517147485.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Andy Gross <andy.gross@linaro.org>
Cc: David Brown <david.brown@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-arm-qualcomm-support-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-arm-qualcomm-support-patterns
+++ a/MAINTAINERS
@@ -1793,7 +1793,6 @@ F:	drivers/clk/qcom/
 F:	drivers/dma/qcom/
 F:	drivers/soc/qcom/
 F:	drivers/spi/spi-qup.c
-F:	drivers/tty/serial/msm_serial.h
 F:	drivers/tty/serial/msm_serial.c
 F:	drivers/*/pm8???-*
 F:	drivers/mfd/ssbi.c
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

