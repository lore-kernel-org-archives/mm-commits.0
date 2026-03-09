Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74088175A75
	for <mm-commits@vger.kernel.org>; Mon,  9 Mar 2026 19:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773083020; cv=none; b=ZHpht6ioDUTpRrJhhQCa4cKlWqIuqxHJFUZZRPKD2ThnpJRe9A1ysjUHCMLpKNTub5AOLGUjauetwvAwYhCum79j102x7STDCw2GkSU+GOSCzgxcQ2nejAk20GHcx2ssZ6K45dsdnoWP36kab+eWvcVSnZQNaxKJ1t/SeCZZWio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773083020; c=relaxed/simple;
	bh=di7WyrQbxAfVVtrAjiYN17/fgxxT+u6ZiPowNj6KKpA=;
	h=Date:To:From:Subject:Message-Id; b=AbnRy63ECr3/uPaaq7YaHGvL3xqhJa01xCLog4E4KbH4azck7GmQSogKDBxI3Muh46L01C+iSNqTEKYr7i6oOXK/eLsCQf11oweNPUu2Fqcnakxhr41z8Kc1fEXsErFIafnXF45DfQPyhn/kKbBNZu/l5ennIIdPK2a/nxGgQe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bzeEHymE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bzeEHymE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21AC1C4CEF7;
	Mon,  9 Mar 2026 19:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773083020;
	bh=di7WyrQbxAfVVtrAjiYN17/fgxxT+u6ZiPowNj6KKpA=;
	h=Date:To:From:Subject:From;
	b=bzeEHymEP5EyTnZHTSVf7n4EcDzq5mwGOflRH1FQXLG5NfpG9GKqn5U0O84oc2QhD
	 aLqZQM+W+lMRON9W2O07cf8F0At+Tl+z7z9fTGqRuVqBwZWcuNfW5QaqZ8rBmSWnpi
	 zCUZCNKOIfQAJ4FCcdOZld+jvPEKA+KkfCzf0QTU=
Date: Mon, 09 Mar 2026 12:03:41 -0700
To: mm-commits@vger.kernel.org,lukas@wunner.de,herbert@gondor.apana.org.au,dhowells@redhat.com,ignat@cloudflare.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-email-address-for-ignat-korchagin.patch added to mm-hotfixes-unstable branch
Message-Id: <20260309190340.21AC1C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: update email address for Ignat Korchagin
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-update-email-address-for-ignat-korchagin.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-email-address-for-ignat-korchagin.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
@@ -322,6 +322,7 @@ Henrik Rydberg <rydberg@bitmath.org>
 Herbert Xu <herbert@gondor.apana.org.au>
 Huacai Chen <chenhuacai@kernel.org> <chenhc@lemote.com>
 Huacai Chen <chenhuacai@kernel.org> <chenhuacai@loongson.cn>
+Ignat Korchagin <ignat@linux.win> <ignat@cloudflare.com>
 Ike Panhc <ikepanhc@gmail.com> <ike.pan@canonical.com>
 J. Bruce Fields <bfields@fieldses.org> <bfields@redhat.com>
 J. Bruce Fields <bfields@fieldses.org> <bfields@citi.umich.edu>
--- a/MAINTAINERS~maintainers-update-email-address-for-ignat-korchagin
+++ a/MAINTAINERS
@@ -4025,7 +4025,7 @@ F:	drivers/hwmon/asus_wmi_sensors.c
 ASYMMETRIC KEYS
 M:	David Howells <dhowells@redhat.com>
 M:	Lukas Wunner <lukas@wunner.de>
-M:	Ignat Korchagin <ignat@cloudflare.com>
+M:	Ignat Korchagin <ignat@linux.win>
 L:	keyrings@vger.kernel.org
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
@@ -4038,7 +4038,7 @@ F:	include/linux/verification.h
 
 ASYMMETRIC KEYS - ECDSA
 M:	Lukas Wunner <lukas@wunner.de>
-M:	Ignat Korchagin <ignat@cloudflare.com>
+M:	Ignat Korchagin <ignat@linux.win>
 R:	Stefan Berger <stefanb@linux.ibm.com>
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
@@ -4048,14 +4048,14 @@ F:	include/crypto/ecc*
 
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

maintainers-update-email-address-for-ignat-korchagin.patch

