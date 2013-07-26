From: akpm@linux-foundation.org
Subject: + maintainers-add-mach-bcm-and-drivers.patch added to -mm tree
Date: Fri, 26 Jul 2013 14:24:51 -0700
Message-ID: <51f2e923.lnB2gGst/w1Tf96Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51602 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932810Ab3GZVYw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 26 Jul 2013 17:24:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, swarren@wwwdotorg.org, olof@lixom.net, arnd@arndb.de, csd@broadcom.com

Subject: + maintainers-add-mach-bcm-and-drivers.patch added to -mm tree
To: csd@broadcom.com,arnd@arndb.de,olof@lixom.net,swarren@wwwdotorg.org
From: akpm@linux-foundation.org
Date: Fri, 26 Jul 2013 14:24:51 -0700


The patch titled
     Subject: MAINTAINERS: add mach-bcm and drivers
has been added to the -mm tree.  Its filename is
     maintainers-add-mach-bcm-and-drivers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-mach-bcm-and-drivers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-mach-bcm-and-drivers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Christian Daudt" <csd@broadcom.com>
Subject: MAINTAINERS: add mach-bcm and drivers

Add ownership to maintainers file for the mach-bcm related files,
including drivers that are used for the SoCs defined in mach-bcm.

Signed-off-by: Christian Daudt <csd@broadcom.com>
Cc: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN MAINTAINERS~maintainers-add-mach-bcm-and-drivers MAINTAINERS
--- a/MAINTAINERS~maintainers-add-mach-bcm-and-drivers
+++ a/MAINTAINERS
@@ -1780,6 +1780,17 @@ L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/broadcom/bnx2x/
 
+BROADCOM BCM281XX/BCM11XXX ARM ARCHITECTURE
+M:	Christian Daudt <csd@broadcom.com>
+T:	git git://git.github.com/broadcom/bcm11351
+S:	Maintained
+F:	arch/arm/mach-bcm/
+F:	arch/arm/boot/dts/bcm113*
+F:	arch/arm/boot/dts/bcm281*
+F:	arch/arm/configs/bcm_defconfig
+F:	drivers/mmc/host/sdhci_bcm_kona.c
+F:	drivers/clocksource/bcm_kona_timer.c
+
 BROADCOM BCM2835 ARM ARCHICTURE
 M:	Stephen Warren <swarren@wwwdotorg.org>
 L:	linux-rpi-kernel@lists.infradead.org (moderated for non-subscribers)
_

Patches currently in -mm which might be from csd@broadcom.com are

maintainers-add-mach-bcm-and-drivers.patch

