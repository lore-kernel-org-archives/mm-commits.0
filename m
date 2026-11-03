Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793668697;
	b=cdWQeqR175Dnapp8wig5wUj88SyPH5xK/Yqaz87zZI9q1UgBwidcFggnrWjwIdO+6GMX
	 FhFWr6+Pmgs8VPezxvpYQZ84a7b8gVhBVQxbaFZz/byASRWq92iHWqBXcDgmJGBxAlTxf
	 yxlmdxWNFGNZJWoWJ6T750LFRBl9ipGu577qWpyqElmd5jcfk4xPW9N0nB7lM65LjOwpx
	 qWpWMS4HFAcIu96Usgng8vztc7rnigxAZ6LzcWJfAYy1IQ2x5KNtg8VCmd5dfVK/ws4z4
	 GNpX8Kgd5Zz0tJjMQHyYWi9gFhtKSk1y1tGzPTeGryZT3f8891B6PhkwrofteMnml6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793668697;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Q68aMWqPm/ah49wjaM0eMF/lE//xYsSl2boipRkdKtU=;
	b=OPFsT2y53CCRwewLjMkKcRTOWcWP+L/8tQfXnZaKckt3fwSDaB3MpzWUDaGtJK/RpajW
	 zS4vsGL1i6JfC8iVqYfpJla1dF+A8O/zBNLXjSN720s5H1RQZEgVrZOnKIkK+Rb8zb0g+
	 DS/75OIbHgwRWP7WtRZ2LA4If6fqNMOkl+vNThrP9v7t1YkMeGgimMS14Eaw4baoe1yDR
	 t0a0G2XweeNAEnm3lFnFxmBVvw5KuCd1gTHX4508KRkHkSdoLF31LSskQdHGGUC5Mt27M
	 8c3Is1aZZTEJKC2Jq7atd50zWGoB+IidVU44INZvtelDtucAQQFohlyWoHq/uIh2XHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=A5bbX9aK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3112606A33D
	for <mm-commits@vger.kernel.org>; Tue,  3 Nov 2026 01:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=A5bbX9aK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE97E1F000C1;
	Tue,  3 Nov 2026 01:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793668696;
	bh=Q68aMWqPm/ah49wjaM0eMF/lE//xYsSl2boipRkdKtU=;
	h=Date:To:From:Subject;
	b=A5bbX9aKOH91SDlk/Aw3brdeNKk4Pee9Ya/eMG8bfQtZjWcAbtNXyfHso7eHklXp9
	 q2CFskpItRJSjBLaV8CyFH5N1iUu7FxIkdVCR0bFlnHgndve48EgxE6O9tG8vETQCd
	 8ZeaE2h2yePEMHYEyR8wI1BNxKPZFe10FwZg9rX0=
Date: Mon, 02 Nov 2026 17:18:16 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,sj@kernel.org,
	rdunlap@infradead.org,manuelebnerli@mailbox.org,corbet@lwn.net,
	jm5905938@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-api-fix-verb-form.patch added to mm-new branch
Message-Id: <20261103011816.BE97E1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Docs/mm/damon/api: fix verb form
has been added to the -mm mm-new branch.  Its filename is
     docs-mm-damon-api-fix-verb-form.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-api-fix-verb-form.patch

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
Subject: Docs/mm/damon/api: fix verb form
Date: Mon, 02 Nov 2026 16:59:36 -0800

It should be "All you need to do is include", not "including".

Link: https://lore.kernel.org/20261103005940.91432-7-sj@kernel.org
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Manuel Ebner <manuelebnerli@mailbox.org>
---

 Documentation/mm/damon/api.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/mm/damon/api.rst~docs-mm-damon-api-fix-verb-form
+++ a/Documentation/mm/damon/api.rst
@@ -5,7 +5,7 @@ API Reference
 =============
 
 Kernel space programs can use every feature of DAMON using below APIs.  All you
-need to do is including ``damon.h``, which is located in ``include/linux/`` of
+need to do is include ``damon.h``, which is located in ``include/linux/`` of
 the source tree.
 
 Structures
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

