From: akpm@osdl.org
Subject: - uml-include-asm-pageh-in-order-to-get-page_shift.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:00:09 -0800
Message-ID: <200612072300.kB7N09gD029613@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51176 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163704AbWLGXAM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:00:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: include asm/page.h in order to get PAGE_SHIFT
has been removed from the -mm tree.  Its filename was
     uml-include-asm-pageh-in-order-to-get-page_shift.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: include asm/page.h in order to get PAGE_SHIFT
From: Jeff Dike <jdike@addtoit.com>

Include the proper header to get a definition of PAGE_SHIFT.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/um/include/sysdep-i386/stub.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/um/include/sysdep-i386/stub.h~uml-include-asm-pageh-in-order-to-get-page_shift arch/um/include/sysdep-i386/stub.h
--- a/arch/um/include/sysdep-i386/stub.h~uml-include-asm-pageh-in-order-to-get-page_shift
+++ a/arch/um/include/sysdep-i386/stub.h
@@ -9,6 +9,7 @@
 #include <sys/mman.h>
 #include <asm/ptrace.h>
 #include <asm/unistd.h>
+#include <asm/page.h>
 #include "stub-data.h"
 #include "kern_constants.h"
 #include "uml-config.h"
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
x86_64-i386-kernel-mode-faults-pollute-current-thead.patch
uml-fix-prototypes.patch
tty-signal-tty-locking.patch
uml-add-generic-bug-support.patch
add-process_session-helper-routine-deprecate-old-field-fix-warnings-fix.patch
tty-switch-to-ktermios-uml-fix.patch

