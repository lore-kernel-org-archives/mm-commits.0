From: akpm@linux-foundation.org
Subject: - ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch removed from -mm tree
Date: Thu, 19 Jul 2007 12:49:00 -0700
Message-ID: <200707191949.l6JJn0eT018947@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47160 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933211AbXGSTuC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 15:50:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: venkatesh.pallipadi@intel.com, ak@suse.de, greg@kroah.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     ICH Force HPET: add ICH7_0 pciid to quirk list
has been removed from the -mm tree.  Its filename was
     ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch

This patch was dropped because Changes in Andi's tree destroyed this patch series

------------------------------------------------------
Subject: ICH Force HPET: add ICH7_0 pciid to quirk list
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
 1 files changed, 2 insertions(+)

diff -puN arch/i386/kernel/quirks.c~ich-force-hpet-add-ich7_0-pciid-to-quirk-list arch/i386/kernel/quirks.c
--- a/arch/i386/kernel/quirks.c~ich-force-hpet-add-ich7_0-pciid-to-quirk-list
+++ a/arch/i386/kernel/quirks.c
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
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default-fix.patch
x86_64-block-irq-balancing-for-timer.patch
ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch
