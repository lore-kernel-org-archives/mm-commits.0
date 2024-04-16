Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F9F1E511
	for <mm-commits@vger.kernel.org>; Tue, 16 Apr 2024 22:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713307235; cv=none; b=FeRdZRVJOX6HDCEIVTp1jMEMPrWB2FaoUjIJplDuNhO/3nACnOpkU9Jp9u46l5ZGdUu8mr5IM1FsBhsACTotJZdCZThFDbB6lDDnZzaXi5w5Fwx6YV8lxBAuyszUnW4U7B7fs4B3ePThvaeP+C725ZaeDpBpIy1syFNsC28l6E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713307235; c=relaxed/simple;
	bh=x9Z70U8W6m4ufThnX5sbH0To60CtoyKZdt+vaxRgWHc=;
	h=Date:To:From:Subject:Message-Id; b=bVrJJm1S24SO9remXcY8d0dsptiXXPxca3ySDHKoFN9ektQtOepuLM3bAVCuI1K7ZI294FjPCULqX6vbbpN15vRe1L3y2v9gSexFRCmhMNxzbAXcrFv/VLUKtH6gKzq/xa4ppHzw3tR4l8NW6krsoeH4fmPHn+dzjvk6Bqawl4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B+Tvyneb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B+Tvyneb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 225C0C32783;
	Tue, 16 Apr 2024 22:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713307235;
	bh=x9Z70U8W6m4ufThnX5sbH0To60CtoyKZdt+vaxRgWHc=;
	h=Date:To:From:Subject:From;
	b=B+TvynebibRTPdU9EOu+HrrEgytldI+WmkL59kLvg6EPQ6L30dr8gAUPjMbx3EBF5
	 o54DGKjjqOUDN+By7bxWsPph+9n+1csnzAQinFDxoXzRTGkm4Ktk/d45y6KBAxDTv+
	 LLEFf8dhCF5jxchoZHvAS86B7P81SmfttguAih/0=
Date: Tue, 16 Apr 2024 15:40:34 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,linmiaohe@huawei.com,nao.horiguchi@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-update-naoya-horiguchis-email-address.patch removed from -mm tree
Message-Id: <20240416224035.225C0C32783@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: update Naoya Horiguchi's email address
has been removed from the -mm tree.  Its filename was
     maintainers-update-naoya-horiguchis-email-address.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: MAINTAINERS: update Naoya Horiguchi's email address
Date: Sat, 13 Apr 2024 03:17:20 +0900

My old NEC address has been removed, so update MAINTAINERS and .mailmap to
map it to my gmail address.

Link: https://lkml.kernel.org/r/20240412181720.18452-1-nao.horiguchi@gmail.com
Signed-off-by: Naoya Horiguchi <nao.horiguchi@gmail.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    3 ++-
 MAINTAINERS |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/.mailmap~maintainers-update-naoya-horiguchis-email-address
+++ a/.mailmap
@@ -446,7 +446,8 @@ Mythri P K <mythripk@ti.com>
 Nadav Amit <nadav.amit@gmail.com> <namit@vmware.com>
 Nadav Amit <nadav.amit@gmail.com> <namit@cs.technion.ac.il>
 Nadia Yvette Chambers <nyc@holomorphy.com> William Lee Irwin III <wli@holomorphy.com>
-Naoya Horiguchi <naoya.horiguchi@nec.com> <n-horiguchi@ah.jp.nec.com>
+Naoya Horiguchi <nao.horiguchi@gmail.com> <n-horiguchi@ah.jp.nec.com>
+Naoya Horiguchi <nao.horiguchi@gmail.com> <naoya.horiguchi@nec.com>
 Nathan Chancellor <nathan@kernel.org> <natechancellor@gmail.com>
 Neeraj Upadhyay <quic_neeraju@quicinc.com> <neeraju@codeaurora.org>
 Neil Armstrong <neil.armstrong@linaro.org> <narmstrong@baylibre.com>
--- a/MAINTAINERS~maintainers-update-naoya-horiguchis-email-address
+++ a/MAINTAINERS
@@ -10024,7 +10024,7 @@ F:	drivers/media/platform/st/sti/hva
 
 HWPOISON MEMORY FAILURE HANDLING
 M:	Miaohe Lin <linmiaohe@huawei.com>
-R:	Naoya Horiguchi <naoya.horiguchi@nec.com>
+R:	Naoya Horiguchi <nao.horiguchi@gmail.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/hwpoison-inject.c
_

Patches currently in -mm which might be from nao.horiguchi@gmail.com are


