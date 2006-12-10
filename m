From: akpm@osdl.org
Subject: + kvm-put-kvm-in-a-new-virtualization-menu.patch added to -mm tree
Date: Sun, 10 Dec 2006 11:14:28 -0800
Message-ID: <200612101914.kBAJESRr000463@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51717 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762440AbWLJTOb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 14:14:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com


The patch titled
     KVM: Put KVM in a new Virtualization menu
has been added to the -mm tree.  Its filename is
     kvm-put-kvm-in-a-new-virtualization-menu.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
kvm-userspace-interface.patch
kvm-add-missing-include.patch
kvm-put-kvm-in-a-new-virtualization-menu.patch
kvm-clean-up-amd-svm-debug-registers-load-and-unload.patch
kvm-replace-__x86_64__-with-config_x86_64.patch

