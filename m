From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-sts-mailing-list-for-spear.patch removed from -mm tree
Date: Fri, 16 Mar 2012 13:57:53 -0700
Message-ID: <20120316205753.62E4BA0128@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:34173 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031874Ab2CPU5z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Mar 2012 16:57:55 -0400
Received: by faaa19 with SMTP id a19so211243faa.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Mar 2012 13:57:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viresh.kumar@st.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update ST's Mailing list for SPEAr
has been removed from the -mm tree.  Its filename was
     maintainers-update-sts-mailing-list-for-spear.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Viresh Kumar <viresh.kumar@st.com>
Subject: MAINTAINERS: update ST's Mailing list for SPEAr

We have created a ST's Mailing list for SPEAr.  This can be accessed from
non-st email ids.  I want people to cc this list, when they have changes
specific to SPEAr.  So, its better to get this updated in MAINTAINERS
file.

linux-arm-kernel@lists.infradead.org is also added for SPEAr.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN MAINTAINERS~maintainers-update-sts-mailing-list-for-spear MAINTAINERS
--- a/MAINTAINERS~maintainers-update-sts-mailing-list-for-spear
+++ a/MAINTAINERS
@@ -5859,6 +5859,7 @@ F:	drivers/mmc/host/sdhci-s3c.c
 
 SECURE DIGITAL HOST CONTROLLER INTERFACE (SDHCI) ST SPEAR DRIVER
 M:	Viresh Kumar <viresh.kumar@st.com>
+L:	spear-devel@list.st.com
 L:	linux-mmc@vger.kernel.org
 S:	Maintained
 F:	drivers/mmc/host/sdhci-spear.c
@@ -6201,24 +6202,32 @@ F:	drivers/tty/serial/sunzilog.h
 
 SPEAR PLATFORM SUPPORT
 M:	Viresh Kumar <viresh.kumar@st.com>
+L:	spear-devel@list.st.com
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.st.com/spear
 S:	Maintained
 F:	arch/arm/plat-spear/
 
 SPEAR3XX MACHINE SUPPORT
 M:	Viresh Kumar <viresh.kumar@st.com>
+L:	spear-devel@list.st.com
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.st.com/spear
 S:	Maintained
 F:	arch/arm/mach-spear3xx/
 
 SPEAR6XX MACHINE SUPPORT
 M:	Rajeev Kumar <rajeev-dlh.kumar@st.com>
+L:	spear-devel@list.st.com
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.st.com/spear
 S:	Maintained
 F:	arch/arm/mach-spear6xx/
 
 SPEAR CLOCK FRAMEWORK SUPPORT
 M:	Viresh Kumar <viresh.kumar@st.com>
+L:	spear-devel@list.st.com
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.st.com/spear
 S:	Maintained
 F:	arch/arm/mach-spear*/clock.c
@@ -6227,6 +6236,8 @@ F:	arch/arm/plat-spear/include/plat/cloc
 
 SPEAR PAD MULTIPLEXING SUPPORT
 M:	Viresh Kumar <viresh.kumar@st.com>
+L:	spear-devel@list.st.com
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.st.com/spear
 S:	Maintained
 F:	arch/arm/plat-spear/include/plat/padmux.h
_

Patches currently in -mm which might be from viresh.kumar@st.com are

origin.patch
linux-next.patch
thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines.patch
thermal-spear_thermal-replace-readl-writel-with-lighter-_relaxed-variants.patch
thermal-spear13xx-checking-for-null-instead-of-is_err.patch
rtc-spear-fix-for-balancing-the-enable_irq_wake-in-power-mgmt.patch
rtc-spear-fix-for-rtc_aie_on-and-rtc_aie_off-ioctl-errors.patch
rtc-rtc-spear-call-platform_set_drvdata-before-registering-rtc-device.patch

