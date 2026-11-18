Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794980531;
	b=VjpOssXYVtKpuy5q/8Jdvmb3DyqRhFtmGaFrGEFCasLblKjavZdtazeumJvYBFoIYCoy
	 8fqpqwNYz4xV7DlkuuZROiLmeb7ge2A/mLAXZ2bz881nEUMe0Xp2zXtcMfR0eYS5lkmhy
	 sJ3OQCPOZr78ZTds2ceqBEE1z1liUgQXywO+8f+BOgLsmCualReWu3Xc7M34SLzqT2JCs
	 CCtnfxC4B68Sixe+09hE4I9RxPWa6aO7JJeNu8SRjUsGbty1vdRqLz5VyS5HXMZ1BPYlj
	 rT1iN5oTmmFMuKrUfYz1ekx20+HG37mpWsUTT5GvLhppSxWooDIjuY7Cslwbg+Q1kqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794980531;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=X5D2WSlH+mzIOy7WrV0SzIO1wwEHbp+8rQpbHh9BJIA=;
	b=aoQ0A7XT4BXJF3aGVSHhSMZ2Zno4k70oacWIcAHS6q8jQ/lJvgFFfptzGQbGkpffHIvS
	 KK0o1ZbxgmCDP4p1lbXF41QTMFuAPLZD9WCGgznNgV6nEpD1ZX6ZTJ2e3y+H7XZn8+tjT
	 2SlTWAiL4MHHrKJnr3M6ys+lSwGik6atTqiFWOqEf8po0XGoKw9wd3X71ZfFhybml04GH
	 i+onpyIJmwi6wmPCeAlhAzYpTgec2ljAahcBvXCKFh4xWTTRbAb5JfqTgkUTA1BCcoPV2
	 eJpqwgS0YlJgob0gXQSoW6g19GhgQLQ+z9G+vQUjuyTKOxuIuy+2CC2nn3Swk1KrHJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="L/HmBAKP";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53633606A31C
	for <mm-commits@vger.kernel.org>; Wed, 18 Nov 2026 05:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=L/HmBAKP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7651F000C4;
	Wed, 18 Nov 2026 05:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794980531;
	bh=X5D2WSlH+mzIOy7WrV0SzIO1wwEHbp+8rQpbHh9BJIA=;
	h=Date:To:From:Subject;
	b=L/HmBAKPO8d5GJDQULjvZvs/m09WCvSLt2VpdtbgWj/V2/l0pKAvNCZu0endW0P0J
	 QcGX/vw0//iY7emJpZSlbdZrC4f3zD+WLPGwkAIOOshOC9V0Lre75DR/hXpchE/dWC
	 IrcHCR4HNeTaj4TbTtNu+oeLyYGpywqmL7MuE3M4=
Date: Tue, 17 Nov 2026 21:42:10 -0800
To: mm-commits@vger.kernel.org,pvorel@suse.cz,li.wang@linux.dev,
	chrubis@suse.cz,andrea.cervesato@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-hotfixes-stable] maintainers-update-andrea-cervesatos-email-for-ltp.patch removed from -mm tree
Message-Id: <20261118054211.1C7651F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: MAINTAINERS: update Andrea Cervesato's email for LTP
has been removed from the -mm tree.  Its filename was
     maintainers-update-andrea-cervesatos-email-for-ltp.patch

This patch was dropped because it was merged into the mm-nonmm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrea Cervesato <andrea.cervesato@linux.dev>
Subject: MAINTAINERS: update Andrea Cervesato's email for LTP
Date: Mon, 26 Oct 2026 11:47:17 +0100

I'm not working for SUSE anymore and I will use linux.dev email to
develop and maintain Linux Test Project. Also update .mailmap.

Link: https://lore.kernel.org/20261026-acer_maintainers-v2-1-4cf0f350fdf1@linux.dev
Signed-off-by: Andrea Cervesato <andrea.cervesato@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Petr Vorel <pvorel@suse.cz>
Reviewed-by: Li Wang (Hieco) <li.wang@linux.dev>
Reviewed-by: Cyril Hrubis <chrubis@suse.cz>

 .mailmap    |    1 +
 MAINTAINERS |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/.mailmap~maintainers-update-andrea-cervesatos-email-for-ltp
+++ a/.mailmap
@@ -83,6 +83,7 @@ Amit Blay <quic_ablay@quicinc.com> <abla
 Amit Nischal <quic_anischal@quicinc.com> <anischal@codeaurora.org>
 Andi Kleen <ak@linux.intel.com> <ak@suse.de>
 Andi Shyti <andi@etezian.org> <andi.shyti@samsung.com>
+Andrea Cervesato <andrea.cervesato@linux.dev> <andrea.cervesato@suse.com>
 Andreas Herrmann <aherrman@de.ibm.com>
 Andreas Hindborg <a.hindborg@kernel.org> <a.hindborg@samsung.com>
 Andrej Shadura <andrew.shadura@collabora.co.uk>
--- a/MAINTAINERS~maintainers-update-andrea-cervesatos-email-for-ltp
+++ a/MAINTAINERS
@@ -15933,7 +15933,7 @@ F:	Documentation/devicetree/bindings/i2c
 F:	drivers/i2c/muxes/i2c-mux-ltc4306.c
 
 LTP (Linux Test Project)
-M:	Andrea Cervesato <andrea.cervesato@suse.com>
+M:	Andrea Cervesato <andrea.cervesato@linux.dev>
 M:	Cyril Hrubis <chrubis@suse.cz>
 M:	Jan Stancek <jstancek@redhat.com>
 M:	Petr Vorel <pvorel@suse.cz>
_

Patches currently in -mm which might be from andrea.cervesato@linux.dev are


