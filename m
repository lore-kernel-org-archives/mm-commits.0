From: akpm@linux-foundation.org
Subject: + maintainers-fixup-file-entries-for-simtec-eb2410itx-bast.patch added to -mm tree
Date: Thu, 27 Jan 2011 16:00:56 -0800
Message-ID: <201101280000.p0S00u7E007593@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753404Ab1A1ABO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Jan 2011 19:01:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org, jwjstone@fastmail.fm, linux@simtec.co.uk, support@simtec.co.uk


The patch titled
     MAINTAINERS: fixup file entries for "SIMTEC EB2410ITX (BAST)"
has been added to the -mm tree.  Its filename is
     maintainers-fixup-file-entries-for-simtec-eb2410itx-bast.patch

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
@@ -5631,7 +5631,9 @@ P:	Ben Dooks
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

linux-next.patch
maintainers-move-s3c2410-drivers-to-arm-samsung-arm.patch
maintainers-fixup-file-entries-for-simtec-eb2410itx-bast.patch
maintainers-fixup-simtec-support-email-entries.patch
maintainers-fixup-simtec-support-email-entries-fix.patch

