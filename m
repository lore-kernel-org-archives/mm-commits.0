Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794867993;
	b=wtdyakLKFMbOwaqNx6VsDcXUcqUnRgrekp3rteznr6/MueZAQc5V5/DJiYJRl7Rihshf
	 sh2GOxhzdOUVYwk2yd0RzUksI+hx+Rrxc4lCruXuF3huB77rROb16JsThi9Un6e1caprM
	 QJu/0BacKbtMuXUMM+7aLS52ZLKMXiTlfR2gWkAgibMTEG+rsDSIYa1v2yaIGbj/1snmC
	 MBYaM4V698v0qfJY6opOCzsW/0vXFpiyFSz0wHAMB20pHpCY7hvHs8uGp0waI8Dqr07kr
	 e7IyhMTpARlGP2gwfFoPdq/X+g7wk/CqbPjMe8EDa5WFPNRZuA87Jdy7SsvCwi35gYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794867993;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=jEkhsCtqt/OeawAYx+APm3KbhNkP16w9r1GvGRUlPaU=;
	b=HIYYRrwBhTycs6/CbyzTN6blKBbYaNzmIv9nm23WDpq25pxDcEkc2mOIGnY8jdPKIxE4
	 sSjRrKYcehpCJCjLPrRW3iBzgv9/AoPT07+qDfdbmMwtFh7yXQ8r9NTWR9IF4DSxC8bdh
	 r7jZVNdFFYcPP5aWauxr8wB1Hb3fCavrpaadwwWI79qABM1dfxwXlwZVZLnK7UZa+QVb/
	 KtRHu991UnxSQULBnEn/Chs1Q2mzATp3OwGFFeXJWFx7Bcu+Y0Og8l4kxSNiWwdhSgNnf
	 q0W2rJVyEHZegi/fLrFAJzgWzAOI+2W8eNjHwDCJlv2g8LEq+7re8z9W3zDwuSYfxTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UggQb9oa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD6B606A8B5
	for <mm-commits@vger.kernel.org>; Mon, 16 Nov 2026 22:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UggQb9oa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 049A11F000C5;
	Mon, 16 Nov 2026 22:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794867993;
	bh=jEkhsCtqt/OeawAYx+APm3KbhNkP16w9r1GvGRUlPaU=;
	h=Date:To:From:Subject;
	b=UggQb9oaMLx00LBOeHwQZeB7wPKEiCl3YlSDYdBu6gKSRAjfdcvZcvyg0loMmnDJq
	 MtMk1jfw6taEGMrTL9Rpejx/sSOPZp9UP8WLX2Up6dE/GbXNqggBgfgXbcLFBjf29Y
	 1466TJkjbckvG6kib21SA3pfgxsoXKwERDTAgJRQ=
Date: Mon, 16 Nov 2026 14:26:32 -0800
To: mm-commits@vger.kernel.org,nico.pache@linux.dev,luiz.capitulino@linux.dev,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entries-for-luiz-capitulino.patch added to mm-nonmm-hotfixes-unstable branch
Message-Id: <20261116222633.049A11F000C5@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mailmap: add entries for Luiz Capitulino
has been added to the -mm mm-nonmm-hotfixes-unstable branch.  Its filename is
     mailmap-add-entries-for-luiz-capitulino.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entries-for-luiz-capitulino.patch

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
From: "Luiz Capitulino (Red Hat)" <luiz.capitulino@linux.dev>
Subject: mailmap: add entries for Luiz Capitulino
Date: Mon, 16 Nov 2026 16:57:56 -0500

Map my previous addresses to my linux.dev address, which I'll be using for
kernel work going forward.

Link: https://lore.kernel.org/20261116215756.133593-1-luiz.capitulino@linux.dev
Signed-off-by: Luiz Capitulino (Red Hat) <luiz.capitulino@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Nico Pache <nico.pache@linux.dev>

 .mailmap |    3 +++
 1 file changed, 3 insertions(+)

--- a/.mailmap~mailmap-add-entries-for-luiz-capitulino
+++ a/.mailmap
@@ -587,6 +587,9 @@ Lorenzo Stoakes <ljs@kernel.org> <lorenz
 Luca Ceresoli <luca.ceresoli@bootlin.com> <luca@lucaceresoli.net>
 Luca Weiss <luca@lucaweiss.eu> <luca@z3ntu.xyz>
 Lucas De Marchi <demarchi@kernel.org> <lucas.demarchi@intel.com>
+Luiz Capitulino <luiz.capitulino@linux.dev> <lcapitulino@redhat.com>
+Luiz Capitulino <luiz.capitulino@linux.dev> <luizcap@amazon.com>
+Luiz Capitulino <luiz.capitulino@linux.dev> <luizcap@redhat.com>
 Lukasz Luba <lukasz.luba@arm.com> <l.luba@partner.samsung.com>
 Luo Jie <jie.luo@oss.qualcomm.com> <luoj@codeaurora.org>
 Luo Jie <jie.luo@oss.qualcomm.com> <quic_luoj@quicinc.com>
_

Patches currently in -mm which might be from luiz.capitulino@linux.dev are

mailmap-add-entries-for-luiz-capitulino.patch

