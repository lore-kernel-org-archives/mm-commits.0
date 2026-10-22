Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792704471;
	b=0MLj1D0+rsHbvhH3uSTASdXvfAUlrbo2IynUs8zw039gBhioZjpGIdFDc4S/WmAbciEd
	 uxl/h9f3gh/cpOxKXqOk1CI3x/MeZXW+wz1T5kdzVU619qpQLQcGirTw2psNJbst+i8+c
	 CTBMkFnctUOWSMjgYfZrmfJ3p+MmaPbIeEzdG+u7Gn2S5FXl8oTwJRaNxYkx7byiVNXrZ
	 5OZjRVNWRtjBsiYN1JKJoImePK/nsbzxC1pFH2C+mXY3Bb4iY4bHx+l+ODtlb/9mNv+dc
	 /xpsKA4XZ5gG+Rw99rXWbUDdRGbvDHke9nl+Dv/flGCV6SKGMu1IM8AzLi7rxlPTyPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792704471;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=QgwaE9S83cJ41QeWG4WzKbMomBMJok9C3O3RKbKlpQY=;
	b=k9djXjhvEkHmlDuQVgoaUAE5hyeW7Dk/OBWx76tkrQtaH7DV473AGlVV8fQWtw0O3snl
	 9nPK9QDPN+SamUAy9Q8pnGLn95LCRRUe7EaakU7f1dhlKBvcZfPbirNFCEKw68lsuiDuI
	 cUgbfY+KTm1rvvBq9T0Us2Fue6frpoOIThZDMgPM9crhpuFEpF5QinqOcWU9IkrvGrvvB
	 Xn3hbq+SIMkBTYJ1+7NZebqHpygrS+nmm28U72ZI3ImX6bHp9GYxo15AT5ZbhhG2fEkiQ
	 BIzN08KwlNg/9pmzrjkW0segNjWnbAycWT5K0+kqKzbcDKoWDSfaOlRlOeoAFiHHL7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ZeGo8lSF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD9F606A31A
	for <mm-commits@vger.kernel.org>; Thu, 22 Oct 2026 21:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ZeGo8lSF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F931F01825;
	Thu, 22 Oct 2026 21:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792704471;
	bh=QgwaE9S83cJ41QeWG4WzKbMomBMJok9C3O3RKbKlpQY=;
	h=Date:To:From:Subject;
	b=ZeGo8lSFIUNc4XfdQ6no5m+W47hDESG5RLgLkNTOUR5cqU00YRHGBGmt5MGOi3uw/
	 TFgheeusjn2EZQQQo2nEZ9er/eL5RVtSTelUBp75w9xftEO1YT7hJyfn65U+Mbz5/Q
	 2nkYBE//W2p44tC/168lmED92lWYsQfzd1N6YtY8=
Date: Thu, 22 Oct 2026 14:27:50 -0700
To: mm-commits@vger.kernel.org,martink@posteo.de,kuba@kernel.org,cel@kernel.org,alex@sverdlin.org,markus.mayer@broadcom.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-my-e-mail-address.patch added to mm-nonmm-unstable branch
Message-Id: <20261022212750.E1F931F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: MAINTAINERS: update Markus's e-mail address
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     maintainers-update-my-e-mail-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-my-e-mail-address.patch

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
From: Markus Mayer <markus.mayer@broadcom.com>
Subject: MAINTAINERS: update Markus's e-mail address
Date: Thu, 22 Oct 2026 14:19:48 -0700

Classic Broadcom e-mail addresses were recently phased out.  Update
MAINTAINERS to the new format.  Also add an entry to .mailmap for said
address.

Finally, since I am already touching .mailmap, I may as well map an
ancient Linaro address, as well.

Link: https://lore.kernel.org/20261022211949.42939-1-markus.mayer@broadcom.com
Signed-off-by: Markus Mayer <markus.mayer@broadcom.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Alexander Sverdlin <alex@sverdlin.org>
Cc: Chuck Lever <cel@kernel.org>
Cc: Martin Kepplinger <martink@posteo.de>
---

 .mailmap    |    2 ++
 MAINTAINERS |    8 ++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/.mailmap~maintainers-update-my-e-mail-address
+++ a/.mailmap
@@ -599,6 +599,8 @@ Marek Lindner <marek.lindner@mailbox.org
 Marek Lindner <marek.lindner@mailbox.org> <mareklindner@neomailbox.ch>
 Mark Brown <broonie@sirena.org.uk>
 Mark Starovoytov <mstarovo@pm.me> <mstarovoitov@marvell.com>
+Markus Mayer <markus.mayer@broadcom.com> <mmayer@broadcom.com>
+Markus Mayer <markus.mayer@broadcom.com> <markus.mayer@linaro.org>
 Markus Schneider-Pargmann <msp@baylibre.com> <mpa@pengutronix.de>
 Mark Yao <markyao0591@gmail.com> <mark.yao@rock-chips.com>
 Martin K. Petersen <mkp@kernel.org> <martin.petersen@oracle.com>
--- a/MAINTAINERS~maintainers-update-my-e-mail-address
+++ a/MAINTAINERS
@@ -5296,7 +5296,7 @@ F:	Documentation/devicetree/bindings/usb
 F:	drivers/usb/gadget/udc/bdc/
 
 BROADCOM BMIPS CPUFREQ DRIVER
-M:	Markus Mayer <mmayer@broadcom.com>
+M:	Markus Mayer <markus.mayer@broadcom.com>
 R:	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
 L:	linux-pm@vger.kernel.org
 S:	Maintained
@@ -5571,7 +5571,7 @@ F:	drivers/spi/spi-brcmstb-qspi.c
 F:	drivers/spi/spi-iproc-qspi.c
 
 BROADCOM STB AVS CPUFREQ DRIVER
-M:	Markus Mayer <mmayer@broadcom.com>
+M:	Markus Mayer <markus.mayer@broadcom.com>
 R:	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
 L:	linux-pm@vger.kernel.org
 S:	Maintained
@@ -5579,7 +5579,7 @@ F:	Documentation/devicetree/bindings/cpu
 F:	drivers/cpufreq/brcmstb*
 
 BROADCOM STB AVS TMON DRIVER
-M:	Markus Mayer <mmayer@broadcom.com>
+M:	Markus Mayer <markus.mayer@broadcom.com>
 R:	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
 L:	linux-pm@vger.kernel.org
 S:	Maintained
@@ -5587,7 +5587,7 @@ F:	Documentation/devicetree/bindings/the
 F:	drivers/thermal/broadcom/brcmstb*
 
 BROADCOM STB DPFE DRIVER
-M:	Markus Mayer <mmayer@broadcom.com>
+M:	Markus Mayer <markus.mayer@broadcom.com>
 R:	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
_

Patches currently in -mm which might be from markus.mayer@broadcom.com are

maintainers-update-my-e-mail-address.patch

