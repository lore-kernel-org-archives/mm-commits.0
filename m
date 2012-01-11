From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-various-arm-f-patterns.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:29:00 -0800
Message-ID: <20120111212901.0BAC05C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:62274 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932654Ab2AKV3C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:29:02 -0500
Received: by mail-ey0-f202.google.com with SMTP id d12so32568eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:29:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, linux@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update various arm F: patterns
has been removed from the -mm tree.  Its filename was
     maintainers-update-various-arm-f-patterns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: update various arm F: patterns

Track renames and missing or deleted files.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN MAINTAINERS~maintainers-update-various-arm-f-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-various-arm-f-patterns
+++ a/MAINTAINERS
@@ -914,7 +914,6 @@ M:	Lennert Buytenhek <kernel@wantstofly.
 M:	Nicolas Pitre <nico@fluxnic.net>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Odd Fixes
-F:	arch/arm/mach-loki/
 F:	arch/arm/mach-kirkwood/
 F:	arch/arm/mach-mv78xx0/
 F:	arch/arm/mach-orion5x/
@@ -1076,8 +1075,8 @@ L:	linux-arm-kernel@lists.infradead.org 
 S:	Maintained
 F:	arch/arm/mach-s5pv210/mach-aquila.c
 F:	arch/arm/mach-s5pv210/mach-goni.c
-F:	arch/arm/mach-exynos4/mach-universal_c210.c
-F:	arch/arm/mach-exynos4/mach-nuri.c
+F:	arch/arm/mach-exynos/mach-universal_c210.c
+F:	arch/arm/mach-exynos/mach-nuri.c
 
 ARM/SAMSUNG S5P SERIES FIMC SUPPORT
 M:	Kyungmin Park <kyungmin.park@samsung.com>
@@ -1105,7 +1104,6 @@ M:	Tomasz Stanislawski <t.stanislaws@sam
 L:	linux-arm-kernel@lists.infradead.org
 L:	linux-media@vger.kernel.org
 S:	Maintained
-F:	arch/arm/plat-s5p/dev-tv.c
 F:	drivers/media/video/s5p-tv/
 
 ARM/SHMOBILE ARM ARCHITECTURE
@@ -1140,7 +1138,6 @@ L:	linux-arm-kernel@lists.infradead.org 
 W:	http://www.mcuos.com
 S:	Maintained
 F:	arch/arm/mach-w90x900/
-F:	arch/arm/mach-nuc93x/
 F:	drivers/input/keyboard/w90p910_keypad.c
 F:	drivers/input/touchscreen/w90p910_ts.c
 F:	drivers/watchdog/nuc900_wdt.c
@@ -6180,9 +6177,7 @@ M:	Viresh Kumar <viresh.kumar@st.com>
 W:	http://www.st.com/spear
 S:	Maintained
 F:	arch/arm/mach-spear*/clock.c
-F:	arch/arm/mach-spear*/include/mach/clkdev.h
 F:	arch/arm/plat-spear/clock.c
-F:	arch/arm/plat-spear/include/plat/clkdev.h
 F:	arch/arm/plat-spear/include/plat/clock.h
 
 SPEAR PAD MULTIPLEXING SUPPORT
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-staging-cx25821-add-l-linux-media.patch
kernelh-neaten-panic-prototype.patch
linkage-remove-unused-noret_and-macro.patch
treewide-remove-useless-noret_type-macro-and-uses.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
linkage-remove-unused-attrib_noret-macro.patch

