Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28E2290F
	for <mm-commits@vger.kernel.org>; Tue,  8 Jul 2025 00:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751933258; cv=none; b=iC0n70hy9ad3+uZ+FyLTKKolj2SDDDpoLPINUl1S9sFw+8mW4jN+bnVRBwbOvIX4k92G9QUI2YR5L/74PwOjKROZabCHv2YtLQh50AF5DWEBLg7acHB3Qky7SYbaCTWMw9IdLNfGm3WdIkxYJ//0pdlCweklz2i5dRI6Grsy5Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751933258; c=relaxed/simple;
	bh=Zg7M6svD0SLiTm2UBQhBUpZ7E6yGVW2/KCAWuZjpDS8=;
	h=Date:To:From:Subject:Message-Id; b=FzSVIoVnBBtoSwEimjfFwDr6Kk8dKkZ6nwaVJWfAplaO0nYEFSuGma0L8/p4sI3bkuhjocpNz2McXZOQEFrbbEHIvkPRRdmkXStwxyHshkhDrxojxZmWi7lctjt1B1xzxiLoduK2IPSI1/AsQoC0Yzgnm18f2LvaxM2lV12NJW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fawSH27N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fawSH27N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E03DC4CEE3;
	Tue,  8 Jul 2025 00:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751933255;
	bh=Zg7M6svD0SLiTm2UBQhBUpZ7E6yGVW2/KCAWuZjpDS8=;
	h=Date:To:From:Subject:From;
	b=fawSH27N97uB6VexnvyWcuj+BMHzRaQ4RxLN2ia2ljPkRxAYeTHlk9dI4V6nXHLjO
	 MB+1jURDEznQHK6zKNqep3fZPArmzvXUspQ2E3Oh24tDJFRz3cFMF05uF7AlY4eQeD
	 9gHR0EN4NKvqHqwEmw5+wSb7qQidDrHSZT3tphGs=
Date: Mon, 07 Jul 2025 17:07:34 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entry-for-senozhatsky.patch added to mm-hotfixes-unstable branch
Message-Id: <20250708000735.2E03DC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: add entry for Senozhatsky
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-add-entry-for-senozhatsky.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entry-for-senozhatsky.patch

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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: mailmap: add entry for Senozhatsky
Date: Mon, 7 Jul 2025 16:52:13 +0900

Consolidate and map all addresses to a single one.

Link: https://lkml.kernel.org/r/20250707075243.858895-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    4 ++++
 1 file changed, 4 insertions(+)

--- a/.mailmap~mailmap-add-entry-for-senozhatsky
+++ a/.mailmap
@@ -693,6 +693,10 @@ Sedat Dilek <sedat.dilek@gmail.com> <sed
 Senthilkumar N L <quic_snlakshm@quicinc.com> <snlakshm@codeaurora.org>
 Serge Hallyn <sergeh@kernel.org> <serge.hallyn@canonical.com>
 Serge Hallyn <sergeh@kernel.org> <serue@us.ibm.com>
+Sergey Senozhatsky <senozhatsky@chromium.org> <sergey.senozhatsky.work@gmail.com>
+Sergey Senozhatsky <senozhatsky@chromium.org> <sergey.senozhatsky@gmail.com>
+Sergey Senozhatsky <senozhatsky@chromium.org> <sergey.senozhatsky@mail.by>
+Sergey Senozhatsky <senozhatsky@chromium.org> <senozhatsky@google.com>
 Seth Forshee <sforshee@kernel.org> <seth.forshee@canonical.com>
 Shakeel Butt <shakeel.butt@linux.dev> <shakeelb@google.com>
 Shannon Nelson <sln@onemain.com> <shannon.nelson@amd.com>
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

mailmap-add-entry-for-senozhatsky.patch

