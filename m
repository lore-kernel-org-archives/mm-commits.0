From: akpm@linux-foundation.org
Subject: [merged]
 maintainers-update-arm-oxnas-platform-support-patterns.patch removed from
 -mm tree
Date: Wed, 07 Feb 2018 12:00:49 -0800
Message-ID: <20180207200049.oiFmN3XpB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60800 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753721AbeBGUAu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 15:00:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, daniel@makrotopia.org, joe@perches.com, mm-commits@vger.kernel.org, narmstrong@baylibre.com


The patch titled
     Subject: MAINTAINERS: update "ARM/OXNAS platform support" patterns
has been removed from the -mm tree.  Its filename was
     maintainers-update-arm-oxnas-platform-support-patterns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from joe@perches.com are


