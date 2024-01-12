Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF23B18EA9
	for <mm-commits@vger.kernel.org>; Fri, 12 Jan 2024 23:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MD04gXDZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55887C433F1;
	Fri, 12 Jan 2024 23:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705101695;
	bh=G9L8ABbKZvdW2vVyJmFhdoVBAyLISXA1fVc/N2U8rX8=;
	h=Date:To:From:Subject:From;
	b=MD04gXDZ9nXpyjwUxMFVVd+tQLOQ/Np/+aZHp/KJJ/JNHikMbDlKeGnqWMF54osUX
	 lzeGpBX741xn0vsQFAhHtcsTTOUhmvmyZoaA1ni7/6tNlstTKhV0WBarQPAiyO80Jw
	 UULbfG34o5vXACpFWojQA2w9llaZly/U2o1QzVEw=
Date: Fri, 12 Jan 2024 15:21:34 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,vitaly.wool@konsulko.com,sjenning@redhat.com,nphamcs@gmail.com,ddstreet@ieee.org,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-zswap-switch-maintainers-to-recently-active-developers-and-reviewers.patch removed from -mm tree
Message-Id: <20240112232135.55887C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: switch maintainers to recently active developers and reviewers
has been removed from the -mm tree.  Its filename was
     mm-zswap-switch-maintainers-to-recently-active-developers-and-reviewers.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: switch maintainers to recently active developers and reviewers
Date: Tue, 9 Jan 2024 14:02:00 -0500

Yosry, Nhat and I have been doing most of the recent development and
reviewing of changes in this space.  

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Dan Streetman <ddstreet@ieee.org>
Acked-by: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/MAINTAINERS~mm-zswap-switch-maintainers-to-recently-active-developers-and-reviewers
+++ a/MAINTAINERS
@@ -24141,11 +24141,13 @@ N:	zstd
 K:	zstd
 
 ZSWAP COMPRESSED SWAP CACHING
-M:	Seth Jennings <sjenning@redhat.com>
-M:	Dan Streetman <ddstreet@ieee.org>
-M:	Vitaly Wool <vitaly.wool@konsulko.com>
+M:	Johannes Weiner <hannes@cmpxchg.org>
+M:	Yosry Ahmed <yosryahmed@google.com>
+M:	Nhat Pham <nphamcs@gmail.com>
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	Documentation/admin-guide/mm/zswap.rst
+F:	include/linux/zswap.h
 F:	mm/zswap.c
 
 THE REST
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


