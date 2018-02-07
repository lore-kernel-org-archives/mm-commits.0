From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-cortina-gemini-patterns.patch
 removed from -mm tree
Date: Wed, 07 Feb 2018 12:00:46 -0800
Message-ID: <20180207200046.fIXR9AULI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60764 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753721AbeBGUAr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 15:00:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, joe@perches.com, linus.walleij@linaro.org, mm-commits@vger.kernel.org, ulli.kroll@googlemail.com


The patch titled
     Subject: MAINTAINERS: update Cortina/Gemini patterns
has been removed from the -mm tree.  Its filename was
     maintainers-update-cortina-gemini-patterns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


