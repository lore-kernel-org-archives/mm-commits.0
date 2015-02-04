From: akpm@linux-foundation.org
Subject: + maintainers-add-the-rtc-driver-for-the-armada38x.patch added to -mm tree
Date: Wed, 04 Feb 2015 14:49:23 -0800
Message-ID: <54d2a1f3.JgiO/pI/mCBVA0kP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47491 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933704AbbBDWtZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Feb 2015 17:49:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gregory.clement@free-electrons.com, a.zummo@towertech.it, alior@marvell.com, andrew@lunn.ch, arno@natisbad.org, boris.brezillon@free-electrons.com, ezequiel.garcia@free-electrons.com, jason@lakedaemon.net, mark.rutland@arm.com, maxime.ripard@free-electrons.com, nadavh@marvell.com, sebastian.hesselbarth@gmail.com, tawfik@marvell.com, thomas.petazzoni@free-electrons.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add the RTC driver for the Armada38x
has been added to the -mm tree.  Its filename is
     maintainers-add-the-rtc-driver-for-the-armada38x.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-the-rtc-driver-for-the-armada38x.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-the-rtc-driver-for-the-armada38x.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: MAINTAINERS: add the RTC driver for the Armada38x

Put it in the mvebu entry.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Arnaud Ebalard <arno@natisbad.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Lior Amsalem <alior@marvell.com>
Cc: Tawfik Bayouk <tawfik@marvell.com>
Cc: Nadav Haklai <nadavh@marvell.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-add-the-rtc-driver-for-the-armada38x MAINTAINERS
--- a/MAINTAINERS~maintainers-add-the-rtc-driver-for-the-armada38x
+++ a/MAINTAINERS
@@ -1160,6 +1160,7 @@ M:	Sebastian Hesselbarth <sebastian.hess
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-mvebu/
+F:	drivers/rtc/armada38x-rtc
 
 ARM/Marvell Berlin SoC support
 M:	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
_

Patches currently in -mm which might be from gregory.clement@free-electrons.com are

rtc-armada38x-add-the-device-tree-binding-documentation.patch
drivers-rtc-rtc-armada38x-add-a-new-rtc-driver-for-recent-mvebu-socs.patch
maintainers-add-the-rtc-driver-for-the-armada38x.patch
arm-mvebu-add-device-tree-description-of-rtc-on-armada-38x.patch
arm-mvebu-enable-armada-38x-rtc-driver-in-mvebu_v7_defconfig.patch
linux-next.patch

