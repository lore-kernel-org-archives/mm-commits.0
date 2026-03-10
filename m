Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6A3285CA2
	for <mm-commits@vger.kernel.org>; Tue, 10 Mar 2026 23:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773183756; cv=none; b=DZWYPcTFY+5fljri65BkO0Wwd2Ah/3aWeGhsObVg9GA5luFmyJseLbqVuLU0B5Aza+RmNjxJCkK8QpNWnN5s5PecZtAAriRNcIMB1Ys5FDnwW0k2eZkjDH8CMA4JRGqdKDWTqpd8iiSBFxFKwv5OprTkGxavYGQ05DuaWdF6M84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773183756; c=relaxed/simple;
	bh=cyvobBBgNxxE+Htro9EtNDj3qwHvmvuWSZl8+JKCZmc=;
	h=Date:To:From:Subject:Message-Id; b=YTE7ackfBqAyRESBGvXPciSM1O+e2uJzV45mHNllZFcUsB6GQjbj+1xELgNTc+Sixwc3HgjkjbV/xEmTqfkT0ylC+RdG+UtlI8pSt2Sl6JnvIhqYSQSsf+ThyAssc/jRpS/1XN5RCoBL48UywH0GuQPkVkv/Cm68fl6sIV+Yf3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mip2y55c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mip2y55c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C76AC19423;
	Tue, 10 Mar 2026 23:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773183756;
	bh=cyvobBBgNxxE+Htro9EtNDj3qwHvmvuWSZl8+JKCZmc=;
	h=Date:To:From:Subject:From;
	b=mip2y55czRCXS/eCYLNgt1Myjgl4tvmH3OohM3wk40oAGqy8hlseA+4GF7CGt+0OK
	 nEkNyO/PsDrB9A9KLT0OAk0g2y1z00vKHPTwC36Cj31KRbJdEAY6wmCpZ0QrEFKhNd
	 gbPEhWgoo4nl8v4cXXWo9dJmHbnDZcxsbt4lQm38=
Date: Tue, 10 Mar 2026 16:02:35 -0700
To: mm-commits@vger.kernel.org,lukas@wunner.de,herbert@gondor.apana.org.au,dhowells@redhat.com,ignat@cloudflare.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-update-email-address-for-ignat-korchagin.patch removed from -mm tree
Message-Id: <20260310230236.8C76AC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: update email address for Ignat Korchagin
has been removed from the -mm tree.  Its filename was
     maintainers-update-email-address-for-ignat-korchagin.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ignat Korchagin <ignat@cloudflare.com>
Subject: MAINTAINERS: update email address for Ignat Korchagin
Date: Mon, 9 Mar 2026 17:34:45 +0000

Since I'm moving from Cloudflare update my email address in the
MAINTAINERS file and add an entry to .mailmap so nothing gets lost.

Link: https://lkml.kernel.org/r/20260309173445.71393-1-ignat@cloudflare.com
Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
Acked-by: Lukas Wunner <lukas@wunner.de>
Cc: David Howells <dhowells@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |    8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/.mailmap~maintainers-update-email-address-for-ignat-korchagin
+++ a/.mailmap
@@ -327,6 +327,7 @@ Henrik Rydberg <rydberg@bitmath.org>
 Herbert Xu <herbert@gondor.apana.org.au>
 Huacai Chen <chenhuacai@kernel.org> <chenhc@lemote.com>
 Huacai Chen <chenhuacai@kernel.org> <chenhuacai@loongson.cn>
+Ignat Korchagin <ignat@linux.win> <ignat@cloudflare.com>
 Ike Panhc <ikepanhc@gmail.com> <ike.pan@canonical.com>
 J. Bruce Fields <bfields@fieldses.org> <bfields@redhat.com>
 J. Bruce Fields <bfields@fieldses.org> <bfields@citi.umich.edu>
--- a/MAINTAINERS~maintainers-update-email-address-for-ignat-korchagin
+++ a/MAINTAINERS
@@ -4022,7 +4022,7 @@ F:	drivers/hwmon/asus_wmi_sensors.c
 ASYMMETRIC KEYS
 M:	David Howells <dhowells@redhat.com>
 M:	Lukas Wunner <lukas@wunner.de>
-M:	Ignat Korchagin <ignat@cloudflare.com>
+M:	Ignat Korchagin <ignat@linux.win>
 L:	keyrings@vger.kernel.org
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
@@ -4035,7 +4035,7 @@ F:	include/linux/verification.h
 
 ASYMMETRIC KEYS - ECDSA
 M:	Lukas Wunner <lukas@wunner.de>
-M:	Ignat Korchagin <ignat@cloudflare.com>
+M:	Ignat Korchagin <ignat@linux.win>
 R:	Stefan Berger <stefanb@linux.ibm.com>
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
@@ -4045,14 +4045,14 @@ F:	include/crypto/ecc*
 
 ASYMMETRIC KEYS - GOST
 M:	Lukas Wunner <lukas@wunner.de>
-M:	Ignat Korchagin <ignat@cloudflare.com>
+M:	Ignat Korchagin <ignat@linux.win>
 L:	linux-crypto@vger.kernel.org
 S:	Odd fixes
 F:	crypto/ecrdsa*
 
 ASYMMETRIC KEYS - RSA
 M:	Lukas Wunner <lukas@wunner.de>
-M:	Ignat Korchagin <ignat@cloudflare.com>
+M:	Ignat Korchagin <ignat@linux.win>
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
 F:	crypto/rsa*
_

Patches currently in -mm which might be from ignat@cloudflare.com are


