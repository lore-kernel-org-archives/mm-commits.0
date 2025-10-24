Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F9B302774
	for <mm-commits@vger.kernel.org>; Fri, 24 Oct 2025 08:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761296127; cv=none; b=a2ukcFSrxiXl3SdVAkg9nQLCP37umANvrlGRInQPElOyi5lyZq2mzIrMAz25raKDV+GQ9+Z5UxCBUzypxZKZhxgcZKKPkU+oDN5zJuDpemyWeHIdXqrZa+khMmUCcnAd7W8dWhRTOFiiMRCxXDFyWMLIy5naPh+NYK6IYivkknY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761296127; c=relaxed/simple;
	bh=txzO1jCLwnlwxgE13jxK9RLP2Exm7h8Yla+QHNbL3UM=;
	h=Date:To:From:Subject:Message-Id; b=aUbqERoZsxfN3gsD7YQOXolkhy3EkpLDrJkBkdLXzA9MAMFAXzZP58N1IXLRgPnzVx41R9A9oWNZtfHQP7EIx6uk7GJC0bBlMZxGW7TyXmfJhC3+U8bNjmxh3YJIRDxnX7kTysbuU4B/6sONGF1bw/KbG6Pl9uH3Y//TGsVDPx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R1iz1+Pu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R1iz1+Pu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E395C4CEF7;
	Fri, 24 Oct 2025 08:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761296126;
	bh=txzO1jCLwnlwxgE13jxK9RLP2Exm7h8Yla+QHNbL3UM=;
	h=Date:To:From:Subject:From;
	b=R1iz1+Pu7Fc4Zwi6WuyyTJFyttvBAEDnWDhDSXQUQoqFGq40TmYYvpam2twup2f7Q
	 2earppqBCFOiopwLLWx4VQig9kC9CVWgLfZWojEDhyZUqHIbF7dW4l0IbCnWHSz0Pf
	 RObyFi3GlUrdu3YOo/UoyGT0pS6VxNKbZJuLHpso=
Date: Fri, 24 Oct 2025 01:55:25 -0700
To: mm-commits@vger.kernel.org,torvalds@linux-foundation.org,broonie@kernel.org,sfr@canb.auug.org.au,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] maintainers-add-mark-brown-as-a-maintainer.patch removed from -mm tree
Message-Id: <20251024085526.6E395C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add Mark Brown as a linux-next maintainer
has been removed from the -mm tree.  Its filename was
     maintainers-add-mark-brown-as-a-maintainer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: MAINTAINERS: add Mark Brown as a linux-next maintainer
Date: Wed, 22 Oct 2025 16:36:25 +1100

Mark has been kindly helping fill in when I have been unavailable over
the past several years.  He has also put his hand up to take over
linux-next maintenance when I finally decide to stop (which may be some
time yet ;-) ).

Link: https://lkml.kernel.org/r/20251022163625.5df7542a@canb.auug.org.au
Link: https://patch.msgid.link/all/20251022163625.5df7542a@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Mark Brown <broonie@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-mark-brown-as-a-maintainer
+++ a/MAINTAINERS
@@ -14393,6 +14393,7 @@ F:	tools/memory-model/
 
 LINUX-NEXT TREE
 M:	Stephen Rothwell <sfr@canb.auug.org.au>
+M:	Mark Brown <broonie@kernel.org>
 L:	linux-next@vger.kernel.org
 S:	Supported
 B:	mailto:linux-next@vger.kernel.org and the appropriate development tree
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are


