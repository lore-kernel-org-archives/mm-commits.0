From: akpm@linux-foundation.org
Subject: + acpiphp_ibm-add-missing-n.patch added to -mm tree
Date: Wed, 18 Jul 2007 16:01:46 -0700
Message-ID: <200707182301.l6IN1kUD001167@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44465 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755296AbXGRXCF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 19:02:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, gregkh@suse.de, kristen.c.accardi@intel.com, trivial@kernel.org


The patch titled
     acpiphp_ibm: add missing \n
has been added to the -mm tree.  Its filename is
     acpiphp_ibm-add-missing-n.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: acpiphp_ibm: add missing \n
From: Jeremy Fitzhardinge <jeremy@goop.org>

Add missing \n to error in ibm_find_acpi_device.

Signed-off-by: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Adrian Bunk <trivial@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/acpiphp_ibm.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pci/hotplug/acpiphp_ibm.c~acpiphp_ibm-add-missing-n drivers/pci/hotplug/acpiphp_ibm.c
--- a/drivers/pci/hotplug/acpiphp_ibm.c~acpiphp_ibm-add-missing-n
+++ a/drivers/pci/hotplug/acpiphp_ibm.c
@@ -399,7 +399,7 @@ static acpi_status __init ibm_find_acpi_
 
 	status = acpi_get_object_info(handle, &info_buffer);
 	if (ACPI_FAILURE(status)) {
-		err("%s:  Failed to get device information", __FUNCTION__);
+		err("%s:  Failed to get device information\n", __FUNCTION__);
 		return 0;
 	}
 	info.hardware_id.value[sizeof(info.hardware_id.value) - 1] = '\0';
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
fix-the-softlockup-watchdog-to-actually-work.patch
git-kbuild.patch
acpiphp_ibm-add-missing-n.patch
fix-x86_64-mm-xen-xen-smp-guest-support.patch
fix-x86_64-mm-xen-xen-event-channels.patch
i386-minor-nx-handling-adjustment.patch
x86-fix-iounmaps-use-of-vm_structs-size-field.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
lguest-the-guest-code.patch
