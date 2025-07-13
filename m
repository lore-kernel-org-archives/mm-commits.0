Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB4C1EF38E
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450046; cv=none; b=Jg9b+9W0SeYgXjIYF2xOg+ChDVa7OT97AfQLeB9Nn1qLAqq1e2zqBBrWbP3+y8NmowqId02LFniGNbmS+HIPktx5CFu34mgeCXOesc/ndlC7gFWvku7Bjy5UT5NQrhLwf5PqiPxL7ocsPFpqfUi1FhBCOgpzXhDyuzvMFpdBajU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450046; c=relaxed/simple;
	bh=sSS0ZN6SYeaHkSAijCQXXmty/3chvI9hwhqAO382a84=;
	h=Date:To:From:Subject:Message-Id; b=GjP3IYCbMLMxXUV9Ryti/KgeT53nxJX5/QmIWJQ2JCK+z8zQ4VSvA0REOxgTvXKdDhqpxKybuTsMQLF2TnO7ZaelMfT2m85CjHycDRpU1Rt4heoWBdywN8lQfD38xGayFX2NiDvLx5Q+rUQ0rnaqu841yhArZGTRzbGlgMJrLYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qnhNFz18; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qnhNFz18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5DC2C4CEE3;
	Sun, 13 Jul 2025 23:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450046;
	bh=sSS0ZN6SYeaHkSAijCQXXmty/3chvI9hwhqAO382a84=;
	h=Date:To:From:Subject:From;
	b=qnhNFz18bL1g5znagB+A80obHNFiF9uspMhsikqVcU0+ptrjgjy2o0dQj9kAKdYEz
	 BBAVmFpMVmQJHyWwGka2LKQUgovKuco4qqolMzwyh9DWPbrb5XvP9mMoArpHibZwln
	 lLmHmlE9OJde88I5FtWCRpf9ab2cu8Btj4IrTmgo=
Date: Sun, 13 Jul 2025 16:40:45 -0700
To: mm-commits@vger.kernel.org,liuqiye2025@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-outdated-filename-comment-in-percpu-statsc.patch removed from -mm tree
Message-Id: <20250713234045.E5DC2C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove outdated filename comment in percpu-stats.c
has been removed from the -mm tree.  Its filename was
     mm-remove-outdated-filename-comment-in-percpu-statsc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xuanye Liu <liuqiye2025@163.com>
Subject: mm: remove outdated filename comment in percpu-stats.c
Date: Wed, 2 Jul 2025 14:23:59 +0800

The comment had the old filename. It's also unnecessary, so drop it.

Link: https://lkml.kernel.org/r/20250702062400.207619-1-liuqiye2025@163.com
Signed-off-by: Xuanye Liu <liuqiye2025@163.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu-stats.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/percpu-stats.c~mm-remove-outdated-filename-comment-in-percpu-statsc
+++ a/mm/percpu-stats.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * mm/percpu-debug.c
  *
  * Copyright (C) 2017		Facebook Inc.
  * Copyright (C) 2017		Dennis Zhou <dennis@kernel.org>
_

Patches currently in -mm which might be from liuqiye2025@163.com are

mm-simplify-min_brk-handling-in-brk.patch

