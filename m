From: akpm@linux-foundation.org
Subject: - mtd-maps-make-uclinux-mapping-driver-depend-on-mtd_ram-since-it-only-probes-that.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:50:45 -0700
Message-ID: <200810012150.m91Lojuc005867@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753717AbYJAVu6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:50:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, cooloney@kernel.org, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     MTD Maps: make uclinux mapping driver depend on MTD_RAM since it only probes that
has been removed from the -mm tree.  Its filename was
     mtd-maps-make-uclinux-mapping-driver-depend-on-mtd_ram-since-it-only-probes-that.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MTD Maps: make uclinux mapping driver depend on MTD_RAM since it only probes that
From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/maps/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mtd/maps/Kconfig~mtd-maps-make-uclinux-mapping-driver-depend-on-mtd_ram-since-it-only-probes-that drivers/mtd/maps/Kconfig
--- a/drivers/mtd/maps/Kconfig~mtd-maps-make-uclinux-mapping-driver-depend-on-mtd_ram-since-it-only-probes-that
+++ a/drivers/mtd/maps/Kconfig
@@ -491,7 +491,7 @@ config MTD_BFIN_ASYNC
 
 config MTD_UCLINUX
 	tristate "Generic uClinux RAM/ROM filesystem support"
-	depends on MTD_PARTITIONS && !MMU
+	depends on MTD_PARTITIONS && MTD_RAM && !MMU
 	help
 	  Map driver to support image based filesystems for uClinux.
 
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

git-mtd.patch
git-sound.patch
git-fastboot.patch

