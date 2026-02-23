Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C20D330B06
	for <mm-commits@vger.kernel.org>; Mon, 23 Feb 2026 17:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771867308; cv=none; b=KaxO0ZsHfBeO/BxaPmnEQb+JEYadbLrnVhy0bhEgUyFI3Q16mpW6CRJfMigZ/QR09AsYCqf1JGtHBtcX2pOTW8Kmt/iWUa5+eB/LHx5DYhcVrNkU6YaeUgcF4paXF6RhJXGsBeSJHJtLCzYX8PkXPeuUaJdtSbwJCWVmngGWbsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771867308; c=relaxed/simple;
	bh=2MkaR+V21ZmDSF0FaJAmi776SxB56EnISjf+Qj23lac=;
	h=Date:To:From:Subject:Message-Id; b=g+9MBAIpw1qY5rLAgeeGbAqHyFYivLNpBX1ZSf2G2GvSwgwP3l2Gq9yO7qYudoctqlgUaA+fczyQf/NkZxoE4nlcMnyMDS8pNumI106w8AKsPu6cHpWgl+L8fr4aJLG9UqmgjNN52YOMIw+FWjehGFo4cZwCcGQRQIVmNuY9ygQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yjBoCtaz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yjBoCtaz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A5DC116C6;
	Mon, 23 Feb 2026 17:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771867308;
	bh=2MkaR+V21ZmDSF0FaJAmi776SxB56EnISjf+Qj23lac=;
	h=Date:To:From:Subject:From;
	b=yjBoCtazOwPDBfFTu/vJfILgrX2iKns1UYDXa46z5gofmHzdIA+Tu0QEG0rUOzxBP
	 TuNIepySqiRD3spXPp9FbVEJ3aF8Wr2ldhaEXVSVApAFiy37ijr4pNQAM4kFmY7BHK
	 W8NNRyjF2i08yiTiz71RGXrFRb7dbzwTwc4n092o=
Date: Mon, 23 Feb 2026 09:21:47 -0800
To: mm-commits@vger.kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,yosry@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-yosry-ahmeds-email-address.patch added to mm-hotfixes-unstable branch
Message-Id: <20260223172148.29A5DC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: update Yosry Ahmed's email address
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-update-yosry-ahmeds-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-yosry-ahmeds-email-address.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Yosry Ahmed <yosry@kernel.org>
Subject: MAINTAINERS: update Yosry Ahmed's email address
Date: Mon, 23 Feb 2026 16:00:26 +0000

Use my kernel.org email address.

Link: https://lkml.kernel.org/r/20260223160027.122307-1-yosry@kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    3 ++-
 MAINTAINERS |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/.mailmap~maintainers-update-yosry-ahmeds-email-address
+++ a/.mailmap
@@ -892,7 +892,8 @@ Yanteng Si <si.yanteng@linux.dev> <siyan
 Ying Huang <huang.ying.caritas@gmail.com> <ying.huang@intel.com>
 Yixun Lan <dlan@kernel.org> <dlan@gentoo.org>
 Yixun Lan <dlan@kernel.org> <yixun.lan@amlogic.com>
-Yosry Ahmed <yosry.ahmed@linux.dev> <yosryahmed@google.com>
+Yosry Ahmed <yosry@kernel.org> <yosryahmed@google.com>
+Yosry Ahmed <yosry@kernel.org> <yosry.ahmed@linux.dev>
 Yu-Chun Lin <eleanor.lin@realtek.com> <eleanor15x@gmail.com>
 Yusuke Goda <goda.yusuke@renesas.com>
 Zack Rusin <zack.rusin@broadcom.com> <zackr@vmware.com>
--- a/MAINTAINERS~maintainers-update-yosry-ahmeds-email-address
+++ a/MAINTAINERS
@@ -29185,7 +29185,7 @@ K:	zstd
 
 ZSWAP COMPRESSED SWAP CACHING
 M:	Johannes Weiner <hannes@cmpxchg.org>
-M:	Yosry Ahmed <yosry.ahmed@linux.dev>
+M:	Yosry Ahmed <yosry@kernel.org>
 M:	Nhat Pham <nphamcs@gmail.com>
 R:	Chengming Zhou <chengming.zhou@linux.dev>
 L:	linux-mm@kvack.org
_

Patches currently in -mm which might be from yosry@kernel.org are

maintainers-update-yosry-ahmeds-email-address.patch

