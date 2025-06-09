Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE11117C21C
	for <mm-commits@vger.kernel.org>; Mon,  9 Jun 2025 02:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749436031; cv=none; b=Y4al00ffCzBZARCqI4J4XG1zcuSxt5Q7+fKh3/oOPcGyhRL68ZRP6IPSbkiY049ep8ANSv+2sRtJHfH5sWgw+Utj8EM9QxmPedzMoDBkKDe7wUDvrz0ZYbnZHSqBjD2KMKT/ZBWAoWtGhKYDomw+j95TLIgTvTY+MP8I6nFf3YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749436031; c=relaxed/simple;
	bh=y9zMG7JnGSlmqgLXGf+NnQgybc+H2x+pskZcZRISGQ8=;
	h=Date:To:From:Subject:Message-Id; b=EhgZlDg1lQ2jfNYX6HfPctShjQLoBTRAEpaLeaSPBvP0xOVgTDXu+gupoYpvWBniR2BJUVIcfYyi4yEi709iTnPtobr8Kv3O0/+HJjB8LywUYz0qNf8s0/Nhvynqj8iw9HGiyicrhA/m57mhO9wYiyV6qes2AnWsAidMZFPVMoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YF61Ytqj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YF61Ytqj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE08C4CEEE;
	Mon,  9 Jun 2025 02:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749436030;
	bh=y9zMG7JnGSlmqgLXGf+NnQgybc+H2x+pskZcZRISGQ8=;
	h=Date:To:From:Subject:From;
	b=YF61YtqjWilbrhrl4haJuZNOQg70GfJ73kN/4dNiK89AKuugUr1t/wYyZI7wAEke4
	 u6mzPDU9FUzfVm5NxJx/m3KyTO4WJyt/TSrQ730c6Omen4wQ7rF+jX4gausQp1+kym
	 h3TYR8wBPnfI8GQZEctoQUlnKifbJJuv9a2BoBYQ=
Date: Sun, 08 Jun 2025 19:27:09 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-myself-as-a-thp-reviewer.patch added to mm-hotfixes-unstable branch
Message-Id: <20250609022710.5FE08C4CEEE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: Barry myself as a THP reviewer
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-myself-as-a-thp-reviewer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-myself-as-a-thp-reviewer.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Barry Song <baohua@kernel.org>
Subject: MAINTAINERS: Barry myself as a THP reviewer
Date: Mon, 9 Jun 2025 12:24:42 +1200

I have been actively contributing to mTHP and reviewing related patches
for an extended period, and I would like to continue supporting patch
reviews.

Link: https://lkml.kernel.org/r/20250609002442.1856-1-21cnbao@gmail.com
Signed-off-by: Barry Song <baohua@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-myself-as-a-thp-reviewer
+++ a/MAINTAINERS
@@ -15919,6 +15919,7 @@ R:	Liam R. Howlett <Liam.Howlett@oracle.
 R:	Nico Pache <npache@redhat.com>
 R:	Ryan Roberts <ryan.roberts@arm.com>
 R:	Dev Jain <dev.jain@arm.com>
+R:	Barry Song <baohua@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
_

Patches currently in -mm which might be from baohua@kernel.org are

maintainers-add-myself-as-a-thp-reviewer.patch

