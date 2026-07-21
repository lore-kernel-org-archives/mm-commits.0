Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A460C3368AB
	for <mm-commits@vger.kernel.org>; Tue, 21 Jul 2026 17:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655728; cv=none; b=WiAPppeyYNTz/Bnl/zmheahf1jH9Lq5Kx3a2DqE8E+uatBNESFyohxUtTo96L0ZBc/nseKMVAMZku5aKY0adxzkmTFtQFEbopDjNYSjwLm8SubrBPAW+ARZ8m7feFRCc7qcKSBu0/4BcNmH1byYfYzZB8runP2fRETYdsjf2zm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655728; c=relaxed/simple;
	bh=USE3sYtbaZ0N7O6Au31NHyq2ERSzAHIRM2j7V4VW37o=;
	h=Date:To:From:Subject:Message-Id; b=kR0TEA72zS4cFxWGdaDzJ+7PQ7HZ+FqQPCqkeJOBUDuyCJsRhrXnq2Hi9AKgSsbOMmbSwFwRGBsIrnFoOld8ZzK3IV1Vz3Mgk5p/NT2otZ0GGwShyxCtSDvn4Ei5Qfq3+eFzYhc9A4JVnrlSdfBuPGUWcqMST2qjvZqPZv9Jln0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FZ2GnBj3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FZ2GnBj3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF4C1F00A3A;
	Tue, 21 Jul 2026 17:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784655726;
	bh=DbtG4FWfPBC7FAOvbQ7Zx0yNP3+VuU7eOdNTZ2A6XYI=;
	h=Date:To:From:Subject;
	b=FZ2GnBj3MfmiFt/E3OarM75/rWWKz9fmVgjRSqVIK62wD1l4tx2WT2dXKDmdPpOaS
	 uyQg3bjdkil+BhaFayu4uoxW4PgQyDHOPcIcJYzVYPc1KVraNhCGoOOt8KMSh67o9a
	 2kgVg7zAGR7wS7XU/4CPjrT7/0MROOexlO/fyqVM=
Date: Tue, 21 Jul 2026 10:42:05 -0700
To: mm-commits@vger.kernel.org,npache@redhat.com,david@kernel.org,nico.pache@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-nico-paches-email-address.patch added to mm-hotfixes-unstable branch
Message-Id: <20260721174206.4FF4C1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: update Nico Pache's email address
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-update-nico-paches-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-nico-paches-email-address.patch

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
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Subject: MAINTAINERS: update Nico Pache's email address
Date: Tue, 21 Jul 2026 04:18:11 -0600

Switch my entry in MAINTAINERS and .mailmap to my @linux.dev email address

Link: https://lore.kernel.org/20260721101811.115954-1-nico.pache@linux.dev
Signed-off-by: Nico Pache <npache@redhat.com>
Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/.mailmap~maintainers-update-nico-paches-email-address
+++ a/.mailmap
@@ -645,6 +645,7 @@ Nicholas Piggin <npiggin@gmail.com> <npi
 Nicholas Piggin <npiggin@gmail.com> <nickpiggin@yahoo.com.au>
 Nicholas Piggin <npiggin@gmail.com> <piggin@cyberone.com.au>
 Nicolas Ferre <nicolas.ferre@microchip.com> <nicolas.ferre@atmel.com>
+Nico Pache <nico.pache@linux.dev> <npache@redhat.com>
 Nicolas Pitre <nico@fluxnic.net> <nicolas.pitre@linaro.org>
 Nicolas Pitre <nico@fluxnic.net> <nico@linaro.org>
 Nicolas Saenz Julienne <nsaenz@kernel.org> <nsaenzjulienne@suse.de>
--- a/MAINTAINERS~maintainers-update-nico-paches-email-address
+++ a/MAINTAINERS
@@ -17252,7 +17252,7 @@ M:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Zi Yan <ziy@nvidia.com>
 R:	Baolin Wang <baolin.wang@linux.alibaba.com>
 R:	Liam R. Howlett <liam@infradead.org>
-R:	Nico Pache <npache@redhat.com>
+R:	Nico Pache <nico.pache@linux.dev>
 R:	Ryan Roberts <ryan.roberts@arm.com>
 R:	Dev Jain <dev.jain@arm.com>
 R:	Barry Song <baohua@kernel.org>
_

Patches currently in -mm which might be from nico.pache@linux.dev are

maintainers-update-nico-paches-email-address.patch

