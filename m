From: akpm@osdl.org
Subject: - i386-io_apic-fix-a-typo-in-an-irq-handler-name.patch removed from -mm tree
Date: Wed, 10 Jan 2007 15:02:25 -0800
Message-ID: <200701102302.l0AN2PV9010735@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33129 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965198AbXAJXCh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 18:02:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     i386/io_apic: Fix a typo in an IRQ handler name
has been removed from the -mm tree.  Its filename was
     i386-io_apic-fix-a-typo-in-an-irq-handler-name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386/io_apic: Fix a typo in an IRQ handler name
From: "Maciej W. Rozycki" <macro@linux-mips.org>

The "fasteoi" IRQ handler is named "fasteio" incorrectly.  This is a fix.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/io_apic.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/io_apic.c~i386-io_apic-fix-a-typo-in-an-irq-handler-name arch/i386/kernel/io_apic.c
--- a/arch/i386/kernel/io_apic.c~i386-io_apic-fix-a-typo-in-an-irq-handler-name
+++ a/arch/i386/kernel/io_apic.c
@@ -2304,7 +2304,7 @@ static inline void __init check_timer(vo
 
 	disable_8259A_irq(0);
 	set_irq_chip_and_handler_name(0, &lapic_chip, handle_fasteoi_irq,
-				      "fasteio");
+				      "fasteoi");
 	apic_write_around(APIC_LVT0, APIC_DM_FIXED | vector);	/* Fixed mode */
 	enable_8259A_irq(0);
 
_

Patches currently in -mm which might be from macro@linux-mips.org are

mips-turbochannel-update-to-the-driver-model.patch
mips-turbochannel-support-for-the-decstation.patch
mips-eisa-registration-with-config_eisa.patch
mips-declance-driver-model-for-the-pmad-a.patch
mips-defxx-turbochannel-support.patch
mips-pmag-ba-fb-convert-to-the-driver-model.patch
mips-pmagb-b-fb-convert-to-the-driver-model.patch
mips-dec_esp-driver-model-for-the-pmaz-a.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
tgafb-switch-to-framebuffer_alloc.patch
tgafb-fix-copying-overlapping-areas.patch
tgafb-support-the-directcolor-visual.patch
tgafb-fix-the-mode-register-setting.patch
tgafb-module-support-fixes.patch
tgafb-sync-on-green-support-fixes.patch
tgafb-fix-the-pci-id-table.patch
