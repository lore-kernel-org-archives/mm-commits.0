From: akpm@linux-foundation.org
Subject: - ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch removed from -mm tree
Date: Mon, 15 Oct 2007 02:18:46 -0700
Message-ID: <200710150918.l9F9IkHC027442@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57570 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757452AbXJOJZE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 05:25:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: venkatesh.pallipadi@intel.com, ak@suse.de, greg@kroah.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     ich force hpet: add ich7_0 pciid to quirk list
has been removed from the -mm tree.  Its filename was
     ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ich force hpet: add ich7_0 pciid to quirk list
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

Add another PCI ID for ICH7 force hpet.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/i386/kernel/quirks.c~ich-force-hpet-add-ich7_0-pciid-to-quirk-list arch/i386/kernel/quirks.c
--- a/arch/x86/kernel/quirks.c~ich-force-hpet-add-ich7_0-pciid-to-quirk-list
+++ a/arch/x86/kernel/quirks.c
@@ -149,6 +149,8 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_I
                          ich_force_enable_hpet);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH6_1,
                          ich_force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH7_0,
+                         ich_force_enable_hpet);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH7_1,
                          ich_force_enable_hpet);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH7_31,
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

origin.patch
git-acpi.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init.patch
hpet-force-enable-on-vt8235-37-chipsets.patch
pm-qos-infrastructure-and-interface-vs-git-acpi.patch
pm-qos-infrastructure-and-interface-vs-git-acpi-2.patch
