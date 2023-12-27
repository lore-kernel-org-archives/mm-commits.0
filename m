Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B56263AF
	for <mm-commits@vger.kernel.org>; Wed, 27 Dec 2023 21:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VvOYTkSN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E815BC433C8;
	Wed, 27 Dec 2023 21:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703713192;
	bh=FAhHyrsVuptyFFT8P3SWkeRa8v6+yUcKqH8J05vIsD4=;
	h=Date:To:From:Subject:From;
	b=VvOYTkSN0qGpC5n4e6l2oeAJttruuFAesfWkG9dV8OdBT97cjZ/5EtvJHrku1EYuq
	 FfO3G8BTNkispifzpD3u90nSb5hqegXwFmcFwF5axgK7jEUdHdACtqDPAmys2QCAaw
	 7Tut5ZwMIHbO206Dpj20yqo3d6pk1Yb+sPOmtzqE=
Date: Wed, 27 Dec 2023 13:39:51 -0800
To: mm-commits@vger.kernel.org,naoya.horiguchi@nec.com,linmiaohe@huawei.com,david@redhat.com,nao.horiguchi@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-hand-over-hwpoison-maintainership-to-miaohe-lin-v2.patch added to mm-hotfixes-unstable branch
Message-Id: <20231227213951.E815BC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maintainers-hand-over-hwpoison-maintainership-to-miaohe-lin-v2
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-hand-over-hwpoison-maintainership-to-miaohe-lin-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-hand-over-hwpoison-maintainership-to-miaohe-lin-v2.patch

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
From: Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: maintainers-hand-over-hwpoison-maintainership-to-miaohe-lin-v2
Date: Sat, 23 Dec 2023 12:11:15 +0900

update to keep myself as a reviewer 

Link: https://lkml.kernel.org/r/20231223031115.GA2883156@u2004
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-hand-over-hwpoison-maintainership-to-miaohe-lin-v2
+++ a/MAINTAINERS
@@ -9784,6 +9784,7 @@ F:	drivers/media/platform/st/sti/hva
 
 HWPOISON MEMORY FAILURE HANDLING
 M:	Miaohe Lin <linmiaohe@huawei.com>
+R:	Naoya Horiguchi <naoya.horiguchi@nec.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/hwpoison-inject.c
_

Patches currently in -mm which might be from nao.horiguchi@gmail.com are

maintainers-hand-over-hwpoison-maintainership-to-miaohe-lin-v2.patch

