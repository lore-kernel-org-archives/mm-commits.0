Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815844BA9E
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 22:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ND4rhl5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F226DC433C8;
	Wed, 20 Dec 2023 22:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703111233;
	bh=aLB3vyXHeXWAIzgkAIO6mY1Ugnq+AQwt4hkadd06KSI=;
	h=Date:To:From:Subject:From;
	b=ND4rhl5p0cDgPv8qbVpGu+a+lVt8YW1h0E2ASwp2eOEeju+oM1Hmt7v6U1ViO6UNb
	 NHBktWTTT9VTlWib/CgglYc4vtUsKdnLoIEC9bVir19SDOOcf/B/DL6L6rqXdRAq/5
	 qP8eihetDMb+g5PbGHxXz14eI9zrvG0Gclsc6ons=
Date: Wed, 20 Dec 2023 14:27:12 -0800
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,mike.kravetz@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-remove-hugetlb-maintainer-mike-kravetz.patch added to mm-hotfixes-unstable branch
Message-Id: <20231220222712.F226DC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: remove hugetlb maintainer Mike Kravetz
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-remove-hugetlb-maintainer-mike-kravetz.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-remove-hugetlb-maintainer-mike-kravetz.patch

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
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: MAINTAINERS: remove hugetlb maintainer Mike Kravetz
Date: Wed, 20 Dec 2023 14:08:43 -0800

I am stepping away from my role as hugetlb maintainer.  There should be no
gap in coverage as Muchun Song is also a hugetlb maintainer.

Link: https://lkml.kernel.org/r/20231220220843.73586-1-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

--- a/MAINTAINERS~maintainers-remove-hugetlb-maintainer-mike-kravetz
+++ a/MAINTAINERS
@@ -9760,7 +9760,6 @@ F:	Documentation/networking/device_drive
 F:	drivers/net/ethernet/huawei/hinic/
 
 HUGETLB SUBSYSTEM
-M:	Mike Kravetz <mike.kravetz@oracle.com>
 M:	Muchun Song <muchun.song@linux.dev>
 L:	linux-mm@kvack.org
 S:	Maintained
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

maintainers-remove-hugetlb-maintainer-mike-kravetz.patch

