From: akpm@linux-foundation.org
Subject: [merged]
 maintainers-update-arm-qualcomm-support-patterns.patch removed from -mm
 tree
Date: Wed, 07 Feb 2018 12:00:56 -0800
Message-ID: <20180207200056.BaYWEEl5w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60828 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753721AbeBGUA5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 15:00:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andy.gross@linaro.org, david.brown@linaro.org, joe@perches.com, mm-commits@vger.kernel.org, sboyd@codeaurora.org


The patch titled
     Subject: MAINTAINERS: update ARM/QUALCOMM SUPPORT patterns
has been removed from the -mm tree.  Its filename was
     maintainers-update-arm-qualcomm-support-patterns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


