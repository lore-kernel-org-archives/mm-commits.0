From: akpm@linux-foundation.org
Subject: + uml-fix-build-breakage.patch added to -mm tree
Date: Tue, 08 May 2007 14:36:33 -0700
Message-ID: <200705082136.l48LaXID002364@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56952 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032399AbXEHVgk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 17:36:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: fix build breakage
has been added to the -mm tree.  Its filename is
     uml-fix-build-breakage.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: fix build breakage
From: Jeff Dike <jdike@addtoit.com>

UML now needs required-features.h to build - an empty one suffices.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-um/required-features.h |    9 +++++++++
 1 files changed, 9 insertions(+)

diff -puN /dev/null include/asm-um/required-features.h
--- /dev/null
+++ a/include/asm-um/required-features.h
@@ -0,0 +1,9 @@
+#ifndef __UM_REQUIRED_FEATURES_H
+#define __UM_REQUIRED_FEATURES_H
+
+/*
+ * Nothing to see, just need something for the i386 and x86_64 asm
+ * headers to include.
+ */
+
+#endif
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-hostfs-style-fixes.patch
uml-an-idle-system-should-have-zero-load-average.patch
remove-tas.patch
x86-create-asm-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch
uml-fix-build-breakage.patch
uml-mark-a-tt-only-function.patch
fix-linuxdoc-comment.patch
