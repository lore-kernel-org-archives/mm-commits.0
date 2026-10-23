Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792797834;
	b=X/KMcOUVzJxVx7KtAsWen/+hpmIEesGetmwzzg0TUvvPdYo9ddfCu/4+jPsFIxC+B3vc
	 j+GEUAEBqPnCSacCJ6dh4dYMBkDumR9C45EBeSGfKsKsR01lQAooku5OeOA61A6Xyh8DH
	 rOkZ58SL9E0dQNbRX5QacP8BPoLcgPe2kq+PGYraOTxRmsjXbJnOVLkXeNhX9rcRYunbs
	 XUpfglgtcoqB7WAAJWL2uwIHT5MdhCqfRg19QF6lBVtVoS+LOAAxRiZJaSa9iNEK6VVHj
	 1nnP/qQeSMtuaVKCcJAH/Oz+Fod0p8SfZJltPaFdVSQyv4+Wpa3Naql07JsKisha28Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792797834;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=jscqA+bP44Td7HmLuqXaCZnfnOFQgnxph9UcGF3rxIU=;
	b=l6veI6zOqxvP10L0gBEhXUlJYB4U9I/8P3V+sVfox74ZEEoUJkjtuDCwhfY2yCbbodul
	 cKRv/M7NQfhDh+/U6YiwSREu8JYnz4XC6IFb4NVMA4Vgvmmrsm2cJw9NPA/+vN6IJXqJz
	 3k+LTZgA96GqvD3glYwoigK7I49JORQPs/YFGcrFZkWcLlzlww3zCXCqQkToFT8nK9YB6
	 eLazy71XNcACNj3y0FygzkceJ7Bgyh5bUGlUfNs4ZFkqtHkA8hnX065qitmNKk58oxkZe
	 o8wowKTcQyXzRaqrsKes/j7BAeaS0W+jt00VYp4kivTx6N98r6g1z0uayeehno74Z6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=lw8ZwOf2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B88606A31A
	for <mm-commits@vger.kernel.org>; Fri, 23 Oct 2026 23:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=lw8ZwOf2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274D01F01825;
	Fri, 23 Oct 2026 23:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792797834;
	bh=jscqA+bP44Td7HmLuqXaCZnfnOFQgnxph9UcGF3rxIU=;
	h=Date:To:From:Subject;
	b=lw8ZwOf2g6JgWTcPIQrdvPG2K5WqbneMSF8V35YvWXzG1TFN0gTWBHFHrDDrqURAy
	 08vYbj3+tlAPBxumitwwIACYpbB8fcLmNPMXTRIx6wQ4j/QFvE2bWoE5QKlgMRp5MR
	 IZR5QbA4OxjYRMqgZ2EYydslH9qCYSnJN+2EkxOo=
Date: Fri, 23 Oct 2026 16:23:53 -0700
To: mm-commits@vger.kernel.org,andrea.cervesato@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-andrea-cervesatos-email-for-ltp.patch added to mm-nonmm-unstable branch
Message-Id: <20261023232354.274D01F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: MAINTAINERS: update Andrea Cervesato's email for LTP
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     maintainers-update-andrea-cervesatos-email-for-ltp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-andrea-cervesatos-email-for-ltp.patch

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
From: Andrea Cervesato <andrea.cervesato@suse.com>
Subject: MAINTAINERS: update Andrea Cervesato's email for LTP
Date: Fri, 23 Oct 2026 12:45:21 +0200

I'm not working for SUSE anymore and I will use linux.dev email to
develop and maintain Linux Test Project.

Link: https://lore.kernel.org/20261023-acer_maintainers-v1-1-848cf4a99a10@suse.com
Signed-off-by: Andrea Cervesato <andrea.cervesato@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-update-andrea-cervesatos-email-for-ltp
+++ a/MAINTAINERS
@@ -15570,7 +15570,7 @@ F:	Documentation/devicetree/bindings/i2c
 F:	drivers/i2c/muxes/i2c-mux-ltc4306.c
 
 LTP (Linux Test Project)
-M:	Andrea Cervesato <andrea.cervesato@suse.com>
+M:	Andrea Cervesato <andrea.cervesato@linux.dev>
 M:	Cyril Hrubis <chrubis@suse.cz>
 M:	Jan Stancek <jstancek@redhat.com>
 M:	Petr Vorel <pvorel@suse.cz>
_

Patches currently in -mm which might be from andrea.cervesato@suse.com are

maintainers-update-andrea-cervesatos-email-for-ltp.patch

