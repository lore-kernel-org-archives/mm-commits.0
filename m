Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086313081CA
	for <mm-commits@vger.kernel.org>; Tue, 23 Dec 2025 19:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766517866; cv=none; b=vBMDZtmCk6IKyIt1+imboMU02rGTQOD+7pyj1OqgG5nDEFBcFm+2hcD8TWiBQd6P1NM542oXC8Xh673hpvr4BXu/WWgkuc1lmmJgjjGoSu9vzd+4Ou2uJ3lAiQ/WNoQ4eAx1ow2DQGr+4MZMQLYRg3UOkymDvP2xAaWauwXWsfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766517866; c=relaxed/simple;
	bh=SPjPC/mWKoTojKaQS+cQj6PyEjMkgSMoCMqfImYQhug=;
	h=Date:To:From:Subject:Message-Id; b=l9Enjev8P/5abt8FPTRZUZVYxzCi1kUrc4d9yQlca9TYO23YMJ5w3bJ9KpSiHH4lzZy5KDa4uNL4L7w3z9d7J+/mHiBhl3nXNKjEzioB8HG4hc8DfjPnMplUwA4FwDNjJQRMsSgUEOTvQ2QdxORPaFzkU5zUdpBZvvDyPr/mgiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QvCy5ieK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QvCy5ieK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B462C113D0;
	Tue, 23 Dec 2025 19:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766517865;
	bh=SPjPC/mWKoTojKaQS+cQj6PyEjMkgSMoCMqfImYQhug=;
	h=Date:To:From:Subject:From;
	b=QvCy5ieKJF7PkJYJdxU+mnICAuRdttVr0rQzapCw6wx+rehm+pTQkC3dwFiurrGWW
	 EH22dWIKk+u6QToMw3Kqpq/FC80A7+LBVYWLvnZxhIImBb5UB95OHdnsMOopA/8fp9
	 9dmtJVM9RGVmlpLUAoHOQv0SNMtq7yLqp1Vw71SY=
Date: Tue, 23 Dec 2025 11:24:25 -0800
To: mm-commits@vger.kernel.org,sparse@chrisli.org,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] sparse-update-maintainers-info.patch removed from -mm tree
Message-Id: <20251223192425.9B462C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sparse: update MAINTAINERS info
has been removed from the -mm tree.  Its filename was
     sparse-update-maintainers-info.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: sparse: update MAINTAINERS info
Date: Wed, 17 Dec 2025 22:09:21 -0800

Chris Li is back as sparse maintainer.

See https://git.kernel.org/pub/scm/devel/sparse/sparse.git/commit/?id=67f0a03cee4637e495151c48a02be642a158cbbb

Link: https://lkml.kernel.org/r/20251218060921.995516-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Christopher Li <sparse@chrisli.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~sparse-update-maintainers-info
+++ a/MAINTAINERS
@@ -24574,7 +24574,7 @@ F:	drivers/tty/vcc.c
 F:	include/linux/sunserialcore.h
 
 SPARSE CHECKER
-M:	"Luc Van Oostenryck" <luc.vanoostenryck@gmail.com>
+M:	Chris Li <sparse@chrisli.org>
 L:	linux-sparse@vger.kernel.org
 S:	Maintained
 W:	https://sparse.docs.kernel.org/
_

Patches currently in -mm which might be from rdunlap@infradead.org are

kernelh-drop-hexh-and-update-all-hexh-users.patch
kfifo-fix-kmalloc_array_node-argument-order.patch

