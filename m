Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794796844;
	b=f5GQcgkA3/DwVykowW4NCeKeR94UMnVdDN0SODAdCeC2tnxgAll7eMUgljctrXAV1MsX
	 hPt+As1qKEw2h9OD6M/UF/6vUVuns2x7bM/ow8ycnCKTQOJn2GbXYIN4mjG8dhIjp4DdB
	 l9yy0OliAUU29LVJgMoDsez2Of44Uu8ZBCsMv92E5oEJcRxPQFkLI1EjGaKHEY9tAcWGd
	 T37S9nE//5RAEuYYwGUsHt2QxOXTZpRziTgVCGEWvgShV0AE2BEZavYeG3oZlBYzfNBhE
	 UWjJh5MCA7g/wwRqdHsPaxWbY09ULL18L55XOwSibgqjBu587YSOZlK1S1bYRmyAqqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794796844;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=zzMLbpWw0ye2Ie3XrhNznl+GNjqcQEei2vpyz2T8DPU=;
	b=xR1HoeIUv5vfNgaIIBuRWEKnvKNXxMVvEecI7BaUkeN17sTy6R3CHULXCVL3JltuOL0v
	 sn3jyPsA4jXmcx7sipAHq1C9y53Q444QqXr9F6nFDV44nBbeEB91BrV7v0zenYmcjM8fW
	 BPG1rsFFCW814hDl+iwOmcrrnjrZHgnu5jN0SSrSmtIrIDHcE6FF84N+Te90rM9i8iryi
	 8iUzrLOXuokFelzFgeYqYcWmGumJ8n2M7W/XpIZHVt5JQfucJJ+67vgqcAfcwmO5FC7iR
	 Tmzy/09thLGHStH987iiFSxupvrih/1IHln4hKIycxuyJzw6B2U1qYI3wndWaddppPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=xFKSjgAb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA555606A31C
	for <mm-commits@vger.kernel.org>; Mon, 16 Nov 2026 02:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=xFKSjgAb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0E11F000C4;
	Mon, 16 Nov 2026 02:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794796843;
	bh=zzMLbpWw0ye2Ie3XrhNznl+GNjqcQEei2vpyz2T8DPU=;
	h=Date:To:From:Subject;
	b=xFKSjgAbKx1lknvzOa4k5OODe9HFuXAXg26tTHOwYFoX0b5zec0dSRFJpCama20Xw
	 u28LgEE0QXzy7UFIZr3qjdqeoOtT+QFLAtRB2fSz+k/pKvRgudzJK+WKPq7oZk9YPY
	 uKONp+eHOQ8O8IPm6ov9BrNK5frFVDB+U3KufWJg=
Date: Sun, 15 Nov 2026 18:40:42 -0800
To: mm-commits@vger.kernel.org,s.grosjean@peak-system.fr,kuba@kernel.org,
	jeff.johnson@oss.qualcomm.com,ehristev@kernel.org,cel@kernel.org,
	alice.kernel@fastmail.im,alex@sverdlin.org,miaoqing.pan@oss.qualcomm.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entries-for-miaoqing-pan.patch added to mm-nonmm-hotfixes-unstable branch
Message-Id: <20261116024043.3F0E11F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mailmap: add entries for Miaoqing Pan
has been added to the -mm mm-nonmm-hotfixes-unstable branch.  Its filename is
     mailmap-add-entries-for-miaoqing-pan.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entries-for-miaoqing-pan.patch

This patch will later appear in the mm-nonmm-hotfixes-unstable branch at
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

mailmap-add-entries-for-miaoqing-pan.patch

