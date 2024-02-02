Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9726613E235
	for <mm-commits@vger.kernel.org>; Fri,  2 Feb 2024 12:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706875975; cv=none; b=Ah360oE53JFS8oKdBAqYSMuBj60AQe73DL2s2FVqoP0ORybiXyd4yD+lu+HryCFRQCbET/aSLfzoxEl6+8BzeURu5GIOHaTlHO2nZYmvnKJldfT6Trk9MNDVW+ZwdiylWC+YROwr6CVjXFjUEeGdg8KjH1FKBj+K7mV+WxjwWIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706875975; c=relaxed/simple;
	bh=JYyi+BpZWTqcGvKI4XNEr2IR9mosItxeNUpz8XoQnwg=;
	h=Date:To:From:Subject:Message-Id; b=rCAk10mVUcxt3RS8s7ajTd2PXIvmgc/RuwviKYFQp0M0bFInm+jNmyfWIPamG5XU3WT3IEi3M/0OfgLOFTQzntFTHTBaMPjd7M7vQ/utNZHgRRt7i8xU1WQFZgIHtfPmUPMMJiWv5RPOnA2K9pug9Enb3rbyhbZXL/+Zaze3ADc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H1q1m1Vl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H1q1m1Vl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FDB5C433C7;
	Fri,  2 Feb 2024 12:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706875975;
	bh=JYyi+BpZWTqcGvKI4XNEr2IR9mosItxeNUpz8XoQnwg=;
	h=Date:To:From:Subject:From;
	b=H1q1m1Vlc1c58/6UZfOIvoOsXdIjGQ1gFdFo4/jelVSk5uunDYozQu8LcLsE01TJS
	 uOM0695lEzZVFiWDLEyijTxqOCLpyDoyW4be8LSb62gsPSDWrVoLHe1KThhrI3NRHV
	 8ahe+FpWU5r/eYO0Pw/fLyabynYOp9Ars4/dYB6w=
Date: Fri, 02 Feb 2024 04:12:53 -0800
To: mm-commits@vger.kernel.org,namhyung@kernel.org,mike.leach@linaro.org,james.clark@arm.com,irogers@google.com,acme@kernel.org,leo.yan@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-my-email-address.patch added to mm-hotfixes-unstable branch
Message-Id: <20240202121255.0FDB5C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: Leo Yan has moved
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-update-my-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-my-email-address.patch

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
From: Leo Yan <leo.yan@linux.dev>
Subject: MAINTAINERS: Leo Yan has moved
Date: Thu, 1 Feb 2024 10:10:08 +0800

I will lose access to my @linaro.org email address next week, update the
MAINTAINERS file and map it in .mailmap with the new email address.

Link: https://lkml.kernel.org/r/20240201021022.886-1-leo.yan@linux.dev
Signed-off-by: Leo Yan <leo.yan@linux.dev>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Cc: James Clark <james.clark@arm.com>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/.mailmap~maintainers-update-my-email-address
+++ a/.mailmap
@@ -345,6 +345,7 @@ Leonid I Ananiev <leonid.i.ananiev@intel
 Leon Romanovsky <leon@kernel.org> <leon@leon.nu>
 Leon Romanovsky <leon@kernel.org> <leonro@mellanox.com>
 Leon Romanovsky <leon@kernel.org> <leonro@nvidia.com>
+Leo Yan <leo.yan@linux.dev> <leo.yan@linaro.org>
 Liam Mark <quic_lmark@quicinc.com> <lmark@codeaurora.org>
 Linas Vepstas <linas@austin.ibm.com>
 Linus Lüssing <linus.luessing@c0d3.blue> <linus.luessing@ascom.ch>
--- a/MAINTAINERS~maintainers-update-my-email-address
+++ a/MAINTAINERS
@@ -17180,7 +17180,7 @@ R:	John Garry <john.g.garry@oracle.com>
 R:	Will Deacon <will@kernel.org>
 R:	James Clark <james.clark@arm.com>
 R:	Mike Leach <mike.leach@linaro.org>
-R:	Leo Yan <leo.yan@linaro.org>
+R:	Leo Yan <leo.yan@linux.dev>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
 F:	tools/build/feature/test-libopencsd.c
_

Patches currently in -mm which might be from leo.yan@linux.dev are

maintainers-update-my-email-address.patch

