From: akpm@linux-foundation.org
Subject: - change-misleading-efi-partition-support-description.patch removed from -mm tree
Date: Sun, 18 Mar 2007 01:10:08 -0800
Message-ID: <200703180910.l2I9A8XH020067@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60495 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbXCRJKW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 05:10:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johannes@sipsolutions.net, Matt_Domsch@dell.com, mm-commits@vger.kernel.org


The patch titled
     change misleading EFI partition support description
has been removed from the -mm tree.  Its filename was
     change-misleading-efi-partition-support-description.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: change misleading EFI partition support description
From: Johannes Berg <johannes@sipsolutions.net>

Remove the misleading "Presently only useful on the IA-64 platform" text
from the EFI partition Kconfig.

EFI partitions are also used by Apple on their Intel-based machines and
thus you need EFI partition support if you (for example) want to attach
such a machine in target disk mode.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Matt Domsch <Matt_Domsch@dell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/partitions/Kconfig~change-misleading-efi-partition-support-description fs/partitions/Kconfig
--- a/fs/partitions/Kconfig~change-misleading-efi-partition-support-description
+++ a/fs/partitions/Kconfig
@@ -235,5 +235,4 @@ config EFI_PARTITION
 	select CRC32
 	help
 	  Say Y here if you would like to use hard disks under Linux which
-	  were partitioned using EFI GPT.  Presently only useful on the
-	  IA-64 platform.
+	  were partitioned using EFI GPT.
_

Patches currently in -mm which might be from johannes@sipsolutions.net are

origin.patch
git-alsa.patch
git-wireless.patch
