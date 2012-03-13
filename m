From: akpm@linux-foundation.org
Subject: + maintainers-update-sts-mailing-list-for-spear.patch added to -mm tree
Date: Tue, 13 Mar 2012 15:12:09 -0700
Message-ID: <20120313221209.B6449A00AB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:45498 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828Ab2CMWML (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Mar 2012 18:12:11 -0400
Received: by ghbz15 with SMTP id z15so179667ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Mar 2012 15:12:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viresh.kumar@st.com, rmk@arm.linux.org.uk


The patch titled
     Subject: MAINTAINERS: update ST's Mailing list for SPEAr
has been added to the -mm tree.  Its filename is
     maintainers-update-sts-mailing-list-for-spear.patch

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
Subject: MAINTAINERS: update ST's Mailing list for SPEAr

We have created a ST's Mailing list for SPEAr.  This can be accessed from
non-st email ids.  I want people to cc this list, when they have changes
specific to SPEAr.  So, its better to get this updated in MAINTAINERS
file.

-arm-kernel@lists.infradead.org is also added for SPEAr.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN MAINTAINERS~maintainers-update-sts-mailing-list-for-spear MAINTAINERS
--- a/MAINTAINERS~maintainers-update-sts-mailing-list-for-spear
+++ a/MAINTAINERS
@@ -5944,6 +5944,7 @@ F:	drivers/mmc/host/sdhci-s3c.c
 
 SECURE DIGITAL HOST CONTROLLER INTERFACE (SDHCI) ST SPEAR DRIVER
 M:	Viresh Kumar <viresh.kumar@st.com>
+L:	spear-devel@list.st.com
 L:	linux-mmc@vger.kernel.org
 S:	Maintained
 F:	drivers/mmc/host/sdhci-spear.c
@@ -6287,24 +6288,32 @@ F:	drivers/tty/serial/sunzilog.h
 
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
@@ -6313,6 +6322,8 @@ F:	arch/arm/plat-spear/include/plat/cloc
 
 SPEAR PAD MULTIPLEXING SUPPORT
 M:	Viresh Kumar <viresh.kumar@st.com>
+L:	spear-devel@list.st.com
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.st.com/spear
 S:	Maintained
 F:	arch/arm/plat-spear/include/plat/padmux.h
_
Subject: Subject: MAINTAINERS: update ST's Mailing list for SPEAr

Patches currently in -mm which might be from viresh.kumar@st.com are

maintainers-update-sts-mailing-list-for-spear.patch
linux-next.patch
thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines.patch
thermal-spear_thermal-replace-readl-writel-with-lighter-_relaxed-variants.patch
thermal-spear13xx-checking-for-null-instead-of-is_err.patch
rtc-spear-fix-for-balancing-the-enable_irq_wake-in-power-mgmt.patch
rtc-spear-fix-for-rtc_aie_on-and-rtc_aie_off-ioctl-errors.patch
rtc-rtc-spear-call-platform_set_drvdata-before-registering-rtc-device.patch

