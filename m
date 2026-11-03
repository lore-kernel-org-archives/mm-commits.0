Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793668701;
	b=G/G/mmEgpSKpwq6ImzV2W2Z/X66+EAqKi64NRH0+NezGnDYZfmyRs+ShWp1i/1nbbvQm
	 +2Kai2L0Kf98OZoM/2l75hBBlY9E2KKHcDi6x8iDYReDlQNpmGL0C9rdTeVFNWm+iR7F/
	 5Kh40vQHo0dRosnFABsQVO3fjLsvN/HC9MHllLEAMH4sARXFAsaN7+Ize9MWPkRB8O/W6
	 VwOb776D/ZPimBkMZh0mAK79VtyeC/nrbNPBYbTlCLLtL4+ysm191a08505GpQrNbuDrc
	 gzGhAN1XMSOz/kcbtsY1VGOgPgDHXgbPkmzXnDDYlZLuD+Sn9hPomzf0kR+9P/tCB8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793668701;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=jkCjSvVgMhpE5JJ9kYqBP5/4uQXVGP5c+RkkzWH8NoM=;
	b=3HM+lo5xxyUER4GALwMbfvsxLv3a7eu5yBon6S9PX2UcQcNzgWU1xhwG5tb8i6/IU1BB
	 hTD/zQYQelF9P7qsX6cG1oUNVUtQoESds7TFk0ATdsCTMpWl8pXC9JxQeb6OU0/dFQFbL
	 Zskj6i8rheeaChveFJqVGgjL8xQbVy9gaiM4gyJ/R9Yc1iZ6cbv/K/6XrQRA6611cn7pA
	 /jkMFJC2lwTeVBSpaPXQVFicBA8xq5lwx8UjRvbgL1fai19apmf60IAuXig6kdR4Yx9Kv
	 rKm4aRKKLaIQtrVN+VqiIklDXvIgMxmcXo4N+uBoWMyN7CgiXfcCK1/yGQL9A0lNang==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=YaRP5K7q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F8A606A32E
	for <mm-commits@vger.kernel.org>; Tue,  3 Nov 2026 01:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=YaRP5K7q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5946F1F000C1;
	Tue,  3 Nov 2026 01:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793668700;
	bh=jkCjSvVgMhpE5JJ9kYqBP5/4uQXVGP5c+RkkzWH8NoM=;
	h=Date:To:From:Subject;
	b=YaRP5K7qlM32ImW5bqD1ZYO6Tw1TGyJbtfizxl2fFufAOZJ5VQ2CYGCBu8QJEHV1S
	 BkwO9JfhLyON9WlgI1odUUHmsOSw+1S9bRXPa/cQyHq0A0u0ywGXPTX+SoaGT9N0ut
	 S6H37t7y40kwsTCn9e1ikILXoBRIDoTILc1A3pKs=
Date: Mon, 02 Nov 2026 17:18:19 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,sj@kernel.org,
	rdunlap@infradead.org,manuelebnerli@mailbox.org,corbet@lwn.net,
	jm5905938@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-monitoring_intervals_tuning_example-fix-grammar-and-typos.patch added to mm-new branch
Message-Id: <20261103011820.5946F1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Docs/mm/damon/monitoring_intervals_tuning_example: fix grammar and typos
has been added to the -mm mm-new branch.  Its filename is
     docs-mm-damon-monitoring_intervals_tuning_example-fix-grammar-and-typos.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-monitoring_intervals_tuning_example-fix-grammar-and-typos.patch

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
Subject: Docs/mm/damon/monitoring_intervals_tuning_example: fix grammar and typos
Date: Mon, 02 Nov 2026 16:59:38 -0800

Fix a few typos, including "Moniting" in the title, and some grammar in
the interval tuning example.

"starts looking degrading" should be "start looking degraded for", as I
think the sentence means the cold region detection starts to look worse.
Rewrap where the lines got too long.

