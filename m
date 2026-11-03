Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672170;
	b=nEBBP6C1Bl+iOcO0CGoPFjVTo0CLkxYFU3hTZKoNovyqgZWy9AAxjeovIlo67rGW4g9m
	 iyiqMK54krXNW6FMozNa3cdSAtVJuiRsGhd9+Gz2ts+aps81rWZ6TpPXee0WIAhWxsbAv
	 qRoxi7csWvLsKAUOLqYfCJt/ur8GaKa3iG4tDkDZAyqAySOsNTt+xXZXn/ItKf2yFa8FM
	 XkhcGpR2KsFl61JQ69VrlIXOr00gErYPl7KX0U4aS3Zjg2jpHqEa1uARXVtZqKR/QP0YK
	 +vxNGeSqY35zUkKspPRN5mDeoJwQafJos6WOUyStyX1t3uNva/fgnU3YoaQwMXqRpFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672170;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=iHfp48RnlIOJ5SownnjQUDrQIv8dC+qwxdlHyXV06SE=;
	b=r/LENnHTSkaGujiHd9VEmRPuR+7G09CcTTvFqTmKegxzESaISltptlNYiBTudheLGzgo
	 Bw3CVxw5DzPAlT6w/eUTxrkOfNNnI4VXezhGdJ3up2yT84QL7AfcCqtWwd6H1EO2+MmVe
	 CqMdSeOJ7tOJ36WwAxieVnzj7zn2SAx1YC8sYAM4kb6wEnSHWGMqOjdjZ9AkHmOzc6hfC
	 rP+VTb8MtLHdd21Iyof44W1oUvtCU8vuVxhPU7fSdyLtf+bbvxuOFyzgUtPA+SeL1+OvB
	 txXGf11Kb64GvSd3CwqQYiDuXGRt0V97qvqWWGZcDfP/9y4lHtA/asDFFAp1pCEYykA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pUwgiMDD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7C2606A32C
	for <mm-commits@vger.kernel.org>; Tue,  3 Nov 2026 02:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pUwgiMDD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390461F000C1;
	Tue,  3 Nov 2026 02:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672170;
	bh=iHfp48RnlIOJ5SownnjQUDrQIv8dC+qwxdlHyXV06SE=;
	h=Date:To:From:Subject;
	b=pUwgiMDDqg4vECJgZJ2jEyWf/wF6HRyeLhsn+XN8Dps93Uca+/l2eX8qsPvxsz9JS
	 8ydDKnrFjwADT4nR+2AVYvxd1MiG2CuaMVcLW/TplNDzXOMd7VINz6C63A+fimA8x3
	 CtnbLOmSMQz7sv/Gw8E+UAYKkQ6Gs7MmrLcxtTkU=
Date: Mon, 02 Nov 2026 18:16:09 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,surenb@google.com,sj@kernel.org,
	rppt@kernel.org,roman.gushchin@linux.dev,rientjes@google.com,
	pfalcato@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,
	jannh@google.com,harry@kernel.org,hao.li@linux.dev,hannes@cmpxchg.org,
	gourry@gourry.net,david@kernel.org,cl@gentwo.org,brendan.jackman@linux.dev,
	vbabka@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-johannes-as-the-page-allocator-co-maintainer.patch removed from -mm tree
Message-Id: <20261103021610.390461F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: MAINTAINERS: add Johannes as the page allocator co-maintainer
has been removed from the -mm tree.  Its filename was
     maintainers-add-johannes-as-the-page-allocator-co-maintainer.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: MAINTAINERS: add Johannes as the page allocator co-maintainer
Date: Sun, 01 Nov 2026 17:34:48 +0100

Patch series "MAINTAINERS updates for page and slab allocators".

Following David's updates [1], perform similar updates for page and slab
allocators to indicate the MM process transition for these
subcomponents. Importantly, add Johannes as a page allocator
co-maintainer.


This patch (of 2):

Johannes is a long-time expert and reviewer for the page allocator and
has agreed to step up to a co-maintainer role, so do that. Thanks!

Additionally, page allocator is joining the MM transition, following the
MM core updates from David [2].

Patches will be collected in the mm/page_alloc git tree and integrated
via the mm/linux integration tree. To signify the change from Andrew's
mm tree, remove Andrew as M: - get_maintainers will continue CCing him
on most patches via the catch-all MM entry. David prefers not being
added for mail volume reasons.

Link: https://lore.kernel.org/20261101-maint-page_alloc-update-v1-0-27e8c246b13d@kernel.org
Link: https://lore.kernel.org/20261101-maint-page_alloc-update-v1-1-27e8c246b13d@kernel.org
Link: https://lore.kernel.org/all/20261030-maintainers-v1-0-97278f8a5f54@kernel.org/ [1]
Link: https://lore.kernel.org/all/20261030-maintainers-v1-7-97278f8a5f54@kernel.org/ [2]
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Harry Yoo (Meta) <harry@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: SJ Park <sj@kernel.org>
Cc: Hao Li <hao.li@linux.dev>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/MAINTAINERS~maintainers-add-johannes-as-the-page-allocator-co-maintainer
+++ a/MAINTAINERS
@@ -17758,15 +17758,15 @@ F:	include/uapi/linux/oom.h
 F:	mm/oom_kill.c
 
 MEMORY MANAGEMENT - PAGE ALLOCATOR
-M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Vlastimil Babka <vbabka@kernel.org>
+M:	Johannes Weiner <hannes@cmpxchg.org>
 R:	Suren Baghdasaryan <surenb@google.com>
 R:	Michal Hocko <mhocko@suse.com>
 R:	Brendan Jackman <brendan.jackman@linux.dev>
-R:	Johannes Weiner <hannes@cmpxchg.org>
 R:	Zi Yan <ziy@nvidia.com>
 L:	linux-mm@kvack.org
 S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/page_alloc.git page_alloc/for-next
 F:	include/linux/compaction.h
 F:	include/linux/gfp.h
 F:	include/linux/page-isolation.h
_

Patches currently in -mm which might be from vbabka@kernel.org are


