Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794980525;
	b=MA6WEgv7XW/iz1gbp564Ae/6rLiqQt5bIY44H8xyuP6oc74mYWuE0l+t7jhNLkCGK3ZC
	 Ub3Aex57cT0rQ/ODsgAnderr+yWPOg3D1y6c+quc/Sdu/fSx98BhVStl3L09Mj+MGp9y9
	 yxRlHjdOSVmm8Xt9pERR28FtZ0SNyfcFpoP7Ctboa20t4e8zDKFI6lbbuSWrctuG6XhHn
	 FtFPO/ia9xoq0ReXY7ENi04wcxi1VFEh6Ol/8wwBs/5CdCi4VB7+1QyzWTMBSPEPb5ouc
	 RlvR4bPUTok8V4Qm578PFQ60hhsN8sMMUPuZAbE7jVBMQhuN/KHJFeg3PVFHG6QRAHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794980525;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=TOG3nR/5bzvgAZGxu51ysm6B7WwLMiGZAMtDES/stzo=;
	b=GKzPa90iqeZL3uDiBt+wT9p5cOJaMJAxIX/dUQ4KpcFuEh5IuPu3G7BDSLb0EEtXokh6
	 EUTbzOP7fWWsKQzlRwnS5jQQ6KeUtvRCp9t1aV/qT7JrwBsyaDxBd+sRpxstiDuU5cYE/
	 pJmz26ewMJ2CDtE+VCqOA2fhAzSGhg/OCstnz419QeprjNDf0HwxVH5Z1e5FPu0rRH9Tl
	 6DecS9pR4OR1VCLUyoEu2yYKhEUAht/CaOSPDzzXb+94CTnaSC6RDeAq9/37/glzC0ZGJ
	 R9P/LOuaw8U7nSL4qsJMn5jMm/Ot+0pWsD7AeBNSvjKtNF2bOTW2in5h9Zdj6yPI8jQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=JlHP9Qj9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9BE606A31C
	for <mm-commits@vger.kernel.org>; Wed, 18 Nov 2026 05:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=JlHP9Qj9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 462FE1F00932;
	Wed, 18 Nov 2026 05:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794980525;
	bh=TOG3nR/5bzvgAZGxu51ysm6B7WwLMiGZAMtDES/stzo=;
	h=Date:To:From:Subject;
	b=JlHP9Qj9pGOPKNmKPpMPu06OPZGSGXxyc2GInAP7icIqhblE0JCDJCXfA6wIOPs49
	 yekkYPPzWl9yWRgBJpyoc2CDEl/+VuViLlR1vRNkJk0RHKcU/wXiL0yfGwCCOYSPgr
	 gV7hFVBo64vAphTMGf8aXYWNwXVHe3WZmxInl96o=
Date: Tue, 17 Nov 2026 21:42:04 -0800
To: mm-commits@vger.kernel.org,chenridong@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-hotfixes-stable] mailmap-add-entries-for-ridong-chen.patch removed from -mm tree
Message-Id: <20261118054205.462FE1F00932@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mailmap: add entries for Ridong Chen
has been removed from the -mm tree.  Its filename was
     mailmap-add-entries-for-ridong-chen.patch

This patch was dropped because it was merged into the mm-nonmm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-add-entries-for-ridong-chen
+++ a/.mailmap
@@ -815,6 +815,8 @@ Richard Genoud <richard.genoud@bootlin.c
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

mm-memcontrol-drop-unused-vmscan-tracepoint-include.patch
mm-vmscan-move-vmscan-tracepoints-to-a-local-header.patch
mm-vmscan-move-struct-scan_control-to-a-dedicated-header.patch
mm-vmscan-pass-scan_control-to-the-vmscan-tracepoints.patch
mm-mglru-add-tracepoint-for-scan_folios.patch
mm-mglru-add-lruvec_gen_size-helper.patch
mm-mglru-add-tracepoint-for-aging.patch

