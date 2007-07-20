From: akpm@linux-foundation.org
Subject: - dpt_i2o-depends-on-virt_to_bus.patch removed from -mm tree
Date: Fri, 20 Jul 2007 12:41:54 -0700
Message-ID: <200707201941.l6KJfsNr012979@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38207 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763613AbXGTTmH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 15:42:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     dpt_i2o depends on virt_to_bus
has been removed from the -mm tree.  Its filename was
     dpt_i2o-depends-on-virt_to_bus.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dpt_i2o depends on virt_to_bus
From: Stephen Rothwell <sfr@canb.auug.org.au>

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/Kconfig~dpt_i2o-depends-on-virt_to_bus drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig~dpt_i2o-depends-on-virt_to_bus
+++ a/drivers/scsi/Kconfig
@@ -483,7 +483,7 @@ source "drivers/scsi/aic94xx/Kconfig"
 # All the I2O code and drivers do not seem to be 64bit safe.
 config SCSI_DPT_I2O
 	tristate "Adaptec I2O RAID support "
-	depends on !64BIT && SCSI && PCI
+	depends on !64BIT && SCSI && PCI && VIRT_TO_BUS
 	help
 	  This driver supports all of Adaptec's I2O based RAID controllers as 
 	  well as the DPT SmartRaid V cards.  This is an Adaptec maintained
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
stradis-and-zoran-depend-on-virt_to_bus.patch
toshiba_fir-depends-on-virt_to_bus.patch
