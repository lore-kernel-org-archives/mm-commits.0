From: akpm@linux-foundation.org
Subject: + maintainers-fixup-simtec-support-email-entries.patch added to -mm tree
Date: Thu, 27 Jan 2011 16:00:58 -0800
Message-ID: <201101280000.p0S00wb6007596@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753420Ab1A1ABQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Jan 2011 19:01:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org, jwjstone@fastmail.fm, linux@simtec.co.uk, support@simtec.co.uk, vince@simtec.co.uk


The patch titled
     MAINTAINERS: fixup Simtec support email entries
has been added to the -mm tree.  Its filename is
     maintainers-fixup-simtec-support-email-entries.patch

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
Subject: MAINTAINERS: fixup Simtec support email entries
From: Ben Dooks <ben-linux@fluff.org>

The support@simtec.co.uk address is for direct customer support only, the
EB2410ITX and EB110ATX entries should direct to the Simtec Linux Team
address of linux@simtec.co.uk

Also add correct email address for Vincent Sanders

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Cc: Vincent Sanders <vince@simtec.co.uk>
Cc: Simtec Support <support@simtec.co.uk>
Cc: Simtec Linux Team <linux@simtec.co.uk>
Cc: Jack Stone <jwjstone@fastmail.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-fixup-simtec-support-email-entries MAINTAINERS
--- a/MAINTAINERS~maintainers-fixup-simtec-support-email-entries
+++ a/MAINTAINERS
@@ -5622,13 +5622,15 @@ F:	include/linux/sfi*.h
 
 SIMTEC EB110ATX (Chalice CATS)
 P:	Ben Dooks
-M:	Vincent Sanders <support@simtec.co.uk>
+P:	Vincent Sanders <support@simtec.co.uk>
+M:	Simtec Linux Team <linux@simtec.co.uk>
 W:	http://www.simtec.co.uk/products/EB110ATX/
 S:	Supported
 
 SIMTEC EB2410ITX (BAST)
 P:	Ben Dooks
-M:	Vincent Sanders <support@simtec.co.uk>
+P:	Vincent Sanders <vince@simtec.co.uk>
+M:	Simtec Linux Team <linux@simtec.co.uk>
 W:	http://www.simtec.co.uk/products/EB2410ITX/
 S:	Supported
 F:	arch/arm/mach-s3c2410/mach-bast.c
_

Patches currently in -mm which might be from ben-linux@fluff.org are

linux-next.patch
maintainers-move-s3c2410-drivers-to-arm-samsung-arm.patch
maintainers-fixup-file-entries-for-simtec-eb2410itx-bast.patch
maintainers-fixup-simtec-support-email-entries.patch
maintainers-fixup-simtec-support-email-entries-fix.patch

