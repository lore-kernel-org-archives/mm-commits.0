From: akpm@linux-foundation.org
Subject: + change-misleading-efi-partition-support-description.patch added to -mm tree
Date: Thu, 15 Mar 2007 20:13:13 -0800
Message-ID: <200703160413.l2G4DDGd002234@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53435 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbXCPENb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Mar 2007 00:13:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johannes@sipsolutions.net, Matt_Domsch@dell.com


The patch titled
     change misleading EFI partition support description
has been added to the -mm tree.  Its filename is
     change-misleading-efi-partition-support-description.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
change-misleading-efi-partition-support-description.patch
git-alsa.patch
git-wireless.patch
