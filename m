From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-omap-cpufreq-driver-to-omap-power-management-section.patch removed from -mm tree
Date: Thu, 12 Jul 2012 12:37:18 -0700
Message-ID: <20120712193718.B149D100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:60493 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030750Ab2GLThT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 15:37:19 -0400
Received: by mail-vc0-f202.google.com with SMTP id p1so16661vcq.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 12:37:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khilman@ti.com, arnd@arndb.de, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add OMAP CPUfreq driver to OMAP Power Management section
has been removed from the -mm tree.  Its filename was
     maintainers-add-omap-cpufreq-driver-to-omap-power-management-section.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kevin Hilman <khilman@ti.com>
Subject: MAINTAINERS: add OMAP CPUfreq driver to OMAP Power Management section

Add the OMAP CPUFreq driver to the list of files in the OMAP Power
Management section.

I've already been maintaining this driver, this just makes it official.

Signed-off-by: Kevin Hilman <khilman@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-add-omap-cpufreq-driver-to-omap-power-management-section MAINTAINERS
--- a/MAINTAINERS~maintainers-add-omap-cpufreq-driver-to-omap-power-management-section
+++ a/MAINTAINERS
@@ -4857,6 +4857,7 @@ M:	Kevin Hilman <khilman@ti.com>
 L:	linux-omap@vger.kernel.org
 S:	Maintained
 F:	arch/arm/*omap*/*pm*
+F:	drivers/cpufreq/omap-cpufreq.c
 
 OMAP POWERDOMAIN/CLOCKDOMAIN SOC ADAPTATION LAYER SUPPORT
 M:	Rajendra Nayak <rnayak@ti.com>
_

Patches currently in -mm which might be from khilman@ti.com are

origin.patch
linux-next.patch

