Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794980518;
	b=BhdH6QZ/K0V/jEA15acF49qVseHjkaJfOfz6fekmlD2qSlcYyzLV3UlQ5NmeLzKXWxE2
	 tIgdNIDmRdNzadzBGkWnNG+9ttgQI/hoUklODRYf9dvPSAasSijmE6ARo5DV5dsyU3L3P
	 fJMyeduEWnmystp1vohEmTzAGkdRLip6LHb022e0TI0/YceuXFbEYxjKjBOGPuPLiWjlx
	 lN3Prk/bhGM91O7lTeEsfhKa8ckx0nVPuuW3Sg0Hx8ExcDGvWJ2Z2V+ff8urW4IH502mm
	 tEzbgK+xEc3HgxObEnAFst3lxQ0qL9jYPt4/Vne1/nQMalEEScDQ2U9AF7iJ8oUXALw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794980518;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=CHkMO9VhU0EtBYY4fYGr2UeR+QqUBohG9bzdlec7m4k=;
	b=esEPbqvTcgTXg4P/8pDkv3rlna2sGRMZSwgQtwnOfXlJc05lReAi3+vY8GpnIQmkymWn
	 8iJAc2eOaOK6Fnqr4K48Y7Kr1xKcWLoJ4lv+IHyNnzInEEZiNTZN3AHzFtZkaalHSc0Fj
	 N8r68/EXU5u7eisahksXtzjE9iwINidVjCHCfkLqFt2TgJzp0v1/lAD4IMj3CjddxQXVw
	 g+THssXks92lEXeSuWfPvQ1DZ02nLDXzSgENhcRGRC2IeMN9r17DxgYxLx08iE+tSPiyC
	 8QPI+qVZkhZx8FgVrQaxVy2Q3YtT8NrJFDbs08HapdnwhHYFdTLM+469QU7s3vkJ6cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=oxA23By2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4429C606A331
	for <mm-commits@vger.kernel.org>; Wed, 18 Nov 2026 05:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=oxA23By2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0C91F000C8;
	Wed, 18 Nov 2026 05:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794980517;
	bh=CHkMO9VhU0EtBYY4fYGr2UeR+QqUBohG9bzdlec7m4k=;
	h=Date:To:From:Subject;
	b=oxA23By2fZGJKQun5gFA2xf+uGp757EoLqSEvKCdNKXjszC+7c+sE6E6uCnMigGBS
	 taE1Nn5XH3Y4lmpe5jT0/ZJP3dVCd+XtY0WUAAgMpNljniookCTCCCt7gsH2pO5uzm
	 ZjcIfnOt1ef9HioOMxdRdcIfC6ag4ZT6DRukK2GM=
Date: Tue, 17 Nov 2026 21:41:57 -0800
To: mm-commits@vger.kernel.org,s.grosjean@peak-system.fr,kuba@kernel.org,
	jeff.johnson@oss.qualcomm.com,ehristev@kernel.org,cel@kernel.org,
	alice.kernel@fastmail.im,alex@sverdlin.org,miaoqing.pan@oss.qualcomm.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-hotfixes-stable] mailmap-add-entries-for-miaoqing-pan.patch removed from -mm tree
Message-Id: <20261118054157.BF0C91F000C8@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mailmap: add entries for Miaoqing Pan
has been removed from the -mm tree.  Its filename was
     mailmap-add-entries-for-miaoqing-pan.patch

This patch was dropped because it was merged into the mm-nonmm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
Subject: mailmap: add entries for Miaoqing Pan
Date: Mon, 16 Nov 2026 10:32:26 +0800

Map past iterations of my e-mail addresses to the current one.

Link: https://lore.kernel.org/20261116023226.17265-1-miaoqing.pan@oss.qualcomm.com
Signed-off-by: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Alexander Sverdlin <alex@sverdlin.org>
Cc: Chuck Lever <cel@kernel.org>
Cc: Eugen Hristev <ehristev@kernel.org>
Cc: Stéphane Grosjean <s.grosjean@peak-system.fr>
Cc: Alice Mikityanska <alice.kernel@fastmail.im>

 .mailmap |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/.mailmap~mailmap-add-entries-for-miaoqing-pan
+++ a/.mailmap
@@ -656,7 +656,8 @@ Maxwell Doose <maxwell@maxwelld.cc> <m32
 Maya Erez <quic_merez@quicinc.com> <merez@codeaurora.org>
 Mayuresh Janorkar <mayur@ti.com>
 Md Sadre Alam <quic_mdalam@quicinc.com> <mdalam@codeaurora.org>
-Miaoqing Pan <quic_miaoqing@quicinc.com> <miaoqing@codeaurora.org>
+Miaoqing Pan <miaoqing.pan@oss.qualcomm.com> <miaoqing@codeaurora.org>
+Miaoqing Pan <miaoqing.pan@oss.qualcomm.com> <quic_miaoqing@quicinc.com>
 Michael Buesch <m@bues.ch>
 Michael Chan <michael.chan@broadcom.com> <mchan@broadcom.com>
 Michael Grzeschik <mgr@kernel.org> <m.grzeschik@pengutronix.de>
_

Patches currently in -mm which might be from miaoqing.pan@oss.qualcomm.com are


