From: akpm@linux-foundation.org
Subject: + kvm-bump-api-version.patch added to -mm tree
Date: Wed, 21 Feb 2007 18:21:05 -0800
Message-ID: <200702220221.l1M2L5C3001708@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33965 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381AbXBVCVH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 21:21:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com


The patch titled
     kvm: bump API version
has been added to the -mm tree.  Its filename is
     kvm-bump-api-version.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kvm: bump API version
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kvm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/kvm.h~kvm-bump-api-version include/linux/kvm.h
--- a/include/linux/kvm.h~kvm-bump-api-version
+++ a/include/linux/kvm.h
@@ -11,7 +11,7 @@
 #include <asm/types.h>
 #include <linux/ioctl.h>
 
-#define KVM_API_VERSION 3
+#define KVM_API_VERSION 4
 
 /*
  * Architectural interrupt line count, and the size of the bitmap needed
_

Patches currently in -mm which might be from avi@qumranet.com are

kvm-mmu-add-missing-dirty-page-tracking-cases.patch
kvm-move-virtualization-deactivation-from-cpu_dead.patch
kvm-cosmetics.patch
kvm-vmx-hack-set_cr0_no_modeswitch-to-actually-do.patch
kvm-use-array_size-macro-instead-of-manual-calculation.patch
kvm-use-page_private-set_page_private-apis.patch
kvm-add-msr-based-hypercall-api.patch
kvm-add-host-hypercall-support-for-vmx.patch
kvm-add-hypercall-host-support-for-svm.patch
kvm-wire-up-hypercall-handlers-to-a-central.patch
kvm-svm-init-cr0-with-the-wp-bit-set.patch
kvm-svm-intercept-smi-to-handle-it-at-host-level.patch
kvm-more-0-null-conversions.patch
kvm-add-internal-filesystem-for-generating-inodes.patch
kvm-add-internal-filesystem-for-generating-inodes-tweak.patch
kvm-create-an-inode-per-virtual-machine.patch
kvm-rename-some-kvm_dev_ioctl_-functions-to.patch
kvm-move-kvm_vm_ioctl_create_vcpu-around.patch
kvm-per-vcpu-inodes.patch
kvm-bump-api-version.patch
