From: akpm@osdl.org
Subject: - initializer-entry-defined-twice-in-pata_rz1000.patch removed from -mm tree
Date: Tue, 19 Dec 2006 12:31:45 -0800
Message-ID: <200612192031.kBJKVjmv009511@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:60634 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932936AbWLSUcL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Dec 2006 15:32:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kernel@irasnyder.com, alan@lxorguk.ukuu.org.uk, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     initializer entry defined twice in pata_rz1000
has been removed from the -mm tree.  Its filename was
     initializer-entry-defined-twice-in-pata_rz1000.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: initializer entry defined twice in pata_rz1000
From: Ira Snyder <kernel@irasnyder.com>

This removes the extra definition of the .error_handler member
in the pata_rz1000 driver.

Signed-off-by: Ira W. Snyder <kernel@irasnyder.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ata/pata_rz1000.c |    2 --
 1 files changed, 2 deletions(-)

diff -puN drivers/ata/pata_rz1000.c~initializer-entry-defined-twice-in-pata_rz1000 drivers/ata/pata_rz1000.c
--- a/drivers/ata/pata_rz1000.c~initializer-entry-defined-twice-in-pata_rz1000
+++ a/drivers/ata/pata_rz1000.c
@@ -105,8 +105,6 @@ static struct ata_port_operations rz1000
 	.exec_command	= ata_exec_command,
 	.dev_select 	= ata_std_dev_select,
 
-	.error_handler	= rz1000_error_handler,
-
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
 	.bmdma_stop	= ata_bmdma_stop,
_

Patches currently in -mm which might be from kernel@irasnyder.com are

origin.patch
initializer-entry-defined-twice-in-pata_rz1000.patch

