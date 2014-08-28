From: akpm@linux-foundation.org
Subject: [to-be-updated]
 arm-dts-fix-wrong-compatible-string-of-exynos3250-rtc-dt-node.patch removed from -mm tree
Date: Thu, 28 Aug 2014 14:59:11 -0700
Message-ID: <53ffa62f.8bzBG5WHkW1pYQoN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f201.google.com ([209.85.223.201]:35536 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbaH1WyT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Aug 2014 18:54:19 -0400
Received: by mail-ie0-f201.google.com with SMTP id tr6so418684ieb.4
        for <mm-commits@vger.kernel.org>; Thu, 28 Aug 2014 15:54:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cw00.choi@samsung.com, a.zummo@towertech.it, kgene.kim@samsung.com, kyungmin.park@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: dts: fix wrong compatible string of Exynos3250 RTC dt node
has been removed from the -mm tree.  Its filename was
     arm-dts-fix-wrong-compatible-string-of-exynos3250-rtc-dt-node.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Chanwoo Choi <cw00.choi@samsung.com>
Subject: ARM: dts: fix wrong compatible string of Exynos3250 RTC dt node

Fix wrong compatible string of Exynos3250 RTC (Real-Time Clock) dt node. 
The RTC of Exynos3250 must need additional source clock (XrtcXTI).

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/boot/dts/exynos3250.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/boot/dts/exynos3250.dtsi~arm-dts-fix-wrong-compatible-string-of-exynos3250-rtc-dt-node arch/arm/boot/dts/exynos3250.dtsi
--- a/arch/arm/boot/dts/exynos3250.dtsi~arm-dts-fix-wrong-compatible-string-of-exynos3250-rtc-dt-node
+++ a/arch/arm/boot/dts/exynos3250.dtsi
@@ -164,7 +164,7 @@
 		};
 
 		rtc: rtc@10070000 {
-			compatible = "samsung,s3c6410-rtc";
+			compatible = "samsung,exynos3250-rtc";
 			reg = <0x10070000 0x100>;
 			interrupts = <0 73 0>, <0 74 0>;
 			status = "disabled";
_

Patches currently in -mm which might be from cw00.choi@samsung.com are

rtc-s3c-define-s3c_rtc-structure-to-remove-global-variables.patch
linux-next.patch

