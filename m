From: akpm@linux-foundation.org
Subject: - xen-xen-pageh-compile-fix.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:11:23 -0700
Message-ID: <200707290611.l6T6BNvj010980@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44382 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756512AbXG2GLb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:11:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, jeremy@xensource.com, mm-commits@vger.kernel.org


The patch titled
     xen: xen/page.h compile fix
has been removed from the -mm tree.  Its filename was
     xen-xen-pageh-compile-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: xen: xen/page.h compile fix
From: Jeremy Fitzhardinge <jeremy@goop.org>

Fix:
linux/include/xen/page.h: In function mfn_pte:
linux/include/xen/page.h:149: error: __supported_pte_mask undeclared (first use in this function)
linux/include/xen/page.h:149: error: (Each undeclared identifier is reported only once
linux/include/xen/page.h:149: error: for each function it appears in.)

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/xen/page.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/xen/page.h~xen-xen-pageh-compile-fix include/xen/page.h
--- a/include/xen/page.h~xen-xen-pageh-compile-fix
+++ a/include/xen/page.h
@@ -4,6 +4,7 @@
 #include <linux/pfn.h>
 
 #include <asm/uaccess.h>
+#include <asm/pgtable.h>
 
 #include <xen/features.h>
 
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
acpiphp_ibm-add-missing-n.patch
clean-up-duplicate-includes-in-arch-i386-xen.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
fix-the-softlockup-watchdog-to-actually-work.patch
