Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281BB1A5B9D
	for <mm-commits@vger.kernel.org>; Sat,  1 Aug 2026 18:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785609078; cv=none; b=e+ndeAJ+2ck6uD88Os7nOjoWZ/c0Mr4IWN6TXCnItGUz8vq8ubF+IdIzAxWoCR2Ff51KQbbpoEDJdR8FziuXwxiGqL8ouPLPVbfmtG4vsqgPrXoqzrxj2lydSkhiliCsTtdea3EC9EDSAhzBbFHxTbMkgyTwXf2dARoMg83XqAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785609078; c=relaxed/simple;
	bh=hmkvysxiZSuhCfsCHbxZV0VXVdZB3lYcJ4d16HmJSJI=;
	h=Date:To:From:Subject:Message-Id; b=QCSP0qy5U53h0OGxXTTTYjls2HKzER+wnBzDm+Myj8a0mqGqyTiws3VfjtEU+77BJwPKc1/GNU8ibXYZghHAcLa9WrzF9gpDn1nOCyTaKa//TGUzRgQF4Uo41Q5uDF9Qzp1co0jIJm4P+sDcc6bxug+YKQS+bVArroo+rpBJDC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o4livOLB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o4livOLB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967461F00AC4;
	Sat,  1 Aug 2026 18:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785609076;
	bh=xgumP63lTQRtUKeqCZyp7FXQw97gvcLVwRMJgUouaF0=;
	h=Date:To:From:Subject;
	b=o4livOLBdV1zh2Y4Rj0x40sTdO7ZpzrFKEknYjXCRVBOOHplqsMg3em6g0PC9lwcJ
	 zJj8kAeCAwpJUpFJ+ojYVewaYk8vG/E3X+xcvzm+Lfl/IIJ5WyI/YudbZcInk3uFsx
	 +jULqvDDp2PM8I0FfiDbzWE3BLcXGh0aHIFbXiT0=
Date: Sat, 01 Aug 2026 11:31:16 -0700
To: mm-commits@vger.kernel.org,kuba@kernel.org,danila@mainlining.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-map-old-addresses-to-danila-tikhonov.patch added to mm-hotfixes-unstable branch
Message-Id: <20260801183116.967461F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: map old addresses to Danila Tikhonov
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-map-old-addresses-to-danila-tikhonov.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-map-old-addresses-to-danila-tikhonov.patch

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
From: Danila Tikhonov <danila@mainlining.org>
Subject: mailmap: map old addresses to Danila Tikhonov
Date: Sat, 1 Aug 2026 18:33:33 +0300

Map my old jiaxyga.com and ProtonMail addresses to the current
mainlining.org address.

Link: https://lore.kernel.org/20260801153333.296218-1-danila@mainlining.org
Signed-off-by: Danila Tikhonov <danila@mainlining.org>
Cc: Jakub Kacinski <kuba@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-map-old-addresses-to-danila-tikhonov
+++ a/.mailmap
@@ -233,6 +233,8 @@ Daniel Lezcano <daniel.lezcano@kernel.or
 Daniel Lezcano <daniel.lezcano@kernel.org> <dlezcano@fr.ibm.com>
 Daniel Thompson <danielt@kernel.org> <daniel.thompson@linaro.org>
 Daniele Alessandrelli <daniele.alessandrelli@gmail.com> <daniele.alessandrelli@intel.com>
+Danila Tikhonov <danila@mainlining.org> <danila@jiaxyga.com>
+Danila Tikhonov <danila@mainlining.org> <JIaxyga@protonmail.com>
 Danilo Krummrich <dakr@kernel.org> <dakr@redhat.com>
 David Brownell <david-b@pacbell.net>
 David Collins <quic_collinsd@quicinc.com> <collinsd@codeaurora.org>
_

Patches currently in -mm which might be from danila@mainlining.org are

mailmap-map-old-addresses-to-danila-tikhonov.patch

