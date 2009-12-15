From: akpm@linux-foundation.org
Subject: [merged] maintainers-rename-palm-treo-section-and-file-patterns.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:57:04 -0800
Message-ID: <200912152157.nBFLv48W015686@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49025 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761293AbZLOV5j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:57:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, sleep_walker@suse.cz, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: rename PALM TREO section and file patterns
has been removed from the -mm tree.  Its filename was
     maintainers-rename-palm-treo-section-and-file-patterns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: rename PALM TREO section and file patterns
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Tomas Cech <sleep_walker@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN MAINTAINERS~maintainers-rename-palm-treo-section-and-file-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-rename-palm-treo-section-and-file-patterns
+++ a/MAINTAINERS
@@ -835,13 +835,13 @@ F:	arch/arm/mach-pxa/palmte2.c
 F:	arch/arm/mach-pxa/include/mach/palmtc.h
 F:	arch/arm/mach-pxa/palmtc.c
 
-ARM/PALM TREO 680 SUPPORT
+ARM/PALM TREO SUPPORT
 M:	Tomas Cech <sleep_walker@suse.cz>
 L:	linux-arm-kernel@lists.infradead.org
 W:	http://hackndev.com
 S:	Maintained
-F:	arch/arm/mach-pxa/include/mach/treo680.h
-F:	arch/arm/mach-pxa/treo680.c
+F:	arch/arm/mach-pxa/include/mach/palmtreo.h
+F:	arch/arm/mach-pxa/palmtreo.c
 
 ARM/PALMZ72 SUPPORT
 M:	Sergey Lapin <slapin@ossfans.org>
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch
isicomc-use-pr_fmt-and-pr_level.patch
parport_pcc-use-correct-length-in-strncmp.patch

