From: akpm@osdl.org
Subject: - kvm-clarify-licensing.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:53:07 -0800
Message-ID: <200612100753.kBA7r7Kt017706@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59604 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760449AbWLJHxJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:53:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Clarify licensing
has been removed from the -mm tree.  Its filename was
     kvm-clarify-licensing.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: Clarify licensing
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h         |    5 +++++
 drivers/kvm/kvm_main.c    |    3 +++
 drivers/kvm/mmu.c         |    3 +++
 drivers/kvm/paging_tmpl.h |   19 +++++++++++++++++++
 drivers/kvm/x86_emulate.c |    3 +++
 5 files changed, 33 insertions(+)

diff -puN drivers/kvm/kvm.h~kvm-clarify-licensing drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-clarify-licensing
+++ a/drivers/kvm/kvm.h
@@ -1,6 +1,11 @@
 #ifndef __KVM_H
 #define __KVM_H
 
+/*
+ * This work is licensed under the terms of the GNU GPL, version 2.  See
+ * the COPYING file in the top-level directory.
+ */
+
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
diff -puN drivers/kvm/kvm_main.c~kvm-clarify-licensing drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-clarify-licensing
+++ a/drivers/kvm/kvm_main.c
@@ -10,6 +10,9 @@
  *   Avi Kivity   <avi@qumranet.com>
  *   Yaniv Kamay  <yaniv@qumranet.com>
  *
+ * This work is licensed under the terms of the GNU GPL, version 2.  See
+ * the COPYING file in the top-level directory.
+ *
  */
 
 #include "kvm.h"
diff -puN drivers/kvm/mmu.c~kvm-clarify-licensing drivers/kvm/mmu.c
--- a/drivers/kvm/mmu.c~kvm-clarify-licensing
+++ a/drivers/kvm/mmu.c
@@ -12,6 +12,9 @@
  *   Yaniv Kamay  <yaniv@qumranet.com>
  *   Avi Kivity   <avi@qumranet.com>
  *
+ * This work is licensed under the terms of the GNU GPL, version 2.  See
+ * the COPYING file in the top-level directory.
+ *
  */
 #include <linux/types.h>
 #include <linux/string.h>
diff -puN drivers/kvm/paging_tmpl.h~kvm-clarify-licensing drivers/kvm/paging_tmpl.h
--- a/drivers/kvm/paging_tmpl.h~kvm-clarify-licensing
+++ a/drivers/kvm/paging_tmpl.h
@@ -1,4 +1,23 @@
 /*
+ * Kernel-based Virtual Machine driver for Linux
+ *
+ * This module enables machines with Intel VT-x extensions to run virtual
+ * machines without emulation or binary translation.
+ *
+ * MMU support
+ *
+ * Copyright (C) 2006 Qumranet, Inc.
+ *
+ * Authors:
+ *   Yaniv Kamay  <yaniv@qumranet.com>
+ *   Avi Kivity   <avi@qumranet.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.  See
+ * the COPYING file in the top-level directory.
+ *
+ */
+
+/*
  * We need the mmu code to access both 32-bit and 64-bit guest ptes,
  * so the code in this file is compiled twice, once per pte size.
  */
diff -puN drivers/kvm/x86_emulate.c~kvm-clarify-licensing drivers/kvm/x86_emulate.c
--- a/drivers/kvm/x86_emulate.c~kvm-clarify-licensing
+++ a/drivers/kvm/x86_emulate.c
@@ -13,6 +13,9 @@
  *   Avi Kivity <avi@qumranet.com>
  *   Yaniv Kamay <yaniv@qumranet.com>
  *
+ * This work is licensed under the terms of the GNU GPL, version 2.  See
+ * the COPYING file in the top-level directory.
+ *
  * From: xen-unstable 10676:af9809f51f81a3c43f276f00c81a52ef558afda4
  */
 
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
kvm-clarify-licensing.patch
kvm-x86-emulator-fix-emulator-mov-cr-decoding.patch
kvm-plumbing.patch
kvm-dynamically-determine-which-msrs-to-load-and-save.patch
kvm-fix-calculation-of-initial-value-of-rdx-register.patch
kvm-avoid-using-vmx-instruction-directly.patch
kvm-avoid-using-vmx-instruction-directly-fix-asm-constraints.patch
kvm-expose-interrupt-bitmap.patch
kvm-add-time-stamp-counter-msr-and-accessors.patch
kvm-expose-msrs-to-userspace.patch
kvm-expose-msrs-to-userspace-v2.patch
kvm-create-kvm-intelko-module.patch
kvm-make-dev-registration-happen-when-the-arch.patch
kvm-make-hardware-detection-an-arch-operation.patch
kvm-make-the-per-cpu-enable-disable-functions-arch.patch
kvm-make-the-hardware-setup-operations-non-percpu.patch
kvm-make-the-guest-debugger-an-arch-operation.patch
kvm-make-msr-accessors-arch-operations.patch
kvm-make-the-segment-accessors-arch-operations.patch
kvm-cache-guest-cr4-in-vcpu-structure.patch
kvm-cache-guest-cr0-in-vcpu-structure.patch
kvm-add-get_segment_base-arch-accessor.patch
kvm-add-idt-and-gdt-descriptor-accessors.patch
kvm-make-syncing-the-register-file-to-the-vcpu.patch
kvm-make-the-vcpu-execution-loop-an-arch-operation.patch
kvm-make-the-vcpu-execution-loop-an-arch-operation-build-fix.patch
kvm-move-the-vmx-exit-handlers-to-vmxc.patch
kvm-make-vcpu_setup-an-arch-operation.patch
kvm-make-__set_cr0-and-dependencies-arch-operations.patch
kvm-make-__set_cr4-an-arch-operation.patch
kvm-make-__set_efer-an-arch-operation.patch
kvm-make-__set_efer-an-arch-operation-build-fix.patch
kvm-make-set_cr3-and-tlb-flushing-arch-operations.patch
kvm-make-inject_page_fault-an-arch-operation.patch
kvm-make-inject_gp-an-arch-operation.patch
kvm-use-the-idt-and-gdt-accessors-in-realmode-emulation.patch
kvm-use-the-general-purpose-register-accessors-rather.patch
kvm-move-the-vmx-tsc-accessors-to-vmxc.patch
kvm-access-rflags-through-an-arch-operation.patch
kvm-move-the-vmx-segment-field-definitions-to-vmxc.patch
kvm-add-an-arch-accessor-for-cs-d-b-and-l-bits.patch
kvm-add-a-set_cr0_no_modeswitch-arch-accessor.patch
kvm-make-vcpu_load-and-vcpu_put-arch-operations.patch
kvm-make-vcpu-creation-and-destruction-arch-operations.patch
kvm-move-vmcs-static-variables-to-vmxc.patch
kvm-make-is_long_mode-an-arch-operation.patch
kvm-use-the-tlb-flush-arch-operation-instead-of-an.patch
kvm-remove-guest_cpl.patch
kvm-move-vmcs-accessors-to-vmxc.patch
kvm-move-vmx-helper-inlines-to-vmxc.patch
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

