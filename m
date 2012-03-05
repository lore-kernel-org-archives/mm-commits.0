From: akpm@linux-foundation.org
Subject: [folded] thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines-add-compilation-dependency-on-plat_spear.patch removed from -mm tree
Date: Mon, 05 Mar 2012 15:09:58 -0800
Message-ID: <20120305230958.A8ED6A02EB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:62520 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757410Ab2CEXKB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Mar 2012 18:10:01 -0500
Received: by wejx9 with SMTP id x9so180532wej.1
        for <mm-commits@vger.kernel.org>; Mon, 05 Mar 2012 15:09:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viresh.kumar@st.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: thermal/spear_thermal: Add compilation dependency on PLAT_SPEAR
has been removed from the -mm tree.  Its filename was
     thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines-add-compilation-dependency-on-plat_spear.patch

This patch was dropped because it was folded into thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Viresh Kumar <viresh.kumar@st.com>
Subject: thermal/spear_thermal: Add compilation dependency on PLAT_SPEAR

spear_thermal is a proprietary module used for SPEAr machines only.  Add
compile dependency in Kconfig for PLAT_SPEAR.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/thermal/Kconfig~thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines-add-compilation-dependency-on-plat_spear drivers/thermal/Kconfig
--- a/drivers/thermal/Kconfig~thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines-add-compilation-dependency-on-plat_spear
+++ a/drivers/thermal/Kconfig
@@ -22,6 +22,7 @@ config THERMAL_HWMON
 config SPEAR_THERMAL
 	bool "SPEAr thermal sensor driver"
 	depends on THERMAL
+	depends on PLAT_SPEAR
 	help
 	  Enable this to plug the SPEAr thermal sensor driver into the Linux
 	  thermal framework
_

Patches currently in -mm which might be from viresh.kumar@st.com are

linux-next.patch
thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines.patch
thermal-spear_thermal-replace-readl-writel-with-lighter-_relaxed-variants.patch
thermal-spear13xx-checking-for-null-instead-of-is_err.patch
rtc-spear-fix-for-balancing-the-enable_irq_wake-in-power-mgmt.patch
rtc-spear-fix-for-rtc_aie_on-and-rtc_aie_off-ioctl-errors.patch
rtc-rtc-spear-call-platform_set_drvdata-before-registering-rtc-device.patch

