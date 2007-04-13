From: akpm@linux-foundation.org
Subject: - paravirt_ops-update-maintainers.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:29:54 -0700
Message-ID: <200704132329.l3DNTscP012660@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60709 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161258AbXDMXao (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:30:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, chrisw@sous-sol.org, jeremy@xensource.com, rusty@rustcorp.com.au, zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     paravirt_ops: update MAINTAINERS
has been removed from the -mm tree.  Its filename was
     paravirt_ops-update-maintainers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: paravirt_ops: update MAINTAINERS
From: Jeremy Fitzhardinge <jeremy@goop.org>

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Zachary Amsden <zach@vmware.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff -puN MAINTAINERS~paravirt_ops-update-maintainers MAINTAINERS
--- a/MAINTAINERS~paravirt_ops-update-maintainers
+++ a/MAINTAINERS
@@ -2679,6 +2679,19 @@ T:	git kernel.org:/pub/scm/linux/kernel/
 T:	cvs cvs.parisc-linux.org:/var/cvs/linux-2.6
 S:	Maintained
 
+PARAVIRT_OPS INTERFACE
+P:	Jeremy Fitzhardinge
+M:	jeremy@xensource.com
+P:	Chris Wright
+M:	chrisw@sous-sol.org
+P:	Zachary Amsden
+M:	zach@vmware.com
+P:	Rusty Russell
+M:	rusty@rustcorp.com.au
+L:	virtualization@lists.osdl.org
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+
 PC87360 HARDWARE MONITORING DRIVER
 P:	Jim Cromie
 M:	jim.cromie@gmail.com
@@ -3936,6 +3949,15 @@ M:	eis@baty.hanse.de
 L:	linux-x25@vger.kernel.org
 S:	Maintained
 
+XEN HYPERVISOR INTERFACE
+P:	Jeremy Fitzhardinge
+M:	jeremy@xensource.com
+P:	Chris Wright
+M:	chrisw@sous-sol.org
+L:	virtualization@lists.osdl.org
+L:	xen-devel@lists.xensource.com
+S:	Supported
+
 XFS FILESYSTEM
 P:	Silicon Graphics Inc
 P:	Tim Shimmin, David Chatterton
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
revert-proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621.patch
revert-x86_64-mm-account-for-module-percpu-space-separately-from-kernel-percpu.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others-fix.patch
allow-boot-time-disable-of-paravirt_ops-patching.patch
x86-clean-up-identify_cpu-update.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings.patch
mm-only-i386-for-debugging-make-the-initial-page-table-setup-less-forgiving.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
add-touch_all_softlockup_watchdogs.patch
clean-up-elf-note-generation.patch
deflate-stack-usage-in-lib-inflatec.patch
