Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328274399FF
	for <mm-commits@vger.kernel.org>; Mon, 10 Aug 2026 18:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786387720; cv=none; b=pFsW2zVg4ka0hAyhr+XrA1ez1Dc2minEL2S6dGRHpn9NSxWSVtuAT6uTvbERUd8gEUeygVuct7uFvCdkZrs2wKWexjA6+tFpt97O19ctMMPSIJRAreZLqwWpMqsNDxksr9d3MB3RN8x0k2TI+x7hXiv1e/uK78h60/R50MZghko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786387720; c=relaxed/simple;
	bh=pnysL7cwpoHzL5Dz/e037FZsEnqxiASN7ZwM6JbxeIc=;
	h=Date:To:From:Subject:Message-Id; b=OmDycRY+6qBnuXEuMOREBSOL03+yHY9/9tn17d2+8yJXUzGahleYob8api6WwQDBls3fq7hb6vf1YJEWAMZJAb4+QCDEc7iNkrvLdrO2Tm30gj63MfRVBthX4p/vXOSDZmh/hBKIc5uMIAdfXB67yYyKz5pwwHk7VVkQMYzyvRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZbnfsLcJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZbnfsLcJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC451F000E9;
	Mon, 10 Aug 2026 18:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786387718;
	bh=AJ7Mh3ACbEi7jWveWHm/TGnCnQsz0vFHLuJwKa9kZxE=;
	h=Date:To:From:Subject;
	b=ZbnfsLcJGzF2JyaPMRFlkV9kiizjZBIsTxY7n4TXB3Alpm2C2mkj8S2A22cjltlw4
	 PPu6QF8fUCH1tkzKL+TtbKX8ysqaFFyuO+R6hmFZrF+CE7zrbr3Yslz2Uety7LQjZn
	 Uja4UnMjyYBv0ejNTddfSM2zwqIPiEzhZ6BodGPw=
Date: Mon, 10 Aug 2026 11:48:37 -0700
To: mm-commits@vger.kernel.org,linfeng.sun.dev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-email-address-for-linfeng-sun.patch added to mm-nonmm-unstable branch
Message-Id: <20260810184837.ECC451F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: update email address for Linfeng Sun
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mailmap-update-email-address-for-linfeng-sun.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-email-address-for-linfeng-sun.patch

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
From: Linfeng Sun <linfeng.sun.dev@gmail.com>
Subject: mailmap: update email address for Linfeng Sun
Date: Mon, 10 Aug 2026 15:32:35 +0800

1. Update my university email to my personal Gmail, as the former will
   expire after graduation.
2. Fix a typo in my Gmail domain.

Link: https://lore.kernel.org/20260810073235.22980-1-linfeng.sun.dev@gmail.com
Signed-off-by: Linfeng Sun <linfeng.sun.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-update-email-address-for-linfeng-sun
+++ a/.mailmap
@@ -522,6 +522,8 @@ Leo Yan <leo.yan@linux.dev> <leo.yan@lin
 Liam R. Howlett <liam@infradead.org> <Liam.Howlett@oracle.com>
 Liam Mark <quic_lmark@quicinc.com> <lmark@codeaurora.org>
 Linas Vepstas <linas@austin.ibm.com>
+Linfeng Sun <linfeng.sun.dev@gmail.com> <slf@hdu.edu.cn>
+Linfeng Sun <linfeng.sun.dev@gmail.com> <linfeng.sun.dev@gamil.com>
 Linus Lüssing <linus.luessing@c0d3.blue> <linus.luessing@ascom.ch>
 Linus Lüssing <linus.luessing@c0d3.blue> <linus.luessing@web.de>
 Linus Lüssing <linus.luessing@c0d3.blue> <ll@simonwunderlich.de>
_

Patches currently in -mm which might be from linfeng.sun.dev@gmail.com are

mailmap-update-email-address-for-linfeng-sun.patch

