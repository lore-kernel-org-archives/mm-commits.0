From: akpm@linux-foundation.org
Subject: [patch 111/114] MAINTAINERS: update "ARM/OXNAS platform
 support" patterns
Date: Tue, 06 Feb 2018 15:42:33 -0800
Message-ID: <20180206234233.QOoHydwXY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56884 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754145AbeBFXmf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:42:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, daniel@makrotopia.org, joe@perches.com, mm-commits@vger.kernel.org, narmstrong@baylibre.com, torvalds@linux-foundation.org

From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: update "ARM/OXNAS platform support" patterns

9e6c62b05c1b ("ARM: dts: rename oxnas dts files") renamed the files,
update the patterns.

[akpm@linux-foundation.org: crunch into a single globbed term, per Arnd]
Link: http://lkml.kernel.org/r/b39d779e143b3c0a4e7dff827346e509447e3e8e.1517147485.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Golle <daniel@makrotopia.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN MAINTAINERS~maintainers-update-arm-oxnas-platform-support-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-arm-oxnas-platform-support-patterns
+++ a/MAINTAINERS
@@ -1735,9 +1735,7 @@ L:	linux-arm-kernel@lists.infradead.org
 L:	linux-oxnas@lists.tuxfamily.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-oxnas/
-F:	arch/arm/boot/dts/ox8*.dtsi
-F:	arch/arm/boot/dts/wd-mbwe.dts
-F:	arch/arm/boot/dts/cloudengines-pogoplug-series-3.dts
+F:	arch/arm/boot/dts/ox8*.dts*
 N:	oxnas
 
 ARM/PALM TREO SUPPORT
_
