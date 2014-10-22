From: akpm@linux-foundation.org
Subject: + arm-dts-am33xx-update-rtc-node-compatible-property.patch added
 to -mm tree
Date: Wed, 22 Oct 2014 12:04:47 -0700
Message-ID: <5447ffcf.T1P4m2wpb7JxRD8x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56504 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932306AbaJVTEr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Oct 2014 15:04:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johan@kernel.org, a.zummo@towertech.it, balbi@ti.com, bcousson@baylibre.com, j-keerthy@ti.com, linux@roeck-us.net, lokeshvutla@ti.com, nsekhar@ti.com, t-kristo@ti.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: dts: am33xx: update rtc-node compatible property
has been added to the -mm tree.  Its filename is
     arm-dts-am33xx-update-rtc-node-compatible-property.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm-dts-am33xx-update-rtc-node-compatible-property.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm-dts-am33xx-update-rtc-node-compatible-property.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johan Hovold <johan@kernel.org>
Subject: ARM: dts: am33xx: update rtc-node compatible property

Enable am33xx specific RTC features (e.g. PMIC control) by adding
"ti,am3352-rtc" to the compatible property of the rtc node.

Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Felipe Balbi <balbi@ti.com>
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
@@ -419,7 +419,7 @@
 		};
 
 		rtc: rtc@44e3e000 {
-			compatible = "ti,da830-rtc";
+			compatible = "ti,am3352-rtc", "ti,da830-rtc";
 			reg = <0x44e3e000 0x1000>;
 			interrupts = <75
 				      76>;
_

Patches currently in -mm which might be from johan@kernel.org are

rtc-omap-fix-clock-source-configuration.patch
rtc-omap-fix-missing-wakealarm-attribute.patch
rtc-omap-fix-interrupt-disable-at-probe.patch
rtc-omap-clean-up-probe-error-handling.patch
rtc-omap-fix-class-device-registration.patch
rtc-omap-remove-unused-register-base-define.patch
rtc-omap-use-dev_info.patch
rtc-omap-make-platform-device-id-table-const.patch
rtc-omap-add-device-abstraction.patch
rtc-omap-remove-driver_name-macro.patch
rtc-omap-add-structured-device-type-info.patch
rtc-omap-silence-bogus-power-up-reset-message-at-probe.patch
rtc-omap-add-helper-to-read-raw-bcd-time.patch
rtc-omap-add-helper-to-read-32-bit-registers.patch
rtc-omap-add-support-for-pmic_power_en.patch
rtc-omap-enable-wake-up-from-power-off.patch
rtc-omap-fix-minor-coding-style-issues.patch
rtc-omap-add-copyright-entry.patch
arm-dts-am33xx-update-rtc-node-compatible-property.patch
arm-dts-am335x-boneblack-enable-power-off-and-rtc-wake-up.patch
linux-next.patch

