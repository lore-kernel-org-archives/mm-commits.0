From: akpm@linux-foundation.org
Subject: - kerneldoc-fix-in-libata.patch removed from -mm tree
Date: Sat, 23 Jun 2007 12:28:15 -0700
Message-ID: <200706231928.l5NJSFib022128@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50548 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752657AbXFWTef (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 15:34:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: henne@nachtwindheim.de, mm-commits@vger.kernel.org


The patch titled
     kerneldoc fix in libata
has been removed from the -mm tree.  Its filename was
     kerneldoc-fix-in-libata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kerneldoc fix in libata
From: Henrik Kretzschmar <henne@nachtwindheim.de>

Fix parameter name from ata_dev_reread_id() in libata-core.c for kerneldoc.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ata/libata-core.c~kerneldoc-fix-in-libata drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~kerneldoc-fix-in-libata
+++ a/drivers/ata/libata-core.c
@@ -3665,7 +3665,7 @@ static int ata_dev_same_device(struct at
 
 /**
  *	ata_dev_reread_id - Re-read IDENTIFY data
- *	@adev: target ATA device
+ *	@dev: target ATA device
  *	@readid_flags: read ID flags
  *
  *	Re-read IDENTIFY page and make sure @dev is still attached to
_

Patches currently in -mm which might be from henne@nachtwindheim.de are

origin.patch
kerneldoc-fix-in-audit_core_dumps.patch
