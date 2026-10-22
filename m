Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792684865;
	b=wWoxLYOjHi2a6n0Np/elwYAg5dHZqVfM/+7GFY+jdVIr+WROfUbr6ouiQawDdmPb3BEs
	 UXmFoGtSCorClEJC7OgUlDsHlqO+UNFBsTIR/PggNulAJ3uuU2YRde5tTxtn+lWgepxId
	 Um39svrvBOIJ76LzV4d00Ohwg1y4PX1mC7lQZewTe9Dwg4inzjij6H71a8pwFxMxlDyiE
	 5F71i4PBDSp2BOQ1rVNb5SRUknvnmFCTFdLa09rf3NW57Zv1pZI52xMywXMCzpY3VQNoz
	 xZOedWEV0ztw6nwaigU6pNWpc3Kec2s0C4wiw4g3emq4kS/15wtUxMG2eZn5G0AMTLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792684865;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=zKxKlxjhfhmM01Z2JB3lIBQC+QXnoAqNjVysDcA/4Ac=;
	b=l6RMGT3PoPEanDSO/B/Og4Yptlp2kRHfYv2PgUjdopkhZtb1Mjntkzo/RQ8iZMf8n0+d
	 3yyZqV1f1+97+d/EkXACWkQjoRz1dI+ZnSwdcfDnpEigzBYxwQm8tP7++clz2kNCarmAE
	 mqtn8jxSmR9LaMn9zOkDs6xnFLBraWTNurX2RMHeqvHFxsBlS4Qf2GaeXNgzY3WTQUZH+
	 A0886pM7Pk/C8w6bt7Hp7uZwJyLkeRDj/rQfQMAj7JTkHGIMtO4egsKcIl+71e6YmZZQT
	 sCup2nWb+lLev/X4Ps5fR2L+NMIoEUSq/3sES2neZ6uzRLknVk2pR0CX3vzThBgjdUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Wwuh6phb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3734606A319
	for <mm-commits@vger.kernel.org>; Thu, 22 Oct 2026 16:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Wwuh6phb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31EEB1F01825;
	Thu, 22 Oct 2026 16:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792684864;
	bh=zKxKlxjhfhmM01Z2JB3lIBQC+QXnoAqNjVysDcA/4Ac=;
	h=Date:To:From:Subject;
	b=Wwuh6phbCaCgWUaNS4no5PpwTV1jCou2Y4I4SHOXLxt7YSOS22cW5GyyoXUdfTlay
	 ij0nKiEMq87ahJ0cNOFhtewZOZjofs17+vXp8HuLJepTlpyuNp2RjzVSJSBZvbV263
	 tJScSq/H9w8kAsD0n+8etaHJjUFd9e39z/72rzJ0=
Date: Thu, 22 Oct 2026 09:01:03 -0700
To: mm-commits@vger.kernel.org,andrew.jones@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entries-for-andrew-jones.patch added to mm-nonmm-unstable branch
Message-Id: <20261022160104.31EEB1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mailmap: add entries for Andrew Jones
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mailmap-add-entries-for-andrew-jones.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entries-for-andrew-jones.patch

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
From: Andrew Jones <andrew.jones@linux.dev>
Subject: mailmap: add entries for Andrew Jones
Date: Thu, 22 Oct 2026 17:45:32 +0200

Use my linux.dev address for kernel correspondence, including for
contributions made with my other email addresses.

Link: https://lore.kernel.org/20261022154532.1374661-1-andrew.jones@linux.dev
Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    4 ++++
 1 file changed, 4 insertions(+)

--- a/.mailmap~mailmap-add-entries-for-andrew-jones
+++ a/.mailmap
@@ -88,6 +88,10 @@ Andrej Shadura <andrew@shadura.me> <andr
 Andrew Donnellan <andrew+kernel@donnellan.id.au> <andrew@donnellan.id.au>
 Andrew Donnellan <andrew+kernel@donnellan.id.au> <ajd@linux.ibm.com>
 Andrew Donnellan <andrew+kernel@donnellan.id.au> <andrew.donnellan@au1.ibm.com>
+Andrew Jones <andrew.jones@linux.dev> <ajones@ventanamicro.com>
+Andrew Jones <andrew.jones@linux.dev> <andrew.jones@oss.qualcomm.com>
+Andrew Jones <andrew.jones@linux.dev> <anjones@nvidia.com>
+Andrew Jones <andrew.jones@linux.dev> <drjones@redhat.com>
 Andrew Morton <akpm@linux-foundation.org>
 Andrew Murray <amurray@thegoodpenguin.co.uk> <amurray@embedded-bits.co.uk>
 Andrew Murray <amurray@thegoodpenguin.co.uk> <andrew.murray@arm.com>
_

Patches currently in -mm which might be from andrew.jones@linux.dev are

mailmap-add-entries-for-andrew-jones.patch

