Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39002440653
	for <mm-commits@vger.kernel.org>; Thu, 24 Sep 2026 21:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790284956; cv=none; b=GDIWHU0Q4JJVDsCf0IqfQwY3GmhWEUb1z+n2jig5gu4MEdGA67kWIVqaxp52lKDejx22KNFOTiJBzE9PFOf7W+0a0Ik5Czns/FkojGpPEHwakg2Lsj/STXo/U9Afg71Lk5DFdl/FO8mOsvvigy+yMqddPsEtbPPV2JPFxz6WkwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790284956; c=relaxed/simple;
	bh=JBs9Z1L9xGVvwdn4GTpxePWyComAYrEK0JG93R5BWok=;
	h=Date:To:From:Subject:Message-Id; b=VHPtdIN3uwhfCrHBmvcWhOlG5I/59vOt3Wo285nwsT0KBYqE2b4pZeGoLEN14Medqjt4t2Z2S5ap5JgCYXS8Lf+fUXU6YhaK7rmbtLvtRHjkJocy5FWL2VjO4pb3Nz4lUOXiwqlQ7O75XZVyriYLrZoDIMuhSsuBCofzMK2bU2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iJ1vzIho; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iJ1vzIho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82B361F000FF;
	Thu, 24 Sep 2026 21:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790284953;
	bh=LEP7tH7hAarqKXu0cpDpgw3bAXag3Oh5W1HDQyk276M=;
	h=Date:To:From:Subject;
	b=iJ1vzIhoDwCvCg3RC9yXEPvvJpnTzXlZrcYDkCgYzS2SbCheaJ40H+7LWYZ+XIHP0
	 cQZI8NAfqk6TeuFhJrG9di6AtFjMm0Q+S0ktm6ja6pNFcsgelUTlLdL2p2RSppXLSo
	 fmKFDsjCZofL/EoqYHwi3VwA5yHNVUuTAS0cS600=
Date: Thu, 24 Sep 2026 14:22:33 -0700
To: mm-commits@vger.kernel.org,martink@posteo.de,kuba@kernel.org,cel@kernel.org,alex@sverdlin.org,andyshrk@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-entry-for-andy-yan.patch added to mm-nonmm-unstable branch
Message-Id: <20260924212233.82B361F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: update entry for Andy Yan
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mailmap-update-entry-for-andy-yan.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-entry-for-andy-yan.patch

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
From: Andy Yan <andyshrk@163.com>
Subject: mailmap: update entry for Andy Yan
Date: Thu, 24 Sep 2026 18:50:33 +0800

I will use andyshrk@163.com for future review and discussion.

Link: https://lore.kernel.org/20260924105052.768760-1-andyshrk@163.com
Signed-off-by: Andy Yan <andyshrk@163.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Sverdlin <alex@sverdlin.org>
Cc: Chuck Lever <cel@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Martin Kepplinger <martink@posteo.de>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-entry-for-andy-yan
+++ a/.mailmap
@@ -103,6 +103,7 @@ Andy Chiu <andybnac@gmail.com> <andy.chi
 Andy Chiu <andybnac@gmail.com> <taochiu@synology.com>
 Andy Shevchenko <andy@kernel.org> <andy@smile.org.ua>
 Andy Shevchenko <andy@kernel.org> <ext-andriy.shevchenko@nokia.com>
+Andy Yan <andyshrk@163.com> <andy.yan@rock-chips.com>
 Anilkumar Kolli <quic_akolli@quicinc.com> <akolli@codeaurora.org>
 Anirudh Ghayal <quic_aghayal@quicinc.com> <aghayal@codeaurora.org>
 Antoine Tenart <atenart@kernel.org> <antoine.tenart@bootlin.com>
_

Patches currently in -mm which might be from andyshrk@163.com are

mailmap-update-entry-for-andy-yan.patch

