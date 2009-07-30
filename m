From: akpm@linux-foundation.org
Subject: [merged] maintainers-remove-l-linux-kernel-vgerkernelorg.patch removed from -mm tree
Date: Thu, 30 Jul 2009 13:37:50 -0700
Message-ID: <200907302037.n6UKboo9012153@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37596 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752321AbZG3UiV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 16:38:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: Remove L: linux-kernel@vger.kernel.org
has been removed from the -mm tree.  Its filename was
     maintainers-remove-l-linux-kernel-vgerkernelorg.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: MAINTAINERS: Remove L: linux-kernel@vger.kernel.org
=46rom: Joe Perches <joe@perches.com>

from sections that should not have them.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 -----
 1 file changed, 5 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-l-linux-kernel-vgerkernelorg M=
AINTAINERS
--- a/MAINTAINERS~maintainers-remove-l-linux-kernel-vgerkernelorg
+++ a/MAINTAINERS
@@ -2204,7 +2204,6 @@ F:	drivers/scsi/lpfc/
 ENE CB710 FLASH CARD READER DRIVER
 P:	Micha=C5=82 Miros=C5=82aw
 M:	mirq-linux@rere.qmqm.pl
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/misc/cb710/
 F:	drivers/mmc/host/cb710-mmc.*
@@ -3480,13 +3479,11 @@ P:	Vegard Nossum
 M:	vegardno@ifi.uio.no
 P	Pekka Enberg
 M:	penberg@cs.helsinki.fi
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
=20
 KMEMLEAK
 P:	Catalin Marinas
 M:	catalin.marinas@arm.com
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/kmemleak.txt
 F:	include/linux/kmemleak.h
@@ -4306,7 +4303,6 @@ F:	drivers/video/omap/
 OMAP MMC SUPPORT
 P:	Jarkko Lavinen
 M:	jarkko.lavinen@nokia.com
-L:	linux-kernel@vger.kernel.org
 L:	linux-omap@vger.kernel.org
 S:	Maintained
 F:	drivers/mmc/host/*omap*
@@ -4588,7 +4584,6 @@ P:	Paul Mackerras
 M:	paulus@samba.org
 P:	Ingo Molnar
 M:	mingo@elte.hu
-L:	linux-kernel@vger.kernel.org
 S:	Supported
=20
 PERSONALITY HANDLING
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
mmc-msm_sdccc-driver-for-htc-dream.patch
msm_sdccc-convert-printkkern_level-to-pr_level.patch
msm_sdccc-stylistic-cleaning.patch
msm_sdccc-move-overly-indented-code-to-separate-function.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
