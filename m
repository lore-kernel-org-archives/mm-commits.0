From: akpm@linux-foundation.org
Subject: - pcmcia-blackfin-fix-bug-add-missing-to-module-macro.patch removed from -mm tree
Date: Tue, 16 Dec 2008 12:30:11 -0800
Message-ID: <200812162030.mBGKUBMH006336@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56006 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750981AbYLPUa4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Dec 2008 15:30:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, cooloney@kernel.org, linux@dominikbrodowski.net, michael.hennerich@analog.com, mm-commits@vger.kernel.org


The patch titled
     pcmcia: blackfin: fix bug - add missing ; to MODULE macro
has been removed from the -mm tree.  Its filename was
     pcmcia-blackfin-fix-bug-add-missing-to-module-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pcmcia: blackfin: fix bug - add missing ; to MODULE macro
From: Mike Frysinger <vapier.adi@gmail.com>

Cc: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/bfin_cf_pcmcia.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pcmcia/bfin_cf_pcmcia.c~pcmcia-blackfin-fix-bug-add-missing-to-module-macro drivers/pcmcia/bfin_cf_pcmcia.c
--- a/drivers/pcmcia/bfin_cf_pcmcia.c~pcmcia-blackfin-fix-bug-add-missing-to-module-macro
+++ a/drivers/pcmcia/bfin_cf_pcmcia.c
@@ -334,6 +334,6 @@ static void __exit bfin_cf_exit(void)
 module_init(bfin_cf_init);
 module_exit(bfin_cf_exit);
 
-MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>")
+MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
 MODULE_DESCRIPTION("BFIN CF/PCMCIA Driver");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

origin.patch
linux-next.patch
genrtc-disable-genrtc-on-blackfin-systems.patch

