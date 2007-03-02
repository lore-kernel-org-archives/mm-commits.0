From: akpm@linux-foundation.org
Subject: - xen-paravirt_ops-fix-typo-in-sync_constant_test_bits-name.patch removed from -mm tree
Date: Thu, 01 Mar 2007 20:56:48 -0800
Message-ID: <200703020456.l224um7U000467@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41876 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422898AbXCBE4v (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 23:56:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, jeremy@xensource.com, mm-commits@vger.kernel.org


The patch titled
     xen-paravirt_ops: fix typo in sync_constant_test_bit()s name
has been removed from the -mm tree.  Its filename was
     xen-paravirt_ops-fix-typo-in-sync_constant_test_bits-name.patch

This patch was dropped because Zach's patches destroyed it all

------------------------------------------------------
Subject: xen-paravirt_ops: fix typo in sync_constant_test_bit()s name
From: Jeremy Fitzhardinge <jeremy@goop.org>

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/sync_bitops.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-i386/sync_bitops.h~xen-paravirt_ops-fix-typo-in-sync_constant_test_bits-name include/asm-i386/sync_bitops.h
--- a/include/asm-i386/sync_bitops.h~xen-paravirt_ops-fix-typo-in-sync_constant_test_bits-name
+++ a/include/asm-i386/sync_bitops.h
@@ -130,7 +130,7 @@ static inline int sync_test_and_change_b
 	return oldbit;
 }
 
-static __always_inline int sync_const_test_bit(int nr, const volatile unsigned long *addr)
+static __always_inline int sync_constant_test_bit(int nr, const volatile unsigned long *addr)
 {
 	return ((1UL << (nr & 31)) &
 		(((const volatile unsigned int *)addr)[nr >> 5])) != 0;
_

Patches currently in -mm which might be from jeremy@goop.org are

xen-paravirt_ops-fix-typo-in-sync_constant_test_bits-name.patch
xen-paravirt_ops-use-paravirt_nop-to-consistently-mark-no-op-operations.patch
xen-paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch
xen-paravirt_ops-paravirt_ops-hooks-to-set-up-initial-pagetable.patch
xen-paravirt_ops-paravirt_ops-allocate-a-fixmap-slot.patch
xen-paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
xen-paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction.patch
xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations.patch
xen-paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch
xen-paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure.patch
xen-paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch
xen-paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable.patch
xen-paravirt_ops-add-common-patching-machinery.patch
xen-paravirt_ops-add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
xen-paravirt_ops-allocate-and-free-vmalloc-areas.patch
xen-paravirt_ops-add-nosegneg-capability-to-the-vsyscall-page-notes.patch
xen-paravirt_ops-add-xen-config-options.patch
xen-paravirt_ops-add-xen-interface-header-files.patch
xen-paravirt_ops-core-xen-implementation.patch
xen-paravirt_ops-use-the-hvc-console-infrastructure-for-xen-console.patch
xen-paravirt_ops-add-early-printk-support-via-hvc-console.patch
xen-paravirt_ops-add-xen-grant-table-support.patch
xen-paravirt_ops-add-the-xenbus-sysfs-and-virtual-device-hotplug-driver.patch
xen-paravirt_ops-add-xen-virtual-block-device-driver.patch
xen-paravirt_ops-add-the-xen-virtual-network-device-driver.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
