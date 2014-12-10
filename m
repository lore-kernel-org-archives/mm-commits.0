From: akpm@linux-foundation.org
Subject: [folded-merged] rtc-omap-add-support-for-pmic_power_en-v3.patch
 removed from -mm tree
Date: Wed, 10 Dec 2014 15:21:32 -0800
Message-ID: <5488d57c.AZNG6jK9IlW9YtgE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58323 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933125AbaLJXVd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Dec 2014 18:21:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johan@kernel.org, a.zummo@towertech.it, anilkumar@ti.com, balbi@ti.com, bcousson@baylibre.com, colin.foeparker@logicpd.com, j-keerthy@ti.com, linux@roeck-us.net, lokeshvutla@ti.com, nsekhar@ti.com, t-kristo@ti.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: omap: add support for pmic_power_en
has been removed from the -mm tree.  Its filename was
     rtc-omap-add-support-for-pmic_power_en-v3.patch

This patch was dropped because it was folded into rtc-omap-add-support-for-pmic_power_en.patch

------------------------------------------------------
From: Johan Hovold <johan@kernel.org>
Subject: rtc: omap: add support for pmic_power_en

Signed-off-by: Johan Hovold <johan@kernel.org>
Tested-by: Felipe Balbi <balbi@ti.com>
Cc: Colin Foe-Parker <colin.foeparker@logicpd.com>
Cc: AnilKumar Ch <anilkumar@ti.com>
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

 drivers/rtc/rtc-omap.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/rtc/rtc-omap.c~rtc-omap-add-support-for-pmic_power_en-v3 drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-omap-add-support-for-pmic_power_en-v3
+++ a/drivers/rtc/rtc-omap.c
@@ -416,6 +416,8 @@ static void omap_rtc_power_off(void)
 	val = rtc_read(rtc, OMAP_RTC_INTERRUPTS_REG);
 	rtc_writel(rtc, OMAP_RTC_INTERRUPTS_REG,
 			val | OMAP_RTC_INTERRUPTS_IT_ALARM2);
+
+	mdelay(2000);
 }
 
 static struct rtc_class_ops omap_rtc_ops = {
_

Patches currently in -mm which might be from johan@kernel.org are

origin.patch
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
rtc-omap-add-support-for-pmic_power_en-v3-fix.patch
rtc-omap-add-support-for-pmic_power_en-v4.patch
rtc-omap-enable-wake-up-from-power-off.patch
rtc-omap-fix-minor-coding-style-issues.patch
rtc-omap-add-copyright-entry.patch
arm-dts-am33xx-update-rtc-node-compatible-property.patch
arm-dts-am335x-boneblack-enable-power-off-and-rtc-wake-up.patch
rtc-omap-drop-vendor-prefix-from-power-controller-dt-property.patch

