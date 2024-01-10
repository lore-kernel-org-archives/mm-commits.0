Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C018B3C2F
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 05:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aKb9BQLw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C36C433F1;
	Wed, 10 Jan 2024 05:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704865078;
	bh=a/BXtvns21WWETCSnNxgicAruJn97q2aMKr0ebQ/5r4=;
	h=Date:To:From:Subject:From;
	b=aKb9BQLwFGDyinKbQNAyfRAp2Csk5VNHmjeMzC8Pn9maXqg1VJkEoGNwsu50scP3T
	 Kl/LHBFcf/KrMTWaBxDfjvYtypqEK2XQZuW66+RH0tJSCBDIZzuzJ6bsdjbd2nkU+d
	 6b5qHNbR27zJfsw1s9pRWwf89B5Vr11t8gHEf0fc=
Date: Tue, 09 Jan 2024 21:37:57 -0800
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-win_minmax-fix-header-comments.patch added to mm-nonmm-unstable branch
Message-Id: <20240110053758.39C36C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/win_minmax: fix header comments
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-win_minmax-fix-header-comments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-win_minmax-fix-header-comments.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Randy Dunlap <rdunlap@infradead.org>
Subject: lib/win_minmax: fix header comments
Date: Sun, 7 Jan 2024 14:01:55 -0800

Don't use "/**" kernel-doc comment marker for non-kernel-doc
comment.

Correct the filename but omit the path since we know where it is
and it could change (but not likely).

Link: https://lkml.kernel.org/r/20240107220155.29013-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/win_minmax.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/win_minmax.h~lib-win_minmax-fix-header-comments
+++ a/include/linux/win_minmax.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/**
- * lib/minmax.c: windowed min/max tracker by Kathleen Nichols.
+/*
+ * win_minmax.h: windowed min/max tracker by Kathleen Nichols.
  *
  */
 #ifndef MINMAX_H
_

Patches currently in -mm which might be from rdunlap@infradead.org are

lib-win_minmax-fix-header-comments.patch

