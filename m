From: akpm@linux-foundation.org
Subject: + doc-submitchecklist-add-ioctls-remove-osdl-reference.patch added to -mm tree
Date: Mon, 09 Nov 2009 12:24:09 -0800
Message-ID: <200911092024.nA9KO9KP026905@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753871AbZKIUYK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2009 15:24:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     doc: SubmitChecklist, add ioctls, remove OSDL reference
has been added to the -mm tree.  Its filename is
     doc-submitchecklist-add-ioctls-remove-osdl-reference.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
maintainers-openipmi-list-is-moderated.patch
linux-next.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-depends-on-acpi.patch
scsi-fix-func-names-in-kernel-doc.patch
readahead-add-blk_run_backing_dev.patch
page-types-unsigned-cannot-be-less-than-0-in-add_page.patch
nodemask-make-nodemask_alloc-more-general.patch
hugetlb-rework-hstate_next_node_-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions-fix.patch
hugetlb-factor-init_nodemask_of_node.patch
hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy.patch
hugetlb-add-generic-definition-of-numa_no_node.patch
hugetlb-add-per-node-hstate-attributes.patch
hugetlb-update-hugetlb-documentation-for-numa-controls.patch
hugetlb-use-only-nodes-with-memory-for-huge-pages.patch
mm-clear-node-in-n_high_memory-and-stop-kswapd-when-all-memory-is-offlined.patch
hugetlb-handle-memory-hot-plug-events.patch
hugetlb-offload-per-node-attribute-registrations.patch
hugetlb-offload-per-node-attribute-registrations-fix.patch
mm-add-gfp-flags-for-nodemask_alloc-slab-allocations.patch
spi-add-pci-interface-driver-for-designware-spi-core-fix.patch
docs-large-update-to-ioctl-numbertxt.patch
doc-submitchecklist-add-ioctls-remove-osdl-reference.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

