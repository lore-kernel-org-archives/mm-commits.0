Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82AA936196A
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 03:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785898975; cv=none; b=EbR6jbooJPTPRJVkWKCz15mVRLuOKCKsg9tR6W+ue6cVqHhWugKpKZX/uI8TP1DEiujr9f9nubsrrbKyG9R+AGd9wnmwfWfzWbw6pPf9eDLuKAFicuo1ML3jLXJornZOI3jYhFdTTtjZnDzB0DXeMCQvkNn6v6EfEXRT3xcGyGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785898975; c=relaxed/simple;
	bh=zmRYb61VQeS97zXdhp90zTDE2QSpKlf7vjav3Tnv6Rg=;
	h=Date:To:From:Subject:Message-Id; b=bTcZqaFLu4mgBy8qLnlp9ODIIy5c4wjalztia8ElV+/mBF+i7/vmiF78Y7kabBD3XztxWsds9Rzaz0CUv2d9fbwuI/Bh398UjXkcriGwvGBqYz6iP3mxg4IZZr4Gz1TncJIpPr6fc7/w56tJFqZe+iIBSl3TKo77qSfnzQNjNnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VVCSVN2g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VVCSVN2g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA771F00A3A;
	Wed,  5 Aug 2026 03:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785898974;
	bh=+T8COCx1zkIZAgsATLLc1ZrPLsCoeFu92V7AtnagbA0=;
	h=Date:To:From:Subject;
	b=VVCSVN2gpoPeNrkcJCKVrEZSlrWQUeZMEWw8uNEps4EpGude5zehrkWRcb+ca+i7t
	 rX5HNJmsUY2OL0VQoa5ce6MI2O1T5m1ClPxBbvUv53msJ5FEQILhvs6UKDBlb6I/7n
	 hyhWvASCxx5/4ndEUO/zEpj41fYjFCcSckV5mIAc=
Date: Tue, 04 Aug 2026 20:02:53 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,brendan.jackman@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-update-address-for-brendan-jackman.patch removed from -mm tree
Message-Id: <20260805030254.4CA771F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: update address for Brendan Jackman
has been removed from the -mm tree.  Its filename was
     maintainers-update-address-for-brendan-jackman.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Jackman <brendan.jackman@linux.dev>
Subject: MAINTAINERS: update address for Brendan Jackman
Date: Wed, 29 Jul 2026 12:01:48 +0000

Switch my entry in MAINTAINERS and .mailmap to my @linux.dev email address

Link: https://lore.kernel.org/20260729-email-change-v1-1-666ae7c2b7fc@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Signed-off-by: Brendan Jackman <brendan.jackman@linux.dev>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/.mailmap~maintainers-update-address-for-brendan-jackman
+++ a/.mailmap
@@ -170,6 +170,7 @@ Boris Brezillon <bbrezillon@kernel.org>
 Boris Brezillon <bbrezillon@kernel.org> <boris.brezillon@bootlin.com>
 Boris Brezillon <bbrezillon@kernel.org> <boris.brezillon@free-electrons.com>
 Brendan Higgins <brendan.higgins@linux.dev> <brendanhiggins@google.com>
+Brendan Jackman <brendan.jackman@linux.dev> <jackmanb@google.com>
 Brian Avery <b.avery@hp.com>
 Brian Cain <bcain@kernel.org> <brian.cain@oss.qualcomm.com>
 Brian Cain <bcain@kernel.org> <bcain@quicinc.com>
--- a/MAINTAINERS~maintainers-update-address-for-brendan-jackman
+++ a/MAINTAINERS
@@ -17160,7 +17160,7 @@ M:	Andrew Morton <akpm@linux-foundation.
 M:	Vlastimil Babka <vbabka@kernel.org>
 R:	Suren Baghdasaryan <surenb@google.com>
 R:	Michal Hocko <mhocko@suse.com>
-R:	Brendan Jackman <jackmanb@google.com>
+R:	Brendan Jackman <brendan.jackman@linux.dev>
 R:	Johannes Weiner <hannes@cmpxchg.org>
 R:	Zi Yan <ziy@nvidia.com>
 L:	linux-mm@kvack.org
_

Patches currently in -mm which might be from brendan.jackman@linux.dev are


