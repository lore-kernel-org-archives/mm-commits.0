From: akpm@linux-foundation.org
Subject: - uml-fix-build-breakage.patch removed from -mm tree
Date: Wed, 09 May 2007 14:49:27 -0700
Message-ID: <200705092149.l49LnRlC002697@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59091 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755589AbXEIVtc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:49:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: fix build breakage
has been removed from the -mm tree.  Its filename was
     uml-fix-build-breakage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: fix build breakage
From: Jeff Dike <jdike@addtoit.com>

UML now needs required-features.h to build - an empty one suffices.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-um/required-features.h |    9 +++++++++
 1 file changed, 9 insertions(+)

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
