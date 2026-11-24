Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795540212;
	b=tk70p1IONFh4TqHTIvgWMPMGILCW3NdIUsO30HXOoB5JDcvpZp1VLJU5K6eaNcmv0wzV
	 IGZgNnmllUwTkI4CSO314dqybtj9dDxw8GFzb4Oszhbqv17TRR4bzHWQMc8iKMp/VlaPl
	 yVzUwrP2mee/Q7R0q7noNCId4iRIH/GSVoVgyscJydetQRVhkn61KULfZTv2bcWLvNRsY
	 ex/NqAIkXsvz86crVgMkGNP6FhkAGtOx7dQd/DLdWGktcza7wXJLV1793n9KWcn39QmTn
	 asFhJb6IgdcCOCjXDTR1yNsZ4wLdI89o7mjXp0S2wKAAGJDQXMrvma7eZOw60sv90NQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795540212;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=g6tufEw9rr8EQnht1+3rZ0bL/AYMddl8RYJSWCLJly4=;
	b=cHa2677FhTgAdCCC8igiYe0jh+w6A8lDhO3wW5bqchiRDnvuWcKzr3GWj/jTZt1xJdGe
	 Nn+gh1bnKr/Pc2xZ/MXUtyJEGsh0p3ReiUvFd1cVB16185mjp0ozBRTj87jEugJsqGokW
	 ODMn0YLj3qFY6WKZj3GafsAyHxu1JcVDe5qF2hif8Nhkor9drnzNOCR5LxrEEkKE3agRJ
	 Q8sLCsPREP5hlXjqLZVrzqHGlO1gJP0Y9tXmiKyb7ooKz/CcDCMpJIShOgdnpkneCOm81
	 3B3DA9ccoWcMCmMRHKnEB/lKkV1V94SpN17Qh0k0rxXJCMosxx7CI7gKEkcse96x/Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=CqJ6ozUn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE1E60A3815
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 17:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=CqJ6ozUn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1571F01564;
	Tue, 24 Nov 2026 17:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795540211;
	bh=g6tufEw9rr8EQnht1+3rZ0bL/AYMddl8RYJSWCLJly4=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=CqJ6ozUnzfxrsMYfPWYMTrQn14cCshk21uqXEpRDFYcs1NfJ5jZQ1ynhyMoMeI9yy
	 6kkIGcRwWOLMo29e4tUBaPMu/LtiDiAf3oQVyGT4z8TR0GKHkFpxKoNI2AxicwRi3W
	 QdIWVQDhSKGCUBke8yxQhd878W9CocV7aFgL4370=
Date: Tue, 24 Nov 2026 09:10:10 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,
	rdunlap@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124160124.93482-4-sj@kernel.org>
References: <20261124160124.93482-4-sj@kernel.org>
Subject: + docs-mm-damon-maintainer-profile-drop-scm-trees-section.patch added to mm-unstable branch
Message-Id: <20261124171011.6F1571F01564@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Docs/mm/damon/maintainer-profile: drop 'SCM Trees' section
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-maintainer-profile-drop-scm-trees-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-maintainer-profile-drop-scm-trees-section.patch

This patch will later appear in the mm-unstable branch at
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
From: SJ Park <sj@kernel.org>
Subject: Docs/mm/damon/maintainer-profile: drop 'SCM Trees' section
Date: Tue, 24 Nov 2026 08:01:21 -0800

Right after 7.5-rc1, DAMON will onboard the mm-next transition [1].  The
major change is that it will use damon.git [2] as its SCM tree.  'SCM
Trees' section on the maintainer profile document will be outdated.  The
updates for the new process would make the roles of the new trees clear.
Hence 'SCM Trees' section would be no more necessary.  Remove the
section.

Link: https://patch.msgid.link/20261124160124.93482-4-sj@kernel.org
Link: https://lore.kernel.org/bed81e01-7303-4957-bd7d-38e3a094e96f@kernel.org/ [1]
Link: https://git.kernel.org/pub/scm/linux/kernel/git/mm/damon.git/ [2]
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: David Hildenbrand <david@kernel.org>

 Documentation/mm/damon/maintainer-profile.rst |   20 ----------------
 1 file changed, 20 deletions(-)

--- a/Documentation/mm/damon/maintainer-profile.rst~docs-mm-damon-maintainer-profile-drop-scm-trees-section
+++ a/Documentation/mm/damon/maintainer-profile.rst
@@ -18,26 +18,6 @@ the reason and what baseline is used.
 
 Patches should be posted to the mailing lists whenever possible.
 
-SCM Trees
----------
-
-There are multiple Linux trees for DAMON development.  Patches under
-development or testing are queued in `damon/next
-<https://git.kernel.org/sj/h/damon/next>`_ by the DAMON maintainer.
-Sufficiently reviewed patches will be queued in `mm-new
-<https://git.kernel.org/akpm/mm/h/mm-new>`_ by the memory management subsystem
-maintainer.  As more sufficient tests are done, the patches will move to
-`mm-unstable <https://git.kernel.org/akpm/mm/h/mm-unstable>`_ and then to
-`mm-stable <https://git.kernel.org/akpm/mm/h/mm-stable>`_.  And finally those
-will be pull-requested to the mainline by the memory management subsystem
-maintainer.
-
-Note again the patches for `mm-new tree
-<https://git.kernel.org/akpm/mm/h/mm-new>`_ are queued by the memory management
-subsystem maintainer.  If the patches require some patches in `damon/next tree
-<https://git.kernel.org/sj/h/damon/next>`_ which have not yet merged in mm-new,
-please make sure the requirement is clearly specified.
-
 Submit checklist addendum
 -------------------------
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-copy-only-installed-probe-in-damon_split_region_at.patch
mm-damon-core-add-damos_filter_type_age_ms.patch
mm-damon-sysfs-schemes-support-damos_filter_type_age_ms.patch
docs-mm-damon-design-update-for-age_ms-damos-core-filter-type.patch
docs-admin-guide-mm-damon-usage-update-for-age_ms-damos-core-filter.patch
mm-damon-api-define-damon_filter_type_active.patch
mm-damon-ops-common-implement-damon_filter_type_active-operation.patch
mm-damon-sysfs-support-lru-activeness-based-damon-filter-setup.patch
docs-mm-damon-design-update-for-damon_filter_type_active.patch
maintainers-change-damon-scm-tree-to-mm-damongit.patch
docs-mm-damon-maintainer-profile-use-damongit-for-patch-baselines.patch
docs-mm-damon-maintainer-profile-drop-scm-trees-section.patch
docs-mm-damon-maintainer-profile-update-key-cycle-dates-for-damongit.patch

