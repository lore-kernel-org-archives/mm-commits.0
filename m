From: akpm@linux-foundation.org
Subject: + kconfig-lib-kconfigdebug-fix-references-to-documenation.patch
 added to -mm tree
Date: Tue, 18 Oct 2016 13:56:20 -0700
Message-ID: <58068c74.W+YiRtQekHn+78wG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56509 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755161AbcJRU4V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2016 16:56:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreas.platschek@opentech.at, mm-commits@vger.kernel.org


The patch titled
     Subject: Kconfig: lib/Kconfig.debug: fix references to Documenation
has been added to the -mm tree.  Its filename is
     kconfig-lib-kconfigdebug-fix-references-to-documenation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kconfig-lib-kconfigdebug-fix-references-to-documenation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kconfig-lib-kconfigdebug-fix-references-to-documenation.patch

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
Subject: Kconfig: lib/Kconfig.debug: fix references to Documenation

Documentation on development tools was moved to Documentation/devl-tools
and sphinxified (renamed from .txt to .rst).

References in lib/Kconfig.debug need to be updated to the new location.

Link: http://lkml.kernel.org/r/1476698152-29340-2-git-send-email-andreas.platschek@opentech.at
Signed-off-by: Andreas Platschek <andreas.platschek@opentech.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN lib/Kconfig.debug~kconfig-lib-kconfigdebug-fix-references-to-documenation lib/Kconfig.debug
--- a/lib/Kconfig.debug~kconfig-lib-kconfigdebug-fix-references-to-documenation
+++ a/lib/Kconfig.debug
@@ -175,8 +175,8 @@ config GDB_SCRIPTS
 	  build directory. If you load vmlinux into gdb, the helper
 	  scripts will be automatically imported by gdb as well, and
 	  additional functions are available to analyze a Linux kernel
-	  instance. See Documentation/gdb-kernel-debugging.txt for further
-	  details.
+	  instance. See Documentation/dev-tools/gdb-kernel-debugging.rst
+	  for further details.
 
 config ENABLE_WARN_DEPRECATED
 	bool "Enable __deprecated logic"
@@ -522,7 +522,7 @@ config DEBUG_KMEMLEAK
 	  difference being that the orphan objects are not freed but
 	  only shown in /sys/kernel/debug/kmemleak. Enabling this
 	  feature will introduce an overhead to memory
-	  allocations. See Documentation/kmemleak.txt for more
+	  allocations. See Documentation/dev-tools/kmemleak.rst for more
 	  details.
 
 	  Enabling DEBUG_SLAB or SLUB_DEBUG may increase the chances
@@ -719,7 +719,7 @@ config KCOV
 	  different machines and across reboots. If you need stable PC values,
 	  disable RANDOMIZE_BASE.
 
-	  For more details, see Documentation/kcov.txt.
+	  For more details, see Documentation/dev-tools/kcov.rst.
 
 config KCOV_INSTRUMENT_ALL
 	bool "Instrument all code by default"
_

Patches currently in -mm which might be from andreas.platschek@opentech.at are

kconfig-lib-kconfigdebug-fix-references-to-documenation.patch
kconfig-lib-kconfigubsan-fix-reference-to-ubsan-documentation.patch

