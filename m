From: akpm@linux-foundation.org
Subject: [merged]
 maintainers-add-entry-for-maxim-pmics-on-samsung-boards.patch removed from
 -mm tree
Date: Tue, 17 Feb 2015 12:06:39 -0800
Message-ID: <54e39f4f.g4usdvyr+/8mPkm1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35379 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbbBQUGk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Feb 2015 15:06:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, a.zummo@towertech.it, broonie@kernel.org, cw00.choi@samsung.com, lee.jones@linaro.org, lgirdwood@gmail.com, mturquette@linaro.org, myungjoo.ham@samsung.com, sameo@linux.intel.com, sboyd@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add entry for Maxim PMICs on Samsung boards
has been removed from the -mm tree.  Its filename was
     maintainers-add-entry-for-maxim-pmics-on-samsung-boards.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: MAINTAINERS: add entry for Maxim PMICs on Samsung boards

Add myself and Chanwoo Choi as supporters to help in reviewing patches
for Maxim 77686 PMIC and Maxim 14577/77693 MUIC drivers:
 - mfd (all of them),
 - extcon (extcon-max14577.c, extcon-max77693.c),
 - regulator (all of them),
 - clock (clk-max77686.c),
 - RTC (rtc-max77686.c).

Lately I am the author of contributors to them. These drivers are used
on Exynos-based boards (Trats 2, Gear 1 and Gear 2).

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Acked-by: Mark Brown <broonie@kernel.org>
Acked-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff -puN MAINTAINERS~maintainers-add-entry-for-maxim-pmics-on-samsung-boards MAINTAINERS
--- a/MAINTAINERS~maintainers-add-entry-for-maxim-pmics-on-samsung-boards
+++ a/MAINTAINERS
@@ -6216,6 +6216,26 @@ S:	Supported
 F:	drivers/power/max14577_charger.c
 F:	drivers/power/max77693_charger.c
 
+MAXIM PMIC AND MUIC DRIVERS FOR EXYNOS BASED BOARDS
+M:	Chanwoo Choi <cw00.choi@samsung.com>
+M:	Krzysztof Kozlowski <k.kozlowski@samsung.com>
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+F:	drivers/*/max14577.c
+F:	drivers/*/max77686.c
+F:	drivers/*/max77693.c
+F:	drivers/extcon/extcon-max14577.c
+F:	drivers/extcon/extcon-max77693.c
+F:	drivers/rtc/rtc-max77686.c
+F:	drivers/clk/clk-max77686.c
+F:	Documentation/devicetree/bindings/mfd/max14577.txt
+F:	Documentation/devicetree/bindings/mfd/max77686.txt
+F:	Documentation/devicetree/bindings/mfd/max77693.txt
+F:	Documentation/devicetree/bindings/clock/maxim,max77686.txt
+F:	include/linux/mfd/max14577*.h
+F:	include/linux/mfd/max77686*.h
+F:	include/linux/mfd/max77693*.h
+
 MAXIRADIO FM RADIO RECEIVER DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

origin.patch
linux-next.patch

