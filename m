From: akpm@linux-foundation.org
Subject: [merged] sysfs-fix-sysfs_deprecated_v2-prompt.patch removed from -mm tree
Date: Thu, 03 Dec 2009 12:36:11 -0800
Message-ID: <200912032036.nB3KaBHn011609@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42870 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754739AbZLCUgO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Dec 2009 15:36:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, greg@kroah.com, kay.sievers@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     sysfs: fix SYSFS_DEPRECATED_V2 prompt
has been removed from the -mm tree.  Its filename was
     sysfs-fix-sysfs_deprecated_v2-prompt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysfs: fix SYSFS_DEPRECATED_V2 prompt
From: Randy Dunlap <randy.dunlap@oracle.com>

The SYSFS_DEPRECATED_V2 says "remove" older, deprecated features, but it
actually enables them, so correct this confusing, backwards text.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/Kconfig~sysfs-fix-sysfs_deprecated_v2-prompt init/Kconfig
--- a/init/Kconfig~sysfs-fix-sysfs_deprecated_v2-prompt
+++ a/init/Kconfig
@@ -606,7 +606,7 @@ config SYSFS_DEPRECATED
 	bool
 
 config SYSFS_DEPRECATED_V2
-	bool "remove sysfs features which may confuse old userspace tools"
+	bool "enable deprecated sysfs features which may confuse old userspace tools"
 	depends on SYSFS
 	default n
 	select SYSFS_DEPRECATED
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
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
writeback-fix-missing-kernel-doc-notation.patch
lis3-update-documentation-to-match-latest-changes-fix.patch
spi-add-pci-interface-driver-for-designware-spi-core-fix.patch
docs-large-update-to-ioctl-numbertxt.patch
doc-submitchecklist-add-ioctls-remove-osdl-reference.patch
proc-remove-docbook-and-example.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

