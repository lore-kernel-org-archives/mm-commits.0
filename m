Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794980516;
	b=JLE9kqmeLCnuFHgxse7l3+aUBZKMB/HRqsnt0/BMsl3vCf2976Z25dPZ0xTed3UG79UT
	 59Gm3tgzsAOeUABBbFUyHJvAspPwF/90VOc/cBcKPWHlNExEBJwq86r64cXiBIR1rV1zk
	 nR+u/SwUbQNvM9xlHYv45iAlI3SgRpieya7poefdN8RWzSHL1KotWr1TRfCFydVroK9rV
	 6rk+fg60GHXiCMvT4+dr2Yy/mJEtty2o08Hl1hGDid5zRYhUlER4KSjftTGnmcP5N0bVf
	 twZcGGu7mdjc1m6NfK84JsXMQKw4LVO8GmI0U+v0gOg8CDCHc1NBNDuaivnOofEdh6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794980516;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Q0trRgjgda0ZEi1yjHoa5cYdsX2hapFO+40vfO53szc=;
	b=JMRPcYFTDPv7RsWxzcZyidhNLgBhG8PH7+CukBsRmd+lPpvQoLNLGBY1oCIsZqczmqNF
	 W32GYbtEubZPxkSG0O5ccXW38JzX+tjwjHQSZHy3onVlojHZRt8ByYim789dTSmvWEtU2
	 hyiWMDBxRPR+eJT1DGlIs3r445Yc4V5fX+ZjLYxH+4IluhZsOCOID/HjLOUwviRQifqBr
	 O5zbIuYT6D1k2qpy8+Xpj9MmwHLoCGKz4fn1t3WTzZwhf75Q9k7M58O4xO5mWaV/pCq5j
	 C/q+x9c02OEf35ph8tj9FYPYPYfEojuxu5fobw2tIUyL8qkd5PgcPuyPmnWfRw3psPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=EUWc1h0j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22F3606A31C
	for <mm-commits@vger.kernel.org>; Wed, 18 Nov 2026 05:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=EUWc1h0j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7061F000C8;
	Wed, 18 Nov 2026 05:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794980516;
	bh=Q0trRgjgda0ZEi1yjHoa5cYdsX2hapFO+40vfO53szc=;
	h=Date:To:From:Subject;
	b=EUWc1h0jxVc1tRB4iDrpb2OWaMSiwuMHxP4tXLyuaLSSz6XoUhuILeLGk0LkSjdey
	 iAfJscvJK2o+FkgH+Hf2RC/K88DtHyKQAU6nm/whjws3gSnYu7FJZTPVXuFANC3Rgj
	 4Ov2cnSO7ZU9b/vQPrKo7lEEioDzy7iWkPeeJxvA=
Date: Tue, 17 Nov 2026 21:41:56 -0800
To: mm-commits@vger.kernel.org,yehezkelshb@gmail.com,lukas@wunner.de,
	andreas.noever@gmail.com,westeri@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-hotfixes-stable] mailmap-update-mika-westerbergs-email-address.patch removed from -mm tree
Message-Id: <20261118054156.8C7061F000C8@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mailmap: update Mika Westerberg's email address
has been removed from the -mm tree.  Its filename was
     mailmap-update-mika-westerbergs-email-address.patch

This patch was dropped because it was merged into the mm-nonmm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mika Westerberg <westeri@kernel.org>
Subject: mailmap: update Mika Westerberg's email address
Date: Wed, 11 Nov 2026 13:39:09 +0100

My @linux.intel.com address will be going away soon so switch to use my
@kernel.org address.

Link: https://lore.kernel.org/20261111123910.1324579-1-mika.westerberg@linux.intel.com
Signed-off-by: Mika Westerberg <westeri@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Yehezkel Bernat <yehezkelshb@gmail.com>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Andreas Noever <andreas.noever@gmail.com>

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-mika-westerbergs-email-address
+++ a/.mailmap
@@ -669,6 +669,7 @@ Michel Lespinasse <michel@lespinasse.org
 Michel Lespinasse <michel@lespinasse.org> <walken@zoy.org>
 Mickaël Salaün <mic@digikod.net> <mic@linux.microsoft.com>
 Miguel Ojeda <ojeda@kernel.org> <miguel.ojeda.sandonis@gmail.com>
+Mika Westerberg <westeri@kernel.org> <mika.westerberg@linux.intel.com>
 Mike Leach <mike.leach@arm.com> <mike.leach@linaro.org>
 Mike Rapoport <rppt@kernel.org> <mike@compulab.co.il>
 Mike Rapoport <rppt@kernel.org> <mike.rapoport@gmail.com>
_

Patches currently in -mm which might be from westeri@kernel.org are


