Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C292EEE75
	for <mm-commits@vger.kernel.org>; Mon, 14 Sep 2026 02:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789353437; cv=none; b=m7Y+xb4JyhxAeLuQnlEmotpqyZ+LHfJvImzaE1bnJiZYVaW/KMjxmjSNZY8Ws1rApjwESJr7hUZaPB0dEZlDcBWVz36UPNpQPPQBA3FnvstJRwjglcyoKTlDIc27XPd4729DP/OTa1JSVoWjVh0oT4ofI/rlZwfQmixvUQXCnIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789353437; c=relaxed/simple;
	bh=s813lbnjG08aJ1oVVa6l960PQLYGmtUMmkb1xFBP7xc=;
	h=Date:To:From:Subject:Message-Id; b=hV5MeEP2Kx3Qv+f3EoDSVtGNGFQIVryBW72rwUbFpSYhkGN7TMXaLo2MCqqMyfsSHxejf7n71t3rPqQd8+VeRoBVMGSmd72KgubH9BC4X9+zBg4m48IsSAPLEnAwXGAECQwOH85nIrBRyqekqrqk15zHwC8KmEVhESNJYxc/gs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kD0Iib5d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kD0Iib5d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AEFA1F000FF;
	Mon, 14 Sep 2026 02:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789353436;
	bh=5k0znzKuBZsVBsWueD8N5Wbl3U5P2/DM1MxIjtc/oEQ=;
	h=Date:To:From:Subject;
	b=kD0Iib5dRJ0wO6OCM0nozDhZyOdVGS/Yp+FCzDpbQ8PzbvUH7KM4X2wH6aaZUQ9S+
	 jCnqpLWkC9wIQvdrmLsTkG+/dD+eKCdEUS+qDDmjecD8QbDjEXNd88lxuuA+LUrykL
	 TQms8mHDIl36JQg5dWKGQsaiGb05J4If+Tp0K4Bw=
Date: Sun, 13 Sep 2026 19:37:15 -0700
To: mm-commits@vger.kernel.org,andrey.golovko@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-email-address-for-andrey-golovko.patch added to mm-nonmm-unstable branch
Message-Id: <20260914023716.4AEFA1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: update email address for Andrey Golovko
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mailmap-update-email-address-for-andrey-golovko.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-email-address-for-andrey-golovko.patch

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
From: Andrey Golovko <andrey.golovko@gmail.com>
Subject: mailmap: update email address for Andrey Golovko
Date: Sat, 12 Sep 2026 19:26:30 +0300

Patches sent from andrey.golovko@gmail.com carry the authorship of my
commits, but some of the tags I gave on other people's patches use
andrey@golovko.me.  Map the second address onto the first so the two do
not look like two different contributors.

Link: https://lore.kernel.org/20260912162630.7731-1-andrey.golovko@gmail.com
Signed-off-by: Andrey Golovko <andrey.golovko@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-email-address-for-andrey-golovko
+++ a/.mailmap
@@ -92,6 +92,7 @@ Andrew Morton <akpm@linux-foundation.org
 Andrew Murray <amurray@thegoodpenguin.co.uk> <amurray@embedded-bits.co.uk>
 Andrew Murray <amurray@thegoodpenguin.co.uk> <andrew.murray@arm.com>
 Andrew Vasquez <andrew.vasquez@qlogic.com>
+Andrey Golovko <andrey.golovko@gmail.com> <andrey@golovko.me>
 Andrey Konovalov <andreyknvl@gmail.com> <andreyknvl@google.com>
 Andrey Ryabinin <ryabinin.a.a@gmail.com> <a.ryabinin@samsung.com>
 Andrey Ryabinin <ryabinin.a.a@gmail.com> <aryabinin@virtuozzo.com>
_

Patches currently in -mm which might be from andrey.golovko@gmail.com are

mailmap-update-email-address-for-andrey-golovko.patch

