Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610AD1369
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XoZ5gY0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC628C433C8;
	Mon, 11 Dec 2023 00:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702255575;
	bh=Hji/FEU76Sue4yopW/ItIRQNQ7bEJpU5DBkF2UwcuQQ=;
	h=Date:To:From:Subject:From;
	b=XoZ5gY0adrgEuRGx6Q4fPKEjjM3H8wwO4usM5qJfZ+DWCbiKUS75uwkhckxA8jGsF
	 bGYccoiLOpDNEskIQxmLDsR3XdDR+10Sr5UZ0qvNU1OVl/FVW6qihxpxcHq7NfCmWy
	 03lkzsak663Lwp31mBhcGiZwdLmCJ47HA6gDFlYI=
Date: Sun, 10 Dec 2023 16:46:14 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,fancer.lancer@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-mm_initc-extend-init-unavailable-range-doc-info-v2.patch removed from -mm tree
Message-Id: <20231211004614.DC628C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-mm_initc-extend-init-unavailable-range-doc-info-v2
has been removed from the -mm tree.  Its filename was
     mm-mm_initc-extend-init-unavailable-range-doc-info-v2.patch

This patch was dropped because it was folded into mm-mm_initc-extend-init-unavailable-range-doc-info.patch

------------------------------------------------------
From: Serge Semin <fancer.lancer@gmail.com>
Subject: mm-mm_initc-extend-init-unavailable-range-doc-info-v2
Date: Sat, 2 Dec 2023 14:18:52 +0300

update per Mike

Link: https://lkml.kernel.org/r/20231202111855.18392-1-fancer.lancer@gmail.com
Signed-off-by: Serge Semin <fancer.lancer@gmail.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mm_init.c~mm-mm_initc-extend-init-unavailable-range-doc-info-v2
+++ a/mm/mm_init.c
@@ -796,7 +796,7 @@ overlap_memmap_init(unsigned long zone,
  * - physical memory bank size is not necessarily the exact multiple of the
  *   arbitrary section size
  * - early reserved memory may not be listed in memblock.memory
- * - memory mapped IO space
+ * - non-memory regions covered by the contigious flatmem mapping
  * - memory layouts defined with memmap= kernel parameter may not align
  *   nicely with memmap sections
  *
_

Patches currently in -mm which might be from fancer.lancer@gmail.com are

mm-mm_initc-extend-init-unavailable-range-doc-info.patch
mm-mm_initc-append-newline-to-the-unavailable-ranges-log-message.patch

