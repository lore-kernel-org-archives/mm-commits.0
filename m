From: akpm@linux-foundation.org
Subject: [merged]
 arm-dts-fix-wrong-compatible-string-of-exynos3250-rtc-dt-node.patch removed from -mm tree
Date: Tue, 14 Oct 2014 11:20:23 -0700
Message-ID: <543d6967./MTUmxFdjBilH+xp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44231 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487AbaJNSUW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:20:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cw00.choi@samsung.com, a.zummo@towertech.it, kgene.kim@samsung.com, kyungmin.park@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: dts: fix wrong compatible string of Exynos3250 RTC dt node
has been removed from the -mm tree.  Its filename was
     arm-dts-fix-wrong-compatible-string-of-exynos3250-rtc-dt-node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chanwoo Choi <cw00.choi@samsung.com>
Subject: ARM: dts: fix wrong compatible string of Exynos3250 RTC dt node

Fix wrong compatible string of Exynos3250 RTC (Real-Time Clock) dt node. 
The RTC of Exynos3250 must need additional source clock (XrtcXTI).

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
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

origin.patch
linux-next.patch

