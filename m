From: akpm@osdl.org
Subject: - kvm-remove-vmx-includes-from-arch-independent-code.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:55:35 -0800
Message-ID: <200612100755.kBA7tZU2017885@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59858 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760574AbWLJHzh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:55:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: remove vmx includes from arch independent code
has been removed from the -mm tree.  Its filename was
     kvm-remove-vmx-includes-from-arch-independent-code.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: remove vmx includes from arch independent code
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm_main.c |    2 --
 drivers/kvm/vmx.c      |    2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/kvm/kvm_main.c~kvm-remove-vmx-includes-from-arch-independent-code drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-remove-vmx-includes-from-arch-independent-code
+++ a/drivers/kvm/kvm_main.c
@@ -35,8 +35,6 @@
 #include <linux/file.h>
 #include <asm/desc.h>
 
-#include "vmx.h"
-#include "kvm_vmx.h"
 #include "x86_emulate.h"
 #include "segment_descriptor.h"
 
diff -puN drivers/kvm/vmx.c~kvm-remove-vmx-includes-from-arch-independent-code drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-remove-vmx-includes-from-arch-independent-code
+++ a/drivers/kvm/vmx.c
@@ -16,9 +16,9 @@
  */
 
 #include "kvm.h"
-#include <linux/module.h>
 #include "vmx.h"
 #include "kvm_vmx.h"
+#include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
 #include <asm/io.h>
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
kvm-remove-vmx-includes-from-arch-independent-code.patch
kvm-amd-svm-add-architecture-definitions-for-amd-svm.patch
kvm-amd-svm-enhance-x86-emulator.patch
kvm-amd-svm-enhance-x86-emulator-fix-mov-to-from-control-register-emulation.patch
kvm-amd-svm-add-missing-tlb-flushes-to-the-guest-mmu.patch
kvm-amd-svm-add-data-structures.patch
kvm-amd-svm-implementation.patch
kvm-amd-svm-implementation-avoid-three-more-new-instructions.patch
kvm-amd-svm-implementation-more-i386-fixes.patch
kvm-amd-svm-implementation-printk-log-levels.patch
kvm-amd-svm-plumbing.patch
kvm-fix-null-and-c99-init-sparse-warnings.patch
kvm-load-i386-segment-bases.patch

