From: akpm@linux-foundation.org
Subject: + thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines-add-compilation-dependency-on-plat_spear.patch added to -mm tree
Date: Mon, 27 Feb 2012 15:26:32 -0800
Message-ID: <20120227232632.B0DC9A00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:50700 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341Ab2B0X0f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2012 18:26:35 -0500
Received: by eaaf13 with SMTP id f13so183513eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2012 15:26:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viresh.kumar@st.com, lenb@kernel.org


The patch titled
     Subject: thermal/spear_thermal: Add compilation dependency on PLAT_SPEAR
has been added to the -mm tree.  Its filename is
     thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines-add-compilation-dependency-on-plat_spear.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: thermal/spear_thermal: Add compilation dependency on PLAT_SPEAR

Patches currently in -mm which might be from viresh.kumar@st.com are

linux-next.patch
thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines.patch
thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines-fix.patch
thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines-fix-fix.patch
thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines-add-compilation-dependency-on-plat_spear.patch
thermal-spear_thermal-replace-readl-writel-with-lighter-_relaxed-variants.patch
rtc-spear-fix-for-balancing-the-enable_irq_wake-in-power-mgmt.patch
rtc-spear-fix-for-rtc_aie_on-and-rtc_aie_off-ioctl-errors.patch
rtc-rtc-spear-call-platform_set_drvdata-before-registering-rtc-device.patch

