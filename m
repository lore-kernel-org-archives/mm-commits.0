Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793064140;
	b=jsVGfxKirmu7FSNsot5egdjYgLJV0Ho7t/iSPlxRc0PWyeUIr0cLEE8UlPOXV/G/0yfW
	 /NawX4FPk6gbPL3s4VtDYd0THgHIadNDcEzb5dhq3b0Pf0Ja6eElgO1b3hLlFI7wiGuy2
	 ToPzsLj2RWKDetdQNbpgZiNjrJOi2H6x7zSJfz2a7fNqL0y0Uf82KJ6PxX4EY+2D/8KcA
	 FBBkp6txvlfdWidMeLhDjBev5z/Up4ot0MUG/DS6CLRQWzQ/5obUnsLgVkwaD/Xr9JWle
	 zY3rekYq4VZuxrbQ3FNXXAtzgl/oNHQxsaLq0oZKO1uhOS8Us6Tb45kEdkYvy1tWMUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793064140;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=TRlXgK8lSCFWy7DtK/7chRw9V29DTiCGrV591cYtqA4=;
	b=myj2kaHyuQ8n6c47sSoazU5x5nk1eRTwNx++QszpQnbV9Il6JCTblj1qTtfPSkXxsYw+
	 d4O4I5Wm8tUkwJnvO8K5okOSSZWnfK+i78c0D4EA/fBslhJ0ObYVs/kU8Fefs2qtI1LHN
	 eMilQY2nrp77euBPBRlZ82w9UrMvsvTmCu2nvxSs4/i24uEZ9SDbwHRORTni9spUiHgPF
	 WLKQTGXZ4a/uyHd97wbAjWDPkqlPm2luxNl99KMHk9ejL7gnmTY6D7g0YvkaYjm4Dwo1A
	 Hp7jM59/LvCxHX0uGjVWeMQc/ptthjcSAY3IkHl/66ef26ir6GENG6WIpC/sUJfaMHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=E8v4PcWX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2FB606A31A
	for <mm-commits@vger.kernel.org>; Tue, 27 Oct 2026 01:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=E8v4PcWX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A303C1F01825;
	Tue, 27 Oct 2026 01:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793064139;
	bh=TRlXgK8lSCFWy7DtK/7chRw9V29DTiCGrV591cYtqA4=;
	h=Date:To:From:Subject;
	b=E8v4PcWXlANxNeBc9J7VeQq3kGDhTmSCFR9YiggxL/PHcyjF6LhZmo7hjafYCnNnS
	 pMZv9QHPn55UUGxmBx9XCBD0HRgXH7Mv1WMaRCoomdftqSdCPO2obQuG945W/c7p4c
	 KhgHXWlr1VxDXqPfD0OPHGbKnVPHhm1C5M665hek=
Date: Mon, 26 Oct 2026 18:22:19 -0700
To: mm-commits@vger.kernel.org,pvorel@suse.cz,andrea.cervesato@linux.dev,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-andrea-cervesatos-email-for-ltp.patch added to mm-nonmm-unstable branch
Message-Id: <20261027012219.A303C1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: MAINTAINERS: Update Andrea Cervesato's email for LTP
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
From: Andrea Cervesato <andrea.cervesato@linux.dev>
Subject: MAINTAINERS: Update Andrea Cervesato's email for LTP
Date: Mon, 26 Oct 2026 11:47:17 +0100

I'm not working for SUSE anymore and I will use linux.dev email to
develop and maintain Linux Test Project. Also update .mailmap.

Link: https://lore.kernel.org/20261026-acer_maintainers-v2-1-4cf0f350fdf1@linux.dev
Signed-off-by: Andrea Cervesato <andrea.cervesato@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Petr Vorel <pvorel@suse.cz>
---

 .mailmap    |    1 +
 MAINTAINERS |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/.mailmap~maintainers-update-andrea-cervesatos-email-for-ltp
+++ a/.mailmap
@@ -81,6 +81,7 @@ Amit Blay <quic_ablay@quicinc.com> <abla
 Amit Nischal <quic_anischal@quicinc.com> <anischal@codeaurora.org>
 Andi Kleen <ak@linux.intel.com> <ak@suse.de>
 Andi Shyti <andi@etezian.org> <andi.shyti@samsung.com>
+Andrea Cervesato <andrea.cervesato@linux.dev> <andrea.cervesato@suse.com>
 Andreas Herrmann <aherrman@de.ibm.com>
 Andreas Hindborg <a.hindborg@kernel.org> <a.hindborg@samsung.com>
 Andrej Shadura <andrew.shadura@collabora.co.uk>
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

Patches currently in -mm which might be from andrea.cervesato@linux.dev are

maintainers-update-andrea-cervesatos-email-for-ltp.patch

