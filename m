Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793640348;
	b=t1rzvogzczuawRfoBfupAGDQofEIiWR+waC4iqAf4upz0DS4KW8+oPT8CfbbWCYKVGkQ
	 hHQnAuJh/LseEeaU9EaINZf+2vXU0jWuAhYt55F40tpLpzFigO+mSRMMzIcBCLuiZe2FU
	 IGhvCMxwShgbxvdpfYKoZYr63mXAtfM5m4OA9pYGLJZnhlEAB+EhYYUM3WwKHHzKnkySr
	 UTV+YUZVydI1g7UyNBi4uXSlOa+LKe25zBm1t4xru9+XGBNgtPZTJ2Q9SbFlKGzHKBYpP
	 t6shRhWebC4WejJ9pHqym9cYfh63usBFyP2GqTdH0Xy10Wqwtmupwc5G86W0yyv4mvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793640348;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=6u3mPeB7C7gaPneRpmXjwOK28suZdWcyKsP+wSJO7q0=;
	b=Y5cQhkIvUFtxtoxmuTzTvLPfoEkgGtGrG1Rtoa3Cvo7G1XAqgUBYMvik9E3L+azDgyJm
	 hROIZMCJJHAeQGvE6KIAPHs6HjDtDZK7Jh5yuqe1rYMgGAEl3pKZymEoc0yVC176vui01
	 QI2fGYCwrM6N4o+Cn43RpSXHa7B6baO0H29cAkL2KRuaxWUUKFr06x9HYq9eKtZjt5xf2
	 4o6Dr5/qzEEllDmRJnlQzaCZx0QQVlZ61Gd2ahzrjdUkd7fgL7H9OO97DplGSVA4SaMEi
	 Vp3EAUF3xzi12FAYDetI1+3qsh6d6upvCaQTq9vz/J/C/578Bt16fZ4RYsSqyGC6KDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=zw8FwGZi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B83606A329
	for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2026 17:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=zw8FwGZi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4BD1F00A1B;
	Mon,  2 Nov 2026 17:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793640348;
	bh=6u3mPeB7C7gaPneRpmXjwOK28suZdWcyKsP+wSJO7q0=;
	h=Date:To:From:Subject;
	b=zw8FwGZikurEeA0FHH2rqukFb3lxxZSMe7ASWZWHDxGbPzfMoKByxy6PuIIxT7S9B
	 aR0fLdCHPs485gDQ4iXa55a/5cNWqnss3WIxWOfJLPzvOARDYPeWvJdimvkTGUV8NK
	 RzPagtBuiKravaHT0qlnWfdZCeEwa81ywTIWlWgw=
Date: Mon, 02 Nov 2026 09:25:47 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,sj@kernel.org,
	rdunlap@infradead.org,corbet@lwn.net,adrianhuang0701@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-lru_sort-fix-copy-paste-mistakes.patch added to mm-new branch
Message-Id: <20261102172548.0E4BD1F00A1B@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Docs/admin-guide/mm/damon/lru_sort: fix copy-paste mistakes
has been added to the -mm mm-new branch.  Its filename is
     docs-admin-guide-mm-damon-lru_sort-fix-copy-paste-mistakes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-lru_sort-fix-copy-paste-mistakes.patch

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
From: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
Subject: Docs/admin-guide/mm/damon/lru_sort: fix copy-paste mistakes
Date: Mon, 02 Nov 2026 07:28:46 -0800

The DAMON_LRU_SORT documentation mistakenly refers to DAMON_RECLAIM
in a few places.

Fix these copy-paste mistakes to correctly refer to DAMON_LRU_SORT.

Link: https://lore.kernel.org/20261102152849.96057-3-sj@kernel.org
Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
---

 Documentation/admin-guide/mm/damon/lru_sort.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/mm/damon/lru_sort.rst~docs-admin-guide-mm-damon-lru_sort-fix-copy-paste-mistakes
+++ a/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -263,7 +263,7 @@ addr_unit
 A scale factor for memory addresses and bytes.
 
 This parameter is for setting and getting the :ref:`address unit
-<damon_design_addr_unit>` parameter of the DAMON instance for DAMON_RECLAIM.
+<damon_design_addr_unit>` parameter of the DAMON instance for DAMON_LRU_SORT.
 
 ``monitor_region_start`` and ``monitor_region_end`` should be provided in this
 unit.  For example, let's suppose ``addr_unit``, ``monitor_region_start`` and
@@ -346,7 +346,7 @@ memory regions that not accessed for 120
 deprioritization is limited to be done using only up to 1% CPU time to avoid
 DAMON_LRU_SORT consuming too much CPU time for the (de)prioritization.  It also
 asks DAMON_LRU_SORT to do nothing if the system's free memory rate is more than
-50%, but start the real works if it becomes lower than 40%.  If DAMON_RECLAIM
+50%, but start the real works if it becomes lower than 40%.  If DAMON_LRU_SORT
 doesn't make progress and therefore the free memory rate becomes lower than
 20%, it asks DAMON_LRU_SORT to do nothing again, so that we can fall back to
 the LRU-list based page granularity reclamation. ::
_

Patches currently in -mm which might be from adrianhuang0701@gmail.com are

mm-damon-core-remove-unnecessary-zero-initialization-in-damon_new_ctx.patch
docs-admin-guide-mm-damon-fix-various-typos.patch
docs-admin-guide-mm-damon-lru_sort-fix-copy-paste-mistakes.patch
docs-admin-guide-mm-damon-usage-fix-incorrect-option-syntax-in-perf-example.patch

