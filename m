Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998AA349B16
	for <mm-commits@vger.kernel.org>; Mon,  2 Mar 2026 23:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772495579; cv=none; b=cdDU5ZcMjiE4Eqkyek5WTkmyIWQ9x+Ot7FCgjZDA6y2Jkr+XDqEttqSXWZVHfkvX6f3s3KYP93ozxTJj5XKyWlDbW8gcXX01Nkn6eTlct5SAx82juufA2L+bdcafvaqBCO28c7fBvi51jIYV3IVMRe7aqUHitogNx2o0h8iUDrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772495579; c=relaxed/simple;
	bh=yVs9/7/xrFZvjRCfR/DN12rYBZs1noTl/bKdyJXHawQ=;
	h=Date:To:From:Subject:Message-Id; b=sB3vn8wFm2tBsSu2uqN8ixzi9umoqHmvxMOWkk6VP/d/LYVSwPMO/X+58O2+USYV6zpyNOJKoQJxtLVqUoMeMasZwkKUh3guk8fanNhc94ulPzysvA7n7mJ85yjSYCzGDHWUKNcO5zSUkYzED5qxJxgElT3+QnD0ZinnYWsmqDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hX24/hUS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hX24/hUS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2058AC19423;
	Mon,  2 Mar 2026 23:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772495579;
	bh=yVs9/7/xrFZvjRCfR/DN12rYBZs1noTl/bKdyJXHawQ=;
	h=Date:To:From:Subject:From;
	b=hX24/hUSY8hybO7Wtmk7tMwY2aM+yMs7p6BWS82hiRbn+ziYKEgw1lTk3AV/IWvrv
	 ED5vFloCk5nnyJMpolImDMjoh8Kf527uYpi8dYsakm7dVfOhoWGiS0zam7E2Apw5jX
	 aTTDmijTWXOpH7+x+R+cmhL5brPBwcU/FFDEjVsI=
Date: Mon, 02 Mar 2026 15:52:58 -0800
To: mm-commits@vger.kernel.org,linux@gurudas.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-guru-das-srinageshs-email-address.patch added to mm-nonmm-unstable branch
Message-Id: <20260302235259.2058AC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: update Guru Das Srinagesh's email address
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mailmap-update-guru-das-srinageshs-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-guru-das-srinageshs-email-address.patch

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
From: Guru Das Srinagesh <linux@gurudas.dev>
Subject: mailmap: update Guru Das Srinagesh's email address
Date: Sun, 01 Mar 2026 18:44:20 -0800

Add my current email address and map previous addresses to it.

Link: https://lkml.kernel.org/r/20260301-gds-mailmap-update-2-v1-1-5691415be73c@gurudas.dev
Signed-off-by: Guru Das Srinagesh <linux@gurudas.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/.mailmap~mailmap-update-guru-das-srinageshs-email-address
+++ a/.mailmap
@@ -300,7 +300,10 @@ Gokul Sriram Palanisamy <quic_gokulsri@q
 Govindaraj Saminathan <quic_gsamin@quicinc.com> <gsamin@codeaurora.org>
 Guo Ren <guoren@kernel.org> <guoren@linux.alibaba.com>
 Guo Ren <guoren@kernel.org> <ren_guo@c-sky.com>
-Guru Das Srinagesh <quic_gurus@quicinc.com> <gurus@codeaurora.org>
+Guru Das Srinagesh <linux@gurudas.dev>
+Guru Das Srinagesh <linux@gurudas.dev> <quic_gurus@quicinc.com>
+Guru Das Srinagesh <linux@gurudas.dev> <gurus@codeaurora.org>
+Guru Das Srinagesh <linux@gurudas.dev> <gurooodas@gmail.com>
 Gustavo Padovan <gustavo@las.ic.unicamp.br>
 Gustavo Padovan <padovan@profusion.mobi>
 Hamza Mahfooz <hamzamahfooz@linux.microsoft.com> <hamza.mahfooz@amd.com>
_

Patches currently in -mm which might be from linux@gurudas.dev are

mailmap-update-guru-das-srinageshs-email-address.patch

