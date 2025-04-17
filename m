Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E6D189915
	for <mm-commits@vger.kernel.org>; Thu, 17 Apr 2025 20:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744921853; cv=none; b=oxgSGCM8GFABOCAZy4smHCkTvBlmT8r5PDVBoaDZ1asTzI/tr1RKGt6iHiOop52DmCDplzQIWFSFUSZFbflrhAeH7vEFitbvZrFsl0QGfbpyX1DRsi/RoCjBhwCu9RMh599Chi9rqEBAZznQbGkDNnnoB2+jQDCiGaflONbk0ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744921853; c=relaxed/simple;
	bh=C1e8NPlnDUDdtyTHrrEIsbk4/wWMIqWjI3JBBS0L05k=;
	h=Date:To:From:Subject:Message-Id; b=mK8m2DFeoBMBnrEddMxie8wt1zO4TlEPqFD9H5lmFmR8lVEMaFftxovAej4+PC3H/vPNiAnq1ql3t9rM7hwsVeWg0CXE+TryADFg8xsK7iJGAA7VCOiXi9fe4Z8ULvm8RGuZ96tGki3sn/BtkOm5KV3WWt2y3k+nWcUO83YtIb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XfzHDNaT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XfzHDNaT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4514AC4CEE4;
	Thu, 17 Apr 2025 20:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744921853;
	bh=C1e8NPlnDUDdtyTHrrEIsbk4/wWMIqWjI3JBBS0L05k=;
	h=Date:To:From:Subject:From;
	b=XfzHDNaTCERnTUM/b2Y028lcU8sBVNjjjrL1N/WN00W7kQft2iVe/JPar8FXtjUdR
	 DmHoH1LzAvlv3tT3j16g7TnhZ8UpLSTaR63ktaVfmT7muSOBEyvPCwMN6dFo/t+81B
	 mvSm6PnBLQGn5SKK99NU7p92vz8/QHCT1z1JaYlw=
Date: Thu, 17 Apr 2025 13:30:52 -0700
To: mm-commits@vger.kernel.org,lance.yang@linux.dev,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entries-for-lance-yang.patch added to mm-hotfixes-unstable branch
Message-Id: <20250417203053.4514AC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: add entries for Lance Yang
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-add-entries-for-lance-yang.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entries-for-lance-yang.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Lance Yang <ioworker0@gmail.com>
Subject: mailmap: add entries for Lance Yang
Date: Thu, 17 Apr 2025 23:30:41 +0800

I'm moving to @linux.dev and mapping my old addresses to it.

Link: https://lkml.kernel.org/r/20250417153041.38977-1-lance.yang@linux.dev
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-add-entries-for-lance-yang
+++ a/.mailmap
@@ -447,6 +447,8 @@ Luca Ceresoli <luca.ceresoli@bootlin.com
 Luca Weiss <luca@lucaweiss.eu> <luca@z3ntu.xyz>
 Lukasz Luba <lukasz.luba@arm.com> <l.luba@partner.samsung.com>
 Luo Jie <quic_luoj@quicinc.com> <luoj@codeaurora.org>
+Lance Yang <lance.yang@linux.dev> <ioworker0@gmail.com>
+Lance Yang <lance.yang@linux.dev> <mingzhe.yang@ly.com>
 Maciej W. Rozycki <macro@mips.com> <macro@imgtec.com>
 Maciej W. Rozycki <macro@orcam.me.uk> <macro@linux-mips.org>
 Maharaja Kennadyrajan <quic_mkenna@quicinc.com> <mkenna@codeaurora.org>
_

Patches currently in -mm which might be from ioworker0@gmail.com are

mailmap-add-entries-for-lance-yang.patch
hung_task-replace-blocker_mutex-with-encoded-blocker.patch
hung_task-show-the-blocker-task-if-the-task-is-hung-on-semaphore.patch

