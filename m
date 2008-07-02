From: akpm@linux-foundation.org
Subject: - x86-mm-init_64-fix-printk-format-warning.patch removed from -mm tree
Date: Wed, 02 Jul 2008 00:46:50 -0700
Message-ID: <200807020746.m627kohr005596@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57585 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751096AbYGBHrd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 03:47:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     x86/mm/init_64: fix printk format warning
has been removed from the -mm tree.  Its filename was
     x86-mm-init_64-fix-printk-format-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86/mm/init_64: fix printk format warning
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix x86/mm/init_64.c printk format warning:

linux-next-20080618/arch/x86/mm/init_64.c:834: warning: format '%u' expects type 'unsigned int', but argument 3 has type 'long unsigned int'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/mm/init_64.c~x86-mm-init_64-fix-printk-format-warning arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~x86-mm-init_64-fix-printk-format-warning
+++ a/arch/x86/mm/init_64.c
@@ -830,7 +830,7 @@ int __init reserve_bootmem_generic(unsig
 		if (pfn < max_pfn_mapped)
 			return -EFAULT;
 
-		printk(KERN_ERR "reserve_bootmem: illegal reserve %lx %u\n",
+		printk(KERN_ERR "reserve_bootmem: illegal reserve %lx %lu\n",
 				phys, len);
 		return -EFAULT;
 	}
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
doc-kernel-parameterstxt-fix-stale-references.patch
cpusets-document-proc-status-cpus-and-mems-allowed-lists.patch
linux-next.patch
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
git-kbuild-next.patch
bluetooth-hci_bcsp-fix-bitrev-kconfig.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix-fix.patch
e100-fix-printk-format-warning.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
git-scsi-misc-fix-scsi_dh-build-errors.patch
lkdtm-fix-for-config_scsi=n.patch
git-unionfs.patch
vmallocinfo-add-numa-information.patch
vmallocinfo-add-numa-information-fix.patch
pm-remove-obsolete-piece-of-pm-documentation-rev-2.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
kallsyms-unify-32-and-64-bit-code.patch
procfs-guide-drop-pointless-nbsp-entities.patch
bsdacct-stir-up-comments-around-acct_process.patch
documentation-cleanup-trivial-misspelling-punctuation-and-grammar-corrections.patch
profile-likely-unlikely-macros.patch

