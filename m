From: akpm@linux-foundation.org
Subject: [merged] maintainers-arm-palm-file-patterns.patch removed from -mm tree
Date: Mon, 05 Oct 2009 11:38:11 -0700
Message-ID: <200910051838.n95IcBSC016490@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44004 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754707AbZJESj4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2009 14:39:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, marek.vasut@gmail.com, sleep_walker@suse.cz, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: ARM/Palm file patterns
has been removed from the -mm tree.  Its filename was
     maintainers-arm-palm-file-patterns.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: MAINTAINERS: ARM/Palm file patterns
=46rom: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Marek Vasut <marek.vasut@gmail.com>
Acked-by: Tomas Cech <sleep_walker@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-arm-palm-file-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-arm-palm-file-patterns
+++ a/MAINTAINERS
@@ -741,23 +741,36 @@ M:	Dirk Opfer <dirk@opfer-online.de>
 S:	Maintained
=20
 ARM/PALMTX,PALMT5,PALMLD,PALMTE2,PALMTC SUPPORT
-P:	Marek Vasut
-M:	marek.vasut@gmail.com
+M:	Marek Vasut <marek.vasut@gmail.com>
 L:	linux-arm-kernel@lists.infradead.org
 W:	http://hackndev.com
 S:	Maintained
+F:	arch/arm/mach-pxa/include/mach/palmtx.h
+F:	arch/arm/mach-pxa/palmtx.c
+F:	arch/arm/mach-pxa/include/mach/palmt5.h
+F:	arch/arm/mach-pxa/palmt5.c
+F:	arch/arm/mach-pxa/include/mach/palmld.h
+F:	arch/arm/mach-pxa/palmld.c
+F:	arch/arm/mach-pxa/include/mach/palmte2.h
+F:	arch/arm/mach-pxa/palmte2.c
+F:	arch/arm/mach-pxa/include/mach/palmtc.h
+F:	arch/arm/mach-pxa/palmtc.c
=20
 ARM/PALM TREO 680 SUPPORT
 M:	Tomas Cech <sleep_walker@suse.cz>
 L:	linux-arm-kernel@lists.infradead.org
 W:	http://hackndev.com
 S:	Maintained
+F:	arch/arm/mach-pxa/include/mach/treo680.h
+F:	arch/arm/mach-pxa/treo680.c
=20
 ARM/PALMZ72 SUPPORT
 M:	Sergey Lapin <slapin@ossfans.org>
 L:	linux-arm-kernel@lists.infradead.org
 W:	http://hackndev.com
 S:	Maintained
+F:	arch/arm/mach-pxa/include/mach/palmz72.h
+F:	arch/arm/mach-pxa/palmz72.c
=20
 ARM/PLEB SUPPORT
 M:	Peter Chubb <pleb@gelato.unsw.edu.au>
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
maintainers-update-generic-uio-for-pci-devices.patch
maintainers-update-tracing-section.patch
maintainers-update-omap-tony-lindgren-email-name.patch
maintainers-change-atm-mailing-list-to-moderated.patch
maintainers-use-tab-not-spaces-after-field-types.patch
maintainers-update-kernel-janitors-after-mismerge.patch
maintainers-update-score-architecture-name-style-and-add-file-pattern.p=
atch
maintainers-simple-firmware-interface-update-email-style.patch
maintainers-winbond-cir-integrate-p-m-lines-fixup-david-h=E4rdemans-nam=
e.patch
maintainers-fix-up-peripheral-spelling.patch
maintainers-update-wolfson-microelectronics.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
