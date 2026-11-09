Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794252359;
	b=KinKkFJgJeSVNRR+klC7UkdoJe5N7hh/YCGDvno7DagxdQZQr146K9do9cg42+/MhCrB
	 oLJlpBeom+zb2VKXmock4B8kJw4fD/YjfN+hVqJY0PfGzseNPuUBpfizniAv+UiGtIucp
	 YnzHkTFtwEZQyHVqZrLnAoq1MP0les8P0inTFCpN/MktAAuFSaC63mPBPoUqkrFYlmpbk
	 Uige8QpeAJZT66b9y5ZRuqXbnxXVHq0a/sLMicaDFJQWne81hcr36/FwZg+yQSBPwHD8d
	 98NuSH4e4C+KsO4+4U/wwRZcFgBy0prMeSq4yjvhu5dMuatd2nUl4mEENuptlVww/lA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794252359;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=y+mm9RCwokP3BvMRB9sMGvTrOCc8VGfvO4b2vUpxwxc=;
	b=4A7xgTwa+E3LO/HYdGbOP+rXOWUwrWMlWXFGKp7bRaeSdQNd0KOji3jDenjb0sMlKZ5p
	 uTaNdH+AmssLQfVxuF8RREEpPVT0XvKnh08E8V18Y/3VVq0sA4Gm+jqpT+Sgz5snAk76u
	 7xGUFhEJxXoHcShua7LaKt8b0/D4X9V83ZyAt46xhTJeC3xHcMTbRbILXy8FIDuQTEyIE
	 8th055NEn7ShVYaLJbY0sAv8w1pNeZdXnGBZ6vWe5EOdNkKW9i9+kJYXB+7XmZ0XsFW0d
	 cymGXFYk2bZswZ8K8sBgU4A8ZNW7/yRHSI/kVVxCFMbaThjMy+epiQRCHUlJGXg+SxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WKQ+Qdo0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43342606A31C
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 19:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WKQ+Qdo0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9EB71F0089F;
	Mon,  9 Nov 2026 19:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794252358;
	bh=y+mm9RCwokP3BvMRB9sMGvTrOCc8VGfvO4b2vUpxwxc=;
	h=Date:To:From:Subject;
	b=WKQ+Qdo0quWgPfZDVohsgC1Q7dmm4q3fmGFP3173LvW6SBeP5TqvJg1pfnZZx4lzx
	 jC5ubikt61AzHVLfOjHPxlKtRq9KF8BgtxHKjutTt334H2ecPTRHr9BqwGJZKoq2qX
	 1wOnH5kkI5vvSTTbyUuQqCz7UFLwJHOWSyPlnJOc=
Date: Mon, 09 Nov 2026 11:25:58 -0800
To: mm-commits@vger.kernel.org,brads@mainlining.org,bradley.morgan@linux.dev,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-email-address-for-bradley-morgan.patch added to mm-nonmm-unstable branch
Message-Id: <20261109192558.C9EB71F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mailmap: update email address for Bradley Morgan
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mailmap-update-email-address-for-bradley-morgan.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-email-address-for-bradley-morgan.patch

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
From: Bradley Morgan <bradley.morgan@linux.dev>
Subject: mailmap: update email address for Bradley Morgan
Date: Mon,  9 Nov 2026 19:19:28 +0000

I switched to bradley.morgan@linux.dev for kernel work, so map the
brads@mainlining.org and include@grrlz.net addresses over to keep shortlog
and blame from splitting commits between them.

Link: https://lore.kernel.org/20261109191928.3222846-1-bradley.morgan@linux.dev
Signed-off-by: Bradley Morgan <bradley.morgan@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Bradley Morgan <brads@mainlining.org>
---

 .mailmap |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/.mailmap~mailmap-update-email-address-for-bradley-morgan
+++ a/.mailmap
@@ -182,7 +182,8 @@ Boris Brezillon <bbrezillon@kernel.org>
 Boris Brezillon <bbrezillon@kernel.org> <b.brezillon@overkiz.com>
 Boris Brezillon <bbrezillon@kernel.org> <boris.brezillon@bootlin.com>
 Boris Brezillon <bbrezillon@kernel.org> <boris.brezillon@free-electrons.com>
-Bradley Morgan <brads@mainlining.org> <include@grrlz.net>
+Bradley Morgan <bradley.morgan@linux.dev> <brads@mainlining.org>
+Bradley Morgan <bradley.morgan@linux.dev> <include@grrlz.net>
 Brendan Higgins <brendan.higgins@linux.dev> <brendanhiggins@google.com>
 Brendan Jackman <brendan.jackman@linux.dev> <jackmanb@google.com>
 Brian Avery <b.avery@hp.com>
_

Patches currently in -mm which might be from bradley.morgan@linux.dev are

mailmap-update-email-address-for-bradley-morgan.patch

