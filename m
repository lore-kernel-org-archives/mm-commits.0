Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3714112B93
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 19:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K/9lTB8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1833C433C8;
	Fri, 29 Dec 2023 19:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703876707;
	bh=wcRTtWkFW6qNSwApcEXGb1HSicvwDfaMuXdyOOXGz9Y=;
	h=Date:To:From:Subject:From;
	b=K/9lTB8tmKRSwjXZmJjaiDVmpTkUYplKn3FIWTci7QYz/VRF3mqa7mv4HT3DaHnqv
	 iHj/5xrIYS8/Ohj8C5jnT6WxI1XQjXKIlfQpwIwyCpr4ABZTzYc/71aj0DTknEEBiP
	 Wqq/bj+fkF6I9ax5N4i4T+Ge0d35WgRMte+lPSZQ=
Date: Fri, 29 Dec 2023 11:05:07 -0800
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,mike.kravetz@oracle.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] maintainers-remove-hugetlb-maintainer-mike-kravetz-fix.patch removed from -mm tree
Message-Id: <20231229190507.A1833C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maintainers-remove-hugetlb-maintainer-mike-kravetz-fix
has been removed from the -mm tree.  Its filename was
     maintainers-remove-hugetlb-maintainer-mike-kravetz-fix.patch

This patch was dropped because it was folded into maintainers-remove-hugetlb-maintainer-mike-kravetz.patch

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

maintainers-remove-hugetlb-maintainer-mike-kravetz.patch
kasan-stop-leaking-stack-trace-handles-fix.patch

