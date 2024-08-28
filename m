Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C6615E96
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 01:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724808456; cv=none; b=nLX43DZ4maKinOGgXGWClTRJFj9XroUGXR5vUjRtEKUiMx/f+0/ZIj4zjuP6AsTYggKoqbotq1X0vFA4EviqBeSL+qUpzedRTecQD53OFo5cmwtr93neABuzQV4SyoIRhROOcz1owtGuDl2HoJXdDWAXOpSDtXYDV1dJCA99Ais=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724808456; c=relaxed/simple;
	bh=VR0r4GlEXzEucUv3QhxLkCOwMdRUl3+Rg7yvSXVF2kQ=;
	h=Date:To:From:Subject:Message-Id; b=YjkbwMnuvFHQ7X3gfSiC+howL8dEATFJUeGNiOL6F1ES7llDWlpwr+/kLgpMZXXjhit4izsCCybqwbv3er7fX16evCTBwSpjuj81OsrDiCOXpkED0QNYx6u05kQOHJOMcMFVJeLpYjnZSghBMbFFTtVDzLUIV+58ejFCOJYJtVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FHEGM+g7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FHEGM+g7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3BFC32782;
	Wed, 28 Aug 2024 01:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724808456;
	bh=VR0r4GlEXzEucUv3QhxLkCOwMdRUl3+Rg7yvSXVF2kQ=;
	h=Date:To:From:Subject:From;
	b=FHEGM+g7pR0Nmj+q2iYM+9xfkMVZjXeflw/HtzfLQ6q+fn2vQ89Wp0FUWYeWPU2v5
	 CviAbF3+v1fZ1iFLk+E/soPA4No3LcamSangDvWxTlzEinSf6e9+NBmrFfmzGxL1PK
	 xTjwbv/HieDCaKZvXhn7W/eJh1tG/16FeriElogg=
Date: Tue, 27 Aug 2024 18:27:35 -0700
To: mm-commits@vger.kernel.org,siyanteng@loongson.cn,corbet@lwn.net,alexs@kernel.org,2023002089@link.tyut.edu.cn,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-damon-maintainer-profile-document-google-calendar-for-bi-weekly-meetups.patch added to mm-unstable branch
Message-Id: <20240828012736.3D3BFC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/damon/maintainer-profile: document Google calendar for bi-weekly meetups
has been added to the -mm mm-unstable branch.  Its filename is
     docs-damon-maintainer-profile-document-google-calendar-for-bi-weekly-meetups.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-damon-maintainer-profile-document-google-calendar-for-bi-weekly-meetups.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/damon/maintainer-profile: document Google calendar for bi-weekly meetups
Date: Sun, 25 Aug 2024 18:57:41 -0700

We added a public Google calendar for easy sharing of DAMON bi-weekly
meetups[1].  Add it to the official document for a better visibility.

[1] https://lore.kernel.org/all/20240717235812.53087-1-sj@kernel.org/

Link: https://lkml.kernel.org/r/20240826015741.80707-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Alex Shi <alexs@kernel.org>
Cc: Hu Haowen <2023002089@link.tyut.edu.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Yanteng Si <siyanteng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/maintainer-profile.rst |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/Documentation/mm/damon/maintainer-profile.rst~docs-damon-maintainer-profile-document-google-calendar-for-bi-weekly-meetups
+++ a/Documentation/mm/damon/maintainer-profile.rst
@@ -99,5 +99,7 @@ time slot, by reaching out to the mainta
 
 Schedules and available reservation time slots are available at the Google `doc
 <https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing>`.
-DAMON maintainer will also provide periodic reminder to the mailing list
-(damon@lists.linux.dev).
+There is also a public Google `calendar
+<https://calendar.google.com/calendar/u/0?cid=ZDIwOTA4YTMxNjc2MDQ3NTIyMmUzYTM5ZmQyM2U4NDA0ZGIwZjBiYmJlZGQxNDM0MmY4ZTRjOTE0NjdhZDRiY0Bncm91cC5jYWxlbmRhci5nb29nbGUuY29t>`
+that has the events.  Anyone can subscribe it.  DAMON maintainer will also
+provide periodic reminder to the mailing list (damon@lists.linux.dev).
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-add-access_memory_even-to-gitignore.patch
selftests-damon-cleanup-__pycache__-with-make-clean.patch
selftests-damon-add-execute-permissions-to-test-scripts.patch
mm-damon-core-test-test-only-vaddr-case-on-ops-registration-test.patch
mm-damon-core-test-fix-damon_test_ops_registration-for-damon_vaddr-unset-case.patch
mm-damon-dbgfs-test-skip-dbgfs_set_targets-test-if-paddr-is-not-registered.patch
mm-damon-dbgfs-test-skip-dbgfs_set_init_regions-test-if-paddr-is-not-registered.patch
mm-damon-move-kunit-tests-to-tests-subdirectory-with-_kunit-suffix.patch
mm-damon-tests-add-kunitconfig-file-for-damon-kunit-tests.patch
mm-damon-core-intorduce-per-context-region-priorities-histogram-buffer.patch
mm-damon-core-replace-per-quota-regions-priority-histogram-buffer-usage-with-per-context-one.patch
mm-damon-core-remove-per-scheme-region-priority-histogram-buffer.patch
revert-mm-damon-lru_sort-adjust-local-variable-to-dynamic-allocation.patch
docs-damon-use-damonitor-github-organization-instead-of-awslabs.patch
docs-damon-maintainer-profile-add-links-in-place.patch
docs-damon-maintainer-profile-document-google-calendar-for-bi-weekly-meetups.patch

