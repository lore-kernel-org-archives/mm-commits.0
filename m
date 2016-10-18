From: akpm@linux-foundation.org
Subject: +
 kconfig-lib-kconfigubsan-fix-reference-to-ubsan-documentation.patch added
 to -mm tree
Date: Tue, 18 Oct 2016 13:56:22 -0700
Message-ID: <58068c76.XAPBks4+j8r0w70N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56512 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755161AbcJRU4X (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2016 16:56:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreas.platschek@opentech.at, mm-commits@vger.kernel.org


The patch titled
     Subject: Kconfig: lib/Kconfig.ubsan fix reference to ubsan documentation
has been added to the -mm tree.  Its filename is
     kconfig-lib-kconfigubsan-fix-reference-to-ubsan-documentation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kconfig-lib-kconfigubsan-fix-reference-to-ubsan-documentation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kconfig-lib-kconfigubsan-fix-reference-to-ubsan-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andreas Platschek <andreas.platschek@opentech.at>
Subject: Kconfig: lib/Kconfig.ubsan fix reference to ubsan documentation

Documenation/ubsan.txt was moved to Documentation/dev-tools/ubsan.rst,
this fixes the reference.

Link: http://lkml.kernel.org/r/1476698152-29340-3-git-send-email-andreas.platschek@opentech.at
Signed-off-by: Andreas Platschek <andreas.platschek@opentech.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.ubsan |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN lib/Kconfig.ubsan~kconfig-lib-kconfigubsan-fix-reference-to-ubsan-documentation lib/Kconfig.ubsan
--- a/lib/Kconfig.ubsan~kconfig-lib-kconfigubsan-fix-reference-to-ubsan-documentation
+++ a/lib/Kconfig.ubsan
@@ -10,7 +10,8 @@ config UBSAN
 	  This option enables undefined behaviour sanity checker
 	  Compile-time instrumentation is used to detect various undefined
 	  behaviours in runtime. Various types of checks may be enabled
-	  via boot parameter ubsan_handle (see: Documentation/ubsan.txt).
+	  via boot parameter ubsan_handle
+	  (see: Documentation/dev-tools/ubsan.rst).
 
 config UBSAN_SANITIZE_ALL
 	bool "Enable instrumentation for the entire kernel"
_

Patches currently in -mm which might be from andreas.platschek@opentech.at are

kconfig-lib-kconfigdebug-fix-references-to-documenation.patch
kconfig-lib-kconfigubsan-fix-reference-to-ubsan-documentation.patch

