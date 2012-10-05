From: akpm@linux-foundation.org
Subject: [merged] maintainers-fix-indentation-for-viresh-kumar.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:14:36 -0700
Message-ID: <20121005201437.150CD5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:38088 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757235Ab2JEUOj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:14:39 -0400
Received: by mail-bk0-f74.google.com with SMTP id q16so138937bkw.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:14:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, viresh.kumar@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: fix indentation for Viresh Kumar
has been removed from the -mm tree.  Its filename was
     maintainers-fix-indentation-for-viresh-kumar.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: MAINTAINERS: fix indentation for Viresh Kumar

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN MAINTAINERS~maintainers-fix-indentation-for-viresh-kumar MAINTAINERS
--- a/MAINTAINERS~maintainers-fix-indentation-for-viresh-kumar
+++ a/MAINTAINERS
@@ -572,7 +572,7 @@ F:	drivers/net/appletalk/
 F:	net/appletalk/
 
 ARASAN COMPACT FLASH PATA CONTROLLER
-M:     Viresh Kumar <viresh.linux@gmail.com>
+M:	Viresh Kumar <viresh.linux@gmail.com>
 L:	linux-ide@vger.kernel.org
 S:	Maintained
 F:	include/linux/pata_arasan_cf_data.h
@@ -5988,7 +5988,7 @@ S:	Maintained
 F:	drivers/tty/serial
 
 SYNOPSYS DESIGNWARE DMAC DRIVER
-M:     Viresh Kumar <viresh.linux@gmail.com>
+M:	Viresh Kumar <viresh.linux@gmail.com>
 S:	Maintained
 F:	include/linux/dw_dmac.h
 F:	drivers/dma/dw_dmac_regs.h
@@ -6136,7 +6136,7 @@ S:	Maintained
 F:	drivers/mmc/host/sdhci-s3c.c
 
 SECURE DIGITAL HOST CONTROLLER INTERFACE (SDHCI) ST SPEAR DRIVER
-M:     Viresh Kumar <viresh.linux@gmail.com>
+M:	Viresh Kumar <viresh.linux@gmail.com>
 L:	spear-devel@list.st.com
 L:	linux-mmc@vger.kernel.org
 S:	Maintained
@@ -6501,7 +6501,7 @@ S:	Maintained
 F:	include/linux/compiler.h
 
 SPEAR PLATFORM SUPPORT
-M:     Viresh Kumar <viresh.linux@gmail.com>
+M:	Viresh Kumar <viresh.linux@gmail.com>
 M:	Shiraz Hashim <shiraz.hashim@st.com>
 L:	spear-devel@list.st.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
@@ -6510,7 +6510,7 @@ S:	Maintained
 F:	arch/arm/plat-spear/
 
 SPEAR13XX MACHINE SUPPORT
-M:     Viresh Kumar <viresh.linux@gmail.com>
+M:	Viresh Kumar <viresh.linux@gmail.com>
 M:	Shiraz Hashim <shiraz.hashim@st.com>
 L:	spear-devel@list.st.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
@@ -6519,7 +6519,7 @@ S:	Maintained
 F:	arch/arm/mach-spear13xx/
 
 SPEAR3XX MACHINE SUPPORT
-M:     Viresh Kumar <viresh.linux@gmail.com>
+M:	Viresh Kumar <viresh.linux@gmail.com>
 M:	Shiraz Hashim <shiraz.hashim@st.com>
 L:	spear-devel@list.st.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
@@ -6530,7 +6530,7 @@ F:	arch/arm/mach-spear3xx/
 SPEAR6XX MACHINE SUPPORT
 M:	Rajeev Kumar <rajeev-dlh.kumar@st.com>
 M:	Shiraz Hashim <shiraz.hashim@st.com>
-M:     Viresh Kumar <viresh.linux@gmail.com>
+M:	Viresh Kumar <viresh.linux@gmail.com>
 L:	spear-devel@list.st.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.st.com/spear
@@ -6538,7 +6538,7 @@ S:	Maintained
 F:	arch/arm/mach-spear6xx/
 
 SPEAR CLOCK FRAMEWORK SUPPORT
-M:     Viresh Kumar <viresh.linux@gmail.com>
+M:	Viresh Kumar <viresh.linux@gmail.com>
 L:	spear-devel@list.st.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.st.com/spear
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

origin.patch
linux-next.patch

