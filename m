Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1B647A6B
	for <mm-commits@vger.kernel.org>; Thu,  6 Nov 2025 00:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762388424; cv=none; b=eJtqUayAajcP+9qUF963IIxkjasBkGCoVbSsWctcLWcv60yGkXdQoigqOuWQLUqWWKaJ6/z6ddSsBmYMJYssy7EsS9dwftZtxGp2Fbg2vKD6WrVkQAWWX9WnYualEc17qC8KxOWMekGeWugBqCKoW57NAEO8x7sKP0ppCd5TrQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762388424; c=relaxed/simple;
	bh=qIss5IAbt/To1AAkxgRb5eprMVXMWeBe07YY3mgJl0Y=;
	h=Date:To:From:Subject:Message-Id; b=RvErnvqq/KNFWCzb9ajp0j/0zN27JGwC7lOjkE1YeBTWfrOmEbd0UXdhonDf9G1WJLFEgnZnNvPHrQgrtg4+TtsqFzDr5YCnisdELibJCDkXiLYQc9eEXgl6oV6rhTInya7t36c9BTbrzQsRx7W65IEkCs4vo1ijeqY/yAWyhZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u9MvSR1d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u9MvSR1d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 175B5C4CEF5;
	Thu,  6 Nov 2025 00:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762388424;
	bh=qIss5IAbt/To1AAkxgRb5eprMVXMWeBe07YY3mgJl0Y=;
	h=Date:To:From:Subject:From;
	b=u9MvSR1dCAEoPOK0h92goeXYtN0gR1fTURmaOZbDQSebQrlA12G9FGVQl0QY3tKyh
	 tjlMo5PJmG+35BldJadu4wPTniNSbFYphV8hJlUUS4Hv2zZqcVDPl0IyOZY+XFgZh+
	 3qG//hxTKuzNBa/WmHcqNDIM34PIDRhk8UD6/PB0=
Date: Wed, 05 Nov 2025 16:20:23 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,bhe@redhat.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-myself-as-a-reviewer-for-kho.patch added to mm-nonmm-unstable branch
Message-Id: <20251106002024.175B5C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add Pratyush as a reviewer for KHO
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     maintainers-add-myself-as-a-reviewer-for-kho.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-myself-as-a-reviewer-for-kho.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Pratyush Yadav <pratyush@kernel.org>
Subject: MAINTAINERS: add Pratyush as a reviewer for KHO
Date: Wed, 5 Nov 2025 11:20:19 +0100

I have been reviewing most patches for KHO already, and it is easier to
spot them if I am directly in Cc.

Link: https://lkml.kernel.org/r/20251105102022.18798-1-pratyush@kernel.org
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-myself-as-a-reviewer-for-kho
+++ a/MAINTAINERS
@@ -13789,6 +13789,7 @@ KEXEC HANDOVER (KHO)
 M:	Alexander Graf <graf@amazon.com>
 M:	Mike Rapoport <rppt@kernel.org>
 M:	Pasha Tatashin <pasha.tatashin@soleen.com>
+R:	Pratyush Yadav <pratyush@kernel.org>
 L:	kexec@lists.infradead.org
 L:	linux-mm@kvack.org
 S:	Maintained
_

Patches currently in -mm which might be from pratyush@kernel.org are

kho-fix-out-of-bounds-access-of-vmalloc-chunk.patch
kho-fix-unpreservation-of-higher-order-vmalloc-preservations.patch
kho-warn-and-exit-when-unpreserved-page-wasnt-preserved.patch
maintainers-add-myself-as-a-reviewer-for-kho.patch

