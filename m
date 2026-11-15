Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794768644;
	b=3QmKHrVpFD19wmv7u7kqb1HfRNSxNkKD8mjNZnGxloEoWNyhdhSyRcxlB/QSsOCO2Wm5
	 akmYMlXh031d5AcBzdkfxRHER0eX84a0ifQNVs7EgTOI16jm0kzPeuz0JbF4gS4G3kIBb
	 SfFqyecwN/D3tiAS7PWUgFiwnLfNCTAUA+fQYwZoV0w9zbhBjRJp+GMKzRA1PV/GjQYti
	 0Q7MRk+8ZangY9TR10bkHQIvllqGZh+r5dv9GcRwklIldnbgmPotcweDexrzzqUx7p/b8
	 fLLUF/djZlQaeMQFkBSTJVfFiWR4Pl6zkQNVn40QwysvCWQT5c/8SXrB5nTDG/4OGTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794768644;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=MQVBHHO+pjCk2C8qwCDPOj3llycmszBnTI6gq+4iYbQ=;
	b=oh4pKQd1lVic4Qgtxw/xJznpBHHHaMYwvRdyTykunS2g/QzMeJPeK8bZr4NF1iSWSFON
	 UIdgruDcwcl/DCSVONhDV9GpguH6ouiD187MHhyEe0I/nIogARK/7EOtKUxkvQJc6/d/E
	 4xcduvaidLACIcDBALpssixM9v9zf9WS2v1ifHKuVdWT6DaPqeZErHdfjCkmVmGk2aFAa
	 MckFjYwmKYBkE8qo7wBHNehdpBhw1hVg4kCGkvaCzU0QuVB2hr08SYMNKeNBKORuDmuxX
	 eLiRomGbSWCu7NFgM9ED05iAXRwHQDHnlhGdpFY677SIPhRL89+IEfXNv4k/vqX4LUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="Wt/dtuJW";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C93606A32C
	for <mm-commits@vger.kernel.org>; Sun, 15 Nov 2026 18:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Wt/dtuJW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365521F000C4;
	Sun, 15 Nov 2026 18:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794768644;
	bh=MQVBHHO+pjCk2C8qwCDPOj3llycmszBnTI6gq+4iYbQ=;
	h=Date:To:From:Subject;
	b=Wt/dtuJWO2mzuXOKB4/MjTd1R0YZrrrLHl886cFconPJQXzKANQ69V/yF89KLirRU
	 7GpErIX8/HX/evlHJnikyA9Ix+180KrNh1dooNu83dPhax8zx8KWdvz+1vwql0hjJb
	 BKhoxg4BguoFqM+w9oD2ObDpxy97QSFkpis8/CEs=
Date: Sun, 15 Nov 2026 10:50:43 -0800
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,
	sj@kernel.org,shakeel.butt@linux.dev,ridong.chen@linux.dev,
	qi.zheng@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,
	lianux.mm@gmail.com,lance.yang@linux.dev,kasong@tencent.com,
	hannes@cmpxchg.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,
	baohua@kernel.org,axelrasmussen@google.com,david@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-remove-myself-from-memory-management-reclaim.patch added to mm-hotfixes-unstable branch
Message-Id: <20261115185044.365521F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: MAINTAINERS: remove myself from MEMORY MANAGEMENT - RECLAIM
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-remove-myself-from-memory-management-reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-remove-myself-from-memory-management-reclaim.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: MAINTAINERS: remove myself from MEMORY MANAGEMENT - RECLAIM
Date: Mon, 09 Nov 2026 19:31:54 +0100

I don't really get to look at most reclaim related stuff.  For things that
are actually relevant for me, I'm sure people will CC me.

So remove myself from the MEMORY MANAGEMENT - RECLAIM section for now to
have a bit less noise in my inbox.

Link: https://lore.kernel.org/20261109-maintainers_mglru-v1-2-c25e6de60bcc@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: SJ Park <sj@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Ridong Chen <ridong.chen@linux.dev>
Cc: Lian Wang <lianux.mm@gmail.com>

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

--- a/MAINTAINERS~maintainers-remove-myself-from-memory-management-reclaim
+++ a/MAINTAINERS
@@ -17805,7 +17805,6 @@ F:	tools/mm/page_owner_sort.c
 MEMORY MANAGEMENT - RECLAIM
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Johannes Weiner <hannes@cmpxchg.org>
-R:	David Hildenbrand <david@kernel.org>
 R:	Michal Hocko <mhocko@kernel.org>
 R:	Qi Zheng <qi.zheng@linux.dev>
 R:	Shakeel Butt <shakeel.butt@linux.dev>
_

Patches currently in -mm which might be from david@kernel.org are

mm-huge_memory-flush-dirty-file-pmds-before-removing-rmap.patch
maintainers-memory-management-mglru-multi-gen-lru-update.patch
maintainers-remove-myself-from-memory-management-reclaim.patch
mm-mprotect-dont-skip-uffd-marker-install-when-racing-with-pte-table-reclaim.patch
mm-khugepaged-free-unused-page-table-when-setting-a-huge-pmd-fails.patch

