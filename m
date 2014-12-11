From: akpm@linux-foundation.org
Subject: [merged] arm-dts-am33xx-update-rtc-node-compatible-property.patch removed from -mm tree
Date: Thu, 11 Dec 2014 11:07:00 -0800
Message-ID: <5489eb54./KcmY3QU3b1CaJEP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45890 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031AbaLKTHB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:07:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johan@kernel.org, a.zummo@towertech.it, balbi@ti.com, bcousson@baylibre.com, j-keerthy@ti.com, linux@roeck-us.net, lokeshvutla@ti.com, nsekhar@ti.com, t-kristo@ti.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: dts: am33xx: update rtc-node compatible property
has been removed from the -mm tree.  Its filename was
     arm-dts-am33xx-update-rtc-node-compatible-property.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johan Hovold <johan@kernel.org>
Subject: ARM: dts: am33xx: update rtc-node compatible property

Enable am33xx specific RTC features (e.g. PMIC control) by adding
"ti,am3352-rtc" to the compatible property of the rtc node.

Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Felipe Balbi <balbi@ti.com>
Tested-by: Felipe Balbi <balbi@ti.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Benot Cousson <bcousson@baylibre.com>
Cc: Lokesh Vutla <lokeshvutla@ti.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Tero Kristo <t-kristo@ti.com>
Cc: Keerthy J <j-keerthy@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/boot/dts/am33xx.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/boot/dts/am33xx.dtsi~arm-dts-am33xx-update-rtc-node-compatible-property arch/arm/boot/dts/am33xx.dtsi
--- a/arch/arm/boot/dts/am33xx.dtsi~arm-dts-am33xx-update-rtc-node-compatible-property
+++ a/arch/arm/boot/dts/am33xx.dtsi
@@ -435,7 +435,7 @@
 		};
 
 		rtc: rtc@44e3e000 {
-			compatible = "ti,da830-rtc";
+			compatible = "ti,am3352-rtc", "ti,da830-rtc";
 			reg = <0x44e3e000 0x1000>;
 			interrupts = <75
 				      76>;
_

Patches currently in -mm which might be from johan@kernel.org are

origin.patch
linux-next.patch

