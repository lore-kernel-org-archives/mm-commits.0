From: akpm@linux-foundation.org
Subject: +
 arch-arm-boot-dts-sun4i-a10dtsi-convert-to-the-new-rtc-compatibles.patch
 added to -mm tree
Date: Fri, 21 Feb 2014 15:39:27 -0800
Message-ID: <5307e3af.a//eDLIxeyLL6oMp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59293 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044AbaBUXj2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 18:39:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, maxime.ripard@free-electrons.com

Subject: + arch-arm-boot-dts-sun4i-a10dtsi-convert-to-the-new-rtc-compatibles.patch added to -mm tree
To: maxime.ripard@free-electrons.com
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 15:39:27 -0800


The patch titled
     Subject: arch/arm/boot/dts/sun4i-a10.dtsi: convert to the new RTC compatibles
has been added to the -mm tree.  Its filename is
     arch-arm-boot-dts-sun4i-a10dtsi-convert-to-the-new-rtc-compatibles.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-arm-boot-dts-sun4i-a10dtsi-convert-to-the-new-rtc-compatibles.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-arm-boot-dts-sun4i-a10dtsi-convert-to-the-new-rtc-compatibles.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: arch/arm/boot/dts/sun4i-a10.dtsi: convert to the new RTC compatibles

Switch the device tree to the new compatibles introduced in the RTC
drivers to have a common pattern accross all Allwinner SoCs.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/boot/dts/sun4i-a10.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/boot/dts/sun4i-a10.dtsi~arch-arm-boot-dts-sun4i-a10dtsi-convert-to-the-new-rtc-compatibles arch/arm/boot/dts/sun4i-a10.dtsi
--- a/arch/arm/boot/dts/sun4i-a10.dtsi~arch-arm-boot-dts-sun4i-a10dtsi-convert-to-the-new-rtc-compatibles
+++ a/arch/arm/boot/dts/sun4i-a10.dtsi
@@ -415,7 +415,7 @@
 		};
 
 		rtc: rtc@01c20d00 {
-			compatible = "allwinner,sun4i-rtc";
+			compatible = "allwinner,sun4i-a10-rtc";
 			reg = <0x01c20d00 0x20>;
 			interrupts = <24>;
 		};
_

Patches currently in -mm which might be from maxime.ripard@free-electrons.com are

backlight-hx8357-remove-unnecessary-oom-messages.patch
drivers-rtc-rtc-sunxic-add-new-compatibles.patch
arch-arm-boot-dts-sun4i-a10dtsi-convert-to-the-new-rtc-compatibles.patch
linux-next.patch

