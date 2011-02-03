From: akpm@linux-foundation.org
Subject: [merged] maintainers-fixup-file-entries-for-simtec-eb2410itx-bast.patch removed from -mm tree
Date: Thu, 03 Feb 2011 11:46:10 -0800
Message-ID: <201102031946.p13JkATq020987@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39090 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756715Ab1BCTqe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2011 14:46:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, jwjstone@fastmail.fm, linux@simtec.co.uk, support@simtec.co.uk, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: fixup file entries for "SIMTEC EB2410ITX (BAST)"
has been removed from the -mm tree.  Its filename was
     maintainers-fixup-file-entries-for-simtec-eb2410itx-bast.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: fixup file entries for "SIMTEC EB2410ITX (BAST)"
From: Ben Dooks <ben-linux@fluff.org>

Add the correct files for the Simtec BAST machine, ensuring the IDE and
IRQ routing are added, and move to the machine specific file instead of
trying to catch all of arch/arm/mach-s3c2410

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Cc: Simtec Linux Team <linux@simtec.co.uk>
Cc: Simtec Support <support@simtec.co.uk>
Cc: Jack Stone <jwjstone@fastmail.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-fixup-file-entries-for-simtec-eb2410itx-bast MAINTAINERS
--- a/MAINTAINERS~maintainers-fixup-file-entries-for-simtec-eb2410itx-bast
+++ a/MAINTAINERS
@@ -5625,7 +5625,9 @@ P:	Ben Dooks
 M:	Vincent Sanders <support@simtec.co.uk>
 W:	http://www.simtec.co.uk/products/EB2410ITX/
 S:	Supported
-F:	arch/arm/mach-s3c2410/
+F:	arch/arm/mach-s3c2410/mach-bast.c
+F:	arch/arm/mach-s3c2410/bast-ide.c
+F:	arch/arm/mach-s3c2410/bast-irq.c
 
 TI DAVINCI MACHINE SUPPORT
 M:	Kevin Hilman <khilman@deeprootsystems.com>
_

Patches currently in -mm which might be from ben-linux@fluff.org are

origin.patch
linux-next.patch

