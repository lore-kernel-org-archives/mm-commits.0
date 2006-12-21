From: akpm@osdl.org
Subject: + mips-if_fddih-add-a-missing-inclusion.patch added to -mm tree
Date: Wed, 20 Dec 2006 20:58:20 -0800
Message-ID: <200612210458.kBL4wKaK016112@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:38159 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422728AbWLUE6e (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 23:58:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macro@linux-mips.org, davem@davemloft.net, jeff@garzik.org, ralf@linux-mips.org


The patch titled
     mips: if_fddi.h: Add a missing inclusion
has been added to the -mm tree.  Its filename is
     mips-if_fddih-add-a-missing-inclusion.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

mips-if_fddih-add-a-missing-inclusion.patch
mips-turbochannel-update-to-the-driver-model.patch
mips-turbochannel-support-for-the-decstation.patch
mips-eisa-registration-with-config_eisa.patch
mips-declance-driver-model-for-the-pmad-a.patch
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

