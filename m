Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52AC32E823
	for <mm-commits@vger.kernel.org>; Fri, 22 Dec 2023 19:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p2x5EUUd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC966C433C7;
	Fri, 22 Dec 2023 19:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703275098;
	bh=U0mroXl6X1kdAMFrJh9USBZVDnx5Kual+ZDse6NPCVM=;
	h=Date:To:From:Subject:From;
	b=p2x5EUUdsyRQokwKketIQqB1HHmsaWJ+QQ+qi6PJAThSaGwbqjX3QXT2CPugNC+ha
	 F1KyxmgEswHcEwO1jNfVcamidXlAhfcbGr+74lGvZjMYQDUdRYbS1qgvWb92/ZDKtY
	 LVfmLBM90Qb8hXNGz8N/nHYczHRHDMVcpOwi0udA=
Date: Fri, 22 Dec 2023 11:58:18 -0800
To: mm-commits@vger.kernel.org,linmiaohe@huawei.com,david@redhat.com,naoya.horiguchi@nec.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-hand-over-hwpoison-maintainership-to-miaohe-lin.patch added to mm-hotfixes-unstable branch
Message-Id: <20231222195818.AC966C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: hand over hwpoison maintainership to Miaohe Lin
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-hand-over-hwpoison-maintainership-to-miaohe-lin.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-hand-over-hwpoison-maintainership-to-miaohe-lin.patch

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
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: MAINTAINERS: hand over hwpoison maintainership to Miaohe Lin
Date: Fri, 22 Dec 2023 11:40:24 +0900

Miaohe Lin has contributed to hwpoison subsystem as a reviewer for more
than 1.5 year, and has made many patch contributions in hwpoison subsystem
and the memory management subsystem.  So I'd like to pass on the hwpoison
maintainership to Miaohe.

Link: https://lkml.kernel.org/r/20231222024024.1601043-1-naoya.horiguchi@linux.dev
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/MAINTAINERS~maintainers-hand-over-hwpoison-maintainership-to-miaohe-lin
+++ a/MAINTAINERS
@@ -9783,8 +9783,7 @@ T:	git git://linuxtv.org/media_tree.git
 F:	drivers/media/platform/st/sti/hva
 
 HWPOISON MEMORY FAILURE HANDLING
-M:	Naoya Horiguchi <naoya.horiguchi@nec.com>
-R:	Miaohe Lin <linmiaohe@huawei.com>
+M:	Miaohe Lin <linmiaohe@huawei.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/hwpoison-inject.c
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

maintainers-hand-over-hwpoison-maintainership-to-miaohe-lin.patch

