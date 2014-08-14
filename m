From: akpm@linux-foundation.org
Subject: +
 arm-dts-fix-wrong-compatible-string-of-exynos3250-rtc-dt-node.patch added
 to -mm tree
Date: Thu, 14 Aug 2014 15:23:50 -0700
Message-ID: <53ed36f6.uFMX7xCktH2AUpsx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f73.google.com ([209.85.218.73]:59913 "EHLO
	mail-oi0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbaHNWXv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Aug 2014 18:23:51 -0400
Received: by mail-oi0-f73.google.com with SMTP id u20so388488oif.2
        for <mm-commits@vger.kernel.org>; Thu, 14 Aug 2014 15:23:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cw00.choi@samsung.com, a.zummo@towertech.it, kgene.kim@samsung.com, kyungmin.park@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: dts: fix wrong compatible string of Exynos3250 RTC dt node
has been added to the -mm tree.  Its filename is
     arm-dts-fix-wrong-compatible-string-of-exynos3250-rtc-dt-node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm-dts-fix-wrong-compatible-string-of-exynos3250-rtc-dt-node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm-dts-fix-wrong-compatible-string-of-exynos3250-rtc-dt-node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

origin.patch
rtc-s3c-define-s3c_rtc-structure-to-remove-global-variables.patch
rtc-s3c-remove-warning-message-when-checking-coding-style-with-checkpatch-script.patch
rtc-s3c-add-s3c_rtc_data-structure-to-use-variant-data-instead-of-s3c_cpu_type.patch
rtc-s3c-add-support-for-rtc-of-exynos3250-soc.patch
arm-dts-fix-wrong-compatible-string-of-exynos3250-rtc-dt-node.patch

