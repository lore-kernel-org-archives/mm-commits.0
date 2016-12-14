From: akpm@linux-foundation.org
Subject: [patch 034/114] Kconfig: lib/Kconfig.debug: fix references to
 Documenation
Date: Wed, 14 Dec 2016 15:05:40 -0800
Message-ID: <5851d044.Yl2a2cYyk52FVZn7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34648 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933408AbcLNXFm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:05:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, andreas.platschek@opentech.at

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
@@ -194,8 +194,8 @@ config GDB_SCRIPTS
 	  build directory. If you load vmlinux into gdb, the helper
 	  scripts will be automatically imported by gdb as well, and
 	  additional functions are available to analyze a Linux kernel
-	  instance. See Documentation/gdb-kernel-debugging.txt for further
-	  details.
+	  instance. See Documentation/dev-tools/gdb-kernel-debugging.rst
+	  for further details.
 
 config ENABLE_WARN_DEPRECATED
 	bool "Enable __deprecated logic"
@@ -542,7 +542,7 @@ config DEBUG_KMEMLEAK
 	  difference being that the orphan objects are not freed but
 	  only shown in /sys/kernel/debug/kmemleak. Enabling this
 	  feature will introduce an overhead to memory
-	  allocations. See Documentation/kmemleak.txt for more
+	  allocations. See Documentation/dev-tools/kmemleak.rst for more
 	  details.
 
 	  Enabling DEBUG_SLAB or SLUB_DEBUG may increase the chances
@@ -739,7 +739,7 @@ config KCOV
 	  different machines and across reboots. If you need stable PC values,
 	  disable RANDOMIZE_BASE.
 
-	  For more details, see Documentation/kcov.txt.
+	  For more details, see Documentation/dev-tools/kcov.rst.
 
 config KCOV_INSTRUMENT_ALL
 	bool "Instrument all code by default"
_
