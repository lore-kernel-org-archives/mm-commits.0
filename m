From: akpm@linux-foundation.org
Subject: + maintainers-add-matt-mackall-and-herbert-xu-to-hardware-random-number-generator.patch added to -mm tree
Date: Mon, 10 Aug 2009 15:31:49 -0700
Message-ID: <200908102231.n7AMVnsN019103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49999 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753521AbZHJWdh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Aug 2009 18:33:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, ddaney@caviumnetworks.com, herbert@gondor.apana.org.au, mpm@selenic.com


The patch titled
     MAINTAINERS: add Matt Mackall and Herbert Xu to HARDWARE RANDOM NUMBER GENERATOR
has been added to the -mm tree.  Its filename is
     maintainers-add-matt-mackall-and-herbert-xu-to-hardware-random-number-generator.patch

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
@@ -2308,7 +2308,9 @@ S:	Orphan
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

linux-next.patch
maintainers-add-ipvs-include-files.patch
mmc-msm_sdccc-driver-for-htc-dream.patch
msm_sdccc-convert-printkkern_level-to-pr_level.patch
msm_sdccc-stylistic-cleaning.patch
msm_sdccc-move-overly-indented-code-to-separate-function.patch
maintainers-add-matt-mackall-and-herbert-xu-to-hardware-random-number-generator.patch

