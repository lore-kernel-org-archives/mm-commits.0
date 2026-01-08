Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D9A32142E
	for <mm-commits@vger.kernel.org>; Thu,  8 Jan 2026 18:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767897768; cv=none; b=GuGgVaSuRPxyCulNiUzTA+w9k3l1IG6HilUPBM+/PiarWgEVSSDVG/HFycMgK0uYwCMjnIMf8VMY773gZdx8BDmHbu/AUegTW860dzdYsbHHLUohnSNFLkNPt1ESZnfZdp3YYTXT6/XPuSoXM2XGhDUnsazCjF5fg/QZnMK4ILQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767897768; c=relaxed/simple;
	bh=rQhtx76dGhQvAB8uoGGXpytI8fJf4zfapYEghWR2lEw=;
	h=Date:To:From:Subject:Message-Id; b=fZArD8hAnqmDNxJc6rQBf3Hdb4rQ0ZGAZXfQ8tPQOnZo1tcQMC0o+PheuZwBhpE4OFuDG4qZNZHuJrrRLUNdiuMRmX22HufhmTCfYsp9pgTotJQW5l5aBc39S2oFDRhfrvwXJ2f2rtnMZTSBd10BRKrzEu31mFugti+97Pb+PYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MzCaENP9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MzCaENP9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D001CC116C6;
	Thu,  8 Jan 2026 18:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767897767;
	bh=rQhtx76dGhQvAB8uoGGXpytI8fJf4zfapYEghWR2lEw=;
	h=Date:To:From:Subject:From;
	b=MzCaENP9E1lV9jCEYkg+Nog0xjf645cZLYcodNJhwlnzdNMTc5peCUH9sTSMCvuQz
	 3LnIQZwtg4zhWQoMnJNjTgJCAQgUn0GmRceAZSaajfZj2+qfPHmqrAQf5d5oY4NebE
	 BvQFUuKD68Rf0f5WIN7bNGdZdtu6lm9XcUcq4lyE=
Date: Thu, 08 Jan 2026 10:42:47 -0800
To: mm-commits@vger.kernel.org,danielt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entry-for-daniel-thompson.patch added to mm-hotfixes-unstable branch
Message-Id: <20260108184247.D001CC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: add entry for Daniel Thompson
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-add-entry-for-daniel-thompson.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entry-for-daniel-thompson.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Daniel Thompson <danielt@kernel.org>
Subject: mailmap: add entry for Daniel Thompson
Date: Thu, 08 Jan 2026 11:09:54 +0000

My linaro address stopped working a long time ago but I didn't update my
mailmap entry.  Fix that.

Link: https://lkml.kernel.org/r/20260108-mailmap-daniel_thompson_linaro-org-v1-1-83f610876377@kernel.org
Signed-off-by: Daniel Thompson <danielt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-entry-for-daniel-thompson
+++ a/.mailmap
@@ -207,6 +207,7 @@ Daniel Borkmann <daniel@iogearbox.net> <
 Daniel Borkmann <daniel@iogearbox.net> <dborkmann@redhat.com>
 Daniel Borkmann <daniel@iogearbox.net> <dborkman@redhat.com>
 Daniel Borkmann <daniel@iogearbox.net> <dxchgb@gmail.com>
+Daniel Thompson <danielt@kernel.org> <daniel.thompson@linaro.org>
 Danilo Krummrich <dakr@kernel.org> <dakr@redhat.com>
 David Brownell <david-b@pacbell.net>
 David Collins <quic_collinsd@quicinc.com> <collinsd@codeaurora.org>
_

Patches currently in -mm which might be from danielt@kernel.org are

mailmap-add-entry-for-daniel-thompson.patch

