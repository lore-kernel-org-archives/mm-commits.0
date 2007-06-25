From: akpm@linux-foundation.org
Subject: - uml-add-asm-paravirth.patch removed from -mm tree
Date: Mon, 25 Jun 2007 02:21:07 -0700
Message-ID: <200706250921.l5P9L7Mw031071@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54228 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751843AbXFYJVT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 05:21:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: add asm/paravirt.h
has been removed from the -mm tree.  Its filename was
     uml-add-asm-paravirth.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: add asm/paravirt.h
From: Jeff Dike <jdike@addtoit.com>

Add asm-um/paravirt.h so that i386 headers that get pulled into UML
don't cause build failures when they want asm/paravirt.h.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-um/paravirt.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN /dev/null include/asm-um/paravirt.h
--- /dev/null
+++ a/include/asm-um/paravirt.h
@@ -0,0 +1,6 @@
+#ifndef __UM_PARAVIRT_H
+#define __UM_PARAVIRT_H
+
+#include "asm/arch/paravirt.h"
+
+#endif
_

Patches currently in -mm which might be from jdike@addtoit.com are

hostfs-convert-to-new-aops.patch
uml-fix-request-sector-update.patch
uml-use-get_free_pages-to-allocate-kernel-stacks.patch
uml-add-stack-usage-monitoring.patch
