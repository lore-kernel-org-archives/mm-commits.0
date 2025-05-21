Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C60E32C85
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 05:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747806500; cv=none; b=DjYataIdYLs/Ya/PUYl8VplTtRu10dxb8U2eUsd5p8nErjCbOIV9tp+EZeE07/23BRJ35jhYB9ptrhld0orJCtLg6+ioCM48bAzPmd8LL9cZv4P9JqoTqu6Zg2PIcLQZYuUqvITuQ7Xli4sp/dS+WeEVbjgvdGU7aH8eHDFXJSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747806500; c=relaxed/simple;
	bh=AuP0K6aGKjxIcGWea9Ziwmea4vAElgAey/c2uHwO05Q=;
	h=Date:To:From:Subject:Message-Id; b=drT2J4F4Vi/XRYCcyRInv1HOShP+djoSD6RhrQJIS/NAgxRFXZlIraz7ypRJYIRaq3HuT0bHdj0BsjEb+x8/gpjqCQr2AES+HfnKFm051pnu4qAikrVFkRycyxKNII4BCTGWM9pg28XNXqop7SSm3q18TOrmT3RZzMnICyas/wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RNoqPuGJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RNoqPuGJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2BC7C4CEED;
	Wed, 21 May 2025 05:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747806499;
	bh=AuP0K6aGKjxIcGWea9Ziwmea4vAElgAey/c2uHwO05Q=;
	h=Date:To:From:Subject:From;
	b=RNoqPuGJBByHX0YQNADjsSiLGI5tEMSeUcJsA2NG0FeXHAMCAg37PxQGIw0hvIg17
	 NrXRMjY6vlytKHyN2Ho/U7rU8fiNfbaM9VnB/BvM+e89yulxK24jiYTNhF0os9Zv1E
	 nFe+U/8BefO0AKfi7JjziEKlYVGHbpkdt4HGsjn0=
Date: Tue, 20 May 2025 22:48:19 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@redhat.com,byungchul@sk.com,apopple@nvidia.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] maintainers-add-mm-memory-policy-section-fix.patch removed from -mm tree
Message-Id: <20250521054819.A2BC7C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: add Ying as reviewer
has been removed from the -mm tree.  Its filename was
     maintainers-add-mm-memory-policy-section-fix.patch

This patch was dropped because it was folded into maintainers-add-mm-memory-policy-section.patch

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: add Ying as reviewer
Date: Thu, 15 May 2025 20:23:27 +0100

Link: https://lkml.kernel.org/r/ed6f0fc2-5608-4eea-b1be-07e3e19be263@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Huang Ying <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-mm-memory-policy-section-fix
+++ a/MAINTAINERS
@@ -15586,6 +15586,7 @@ R:	Joshua Hahn <joshua.hahnjy@gmail.com>
 R:	Rakie Kim <rakie.kim@sk.com>
 R:	Byungchul Park <byungchul@sk.com>
 R:	Gregory Price <gourry@gourry.net>
+R:	Ying Huang <ying.huang@linux.alibaba.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-update-page-allocator-section.patch
maintainers-add-mm-reclaim-section.patch
maintainers-add-mm-ksm-section.patch
maintainers-add-mm-memory-policy-section.patch
maintainers-add-kernel-forkc-to-relevant-sections.patch
mm-remove-warn_on_once-in-file_has_valid_mmap_hooks.patch
memcg-memcg_rstat_updated-re-entrant-safe-against-irqs-fix.patch

