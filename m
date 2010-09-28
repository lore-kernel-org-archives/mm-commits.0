From: akpm@linux-foundation.org
Subject: + maintainers-update-maintainer-for-s5p-arm-architectures.patch added to -mm tree
Date: Tue, 28 Sep 2010 14:42:26 -0700
Message-ID: <201009282142.o8SLgQ8B019488@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751952Ab0I1Vmq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Sep 2010 17:42:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kgene.kim@samsung.com, ben-linux@fluff.org, kmpark@infradead.org, rmk@arm.linux.org.uk


The patch titled
     MAINTAINERS: update maintainer for S5P ARM ARCHITECTURES
has been added to the -mm tree.  Its filename is
     maintainers-update-maintainer-for-s5p-arm-architectures.patch

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
Subject: MAINTAINERS: update maintainer for S5P ARM ARCHITECTURES
From: Kukjin Kim <kgene.kim@samsung.com>

Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Kyungmin Park <kmpark@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN MAINTAINERS~maintainers-update-maintainer-for-s5p-arm-architectures MAINTAINERS
--- a/MAINTAINERS~maintainers-update-maintainer-for-s5p-arm-architectures
+++ a/MAINTAINERS
@@ -962,6 +962,13 @@ W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c6410/
 
+ARM/S5P ARM ARCHITECTURES
+M:	Kukjin Kim <kgene.kim@samsung.com>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+L:	linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
+S:	Maintained
+F:	arch/arm/mach-s5p*/
+
 ARM/SHMOBILE ARM ARCHITECTURE
 M:	Paul Mundt <lethal@linux-sh.org>
 M:	Magnus Damm <magnus.damm@gmail.com>
_

Patches currently in -mm which might be from kgene.kim@samsung.com are

origin.patch
linux-next.patch
maintainers-update-maintainer-for-s5p-arm-architectures.patch

