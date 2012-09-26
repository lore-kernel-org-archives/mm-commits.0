From: akpm@linux-foundation.org
Subject: + maintainers-fix-indentation-for-viresh-kumar.patch added to -mm tree
Date: Wed, 26 Sep 2012 14:32:32 -0700
Message-ID: <20120926213232.94D82100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:50711 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab2IZVcd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Sep 2012 17:32:33 -0400
Received: by yenr11 with SMTP id r11so132055yen.1
        for <mm-commits@vger.kernel.org>; Wed, 26 Sep 2012 14:32:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andriy.shevchenko@linux.intel.com, viresh.kumar@linaro.org


The patch titled
     Subject: MAINTAINERS: fix indentation for Viresh Kumar
has been added to the -mm tree.  Its filename is
     maintainers-fix-indentation-for-viresh-kumar.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -5998,7 +5998,7 @@ S:	Maintained
 F:	drivers/tty/serial
 
 SYNOPSYS DESIGNWARE DMAC DRIVER
-M:     Viresh Kumar <viresh.linux@gmail.com>
+M:	Viresh Kumar <viresh.linux@gmail.com>
 S:	Maintained
 F:	include/linux/dw_dmac.h
 F:	drivers/dma/dw_dmac_regs.h
@@ -6146,7 +6146,7 @@ S:	Maintained
 F:	drivers/mmc/host/sdhci-s3c.c
 
 SECURE DIGITAL HOST CONTROLLER INTERFACE (SDHCI) ST SPEAR DRIVER
-M:     Viresh Kumar <viresh.linux@gmail.com>
+M:	Viresh Kumar <viresh.linux@gmail.com>
 L:	spear-devel@list.st.com
 L:	linux-mmc@vger.kernel.org
 S:	Maintained
@@ -6512,7 +6512,7 @@ S:	Maintained
 F:	include/linux/compiler.h
 
 SPEAR PLATFORM SUPPORT
-M:     Viresh Kumar <viresh.linux@gmail.com>
+M:	Viresh Kumar <viresh.linux@gmail.com>
 M:	Shiraz Hashim <shiraz.hashim@st.com>
 L:	spear-devel@list.st.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
@@ -6521,7 +6521,7 @@ S:	Maintained
 F:	arch/arm/plat-spear/
 
 SPEAR13XX MACHINE SUPPORT
-M:     Viresh Kumar <viresh.linux@gmail.com>
+M:	Viresh Kumar <viresh.linux@gmail.com>
 M:	Shiraz Hashim <shiraz.hashim@st.com>
 L:	spear-devel@list.st.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
@@ -6530,7 +6530,7 @@ S:	Maintained
 F:	arch/arm/mach-spear13xx/
 
 SPEAR3XX MACHINE SUPPORT
-M:     Viresh Kumar <viresh.linux@gmail.com>
+M:	Viresh Kumar <viresh.linux@gmail.com>
 M:	Shiraz Hashim <shiraz.hashim@st.com>
 L:	spear-devel@list.st.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
@@ -6541,7 +6541,7 @@ F:	arch/arm/mach-spear3xx/
 SPEAR6XX MACHINE SUPPORT
 M:	Rajeev Kumar <rajeev-dlh.kumar@st.com>
 M:	Shiraz Hashim <shiraz.hashim@st.com>
-M:     Viresh Kumar <viresh.linux@gmail.com>
+M:	Viresh Kumar <viresh.linux@gmail.com>
 L:	spear-devel@list.st.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.st.com/spear
@@ -6549,7 +6549,7 @@ S:	Maintained
 F:	arch/arm/mach-spear6xx/
 
 SPEAR CLOCK FRAMEWORK SUPPORT
-M:     Viresh Kumar <viresh.linux@gmail.com>
+M:	Viresh Kumar <viresh.linux@gmail.com>
 L:	spear-devel@list.st.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.st.com/spear
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

linux-next.patch
lib-vsprintf-update-documentation-to-cover-all-of-%p.patch
maintainers-fix-indentation-for-viresh-kumar.patch

