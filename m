Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0DE04BAB9
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 22:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jPRuBSXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33D8AC433C8;
	Wed, 20 Dec 2023 22:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703111234;
	bh=POiWBXqJC5x13jCxTURYkklUb6LTqILtwmLhaxIcOro=;
	h=Date:To:From:Subject:From;
	b=jPRuBSXhMwvO5D9ZRoyInVH20QFfkDS1GIwSmkN/O9Wnn2lCnP048WrBY2N8BTZG0
	 QpmG4WB+XRe/KzMnBi6Lg9ZVSGk6cUhhg0zGuRhHFKDjVRCIxBfx2Bj6toWo7ZdRxp
	 M8CxztfhlRhC6fv1sqFlS6EMhSA7j7NvVzCDkrGk=
Date: Wed, 20 Dec 2023 14:27:13 -0800
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,mike.kravetz@oracle.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-remove-hugetlb-maintainer-mike-kravetz-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20231220222714.33D8AC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maintainers-remove-hugetlb-maintainer-mike-kravetz-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-remove-hugetlb-maintainer-mike-kravetz-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-remove-hugetlb-maintainer-mike-kravetz-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: maintainers-remove-hugetlb-maintainer-mike-kravetz-fix
Date: Wed Dec 20 02:23:04 PM PST 2023

update CREDITS

Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS |    4 ++++
 1 file changed, 4 insertions(+)

--- a/CREDITS~maintainers-remove-hugetlb-maintainer-mike-kravetz-fix
+++ a/CREDITS
@@ -2126,6 +2126,10 @@ S: 2213 La Terrace Circle
 S: San Jose, CA 95123
 S: USA
 
+N: Mike Kravetz
+E: mike.kravetz@oracle.com
+D: Maintenance and development of the hugetlb subsystem
+
 N: Andreas S. Krebs
 E: akrebs@altavista.net
 D: CYPRESS CY82C693 chipset IDE, Digital's PC-Alpha 164SX boards
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maintainers-remove-hugetlb-maintainer-mike-kravetz-fix.patch
lib-maple_treec-fix-build-error-due-to-hotfix-alteration.patch
mm-list_lruc-remove-unused-list_lru_from_kmem.patch
mm-memcg-restore-subtree-stats-flushing-fix.patch
mips-fix-r3k_cache_init-build-regression-fix.patch

