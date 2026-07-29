Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F57D3D8902
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 22:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785365554; cv=none; b=HQphhCTmvM5YKGRblzZ6EP1NZGCqQOmmcTXTu2yooGT2NougPYzqrGuJ/iZzmTIGF5cP3fSovmdlWyrlRBzoCRaVZKOZSZmjFEYSfmq03TSHtjlzwpiQygEGmjlUsg1G4M4ZIT++AKKJPk0pwTU9J8mL/RRXZfCWbmokjbtd/vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785365554; c=relaxed/simple;
	bh=SxjU1BrivTjWmfFG73mbCIOH2hP4SV6JtWJx0Rxj6b8=;
	h=Date:To:From:Subject:Message-Id; b=YEhvG0lvhY49w1i/T5zjk7hdMO9YDuj/TsLHIoY5zwZucpPiTKmT++zTqi++SO+E2vXvOgszJCfaj6tNlt/v4F/11vs9qCLP+i8pZCUtxhPLIcvosaBPQUEmvftuedFYNnf41I75vYwHQDClOxSH79qkB39RYELDXcVluMrdWk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zK0EsO33; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zK0EsO33"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E521F000E9;
	Wed, 29 Jul 2026 22:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785365552;
	bh=z9y7Zai5GBul6sXnUkCSTZNz8na1YrBxokr5Je6HV9U=;
	h=Date:To:From:Subject;
	b=zK0EsO33HdIYo0KF07SH/J17y1HJAYcYQIOI7o4VQJI+x5ICP+ZxEPAh9UuhMwTor
	 FHWaNx0MhtgvxvFigCU6WiG6zIDXkva4rpNJsN54e3pr7RL8P9yX3+GS3k9IKslqJB
	 TjIHdHx8Mi3cpGhcfDGlFuOL4lfm8JgNxVcSIQ64=
Date: Wed, 29 Jul 2026 15:52:32 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,brendan.jackman@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-address-for-brendan-jackman.patch added to mm-hotfixes-unstable branch
Message-Id: <20260729225232.C9E521F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: update address for Brendan Jackman
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-update-address-for-brendan-jackman.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-address-for-brendan-jackman.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

maintainers-update-address-for-brendan-jackman.patch
mm-page_alloc-fix-non-movable-reclaim-storm-in-defrag_mode-fix.patch

