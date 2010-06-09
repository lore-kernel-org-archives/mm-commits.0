From: akpm@linux-foundation.org
Subject: + maintainers-add-maintainer-for-samsung-arm-architectures.patch added to -mm tree
Date: Wed, 09 Jun 2010 15:57:25 -0700
Message-ID: <201006092257.o59MvPTc026698@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758024Ab0FIW56 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jun 2010 18:57:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kgene.kim@samsung.com, ben-linux@fluff.org, rmk@arm.linux.org.uk


The patch titled
     MAINTAINERS: add maintainer for SAMSUNG ARM ARCHITECTURES
has been added to the -mm tree.  Its filename is
     maintainers-add-maintainer-for-samsung-arm-architectures.patch

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
Subject: MAINTAINERS: add maintainer for SAMSUNG ARM ARCHITECTURES
From: Kukjin Kim <kgene.kim@samsung.com>

Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

diff -puN MAINTAINERS~maintainers-add-maintainer-for-samsung-arm-architectures MAINTAINERS
--- a/MAINTAINERS~maintainers-add-maintainer-for-samsung-arm-architectures
+++ a/MAINTAINERS
@@ -896,11 +896,13 @@ S:	Maintained
 
 ARM/SAMSUNG ARM ARCHITECTURES
 M:	Ben Dooks <ben-linux@fluff.org>
+M:	Kukjin Kim <kgene.kim@samsung.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/plat-samsung/
 F:	arch/arm/plat-s3c24xx/
+F:	arch/arm/plat-s5p/
 
 ARM/S3C2410 ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
_

Patches currently in -mm which might be from kgene.kim@samsung.com are

maintainers-update-files-for-samsung-arm-architectures.patch
maintainers-add-maintainer-for-samsung-arm-architectures.patch

