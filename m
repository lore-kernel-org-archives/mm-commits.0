From: akpm@linux-foundation.org
Subject: - hwrng-remove-michael-as-hwrng-maintainer.patch removed from -mm tree
Date: Sun, 24 Feb 2008 16:44:52 -0800
Message-ID: <200802250044.m1P0iqgG006141@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56273 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755073AbYBYAtR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:49:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mb@bu3sch.de, herbert@gondor.apana.org.au, mm-commits@vger.kernel.org


The patch titled
     hwrng: remove Michael as HWRNG maintainer
has been removed from the -mm tree.  Its filename was
     hwrng-remove-michael-as-hwrng-maintainer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1712,9 +1712,7 @@ T:	git lm-sensors.org:/kernel/mhoffman/h
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

make-b43_mac_enablesuspend-static.patch
ssb-pci-core-driver-use-new-sprom-data-structure.patch
fix-b43-driver-build-for-arm.patch
