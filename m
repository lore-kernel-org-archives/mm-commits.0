Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A17C258A
	for <mm-commits@vger.kernel.org>; Fri, 24 Jan 2025 05:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737697954; cv=none; b=TnMptVgy8YpyHI3V79OPou8Bzy5RPtbbEfJBNnoq2natPjCWGL6dsWYChOdaQTJ5vJdQ2kFwocVuROUZ16E5oMublPGarABqcLyTCbzeaG+yn0c0sS9b6fUNJv8Ae+AIfzt1P/JkE8FyOycAvAbuWhAKYy1GOY2xK35ItMgTEQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737697954; c=relaxed/simple;
	bh=pxx20HBkGg0k7ZgQIsck3Tpt0iUIdrsLeqH9WEcLJN8=;
	h=Date:To:From:Subject:Message-Id; b=P9FIh+jlW6eB3L1aJnmnahNiK4OcEbCj632UlQ7ZtzzilKkWiZ9ikXq065p/zMLC5S4KHg10HHjI9CUZJ9aZjYh0N7mCZdICITvtaMTTmOZ2svUZl44XzlBsF0s6U92TYfz4dm7v13f5hiuJ9y2p9YHXPz0uUArM9XlTYvJgZ4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1Z1t4fOM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1Z1t4fOM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99C1C4CED2;
	Fri, 24 Jan 2025 05:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737697953;
	bh=pxx20HBkGg0k7ZgQIsck3Tpt0iUIdrsLeqH9WEcLJN8=;
	h=Date:To:From:Subject:From;
	b=1Z1t4fOMZiUarBJpk9rDZcuAEph1M23CZMtHXGSXuJwwPaS3OpjbLPkvpAbxWCRcH
	 GWHN0sGIa5IdnCMk2BOsRnLJV48GSn/DI2htoTJkeEszPiQTFWvU6zgYk0zuUDNjvs
	 WgyEY6xjdx4Dze+0HAelI+bydRaaxwMk0RN6QBnA=
Date: Thu, 23 Jan 2025 21:52:33 -0800
To: mm-commits@vger.kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,yosry.ahmed@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-mailmap-update-yosry-ahmeds-email-address.patch added to mm-hotfixes-unstable branch
Message-Id: <20250124055233.A99C1C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: mailmap: update Yosry Ahmed's email address
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-mailmap-update-yosry-ahmeds-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-mailmap-update-yosry-ahmeds-email-address.patch

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
From: Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: MAINTAINERS: mailmap: update Yosry Ahmed's email address
Date: Thu, 23 Jan 2025 23:13:44 +0000

Moving to a linux.dev email address.

Link: https://lkml.kernel.org/r/20250123231344.817358-1-yosry.ahmed@linux.dev
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/.mailmap~maintainers-mailmap-update-yosry-ahmeds-email-address
+++ a/.mailmap
@@ -740,6 +740,7 @@ Wolfram Sang <wsa@kernel.org> <wsa@the-d
 Yakir Yang <kuankuan.y@gmail.com> <ykk@rock-chips.com>
 Yanteng Si <si.yanteng@linux.dev> <siyanteng@loongson.cn>
 Ying Huang <huang.ying.caritas@gmail.com> <ying.huang@intel.com>
+Yosry Ahmed <yosry.ahmed@linux.dev> <yosryahmed@google.com>
 Yusuke Goda <goda.yusuke@renesas.com>
 Zack Rusin <zack.rusin@broadcom.com> <zackr@vmware.com>
 Zhu Yanjun <zyjzyj2000@gmail.com> <yanjunz@nvidia.com>
--- a/MAINTAINERS~maintainers-mailmap-update-yosry-ahmeds-email-address
+++ a/MAINTAINERS
@@ -26028,7 +26028,7 @@ K:	zstd
 
 ZSWAP COMPRESSED SWAP CACHING
 M:	Johannes Weiner <hannes@cmpxchg.org>
-M:	Yosry Ahmed <yosryahmed@google.com>
+M:	Yosry Ahmed <yosry.ahmed@linux.dev>
 M:	Nhat Pham <nphamcs@gmail.com>
 R:	Chengming Zhou <chengming.zhou@linux.dev>
 L:	linux-mm@kvack.org
_

Patches currently in -mm which might be from yosry.ahmed@linux.dev are

maintainers-mailmap-update-yosry-ahmeds-email-address.patch

