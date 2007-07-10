From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-block-layer.patch removed from -mm tree
Date: Tue, 10 Jul 2007 12:49:25 -0700
Message-ID: <200707101949.l6AJnP5S026097@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51411 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760485AbXGJTzK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jul 2007 15:55:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, jengelh@gmx.de, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Use menuconfig objects: block layer
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-block-layer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use menuconfig objects: block layer
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Use menuconfigs instead of menus, so the whole menu can be disabled at once
instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN block/Kconfig~use-menuconfig-objects-block-layer block/Kconfig
--- a/block/Kconfig~use-menuconfig-objects-block-layer
+++ a/block/Kconfig
@@ -1,7 +1,7 @@
 #
 # Block layer core configuration
 #
-config BLOCK
+menuconfig BLOCK
        bool "Enable the block layer" if EMBEDDED
        default y
        help
@@ -49,6 +49,6 @@ config LSF
 
 	  If unsure, say Y.
 
-endif
+endif # BLOCK
 
 source block/Kconfig.iosched
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

origin.patch
git-acpi.patch
git-infiniband.patch
git-kvm.patch
use-menuconfig-objects-pcmcia.patch
use-menuconfig-objects-ii-scsi.patch
git-block.patch
use-menuconfig-objects-ii-auxdisplay.patch
use-menuconfig-objects-ii-edac.patch
use-menuconfig-objects-ii-ipmi.patch
use-menuconfig-objects-ii-misc-strange-dev.patch
use-menuconfig-objects-ii-module-menu.patch
use-menuconfig-objects-ii-oprofile.patch
use-menuconfig-objects-ii-telephony.patch
use-menuconfig-objects-ii-tpm.patch
use-menuconfig-objects-connector.patch
use-menuconfig-objects-crypto-hw.patch
use-menuconfig-objects-i2o.patch
use-menuconfig-objects-parport.patch
use-menuconfig-objects-pnp.patch
use-menuconfig-objects-w1.patch
kernel-utf-8-handling.patch
use-menuconfig-objects-isdn-config_isdn.patch
use-menuconfig-objects-isdn-config_isdn_i4l.patch
use-menuconfig-objects-isdn-config_isdn_drv_gigaset.patch
use-menuconfig-objects-isdn-config_isdn_capi.patch
use-menuconfig-objects-isdn-config_capi_avm.patch
use-menuconfig-objects-isdn-config_capi_eicon.patch
use-menuconfig-objects-ii-md.patch
