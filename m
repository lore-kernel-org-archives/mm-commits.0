Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76AE1944F
	for <mm-commits@vger.kernel.org>; Sat, 22 Mar 2025 00:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742605063; cv=none; b=mG3LV9p93IrMaSAg3fLF7f0/HrCrACk0vgPRKMu5ceD9kmnH9PZ6RIQyoL2eHOmRf5I9gXKtWW0QVxGGVH/Vskq8L2GMI/O9/9OJquT11LLj+MND7tK4m71sh31vMsYEC5lVljhOroShzbLlKy7tCuMyiS8Ja9EiynjHcGDcKDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742605063; c=relaxed/simple;
	bh=Yh6gmgPCkno4ia/N8kWVHKdTEMLAwh5KNO4kAzHu4m8=;
	h=Date:To:From:Subject:Message-Id; b=t9/1nri+QKZNn29yjMzJf0j56dVpZDyM0DCEKubtz68S+lEtjPaMiJs01IX9iZNS917HZWb/0xSt9EGumDB9yHha9zJb6mTniEXPOOrH7d8Ji0sTib3BRqWoQ/HreHXBn0qfZ2E5lgySQJquhBymWeXzFTrP0K/tbNyxe3S0Dhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YtC3leDu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YtC3leDu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31337C4CEE3;
	Sat, 22 Mar 2025 00:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742605063;
	bh=Yh6gmgPCkno4ia/N8kWVHKdTEMLAwh5KNO4kAzHu4m8=;
	h=Date:To:From:Subject:From;
	b=YtC3leDu4GxG1QBeAv4HXDp9Bi4PskWQi3fyZRea4pVDxjfSm8NrS4HaenMFjdAMQ
	 UfgDRHXAhQqJTwEdGAP0/YZ1R/efPhzRwIegLgFnw3VtZdtj/4/SQ4KIOjo0Ym+jF8
	 HUtY1oalN+SaSfn63BRfFJ+6+6tDzkPleWHcigKg=
Date: Fri, 21 Mar 2025 17:57:42 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,aarcange@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-myself-as-userfaultfd-reviewer-checkpatch-fixes.patch added to mm-unstable branch
Message-Id: <20250322005743.31337C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maintainers-add-myself-as-userfaultfd-reviewer-checkpatch-fixes
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-add-myself-as-userfaultfd-reviewer-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-myself-as-userfaultfd-reviewer-checkpatch-fixes.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: maintainers-add-myself-as-userfaultfd-reviewer-checkpatch-fixes
Date: Fri Mar 21 05:54:54 PM PDT 2025

WARNING: Misordered MAINTAINERS entry - list file patterns in alphabetic order
#37: FILE: MAINTAINERS:15228:
+F:	mm/userfaultfd.c
+F:	fs/userfaultfd.c

WARNING: Misordered MAINTAINERS entry - list file patterns in alphabetic order
#39: FILE: MAINTAINERS:15230:
+F:	include/uapi/linux/userfaultfd.h
+F:	include/asm-generic/pgtable_uffd.h

WARNING: Misordered MAINTAINERS entry - list file patterns in alphabetic order
#40: FILE: MAINTAINERS:15231:
+F:	include/asm-generic/pgtable_uffd.h
+F:	Documentation/admin-guide/mm/userfaultfd.rst

total: 0 errors, 3 warnings, 17 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/maintainers-add-myself-as-userfaultfd-reviewer.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/MAINTAINERS~maintainers-add-myself-as-userfaultfd-reviewer-checkpatch-fixes
+++ a/MAINTAINERS
@@ -15224,11 +15224,11 @@ MEMORY USERFAULTFD
 M:	Andrew Morton <akpm@linux-foundation.org>
 R:	Peter Xu <peterx@redhat.com>
 S:	Maintained
-F:	mm/userfaultfd.c
+F:	Documentation/admin-guide/mm/userfaultfd.rst
 F:	fs/userfaultfd.c
-F:	include/uapi/linux/userfaultfd.h
 F:	include/asm-generic/pgtable_uffd.h
-F:	Documentation/admin-guide/mm/userfaultfd.rst
+F:	include/uapi/linux/userfaultfd.h
+F:	mm/userfaultfd.c
 F:	tools/testing/selftests/mm/uffd-*.[ch]
 
 MEMORY TECHNOLOGY DEVICES (MTD)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maintainers-add-myself-as-userfaultfd-reviewer-checkpatch-fixes.patch
mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2-fix.patch
hung_task-show-the-blocker-task-if-the-task-is-hung-on-mutex-fix.patch
samples-add-hung_task-detector-mutex-blocking-sample-fix.patch

