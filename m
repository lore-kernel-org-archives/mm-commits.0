From: akpm@linux-foundation.org
Subject: - pm-remove-legacy-pm-fix.patch removed from -mm tree
Date: Fri, 04 Apr 2008 12:00:18 -0700
Message-ID: <200804041900.m34J0Ivm004260@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752430AbYDDTBb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2008 15:01:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, pavel@suse.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     PM: Remove legacy PM (fix)
has been removed from the -mm tree.  Its filename was
     pm-remove-legacy-pm-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PM: Remove legacy PM (fix)
From: Randy Dunlap <randy.dunlap@oracle.com>

Source file was removed.  Need to remove docbook reference also.

Are there other files in kernel/power/ that should be added to the docbook?

$ power> kerndoc-search.pl --count *.c
file console.c: 0 kernel-doc blocks
file disk.c: 18 kernel-doc blocks
file main.c: 9 kernel-doc blocks
file poweroff.c: 0 kernel-doc blocks
file process.c: 2 kernel-doc blocks
file snapshot.c: 39 kernel-doc blocks
file swap.c: 10 kernel-doc blocks
file swsusp.c: 4 kernel-doc blocks
file user.c: 0 kernel-doc blocks

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Pavel Machek <pavel@suse.cz>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/kernel-api.tmpl |    5 -----
 1 file changed, 5 deletions(-)

diff -puN Documentation/DocBook/kernel-api.tmpl~pm-remove-legacy-pm-fix Documentation/DocBook/kernel-api.tmpl
--- a/Documentation/DocBook/kernel-api.tmpl~pm-remove-legacy-pm-fix
+++ a/Documentation/DocBook/kernel-api.tmpl
@@ -297,11 +297,6 @@ X!Earch/x86/kernel/mca_32.c
 !Ikernel/acct.c
   </chapter>
 
-  <chapter id="pmfuncs">
-     <title>Power Management</title>
-!Ekernel/power/pm.c
-  </chapter>
-
   <chapter id="devdrivers">
      <title>Device drivers infrastructure</title>
      <sect1><title>Device Drivers Base</title>
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

x86_32-fix-visualws-and-voyager-kexec-build-failures.patch
rapidio-fix-docbook-references.patch
kbuild-silence-documentation-gen-xml-messages-according-to-quiet.patch
git-kvm.patch
git-net.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-unionfs.patch
mempolicy-update-numa-memory-policy-documentation.patch
mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.patch
let-log_buf_shift-default-to-17.patch
sysrq-add-show-backtrace-on-all-cpus-function.patch
isolate-ratelimit-from-printkc-for-other-use-update.patch
documentation-move-spidev_fdx-example-to-its-own-source-file.patch
docbook-some-kernel-locking-fixes.patch
kernel-doc-detect-prevent-duplicate-doc-section-names.patch
kernel-doc-detect-trailing-kernel-doc-line-trash.patch
add-a-document-describing-the-resource-counter-abstraction-v2.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
jbd2-fix-kernel-doc-notation.patch
dma-add-dma_map_attrs-interfaces.patch
dma-document-dma_map_attrs-interfaces.patch
dma-ia64-update-ia64-machvecs-swiotlbc.patch
ib-expand-ib_umem_get-prototype.patch
basic-braille-screen-reader-support-makefile-fix.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
infrastructure-to-debug-dynamic-objects.patch
debugobjects-add-documentation.patch
debugobjects-add-timer-specific-object-debugging-code.patch
add-hrtimer-specific-debugobjects-code.patch
profile-likely-unlikely-macros.patch

