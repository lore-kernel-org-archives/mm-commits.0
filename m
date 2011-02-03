From: akpm@linux-foundation.org
Subject: [merged] maintainers-fixup-simtec-support-email-entries.patch removed from -mm tree
Date: Thu, 03 Feb 2011 11:46:12 -0800
Message-ID: <201102031946.p13JkCJS020990@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33041 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756720Ab1BCTqe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2011 14:46:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, jwjstone@fastmail.fm, linux@simtec.co.uk, support@simtec.co.uk, vince@simtec.co.uk, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: fixup Simtec support email entries
has been removed from the -mm tree.  Its filename was
     maintainers-fixup-simtec-support-email-entries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: fixup Simtec support email entries
From: Ben Dooks <ben-linux@fluff.org>

The support@simtec.co.uk address is for direct customer support only, the
EB2410ITX and EB110ATX entries should direct to the Simtec Linux Team
address of linux@simtec.co.uk

Also add correct email address for Vincent Sanders

[akpm@linux-foundation.org: fix Vincent's address]
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
@@ -5616,13 +5616,15 @@ F:	include/linux/sfi*.h
 
 SIMTEC EB110ATX (Chalice CATS)
 P:	Ben Dooks
-M:	Vincent Sanders <support@simtec.co.uk>
+P:	Vincent Sanders <vince@simtec.co.uk>
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

origin.patch
linux-next.patch

