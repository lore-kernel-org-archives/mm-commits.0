Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793560983;
	b=SsKVb10Twuv+AFlfd7lBm9Adt1fHQMtrV8y6vjdU9fNW3iyTBM0GTpp0s8MHszsLmFRk
	 fOpwfUlBQ1wDQquJy2f4OSfxpU31wlGgS2p403xN9JOqQmDFMiIQLKKWnOIpojdDh8a7P
	 q5L86T2fecJoxXDr9WayyGklwgN0GBW/Rp6IGlzJ7YzOVBLWpkbp3jmEh2XR1ZrwrvsXA
	 XrEPDWMXoFcJNTmpyFIWOQgyXxS1E0F6ZxdU6amWa3PfVbsdbwjM5EsH7h+b8iLA6xCRo
	 SBOk6tB58xLKU9bvOe0DDbFIbXcfnmXJk4fHIojKUck4uLvBGoapMwl+kMzWIhPP9MQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793560983;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=3KqYphuxDOeHbB5JbP1DoGHLHuxdnjMvQlMYNcT6cSs=;
	b=owzlbYiQALcnPL6ASHmA4GhltYajhn2orfHFENbhW27og8nmI6s79n+LlSg9QJEBEQ4r
	 U8NqzyXpyDFvuAzuYPnPcQShIkwwSZUeN6gf4hvOEhhNdqHAO3/SP4AksxezISYkPezg9
	 5wHqSHFrVcF5gE4PqRSLDOnyrnDg7SHWNtNCdk2WkstA4N/ZyyZFCAWD2u/N8jpsb2Rb/
	 UU81hNV0byuvqLMvMPQNaAuLjYqXS4Xss8kCFN9GC/iIxrw2Z/oSySyI1e2zO1EADQcTY
	 LM2W0PMOKesGw8qMNymv+e1jS9Zi5TNJAfoKjXuS5g+1ySXhxPTZuqEiBDWIYmTfGXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=HssYeikK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A003606A326
	for <mm-commits@vger.kernel.org>; Sun,  1 Nov 2026 19:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=HssYeikK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB73F1F000C1;
	Sun,  1 Nov 2026 19:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793560982;
	bh=3KqYphuxDOeHbB5JbP1DoGHLHuxdnjMvQlMYNcT6cSs=;
	h=Date:To:From:Subject;
	b=HssYeikK62CjVQnJwZArkcrp8hHP/HsOF9OyoTzHFcKgMPJN9Sk0S0bQ76oBDBL1O
	 PRBchxJuCeRv6tPcb+4qF0ZCgUvLu04exNWKhV/Wrvq+qqCvuhVqUk2msNTvGHXZIh
	 YGd1OBaXKuLDmJZy3rEiIODxh6zEMKx0Cnbc+fl0=
Date: Sun, 01 Nov 2026 11:23:02 -0800
To: mm-commits@vger.kernel.org,beat@softbase.tech,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entry-for-beat-m-liechti.patch added to mm-nonmm-unstable branch
Message-Id: <20261101192302.AB73F1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mailmap: add entry for Beat M. Liechti
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mailmap-add-entry-for-beat-m-liechti.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entry-for-beat-m-liechti.patch

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
From: "Beat M. Liechti" <beat@softbase.tech>
Subject: mailmap: add entry for Beat M. Liechti
Date: Sun,  1 Nov 2026 13:37:29 +0100

Map my old address, used for the firedtv fixes in 2009, to my current
one.

Link: https://lore.kernel.org/20261101123733.10578-1-beat@softbase.tech
Signed-off-by: Beat M. Liechti <beat@softbase.tech>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-entry-for-beat-m-liechti
+++ a/.mailmap
@@ -155,6 +155,7 @@ Bart Van Assche <bvanassche@acm.org> <ba
 Bart Van Assche <bvanassche@acm.org> <bart.vanassche@wdc.com>
 Bartosz Golaszewski <brgl@kernel.org> <bartosz.golaszewski@linaro.org>
 Bartosz Golaszewski <brgl@kernel.org> <bgolaszewski@baylibre.com>
+Beat M. Liechti <beat@softbase.tech> <bml303@gmail.com>
 Ben Dooks <ben-linux@fluff.org> <ben.dooks@simtec.co.uk>
 Ben Dooks <ben-linux@fluff.org> <ben.dooks@sifive.com>
 Ben Gardner <bgardner@wabtec.com>
_

Patches currently in -mm which might be from beat@softbase.tech are

mailmap-add-entry-for-beat-m-liechti.patch

