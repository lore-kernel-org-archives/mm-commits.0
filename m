From: akpm@linux-foundation.org
Subject: [patch 54/78] scripts/spelling.txt: add "unneded" pattern and fix typo instances
Date: Mon, 27 Feb 2017 14:29:17 -0800
Message-ID: <58b4a83d.Fjp/3rFIJSK5Msol%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54296 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751690AbdB1Auy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 19:50:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, yamada.masahiro@socionext.com

From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: scripts/spelling.txt: add "unneded" pattern and fix typo instances

Fix typos and add the following to the scripts/spelling.txt:

  unneded||unneeded

Link: http://lkml.kernel.org/r/1481573103-11329-15-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c   |    2 +-
 scripts/spelling.txt       |    1 +
 sound/soc/codecs/wm_hubs.c |    2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/dlm/dlmmaster.c~scripts-spellingtxt-add-unneded-pattern-and-fix-typo-instances fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~scripts-spellingtxt-add-unneded-pattern-and-fix-typo-instances
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -2924,7 +2924,7 @@ again:
 	/*
 	 * if target is down, we need to clear DLM_LOCK_RES_BLOCK_DIRTY for
 	 * another try; otherwise, we are sure the MIGRATING state is there,
-	 * drop the unneded state which blocked threads trying to DIRTY
+	 * drop the unneeded state which blocked threads trying to DIRTY
 	 */
 	spin_lock(&res->spinlock);
 	BUG_ON(!(res->state & DLM_LOCK_RES_BLOCK_DIRTY));
diff -puN scripts/spelling.txt~scripts-spellingtxt-add-unneded-pattern-and-fix-typo-instances scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-unneded-pattern-and-fix-typo-instances
+++ a/scripts/spelling.txt
@@ -1067,6 +1067,7 @@ unkmown||unknown
 unknonw||unknown
 unknow||unknown
 unkown||unknown
+unneded||unneeded
 unneedingly||unnecessarily
 unnsupported||unsupported
 unmached||unmatched
diff -puN sound/soc/codecs/wm_hubs.c~scripts-spellingtxt-add-unneded-pattern-and-fix-typo-instances sound/soc/codecs/wm_hubs.c
--- a/sound/soc/codecs/wm_hubs.c~scripts-spellingtxt-add-unneded-pattern-and-fix-typo-instances
+++ a/sound/soc/codecs/wm_hubs.c
@@ -1269,7 +1269,7 @@ void wm_hubs_set_bias_level(struct snd_s
 		break;
 
 	case SND_SOC_BIAS_ON:
-		/* Turn off any unneded single ended outputs */
+		/* Turn off any unneeded single ended outputs */
 		val = 0;
 		mask = 0;
 
_
