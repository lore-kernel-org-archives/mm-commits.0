From: akpm@linux-foundation.org
Subject: - av7110-fix-typo.patch removed from -mm tree
Date: Wed, 18 Jul 2007 11:52:06 -0700
Message-ID: <200707181852.l6IIq6F9023639@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38733 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933813AbXGRSwp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 14:52:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: padator@wanadoo.fr, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     av7110: fix typo
has been removed from the -mm tree.  Its filename was
     av7110-fix-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: av7110: fix typo
From: Yoann Padioleau <padator@wanadoo.fr>

Parse error in ifdef or bad use of macro.

Signed-off-by: Yoann Padioleau <padator@wanadoo.fr>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/ttpci/av7110.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/dvb/ttpci/av7110.c~av7110-fix-typo drivers/media/dvb/ttpci/av7110.c
--- a/drivers/media/dvb/ttpci/av7110.c~av7110-fix-typo
+++ a/drivers/media/dvb/ttpci/av7110.c
@@ -2258,7 +2258,7 @@ static int frontend_init(struct av7110 *
 		FE_FUNC_OVERRIDE(av7110->fe->ops.diseqc_send_master_cmd, av7110->fe_diseqc_send_master_cmd, av7110_fe_diseqc_send_master_cmd);
 		FE_FUNC_OVERRIDE(av7110->fe->ops.diseqc_send_burst, av7110->fe_diseqc_send_burst, av7110_fe_diseqc_send_burst);
 		FE_FUNC_OVERRIDE(av7110->fe->ops.set_tone, av7110->fe_set_tone, av7110_fe_set_tone);
-		FE_FUNC_OVERRIDE(av7110->fe->ops.set_voltage, av7110->fe_set_voltage, av7110_fe_set_voltage;)
+		FE_FUNC_OVERRIDE(av7110->fe->ops.set_voltage, av7110->fe_set_voltage, av7110_fe_set_voltage);
 		FE_FUNC_OVERRIDE(av7110->fe->ops.dishnetwork_send_legacy_command, av7110->fe_dishnetwork_send_legacy_command, av7110_fe_dishnetwork_send_legacy_command);
 		FE_FUNC_OVERRIDE(av7110->fe->ops.set_frontend, av7110->fe_set_frontend, av7110_fe_set_frontend);
 
_

Patches currently in -mm which might be from padator@wanadoo.fr are

origin.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
git-alsa.patch
git-dvb.patch
