From: akpm@osdl.org
Subject: - kvm-put-kvm-in-a-new-virtualization-menu.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:00:14 -0800
Message-ID: <200612140600.kBE60Eup001660@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51282 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbWLNGA2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:00:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Put KVM in a new Virtualization menu
has been removed from the -mm tree.  Its filename was
     kvm-put-kvm-in-a-new-virtualization-menu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: Put KVM in a new Virtualization menu
From: Avi Kivity <avi@qumranet.com>

Instead of in the main drivers menu.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/Kconfig |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/kvm/Kconfig~kvm-put-kvm-in-a-new-virtualization-menu drivers/kvm/Kconfig
--- a/drivers/kvm/Kconfig~kvm-put-kvm-in-a-new-virtualization-menu
+++ a/drivers/kvm/Kconfig
@@ -1,6 +1,8 @@
 #
 # KVM configuration
 #
+menu "Virtualization"
+
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
 	depends on X86 && EXPERIMENTAL
@@ -31,3 +33,5 @@ config KVM_AMD
 	---help---
 	  Provides support for KVM on AMD processors equipped with the AMD-V
 	  (SVM) extensions.
+
+endmenu
_

Patches currently in -mm which might be from avi@qumranet.com are

kvm-add-valid_vcpu-helper.patch
kvm-amd-svm-handle-msr_star-in-32-bit-mode.patch
kvm-amd-svm-save-and-restore-the-floating-point-unit.patch

