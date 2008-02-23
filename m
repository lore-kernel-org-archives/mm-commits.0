From: akpm@linux-foundation.org
Subject: + hwrng-remove-michael-as-hwrng-maintainer.patch added to -mm tree
Date: Sat, 23 Feb 2008 11:09:35 -0800
Message-ID: <200802231909.m1NJ9ZgF010730@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41229 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754655AbYBWTKT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 14:10:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mb@bu3sch.de, herbert@gondor.apana.org.au


The patch titled
     hwrng: remove Michael as HWRNG maintainer
has been added to the -mm tree.  Its filename is
     hwrng-remove-michael-as-hwrng-maintainer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwrng: remove Michael as HWRNG maintainer
From: Michael Buesch <mb@bu3sch.de>

It turns out that I rewrote the HWRNG core once to make it pluggable, but
I'm not a crypto-expert at all.  So I'm certainly the wrong person for
being a maintainer of the HWRNG core.  Let's orphan it.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN MAINTAINERS~hwrng-remove-michael-as-hwrng-maintainer MAINTAINERS
--- a/MAINTAINERS~hwrng-remove-michael-as-hwrng-maintainer
+++ a/MAINTAINERS
@@ -1713,9 +1713,7 @@ T:	git lm-sensors.org:/kernel/mhoffman/h
 S:	Maintained
 
 HARDWARE RANDOM NUMBER GENERATOR CORE
-P:	Michael Buesch
-M:	mb@bu3sch.de
-S:	Maintained
+S:	Orphaned
 
 HARD DRIVE ACTIVE PROTECTION SYSTEM (HDAPS) DRIVER
 P:	Robert Love
_

Patches currently in -mm which might be from mb@bu3sch.de are

hwrng-remove-michael-as-hwrng-maintainer.patch
git-net.patch
make-b43_mac_enablesuspend-static.patch
ssb-pci-core-driver-use-new-sprom-data-structure.patch
fix-b43-driver-build-for-arm.patch
