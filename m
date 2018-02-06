From: akpm@linux-foundation.org
Subject: [folded-merged]
 maintainers-update-arm-oxnas-platform-support-patterns-fix.patch removed
 from -mm tree
Date: Tue, 06 Feb 2018 15:28:58 -0800
Message-ID: <5a7a3a3a.GNY0mR7ekOuAUD0F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50690 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753763AbeBFX27 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:28:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, daniel@makrotopia.org, joe@perches.com, narmstrong@baylibre.com, mm-commits@vger.kernel.org


The patch titled
     Subject: maintainers-update-arm-oxnas-platform-support-patterns-fix
has been removed from the -mm tree.  Its filename was
     maintainers-update-arm-oxnas-platform-support-patterns-fix.patch

This patch was dropped because it was folded into maintainers-update-arm-oxnas-platform-support-patterns.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: maintainers-update-arm-oxnas-platform-support-patterns-fix

Crunch into a single globbed term, per Arnd

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Golle <daniel@makrotopia.org>
Cc: Joe Perches <joe@perches.com>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN MAINTAINERS~maintainers-update-arm-oxnas-platform-support-patterns-fix MAINTAINERS
--- a/MAINTAINERS~maintainers-update-arm-oxnas-platform-support-patterns-fix
+++ a/MAINTAINERS
@@ -1735,9 +1735,7 @@ L:	linux-arm-kernel@lists.infradead.org
 L:	linux-oxnas@lists.tuxfamily.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-oxnas/
-F:	arch/arm/boot/dts/ox8*.dtsi
-F:	arch/arm/boot/dts/ox810se-wd-mbwe.dts
-F:	arch/arm/boot/dts/ox820-cloudengines-pogoplug-series-3.dts
+F:	arch/arm/boot/dts/ox8*.dts*
 N:	oxnas
 
 ARM/PALM TREO SUPPORT
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-ubsanc-s-missaligned-misaligned.patch
maintainers-update-arm-oxnas-platform-support-patterns.patch

