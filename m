Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3255B36A035
	for <mm-commits@vger.kernel.org>; Thu, 23 Apr 2026 12:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776947259; cv=none; b=YzGFyMzqOsv2xXXFvnT80Y8h73Kwmjm3KdFSY0gAVV72E/I3o/ArNV/Bl3QtCfPiMGZnrz2OrF10npVl1j+C+VmMjUYyZYNhaB7gRPc5pW0TbZcIrt/pGWdXvEzgWN+pIPlz4jUjuMe2fVTpJlbACmUc65Bk6AMZkObQ6q5IXz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776947259; c=relaxed/simple;
	bh=wq8ks5fIJkheQB8Y8YQGmphALYMFYfUFJrYSqtye42U=;
	h=Date:To:From:Subject:Message-Id; b=fHM/M2rS8XNPAkjiTnfa6/fWMM+T3SvbAWKy6fycpyZCeTz2diawY6nKRkWY2VYyv10fVhU+hq/a4SMePgWfjqQbsBf3RGtz4oV80c4zVYzSef+bwbxyR5ZVAcZA7TjwdhfXEzAb9BdT4MBi8p6l9PlFPflguLOllF6Nv4Fp5/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CsYur2KZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CsYur2KZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B785FC2BCAF;
	Thu, 23 Apr 2026 12:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776947258;
	bh=wq8ks5fIJkheQB8Y8YQGmphALYMFYfUFJrYSqtye42U=;
	h=Date:To:From:Subject:From;
	b=CsYur2KZwknwZY6VOFgYe+MuiY+mY46BJK6KDR3vdS2/ffQQn0R5ItWtfFMcgREhW
	 NUhxZpR7K1ZN1hQNBKdHXAXNTqoo4/16mDwbgaanP/3NhJHBgma9AW8U65pNBRb7Co
	 YeUPpzbvoNzK6gfz6yG1Gik62pkU6CxHut/JDRI8=
Date: Thu, 23 Apr 2026 05:27:38 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-mailmap-update-email-address-for-qi-zheng.patch added to mm-hotfixes-unstable branch
Message-Id: <20260423122738.B785FC2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS, mailmap: update email address for Qi Zheng
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-mailmap-update-email-address-for-qi-zheng.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-mailmap-update-email-address-for-qi-zheng.patch

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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: MAINTAINERS, mailmap: update email address for Qi Zheng
Date: Thu, 23 Apr 2026 15:16:28 +0800

Update my email address to qi.zheng@linux.dev.

Link: https://lore.kernel.org/20260423071628.44044-1-qi.zheng@linux.dev
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/.mailmap~maintainers-mailmap-update-email-address-for-qi-zheng
+++ a/.mailmap
@@ -687,6 +687,7 @@ Punit Agrawal <punitagrawal@gmail.com> <
 Puranjay Mohan <puranjay@kernel.org> <puranjay12@gmail.com>
 Qais Yousef <qyousef@layalina.io> <qais.yousef@imgtec.com>
 Qais Yousef <qyousef@layalina.io> <qais.yousef@arm.com>
+Qi Zheng <qi.zheng@linux.dev> <zhengqi.arch@bytedance.com>
 Quentin Monnet <qmo@kernel.org> <quentin.monnet@netronome.com>
 Quentin Monnet <qmo@kernel.org> <quentin@isovalent.com>
 Quentin Perret <qperret@qperret.net> <quentin.perret@arm.com>
--- a/MAINTAINERS~maintainers-mailmap-update-email-address-for-qi-zheng
+++ a/MAINTAINERS
@@ -16982,7 +16982,7 @@ M:	Andrew Morton <akpm@linux-foundation.
 M:	Johannes Weiner <hannes@cmpxchg.org>
 R:	David Hildenbrand <david@kernel.org>
 R:	Michal Hocko <mhocko@kernel.org>
-R:	Qi Zheng <zhengqi.arch@bytedance.com>
+R:	Qi Zheng <qi.zheng@linux.dev>
 R:	Shakeel Butt <shakeel.butt@linux.dev>
 R:	Lorenzo Stoakes <ljs@kernel.org>
 L:	linux-mm@kvack.org
@@ -24331,7 +24331,7 @@ F:	include/media/i2c/rj54n1cb0c.h
 SHRINKER
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Dave Chinner <david@fromorbit.com>
-R:	Qi Zheng <zhengqi.arch@bytedance.com>
+R:	Qi Zheng <qi.zheng@linux.dev>
 R:	Roman Gushchin <roman.gushchin@linux.dev>
 R:	Muchun Song <muchun.song@linux.dev>
 L:	linux-mm@kvack.org
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

maintainers-mailmap-update-email-address-for-qi-zheng.patch

