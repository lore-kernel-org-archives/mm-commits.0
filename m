Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794202155;
	b=adQQ9hw2d0mD911g411e0m2IH8ACgV2qWbzIcDowIWnYNn23hKMGkdy3s0JCJuohgz6U
	 oWNm6GTvfWmVQQwNjm7h7TR5UyhT3+ddPldABbX23bXVikGlcyxHXHbCwsHkDatrXMJp+
	 fBkhZyzWIX91HLuh4Kjqcwib0oDKl54Hx9b/zRO4qzZQLMOmiAQitRx193wHrGJG3IIur
	 wmo85dScgtDA/XWfG7+8sqlY9T56Qr9Znp1MI934adl2bjqDqKMwjoMSOCHgQL1ikpiLQ
	 TtS/8KTT5Pgad/SkyxzgoXGz3+T0jE9/UjgO970eFutsQn+Tm6j6V2Gv05aEJpcoVdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794202155;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=EOX9LAzavzVpsX22YGIPAELP9uxAyKI/oOy53oWQ+sQ=;
	b=L0NWiwFt0vgKPj0H4mSFaGVq2Qc2FPgUQFM3X/OYomBiOU+Dqdfi3DdowM8Tltx+VR3X
	 hvA0bAXVuyU/uKCfxtyiSfnhcrNNal3JktRx7vmWrNjuW0mPjZin9fQBWFJ23iJaILLOY
	 ri/1AelmKkdGgWvcdzTMpwHKRMTEqDTIqU3pK+J1v7sS5YPeiDESN+Tkltcme4EFAjuRL
	 9/8CJL7PL3nvestIAwD4IW9lfV3bb+nrdI8tlrvL9ao7mlAJkejuZjFm5Pko7G4Ecx00z
	 n7vBw3ICfeF0G7MIljcvG1VFyxZvNJFKN1xuR60wI2WZp4qqDEiZW9zIUehvNBj5o/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=cxuZNxu8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA47606EE8C
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 05:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=cxuZNxu8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F155F1F008A6;
	Mon,  9 Nov 2026 05:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794202155;
	bh=EOX9LAzavzVpsX22YGIPAELP9uxAyKI/oOy53oWQ+sQ=;
	h=Date:To:From:Subject;
	b=cxuZNxu8rqHgvbLz/bCm6rOTSW4Yg1OwSigRaMG1TGicquDGZNU2gspXjJ49Oo85P
	 YA+2g9Wh+Hjg0UxmHinHomncIwl3tfNjcAeRHCVkpLwJc9ySiuykp7jaraKbl45RGT
	 Pnbrmt6mxNi+VoEVEUSFNYix0o1dLYKEoz7xIJ+g=
Date: Sun, 08 Nov 2026 21:29:14 -0800
To: mm-commits@vger.kernel.org,chenridong@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entries-for-ridong-chen.patch added to mm-nonmm-unstable branch
Message-Id: <20261109052914.F155F1F008A6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mailmap: add entries for Ridong Chen
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mailmap-add-entries-for-ridong-chen.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entries-for-ridong-chen.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Ridong Chen <chenridong@xiaomi.com>
Subject: mailmap: add entries for Ridong Chen
Date: Sun,  8 Nov 2026 20:35:09 +0800

Map my former Huawei address and my current Xiaomi address to my
personal address, so that all my contributions are attributed to a
single identity.

Link: https://lore.kernel.org/20261108123509.214127-1-ridong.chen@linux.dev
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-add-entries-for-ridong-chen
+++ a/.mailmap
@@ -809,6 +809,8 @@ Richard Genoud <richard.genoud@bootlin.c
 Richard Leitner <richard.leitner@linux.dev> <dev@g0hl1n.net>
 Richard Leitner <richard.leitner@linux.dev> <me@g0hl1n.net>
 Richard Leitner <richard.leitner@linux.dev> <richard.leitner@skidata.com>
+Ridong Chen <ridong.chen@linux.dev> <chenridong@huawei.com>
+Ridong Chen <ridong.chen@linux.dev> <chenridong@xiaomi.com>
 Rob Clark <robin.clark@oss.qualcomm.com> <robdclark@chromium.org>
 Rob Clark <robin.clark@oss.qualcomm.com> <robdclark@gmail.com>
 Robert Foss <rfoss@kernel.org> <robert.foss@linaro.org>
_

Patches currently in -mm which might be from chenridong@xiaomi.com are

mm-migrate-move-nr_file_thps-on-cross-node-migration.patch
mm-migrate-move-nr_kernel_file_pages-on-cross-node-migration.patch
mm-memcontrol-drop-unused-vmscan-tracepoint-include.patch
mm-vmscan-move-vmscan-tracepoints-to-a-local-header.patch
mm-vmscan-move-struct-scan_control-to-a-dedicated-header.patch
mm-vmscan-pass-scan_control-to-the-vmscan-tracepoints.patch
mm-mglru-add-tracepoint-for-scan_folios.patch
mm-mglru-add-lruvec_gen_size-helper.patch
mm-mglru-add-tracepoint-for-aging.patch
mailmap-add-entries-for-ridong-chen.patch

