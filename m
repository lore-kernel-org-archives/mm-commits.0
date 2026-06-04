Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D620E32ED21
	for <mm-commits@vger.kernel.org>; Thu,  4 Jun 2026 20:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780604305; cv=none; b=j+B+8eplbEnOa4Kv/bLCDrIS4dSLDQHARbrU2vdOyg6XX9qFIbviSy3CIC4T4UbrELM70KWAp5L+hXua0gRhjjEkVL46EIMcDR5OfaXrSACKd9QtGIeti9JPnY4SYz5PknVGprsL8wIul4eggiDykmkKSfnnaOhs9e1+AxTvsLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780604305; c=relaxed/simple;
	bh=OHVjTO7usek2ZoxcIh0xny6uc2WtBS/t2Fv6I4tjJoc=;
	h=Date:To:From:Subject:Message-Id; b=YoHCERHbWGjHNCo+x4UvC3XmtXwQ2aEjT7DnoINN+UrPVULtNekgCMVdGC4t2uWwHFPYJJqN3G3s8QVhzsMCBvGW4wpKloA+2mIWS9+a9+LJ20KFJoeTV7NH8645lgDyuISGLc0dfi/Can026HefeXo8g7P9xC6l5EVrPS025Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wRyynd8u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wRyynd8u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6421F00893;
	Thu,  4 Jun 2026 20:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780604303;
	bh=7q7C9ruXB6nr+1UaCNkiQxD+p1Rrm+l83zES/BkygUs=;
	h=Date:To:From:Subject;
	b=wRyynd8uz7T8HopPZKU6B0tq5w5Sh5HhkiVo8/NBbTG4qVXaIFY+zauCGEVRR2hWp
	 GUWjOhz9OqyA3hzJeFGM4G6gyPEd2+DTlDupfr0SjBIZ8MvtdO7EEW7NwBVqEo8BPX
	 /h96Wn17Zn8PuSxx4LsJd5fMVXE0Ggs0m+ruwUi8=
Date: Thu, 04 Jun 2026 13:18:23 -0700
To: mm-commits@vger.kernel.org,asv@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-alexander-sverdlins-email-addresses.patch added to mm-nonmm-unstable branch
Message-Id: <20260604201823.6D6421F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: update Alexander Sverdlin's Email addresses
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mailmap-update-alexander-sverdlins-email-addresses.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-alexander-sverdlins-email-addresses.patch

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
From: Alexander Sverdlin <asv@kernel.org>
Subject: mailmap: update Alexander Sverdlin's Email addresses
Date: Thu, 4 Jun 2026 00:58:40 +0200

- add kernel.org address
- add sverdlin.org address (as primary address)
- drop siemens.com address (for accounting purposes only)

Link: https://lore.kernel.org/20260603225847.1849399-1-asv@kernel.org
Signed-off-by: Alexander Sverdlin <asv@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/.mailmap~mailmap-update-alexander-sverdlins-email-addresses
+++ a/.mailmap
@@ -36,13 +36,14 @@ Alexander Lobakin <alobakin@pm.me> <bloo
 Alexander Mikhalitsyn <alexander@mihalicyn.com> <alexander.mikhalitsyn@virtuozzo.com>
 Alexander Mikhalitsyn <alexander@mihalicyn.com> <aleksandr.mikhalitsyn@canonical.com>
 Alexander Mikhalitsyn <alexander@mihalicyn.com> <aleksandr.mikhalitsyn@futurfusion.io>
-Alexander Sverdlin <alexander.sverdlin@gmail.com> <alexander.sverdlin.ext@nsn.com>
-Alexander Sverdlin <alexander.sverdlin@gmail.com> <alexander.sverdlin@gmx.de>
-Alexander Sverdlin <alexander.sverdlin@gmail.com> <alexander.sverdlin@nokia.com>
-Alexander Sverdlin <alexander.sverdlin@gmail.com> <alexander.sverdlin@nsn.com>
-Alexander Sverdlin <alexander.sverdlin@gmail.com> <alexander.sverdlin@siemens.com>
-Alexander Sverdlin <alexander.sverdlin@gmail.com> <alexander.sverdlin@sysgo.com>
-Alexander Sverdlin <alexander.sverdlin@gmail.com> <subaparts@yandex.ru>
+Alexander Sverdlin <alex@sverdlin.org> <alexander.sverdlin.ext@nsn.com>
+Alexander Sverdlin <alex@sverdlin.org> <alexander.sverdlin@gmail.com>
+Alexander Sverdlin <alex@sverdlin.org> <alexander.sverdlin@gmx.de>
+Alexander Sverdlin <alex@sverdlin.org> <alexander.sverdlin@nokia.com>
+Alexander Sverdlin <alex@sverdlin.org> <alexander.sverdlin@nsn.com>
+Alexander Sverdlin <alex@sverdlin.org> <alexander.sverdlin@sysgo.com>
+Alexander Sverdlin <alex@sverdlin.org> <asv@kernel.org>
+Alexander Sverdlin <alex@sverdlin.org> <subaparts@yandex.ru>
 Alexandre Belloni <alexandre.belloni@bootlin.com> <alexandre.belloni@free-electrons.com>
 Alexandre Ghiti <alex@ghiti.fr> <alexandre.ghiti@canonical.com>
 Alexei Avshalom Lazar <quic_ailizaro@quicinc.com> <ailizaro@codeaurora.org>
_

Patches currently in -mm which might be from asv@kernel.org are

mailmap-update-alexander-sverdlins-email-addresses.patch

