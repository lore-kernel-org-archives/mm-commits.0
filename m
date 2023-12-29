Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECC912B99
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 19:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KojhQJGL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6521C433C9;
	Fri, 29 Dec 2023 19:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703876846;
	bh=Yd2Ajav48OeVy/YRQFksb7zeMRRW6hWrnAGvR3b+Qn4=;
	h=Date:To:From:Subject:From;
	b=KojhQJGLlY9AHbv5W5d0UUtZpo+CnT5pVBFswZqkUxryXqYo1VAhpTNnFOk1/y6n3
	 iSJRCDz2ocWeFzt25sfJP4soA/GEZX9Sij+bMapDXhXGIXGCgLtiyPLXsHr+D14GDr
	 38JtdefNBS2OQhyNnYKOokFzlD5Ol8ypH0Z+0lHI=
Date: Fri, 29 Dec 2023 11:07:26 -0800
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,mike.kravetz@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-remove-hugetlb-maintainer-mike-kravetz.patch removed from -mm tree
Message-Id: <20231229190726.B6521C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: remove hugetlb maintainer Mike Kravetz
has been removed from the -mm tree.  Its filename was
     maintainers-remove-hugetlb-maintainer-mike-kravetz.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: MAINTAINERS: remove hugetlb maintainer Mike Kravetz
Date: Wed, 20 Dec 2023 14:08:43 -0800

I am stepping away from my role as hugetlb maintainer.  There should be no
gap in coverage as Muchun Song is also a hugetlb maintainer.

[akpm@linux-foundation.org: update CREDITS]
Link: https://lkml.kernel.org/r/20231220220843.73586-1-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS     |    4 ++++
 MAINTAINERS |    1 -
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/CREDITS~maintainers-remove-hugetlb-maintainer-mike-kravetz
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


