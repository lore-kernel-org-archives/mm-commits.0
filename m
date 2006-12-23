From: akpm@osdl.org
Subject: - mips-if_fddih-add-a-missing-inclusion.patch removed from -mm tree
Date: Fri, 22 Dec 2006 23:54:47 -0800
Message-ID: <200612230754.kBN7sl54010242@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49803 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291AbWLWHzF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Dec 2006 02:55:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, davem@davemloft.net, jeff@garzik.org, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     mips: if_fddi.h: Add a missing inclusion
has been removed from the -mm tree.  Its filename was
     mips-if_fddih-add-a-missing-inclusion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mips: if_fddi.h: Add a missing inclusion
From: "Maciej W. Rozycki" <macro@linux-mips.org>

This is a change to include <linux/netdevice.h> in <linux/if_fddi.h> which is
needed for "struct fddi_statistics".

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/if_fddi.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/if_fddi.h~mips-if_fddih-add-a-missing-inclusion include/linux/if_fddi.h
--- a/include/linux/if_fddi.h~mips-if_fddih-add-a-missing-inclusion
+++ a/include/linux/if_fddi.h
@@ -103,6 +103,8 @@ struct fddihdr
 	} __attribute__ ((packed));
 
 #ifdef __KERNEL__
+#include <linux/netdevice.h>
+
 /* Define FDDI statistics structure */
 struct fddi_statistics {
 
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
mips-turbochannel-update-to-the-driver-model.patch
mips-turbochannel-support-for-the-decstation.patch
mips-eisa-registration-with-config_eisa.patch
mips-declance-driver-model-for-the-pmad-a.patch
mips-defxx-turbochannel-support.patch
mips-pmag-ba-fb-convert-to-the-driver-model.patch
mips-pmagb-b-fb-convert-to-the-driver-model.patch
mips-dec_esp-driver-model-for-the-pmaz-a.patch
i386-io_apic-fix-a-typo-in-an-irq-handler-name.patch
tgafb-switch-to-framebuffer_alloc.patch
tgafb-fix-copying-overlapping-areas.patch
tgafb-support-the-directcolor-visual.patch
tgafb-fix-the-mode-register-setting.patch
tgafb-module-support-fixes.patch
tgafb-sync-on-green-support-fixes.patch
tgafb-fix-the-pci-id-table.patch

