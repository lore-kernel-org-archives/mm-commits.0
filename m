From: akpm@linux-foundation.org
Subject: [obsolete] acpi-get_bios_limit-static-inline-when-cpu_freq=n.patch removed from -mm tree
Date: Thu, 19 Nov 2009 13:20:32 -0800
Message-ID: <200911192120.nAJLKWrE020472@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49079 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753010AbZKSVVa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Nov 2009 16:21:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi: get_bios_limit static inline when CPU_FREQ=n
has been removed from the -mm tree.  Its filename was
     acpi-get_bios_limit-static-inline-when-cpu_freq=n.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: get_bios_limit static inline when CPU_FREQ=n
From: Randy Dunlap <randy.dunlap@oracle.com>

For CONFIG_CPU_FREQ=n, make acpi_processor_get_bios_limit() static inline
so that multiple source files that use this header file do not create
multiple definitions of the function.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/acpi/processor.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/acpi/processor.h~acpi-get_bios_limit-static-inline-when-cpu_freq=n include/acpi/processor.h
--- a/include/acpi/processor.h~acpi-get_bios_limit-static-inline-when-cpu_freq=n
+++ a/include/acpi/processor.h
@@ -318,7 +318,7 @@ static inline int acpi_processor_ppc_has
 	}
 	return 0;
 }
-int acpi_processor_get_bios_limit(int cpu, unsigned int *limit)
+static inline int acpi_processor_get_bios_limit(int cpu, unsigned int *limit)
 {
 	return -ENODEV;
 }
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
hso-fix-debug-routines.patch
hso-fix-soft-lockup.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
acpi-get_bios_limit-static-inline-when-cpu_freq=n.patch
x86-cpufreq-dont-use-acpi_processor_get_bios_limit-when-not-available.patch
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
partitions-use-sector-size-for-efi-gpt-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

