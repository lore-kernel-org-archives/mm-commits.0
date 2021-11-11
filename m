Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0820DC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:52:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E273E61250
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:52:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234561AbhKKCzM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:55:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:58750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234548AbhKKCzM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:55:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A47761108;
        Thu, 11 Nov 2021 02:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599143;
        bh=hjFmSiaIfZQwLS3vD/Xtb9OleJzPudejhukr7HdiI1s=;
        h=Date:From:To:Subject:From;
        b=M2pS9cqNx8TpzVl2yGMMch6K+/aO8OGJ7iorxw416ix6vs0YhFOwmBiDHBHD6it+2
         hF7Y0umyP8cJeGJGDg/+wdyupXZ9VoDwfmXtYzuPzzEC1DWeVQ21xsLRNuE6aqQsto
         E5g5RzeWqi4CpSercvkoOO9aPsYRb2twOBTZs264=
Date:   Wed, 10 Nov 2021 18:52:23 -0800
From:   akpm@linux-foundation.org
To:     broonie@kernel.org, joe@perches.com, lgirdwood@gmail.com,
        mm-commits@vger.kernel.org, perex@perex.cz,
        rikard.falkeborn@gmail.com, tiwai@suse.com
Subject:  [merged]
 const_structscheckpatch-add-a-few-sound-ops-structs.patch removed from -mm
 tree
Message-ID: <20211111025223.Gc2bwVX9b%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: const_structs.checkpatch: add a few sound ops structs
has been removed from the -mm tree.  Its filename was
     const_structscheckpatch-add-a-few-sound-ops-structs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: const_structs.checkpatch: add a few sound ops structs

Add a couple of commonly used (>50 instances) sound ops structs that are
typically const.

Link: https://lkml.kernel.org/r/20210922211042.38017-1-rikard.falkeborn@gmail.com
Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/const_structs.checkpatch |    4 ++++
 1 file changed, 4 insertions(+)

--- a/scripts/const_structs.checkpatch~const_structscheckpatch-add-a-few-sound-ops-structs
+++ a/scripts/const_structs.checkpatch
@@ -54,7 +54,11 @@ sd_desc
 seq_operations
 sirfsoc_padmux
 snd_ac97_build_ops
+snd_pcm_ops
+snd_rawmidi_ops
 snd_soc_component_driver
+snd_soc_dai_ops
+snd_soc_ops
 soc_pcmcia_socket_ops
 stacktrace_ops
 sysfs_ops
_

Patches currently in -mm which might be from rikard.falkeborn@gmail.com are


