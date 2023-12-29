Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9464712E43
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 19:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rtzaEYdc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C54EC433C8;
	Fri, 29 Dec 2023 19:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703876848;
	bh=as4h9cf7smJ4EIXzv/jNSYwlRjejSRE7yIS8i1eL3Ok=;
	h=Date:To:From:Subject:From;
	b=rtzaEYdcwilUWUtUJeffNdH7+8m0IrubLCDsSVxuEVJXc6prEO4zThNSQyHQCRJJh
	 ZmFR1j7fxX0L0e4jzgQ/wQPFdkUUDfsfafUN/rMUg8Ir/6MsVlDy9wZK2AyS8M2S4q
	 HGekunOSRol9JAKJ5b8TfborH+nOfL6Ww/tFxV2g=
Date: Fri, 29 Dec 2023 11:07:27 -0800
To: mm-commits@vger.kernel.org,linmiaohe@huawei.com,david@redhat.com,naoya.horiguchi@nec.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-hand-over-hwpoison-maintainership-to-miaohe-lin.patch removed from -mm tree
Message-Id: <20231229190728.5C54EC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: hand over hwpoison maintainership to Miaohe Lin
has been removed from the -mm tree.  Its filename was
     maintainers-hand-over-hwpoison-maintainership-to-miaohe-lin.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: MAINTAINERS: hand over hwpoison maintainership to Miaohe Lin
Date: Fri, 22 Dec 2023 11:40:24 +0900

Miaohe Lin has contributed to hwpoison subsystem as a reviewer for more
than 1.5 year, and has made many patch contributions in hwpoison subsystem
and the memory management subsystem.  So I'd like to pass on the hwpoison
maintainership to Miaohe.

[nao.horiguchi@gmail.com: update to keep myself as a reviewer]
  Link: https://lkml.kernel.org/r/20231223031115.GA2883156@u2004
Link: https://lkml.kernel.org/r/20231222024024.1601043-1-naoya.horiguchi@linux.dev
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/MAINTAINERS~maintainers-hand-over-hwpoison-maintainership-to-miaohe-lin
+++ a/MAINTAINERS
@@ -9783,8 +9783,8 @@ T:	git git://linuxtv.org/media_tree.git
 F:	drivers/media/platform/st/sti/hva
 
 HWPOISON MEMORY FAILURE HANDLING
-M:	Naoya Horiguchi <naoya.horiguchi@nec.com>
-R:	Miaohe Lin <linmiaohe@huawei.com>
+M:	Miaohe Lin <linmiaohe@huawei.com>
+R:	Naoya Horiguchi <naoya.horiguchi@nec.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/hwpoison-inject.c
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are


