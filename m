From: akpm@linux-foundation.org
Subject: + pcmcia-blackfin-fix-bug-add-missing-to-module-macro.patch added to -mm tree
Date: Tue, 18 Nov 2008 22:30:29 -0800
Message-ID: <200811190630.mAJ6UTsX015435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54492 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751030AbYKSGap (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Nov 2008 01:30:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier.adi@gmail.com, cooloney@kernel.org, linux@dominikbrodowski.net, michael.hennerich@analog.com


The patch titled
     pcmcia: blackfin: fix bug - add missing ; to MODULE macro
has been added to the -mm tree.  Its filename is
     pcmcia-blackfin-fix-bug-add-missing-to-module-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

physmap-fix-leak-of-memory-returned-by-parse_mtd_partitions.patch
pcmcia-blackfin-fix-bug-add-missing-to-module-macro.patch
genrtc-disable-genrtc-on-blackfin-systems.patch

