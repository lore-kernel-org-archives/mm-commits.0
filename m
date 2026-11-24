Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795540214;
	b=RLZ1ld5AervoqgXtsbtUtJJlLyGdBa2VXGmRbgq6kUUWHShq7tSsSY+TC2+TgH11gjwt
	 vmZc8D+uouLa/LSm1xc8FiQm6GFa94SfoOtJaLaCi76CKTORD8LB/d3XnTxwxT3+FnJOf
	 x5PN+ndyu0dqlz1WpPhHVVQWc3LdEsFxljWn2Mpr8OoIYicJx0Eg1r65ehoJA/22ZE4qm
	 w4h2fuBZvjVKOFEmppkNUOR28OHCpm0JZd3NfHL5rpwPwATufNdFrZeyjLW5ZWVLdS8si
	 8/1tULtuHhnAG6ihZVz1FIIXUX/guBFSzgTSkeWnHbTjwYBAxWNpDmX46G4Tb0Ql3Ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795540214;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=+vybS5VRcRZGiySAsp9Fr+sb5LIIu9nCYoiUue39U08=;
	b=UZjeC6e4kKgDCNLXTYe4/wthJCnerjwdu4N8WwruzvNFuPArmN7KXekAo86zOmU6L7pv
	 AbWAkxzDoPUrj+DaggXLKR1GPB04ti7dX95U6uLc5/oP2QCRecuPyYdFfbkg6uUN5BYgf
	 33SaB7g9JJd41oiPE/7u5SkgF18QfMoo4qlTyA0Fd4n0/ea/vXJEhd8oFocHLvK9D+fAB
	 xKOZvt1JPvacYF49IjcfLks1av5rXOxbGyA7azO6kUKjyrAs3s8MCjEOEg989BlU806dd
	 JDbPzifDdSDphe7WEutdRhHPbtkfZ21mczux14XIA/6d7eo1cA7aUkVu3LdZ9I6mV6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ZOxobCVw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9219860A3813
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 17:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ZOxobCVw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AEEA1F0180F;
	Tue, 24 Nov 2026 17:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795540214;
	bh=+vybS5VRcRZGiySAsp9Fr+sb5LIIu9nCYoiUue39U08=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=ZOxobCVwlAEb2kAs8RoIUEJSwiWVJaPEiudtKa1SQm7niYGGVdLRO3ry7XMz8sNmM
	 3VsdAoYgiMbXIw7QNJ7inpR8FK2OjrNvr2mj3jszOt0D+70/fo+9oyP1REZx2Od0SA
	 0YHtpD+wO5jWctU1hu92vTtRa2lcNCRKPiSVspOk=
Date: Tue, 24 Nov 2026 09:10:13 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,
	rdunlap@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124160124.93482-5-sj@kernel.org>
References: <20261124160124.93482-5-sj@kernel.org>
Subject: + docs-mm-damon-maintainer-profile-update-key-cycle-dates-for-damongit.patch added to mm-unstable branch
Message-Id: <20261124171014.2AEEA1F0180F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Docs/mm/damon/maintainer-profile: update key cycle dates for damon.git
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-maintainer-profile-update-key-cycle-dates-for-damongit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-maintainer-profile-update-key-cycle-dates-for-damongit.patch

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
Subject: Docs/mm/damon/maintainer-profile: update key cycle dates for damon.git
Date: Tue, 24 Nov 2026 08:01:22 -0800

Right after 7.5-rc1, DAMON will onboard the mm-next transition [1].  It
will make a few changes to the expected timeline for patches.  Update
'key cycle dates' to align with the changes.

Link: https://patch.msgid.link/20261124160124.93482-5-sj@kernel.org
Link: https://lore.kernel.org/bed81e01-7303-4957-bd7d-38e3a094e96f@kernel.org/ [1]
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: David Hildenbrand <david@kernel.org>

 Documentation/mm/damon/maintainer-profile.rst |   24 ++++++++++++----
 1 file changed, 19 insertions(+), 5 deletions(-)

--- a/Documentation/mm/damon/maintainer-profile.rst~docs-mm-damon-maintainer-profile-update-key-cycle-dates-for-damongit
+++ a/Documentation/mm/damon/maintainer-profile.rst
@@ -41,11 +41,25 @@ Further doing below and putting the resu
 Key cycle dates
 ---------------
 
-Patches can be sent anytime.  Key cycle dates of the `mm-new
-<https://git.kernel.org/akpm/mm/h/mm-new>`_, `mm-unstable
-<https://git.kernel.org/akpm/mm/h/mm-unstable>`_ and `mm-stable
-<https://git.kernel.org/akpm/mm/h/mm-stable>`_ trees depend on the memory
-management subsystem maintainer.
+Patches can be sent to and reviewed on the mailing lists anytime.
+
+Patches that are sufficiently reviewed will be merged into damon.git
+``for-next`` or ``for-next-fixes`` trees.  The destination tree is decided
+based on the urgency of the patches.  Non-urgent patches are merged into
+``for-next``.  Urgent patches are merged into ``for-next-fixes``.  Being merged
+into damon.git is only for additional review and testing.  All patches in
+damon.git can be reviewed, modified and dropped at any time.
+
+Patches in ``for-next-fixes`` tree stay there for at least one week, for
+additional review and testing.  After that, those would be pull-requested to
+the mainline.
+
+Patches in ``for-next`` tree stay there at least two weeks, for additional
+review and testing.  After that, those would be pull-requested to the mainline,
+in the next merge window.
+
+``for-next`` tree is closed for new patches from -rc6 release to next -rc1
+release.
 
 Review cadence
 --------------
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

