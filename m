From: akpm@linux-foundation.org
Subject: - snd-aoa-codec-onyx-fix-typo.patch removed from -mm tree
Date: Mon, 16 Jul 2007 14:00:02 -0700
Message-ID: <200707162100.l6GL02ho002566@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44512 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755859AbXGPVQw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:16:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: padator@wanadoo.fr, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     snd-aoa-codec-onyx: fix typo
has been removed from the -mm tree.  Its filename was
     snd-aoa-codec-onyx-fix-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: snd-aoa-codec-onyx: fix typo
From: Yoann Padioleau <padator@wanadoo.fr>

Parse error in ifdef or bad use of macro.

Signed-off-by: Yoann Padioleau <padator@wanadoo.fr>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/aoa/codecs/snd-aoa-codec-onyx.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN sound/aoa/codecs/snd-aoa-codec-onyx.c~snd-aoa-codec-onyx-fix-typo sound/aoa/codecs/snd-aoa-codec-onyx.c
--- a/sound/aoa/codecs/snd-aoa-codec-onyx.c~snd-aoa-codec-onyx-fix-typo
+++ a/sound/aoa/codecs/snd-aoa-codec-onyx.c
@@ -713,7 +713,7 @@ static int onyx_prepare(struct codec_inf
 	if (substream->runtime->format == SNDRV_PCM_FMTBIT_COMPRESSED_16BE) {
 		/* mute and lock analog output */
 		onyx_read_register(onyx, ONYX_REG_DAC_CONTROL, &v);
-		if (onyx_write_register(onyx
+		if (onyx_write_register(onyx,
 					ONYX_REG_DAC_CONTROL,
 					v | ONYX_MUTE_RIGHT | ONYX_MUTE_LEFT))
 			goto out_unlock;
_

Patches currently in -mm which might be from padator@wanadoo.fr are

origin.patch
git-alsa.patch
av7110-fix-typo.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
