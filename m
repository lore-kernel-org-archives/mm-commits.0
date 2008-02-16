From: akpm@linux-foundation.org
Subject: - isdn-pci-add-missing-file.patch removed from -mm tree
Date: Fri, 15 Feb 2008 17:00:13 -0800
Message-ID: <200802160109.m1G19Fbk001624@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56518 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762906AbYBPBJX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 20:09:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, greg@kroah.com, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     isdn-pci: add missing file
has been removed from the -mm tree.  Its filename was
     isdn-pci-add-missing-file.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isdn-pci: add missing file
From: Jeff Garzik <jeff@garzik.org>

Cc: Greg KH <greg@kroah.com>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hisax/hisax_proto.h |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff -puN /dev/null drivers/isdn/hisax/hisax_proto.h
--- /dev/null
+++ a/drivers/isdn/hisax/hisax_proto.h
@@ -0,0 +1,25 @@
+#ifndef __ISDN_HISAX_HISAX_PROTO_H__
+#define __ISDN_HISAX_HISAX_PROTO_H__
+
+#ifdef CONFIG_HISAX_1TR6
+#define DEFAULT_PROTO ISDN_PTYPE_1TR6
+#define DEFAULT_PROTO_NAME "1TR6"
+#endif
+#ifdef CONFIG_HISAX_NI1
+#undef DEFAULT_PROTO
+#define DEFAULT_PROTO ISDN_PTYPE_NI1
+#undef DEFAULT_PROTO_NAME
+#define DEFAULT_PROTO_NAME "NI1"
+#endif
+#ifdef CONFIG_HISAX_EURO
+#undef DEFAULT_PROTO
+#define DEFAULT_PROTO ISDN_PTYPE_EURO
+#undef DEFAULT_PROTO_NAME
+#define DEFAULT_PROTO_NAME "EURO"
+#endif
+#ifndef DEFAULT_PROTO
+#define DEFAULT_PROTO ISDN_PTYPE_UNKNOWN
+#define DEFAULT_PROTO_NAME "UNKNOWN"
+#endif
+
+#endif /* __ISDN_HISAX_HISAX_PROTO_H__ */
_

Patches currently in -mm which might be from jeff@garzik.org are

git-libata-all.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup.patch
usb-net-asix-does-not-really-need-10-100mbit.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
isdn-pci-add-missing-file.patch
isdn-hisax-modularize-card-setup.patch
isdn-hisax-eliminate-many-unnecessary-references-to-cardtype.patch
isdn-ready-hisax-driver-for-modularization.patch
isdn-hisax-bkm_a4t-convert-to-pci-hotplug-api.patch
isdn-hisax-enternow-convert-to-pci-hotplug-api.patch
isdn-hisax-hfc_pci-w6692-convert-to-pci-hotplug-api.patch
isdn-hisax-nj_s-nj_u-convert-to-pci-hotplug-api.patch
isdn-hisax-telespci-convert-to-pci-hotplug-api.patch
isdn-hisax-avm_pci-convert-to-modern-pci-isa-pnp-probing.patch
isdn-hisax-gazel-convert-to-modern-isa-pci-probing.patch
isdn-hisax-niccy-convert-to-modern-isa-pnp-pci-probing.patch
isdn-hisax-diva-convert-to-modern-isa-pnp-pci-probing.patch
isdn-hisax-bkm_a8-convert-to-pci-hotplug-api.patch
