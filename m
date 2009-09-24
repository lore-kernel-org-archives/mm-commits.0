From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-matt-mackall-and-herbert-xu-to-hardware-random-number-generator.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:36:30 -0700
Message-ID: <200909241936.n8OJaUqK002664@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42917 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754507AbZIXThb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:37:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, ddaney@caviumnetworks.com, herbert@gondor.apana.org.au, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: add Matt Mackall and Herbert Xu to HARDWARE RANDOM NUMBER GENERATOR
has been removed from the -mm tree.  Its filename was
     maintainers-add-matt-mackall-and-herbert-xu-to-hardware-random-number-generator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: add Matt Mackall and Herbert Xu to HARDWARE RANDOM NUMBER GENERATOR
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: David Daney <ddaney@caviumnetworks.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-add-matt-mackall-and-herbert-xu-to-hardware-random-number-generator MAINTAINERS
--- a/MAINTAINERS~maintainers-add-matt-mackall-and-herbert-xu-to-hardware-random-number-generator
+++ a/MAINTAINERS
@@ -2331,7 +2331,9 @@ S:	Orphan
 F:	drivers/hwmon/
 
 HARDWARE RANDOM NUMBER GENERATOR CORE
-S:	Orphan
+M:	Matt Mackall <mpm@selenic.com>
+M:	Herbert Xu <herbert@gondor.apana.org.au>
+S:	Odd fixes
 F:	Documentation/hw_random.txt
 F:	drivers/char/hw_random/
 F:	include/linux/hw_random.h
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch

