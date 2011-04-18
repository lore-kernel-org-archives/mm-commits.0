From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-arm-ts78xx-setup-platform-maintainer.patch removed from -mm tree
Date: Mon, 18 Apr 2011 11:02:39 -0700
Message-ID: <201104181758.p3IHwoeK016090@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57344 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756231Ab1DRSEJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Apr 2011 14:04:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex@digriz.org.uk, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: add ARM/ts78xx-setup platform maintainer
has been removed from the -mm tree.  Its filename was
     maintainers-add-arm-ts78xx-setup-platform-maintainer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: add ARM/ts78xx-setup platform maintainer
From: Alexander Clouter <alex@digriz.org.uk>

Signed-off-by: Alexander Clouter <alex@digriz.org.uk>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN MAINTAINERS~maintainers-add-arm-ts78xx-setup-platform-maintainer MAINTAINERS
--- a/MAINTAINERS~maintainers-add-arm-ts78xx-setup-platform-maintainer
+++ a/MAINTAINERS
@@ -877,6 +877,13 @@ F:	arch/arm/mach-mv78xx0/
 F:	arch/arm/mach-orion5x/
 F:	arch/arm/plat-orion/
 
+ARM/Orion SoC/Technologic Systems TS-78xx platform support
+M:	Alexander Clouter <alex@digriz.org.uk>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+W:	http://www.digriz.org.uk/ts78xx/kernel
+S:	Maintained
+F:	arch/arm/mach-orion5x/ts78xx-*
+
 ARM/MIOA701 MACHINE SUPPORT
 M:	Robert Jarzmik <robert.jarzmik@free.fr>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
_

Patches currently in -mm which might be from alex@digriz.org.uk are

origin.patch

