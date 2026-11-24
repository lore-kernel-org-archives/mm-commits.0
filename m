Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795540209;
	b=qK6iJv9/SZKyp9XyGAKbW9oTC48EsoyMhFqx4zttQpCMC+F/oZmyOQaiagfUm9gJ9CNQ
	 x9uNrebMpzLGu6QssBBEDHvrjJ7HIaYHp+XVp9jYHqM5PEjYvDXEpyzXFUX4qcQbtZprS
	 Uwzf2uKPchfj8rz6TLmxp/+s3CLvDgv2Xqkv2o3WGT5qNLUvI0IMTodJAbwSSEl1z5wyP
	 cYl1Xb5lQgR0avSpjdnevwmzYO+T+mhy9BPkfcaW7bEl1bE2pZSif8W70X0M2039GaIHI
	 JKV7yOAcj5PQgdixuUFys7sfdaYGzoJQYavH1WQcmqkX+56KdNwPzYExdpZde8W26PQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795540209;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=KzoNp4oGUA84DB6N9p09SztALYj8nOCdy8KNIYA5www=;
	b=01oLJ5JDHHDngGiIg/7aYxfT9y/v4iqJURFCbaF38AjdP41FCYB9bcNd5AsMILi/TW79
	 pmKz1C8ANj0vmDVG2VPOY8ZTMOzwYSrEGT6taAHT7HJA8iO26Vc/Gq2+mGKdihfmHYhkO
	 MB3PLweVLD90A3Pn7hP6eKE3Ye1DKoN6VuCN0Hyq3PqERLBmJkPQU/gpoEPqjtb3WR5wM
	 HIUyZfsOOky9S0SyjsCLadlcOQLxyRLoS4dnzr1VIaLQbXiUXaFA1gk4MQz9eGc9mGlfc
	 DGCR5nZ2xRUw56JO7cKTNDfk1ic9VP5qjq947vOpHhObRevOxSJ0z+F7hoEGooUxzYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=NCIoSZy5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD4060A263F
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 17:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=NCIoSZy5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E021F000C4;
	Tue, 24 Nov 2026 17:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795540208;
	bh=KzoNp4oGUA84DB6N9p09SztALYj8nOCdy8KNIYA5www=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=NCIoSZy5v3l7jfWJt/uMNBpNEg91JLwylcLCQbW4wDQyUFgLZUwQ3iFz7xCX01xOs
	 /kSCJY2ceuWrmnMa6R4F+JRwRb8UGxuYaeC7XmhkUxpKjpJBAT8RtTMiB9xokeUVmC
	 0ZFE9jLS1AhMWHu7P+/3TjfWEG6VwJkPireFm3k0=
Date: Tue, 24 Nov 2026 09:10:08 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,
	rdunlap@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124160124.93482-3-sj@kernel.org>
References: <20261124160124.93482-3-sj@kernel.org>
Subject: + docs-mm-damon-maintainer-profile-use-damongit-for-patch-baselines.patch added to mm-unstable branch
Message-Id: <20261124171008.91E021F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Docs/mm/damon/maintainer-profile: use damon.git for patch baselines
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-maintainer-profile-use-damongit-for-patch-baselines.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-maintainer-profile-use-damongit-for-patch-baselines.patch

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
Subject: Docs/mm/damon/maintainer-profile: use damon.git for patch baselines
Date: Tue, 24 Nov 2026 08:01:20 -0800

Right after 7.5-rc1, DAMON will onboard the mm-next transition [1].
Update DAMON maintainer-profile document to suggest using damon.git [2]
for-next and for-next-fixes trees as baselines, following the mm-next
process guideline.  Together, update the DAMON section name to match
that on the MAINTAINERS file.

Link: https://patch.msgid.link/20261124160124.93482-3-sj@kernel.org
Link: https://lore.kernel.org/bed81e01-7303-4957-bd7d-38e3a094e96f@kernel.org/ [1]
Link: https://git.kernel.org/pub/scm/linux/kernel/git/mm/damon.git/ [2]
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: David Hildenbrand <david@kernel.org>

 Documentation/mm/damon/maintainer-profile.rst |   17 +++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/Documentation/mm/damon/maintainer-profile.rst~docs-mm-damon-maintainer-profile-use-damongit-for-patch-baselines
+++ a/Documentation/mm/damon/maintainer-profile.rst
@@ -3,13 +3,20 @@
 DAMON Maintainer Entry Profile
 ==============================
 
-The DAMON subsystem covers the files that are listed in 'DAMON' section of
-'MAINTAINERS' file.
+The DAMON subsystem covers the files that are listed in 'MEMORY MANAGEMENT -
+DAMON' section of 'MAINTAINERS' file.
 
 The mailing lists for the subsystem are damon@lists.linux.dev and
-linux-mm@kvack.org.  Patches should be made against the `mm-new tree
-<https://git.kernel.org/akpm/mm/h/mm-new>`_ whenever possible and posted to the
-mailing lists.
+linux-mm@kvack.org.
+
+Non-urgent patches should be made against the damon.git `for-next
+<https://git.kernel.org/mm/damon/h/for-next>`_ tree.  Urgent patches should be
+made against the damon.git `for-next-fixes
+<https://git.kernel.org/mm/damon/h/for-next-fixes>`_ tree.  If there is a
+reason to not use those branches as the baseline of the patch, please explain
+the reason and what baseline is used.
+
+Patches should be posted to the mailing lists whenever possible.
 
 SCM Trees
 ---------
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

