From: akpm@osdl.org
Subject: + kvm-needs-menu-structure.patch added to -mm tree
Date: Mon, 11 Dec 2006 15:34:44 -0800
Message-ID: <200612112334.kBBNYiBR012672@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49631 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbWLKXfC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Dec 2006 18:35:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, avi@qumranet.com


The patch titled
     kvm needs menu structure
has been added to the -mm tree.  Its filename is
     kvm-needs-menu-structure.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kvm needs menu structure
From: Randy Dunlap <randy.dunlap@oracle.com>

KVM config items need to be inside a menu structure instead of dangling off
of Device Drivers.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/kvm/Kconfig~kvm-needs-menu-structure drivers/kvm/Kconfig
--- a/drivers/kvm/Kconfig~kvm-needs-menu-structure
+++ a/drivers/kvm/Kconfig
@@ -3,7 +3,7 @@
 #
 menu "Virtualization"
 
-config KVM
+menuconfig KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
 	depends on X86 && EXPERIMENTAL
 	---help---
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
fix-section-mismatch-in-parainstructions.patch
kconfig-new-function-bool-conf_get_changedvoid.patch
kconfig-make-sym_change_count-static-let-it-be-altered-by-2-functions-only.patch
kconfig-add-void-conf_set_changed_callbackvoid-fnvoid-use-it-in-qconfcc.patch
kconfig-set-gconfs-save-widgets-sensitivity-according-to-configs-changed-state.patch
kvm-needs-menu-structure.patch
git-acpi.patch
git-alsa.patch
cpufreq-select-consistently-re-2619-rc5-mm1.patch
git-mtd.patch
git-net.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
kbuild-make-fusion-mpt-selectable-from-device-drivers.patch
reiser4-use-null-for-pointers.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
profile_likely-export-do_check_likely.patch