Link: https://lore.kernel.org/20261103005940.91432-9-sj@kernel.org
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Manuel Ebner <manuelebnerli@mailbox.org>
---

 Documentation/mm/damon/monitoring_intervals_tuning_example.rst |   28 +++++-----
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/Documentation/mm/damon/monitoring_intervals_tuning_example.rst~docs-mm-damon-monitoring_intervals_tuning_example-fix-grammar-and-typos
+++ a/Documentation/mm/damon/monitoring_intervals_tuning_example.rst
@@ -1,8 +1,8 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-=================================================
-DAMON Moniting Interval Parameters Tuning Example
-=================================================
+===================================================
+DAMON Monitoring Interval Parameters Tuning Example
+===================================================
 
 DAMON's monitoring parameters need tuning based on given workload and the
 monitoring purpose.  There is a :ref:`tuning guide
@@ -38,7 +38,7 @@ access-hotness of a region.  It is calcu
 frequency and the age of the region.  If the access frequency is 0 %, the
 temperature is multiplied by minus one.  That is, if a region is not accessed,
 it gets minus temperature and it gets lower as not accessed for longer time.
-The sorting is in temperature-ascendint order, so the region at the top of the
+The sorting is in temperature-ascending order, so the region at the top of the
 list is the coldest, and the one at the bottom is the hottest one. ::
 
     # damo report access --sort_regions_by temperature
@@ -56,7 +56,7 @@ list is the coldest, and the one at the
     total size: 62.000 GiB
 
 The list shows not seemingly hot regions, and only minimum access pattern
-diversity.  Every region has zero access frequency.  The number of region is
+diversity.  Every region has zero access frequency.  The number of regions is
 10, which is the default ``min_nr_regions value``.  Size of each region is also
 nearly identical.  We can suspect this is because “adaptive regions adjustment”
 mechanism was not well working.  As the guide suggested, we can get relative
@@ -91,7 +91,7 @@ aggregation interval.
 100ms/2s intervals: Starts Showing Small Hot Regions
 ====================================================
 
-Following the guide, increase the interval 20 times (100 milliseocnds and 2
+Following the guide, increase the interval 20 times (100 milliseconds and 2
 seconds for sampling and aggregation intervals, respectively). ::
 
     # damo start -s 100ms -a 2s
@@ -129,17 +129,17 @@ seconds for sampling and aggregation int
     [50,400,010,000, 59,720,011,000)   4.000 KiB  |*                   |
     total size: 62.000 GiB
 
-DAMON found two distinct 4 KiB regions that pretty hot.  The regions are also
-well aged.  The hottest 4 KiB region was keeping the access frequency for about
-8 minutes, and the coldest region was keeping no access for about 7 minutes.
-The distribution on the histogram also looks like having a pattern.
+DAMON found two distinct 4 KiB regions that are pretty hot.  The regions are
+also well aged.  The hottest 4 KiB region was keeping the access frequency for
+about 8 minutes, and the coldest region was keeping no access for about 7
+minutes.  The distribution on the histogram also looks like having a pattern.
 
 Especially, the finding of the 4 KiB regions among the 62 GiB total memory
 shows DAMON’s adaptive regions adjustment is working as designed.
 
 Still the number of regions is close to the ``min_nr_regions``, and sizes of
 cold regions are similar, though.  Apparently it is improved, but it still has
-rooms to improve.
+room to improve.
 
 400ms/8s intervals: Pretty Improved Results
 ===========================================
@@ -196,8 +196,8 @@ good enough to make some meaningful memo
 =================================
 
 Further double the intervals (800 milliseconds and 16 seconds for sampling
-and aggregation intervals, respectively).  The results is more improved for the
-hot regions detection, but starts looking degrading cold regions detection. ::
+and aggregation intervals, respectively).  The results are more improved for the
+hot regions detection, but start looking degraded for cold regions detection. ::
 
     # damo start -s 800ms -a 16s
     # sleep 600
@@ -243,5 +243,5 @@ Conclusion
 ==========
 
 With the above experimental tuning results, we can conclude the theory and the
-guide makes sense to at least this workload, and could be applied to similar
+guide make sense to at least this workload, and could be applied to similar
 cases.
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

