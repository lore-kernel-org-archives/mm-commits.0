From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-ib-block.patch removed from -mm tree
Date: Tue, 10 Jul 2007 12:49:28 -0700
Message-ID: <200707101949.l6AJnSUs026100@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59297 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760499AbXGJTzK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jul 2007 15:55:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, axboe@kernel.dk, jengelh@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Use menuconfig objects I.b - block
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-ib-block.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use menuconfig objects I.b - block
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

block/Kconfig already has its own "menuconfig" so remove these
"menu, endmenu" that did not get cleaned up in the block patch
[ http://lkml.org/lkml/2007/4/10/251 ]

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    2 --
 1 files changed, 2 deletions(-)

diff -puN init/Kconfig~use-menuconfig-objects-ib-block init/Kconfig
--- a/init/Kconfig~use-menuconfig-objects-ib-block
+++ a/init/Kconfig
@@ -686,6 +686,4 @@ config STOP_MACHINE
 	  Need stop_machine() primitive.
 endmenu
 
-menu "Block layer"
 source "block/Kconfig"
-endmenu
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
