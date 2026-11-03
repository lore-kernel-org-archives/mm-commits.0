Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793668699;
	b=VCDqBN1E1r//AsM7OQXFdRN5vgUuxxpwD3GGDOjE8qHkEpqhTWB8MKZ4zHx19kl/NMYy
	 5yAhCej1VUveE6sMIiYRKmpLRgp02P47ng5QD5oH5bvn9sXOWRZ87ft2mRcfvyrWA89Y8
	 FharliBvAlRJmpxJ5nCz5DGaioK7pgEuQZ/TMpfiN6hQARX7KU1XC0ZAvVlIavmH1ibV/
	 Cp6w0LWU1hRxB15e0Yqfd+c5f7YeLlS70nU4pIVWqPIVCKLfzNh84L1MXheFqkc6b9p/x
	 dJ9WW0+pkBTvz0ZMBsNl/CDOAHQc5b609yH3MZCDgrADwqQ4eRQMxpRZBames7GPZGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793668699;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=IknChGHvyCqfMJpLDK2eXNgrFr/lSmYClOt2MdbAf8Y=;
	b=bHD9Ezt7cr3vYk5PWkzhnNoww2AIUehwj6Apok2fdu5VsRjqzFcRRD7GdiVTVM44++NT
	 TeM199uknyUD1QPWi2/zN/7Y0KwClaEWAtwBHmS7LmxVId0tMNRw48HfdKNm5uU+PcyF6
	 iSOrQioncM7W80xjecvxhntL18r8NFM3NcxJVZSVtG5ccbzAqgpeaXCbc4LrSEF2TXEKZ
	 U4thr81IIuV/MZkXf1bCzMluQE0YRYB4bZvDAngZfwrtloC/gnQcCpyrBcZLOQ91peMjj
	 BYgy/S4K1CrMTBF//SCpanuMScXOGZEEmbFCbDBHjYUX4NqiyZIK1Ubvpo6rh5Bd6pA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="Xp/oR/H4";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF2F606A32C
	for <mm-commits@vger.kernel.org>; Tue,  3 Nov 2026 01:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Xp/oR/H4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E9F1F000C1;
	Tue,  3 Nov 2026 01:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793668698;
	bh=IknChGHvyCqfMJpLDK2eXNgrFr/lSmYClOt2MdbAf8Y=;
	h=Date:To:From:Subject;
	b=Xp/oR/H4cNnqQCue5t52XCf7Tf8LmWeSezxyz0MLe7DXHLQOEaTFUxJSLjomv8zqp
	 bSbt3YsDKiFAcmdXbu3TUYLhWdDAomkhk9xeCZ9yvm6sklOkZvYlX39D85S3LKMPbE
	 CY9dOeyS1OjZwc4a/lYgiRWGx1cM2foHCz4LUagE=
Date: Mon, 02 Nov 2026 17:18:18 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,sj@kernel.org,
	rdunlap@infradead.org,manuelebnerli@mailbox.org,corbet@lwn.net,
	jm5905938@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-maintainer-profile-fix-subject-verb-agreement.patch added to mm-new branch
Message-Id: <20261103011818.92E9F1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Docs/mm/damon/maintainer-profile: fix subject-verb agreement
has been added to the -mm mm-new branch.  Its filename is
     docs-mm-damon-maintainer-profile-fix-subject-verb-agreement.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-maintainer-profile-fix-subject-verb-agreement.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Aveline Noir <jm5905938@gmail.com>
Subject: Docs/mm/damon/maintainer-profile: fix subject-verb agreement
Date: Mon, 02 Nov 2026 16:59:37 -0800

"The DAMON maintainer usually work" should be "works".

Link: https://lore.kernel.org/20261103005940.91432-8-sj@kernel.org
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Manuel Ebner <manuelebnerli@mailbox.org>
---

 Documentation/mm/damon/maintainer-profile.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/mm/damon/maintainer-profile.rst~docs-mm-damon-maintainer-profile-fix-subject-verb-agreement
+++ a/Documentation/mm/damon/maintainer-profile.rst
@@ -63,7 +63,7 @@ management subsystem maintainer.
 Review cadence
 --------------
 
-The DAMON maintainer usually work in a flexible way, except early morning in PT
+The DAMON maintainer usually works in a flexible way, except early morning in PT
 (Pacific Time).  The response to patches will occasionally be slow.  Do not
 hesitate to send a ping if you have not heard back within a week of sending a
 patch.
_

Patches currently in -mm which might be from jm5905938@gmail.com are

mm-damon-core-reset-watermark-wait-state-on-each-iteration.patch
mm-damon-ops-common-align-mmu-notifier-range-when-clearing-pmd-young-bit.patch
mm-damon-stat-avoid-32-bit-overflow-in-idle-percentiles.patch
mm-damon-pvaddr-skip-folios-already-on-the-migration-target-node.patch
docs-admin-guide-mm-damon-start-fix-grammar.patch
docs-admin-guide-mm-damon-stat-fix-pronoun-agreement.patch
docs-admin-guide-mm-damon-usage-fix-grammar.patch
docs-admin-guide-mm-damon-lru_sort-fix-remaining-grammar.patch
docs-mm-damon-design-fix-grammar-and-typos.patch
docs-mm-damon-api-fix-verb-form.patch
docs-mm-damon-maintainer-profile-fix-subject-verb-agreement.patch
docs-mm-damon-monitoring_intervals_tuning_example-fix-grammar-and-typos.patch

