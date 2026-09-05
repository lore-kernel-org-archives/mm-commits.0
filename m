Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01D41B87C9
	for <mm-commits@vger.kernel.org>; Sat,  5 Sep 2026 22:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788646619; cv=none; b=IczOYjEtJF9HFZvdNhj4Bnf+Gbufqo9rz8kzvMSETXIaIU5akEiF9Zmh6I82s6+7DA8y7T/DB9YqowlwEgrFeTDFN/6X6zfRDGNstqnXluFB5+U9WljH/mfedsu0x8nKpi6Rpdwf5oyzzDbgX33jIouZjBjwqW9OV8hBcC9lh+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788646619; c=relaxed/simple;
	bh=r1ugTIobqSVoKtAFVFEBszYugICljR/czjG2naSTlsc=;
	h=Date:To:From:Subject:Message-Id; b=Ow1fj3KwjhI743HZEoJOOfTURe5kKzHEa/BQ6iwCedU2Wtth53SZa9r0MTa0C9Aj7UWh8Ys9fzV7bRYjGuZFs90yHfVVofQ0rcGAQ1lM93E0rMGdmSRg5WKQRlWAvsy9XtQevtu3yrhawvSH33/zb9q+x0HwM6asYw98HSy2gbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fPxB7M83; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fPxB7M83"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA631F00A3A;
	Sat,  5 Sep 2026 22:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788646617;
	bh=S7EZKr2O/c2QeYlsH9rjWtv3hJVOeRQKhn3ZinPU/94=;
	h=Date:To:From:Subject;
	b=fPxB7M83HYFwALXKAZvTlSFHCSv1UKhKnYL/mKCALB3v6Ni1Jp1lfEFLSaDbPs32k
	 2CKBh0MSENL11ziKiGWNfnm2TxE5rXahO7waUkqJe9rYTAMJVMM2i4U3z5rzLkvIvi
	 VSZS0tNcFHaWgZ9pHm9E3Gu69dWVKFenhnwEP9o0=
Date: Sat, 05 Sep 2026 15:16:56 -0700
To: mm-commits@vger.kernel.org,aliamemis@disroot.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-email-address-for-ali-ahmet-memiş.patch added to mm-nonmm-unstable branch
Message-Id: <20260905221657.0BA631F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: update email address for Ali Ahmet Memiş
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mailmap-update-email-address-for-ali-ahmet-memiş.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-email-address-for-ali-ahmet-memiş.patch

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
From: Ali Ahmet Memiş <aliamemis@disroot.org>
Subject: mailmap: update email address for Ali Ahmet Memiş
Date: Sat, 5 Sep 2026 22:49:39 +0300

I'm switching to my disroot address for kernel contributions.  Map the
address my earlier patches were sent from to it, so that get_maintainer.pl
stops offering the old one as a recipient.

Also switch to the proper spelling of my name with diacritics, which is
what I use with the new address.

Link: https://lore.kernel.org/20260905195000.556185-1-aliamemis@disroot.org
Signed-off-by: Ali Ahmet Memiş <aliamemis@disroot.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-email-address-for-ali-ahmet-memiş
+++ a/.mailmap
@@ -67,6 +67,7 @@ Alex Hung <alexhung@gmail.com> <alex.hun
 Alex Shi <alexs@kernel.org> <alex.shi@intel.com>
 Alex Shi <alexs@kernel.org> <alex.shi@linaro.org>
 Alex Shi <alexs@kernel.org> <alex.shi@linux.alibaba.com>
+Ali Ahmet Memiş <aliamemis@disroot.org> <ali@iusegentoo.com>
 Alice Mikityanska <alice.kernel@fastmail.im> <maxtram95@gmail.com>
 Alice Mikityanska <alice.kernel@fastmail.im> <maximmi@mellanox.com>
 Alice Mikityanska <alice.kernel@fastmail.im> <maximmi@nvidia.com>
_

Patches currently in -mm which might be from aliamemis@disroot.org are

mailmap-update-email-address-for-ali-ahmet-memiş.patch

