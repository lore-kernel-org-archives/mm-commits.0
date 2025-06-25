Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44661EA7EC
	for <mm-commits@vger.kernel.org>; Wed, 25 Jun 2025 22:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750892152; cv=none; b=T5vwd8XnfswPLFxLU8+AB315hZkqug+DTZ7Lv/VD3ckHgjg+NPj3RdptkCM5Gv88tJyR1kgawp7EkytQf6Li0ZTOZu1F/XvTrRjCbmwx27iXzS2YcjSDNqdRqTPAKZfjr5JsNkLtZtcdtbsLXaxjNDzFfDiO44jF0GjSevyyTx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750892152; c=relaxed/simple;
	bh=XIQd9r1wuD2PPsh+Yipj5DooqAbjZ+sh8bcHyP8wF68=;
	h=Date:To:From:Subject:Message-Id; b=Pi4mF40pEFw37q581ymshgrMpaL+Nn18rcchzNlcxMqR9Nj1acEBpPmFYpIUs2lwsQoAOebQIDq9Q8vd31Q51DZid1jSQ0cBkUonao62bW3fohOtPz3K1npMoIGDoIAVyzdyFNJ5nDJjEt5tzntzKhyZ31keuSpfAsbhvYJYcIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wsWVOVB0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wsWVOVB0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B54C4CEEA;
	Wed, 25 Jun 2025 22:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750892152;
	bh=XIQd9r1wuD2PPsh+Yipj5DooqAbjZ+sh8bcHyP8wF68=;
	h=Date:To:From:Subject:From;
	b=wsWVOVB0SbPwsc4jMmO6jrzBN41HvFfDwKeR2C/k83YjnwUw1IB+KFIFGzkMragTH
	 7LbBIX4fh1SOpzzm1ANr6pDnDHhbFkuwfizJjfcXkNOgju5LaXZWuEA3Z6gXFkCu/C
	 poM/12PNaTKjvmYaofmMOm0+FS0prRCuY/LRtqP8=
Date: Wed, 25 Jun 2025 15:55:51 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-tree-entry-to-mm-init-block.patch removed from -mm tree
Message-Id: <20250625225552.80B54C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add tree entry to mm init block
has been removed from the -mm tree.  Its filename was
     maintainers-add-tree-entry-to-mm-init-block.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: MAINTAINERS: add tree entry to mm init block
Date: Wed, 18 Jun 2025 19:47:52 +0300

Link: https://lkml.kernel.org/r/aFLubPfiO5hqfhCe@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-add-tree-entry-to-mm-init-block
+++ a/MAINTAINERS
@@ -15676,6 +15676,8 @@ MEMBLOCK AND MEMORY MANAGEMENT INITIALIZ
 M:	Mike Rapoport <rppt@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git for-next
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git fixes
 F:	Documentation/core-api/boot-time-mm.rst
 F:	Documentation/core-api/kho/bindings/memblock/*
 F:	include/linux/memblock.h
_

Patches currently in -mm which might be from rppt@kernel.org are


