Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793668690;
	b=ZB/2JtFBtQpBQNoP0p2a55TKBzSQAEZbPV8tYEsulAoME1oEFy3yc84S1hX42Oly/f5q
	 tH+BHle6HcyTXM+chvOrkTUuSbUe9kZXyUP6dXhLiW9hpR5PDu8xwHYX09q7Ga6F8mr2H
	 EwLXZiqU1SCYQBSxHxU3ibqm9PvIVuSJ57dn+Bb6nWpd58y8HZudujs6YHXuyX/MVx8I4
	 JPZNl0Ipehgbj2yw405ohzF4Jtq+StqBvdEX6xAI2Wt7av4nLfiMlO1YmfcBVdrDopYeG
	 VuwloUYt/+Ra36pYHRfssOCmep1oIXdJgzR59ZrjJspSA8fncXdmR6CQYlP4WbbOMBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793668690;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=O11K+KUiqeqwrPGH1G4d0AbEXyg2fXehoMNkc6Z7uzI=;
	b=p33uZPlRHMujMqlVKFTDdq6GmoOnrjYsWtIvHYrnqI1jics5MqTg0Q93kXKxCv1vBEtl
	 1ZLfn5X2NEVvdlyKZO8sWpJ2Jltz4cjEnce5kxiUqb/8bAtXlbP//nDi30O4W1muS/jt5
	 8NYiu2Y7EfCxRrYxjY3+Z6/qlQRy9WCrnbPzDb0K2r+hkGA13gJaCUU6H2RjQR4T2JibL
	 ZMIA01E5wctomu9aCbJbEUchNKx+jbpJ+/kzCKPZ44kdWZPukvMdi8qBsFsE7JoyasbT5
	 C9I6rXlNVpiHh7NOIJsr3rNmBX6Nr/49wHFT0/wolMVvdo2b0AY7xJvGG1UvUeiP0Pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="Tl6U/Ohk";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF785606A327
	for <mm-commits@vger.kernel.org>; Tue,  3 Nov 2026 01:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Tl6U/Ohk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6722B1F000C1;
	Tue,  3 Nov 2026 01:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793668689;
	bh=O11K+KUiqeqwrPGH1G4d0AbEXyg2fXehoMNkc6Z7uzI=;
	h=Date:To:From:Subject;
	b=Tl6U/Ohk0BRyxuvPpKe3RUjjQ7Q/gFUimmVPWZ/nw4LcPaJenjPVAa8BIXJ6anhEy
	 ftW4KkmPXC33AYlZ+q0BBGQRC6lvI1isg2VtTpNurmp2sVFYGNRslyk0K6+byD5F17
	 2hh5INd2uc32LD8ESz6T8jRlgWCnHZxb9DbEXy+A=
Date: Mon, 02 Nov 2026 17:18:09 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,sj@kernel.org,
	rdunlap@infradead.org,manuelebnerli@mailbox.org,corbet@lwn.net,
	jm5905938@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-stat-fix-pronoun-agreement.patch added to mm-new branch
Message-Id: <20261103011809.6722B1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Docs/admin-guide/mm/damon/stat: fix pronoun agreement
has been added to the -mm mm-new branch.  Its filename is
     docs-admin-guide-mm-damon-stat-fix-pronoun-agreement.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-stat-fix-pronoun-agreement.patch

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
Subject: Docs/admin-guide/mm/damon/stat: fix pronoun agreement
Date: Mon, 02 Nov 2026 16:59:32 -0800

"converts it" refers to the access events, so I think it should be
"them".  Rewrap the paragraph while at it.

Link: https://lore.kernel.org/20261103005940.91432-3-sj@kernel.org
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Manuel Ebner <manuelebnerli@mailbox.org>
Reviewed-by: Manuel Ebner <manuelebnerli@mailbox.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
---

 Documentation/admin-guide/mm/damon/stat.rst |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/Documentation/admin-guide/mm/damon/stat.rst~docs-admin-guide-mm-damon-stat-fix-pronoun-agreement
+++ a/Documentation/admin-guide/mm/damon/stat.rst
@@ -41,8 +41,8 @@ enabled
 
 Enable or disable DAMON_STAT.
 
-You can enable DAMON_STAT by setting the value of this parameter as ``Y``.
-Setting it as ``N`` disables DAMON_STAT.  The default value is set by
+You can enable DAMON_STAT by setting the value of this parameter to ``Y``.
+Setting it to ``N`` disables DAMON_STAT.  The default value is set by
 ``CONFIG_DAMON_STAT_ENABLED_DEFAULT`` build config option.
 
 Note that this module (damon_stat) cannot run simultaneously with other
@@ -68,10 +68,10 @@ estimated_memory_bandwidth
 Estimated memory bandwidth consumption (bytes per second) of the system.
 
 DAMON_STAT reads observed access events on the current DAMON results snapshot
-and converts it to memory bandwidth consumption estimation in bytes per second.
-The resulting metric is exposed to user via this read-only parameter.  Because
-DAMON uses sampling, this is only an estimation of the access intensity rather
-than accurate memory bandwidth.
+and converts them to memory bandwidth consumption estimation in bytes per
+second.  The resulting metric is exposed to user via this read-only parameter.
+Because DAMON uses sampling, this is only an estimation of the access intensity
+rather than accurate memory bandwidth.
 
 memory_idle_ms_percentiles
 --------------------------
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

