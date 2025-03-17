Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614F8218580
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188474; cv=none; b=lTkSfVWkEtFWkYnIFX7CXYB8IF5pLOtnvg0mR9kh4N9hE2IVf9XVSq+XyArGHM9UtLRNT/pTXYGWjFfRRHB3iE8o2uD17Sp5F2ePb0Odg6kCS0XQ8vRpkOECVDGo6ser9bl86jTjfXdBJr3xC2pY+4UF1ArqzpuyYjAQMyrVkYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188474; c=relaxed/simple;
	bh=HIYo0/XlkixUirDGAIqUcxg3I4D+5npY/5cMryuKS+I=;
	h=Date:To:From:Subject:Message-Id; b=mePCSIfdIoCj0lMnFAfM6d+ThKJsPGRdvb93SNeLdrWdRicWBYOqavRDGXf8ePfgWXolG8sbDBvY2pe37kmAwdSMt+Yy0rNx6T2yx3UK+75HCn4Imiiw136N+S23QchrjCDZoetizSiCcE1l6QgVNa0mk0MM4vxMhTuS9P+lfnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I+vXuCzz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I+vXuCzz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E73C4CEEC;
	Mon, 17 Mar 2025 05:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188474;
	bh=HIYo0/XlkixUirDGAIqUcxg3I4D+5npY/5cMryuKS+I=;
	h=Date:To:From:Subject:From;
	b=I+vXuCzzQqgiNZyX+EEJzBM9sihpQRATe0wdYSzXszGDM59w2a6OCDo8igoaHJQYq
	 EZCoCySGRFoF6urPDWfJnzYReK3Pf/PwdPBlcr8R69cwPRGIavnYwzxnm6HsfdKe0Z
	 tzRY4vZYliH2spXzcDAwIme5QcZubDivfXb7vao0=
Date: Sun, 16 Mar 2025 22:14:33 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] vmalloc-drop-myself-from-reviewers.patch removed from -mm tree
Message-Id: <20250317051434.35E73C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: vmalloc: drop Christoph from Reviewers
has been removed from the -mm tree.  Its filename was
     vmalloc-drop-myself-from-reviewers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: vmalloc: drop Christoph from Reviewers
Date: Mon, 24 Feb 2025 08:30:33 -0800

I haven't been doing as much review as I should.  As part of reducing my
inbox flow drop me from the official Reviewers.  I might still chime in on
patches occasionally.

Link: https://lkml.kernel.org/r/20250224163033.350072-1-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

--- a/MAINTAINERS~vmalloc-drop-myself-from-reviewers
+++ a/MAINTAINERS
@@ -25301,7 +25301,6 @@ F:	tools/testing/vsock/
 VMALLOC
 M:	Andrew Morton <akpm@linux-foundation.org>
 R:	Uladzislau Rezki <urezki@gmail.com>
-R:	Christoph Hellwig <hch@infradead.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
_

Patches currently in -mm which might be from hch@lst.de are


