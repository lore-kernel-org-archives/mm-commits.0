From: akpm@linux-foundation.org
Subject: [merged] maintainers-move-s3c2410-drivers-to-arm-samsung-arm.patch removed from -mm tree
Date: Thu, 03 Feb 2011 11:46:06 -0800
Message-ID: <201102031946.p13Jk6hj020982@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53798 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756719Ab1BCTqe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2011 14:46:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, jwjstone@fastmail.fm, kgene.kim@samsung.com, linux@simtec.co.uk, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: move s3c2410 drivers to ARM/SAMSUNG ARM
has been removed from the -mm tree.  Its filename was
     maintainers-move-s3c2410-drivers-to-arm-samsung-arm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: move s3c2410 drivers to ARM/SAMSUNG ARM
From: Ben Dooks <ben-linux@fluff.org>

There are currently two entries under the "SIMTEC EB2410ITX (BAST)"
machine entry for drivers/*/*s3c2410*, which is catching everything
s3c2410 driver related.

This entry is for a specific S3C2410 based machine, so move these two file
entries to the "ARM/SAMSUNG ARM ARCHITECTURES" entry, where it will reach
a wider audience of interested parties.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Cc: Simtec Linux Team <linux@simtec.co.uk>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Cc: Jack Stone <jwjstone@fastmail.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-move-s3c2410-drivers-to-arm-samsung-arm MAINTAINERS
--- a/MAINTAINERS~maintainers-move-s3c2410-drivers-to-arm-samsung-arm
+++ a/MAINTAINERS
@@ -978,6 +978,8 @@ S:	Maintained
 F:	arch/arm/plat-samsung/
 F:	arch/arm/plat-s3c24xx/
 F:	arch/arm/plat-s5p/
+F:	drivers/*/*s3c2410*
+F:	drivers/*/*/*s3c2410*
 
 ARM/S3C2410 ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
@@ -5624,8 +5626,6 @@ M:	Vincent Sanders <support@simtec.co.uk
 W:	http://www.simtec.co.uk/products/EB2410ITX/
 S:	Supported
 F:	arch/arm/mach-s3c2410/
-F:	drivers/*/*s3c2410*
-F:	drivers/*/*/*s3c2410*
 
 TI DAVINCI MACHINE SUPPORT
 M:	Kevin Hilman <khilman@deeprootsystems.com>
_

Patches currently in -mm which might be from ben-linux@fluff.org are

origin.patch
linux-next.patch

