From: akpm@linux-foundation.org
Subject: + partition-use-default_sgi_partition-for-sgi_partion-default.patch added to -mm tree
Date: Wed, 12 Dec 2007 02:35:17 -0800
Message-ID: <200712121035.lBCAZHhB005444@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60252 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757406AbXLLKfU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 05:35:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tsbogend@alpha.franken.de


The patch titled
     partition: use DEFAULT_SGI_PARTITION for SGI_PARTION default
has been added to the -mm tree.  Its filename is
     partition-use-default_sgi_partition-for-sgi_partion-default.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: partition: use DEFAULT_SGI_PARTITION for SGI_PARTION default
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

Use DEFAULT_SGI_PARTITION for SGI_PARTION default

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/partitions/Kconfig~partition-use-default_sgi_partition-for-sgi_partion-default fs/partitions/Kconfig
--- a/fs/partitions/Kconfig~partition-use-default_sgi_partition-for-sgi_partion-default
+++ a/fs/partitions/Kconfig
@@ -198,7 +198,7 @@ config LDM_DEBUG
 
 config SGI_PARTITION
 	bool "SGI partition support" if PARTITION_ADVANCED
-	default y if (SGI_IP22 || SGI_IP27 || ((MACH_JAZZ || SNI_RM) && !CPU_LITTLE_ENDIAN))
+	default y if DEFAULT_SGI_PARTITION
 	help
 	  Say Y here if you would like to be able to read the hard disk
 	  partition table format used by SGI machines.
_

Patches currently in -mm which might be from tsbogend@alpha.franken.de are

git-mips.patch
git-netdev-all.patch
watchdog-use-sgi_has_indydog-for-indydog-depends.patch
serial-use-sgi_has_zilog-for-ip22_zilog-depends.patch
char-use-sgi_has_ds1286-for-sgi_ds1286-depends.patch
sc26xx-new-serial-driver-for-sc2681-uarts.patch
sc26xx-new-serial-driver-for-sc2681-uarts-update.patch
partition-use-default_sgi_partition-for-sgi_partion-default.patch
