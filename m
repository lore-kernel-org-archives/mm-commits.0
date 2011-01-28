From: akpm@linux-foundation.org
Subject: + maintainers-move-s3c2410-drivers-to-arm-samsung-arm.patch added to -mm tree
Date: Thu, 27 Jan 2011 16:00:54 -0800
Message-ID: <201101280000.p0S00s9b007590@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33035 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753355Ab1A1ABN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Jan 2011 19:01:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org, jwjstone@fastmail.fm, kgene.kim@samsung.com, linux@simtec.co.uk


The patch titled
     MAINTAINERS: move s3c2410 drivers to ARM/SAMSUNG ARM
has been added to the -mm tree.  Its filename is
     maintainers-move-s3c2410-drivers-to-arm-samsung-arm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Kukjin Kim <kgene.kim@samsung.com>
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
@@ -5630,8 +5632,6 @@ M:	Vincent Sanders <support@simtec.co.uk
 W:	http://www.simtec.co.uk/products/EB2410ITX/
 S:	Supported
 F:	arch/arm/mach-s3c2410/
-F:	drivers/*/*s3c2410*
-F:	drivers/*/*/*s3c2410*
 
 TI DAVINCI MACHINE SUPPORT
 M:	Kevin Hilman <khilman@deeprootsystems.com>
_

Patches currently in -mm which might be from ben-linux@fluff.org are

linux-next.patch
maintainers-move-s3c2410-drivers-to-arm-samsung-arm.patch
maintainers-fixup-file-entries-for-simtec-eb2410itx-bast.patch
maintainers-fixup-simtec-support-email-entries.patch
maintainers-fixup-simtec-support-email-entries-fix.patch

