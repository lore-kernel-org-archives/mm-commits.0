From: akpm@linux-foundation.org
Subject: [merged] maintainers-openipmi-list-is-moderated.patch removed from -mm tree
Date: Fri, 13 Nov 2009 11:26:00 -0800
Message-ID: <200911131926.nADJQ081027096@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35418 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757160AbZKMT0C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 14:26:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, minyard@acm.org, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: openipmi list is moderated
has been removed from the -mm tree.  Its filename was
     maintainers-openipmi-list-is-moderated.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: openipmi list is moderated
From: Randy Dunlap <randy.dunlap@oracle.com>

openipmi list is moderated.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Corey Minyard <minyard@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN MAINTAINERS~maintainers-openipmi-list-is-moderated MAINTAINERS
--- a/MAINTAINERS~maintainers-openipmi-list-is-moderated
+++ a/MAINTAINERS
@@ -2823,7 +2823,7 @@ F:	drivers/infiniband/hw/ipath/
 
 IPMI SUBSYSTEM
 M:	Corey Minyard <minyard@acm.org>
-L:	openipmi-developer@lists.sourceforge.net
+L:	openipmi-developer@lists.sourceforge.net (moderated for non-subscribers)
 W:	http://openipmi.sourceforge.net/
 S:	Supported
 F:	Documentation/IPMI.txt
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

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
mm-add-numa-node-symlink-for-memory-section-in-sysfs.patch
mm-refactor-register_cpu_under_node.patch
mm-refactor-unregister_cpu_under_node.patch
mm-add-numa-node-symlink-for-cpu-devices-in-sysfs.patch
documentation-abi-sys-devices-system-cpu-cpu-node.patch
spi-add-pci-interface-driver-for-designware-spi-core-fix.patch
docs-large-update-to-ioctl-numbertxt.patch
doc-submitchecklist-add-ioctls-remove-osdl-reference.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

