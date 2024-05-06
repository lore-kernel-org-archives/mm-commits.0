Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43FC6116
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714956295; cv=none; b=pw4k81bF26LKi7S9VlHLHV4u6oFJkvI7qaDGcO/qLF677iERRtLaGTUVf+GlTO/RSt8Za4l+m+YxAx1v10xG/6VqKT3OUNx3qQSBPMLPTPLrb3t26RPSbPiYjAvQ00re9DlwJwh54g5dk0whLKpPFELfZ3UDVfI5/OG83X6TxSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714956295; c=relaxed/simple;
	bh=xbnDpfWXNCxFaLLmL3WIDMBN0dtjaUvjqYg+jINYVcs=;
	h=Date:To:From:Subject:Message-Id; b=P0mlu8JyXEOwFInzDxrxCnwp0WR0M6nqelfdMRjdCdUiZHnbfsHf1uMkwwWy9IVoaTv0+U1q+Qt+SftRLwrSzWrLAlX6mBWVQg1Bs1t6An65DeHZS80a5hFe0r/TXmPdyvVjPScFiXjL0eLLDUy8Q9LbzzKBlUNXYhfPeQ5CCiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ttFM6QSn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ttFM6QSn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F11C113CC;
	Mon,  6 May 2024 00:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714956294;
	bh=xbnDpfWXNCxFaLLmL3WIDMBN0dtjaUvjqYg+jINYVcs=;
	h=Date:To:From:Subject:From;
	b=ttFM6QSngSqeefOXOaPYVHDCXFmQsfu9ZEM17j4gUi1UrvL+dEqL+BrI6qfJyqcBj
	 jxDq/e7ViJRGpeIqA0E2GStPEowk0/SkOiZsQptdjBUNPkFgBMR1GPubb3Pm1kw0R0
	 UAdHoCR5AoC5XCqIkog5LPUfjPu0uB557WTlvcZ8=
Date: Sun, 05 May 2024 17:44:53 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,rdunlap@infradead.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] doc-split-bufferrst-out-of-api-summaryrst-fix-fix.patch removed from -mm tree
Message-Id: <20240506004454.70F11C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: doc-split-bufferrst-out-of-api-summaryrst-fix-fix
has been removed from the -mm tree.  Its filename was
     doc-split-bufferrst-out-of-api-summaryrst-fix-fix.patch

This patch was dropped because it was folded into doc-split-bufferrst-out-of-api-summaryrst.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: doc-split-bufferrst-out-of-api-summaryrst-fix-fix
Date: Thu Apr 25 10:01:12 PM PDT 2024

remove newline at EOF

Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/buffer.rst |    1 -
 1 file changed, 1 deletion(-)

--- a/Documentation/filesystems/buffer.rst~doc-split-bufferrst-out-of-api-summaryrst-fix-fix
+++ a/Documentation/filesystems/buffer.rst
@@ -10,4 +10,3 @@ Functions
 .. kernel-doc:: include/linux/buffer_head.h
 .. kernel-doc:: fs/buffer.c
    :export:
-
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

doc-split-bufferrst-out-of-api-summaryrst.patch
mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail-fix.patch
__mod_memcg_lruvec_state-enhance-diagnostics.patch
__mod_memcg_lruvec_state-enhance-diagnostics-fix.patch
watchdog-allow-nmi-watchdog-to-use-raw-perf-event-fix.patch
kernel-watchdog_perfc-tidy-up-kerneldoc.patch

