Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794980515;
	b=sBmXHIWLgLQFVgSno6UHuTu0m9ES0aLxzGHQP8FjlbUEbfk4vYyaJieiDiiFNtByFi2b
	 bDLeCTP4i4WVHugTY7ZOsUgP+9WWnTq808ZdTyXjU9xq0YhIV0eLCaqDFP2T88daXa5ZF
	 5pQh83mWdx7q2AMx+UdL7103onBtrtiZjgKWpzT9u3NriLZKdmSDU88ENfUlaaZP5rpU1
	 eZXpCzjGnwr6WI8/qKhUAb6DxIBnSHmqf4Hu0UHzvm3Rxqk6mhlURi6KGqwrhMdo9QvLD
	 isciO1xfWWCDD2sQIJhPaUMEN1Y9NtQG7UtkkrhlYQJN8BiemxGM7DUfZaakKA5f4mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794980515;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=GwH05R/kllaH7F/omM4MetAtvX4G7TlWazSfjBpiyN8=;
	b=Va94oQbXKLnW3DTh3TDwacLjjr9SoF+pYlWe06vc8CK5WAyauE11y8izh2tsefIVZdxY
	 rMYcrz5nsVomLblDpEw5NwubpNp8+u+jQIKBwoQQ+XwtrbiVw1RapoHgcwgLsqNnK99lj
	 qvMzEEcngGAJosUqIAVKzg4xhYzp21dXdEtlhatt7T+91UT/72gIMLNBztyG0BOsTHm0j
	 uL87WaB7B7DpfxpqxMt2Evzsxq6LCV/rDbbvY/s/eWdTOoLhDdc3PjT5QAKCgaAurG2DX
	 97Yk8JxmJ02HXKAULXJa0X2mhtTairVFvivyQu05vCwNJdXH/DFdxXcm3NRg21jerpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=W7exgxIm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36AFD606A31C
	for <mm-commits@vger.kernel.org>; Wed, 18 Nov 2026 05:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=W7exgxIm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005E81F000C8;
	Wed, 18 Nov 2026 05:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794980515;
	bh=GwH05R/kllaH7F/omM4MetAtvX4G7TlWazSfjBpiyN8=;
	h=Date:To:From:Subject;
	b=W7exgxImnFM1hmP9fwfCDDA+aEi6QW3+4YbS2/U/aDpTxWLz+AFwR2TUhbKl7zp8N
	 r6dnXAcfm2jVJY+faX5AinkuYdFyqvL4Yrund3Hf8yfCTDETB31dmVEIOBN2yTl8aU
	 M4N1oQopwQsDttFbIF0DD3MK7kP4hKIp4S90yWxo=
Date: Tue, 17 Nov 2026 21:41:54 -0800
To: mm-commits@vger.kernel.org,brads@mainlining.org,bradley.morgan@linux.dev,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-hotfixes-stable] mailmap-update-email-address-for-bradley-morgan.patch removed from -mm tree
Message-Id: <20261118054155.005E81F000C8@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mailmap: update email address for Bradley Morgan
has been removed from the -mm tree.  Its filename was
     mailmap-update-email-address-for-bradley-morgan.patch

This patch was dropped because it was merged into the mm-nonmm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 .mailmap |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/.mailmap~mailmap-update-email-address-for-bradley-morgan
+++ a/.mailmap
@@ -180,7 +180,8 @@ Boris Brezillon <bbrezillon@kernel.org>
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


