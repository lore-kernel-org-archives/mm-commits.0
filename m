From: akpm@linux-foundation.org
Subject: - i386-irq-kill-irq-compression-fix.patch removed from -mm tree
Date: Tue, 06 Mar 2007 02:51:20 -0800
Message-ID: <200703061051.l26ApK9D020301@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35180 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964865AbXCFKvm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 05:51:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michal.k.k.piotrowski@gmail.com, Natalie.Protasevich@UNISYS.com, ak@suse.de, ebiederm@xmission.com, len.brown@intel.com, mm-commits@vger.kernel.org


The patch titled
     i386-irq-kill-irq-compression fix
has been removed from the -mm tree.  Its filename was
     i386-irq-kill-irq-compression-fix.patch

This patch was dropped because it was folded into i386-irq-kill-irq-compression.patch

------------------------------------------------------
Subject: i386-irq-kill-irq-compression fix
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

arch/i386/kernel/mpparse.c: In function 'mp_register_gsi':
arch/i386/kernel/mpparse.c:1049: warning: unused variable 'pci_irq'

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Natalie Protasevich <Natalie.Protasevich@UNISYS.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/mpparse.c |    1 -
 1 files changed, 1 deletion(-)

diff -puN arch/i386/kernel/mpparse.c~i386-irq-kill-irq-compression-fix arch/i386/kernel/mpparse.c
--- a/arch/i386/kernel/mpparse.c~i386-irq-kill-irq-compression-fix
+++ a/arch/i386/kernel/mpparse.c
@@ -1046,7 +1046,6 @@ int mp_register_gsi(u32 gsi, int trigger
 	int ioapic = -1;
 	int ioapic_pin = 0;
 	int idx, bit = 0;
-	static int pci_irq = 16;
 
 	/* Don't set up the ACPI SCI because it's already set up */
 	if (acpi_gbl_FADT.sci_interrupt == gsi)
_

Patches currently in -mm which might be from michal.k.k.piotrowski@gmail.com are

origin.patch
git-ia64.patch
git-input.patch
i386-irq-kill-irq-compression.patch
i386-irq-kill-irq-compression-fix.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
reiser4.patch
