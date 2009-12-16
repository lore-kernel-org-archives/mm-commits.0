From: akpm@linux-foundation.org
Subject: [merged] doc-submitchecklist-add-ioctls-remove-osdl-reference.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:37:18 -0800
Message-ID: <200912162037.nBGKbI21013322@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54124 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935487AbZLPUhX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:37:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     doc: SubmitChecklist, add ioctls, remove OSDL reference
has been removed from the -mm tree.  Its filename was
     doc-submitchecklist-add-ioctls-remove-osdl-reference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: doc: SubmitChecklist, add ioctls, remove OSDL reference
From: Randy Dunlap <randy.dunlap@oracle.com>

If a patch adds ioctls, then Documentation/ioctl/ioctl-number.txt
should also be updated.

Remove reference to the OSDL PLM build farm.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/SubmitChecklist |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN Documentation/SubmitChecklist~doc-submitchecklist-add-ioctls-remove-osdl-reference Documentation/SubmitChecklist
--- a/Documentation/SubmitChecklist~doc-submitchecklist-add-ioctls-remove-osdl-reference
+++ a/Documentation/SubmitChecklist
@@ -15,7 +15,7 @@ kernel patches.
 2: Passes allnoconfig, allmodconfig
 
 3: Builds on multiple CPU architectures by using local cross-compile tools
-   or something like PLM at OSDL.
+   or some other build farm.
 
 4: ppc64 is a good architecture for cross-compilation checking because it
    tends to use `unsigned long' for 64-bit quantities.
@@ -88,3 +88,6 @@ kernel patches.
 
 24: All memory barriers {e.g., barrier(), rmb(), wmb()} need a comment in the
     source code that explains the logic of what they are doing and why.
+
+25: If any ioctl's are added by the patch, then also update
+    Documentation/ioctl/ioctl-number.txt.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
docs-large-update-to-ioctl-numbertxt.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
readahead-add-blk_run_backing_dev.patch
spi-controller-driver-for-designware-spi-core.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

