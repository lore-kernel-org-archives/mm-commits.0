Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F3A101FF
	for <mm-commits@vger.kernel.org>; Fri,  4 Jul 2025 00:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751590049; cv=none; b=gaogschVpHRN/Er/NGDANIAT+/g07sRhsuWiu21JQjAYQCFkGAzAO2cH5ShnYhSmlfvvAQaNbBTHQPcXyGykF4I7ckXWI2zv0InfXL1AGBWrBGINBKVtxs9T4Mt1t8d+VGRfTwFCrLElkLyWgkD2sVdLfXOQ1sEoo1p1gwxxR50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751590049; c=relaxed/simple;
	bh=U2In+DAnRDYH5J2c9ZYxrTXDaCw782q1MOtU6gd8zIU=;
	h=Date:To:From:Subject:Message-Id; b=noRnaasI6AXl+SBs66QvOXWdnV3yvfhInQyB+v5apPW4cZrCmMZ1trychAvnmo5N3VFe+RIo9RHVO6RI0ICUH8bQo262amm5VRzjH3arRNHIPS5AASdipEOB4utT4T23z3BXiPOt6YrQ13Rb8NaYlWzDjQYsyv1JqPbHSSoH8Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P1s6plvU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P1s6plvU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0FCC4CEE3;
	Fri,  4 Jul 2025 00:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751590049;
	bh=U2In+DAnRDYH5J2c9ZYxrTXDaCw782q1MOtU6gd8zIU=;
	h=Date:To:From:Subject:From;
	b=P1s6plvUX9Gjh3HWBR44K9xXWkvcxeq7tMH+8Yy2JvZDkIZOYCR4ynoT/jYNonnNq
	 PqWocdpb19DOoWaBPEnaUqttChQGh5QMfiVgGUE+lZt35h8Z8/+A1z7n7P4aDbJWh8
	 MJByC/7wWm1Hd59jPl4/dilpUU/vJPmw7o1O/JD4=
Date: Thu, 03 Jul 2025 17:47:28 -0700
To: mm-commits@vger.kernel.org,liuqiye2025@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-outdated-filename-comment-in-percpu-statsc.patch added to mm-unstable branch
Message-Id: <20250704004729.0B0FCC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove outdated filename comment in percpu-stats.c
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-outdated-filename-comment-in-percpu-statsc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-outdated-filename-comment-in-percpu-statsc.patch

This patch will later appear in the mm-unstable branch at
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

mm-fix-spelling-issue-in-swaph.patch
mm-remove-outdated-filename-comment-in-percpu-statsc.patch

