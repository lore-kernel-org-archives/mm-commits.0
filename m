Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA4D153565
	for <mm-commits@vger.kernel.org>; Sat,  1 Feb 2025 11:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738410845; cv=none; b=sobPeAgLxHBxD3kmq3ekHfx8adTUI1pt0hU9xr8mLlt5dHeTkfLOUB35Bqh1rSHsaVe59Bc3/5kkhDHnYzgqUQ32zwweiFLyKfN6r1bCAvZhHWpyuGyGfciq7kEpi4xVhfs9o8l1063uYKGYknvbQZDpphBm0kIsDeLUpubIi5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738410845; c=relaxed/simple;
	bh=r8YOAjVntww9GhcStb9T6UUrMdpZ3WfncmhHUTC2ye4=;
	h=Date:To:From:Subject:Message-Id; b=beXrw1grm5XVaKogY5DKiqAZ97GRxavrMIBKriWKB/Zli+2HFRXV1yN8gDBKgcOTQUX2ZBQYgJQUF6ySMoZ6FbmG/DXOMagYrvUzzpztiE1OkV5syzW6aMmp28RYxLXBe1NsBZDijQ19XCCzv7y0yxTJsw9alffuFAH4lc0JJlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Pi2MOe0u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Pi2MOe0u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8AACC4CED3;
	Sat,  1 Feb 2025 11:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738410845;
	bh=r8YOAjVntww9GhcStb9T6UUrMdpZ3WfncmhHUTC2ye4=;
	h=Date:To:From:Subject:From;
	b=Pi2MOe0uWo3LBQewQSpFzubT7C5EbnETcr3VPJmwoyUZN/BG/jJ0rWMoQjQG+ZhwX
	 T6EYYqAFVWGR54O8LXatoY2fzMrd6e6YUInynvamal0W+jKbP6Io6QqwhBm6/uDY6B
	 QfmagEd4JppfJtJ6FIQq4vbLow+yThLRWumS+N8k=
Date: Sat, 01 Feb 2025 03:54:04 -0800
To: mm-commits@vger.kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,yosry.ahmed@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-mailmap-update-yosry-ahmeds-email-address.patch removed from -mm tree
Message-Id: <20250201115404.E8AACC4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: mailmap: update Yosry Ahmed's email address
has been removed from the -mm tree.  Its filename was
     maintainers-mailmap-update-yosry-ahmeds-email-address.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -761,6 +761,7 @@ Wolfram Sang <wsa@kernel.org> <wsa@the-d
 Yakir Yang <kuankuan.y@gmail.com> <ykk@rock-chips.com>
 Yanteng Si <si.yanteng@linux.dev> <siyanteng@loongson.cn>
 Ying Huang <huang.ying.caritas@gmail.com> <ying.huang@intel.com>
+Yosry Ahmed <yosry.ahmed@linux.dev> <yosryahmed@google.com>
 Yusuke Goda <goda.yusuke@renesas.com>
 Zack Rusin <zack.rusin@broadcom.com> <zackr@vmware.com>
 Zhu Yanjun <zyjzyj2000@gmail.com> <yanjunz@nvidia.com>
--- a/MAINTAINERS~maintainers-mailmap-update-yosry-ahmeds-email-address
+++ a/MAINTAINERS
@@ -26213,7 +26213,7 @@ K:	zstd
 
 ZSWAP COMPRESSED SWAP CACHING
 M:	Johannes Weiner <hannes@cmpxchg.org>
-M:	Yosry Ahmed <yosryahmed@google.com>
+M:	Yosry Ahmed <yosry.ahmed@linux.dev>
 M:	Nhat Pham <nphamcs@gmail.com>
 R:	Chengming Zhou <chengming.zhou@linux.dev>
 L:	linux-mm@kvack.org
_

Patches currently in -mm which might be from yosry.ahmed@linux.dev are

mm-z3fold-remove-z3fold.patch
mm-zbud-remove-zbud.patch

