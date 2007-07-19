From: akpm@linux-foundation.org
Subject: + lguest-fix.patch added to -mm tree
Date: Wed, 18 Jul 2007 23:22:44 -0700
Message-ID: <200707190627.l6J6RCf5017730@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41970 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754208AbXGSG1W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 02:27:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au


The patch titled
     lguest fix
has been added to the -mm tree.  Its filename is
     lguest-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lguest fix
From: Andrew Morton <akpm@linux-foundation.org>

sched_clock isn't there yet.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/lguest.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/lguest/lguest.c~lguest-fix drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c~lguest-fix
+++ a/drivers/lguest/lguest.c
@@ -39,7 +39,7 @@
 #include <asm/e820.h>
 #include <asm/mce.h>
 #include <asm/io.h>
-#include <asm/sched-clock.h>
+//#include <asm/sched-clock.h>
 
 /* Declarations for definitions in lguest_guest.S */
 extern char lguest_noirq_start[], lguest_noirq_end[];
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-fault-feedback-2.patch
freezer-run-show_state-when-freezing-times-out.patch
pm-introduce-hibernation-and-suspend-notifiers.patch
pm-disable-usermode-helper-before-hibernation-and-suspend.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
lockstat-core-infrastructure.patch
lockstat-human-readability-tweaks.patch
lockdep-various-fixes.patch
lockstat-measure-lock-bouncing.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
dequeue_huge_page-warning-fix.patch
lguest-the-host-code.patch
lguest-fix.patch
lguest-the-net-driver.patch
drivers-edac-new-i82443bxgz-mc-driver-broken.patch
drivers-edac-fix-e752x-reversed-csrows-fix.patch
drivers-edac-new-pasemi-driver-fix.patch
drivers-edac-new-i82975x-driver-fix.patch
kernel-sysctlc-finish-off-the-warning-comments.patch
