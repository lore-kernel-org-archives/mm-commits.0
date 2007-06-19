From: akpm@linux-foundation.org
Subject: + uml-add-asm-paravirth.patch added to -mm tree
Date: Tue, 19 Jun 2007 16:01:28 -0700
Message-ID: <200706192301.l5JN1SYe023529@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49689 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754239AbXFSXCI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Jun 2007 19:02:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: add asm/paravirt.h
has been added to the -mm tree.  Its filename is
     uml-add-asm-paravirth.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: add asm/paravirt.h
From: Jeff Dike <jdike@addtoit.com>

Add asm-um/paravirt.h so that i386 headers that get pulled into UML
don't cause build failures when they want asm/paravirt.h.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-um/paravirt.h |    6 ++++++
 1 files changed, 6 insertions(+)

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

uml-add-asm-paravirth.patch
hostfs-convert-to-new-aops.patch
uml-fix-request-sector-update.patch
uml-use-get_free_pages-to-allocate-kernel-stacks.patch
uml-add-stack-usage-monitoring.patch
